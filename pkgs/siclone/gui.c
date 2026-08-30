#include "read.h"
#include <gio/gio.h>
#include <gtk-layer-shell.h>
#include <gtk/gtk.h>
#include <libayatana-appindicator/app-indicator.h>
#include <libdbusmenu-gtk/menu.h>
#include <stdlib.h>

typedef struct {
	GtkWidget *window;
	GtkWidget *label_top;
	GtkWidget *tray_box;
	GtkWidget *label_bottom;
	AppIndicator *indicator;
	gboolean is_visible;
	ConfigSettings settings;
} AppState;

static AppState app_state;

/* Minimal StatusNotifierWatcher XML Introspection */
static const gchar watcher_introspection_xml[] =
	"<node>"
	"  <interface name='org.kde.StatusNotifierWatcher'>"
	"    <method name='RegisterStatusNotifierItem'>"
	"      <arg type='s' name='service' direction='in'/>"
	"    </method>"
	"    <method name='RegisterStatusNotifierHost'>"
	"      <arg type='s' name='service' direction='in'/>"
	"    </method>"
	"    <property type='as' name='RegisteredStatusNotifierItems' "
	"access='read'/>"
	"    <property type='b' name='IsStatusNotifierHostRegistered' "
	"access='read'/>"
	"    <property type='i' name='ProtocolVersion' access='read'/>"
	"    <signal name='StatusNotifierItemRegistered'>"
	"      <arg type='s' name='service'/>"
	"    </signal>"
	"  </interface>"
	"</node>";

typedef struct {
	char *service;
	char *path;
	char *menu_path;
	GtkWidget *button;
	GDBusProxy *proxy;
	GtkWidget *menu;
} TrayItem;

typedef struct {
	char *service;
	char *path;
} TrayRegistration;

static GList *tray_items = NULL;
static GDBusNodeInfo *introspection_data = NULL;
static void update_x11_window_position(AppState *state);
static void apply_user_styles(const ConfigSettings *s);

static void on_tray_icon_clicked(GtkWidget *widget, gpointer user_data) {
	(void)widget;
	TrayItem *item = (TrayItem *)user_data;
	if (!item || !item->proxy)
		return;

	g_dbus_proxy_call(item->proxy, "Activate", g_variant_new("(ii)", 0, 0),
					  G_DBUS_CALL_FLAGS_NONE, -1, NULL, NULL, NULL);
}

static void log_sender_info(GDBusConnection *conn, const gchar *sender) {
	GError *err = NULL;
	GVariant *reply = g_dbus_connection_call_sync(
		conn, "org.freedesktop.DBus", "/org/freedesktop/DBus",
		"org.freedesktop.DBus", "GetConnectionUnixProcessID",
		g_variant_new("(s)", sender), G_VARIANT_TYPE("(u)"),
		G_DBUS_CALL_FLAGS_NONE, -1, NULL, &err);

	if (reply) {
		guint32 pid = 0;
		g_variant_get(reply, "(u)", &pid);
		g_variant_unref(reply);

		char cmdpath[64];
		char comm[256] = {0};
		snprintf(cmdpath, sizeof(cmdpath), "/proc/%u/comm", pid);
		FILE *f = fopen(cmdpath, "r");
		if (f) {
			if (fgets(comm, sizeof(comm), f)) {
				comm[strcspn(comm, "\n")] = 0;
			}
			fclose(f);
		}
		g_print("[Tray Discovery] Sender: %s | PID: %u | Process: %s\n", sender,
				pid, comm);
	} else {
		if (err)
			g_error_free(err);
	}
}

