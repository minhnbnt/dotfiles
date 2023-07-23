#include <stdio.h>
#include <time.h>

int main(void) {

	time_t raw_time = time(NULL);
	struct tm *time_info = localtime(&raw_time);

	printf("{ \"hour\": \"%02d\", \"minute\": \"%02d\", \"second\": \"%02d\", "
	       "\"day\": \"%d\", \"month\": \"%d\", \"year\": \"%d\" }\n",
	       time_info->tm_hour, time_info->tm_min, time_info->tm_sec,
	       time_info->tm_mday, time_info->tm_mon + 1,
	       time_info->tm_year + 1900);

	return 0;
}
