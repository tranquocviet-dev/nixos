#include "base.h"
#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/sysinfo.h>
#include <sys/statvfs.h>

#define MAX_RENDER_BUF 512

void add_char(char *s, char c) {
	while (*s++);
	*(s - 1) = c;
	*s = '\0';
}

/* Helper to append a full string into the buffer using add_char */
static void add_str(char *s, const char *src) {
	while (*src) {
		add_char(s, *src++);
	}
}

/*
 * Reads /proc/stat twice over sample_ms interval to calculate
 * the active CPU percentage.
 */
static double get_cpu_usage(unsigned int sample_ms) {
	FILE *fp = fopen("/proc/stat", "r");
	if (!fp) {
		return -1.0;
	}

	unsigned long long u1, n1, s1, i1, w1, q1, sq1, st1;
	int ret = fscanf(fp, "cpu %llu %llu %llu %llu %llu %llu %llu %llu",
		&u1, &n1, &s1, &i1, &w1, &q1, &sq1, &st1);
	fclose(fp);

	if (ret < 8) {
		return -1.0;
	}

	usleep(sample_ms * 1000);

	fp = fopen("/proc/stat", "r");
	if (!fp) {
		return -1.0;
	}

	unsigned long long u2, n2, s2, i2, w2, q2, sq2, st2;
	ret = fscanf(fp, "cpu %llu %llu %llu %llu %llu %llu %llu %llu",
		&u2, &n2, &s2, &i2, &w2, &q2, &sq2, &st2);
	fclose(fp);

	if (ret < 8) {
		return -1.0;
	}

	unsigned long long idle1 = i1 + w1;
	unsigned long long total1 = u1 + n1 + s1 + i1 + w1 + q1 + sq1 + st1;

	unsigned long long idle2 = i2 + w2;
	unsigned long long total2 = u2 + n2 + s2 + i2 + w2 + q2 + sq2 + st2;

	unsigned long long total_delta = total2 - total1;
	unsigned long long idle_delta = idle2 - idle1;

	if (total_delta == 0) {
		return 0.0;
	}

	return (double)(total_delta - idle_delta) / (double)total_delta * 100.0;
}

/*
 * Renders CPU usage according to a user format string.
 * Tokens:
 *   %p : Rounded integer percentage (e.g. 4)
 *   %P : Two-decimal percentage (e.g. 4.12)
 *   %% : Literal '%'
 * Returns a heap-allocated string that the caller must free().
 */
char *render_cpu(const char *fmt, unsigned int sample_ms) {
	if (!fmt) {
		fmt = "Usage: %p%%";
	}
	if (!sample_ms) {
		sample_ms = 200;
	}

	double usage = get_cpu_usage(sample_ms);
	if (usage < 0.0) {
		return NULL;
	}

	char *buf = calloc(MAX_RENDER_BUF, sizeof(char));
	if (!buf) {
		return NULL;
	}

	char tmp[64];
	for (const char *p = fmt; *p != '\0'; p++) {
		if (*p != '%') {
			add_char(buf, *p);
			continue;
		}

		p++;
		switch (*p) {
		case 'p':
			snprintf(tmp, sizeof(tmp), "%d", (int)(usage + 0.5));
			add_str(buf, tmp);
			break;
		case 'P':
			snprintf(tmp, sizeof(tmp), "%.2f", usage);
			add_str(buf, tmp);
			break;
		case '%':
			add_char(buf, '%');
			break;
		case '\0':
			return buf;
		default:
			add_char(buf, '%');
			add_char(buf, *p);
			break;
		}
	}

	return buf;
}

/*
 * Reads /proc/meminfo to calculate real memory consumption matching widgets.
 * Tokens:
 *   %u : Used memory in GiB
 *   %t : Total memory in GiB
 *   %p : Rounded used percentage
 *   %P : Two-decimal used percentage
 *   %% : Literal '%'
 * Returns a heap-allocated string that the caller must free().
 */
