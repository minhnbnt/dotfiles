#include <stdio.h>
#include <stdlib.h>
#include <string.h>

float get_vol(void) {

	float vol;
	FILE *cmd = popen("pamixer --get-volume", "r");
	fscanf(cmd, "%f", &vol), fclose(cmd);

	return vol;
}

const char *get_icon(float vol) {
	if (vol == 0) return "";
	else if (vol < 33) return "";
	else if (vol < 66) return "";
	else return "";
}

int main(void) {

	float vol = get_vol();

	char mute[5];

	FILE *cmd = popen("pamixer --get-mute", "r");

	fgets(mute, 5, cmd), fclose(cmd);

	if (mute[0] == 't') {
		printf("{ \"icon\": \"\", \"vol\": \"%.0f\", \"muted\": true,"
		       " \"tooltip\": \"Volume: muted\" }\n",
		       vol);
		return 0;
	}

	printf("{ \"icon\": \"%s\", \"vol\": \"%.0f\","
	       " \"muted\": false, \"tooltip\": \"Volume: %.0f%%\"} \n",
	       get_icon(vol), vol, vol);

	return 0;
}
