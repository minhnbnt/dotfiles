#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// compile: gcc -o im im.c -lX11 -lX11-xkb
#define _USE_XKB 0

const char *color[] = { "#1E66F5", "#D20F39" };

void switch_layout(const char *layout) {
	if (!strcmp(layout, "us")) {
		system("setxkbmap jp OADG109A");
	}
	if (!strcmp(layout, "jp")) {
		system("setxkbmap us");
	}
}

void switch_engine(const char *engine) {
	if (!strcmp(engine, "BambooUs")) {
		system("ibus engine Bamboo");
	}
	if (!strcmp(engine, "Bamboo")) {
		system("ibus engine BambooUs");
	}
}

#ifdef _USE_XKB

#include <X11/XKBlib.h>
#include <X11/extensions/XKBrules.h>

const char *getxkb_map(void) {

	Display *dpy = XOpenDisplay(NULL);

	if (dpy == NULL) {
		fputs("Cannot open display", stdout);
		exit(1);
	}

	XkbStateRec state;
	XkbGetState(dpy, XkbUseCoreKbd, &state);

	XkbRF_VarDefsRec vd;
	XkbRF_GetNamesProp(dpy, NULL, &vd);

	XCloseDisplay(dpy);

	char *tok = strtok(vd.layout, ",");
	for (int i = 0; i < state.group; i++) {
		tok = strtok(NULL, ",");
		if (tok == NULL) exit(1);
	}

	return tok;
}

#else // _USE_XKB

const char *getxkb_map(void) {

	FILE *fp = popen("setxkbmap -query", "r");

	char *layout = (char *)calloc(8, sizeof(char)), buf[30];

	while (fgets(buf, 30, fp) != NULL)

		if (strstr(buf, "layout") != NULL) {
			sscanf(buf, "layout: %s", layout);
		}

	pclose(fp);

	return layout;
}

#endif // _USE_XKB

const char *getibus_engine(void) {

	FILE *fp = popen("ibus engine", "r");

	if (fp == NULL) {
		fputs("Cannot open pipe", stdout);
		exit(1);
	}

	char *engine = (char *)calloc(32, sizeof(char));
	fscanf(fp, "%s", engine);

	pclose(fp);

	return engine;
}

int main(int argc, char *argv[]) {

	const char *layout = getxkb_map();
	const char *engine = getibus_engine();

	if (argc > 1) {

		if (argv[1][0] == 'e') {
			switch_engine(engine);
		} else if (argv[1][0] == 'l') {
			switch_layout(layout);
		}
	} else {

		if (!strcmp(engine, "BambooUs")) {
			printf("<span>EN </span>");
		} else if (!strcmp(engine, "Bamboo"))
			printf("<span color=\"%s\">VI </span>", color[1]);
		else if (strlen(engine) > 0) printf("%s ", engine);

		if (!strcmp(layout, "us")) {
			printf("<span color=\"%s\">US</span>", color[0]);
		} else if (!strcmp(layout, "jp")) {
			printf("<span>JP</span>");
		} else printf("%s ", layout);

		putchar('\n');
	}
	free((char *)layout);
	return 0;
}
