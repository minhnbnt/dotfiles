SOURCE_DIR := $(PWD)/bar/src
TARGET_DIR := $(PWD)/bar/bin

install:
	cc -O3 $(SOURCE_DIR)/battery.c -o $(TARGET_DIR)/battery
	cc -O3 $(SOURCE_DIR)/calendar.c -o $(TARGET_DIR)/calendar
	cc -O3 $(SOURCE_DIR)/volume.c -o $(TARGET_DIR)/volume
	c++ -O3 $(SOURCE_DIR)/network.cc -o $(TARGET_DIR)/network
	c++ -O3 -o $(TARGET_DIR)/eww_power_dialog \
		$(shell pkg-config --cflags --libs gtkmm-3.0)\
		$(SOURCE_DIR)/dialog.cc
	rustc -O $(SOURCE_DIR)/workspace.rs -o $(TARGET_DIR)/workspace
