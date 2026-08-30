#include "read.h"
#include "base.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <wordexp.h>

static FILE *fopen_expanded(const char *path, const char *mode) {
	wordexp_t exp;
	if (wordexp(path, &exp, WRDE_NOCMD) != 0) {
		return NULL;
	}
	FILE *fp = fopen(exp.we_wordv[0], mode);
	wordfree(&exp);
	return fp;
}

static char **read_file_lines(const char *filepath, size_t *out_line_count) {
	FILE *fp = fopen_expanded(filepath, "r");
	if (!fp) {
		return NULL;
	}

	size_t capacity = 16;
	size_t count = 0;
	char **lines = malloc(capacity * sizeof(char *));
	if (!lines) {
		fclose(fp);
		return NULL;
	}

	char *buffer = NULL;
	size_t buf_len = 0;
	ssize_t nread;

	while ((nread = getline(&buffer, &buf_len, fp)) != -1) {
		while (nread > 0 &&
			   (buffer[nread - 1] == '\n' || buffer[nread - 1] == '\r')) {
			buffer[--nread] = '\0';
		}

		if (count >= capacity) {
			size_t new_cap = capacity * 2;
			char **temp = realloc(lines, new_cap * sizeof(char *));
			if (!temp) {
				break;
			}
			lines = temp;
			capacity = new_cap;
		}

		lines[count] = strdup(buffer);
		if (!lines[count]) {
			break;
		}
		count++;
	}

	free(buffer);
	fclose(fp);
	*out_line_count = count;
	return lines;
}

static void free_file_lines(char **lines, size_t line_count) {
	if (!lines) {
		return;
	}
	for (size_t i = 0; i < line_count; i++) {
		free(lines[i]);
	}
	free(lines);
}

static char *replace_token(const char *line, const char *token,
						   const char *val) {
	char *pos = strstr(line, token);
	if (!pos) {
		return strdup(line);
	}

	size_t pre_len = pos - line;
	size_t tok_len = strlen(token);
	size_t post_len = strlen(pos + tok_len);
	size_t val_len = val ? strlen(val) : 0;

	char *result = malloc(pre_len + val_len + post_len + 1);
	if (!result) {
		return NULL;
	}

	memcpy(result, line, pre_len);
	if (val) {
		memcpy(result + pre_len, val, val_len);
	}
	memcpy(result + pre_len + val_len, pos + tok_len, post_len);
	result[pre_len + val_len + post_len] = '\0';

	return result;
}

void read_config_settings(const char *filepath, ConfigSettings *settings) {
	/* Defaults */
	strncpy(settings->font, "monospace", sizeof(settings->font) - 1);
	settings->font_size = 13;
	strncpy(settings->background, "rgba(0, 0, 0, 0.0)",
			sizeof(settings->background) - 1);
	strncpy(settings->text_color, "#ffffff", sizeof(settings->text_color) - 1);
	settings->margin_x = 0;
	settings->margin_y = 0;
	settings->icon_size = 24;
	settings->position = POS_TOP_RIGHT;

	size_t line_count = 0;
	char **lines = read_file_lines(filepath, &line_count);
	if (!lines) {
		return;
	}

	int inside_settings = 0;
	for (size_t i = 0; i < line_count; i++) {
		char *l = lines[i];
		while (*l == ' ' || *l == '\t') {
			l++;
		}

		if (strncmp(l, "settings {", 10) == 0) {
			inside_settings = 1;
			continue;
		}

		if (inside_settings && *l == '}') {
			inside_settings = 0;
			break;
		}

		if (inside_settings) {
			char *eq = strchr(l, '=');
			if (eq) {
				*eq = '\0';
				char *key = l;
				char *val = eq + 1;

				/* Trim leading/trailing whitespace on key */
				while (*key == ' ' || *key == '\t')
					key++;
				char *end_k = key + strlen(key) - 1;
				while (end_k > key && (*end_k == ' ' || *end_k == '\t'))
					*end_k-- = '\0';

				/* Trim leading/trailing whitespace on val */
				while (*val == ' ' || *val == '\t')
					val++;
				char *end_v = val + strlen(val) - 1;
				while (end_v >= val && (*end_v == ' ' || *end_v == '\t' ||
										*end_v == '\n' || *end_v == '\r'))
					*end_v-- = '\0';

				if (strcmp(key, "font") == 0) {
					strncpy(settings->font, val, sizeof(settings->font) - 1);
				} else if (strcmp(key, "font_size") == 0) {
					settings->font_size = atoi(val);
				} else if (strcmp(key, "background") == 0) {
					strncpy(settings->background, val,
							sizeof(settings->background) - 1);
				} else if (strcmp(key, "text_color") == 0) {
					strncpy(settings->text_color, val,
							sizeof(settings->text_color) - 1);
				} else if (strcmp(key, "margin_x") == 0) {
					settings->margin_x = atoi(val);
				} else if (strcmp(key, "margin_y") == 0) {
					settings->margin_y = atoi(val);
				} else if (strcmp(key, "position") == 0) {
					if (strcmp(val, "top-left") == 0) {
						settings->position = POS_TOP_LEFT;
					} else if (strcmp(val, "bottom-right") == 0) {
						settings->position = POS_BOTTOM_RIGHT;
					} else if (strcmp(val, "bottom-left") == 0) {
						settings->position = POS_BOTTOM_LEFT;
					} else if (strcmp(val, "top-center") == 0) {
						settings->position = POS_TOP_CENTER;
					} else if (strcmp(val, "bottom-center") == 0) {
						settings->position = POS_BOTTOM_CENTER;
					} else {
						settings->position = POS_TOP_RIGHT;
					}
				} else if (strcmp(key, "icon_size") == 0) {
					settings->icon_size = atoi(val);
					if (settings->icon_size <= 0) {
						settings->icon_size = 16;
					}
				}
			}
		}
	}

	free_file_lines(lines, line_count);
}