static GdkPixbuf *decode_sni_pixmap(GVariant *pixmap_var) {
	if (!pixmap_var)
		return NULL;

	GVariantIter iter;
	g_variant_iter_init(&iter, pixmap_var);
	gint width = 0, height = 0;
	GVariant *byte_array = NULL;
	GdkPixbuf *best_pixbuf = NULL;
	gint max_size = 0;

	/* Find largest available pixmap */
	while (
		g_variant_iter_loop(&iter, "(ii@ay)", &width, &height, &byte_array)) {
		if (width > max_size && width <= 48) {
			max_size = width;
			gsize data_len = 0;
			const guint8 *src = (const guint8 *)g_variant_get_data(byte_array);
			data_len = g_variant_get_size(byte_array);

			if (src && data_len >= (gsize)(width * height * 4)) {
				/* SNI pixmaps are ARGB32 big-endian; GdkPixbuf expects RGBA */
				guint8 *rgba_data = g_malloc(width * height * 4);
				for (int i = 0; i < width * height; i++) {
					guint8 a = src[i * 4 + 0];
					guint8 r = src[i * 4 + 1];
					guint8 g = src[i * 4 + 2];
					guint8 b = src[i * 4 + 3];

					rgba_data[i * 4 + 0] = r;
					rgba_data[i * 4 + 1] = g;
					rgba_data[i * 4 + 2] = b;
					rgba_data[i * 4 + 3] = a;
				}
				if (best_pixbuf)
					g_object_unref(best_pixbuf);
				best_pixbuf = gdk_pixbuf_new_from_data(
					rgba_data, GDK_COLORSPACE_RGB, TRUE, 8, width, height,
					width * 4, (GdkPixbufDestroyNotify)g_free, NULL);
			}
		}
	}
	return best_pixbuf;
}

static void update_tray_item_icon(TrayItem *item) {
	if (!item || !item->proxy || !item->button)
		return;

	int size =
		app_state.settings.icon_size > 0 ? app_state.settings.icon_size : 16;

	GVariant *icon_name_var =
		g_dbus_proxy_get_cached_property(item->proxy, "IconName");
	const char *icon_name =
		icon_name_var ? g_variant_get_string(icon_name_var, NULL) : NULL;

	GVariant *theme_path_var =
		g_dbus_proxy_get_cached_property(item->proxy, "IconThemePath");
	const char *theme_path =
		theme_path_var ? g_variant_get_string(theme_path_var, NULL) : NULL;
	if (theme_path && strlen(theme_path) > 0) {
		gtk_icon_theme_append_search_path(gtk_icon_theme_get_default(),
										  theme_path);
	}

	GtkWidget *img = NULL;

	/* 1. File path or named theme icon */
	if (icon_name && strlen(icon_name) > 0) {
		if (g_file_test(icon_name, G_FILE_TEST_EXISTS)) {
			GdkPixbuf *pb = gdk_pixbuf_new_from_file_at_scale(icon_name, size,
															  size, TRUE, NULL);
			if (pb) {
				img = gtk_image_new_from_pixbuf(pb);
				g_object_unref(pb);
			}
		} else if (gtk_icon_theme_has_icon(gtk_icon_theme_get_default(),
										   icon_name)) {
			GdkPixbuf *pb = gtk_icon_theme_load_icon(
				gtk_icon_theme_get_default(), icon_name, size,
				GTK_ICON_LOOKUP_FORCE_SIZE, NULL);
			if (pb) {
				img = gtk_image_new_from_pixbuf(pb);
				g_object_unref(pb);
			}
		}
	}

	/* 2. Raw SNI ARGB Pixmap */
	if (!img) {
		GVariant *pixmap_var =
			g_dbus_proxy_get_cached_property(item->proxy, "IconPixmap");
		if (pixmap_var) {
			GdkPixbuf *pb = decode_sni_pixmap(pixmap_var);
			if (pb) {
				GdkPixbuf *scaled = gdk_pixbuf_scale_simple(
					pb, size, size, GDK_INTERP_BILINEAR);
				img = gtk_image_new_from_pixbuf(scaled);
				g_object_unref(pb);
				g_object_unref(scaled);
			}
			g_variant_unref(pixmap_var);
		}
	}

	/* 3. Fallback to app ID */
	if (!img) {
		GVariant *id_var = g_dbus_proxy_get_cached_property(item->proxy, "Id");
		const char *app_id = id_var ? g_variant_get_string(id_var, NULL) : NULL;
		if (app_id &&
			gtk_icon_theme_has_icon(gtk_icon_theme_get_default(), app_id)) {
			GdkPixbuf *pb = gtk_icon_theme_load_icon(
				gtk_icon_theme_get_default(), app_id, size,
				GTK_ICON_LOOKUP_FORCE_SIZE, NULL);
			if (pb) {
				img = gtk_image_new_from_pixbuf(pb);
				g_object_unref(pb);
			}
		}
		if (id_var)
			g_variant_unref(id_var);
	}

	/* 4. Generic fallback */
	if (!img) {
		GdkPixbuf *pb = gtk_icon_theme_load_icon(
			gtk_icon_theme_get_default(), "application-x-executable", size,
			GTK_ICON_LOOKUP_FORCE_SIZE, NULL);
		if (pb) {
			img = gtk_image_new_from_pixbuf(pb);
			g_object_unref(pb);
		}
	}

	if (icon_name_var)
		g_variant_unref(icon_name_var);
	if (theme_path_var)
		g_variant_unref(theme_path_var);

	if (img) {
		gtk_button_set_image(GTK_BUTTON(item->button), img);
		gtk_widget_show_all(item->button);
	}
}

