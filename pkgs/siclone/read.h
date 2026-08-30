#ifndef READ_H_
#define READ_H_

typedef enum {
	POS_TOP_RIGHT,
	POS_TOP_LEFT,
	POS_BOTTOM_RIGHT,
	POS_BOTTOM_LEFT,
	POS_TOP_CENTER,
	POS_BOTTOM_CENTER
} WidgetPosition;

typedef struct {
	char font[64];
	int font_size;
	char background[32];
	char text_color[32];
	int margin_x;
	int margin_y;
	int icon_size;
	WidgetPosition position;
} ConfigSettings;

void read_config_settings(const char *filepath, ConfigSettings *settings);
void evaluate_config_split(const char *filepath, char **out_top,
						   char **out_bottom, int *out_has_tray);

#endif /* READ_H_ */