/* Helper to parse optional parenthesized custom format for standard modules */
static char *eval_module_with_args(const char *line, const char *module_name,
								   const char *default_fmt,
								   char *(*render_func)(const char *)) {
	char *pos = strstr(line, module_name);
	if (!pos) {
		return NULL;
	}

	size_t name_len = strlen(module_name);
	char token_buf[256];
	char custom_fmt[128];
	const char *fmt_to_use = default_fmt;

	if (pos[name_len] == '(') {
		char *closing = strchr(pos + name_len + 1, ')');
		if (closing) {
			size_t arg_len = closing - (pos + name_len + 1);
			if (arg_len >= sizeof(custom_fmt)) {
				arg_len = sizeof(custom_fmt) - 1;
			}
			strncpy(custom_fmt, pos + name_len + 1, arg_len);
			custom_fmt[arg_len] = '\0';
			fmt_to_use = custom_fmt;

			size_t full_token_len = (closing + 1) - pos;
			if (full_token_len >= sizeof(token_buf)) {
				full_token_len = sizeof(token_buf) - 1;
			}
			strncpy(token_buf, pos, full_token_len);
			token_buf[full_token_len] = '\0';
		} else {
			strncpy(token_buf, module_name, sizeof(token_buf) - 1);
			token_buf[sizeof(token_buf) - 1] = '\0';
		}
	} else {
		strncpy(token_buf, module_name, sizeof(token_buf) - 1);
		token_buf[sizeof(token_buf) - 1] = '\0';
	}

	char *val = render_func(fmt_to_use);
	if (!val) {
		return NULL;
	}

	char *out = replace_token(line, token_buf, val);
	free(val);
	return out;
}

static char *render_cpu_default(const char *fmt) {
	return render_cpu(fmt, 200);
}

static char *eval_line(const char *line, int *out_has_tray) {
	if (strcmp(line, "$tray") == 0 || strcmp(line, "tray") == 0) {
		if (out_has_tray) {
			*out_has_tray = 1;
		}
		return NULL;
	}

	/* $distro and $distro(...) */
	if (strstr(line, "$distro") || strcmp(line, "distro") == 0) {
		if (strstr(line, "$distro")) {
			return eval_module_with_args(line, "$distro", "OS: %n",
										 render_distro);
		}
		char *val = render_distro("OS: %n");
		return val;
	}

	/* $uptime and $uptime(...) */
	if (strstr(line, "$uptime") || strcmp(line, "uptime") == 0) {
		if (strstr(line, "$uptime")) {
			return eval_module_with_args(line, "$uptime", "%Hh %mm %ss",
										 render_uptime);
		}
		char *val = render_uptime("%Hh %mm %ss");
		return val;
	}

	/* $time and $time(...) */
	if (strstr(line, "$time") || strcmp(line, "time") == 0) {
		if (strstr(line, "$time")) {
			return eval_module_with_args(line, "$time", "%Y-%m-%d %H:%M",
										 render_datetime);
		}
		char *val = render_datetime("%Y-%m-%d %H:%M");
		return val;
	}

	/* $cpu and $cpu(...) */
	if (strstr(line, "$cpu") || strcmp(line, "cpu") == 0) {
		if (strstr(line, "$cpu")) {
			return eval_module_with_args(line, "$cpu", "%p%%",
										 render_cpu_default);
		}
		char *val = render_cpu("%p%%", 200);
		return val;
	}

	/* $ram and $ram(...) */
	if (strstr(line, "$ram") || strcmp(line, "ram") == 0) {
		if (strstr(line, "$ram")) {
			return eval_module_with_args(line, "$ram", "%u / %t (%p%%)",
										 render_ram);
		}
		char *val = render_ram("%u / %t (%p%%)");
		return val;
	}

	/* $storage, $storage[path], $storage(fmt), $storage[path](fmt) */
	char *storage_pos = strstr(line, "$storage");
	if (storage_pos || strcmp(line, "storage") == 0) {
		char path[128] = "/";
		char fmt[128] = "%u / %t";
		const char *cursor = storage_pos ? storage_pos + 8 : NULL;

		if (cursor) {
			/* Check for [mount_path] */
			if (*cursor == '[') {
				char *bracket_end = strchr(cursor + 1, ']');
				if (bracket_end) {
					size_t path_len = bracket_end - (cursor + 1);
					if (path_len >= sizeof(path)) {
						path_len = sizeof(path) - 1;
					}
					strncpy(path, cursor + 1, path_len);
					path[path_len] = '\0';
					cursor = bracket_end + 1;
				}
			}

			/* Check for (custom_format) immediately following */
			if (*cursor == '(') {
				char *paren_end = strchr(cursor + 1, ')');
				if (paren_end) {
					size_t fmt_len = paren_end - (cursor + 1);
					if (fmt_len >= sizeof(fmt)) {
						fmt_len = sizeof(fmt) - 1;
					}
					strncpy(fmt, cursor + 1, fmt_len);
					fmt[fmt_len] = '\0';
					cursor = paren_end + 1;
				}
			}
		}

		char token_buf[256];
		if (storage_pos && cursor) {
			size_t full_token_len = cursor - storage_pos;
			if (full_token_len >= sizeof(token_buf)) {
				full_token_len = sizeof(token_buf) - 1;
			}
			strncpy(token_buf, storage_pos, full_token_len);
			token_buf[full_token_len] = '\0';
		} else {
			strncpy(token_buf, "$storage", sizeof(token_buf) - 1);
			token_buf[sizeof(token_buf) - 1] = '\0';
		}

		char *val = render_disk(fmt, path);
		if (!val) {
			return strdup(line);
		}

		char *out =
			storage_pos ? replace_token(line, token_buf, val) : strdup(val);
		free(val);
		return out;
	}

	return strdup(line);
}

