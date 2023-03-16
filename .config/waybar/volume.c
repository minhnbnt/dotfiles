#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

int main(int argc, char *argv[]) {
	if (argc < 2) {
		FILE *mute = popen("pamixer --get-mute", "r");
		char mute_status;
		if (mute == NULL) {
			printf("Error opening pipe!");
			fclose(mute);
			return 1;
		} else {
			fgets(&mute_status, 2, mute);
			fclose(mute);
			if (mute_status == 't') {
				printf("\n");
			} else {
				int vol;
				FILE *volume = popen("pamixer --get-volume", "r");
				fscanf(volume, "%d", &vol);
				fclose(volume);
				if (vol == 0)
					printf("");
				else if (vol < 33)
					printf("");
				else if (vol < 66)
					printf("");
				else
					printf("");
				printf(" %d%%\n", vol);
			}
		}
	} else if (argc == 2) {
		if (strcmp(argv[1], "up") == 0)
			system("pamixer -i 5");
		else if (strcmp(argv[1], "down") == 0)
			system("pamixer -d 5");
		else if (strcmp(argv[1], "mute") == 0)
			system("pamixer -t");
	}
}
