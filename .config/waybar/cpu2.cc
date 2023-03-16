#include <fstream>
#include <iostream>
#include <string>
#include <unistd.h>

float cpu_clock() {
	std::ifstream cpuinfo("/proc/cpuinfo");
	std::string line;
	float clock = 0;
	int cores = 0;
	while (std::getline(cpuinfo, line))
		if (line.find("cpu MHz") != std::string::npos) {
			clock += std::stof(line.substr(line.find(":") + 2));
			cores++;
			break;
		};
	return clock / cores / 1000;
}

float cpu_usage() {
	long long a[10], prevtotal = 0, previdle;
	std::ifstream cpuinfo("/proc/stat");
	cpuinfo.ignore(256, ' ');
	for (int i = 0; i < 10; i++)
		cpuinfo >> a[i], prevtotal += a[i];
	previdle = a[3] + a[4];
	sleep(1), cpuinfo.clear(), cpuinfo.seekg(0);
	cpuinfo.ignore(256, ' ');
	long long total = 0, idle;
	for (int i = 0; i < 10; i++)
		cpuinfo >> a[i], total += a[i];
	idle = a[3] + a[4];
	cpuinfo.close();
	total -= prevtotal, idle -= previdle;
	return (total - idle) * 100.0 / total;
}

int main() {
	std::cout << cpu_clock() << " " << cpu_usage() << std::endl;
	return 0;
}
