#ifndef CPU_H
#define CPU_H

#include <stdio.h>
#include <string.h>
#include <unistd.h>

#define ull unsigned long long

const char *power_profile(const char *path) {
	char buf[12];
	FILE *fp = popen(path, "r");
	fgets(buf, 12, fp), pclose(fp);
	if (strncmp(buf, "balanced", 8) == 0) {
		return "&#xf24e;"; // 
	} else if (strncmp(buf, "performance", 11) == 0) {
		return "&#xf0e4;"; // 
	} else if (strncmp(buf, "power-save", 10) == 0) {
		return "&#xf06c;";    // 
	} else return "&#xf2db;"; // 
}

float cpu_temp(const char *zone) {
	char path[100];
	sprintf(path, "/sys/class/thermal/%s/temp", zone);
	FILE *fp = fopen(path, "r");
	float temp;
	fscanf(fp, "%f", &temp), fclose(fp);
	return temp / 1000;
}

float cpu_clock(const char *path) {
	FILE *fp = fopen(path, "r");
	char buf[100], core = 0;
	float cpu_clock, sum = 0;
	while (fgets(buf, 100, fp) != NULL)
		if (strncmp(buf, "cpu MHz", 7) == 0) {
			sscanf(buf, "cpu MHz\t: %f", &cpu_clock);
			core++, sum += cpu_clock;
		};
	fclose(fp);
	return sum / core / 1000; // average clock
}

float cpu_usage_loop(FILE *fp, ull *a, ull *prev_idle, ull *prev_total,
                     unsigned delay) {
	fflush(stdout), fclose(fp), sleep(delay), fp = fopen("/proc/stat", "r");
	fscanf(fp, "%*s %llu %llu %llu %llu %llu %llu %llu %llu %llu %llu", &a[0],
	       &a[1], &a[2], &a[3], &a[4], &a[5], &a[6], &a[7], &a[8], &a[9]);
	ull idle = a[3] + a[4], total = 0;
	for (char i = 0; i < 10; i++) total += a[i];
	ull totald = total - *prev_total, idled = idle - *prev_idle;
	*prev_idle = idle, *prev_total = total; // for next loop
	return 100.0 * (totald - idled) / totald;
};

#endif
