#include <chrono>
#include <cstdio>
#include <fstream>
#include <string>
#include <thread>
#include <vector>

#define ZONE "thermal_zone1"

float cpu_temp(void);
float cpu_clock(void);
float cpu_usage(void);

const char *module_class(float usage) {
	if (usage < 33) {
		return "low";
	}
	if (usage < 66) {
		return "medium";
	}
	return "high";
}

inline void json_output(void) {

	const float usage = cpu_usage();

	printf("{ \"class\": \"%s\", \"percentage\": %.0f,"
	       " \"text\": \"%.2fGHz %.3g°C\" }\n",
	       module_class(usage), usage, cpu_clock(), cpu_temp());
}

inline void text_output(void) {
	printf("%.3g%% %.2fGHz %.0f°C\n", //
	       cpu_usage(), cpu_clock(), cpu_temp());
}

int main(int argc, char *argv[]) {

	// no buffering on stdout
	std::ios_base::sync_with_stdio(false);

	while (true) {

		using namespace std::chrono;
		using namespace std::chrono_literals;

		static auto time = system_clock::now();

		time += 5s;

		json_output();

		fflush(stdout);

		std::this_thread::sleep_until(time);
	}

	return 0;
}

float cpu_clock(void) {

	std::string line;
	std::ifstream ifs("/proc/cpuinfo");

	float sum = 0;
	unsigned cores = 0;

	while (std::getline(ifs, line)) {

		const size_t pos = line.find("cpu MHz");

		if (pos == std::string::npos) {
			continue;
		}

		sum += std::stof(line.substr(pos + 10));

		++cores;
	}

	return sum / cores / 1000.0;
}

float cpu_temp(void) {

	std::ifstream ifs("/sys/class/thermal/" ZONE "/temp");

	float temp;
	ifs >> temp;

	return temp / 1000.0;
}

float cpu_usage(void) {

	using u128 = __uint128_t;
	using u64 = unsigned long long;

	static u128 prev_total = 0, prev_idle = 0;

	std::ifstream ifs("/proc/stat");
	ifs.ignore(8, ' ');

	unsigned long vals[10];

	u128 total = 0, idle;
	for (int i = 0; i < 10; i++) {
		ifs >> vals[i];
		total += vals[i];
	}

	idle = vals[3] + vals[4];

	const u64 idled = idle - prev_idle;
	const u64 totald = total - prev_total;

	prev_total = total, prev_idle = idle;

	return 100.0 * (totald - idled) / totald;
}
