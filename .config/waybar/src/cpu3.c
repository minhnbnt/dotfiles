#include <stdio.h>
#include <string.h>
#include <unistd.h>

#define __ZONE__ "thermal_zone1" // cpu temp zone

char *power_profile(void) {
	char buf[12]; // store power profile
	FILE *fp = popen("powerprofilesctl get", "r");
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
	float temp;
	char path[50]; // path to thermal_zone
	sprintf(path, "/sys/class/thermal/%s/temp", zone);
	FILE *fp = fopen(path, "r");
	fscanf(fp, "%f", &temp), fclose(fp);
	return temp / 1000;
}

float cpu_clock(void) {
	char buf[100];
	unsigned core = 0;
	float cpu_clock, sum = 0;
	FILE *fp = fopen("/proc/cpuinfo", "r");
	while (fgets(buf, 100, fp) != NULL)
		if (strncmp(buf, "cpu MHz", 7) == 0) { // limit length to 7
			sscanf(buf, "cpu MHz\t: %f", &cpu_clock);
			++core, sum += cpu_clock;
		}
	fclose(fp);
	return sum / core / 1000; // average clock
}

#define ulll __uint128_t
#define ull unsigned long long

float cpu_usage_loop(ulll *prev_idle, ulll *prev_total) {
	ull a[10];
	FILE *fp = fopen("/proc/stat", "r");
	fscanf(fp, "%*s %llu %llu %llu %llu %llu %llu %llu %llu %llu %llu", &a[0],
	       &a[1], &a[2], &a[3], &a[4], &a[5], &a[6], &a[7], &a[8], &a[9]),
		fclose(fp);
	ulll idle = a[3] + a[4], total = 0;
	for (int i = 0; i < 10; i++) total += a[i];
	ull totald = total - *prev_total, idled = idle - *prev_idle;
	*prev_idle = idle, *prev_total = total; // for next loop
	return 100.0 * (totald - idled) / totald;
}

int main(int argc, char *argv[]) { // args will be done later :)
	ulll idle = 0, total = 0;      // for cpu usage
	while (1) {
		printf("{\"text\": \"%.*f%%\", \"alt\": \"" /* "<span>%s</span> " */
		       "%.2fGHz %.3g°C\"}\n",
		       0, cpu_usage_loop(&idle, &total), /* power_profile(), */
		       cpu_clock(), cpu_temp(__ZONE__));
		fflush(stdout), sleep(10); // clear cache and sleep 10s
	}
	return 0;
}
