#include "cpu.h"

ull sumOfArray(ull *a, int n) {
	ull sum = 0;
	for (int i = 0; i < n; i++) sum += a[i];
	return sum;
}

float cpu_usage(char *path, int interval) {
	ull a[10];
	FILE *fp = fopen(path, "r");
	fscanf(fp, "%*s %llu %llu %llu %llu %llu %llu %llu %llu %llu %llu", &a[0],
	       &a[1], &a[2], &a[3], &a[4], &a[5], &a[6], &a[7], &a[8], &a[9]);
	ull idle = a[3] + a[4], total = sumOfArray(a, 10);
	sleep(interval), fp = fopen(path, "r");
	fscanf(fp, "%*s %llu %llu %llu %llu %llu %llu %llu %llu %llu %llu", &a[0],
	       &a[1], &a[2], &a[3], &a[4], &a[5], &a[6], &a[7], &a[8], &a[9]);
	fclose(fp), idle = a[3] + a[4] - idle, total = sumOfArray(a, 10) - total;
	return (total - idle) * 100.0 / total;
}

int main(int argc, char *argv[]) {
	int interval = 1;
	char *stat = "/proc/stat", *cpuinfo = "/proc/cpuinfo",
		 *current_profile = "powerprofilesctl get ";
	if (argc == 1) {
		printf("<span>%s</span> %.2fGHz %.3g%%\n",
		       power_profile(current_profile), cpu_clock(cpuinfo),
		       cpu_usage(stat, interval));
		return 0;
	} else {
		if (strcmp(argv[1], "-l") == 0) {
			printf("<span>%s</span> %.2fGHz\n", power_profile(current_profile),
			       cpu_clock(cpuinfo));
			interval = 10;
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
				float usage = cpu_usage(stat, interval);
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