char *evaluate_config_to_string(const char *filepath, int *out_has_tray) {
	size_t line_count = 0;
	char **lines = read_file_lines(filepath, &line_count);
	if (!lines) {
		return NULL;
	}

	if (out_has_tray) {
		*out_has_tray = 0;
	}

	size_t out_cap = 4096;
	char *output = calloc(out_cap, sizeof(char));
	if (!output) {
		free_file_lines(lines, line_count);
		return NULL;
	}

	int inside_format = 0;
	for (size_t i = 0; i < line_count; i++) {
		char *line = lines[i];

		if (strncmp(line, "fmt {", 5) == 0 ||
			strncmp(line, "format_start", 12) == 0) {
			inside_format = 1;
			continue;
		}
		if (inside_format &&
			(strcmp(line, "}") == 0 || strncmp(line, "format_end", 10) == 0)) {
			break;
		}

		if (inside_format) {
			char *rendered_line = eval_line(line, out_has_tray);
			if (rendered_line) {
				if (strlen(output) + strlen(rendered_line) + 2 >= out_cap) {
					out_cap *= 2;
					char *temp = realloc(output, out_cap);
					if (!temp) {
						free(rendered_line);
						break;
					}
					output = temp;
				}
				strcat(output, rendered_line);
				strcat(output, "\n");
				free(rendered_line);
			}
		}
	}

	free_file_lines(lines, line_count);
	return output;
}

void evaluate_config_split(const char *filepath, char **out_top,
						   char **out_bottom, int *out_has_tray) {
	size_t line_count = 0;
	char **lines = read_file_lines(filepath, &line_count);
	if (!lines) {
		*out_top = NULL;
		*out_bottom = NULL;
		if (out_has_tray)
			*out_has_tray = 0;
		return;
	}

	size_t top_cap = 2048, bot_cap = 2048;
	char *top = calloc(top_cap, sizeof(char));
	char *bottom = calloc(bot_cap, sizeof(char));
	int found_tray = 0;
	int inside_format = 0;

	for (size_t i = 0; i < line_count; i++) {
		char *line = lines[i];

		if (strncmp(line, "fmt {", 5) == 0 ||
			strncmp(line, "format_start", 12) == 0) {
			inside_format = 1;
			continue;
		}
		if (inside_format &&
			(strcmp(line, "}") == 0 || strncmp(line, "format_end", 10) == 0)) {
			break;
		}

		if (inside_format) {
			if (strstr(line, "$tray") || strcmp(line, "tray") == 0) {
				found_tray = 1;
				continue;
			}

			int dummy = 0;
			char *rendered_line = eval_line(line, &dummy);
			if (rendered_line) {
				char **target = found_tray ? &bottom : &top;
				size_t *cap = found_tray ? &bot_cap : &top_cap;

				if (strlen(*target) + strlen(rendered_line) + 2 >= *cap) {
					*cap *= 2;
					*target = realloc(*target, *cap);
				}
				strcat(*target, rendered_line);
				strcat(*target, "\n");
				free(rendered_line);
			}
		}
	}

	free_file_lines(lines, line_count);
	*out_top = top;
	*out_bottom = bottom;
	if (out_has_tray) {
		*out_has_tray = found_tray;
	}
}