static gboolean on_tray_button_press(GtkWidget *widget, GdkEventButton *event,
									 gpointer user_data) {
	TrayItem *item = (TrayItem *)user_data;
	if (!item || !item->proxy)
		return FALSE;

	gint root_x = (gint)event->x_root;
	gint root_y = (gint)event->y_root;

	if (event->button == GDK_BUTTON_PRIMARY) {
		/* Left-click: Activate */
		g_dbus_proxy_call(item->proxy, "Activate",
						  g_variant_new("(ii)", root_x, root_y),
						  G_DBUS_CALL_FLAGS_NONE, -1, NULL, NULL, NULL);
		return TRUE;
	} else if (event->button == GDK_BUTTON_SECONDARY) {
		/* Right-click: Prefer exported DBusMenu if available */
		if (item->menu) {
			gtk_menu_popup_at_widget(
				GTK_MENU(item->menu), widget, GDK_GRAVITY_SOUTH_WEST,
				GDK_GRAVITY_NORTH_WEST, (const GdkEvent *)event);
			return TRUE;
		}

		/* Fallback to legacy ContextMenu call */
		g_dbus_proxy_call(item->proxy, "ContextMenu",
						  g_variant_new("(ii)", root_x, root_y),
						  G_DBUS_CALL_FLAGS_NONE, -1, NULL, NULL, NULL);
		return TRUE;
	}

	return FALSE;
}

static gboolean on_item_signal_idle(gpointer user_data) {
	TrayItem *item = (TrayItem *)user_data;
	update_tray_item_icon(item);
	return G_SOURCE_REMOVE;
}

static void on_item_signal(GDBusConnection *connection,
						   const gchar *sender_name, const gchar *object_path,
						   const gchar *interface_name,
						   const gchar *signal_name, GVariant *parameters,
						   gpointer user_data) {
	(void)connection;
	(void)sender_name;
	(void)object_path;
	(void)interface_name;
	(void)parameters;

	TrayItem *item = (TrayItem *)user_data;
	if (g_strcmp0(signal_name, "NewIcon") == 0 ||
		g_strcmp0(signal_name, "NewIconThemePath") == 0 ||
		g_strcmp0(signal_name, "NewAttentionIcon") == 0) {
		g_idle_add(on_item_signal_idle, item);
	}
}

