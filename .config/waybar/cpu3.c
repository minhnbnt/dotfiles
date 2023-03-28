#include "cpu.h"

int main() {
	char *stat = "/proc/stat", *cpuinfo = "/proc/cpuinfo",
		 *current_profile = "powerprofilesctl get ", *zone = "thermal_zone1";
	printf("{\"text\": \"nan\", \"alt\": \"<span>%s</span> %.2fGHz %.3g°C\"}\n",
	       power_profile(current_profile), cpu_clock(cpuinfo), cpu_temp(zone));
	ull a[10];
	FILE *fp = fopen(stat, "r");
	fscanf(fp, "%*s %llu %llu %llu %llu %llu %llu %llu %llu %llu %llu", &a[0],
	       &a[1], &a[2], &a[3], &a[4], &a[5], &a[6], &a[7], &a[8], &a[9]);
	ull idle = a[3] + a[4], total = 0;
	for (int i = 0; i < 10; i++) total += a[i];
	while (1)
		printf("{\"text\": \"%.2f%%\", \"alt\": \"<span>%s</span> %.2fGHz "
		       "%.3g°C\"}\n",
		       cpu_usage_loop(fp, a, &idle, &total, 3),
		       power_profile(current_profile), cpu_clock(cpuinfo),
		       cpu_temp(zone));
	return 0;
}
