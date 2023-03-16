#include <fstream>
#include <iostream>
#include <string>
#include <unistd.h>

float cpu_clock() {
	// open /proc/cpuinfo
	std::ifstream cpuinfo("/proc/cpuinfo");
	std::string line;
	float clock = 0;
	int cores = 0;
	while (std::getline(cpuinfo, line))
		if (line.find("cpu MHz") != std::string::npos) {
			clock += std::stof(line.substr(line.find(":") + 2));
			cores++;
			break;
		}
	return clock / cores;
}

float cpu_usage() {
	long long a[10], prevtotal = 0, previdle;
	std::ifstream cpuinfo("/proc/stat");
	for (int i = 0; i < 10; i++) {
		cpuinfo >> a[i];
		prevtotal += a[i];
	}
	previdle = a[3] + a[4];
}
