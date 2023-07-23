#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define battery "BAT0"

const char *plugged = "<span color='#CCD0DA'>\uf1e6</span>",
           *charging = "<span color='#E5C890'>\uf0e7</span>",
           *slash = "<span>\uf377</span>";

const char *full = "<span>\uf240</span>",
           *three_quarters = "<span>\uf241</span>",
           *half = "<span>\uf242</span>", *quarter = "<span>\uf243</span>";

void error(char *message) {
	fputs(message, stderr);
	abort();
}

float get_percentage(void) {

	FILE *fp = fopen("/sys/class/power_supply/" battery "/capacity", "r");
	if (fp == NULL) error("Error opening battery capacity file");

	int percentage;

	fscanf(fp, "%d", &percentage);
	fclose(fp);

	return percentage;
}

char *get_status(void) {
	FILE *fp = fopen("/sys/class/power_supply/" battery "/status", "r");
	if (fp == NULL) {
		return "Unknown";
	}
	char *status = calloc(20, sizeof(char));
	fgets(status, 20, fp), fclose(fp);
	strtok(status, "\n");
	return status;
}

const char *get_icon(float percentage, char *status) {
	if (strcmp(status, "Unknown") == 0) return slash;
	if (strcmp(status, "Charging") == 0) return charging;
	if (strcmp(status, "Not charging") == 0) return plugged;
	// discharging
	if (percentage >= 75) return full;
	if (percentage >= 50) return three_quarters;
	if (percentage >= 25) return half;
	return quarter;
}

int main(int argc, char *argv[]) {
	char *status = get_status();
	float percentage = get_percentage();
	printf("{ \"icon\": \"%s\", \"tooltip\": \"%s: %s, %.0f%%\" }\n",
	       get_icon(percentage, status), battery, get_status(),
	       get_percentage());
}