static void create_tray_widget(const char *service, const char *path) {
	for (GList *l = tray_items; l != NULL; l = l->next) {
		TrayItem *it = (TrayItem *)l->data;
		if (g_strcmp0(it->service, service) == 0 &&
			g_strcmp0(it->path, path) == 0) {
			return;
		}
	}

	GError *error = NULL;
	GDBusProxy *proxy = g_dbus_proxy_new_for_bus_sync(
		G_BUS_TYPE_SESSION, G_DBUS_PROXY_FLAGS_NONE, NULL, service, path,
		"org.kde.StatusNotifierItem", NULL, &error);

	if (!proxy) {
		if (error)
			g_error_free(error);
		return;
	}

	TrayItem *item = g_new0(TrayItem, 1);
	item->service = g_strdup(service);
	item->path = g_strdup(path);
	item->proxy = proxy;

	/* Check for exported com.canonical.dbusmenu path */
	GVariant *menu_var = g_dbus_proxy_get_cached_property(proxy, "Menu");
	if (menu_var) {
		const gchar *mpath = g_variant_get_string(menu_var, NULL);
		if (mpath && strlen(mpath) > 0 &&
			g_strcmp0(mpath, "/NO_DBUSMENU") != 0) {
			item->menu_path = g_strdup(mpath);
			item->menu = GTK_WIDGET(
				dbusmenu_gtkmenu_new((char *)service, (char *)mpath));
		}
		g_variant_unref(menu_var);
	}

	item->button = gtk_button_new();
	gtk_button_set_relief(GTK_BUTTON(item->button), GTK_RELIEF_NONE);

	gtk_widget_add_events(item->button, GDK_BUTTON_PRESS_MASK);
	g_signal_connect(item->button, "button-press-event",
					 G_CALLBACK(on_tray_button_press), item);

	gtk_box_pack_start(GTK_BOX(app_state.tray_box), item->button, FALSE, FALSE,
					   0);

	/* Set initial icon */
	update_tray_item_icon(item);

	/* Subscribe to instant icon updates from this client */
	GDBusConnection *conn = g_dbus_proxy_get_connection(proxy);
	g_dbus_connection_signal_subscribe(
		conn, service, "org.kde.StatusNotifierItem", NULL, path, NULL,
		G_DBUS_SIGNAL_FLAGS_NONE, on_item_signal, item, NULL);

	tray_items = g_list_append(tray_items, item);
}

static gboolean create_tray_widget_idle(gpointer user_data) {
	TrayRegistration *reg = (TrayRegistration *)user_data;
	create_tray_widget(reg->service, reg->path);
	g_free(reg->service);
	g_free(reg->path);
	g_free(reg);
	return G_SOURCE_REMOVE;
}

/* Handle incoming method calls to our Watcher */
static void handle_method_call(GDBusConnection *connection, const gchar *sender,
							   const gchar *object_path,
							   const gchar *interface_name,
							   const gchar *method_name, GVariant *parameters,
							   GDBusMethodInvocation *invocation,
							   gpointer user_data) {
	(void)connection;
	(void)object_path;
	(void)interface_name;
	(void)user_data;

	if (g_strcmp0(method_name, "RegisterStatusNotifierItem") == 0) {
		/* log_sender_info(connection, sender); */

		const gchar *service_or_path = NULL;
		g_variant_get(parameters, "(&s)", &service_or_path);

		/* Prevent Siclone from hosting its own toggle indicator */
		if (service_or_path &&
			(strstr(service_or_path, "siclone-controller") ||
			 strstr(service_or_path, "siclone_controller"))) {
			g_dbus_method_invocation_return_value(invocation, NULL);
			return;
		}
		char *service = NULL;
		char *path = NULL;

		if (service_or_path[0] == '/') {
			service = g_strdup(sender);
			path = g_strdup(service_or_path);
		} else {
			char *slash = strchr(service_or_path, '/');
			if (slash) {
				service = g_strndup(service_or_path, slash - service_or_path);
				path = g_strdup(slash);
			} else {
				service = g_strdup(service_or_path);
				path = g_strdup("/StatusNotifierItem");
			}
		}

		/* Emit signal required by StatusNotifierWatcher spec */
		g_dbus_connection_emit_signal(
			connection, NULL, "/StatusNotifierWatcher",
			"org.kde.StatusNotifierWatcher", "StatusNotifierItemRegistered",
			g_variant_new("(s)", service_or_path), NULL);

		/* Dispatch UI creation to the GTK main loop thread */
		TrayRegistration *reg = g_new0(TrayRegistration, 1);
		reg->service = g_strdup(service);
		reg->path = g_strdup(path);
		g_idle_add(create_tray_widget_idle, reg);

		g_free(service);
		g_free(path);

		g_dbus_method_invocation_return_value(invocation, NULL);
	} else if (g_strcmp0(method_name, "RegisterStatusNotifierHost") == 0) {
		g_dbus_method_invocation_return_value(invocation, NULL);
	}
}