char *render_ram(const char *fmt) {
	if (!fmt) {
		fmt = "RAM: %u / %t (%p%%)";
	}

	FILE *fp = fopen("/proc/meminfo", "r");
	if (!fp) {
		return NULL;
	}

	char line[256];
	unsigned long long total_kb = 0;
	unsigned long long avail_kb = 0;

	while (fgets(line, sizeof(line), fp)) {
		if (strncmp(line, "MemTotal:", 9) == 0) {
			sscanf(line, "MemTotal: %llu kB", &total_kb);
		} else if (strncmp(line, "MemAvailable:", 13) == 0) {
			sscanf(line, "MemAvailable: %llu kB", &avail_kb);
		}

		if (total_kb && avail_kb) {
			break;
		}
	}
	fclose(fp);

	if (total_kb == 0) {
		return NULL;
	}

	unsigned long long used_kb = total_kb - avail_kb;
	double total_gib = (double)total_kb / (1024.0 * 1024.0);
	double used_gib = (double)used_kb / (1024.0 * 1024.0);
	double used_pct = ((double)used_kb / (double)total_kb) * 100.0;

	char *buf = calloc(MAX_RENDER_BUF, sizeof(char));
	if (!buf) {
		return NULL;
	}

	char tmp[64];
	for (const char *p = fmt; *p != '\0'; p++) {
		if (*p != '%') {
			add_char(buf, *p);
			continue;
		}

		p++;
		switch (*p) {
		case 'u':
			snprintf(tmp, sizeof(tmp), "%.2fGiB", used_gib);
			add_str(buf, tmp);
			break;
		case 't':
			snprintf(tmp, sizeof(tmp), "%.2fGiB", total_gib);
			add_str(buf, tmp);
			break;
		case 'p':
			snprintf(tmp, sizeof(tmp), "%d", (int)(used_pct + 0.5));
			add_str(buf, tmp);
			break;
		case 'P':
			snprintf(tmp, sizeof(tmp), "%.2f", used_pct);
			add_str(buf, tmp);
			break;
		case '%':
			add_char(buf, '%');
			break;
		case '\0':
			return buf;
		default:
			add_char(buf, '%');
			add_char(buf, *p);
			break;
		}
	}

	return buf;
}

/*
 * Reads filesystem stats using statvfs().
 * Tokens:
 *   %m : Mount path
 *   %u : Used disk in GiB
 *   %t : Total disk in GiB
 *   %p : Rounded used percentage
 *   %P : Two-decimal used percentage
 *   %% : Literal '%'
 * Returns a heap-allocated string that the caller must free().
 */
char *render_disk(const char *fmt, const char *path) {
	if (!fmt) {
		fmt = "Root: %u / %t";
	}
	if (!path) {
		path = "/";
	}

	struct statvfs stat;
	if (statvfs(path, &stat) != 0) {
		return NULL;
	}

	unsigned long long total_bytes = (unsigned long long)stat.f_blocks * stat.f_frsize;
	unsigned long long free_bytes = (unsigned long long)stat.f_bfree * stat.f_frsize;
	unsigned long long used_bytes = total_bytes - free_bytes;

	double total_gib = (double)total_bytes / (1024.0 * 1024.0 * 1024.0);
	double used_gib = (double)used_bytes / (1024.0 * 1024.0 * 1024.0);
	double used_pct = total_bytes ? ((double)used_bytes / (double)total_bytes) * 100.0 : 0.0;

	char *buf = calloc(MAX_RENDER_BUF, sizeof(char));
	if (!buf) {
		return NULL;
	}

	char tmp[64];
	for (const char *p = fmt; *p != '\0'; p++) {
		if (*p != '%') {
			add_char(buf, *p);
			continue;
		}

		p++;
		switch (*p) {
		case 'm':
			add_str(buf, path);
			break;
		case 'u':
			snprintf(tmp, sizeof(tmp), "%.0fGiB", used_gib);
			add_str(buf, tmp);
			break;
		case 't':
			snprintf(tmp, sizeof(tmp), "%.0fGiB", total_gib);
			add_str(buf, tmp);
			break;
		case 'p':
			snprintf(tmp, sizeof(tmp), "%d", (int)(used_pct + 0.5));
			add_str(buf, tmp);
			break;
		case 'P':
			snprintf(tmp, sizeof(tmp), "%.2f", used_pct);
			add_str(buf, tmp);
			break;
		case '%':
			add_char(buf, '%');
			break;
		case '\0':
			return buf;
		default:
			add_char(buf, '%');
			add_char(buf, *p);
			break;
		}
	}

	return buf;
}

