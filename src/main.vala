int	main(string[] args)
{
	if (args.length != 2)
	{
		print("ft_cloc <dir> or <file>\n");
		return (1);
	}

	File file = File.new_for_commandline_arg(args[1]);
	try {
		list_children (file, new Cancellable ());
	} catch (Error e) {
		print ("Error: %s\n", e.message);
		return 0;
	}
	return (0);
}
