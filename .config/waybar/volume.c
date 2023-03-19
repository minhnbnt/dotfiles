#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[]) {
	if (argc < 2) {
		FILE *cmd = popen("pamixer --get-mute", "r");
		if (cmd == NULL) {
			printf("Error opening pipe!"), fclose(cmd), exit(1);
		} else {
			char mute_status;
			fgets(&mute_status, 2, cmd);
			if (mute_status == 't') printf("\n");
			else {
				int vol;
				cmd = popen("pamixer --get-volume", "r");
				fscanf(cmd, "%d", &vol), fclose(cmd);
				if (!vol) printf("");
				else if (vol < 33) printf("");
				else if (vol < 66) printf("");
				else printf("");
				printf(" %d%%\n", vol), exit(0);
			}
		}
	} else if (argc == 2) {
		if (strcmp(argv[1], "up") == 0) system("pamixer -i 5");
		else if (strcmp(argv[1], "down") == 0) system("pamixer -d 5");
		else if (strcmp(argv[1], "mute") == 0) system("pamixer -t");
	} else return 1;
}
