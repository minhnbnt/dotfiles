// -o ../bin/eww_power_dialog $(pkg-config --cflags --libs gtkmm-3.0) dialog.cc

#include <cstdlib>
#include <string>
// GTK+ 3 header files
#include <gtkmm/main.h>
#include <gtkmm/messagedialog.h>

int main(int argc, char *argv[]) {

	std::string title, message, command;
	for (int i = 1; i < argc; ++i) {
		if (std::string(argv[i]) == "-t") {
			++i, title = argv[i];
			continue;
		}
		if (std::string(argv[i]) == "-m") {
			++i, message = argv[i];
			continue;
		}
		if (std::string(argv[i]) == "-c") {
			++i, command = argv[i];
			continue;
		}
	}

	Gtk::Main kit(argc, argv);

	Gtk::MessageDialog dialog(title, 0, Gtk::MESSAGE_INFO, Gtk::BUTTONS_YES_NO);

	dialog.set_secondary_text(message);

	int response = dialog.run();

	if (response == Gtk::RESPONSE_YES) {
		system(command.c_str());
	}

	return 0;
}
