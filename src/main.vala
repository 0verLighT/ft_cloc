

int	main(string[] args)
{
	if (args.length != 2)
	{
		print("ft_cloc <dir> or <file>\n");
		return (1);
	}

	File file = File.new_for_commandline_arg(args[1]);

	return (0);
}
