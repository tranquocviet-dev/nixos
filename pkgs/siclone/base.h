#ifndef BASE_H_
#define BASE_H_

char *render_cpu(const char *fmt, unsigned int sample_ms);
char *render_ram(const char *fmt);
char *render_disk(const char *fmt, const char *path);
char *render_uptime(const char *fmt);
char *render_datetime(const char *fmt);
char *render_distro(const char *fmt);

#endif // BASE_H_