static GVariant *handle_get_property(GDBusConnection *connection,
									 const gchar *sender,
									 const gchar *object_path,
									 const gchar *interface_name,
									 const gchar *property_name, GError **error,
									 gpointer user_data) {
	(void)connection;
	(void)sender;
	(void)object_path;
	(void)interface_name;
	(void)error;
	(void)user_data;

	if (g_strcmp0(property_name, "IsStatusNotifierHostRegistered") == 0) {
		return g_variant_new_boolean(TRUE);
	} else if (g_strcmp0(property_name, "ProtocolVersion") == 0) {
		return g_variant_new_int32(0);
	} else if (g_strcmp0(property_name, "RegisteredStatusNotifierItems") == 0) {
		GVariantBuilder builder;
		g_variant_builder_init(&builder, G_VARIANT_TYPE("as"));
		for (GList *l = tray_items; l != NULL; l = l->next) {
			TrayItem *it = (TrayItem *)l->data;
			char *full = g_strdup_printf("%s%s", it->service, it->path);
			g_variant_builder_add(&builder, "s", full);
			g_free(full);
		}
		return g_variant_builder_end(&builder);
	}
	return NULL;
}

static const GDBusInterfaceVTable watcher_vtable = {handle_method_call,
													handle_get_property, NULL};

static void on_bus_acquired(GDBusConnection *connection, const gchar *name,
							gpointer user_data) {
	(void)name;
	(void)user_data;

	introspection_data =
		g_dbus_node_info_new_for_xml(watcher_introspection_xml, NULL);
	g_dbus_connection_register_object(connection, "/StatusNotifierWatcher",
									  introspection_data->interfaces[0],
									  &watcher_vtable, NULL, NULL, NULL);

	/* Broadcast to all running apps that a Watcher/Host is ready */
	g_dbus_connection_emit_signal(connection, NULL, "/StatusNotifierWatcher",
								  "org.kde.StatusNotifierWatcher",
								  "StatusNotifierHostRegistered", NULL, NULL);
}

static void init_tray_host(void) {
	g_bus_own_name(G_BUS_TYPE_SESSION, "org.kde.StatusNotifierWatcher",
				   G_BUS_NAME_OWNER_FLAGS_REPLACE, on_bus_acquired, NULL, NULL,
				   NULL, NULL);
}

static void on_toggle_visibility(GtkMenuItem *item, gpointer user_data) {
	(void)item;
	AppState *state = (AppState *)user_data;

	if (state->is_visible) {
		gtk_widget_hide(state->window);
		state->is_visible = FALSE;
	} else {
		gtk_widget_show_all(state->window);
		state->is_visible = TRUE;
	}
}

static void setup_siclone_tray_indicator(AppState *state) {
	if (state->indicator) {
		return;
	}

	state->indicator =
		app_indicator_new("siclone-controller", "utilities-system-monitor",
						  APP_INDICATOR_CATEGORY_APPLICATION_STATUS);
	app_indicator_set_status(state->indicator, APP_INDICATOR_STATUS_ACTIVE);
	app_indicator_set_title(state->indicator, "Siclone");

	GtkWidget *menu = gtk_menu_new();

	/* Toggle window visibility */
	GtkWidget *toggle_item = gtk_menu_item_new_with_label("Toggle Monitor");
	g_signal_connect(toggle_item, "activate", G_CALLBACK(on_toggle_visibility),
					 state);
	gtk_menu_shell_append(GTK_MENU_SHELL(menu), toggle_item);

	/* Separator */
	GtkWidget *sep = gtk_separator_menu_item_new();
	gtk_menu_shell_append(GTK_MENU_SHELL(menu), sep);

	/* Quit */
	GtkWidget *quit_item = gtk_menu_item_new_with_label("Quit");
	g_signal_connect(quit_item, "activate", G_CALLBACK(gtk_main_quit), NULL);
	gtk_menu_shell_append(GTK_MENU_SHELL(menu), quit_item);

	gtk_widget_show_all(menu);
	app_indicator_set_menu(state->indicator, GTK_MENU(menu));
}

static gboolean init_indicator_idle(gpointer user_data) {
	setup_siclone_tray_indicator((AppState *)user_data);
	return G_SOURCE_REMOVE;
}

