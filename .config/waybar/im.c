#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[]) {
	FILE *fp = popen("ibus engine", "r");
	char engine[30], buf[30], layout[5];
	// const char *color1[2] = {"#9cdcfe", "#f44747"};
	const char *color2[2] = {"#1E66F5", "#D20F39"};
	if (fp == NULL) printf("Error opening pipe!"), exit(1);
	else fscanf(fp, "%s", engine);
	fp = popen("setxkbmap -query", "r");
	if (fp == NULL) printf("Error opening pipe!"), exit(1);
	else
		while (fgets(buf, 30, fp) != NULL)
			if (strstr(buf, "layout") != NULL)
				sscanf(buf, "layout: %s", layout);
	fclose(fp);
	if (argc < 2) {
		if (!strcmp(engine, "BambooUs")) {
			printf("<span>EN</span>");
		} else if (!strcmp(engine, "Bamboo"))
			printf("<span color=\"%s\">VI</span>", color2[1]);
		else printf("%s", engine);
		printf(" ");
		if (!strcmp(layout, "us")) {
			printf("<span color=\"%s\">US</span>", color2[0]);
		} else if (!strcmp(layout, "jp")) {
			printf("<span>JP</span>");
		} else printf("%s", layout);
		printf("\n"), exit(0);
	} else if (argc == 2) {
		if (argv[1][0] == 'e') {
			if (!strcmp(engine, "BambooUs")) system("ibus engine Bamboo");
			else if (!strcmp(engine, "Bamboo")) system("ibus engine BambooUs");
		} else if (argv[1][0] == 'l') {
			if (!strcmp(layout, "us")) system("setxkbmap jp OADG109A");
			else if (!strcmp(layout, "jp")) system("setxkbmap us");
		} else if (!strcmp(argv[1], "nocolor")) {
			if (!strcmp(engine, "BambooUs")) printf("EN");
			else if (!strcmp(engine, "Bamboo")) printf("VI");
			else printf("%s", engine);
			printf(" ");
			if (!strcmp(layout, "us")) printf("US");
			else if (!strcmp(layout, "jp")) printf("JP");
			else printf("%s", layout);
		}
		exit(0);
	} else return 1;
}
