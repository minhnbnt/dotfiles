#include <cstdio>
#include <cstring>
#include <fstream>
#include <sstream>
#include <string>
#include <vector>
// Linux headers
#include <arpa/inet.h>
#include <linux/wireless.h>
#include <sys/ioctl.h>
#include <unistd.h>

std::vector<std::string> get_interfaces(void) {

	std::vector<std::string> interfaces;
	std::ifstream ifs("/proc/net/dev");

	if (!ifs.is_open()) {
		perror("open /proc/net/dev");
		return interfaces;
	}

	ifs.ignore(256, '\n'), ifs.ignore(256, '\n');

	std::string line;

	while (std::getline(ifs, line)) {

		std::istringstream iss(line);
		std::string name;

		iss >> name, name.pop_back();

		interfaces.push_back(name);
	}

	return interfaces;
}

std::pair<std::string, bool> get_status(std::string iface) {

	if (iface == "lo") {

		int fd;
		struct ifreq ifr;

		fd = socket(AF_INET, SOCK_DGRAM, 0);

		ifr.ifr_addr.sa_family = AF_INET;

		strncpy(ifr.ifr_name, "lo", IFNAMSIZ - 1);

		ioctl(fd, SIOCGIFADDR, &ifr);

		close(fd);

		return { inet_ntoa(((struct sockaddr_in *)&ifr.ifr_addr)->sin_addr),
			     false };
	}

	struct iwreq wreq;
	memset(&wreq, 0, sizeof(struct iwreq));
	strcpy(wreq.ifr_name, iface.c_str());

	int sockfd = socket(AF_INET, SOCK_DGRAM, 0);
	char ssid[IW_ESSID_MAX_SIZE + 1] = { 0 };

	wreq.u.essid.pointer = ssid;
	wreq.u.essid.length = IW_ESSID_MAX_SIZE;

	if (ioctl(sockfd, SIOCGIWESSID, &wreq) != -1) {
		return std::make_pair(ssid, true);
	}

	// check if iface is ethernet
	std::string path = "/sys/class/net/" + iface + "/carrier";
	std::ifstream ifs(path);

	int carrier;
	ifs >> carrier;

	return carrier ? std::make_pair("ethernet", false)
	               : std::make_pair("disconnected", false);
}

int main(void) {

	const auto interfaces = get_interfaces();

	bool is_connected = false;
	bool is_wireless = false;

	printf("{ \"tooltip\": \"");

	for (unsigned i = 0; i < interfaces.size(); i++) {

		const std::string &iface = interfaces[i];

		if (i > 0) printf("\\n");

		auto status = get_status(iface);
		std::string ssid = status.first;

		if (ssid.empty()) continue;

		printf("%s: %s", iface.c_str(), ssid.c_str());

		if (iface == "lo" || ssid == "disconnected") continue;

		is_connected = true;
		if (status.second) is_wireless = true;
	}

	const char *icon = "", *widget_class = "net-disconnected";
	if (is_connected) {
		icon = is_wireless ? "" : "";
		widget_class = is_wireless ? "net-wireless" : "net-wired";
	}

	printf("\", \"icon\": \"%s\", \"class\": \"%s\" }", //
	       icon, widget_class);

	return 0;
}
