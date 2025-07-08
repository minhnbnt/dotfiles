return {
	on_attach = function(client, bufnr)
		-- With `hotcodereplace = 'auto' the debug adapter will try to apply code changes
		-- you make during a debug session immediately.
		-- Remove the option if you do not want that.
		-- You can use the `JdtHotcodeReplace` command to trigger it manually
		require("jdtls.dap").setup_dap_main_class_configs()
		require("jdtls").setup_dap({ hotcodereplace = "auto" })
		require("jdtls.setup").add_commands()
	end,
	filetypes = { "java" },
	single_file_support = true,
	init_options = {
		bundles = { "/usr/share/java-debug/com.microsoft.java.debug.plugin.jar" },
		jvm_args = { "-Xmx1G" },
	},
	settings = {
		java = {
			signatureHelp = { enabled = true },
			contentProvider = { preferred = "fernflower" },
		},
	},
	cmd = { "/usr/share/java/jdtls/bin/jdtls" }, -- AUR package jdtls
	root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew" }),
	on_init = function(client)
		if not client.config.settings then
			return
		end
		client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
	end,
}
