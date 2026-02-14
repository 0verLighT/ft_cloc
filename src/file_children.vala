namespace Utils {
	public int ft_count_line(string file_contents) {
		int result = 0;
		unowned string ptr = file_contents;
		while (true) {
			int index = ptr.index_of_char ('\n');
			++result;
			if (index == -1)
				break;
			ptr = ptr.offset(index + 1);
		}
		return result;
	}
}


public class LangFile {
	private string Language;
	private int files;
	private int blank;
	private int comment;
	private int code;
	private int lines;

	public void add_file(string path) {
		string contents;
		FileUtils.get_contents(path, out contents);
		lines += Utils.ft_count_line (contents);
	}

	public void print() {
		stdout.printf("%-40s %-15d  %-15d %-15d %-15d\n", Language, files, blank, comment, code);
	}
}



class MyApplication {
	const string[] ext_file = {"vala", "c", "js", "ts", "meson.build"};

	// JSON ==> LangFile Object
	HashTable<string, LangFile> hash_lang = new HashTable<string, LangFile>(str_hash, str_equal);

	public MyApplication (string dir_work) {
		var file = File.new_for_commandline_arg(dir_work);
		list_children(file);
	}


	public void print_all() {
	print ("""
-------------------------------------------------------------------------------
Language                     files          blank        comment           code
-------------------------------------------------------------------------------""");
		foreach (var i in hash_lang.get_keys()) {
			print ("KEY %s\n", i);
			hash_lang[i].print();
		}
	}

	private void list_children (File file) throws Error {

		var enumerator = file.enumerate_children (
			"standard::name",
			FileQueryInfoFlags.NOFOLLOW_SYMLINKS
		);

		FileInfo info = null;
		int file_count = -1;
		
		while (((info = enumerator.next_file ()) != null)) {
			File child = file.get_child(info.get_name());
			string name = info.get_name();
			if (name.has_prefix(".") || info.get_is_hidden()) {
				continue;
			}
			if (info.get_file_type () == FileType.DIRECTORY) {
				File subdir = file.resolve_relative_path (info.get_name ());
				list_children (subdir);
			} else {
				if ("." in name) {
					unowned string ext = name.offset(name.last_index_of_char ('.') + 0);
					if (ext in ext_file) {
						if (!(ext in hash_lang)) {
							hash_lang[ext] = new LangFile();
						}
						hash_lang[ext].add_file(child.get_path());
						++file_count;
					}
				}
			}
		}
		/*
		if (file_count == -1) {
			print ("No code file in this directory :^(");
		} else {
			print ("Count of %s is %d\n", (file_count > 0) ? "files" : "file", file_count);
		}
		*/
	}
}





