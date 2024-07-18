#include <fstream>
#include <iostream>
#include <string>
#include <tuple>

std::tuple<float, float, std::string> get_memory_info() {
	const std::string unit[] = { "kB", "MB", "GB", "TB" };
	std::ifstream ifs("/proc/meminfo");
	std::string line;
	double mem_total, mem_free;
	while (std::getline(ifs, line)) {
		if (line.find("MemTotal") != std::string::npos)
			sscanf(line.c_str(), "MemTotal:\t%lf kB", &mem_total);
		else if (line.find("MemFree") != std::string::npos) {
			sscanf(line.c_str(), "MemFree:\t%lf kB", &mem_free);
			break;
		}
	}
	unsigned unit_index = 0;
	while (mem_total > 1000) {
		mem_total /= 1024;
		mem_free /= 1024;
		unit_index++;
	}
	return std::make_tuple(mem_total, mem_free, unit[unit_index]);
}

int main(int argc, char *argv[]) {
	std::tuple<float, float, std::string> mem_info = get_memory_info();
	float mem_total = std::get<0>(mem_info);
	float mem_free = std::get<1>(mem_info);
	float usage = (mem_total - mem_free) / mem_total * 100;
	std::cout.precision(3);
	if (argc == 2) {
		std::string arg = argv[1];
		if (arg == "usage") {
			std::cout << usage << std::endl;
		}
		return 0;
	}
	std::cout << mem_total - mem_free << "/" << mem_total << " "
	          << std::get<2>(mem_info) << " (" << usage << "%)" << std::endl;
	return 0;
}
