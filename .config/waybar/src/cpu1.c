#include <stdio.h>
#include <string.h>
#include <unistd.h>

#define ZONE "thermal_zone1"

float cpu_temp(void);
float cpu_clock(void);
float cpu_usage(void);

// return class based on usage percentage
const char *class(float usage) {
	if (usage < 33) {
		return "low";
	} else if (usage < 66) {
		return "medium";
	} else return "high";
}

int main(int argc, char *argv[]) {

	while (1) {

		// avoid calling cpu_usage() twice
		float usage = cpu_usage();

		// JSON format for waybar
		printf("{ \"class\": \"%s\", \"percentage\": %.0f,"
		       " \"text\": \"%.2fGHz %.3g°C\" }\n",
		       class(usage), usage, cpu_clock(), cpu_temp());

		fflush(stdout); // flush stdout so output is printed immediately

		sleep(5); // sleep for usage update
	}

	return 0;
}

float cpu_temp(void) {

	float temp; // store temperature

	// read temp from /sys/class/thermal/<ZONE>/temp
	FILE *fp = fopen("/sys/class/thermal/" ZONE "/temp", "r");

	fscanf(fp, "%f", &temp); // read temp
	fclose(fp);              // close file

	// div by 1000 to convert to C
	return temp / 1000;
}

float cpu_clock(void) {

	char buf[100]; // buffer for line from /proc/cpuinfo

	// calculate average clock speed
	float sum = 0;     // sum of clock speeds
	unsigned core = 0; // number of cores

	// file pointer to /proc/cpuinfo
	FILE *fp = fopen("/proc/cpuinfo", "r");

	// read each line of /proc/cpuinfo
	while (fgets(buf, 100, fp) != NULL)
		// if line starts with "cpu MHz"
		if (strncmp(buf, "cpu MHz", 7) == 0) {

			float cpu_clock; // store clock speed

			// read clock speed from line
			sscanf(buf, "cpu MHz\t: %f", &cpu_clock);

			sum += cpu_clock; // add clock speed to sum
			++core;           // increment core count
		}

	fclose(fp); // close file pointer

	// div by 1000 to convert from MHz to GHz
	return sum / core / 1000;
}

float cpu_usage(void) {

	unsigned long long val[10];

	// read values from /proc/stat
	FILE *fp = fopen("/proc/stat", "r");

	fscanf(fp, "%*s"); // skip "cpu0"

	/* read values into array
	 * and calculate total and idle */
	__uint128_t idle, total = 0; // store idle and total
	for (int i = 0; i < 10; i++) {

		fscanf(fp, "%llu", &val[i]); // read value

		total += val[i]; // add to total
	}

	// idle = idle + iowait
	idle = val[3] + val[4];

	/* this variable is static so it retains its value between calls
	 * looks better than global variables, right? :p */
	static __uint128_t prev_idle = 0, prev_total = 0;
	// so first time this will not give correct value :0

	// calculate usage
	unsigned long idled = idle - prev_idle;
	unsigned long totald = total - prev_total;

	// update prev values for next call
	prev_idle = idle, prev_total = total;

	// return usage percentage
	return 100.0 * (totald - idled) / totald;
}
