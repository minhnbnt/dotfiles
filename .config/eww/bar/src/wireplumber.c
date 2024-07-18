#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define ID "@DEFAULT_AUDIO_SINK@"

float get_volume(char *mute_status) {

	float vol;
	FILE *cmd = popen("wpctl get-volume " ID, "r");
	fscanf(cmd, "Volume: %f %s", &vol, mute_status);

	pclose(cmd);

	return 100 * vol;
}

const char *get_icon(float vol) {
	if (vol == 0) return "";
	if (vol < 33) return "";
	if (vol < 66) return "";
	return "";
}

int main(int argc, char *argv[]) {

	if (argc == 2) {

		float vol = atof(argv[1]) / 100;
		char *command = calloc(50, sizeof(char));

		sprintf(command, "wpctl set-volume %s %f", ID, vol);
		system(command);

		return 0;
	}

	char *mute_status = calloc(10, sizeof(char));
	float vol = get_volume(mute_status);

	if (strcmp(mute_status, "[MUTED]") == 0) {
		printf("{ \"icon\": \"\", \"vol\": \"%.0f\", \"muted\": true,"
		       " \"tooltip\": \"Volume: muted\" }\n",
		       vol);
		return 0;
	}

	printf("{ \"icon\": \"%s\", \"vol\": \"%.0f\", \"muted\": false,"
	       " \"tooltip\": \"Volume: %.0f%%\"} \n",
	       get_icon(vol), vol, vol);

	return 0;
}
