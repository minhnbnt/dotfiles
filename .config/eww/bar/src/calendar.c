#include <stdio.h>
#include <time.h>
#include <unistd.h>

int main(void) {

	const char *day_of_week[] = { "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat" };

	const char *month[] = { "Jan", "Feb", "Mar", "Apr", "May", "Jun",
		                    "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" };

	time_t raw_time;
	struct tm *time_info;

	while (1) {

		time(&raw_time);
		time_info = localtime(&raw_time);

		printf("{ \"hour\": \"%02d\", \"minute\": \"%02d\", \"second\": \"%02d\",",
		       time_info->tm_hour, time_info->tm_min, time_info->tm_sec);

		printf(" \"tooltip\": \"%s, %d %s %d %02d:%02d:%02d\" }\n", day_of_week[time_info->tm_wday],
		       time_info->tm_mday, month[time_info->tm_mon], time_info->tm_year + 1900,
		       time_info->tm_hour, time_info->tm_min, time_info->tm_sec);

		fflush(stdout);
		sleep(1);
	}

	return 0;
}
