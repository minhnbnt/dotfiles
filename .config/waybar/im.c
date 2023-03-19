#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[]) {
	FILE *fp = popen("ibus engine", "r");
	char engine[30], buf[30], layout[5];
	if (fp == NULL) printf("Error opening pipe!");
	else fscanf(fp, "%s", engine);
	fp = popen("setxkbmap -query", "r");
	if (fp == NULL) printf("Error opening pipe!");
	else
		while (fgets(buf, 30, fp) != NULL)
			if (strstr(buf, "layout") != NULL)
				sscanf(buf, "layout: %s", layout);
	fclose(fp);
	if (argc < 2) {
		if (strcmp(engine, "BambooUs") == 0) {
			printf("<span>EN</span>");
		} else if (!strcmp(engine, "Bamboo"))
			printf("<span color=\"#f44747\">VI</span>");
		else printf("%s", engine);
		printf(" ");
		if (!strcmp(layout, "us")) {
			printf("<span color=\"#9cdcfe\">US</span>");
		} else if (!strcmp(layout, "jp")) {
			printf("<span>JP</span>");
		} else printf("%s", layout);
		printf("\n");
		return 0;
	} else if (argc == 2) {
		if (argv[1][0] == 'e') {
			if (!strcmp(engine, "BambooUs")) system("ibus engine Bamboo");
			else if (!strcmp(engine, "Bamboo")) system("ibus engine BambooUs");
		} else if (argv[1][0] == 'l') {
			if (!strcmp(layout, "us")) system("setxkbmap jp OADG109A");
			else if (!strcmp(layout, "jp")) system("setxkbmap us");
		}
	} else return 1;
	return 0;
}
