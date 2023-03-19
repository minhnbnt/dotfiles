#include <stdio.h>
#include <string.h>
#include <unistd.h>

char *power_profile(char *command) {
	FILE *fp = popen(command, "r");
	char buf[12];
	fgets(buf, 100, fp), pclose(fp);
	if (!strncmp(buf, "balanced", 8)) return "&#xf24e;";          // 
	else if (!strncmp(buf, "performance", 11)) return "&#xf0e4;"; // 
	else if (!strncmp(buf, "power-save", 10)) return "&#xf06c;";  // 
	else return "&#xf2db;";                                       // 
}

float cpu_clock(char *path) {
	FILE *fp = fopen(path, "r");
	char buf[100], core = 0;
	float cpu_clock, sum = 0;
	while (fgets(buf, 100, fp))
		if (strncmp(buf, "cpu MHz", 7) == 0) {
			sscanf(buf, "cpu MHz\t: %f", &cpu_clock);
			core++, sum += cpu_clock;
		};
	fclose(fp);
	return sum / core / 1000;
}

float cpu_usage(char *path) {
	long long a[10];
	FILE *fp = fopen(path, "r");
	fscanf(fp, "%*s %lld %lld %lld %lld %lld %lld %lld %lld %lld %lld", &a[0],
	       &a[1], &a[2], &a[3], &a[4], &a[5], &a[6], &a[7], &a[8], &a[9]);
	long long int previdle = a[3] + a[4], pretotal = 0;
	for (int i = 0; i < 10; i++)
		pretotal += a[i];
	sleep(1), fp = fopen(path, "r");
	fscanf(fp, "%*s %lld %lld %lld %lld %lld %lld %lld %lld %lld %lld", &a[0],
	       &a[1], &a[2], &a[3], &a[4], &a[5], &a[6], &a[7], &a[8], &a[9]);
	fclose(fp);
	long long idle = a[3] + a[4], total = 0;
	for (int i = 0; i < 10; i++)
		total += a[i];
	total -= pretotal, idle -= previdle;
	return (total - idle) * 100.0 / total;
}

float cpu_temp(char *zone) {
	char path[100];
	sprintf(path, "/sys/class/thermal/%s/temp", zone);
	FILE *fp = fopen(path, "r");
	float temp;
	fscanf(fp, "%f", &temp), fclose(fp);
	return temp / 1000;
}

int main(int argc, char *argv[]) {
	char *stat = "/proc/stat", *cpuinfo = "/proc/cpuinfo",
		 *current_profile = "powerprofilesctl get ";
	if (argc == 1) {
		printf("<span>%s</span> %.2fGHz %.2f%%\n",
		       power_profile(current_profile), cpu_clock(cpuinfo),
		       cpu_usage(stat));
		return 0;
	} else {
		int argpos = 0, colored = 0;
		for (int i = 1; i < argc; i++)
			if (strcmp(argv[i], "-C") == 0) {
				colored = 1;
				break;
			};
		while (++argpos < argc) {
			if (strcmp(argv[argpos], "-C") == 0) continue;
			else if (strcmp(argv[argpos], "-t") == 0)
				printf("%.0f°C", cpu_temp(argv[++argpos]));
			else if (strcmp(argv[argpos], "-p") == 0)
				printf("<span>%s</span>", power_profile(current_profile));
			else if (strcmp(argv[argpos], "-c") == 0)
				printf("%.2fGHz", cpu_clock(cpuinfo));
			else if (strcmp(argv[argpos], "-u") == 0) {
				float usage = cpu_usage(stat);
				if (colored) {
					char *color[6] = {
						"#00ffae", "#04ff00", "#eaff00",
						"#ff8400", "#ff0000", "#ff0000",
					};
					char index = usage / 100 * 6;
					printf("<span color='%s'>%.2f%%</span>", color[index],
					       usage);
				} else printf("%.2f%%", usage);
			};
			if (argpos + 1 < argc) printf(" ");
		};
		printf("\n");
		return 0;
	};
}
