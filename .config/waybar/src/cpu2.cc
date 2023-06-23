// containers
#include <string>
#include <vector>

// sleep
#include <chrono>
#include <thread>

// i can't use format in <iostream>
#include <cstdio>

// file streams
#include <fstream>

// define thermal zone here
#define ZONE "thermal_zone1"

/* forward declarations
 * these are defined at the bottom of the file */
float cpu_temp(void);
float cpu_clock(void);
float cpu_usage(void);

void json_output(void) {
	// for waybar clickable module :D
	printf("{ \"text\": \"%.3g%%\", \"alt\": \"%.2fGHz %.0f°C\" }\n",
	       cpu_usage(), cpu_clock(), cpu_temp());
}

void text_output(void) {
	printf("%.3g%% %.2fGHz %.0f°C\n", // just print the values
	       cpu_usage(), cpu_clock(), cpu_temp());
}

int main(int argc, char *argv[]) {

	// no buffering on stdout
	std::ios_base::sync_with_stdio(false);

	while (true) {

		// get current time when we start
		static auto time = std::chrono::system_clock::now();

		// increment time by 5 second
		time += std::chrono::seconds(5);

		json_output(); // print output

		fflush(stdout); // flush stdout to ensure output is print

		// make sure we sleep until the next 5 second mark
		std::this_thread::sleep_until(time);
	}

	return 0;
}

float cpu_clock(void) {

	// temp variables
	std::string line, find = "cpu MHz";

	// read cpuinfo from /proc/cpuinfo
	std::ifstream ifs("/proc/cpuinfo");

	// calculate average clock speed
	float sum = 0;      // sum of clock speeds
	unsigned cores = 0; // number of cores

	while (std::getline(ifs, line)) { // read all lines
		// find line containing "cpu MHz"
		std::size_t pos = line.find(find);

		if (pos != std::string::npos) { // if found

			// add clock speed to sum
			sum += std::stof(line.substr(pos + find.size() + 4));

			++cores; // increment core count
		}
	}

	ifs.close(); // close file

	// div by 1000 to convert from MHz to GHz
	return sum / cores / 1000.0;
}

float cpu_temp(void) {

	float temp; // store temp here

	// read temp from /sys/class/thermal/<ZONE>/temp
	std::ifstream ifs("/sys/class/thermal/" ZONE "/temp");

	ifs >> temp; // read temp
	ifs.close(); // close file

	// convert from millidegrees to degrees
	return temp / 1000.0;
}

float cpu_usage(void) {

	std::vector<unsigned long long> vals(10);

	/* this variable is static so it retains its value between calls
	 * looks better than global variables or references, right? :p */
	static __uint128_t prev_total = 0, prev_idle = 0;
	// so first time this will not give correct value :0

	// read values from /proc/stat
	std::ifstream ifs("/proc/stat");

	// ignore cpu_ words
	ifs.ignore(8, ' ');

	/* read values into array
	 * and calculate total and idle */
	__uint128_t total = 0, idle;
	for (int i = 0; i < 10; i++) {
		ifs >> vals[i];
		total += vals[i];
	}
	// idle = idle + iowait
	idle = vals[3] + vals[4];

	ifs.close();  // close file
	vals.clear(); // clear vector

	// calculate usage
	size_t idled = idle - prev_idle;
	size_t totald = total - prev_total;

	// update prev values for next call
	prev_total = total, prev_idle = idle;

	// return usage percentage
	return 100.0 * (totald - idled) / totald;
}
