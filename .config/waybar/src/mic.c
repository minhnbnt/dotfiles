#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[]) {
	if (argc < 2) {
		FILE *fp = popen("amixer get Capture", "r");
		char buf[60], status = 0;
		int vol;
		while (fgets(buf, 60, fp) != NULL)
			if (strstr(buf, "Front Left: Capture") != NULL) {
				char *p = strstr(buf, "[");
				if (strstr(buf, "[on]") != NULL) status = 1;
				if (p != NULL) sscanf(++p, "%d", &vol);
			}
		pclose(fp);
		if (status) printf(" %d%%\n", vol);
		else printf("\n");
		return 0;
	} else if (argc == 2) {
		if (!strcmp(argv[1], "mute")) system("amixer set Capture toggle");
		else if (!strcmp(argv[1], "up")) system("amixer set Capture 5%+");
		else if (!strcmp(argv[1], "down")) system("amixer set Capture 5%-");
		else return 1;
	} else return 1;
}