/*
 * Reads system uptime using sysinfo().
 * Tokens:
 *   %D : Days
 *   %h : Hours (0-23)
 *   %H : Total running hours across days
 *   %m : Minutes (0-59)
 *   %s : Seconds (0-59)
 *   %% : Literal '%'
 * Returns a heap-allocated string that the caller must free().
 */
char *render_uptime(const char *fmt) {
	if (!fmt) {
		fmt = "Uptime: %Hh %mm %ss";
	}

	struct sysinfo info;
	if (sysinfo(&info) != 0) {
		return NULL;
	}

	long total = info.uptime;
	long days = total / 86400;
	long hours = (total % 86400) / 3600;
	long total_hours = total / 3600;
	long mins = (total % 3600) / 60;
	long secs = total % 60;

	char *buf = calloc(MAX_RENDER_BUF, sizeof(char));
	if (!buf) {
		return NULL;
	}

	char tmp[64];
	for (const char *p = fmt; *p != '\0'; p++) {
		if (*p != '%') {
			add_char(buf, *p);
			continue;
		}

		p++;
		switch (*p) {
		case 'D':
			snprintf(tmp, sizeof(tmp), "%ld", days);
			add_str(buf, tmp);
			break;
		case 'h':
			snprintf(tmp, sizeof(tmp), "%ld", hours);
			add_str(buf, tmp);
			break;
		case 'H':
			snprintf(tmp, sizeof(tmp), "%ld", total_hours);
			add_str(buf, tmp);
			break;
		case 'm':
			snprintf(tmp, sizeof(tmp), "%02ld", mins);
			add_str(buf, tmp);
			break;
		case 's':
			snprintf(tmp, sizeof(tmp), "%02ld", secs);
			add_str(buf, tmp);
			break;
		case '%':
			add_char(buf, '%');
			break;
		case '\0':
			return buf;
		default:
			add_char(buf, '%');
			add_char(buf, *p);
			break;
		}
	}

	return buf;
}

char *render_datetime(const char *fmt) {
	if (!fmt) {
		fmt = "%Y-%m-%d %H:%M";
	}
	time_t now = time(NULL);
	struct tm *tm_info = localtime(&now);

	char *buf = calloc(64, sizeof(char));
	if (!buf) {
		return NULL;
	}
	strftime(buf, 64, fmt, tm_info);
	return buf;
}

/*
 * Parses /etc/os-release for PRETTY_NAME.
 * Tokens:
 *   %n : Distribution name
 *   %% : Literal '%'
 * Returns a heap-allocated string that the caller must free().
 */
char *render_distro(const char *fmt) {
	if (!fmt) {
		fmt = "OS: %n";
	}

	FILE *fp = fopen("/etc/os-release", "r");
	char name[256] = "Linux";

	if (fp) {
		char line[256];
		while (fgets(line, sizeof(line), fp)) {
			if (strncmp(line, "PRETTY_NAME=", 12) == 0) {
				char *start = line + 12;
				if (*start == '"') {
					start++;
				}
				size_t len = strlen(start);
				while (len > 0 && (start[len - 1] == '\n' || start[len - 1] == '\r' || start[len - 1] == '"')) {
					start[--len] = '\0';
				}
				strncpy(name, start, sizeof(name) - 1);
				name[sizeof(name) - 1] = '\0';
				break;
			}
		}
		fclose(fp);
	}

	char *buf = calloc(MAX_RENDER_BUF, sizeof(char));
	if (!buf) {
		return NULL;
	}

	for (const char *p = fmt; *p != '\0'; p++) {
		if (*p != '%') {
			add_char(buf, *p);
			continue;
		}

		p++;
		switch (*p) {
		case 'n':
			add_str(buf, name);
			break;
		case '%':
			add_char(buf, '%');
			break;
		case '\0':
			return buf;
		default:
			add_char(buf, '%');
			add_char(buf, *p);
			break;
		}
	}

	return buf;
}