static gboolean on_timer_tick(gpointer user_data) {
	AppState *state = (AppState *)user_data;
	char *top_text = NULL;
	char *bottom_text = NULL;
	int has_tray = 0;

	/* 1. Reload live settings and check if icon_size changed */
	int old_size = state->settings.icon_size;
	read_config_settings("~/.siclonerc", &state->settings);

	if (old_size != state->settings.icon_size) {
		for (GList *l = tray_items; l != NULL; l = l->next) {
			update_tray_item_icon((TrayItem *)l->data);
		}
	}

	apply_user_styles(&state->settings);
	evaluate_config_split("~/.siclonerc", &top_text, &bottom_text, &has_tray);

	if (top_text) {
		gtk_label_set_text(GTK_LABEL(state->label_top), top_text);
		free(top_text);
	}
	if (bottom_text) {
		gtk_label_set_text(GTK_LABEL(state->label_bottom), bottom_text);
		free(bottom_text);
	}

	if (has_tray) {
		gtk_widget_show(state->tray_box);
	} else {
		gtk_widget_hide(state->tray_box);
	}

	update_x11_window_position(state);

	return G_SOURCE_CONTINUE;
}
static int measure_text_width(GtkWidget *widget, const char *text) {
	if (!widget || !text)
		return 0;

	PangoLayout *layout = gtk_widget_create_pango_layout(widget, text);
	int width = 0;
	int height = 0;

	pango_layout_get_pixel_size(layout, &width, &height);
	g_object_unref(layout);

	return width;
}
static GtkCssProvider *global_css_provider = NULL;

static void normalize_color(const char *src, char *dst, size_t dst_size) {
	if (!src || !*src) {
		snprintf(dst, dst_size, "transparent");
		return;
	}

	/* Pass standard rgba(...) or rgb(...) calls straight through */
	if (strncmp(src, "rgb", 3) == 0) {
		strncpy(dst, src, dst_size - 1);
		dst[dst_size - 1] = '\0';
		return;
	}

	/* Strip leading '#' if present */
	const char *hex = (src[0] == '#') ? src + 1 : src;
	size_t len = strlen(hex);

	/* 8-digit hex: RRGGBBAA */
	if (len == 8) {
		unsigned int r, g, b, a;
		if (sscanf(hex, "%02x%02x%02x%02x", &r, &g, &b, &a) == 4) {
			snprintf(dst, dst_size, "rgba(%u, %u, %u, %.3f)", r, g, b,
					 a / 255.0);
			return;
		}
	}

	/* 6-digit hex: RRGGBB */
	if (len == 6) {
		snprintf(dst, dst_size, "#%s", hex);
		return;
	}

	/* Fallback */
	snprintf(dst, dst_size, "%s", src);
}

static void apply_user_styles(const ConfigSettings *s) {
	if (!global_css_provider) {
		global_css_provider = gtk_css_provider_new();
		gtk_style_context_add_provider_for_screen(
			gdk_screen_get_default(), GTK_STYLE_PROVIDER(global_css_provider),
			GTK_STYLE_PROVIDER_PRIORITY_APPLICATION);
	}

	char bg_color[64];
	char fg_color[64];
	normalize_color(s->background, bg_color, sizeof(bg_color));
	normalize_color(s->text_color, fg_color, sizeof(fg_color));

	char css_data[1024];
	snprintf(css_data, sizeof(css_data),
			 "window, #main_box {\n"
			 "	background-color: %s;\n"
			 "}\n"
			 "label, * {\n"
			 "	font-family: '%s';\n"
			 "	font-size: %dpx;\n"
			 "	color: %s;\n"
			 "}\n"
			 "button {\n"
			 "	background: transparent;\n"
			 "	border: none;\n"
			 "	padding: 2px;\n"
			 "}\n",
			 bg_color, s->font, s->font_size, fg_color);

	gtk_css_provider_load_from_data(global_css_provider, css_data, -1, NULL);
}

