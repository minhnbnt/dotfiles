#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[]) {
	if (argc < 2) {
		FILE *fp = popen("amixer get Capture", "r");
		char buf[60], status[10];
		int vol;
		while (fgets(buf, 60, fp) != NULL)
			if (strstr(buf, "Front Left: Capture") != NULL) {
				char *p = strstr(buf, "[");
				if (p != NULL) {
					p++;
					char *q = strstr(p, "%]");
					if (q != NULL) {
						sscanf(q + 3, "%s", status);
						*q = '\0';
						sscanf(p, "%d", &vol);
					}
				}
			}
		fclose(fp);
		if (strstr(status, "on") != NULL)
			printf(" %d%%", vol);
		else
			printf("");
		printf("\n");
	} else if (argc == 2) {
		if (strcmp(argv[1], "mute") == 0)
			system("amixer set Capture toggle");
		else if (strcmp(argv[1], "up") == 0)
			system("amixer set Capture 5%+");
		else if (strcmp(argv[1], "down") == 0)
			system("amixer set Capture 5%-");
	}
}
