#include <stdio.h>
#include <stdlib.h>
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

ull sumOfArray(ull *a, int n) {
	ull sum = 0;
	for (int i = 0; i < n; i++) sum += a[i];
	return sum;
}

float cpu_usage(void) {
	ull a[10];
	FILE *fp = fopen("/proc/stat", "r");
	fscanf(fp, "%*s %llu %llu %llu %llu %llu %llu %llu %llu %llu %llu", &a[0],
	       &a[1], &a[2], &a[3], &a[4], &a[5], &a[6], &a[7], &a[8], &a[9]);
	ull idle = a[3] + a[4], total = sumOfArray(a, 10);
	sleep(10), fp = fopen("/proc/stat", "r");
	fscanf(fp, "%*s %llu %llu %llu %llu %llu %llu %llu %llu %llu %llu", &a[0],
	       &a[1], &a[2], &a[3], &a[4], &a[5], &a[6], &a[7], &a[8], &a[9]);
	fclose(fp), idle = a[3] + a[4] - idle, total = sumOfArray(a, 10) - total;
	return (total - idle) * 100.0 / total;
}

int main(int argc, char *argv[]) {
	unsigned interval = 1;
	char *stat = "/proc/stat", *cpuinfo = "/proc/cpuinfo",
		 *current_profile = "powerprofilesctl get";
	if (argc == 1) {
		printf("<span>%s</span> %.2fGHz %.3g%%\n",
		       power_profile(current_profile), cpu_clock(cpuinfo), cpu_usage());
		return 0;
	} else {
		if (strcmp(argv[1], "-l") == 0) {
			printf("<span>%s</span> %.2fGHz\n", power_profile(current_profile),
			       cpu_clock(cpuinfo));
			interval = 10;
			if (argc > 2) interval = atoi(argv[2]);
			ull a[10];
			FILE *fp = fopen(stat, "r");
			fscanf(fp, "%*s %llu %llu %llu %llu %llu %llu %llu %llu %llu %llu",
			       &a[0], &a[1], &a[2], &a[3], &a[4], &a[5], &a[6], &a[7],
			       &a[8], &a[9]);
			ull idle = a[3] + a[4], total = 0;
			for (int i = 0; i < 10; i++) total += a[i];
			while (1) {
				printf("<span>%s</span> %.2fGHz %.2f%%\n",
				       power_profile(current_profile), cpu_clock(cpuinfo),
				       cpu_usage_loop(fp, a, &idle, &total, interval));
			};
		};
		int argpos = 0;
		char colored = 0;
		for (int i = 1; i < argc; i++)
			if (strcmp(argv[i], "-C") == 0) {
				colored = 1;
				break;
			};
		while (++argpos < argc) {
			if (strcmp(argv[argpos], "-C") == 0) continue;
			else if (strcmp(argv[argpos], "-t") == 0)
				printf("%.3g°C", cpu_temp(argv[++argpos]));
			else if (strcmp(argv[argpos], "-p") == 0)
				printf("<span>%s</span>", power_profile(current_profile));
			else if (strcmp(argv[argpos], "-c") == 0)
				printf("%.2fGHz", cpu_clock(cpuinfo));
			else if (strcmp(argv[argpos], "-u") == 0) {
				float usage = cpu_usage();
				if (colored) {
					char *color[6] = {
						"#00ffae", "#04ff00", "#eaff00",
						"#ff8400", "#ff0000", "#ff0000",
					};
					char index = usage / 100 * 6;
					printf("<span color='%s'>%.2f%%</span>", color[index],
					       usage);
				} else printf("%.3g%%", usage);
			};
			if (argpos + 1 < argc) printf(" ");
		};
		printf("\n");
		return 0;
	};
}