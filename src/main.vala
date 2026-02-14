
int	main(string[] args)
{
	if (args.length != 2)
	{
		print("ft_cloc <dir> or <file>\n");
		return (1);
	}

	var hash = new HashTable<string, bool>(str_hash, str_equal);

	hash["meson.build"] = true;
	hash["c"] = true;


	var app = new MyApplication(args[1]);
	app.print_all();

	// var file = File.new_for_commandline_arg(args[1]);
	// try {
		// list_children (file);
	// } catch (Error e) {
		// printerr ("Error: %s\n", e.message);
		// return 0;
	// }
	return (0);
}
