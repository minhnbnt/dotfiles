#include <stdio.h>
#include <string.h>
#include <time.h>

int main(int argc, char *argv[]) {

	time_t raw_time = time(NULL);

	struct tm *time_info = localtime(&raw_time);

	if (argc == 2) {
		if (strcmp(argv[1], "hour") == 0) {
			printf("%02d\n", time_info->tm_hour);
		} else if (strcmp(argv[1], "minute") == 0) {
			printf("%02d\n", time_info->tm_min);
		} else if (strcmp(argv[1], "second") == 0) {
			printf("%02d\n", time_info->tm_sec);
		} else if (strcmp(argv[1], "date") == 0) {
			printf("%d\n", time_info->tm_mday);
		} else if (strcmp(argv[1], "month") == 0) {
			printf("%d\n", time_info->tm_mon);
		} else if (strcmp(argv[1], "year") == 0) {
			printf("%d\n", time_info->tm_year + 1900);
		} else {
			printf("Invalid argument\n");
		}
	}

	return 0;
}