static int get_max_rendered_line_width(GtkWidget *label) {
	if (!label)
		return 0;
	const char *text = gtk_label_get_text(GTK_LABEL(label));
	if (!text || strlen(text) == 0)
		return 0;

	PangoLayout *layout = gtk_widget_create_pango_layout(label, text);
	if (!layout)
		return 0;

	int max_w = 0;
	int line_count = pango_layout_get_line_count(layout);
	for (int i = 0; i < line_count; i++) {
		PangoLayoutLine *line = pango_layout_get_line_readonly(layout, i);
		if (line) {
			PangoRectangle rect;
			pango_layout_line_get_pixel_extents(line, NULL, &rect);
			if (rect.width > max_w) {
				max_w = rect.width;
			}
		}
	}
	g_object_unref(layout);
	return max_w;
}

static void update_x11_window_position(AppState *state) {
	if (gtk_layer_is_supported() || !state->window)
		return;

	GtkRequisition req;
	gtk_widget_get_preferred_size(state->window, NULL, &req);

	GdkDisplay *display = gdk_display_get_default();
	GdkMonitor *primary = gdk_display_get_primary_monitor(display);
	if (!primary) {
		primary = gdk_display_get_monitor(display, 0);
	}

	GdkRectangle geom;
	gdk_monitor_get_geometry(primary, &geom);

	int x = 0;
	int y = 0;

	switch (state->settings.position) {
	case POS_TOP_LEFT:
		x = geom.x + state->settings.margin_x;
		y = geom.y + state->settings.margin_y;
		break;
	case POS_BOTTOM_LEFT:
		x = geom.x + state->settings.margin_x;
		y = geom.y + geom.height - req.height - state->settings.margin_y;
		break;
	case POS_BOTTOM_RIGHT:
		x = geom.x + geom.width - req.width - state->settings.margin_x;
		y = geom.y + geom.height - req.height - state->settings.margin_y;
		break;
	case POS_TOP_CENTER:
		x = geom.x + (geom.width - req.width) / 2;
		y = geom.y + state->settings.margin_y;
		break;
	case POS_BOTTOM_CENTER:
		x = geom.x + (geom.width - req.width) / 2;
		y = geom.y + geom.height - req.height - state->settings.margin_y;
		break;
	case POS_TOP_RIGHT:
	default:
		x = geom.x + geom.width - req.width - state->settings.margin_x;
		y = geom.y + state->settings.margin_y;
		break;
	}

	int cur_x = 0, cur_y = 0;
	gtk_window_get_position(GTK_WINDOW(state->window), &cur_x, &cur_y);
	if (cur_x != x || cur_y != y) {
		gtk_window_move(GTK_WINDOW(state->window), x, y);
	}
}

