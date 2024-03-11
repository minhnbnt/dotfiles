// -o ../bin/eww_power_dialog $(pkg-config --cflags --libs gtkmm-3.0) dialog.cc

#include <cstdlib>
#include <string>
// GTK+ 3 header files
#include <gtkmm/main.h>
#include <gtkmm/messagedialog.h>

class ConfirmDialog : private Gtk::MessageDialog {

	const std::string command;

public:

	ConfirmDialog(const std::string &title, const std::string &message, const std::string &command)
	    : Gtk::MessageDialog(title, false, Gtk::MESSAGE_INFO, Gtk::BUTTONS_YES_NO),
	      command(command) {

		this->set_secondary_text(message);
	}

	void wait_for_response(void) {

		const int response = this->run();

		if (response == Gtk::RESPONSE_YES) {
			system(command.c_str());
		}
	}
};

int main(int argc, char *argv[]) {

	std::string title, message, command;
	for (int i = 1; i < argc; ++i) {

		const std::string arg(argv[i]);

		if (arg == "-t") {
			++i, title = argv[i];
			continue;
		}
		if (arg == "-m") {
			++i, message = argv[i];
			continue;
		}
		if (arg == "-c") {
			++i, command = argv[i];
		}
	}

	Gtk::Main kit(argc, argv);

	ConfirmDialog dialog(title, message, command);

	dialog.wait_for_response();

	return 0;
}
