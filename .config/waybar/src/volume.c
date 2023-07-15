#include <stdio.h>
#include <stdlib.h>
#include <string.h>

const char *get_icon(float vol) {
	if (vol < 0) return "";
	else if (vol < 33) return "";
	else if (vol < 66) return "";
	else return "";
}

float get_vol(void) {

	FILE *cmd = popen("pamixer --get-mute", "r");

	if (cmd == NULL) {
		fputs("Error: Failed to run pamixer\n", stderr);
		pclose(cmd), abort();
	}

	char mute_status = fgetc(cmd);
	pclose(cmd);

	if (mute_status == 't') return -1;

	float vol;
	cmd = popen("pamixer --get-volume", "r");
	fscanf(cmd, "%f", &vol), fclose(cmd);

	return vol;
}

void adjust(const char *arg) {
	if (strcmp(arg, "up") == 0) {
		system("pactl set-sink-volume @DEFAULT_SINK@ +5%");
	} else if (strcmp(arg, "down") == 0) {
		system("pactl set-sink-volume @DEFAULT_SINK@ -5%");
	} else if (strcmp(arg, "mute") == 0) {
		system("pactl set-sink-mute @DEFAULT_SINK@ toggle");
	}
}

int main(int argc, char *argv[]) {

	if (argc == 2) {
		adjust(argv[1]);
		return 0;
	} else if (argc > 2) {
		fputs("Error: Too many arguments\n", stderr);
		abort();
	}

	float vol = get_vol();

	if (vol != -1) {
		printf("%s %.0f%%\n", get_icon(vol), vol);
	} else puts("");

	return 0;
}
