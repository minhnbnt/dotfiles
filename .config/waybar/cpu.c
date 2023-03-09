#include <stdio.h>
#include <string.h>
#include <unistd.h>

char *power_profile() {
	// take output of command
	FILE *fp = popen("powerprofilesctl get ", "r");
	char buf[100];
	fgets(buf, 100, fp);
	if (!strncmp(buf, "balanced", 8))
		return "&#xf24e;";
	else if (strncmp(buf, "performance", 11) == 0)
		return "&#xf0e4;";
	else if (strncmp(buf, "power-save", 10) == 0)
		return "&#xf06c;";
	else
		return "error";
}

float cpu_clock() {
	FILE *fp = fopen("/proc/cpuinfo", "r");
	char buf[100];
	int cnt = 0;
	float cpu_clock, sum = 0;
	while (fgets(buf, 100, fp))
		if (strncmp(buf, "cpu MHz", 7) == 0) {
			sscanf(buf, "cpu MHz\t: %f", &cpu_clock);
			cnt++;
			sum += cpu_clock;
		}
	fclose(fp);
	return sum / cnt / 1000;
}

float cpu_usage() {
	long long int a[10];
	FILE *fp = fopen("/proc/stat", "r");
	fscanf(fp, "%*s %lld %lld %lld %lld %lld %lld %lld %lld %lld %lld", &a[0],
		   &a[1], &a[2], &a[3], &a[4], &a[5], &a[6], &a[7], &a[8], &a[9]);
	fclose(fp);
	long long int previdle = a[3] + a[4], pretotal = 0;
	for (int i = 0; i < 10; i++)
		pretotal += a[i];
	sleep(1);
	fp = fopen("/proc/stat", "r");
	fscanf(fp, "%*s %lld %lld %lld %lld %lld %lld %lld %lld %lld %lld", &a[0],
		   &a[1], &a[2], &a[3], &a[4], &a[5], &a[6], &a[7], &a[8], &a[9]);
	fclose(fp);
	long long int idle = a[3] + a[4], total = 0;
	for (int i = 0; i < 10; i++)
		total += a[i];
	long long totald = total - pretotal, idled = idle - previdle;
	return (float)(totald - idled) / totald * 100;
}

int main() {
	float clock = cpu_clock();
	float usage = cpu_usage();
	printf("<span>%s</span> %.2fGHz %.2f%%\n", power_profile(), clock, usage);
	return 0;
}