int main(int argc, char **argv) {
	gtk_init(&argc, &argv);

	ConfigSettings settings;
	read_config_settings("~/.siclonerc", &settings);
	apply_user_styles(&settings);

	app_state.window = gtk_window_new(GTK_WINDOW_TOPLEVEL);
	app_state.is_visible = TRUE;

	GdkScreen *screen = gtk_widget_get_screen(app_state.window);
	GdkVisual *visual = gdk_screen_get_rgba_visual(screen);
	if (visual) {
		gtk_widget_set_visual(app_state.window, visual);
	}
	gtk_widget_set_app_paintable(app_state.window, TRUE);

	if (gtk_layer_is_supported()) {
		gtk_layer_init_for_window(GTK_WINDOW(app_state.window));
		gtk_layer_set_layer(GTK_WINDOW(app_state.window),
							GTK_LAYER_SHELL_LAYER_BOTTOM);
		gtk_layer_set_exclusive_zone(GTK_WINDOW(app_state.window), -1);

		gboolean top = FALSE, bottom = FALSE, left = FALSE, right = FALSE;

		switch (app_state.settings.position) {
		case POS_TOP_LEFT:
			top = left = TRUE;
			break;
		case POS_BOTTOM_LEFT:
			bottom = left = TRUE;
			break;
		case POS_BOTTOM_RIGHT:
			bottom = right = TRUE;
			break;
		case POS_TOP_CENTER:
			top = TRUE;
			break;
		case POS_BOTTOM_CENTER:
			bottom = TRUE;
			break;
		case POS_TOP_RIGHT:
		default:
			top = right = TRUE;
			break;
		}

		gtk_layer_set_anchor(GTK_WINDOW(app_state.window),
							 GTK_LAYER_SHELL_EDGE_TOP, top);
		gtk_layer_set_anchor(GTK_WINDOW(app_state.window),
							 GTK_LAYER_SHELL_EDGE_BOTTOM, bottom);
		gtk_layer_set_anchor(GTK_WINDOW(app_state.window),
							 GTK_LAYER_SHELL_EDGE_LEFT, left);
		gtk_layer_set_anchor(GTK_WINDOW(app_state.window),
							 GTK_LAYER_SHELL_EDGE_RIGHT, right);

		if (top)
			gtk_layer_set_margin(GTK_WINDOW(app_state.window),
								 GTK_LAYER_SHELL_EDGE_TOP,
								 app_state.settings.margin_y);
		if (bottom)
			gtk_layer_set_margin(GTK_WINDOW(app_state.window),
								 GTK_LAYER_SHELL_EDGE_BOTTOM,
								 app_state.settings.margin_y);
		if (left)
			gtk_layer_set_margin(GTK_WINDOW(app_state.window),
								 GTK_LAYER_SHELL_EDGE_LEFT,
								 app_state.settings.margin_x);
		if (right)
			gtk_layer_set_margin(GTK_WINDOW(app_state.window),
								 GTK_LAYER_SHELL_EDGE_RIGHT,
								 app_state.settings.margin_x);
	} else {
		/* X11 Desktop Pinning */
		gtk_window_set_type_hint(GTK_WINDOW(app_state.window),
								 GDK_WINDOW_TYPE_HINT_DESKTOP);
		gtk_window_set_decorated(GTK_WINDOW(app_state.window), FALSE);
		gtk_window_set_keep_below(GTK_WINDOW(app_state.window), TRUE);
		gtk_window_set_skip_taskbar_hint(GTK_WINDOW(app_state.window), TRUE);
		gtk_window_set_skip_pager_hint(GTK_WINDOW(app_state.window), TRUE);
	}

	GtkWidget *main_box = gtk_box_new(GTK_ORIENTATION_VERTICAL, 2);
	gtk_widget_set_name(main_box, "main_box");
	gtk_container_add(GTK_CONTAINER(app_state.window), main_box);

	/* Label block rendered before the $tray token */
	app_state.label_top = gtk_label_new("");
	gtk_label_set_xalign(GTK_LABEL(app_state.label_top), 0.0);
	gtk_box_pack_start(GTK_BOX(main_box), app_state.label_top, FALSE, FALSE, 0);

	/* Inline container created exactly at the $tray spot */
	app_state.tray_box = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 6);
	gtk_box_pack_start(GTK_BOX(main_box), app_state.tray_box, FALSE, FALSE, 4);

	init_tray_host();

	/* Label block rendered after the $tray token */
	app_state.label_bottom = gtk_label_new("");
	gtk_label_set_xalign(GTK_LABEL(app_state.label_bottom), 0.0);
	gtk_box_pack_start(GTK_BOX(main_box), app_state.label_bottom, FALSE, FALSE,
					   0);

	gtk_label_set_xalign(GTK_LABEL(app_state.label_top), 0.0);
	gtk_label_set_line_wrap(GTK_LABEL(app_state.label_top), FALSE);
	gtk_widget_set_hexpand(app_state.label_top, FALSE);

	gtk_label_set_xalign(GTK_LABEL(app_state.label_bottom), 0.0);
	gtk_label_set_line_wrap(GTK_LABEL(app_state.label_bottom), FALSE);
	gtk_widget_set_hexpand(app_state.label_bottom, FALSE);

	/* Register outer toggle indicator asynchronously after main loop spins up
	 */
	g_idle_add(init_indicator_idle, &app_state);

	gtk_widget_show_all(app_state.window);
	if (!gtk_layer_is_supported()) {
		GdkWindow *gdk_win = gtk_widget_get_window(app_state.window);
		if (gdk_win) {
			gdk_window_lower(gdk_win);
		}
	}

	on_timer_tick(&app_state);
	g_timeout_add_seconds(1, on_timer_tick, &app_state);

	gtk_main();
	return 0;
}
