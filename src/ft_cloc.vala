using Config;

public class LangFile {
	public string language;

	public int files {get; private set; default = 0;} 
	public int blank {get; private set; default = 0;} 
	public int comment {get; private set; default = 0;} 
	public int code {get; private set; default = 0;} 

	public LangFile(string name) {
		this.language = name;
	}

	public void add_file(string path) {
		this.files++;
		string contents;
		try {
			FileUtils.get_contents(path, out contents);
			analyze(contents);
		} catch (Error e) {
			stderr.printf("Error: %s\n", e.message);
		}
	}

	private void analyze(string content) {
		foreach (unowned string line in content.split("\n")) {
			string trimmed = line.strip();
			if (trimmed.length == 0) {
				blank++;
			} else if (trimmed.has_prefix("//") || trimmed.has_prefix("/*") || trimmed.has_prefix("*") || trimmed.has_prefix("#")) {
				comment++;
			} else {
				code++;
			}
		}
	}

	public void print_stats() {
		stdout.printf("%-15s %-10d %-10d %-10d %-10d\n", language, files, blank, comment, code);
	}
}

class MyApplication {
	private HashTable<string, string> lang;
	private HashTable<string, LangFile> hash_lang;
	private void init_language() {
		this.lang = new HashTable<string, string>(str_hash, str_equal);

		this.lang["c"] = "C";
		this.lang["h"] = "Header (.h)";
		this.lang["vala"] = "Vala";
		this.lang["py"] = "Python";
		this.lang["js"] = "Javascript";
		this.lang["ts"] = "Typescript";
		this.lang["cpp"] = "C++";
		this.lang["hpp"] = "C++";
		this.lang["nix"] = "Nix";
		this.lang["yml"] = "YAML";
		this.lang["json"] = "JSON";
		this.lang["makefile"] = "Makefile";
		this.lang["meson.build"] = "Meson";
		this.lang["html"] = "HTML";
		this.lang["css"] = "CSS";
		this.lang["scss"] = "Sass/SCSS";
		this.lang["php"] = "PHP";
		this.lang["jsx"] = "React (JSX)";
		this.lang["tsx"] = "React (TSX)";
		this.lang["vue"] = "Vue.js";
		this.lang["rs"] = "Rust";
		this.lang["go"] = "Go";
		this.lang["java"] = "Java";
		this.lang["cs"] = "C#";
		this.lang["rb"] = "Ruby";
		this.lang["swift"] = "Swift";
		this.lang["kt"] = "Kotlin";
		this.lang["dart"] = "Dart";
		this.lang["sh"] = "Shell (Bash)";
		this.lang["bash"] = "Shell (Bash)";
		this.lang["ps1"] = "PowerShell";
		this.lang["pl"] = "Perl";
		this.lang["lua"] = "Lua";
		this.lang["md"] = "Markdown";
		this.lang["toml"] = "TOML";
		this.lang["xml"] = "XML";
		this.lang["sql"] = "SQL";
		this.lang["ini"] = "Configuration (INI)";
		this.lang["conf"] = "Configuration";
		this.lang["dockerfile"] = "Docker";
	}

	public MyApplication(string dir_work) {
		this.hash_lang = new HashTable<string, LangFile>(str_hash, str_equal);
		this.init_language();
		File root = File.new_for_commandline_arg(dir_work);
		try {
			list_children(root);
		} catch (Error e) {
			stderr.printf("Error scanning: %s\n", e.message);
		}
	}

	public void print_all() {
		print ("""
----------------------------------------------------------------------
Language        Files      Blank      Comment    Code
----------------------------------------------------------------------
""");
		int total_files = 0;
		int total_blank = 0;
		int total_comment = 0;
		int total_code = 0;
		foreach (unowned LangFile langfile in hash_lang.get_values()) {
			langfile.print_stats();
			total_files += langfile.files;
			total_blank += langfile.blank;
			total_comment += langfile.comment;
			total_code += langfile.code;
		}
		print("----------------------------------------------------------------------\n");
		print("%-15s %-10d %-10d %-10d %-10d\n", "Total", total_files, total_blank, total_comment, total_code);
	}

	private void list_children(File dir) throws Error {
		var enumerator = dir.enumerate_children(
			"standard::name,standard::type,standard::is-hidden",
			FileQueryInfoFlags.NOFOLLOW_SYMLINKS
		);

		FileInfo info;
		while ((info = enumerator.next_file()) != null) {
			string name = info.get_name();
			File child = dir.get_child(name);

			if (name.has_prefix(".") || info.get_is_hidden()) 
				continue;

			if (info.get_file_type() == FileType.DIRECTORY) {
				list_children(child);
			} else {
				string? format_name = null;
				string	lower_name = name.down();
				if (lower_name in this.lang) {
					format_name = this.lang[lower_name];
				}
				else if ("." in name) {
					unowned string ext = name.offset(name.last_index_of_char ('.') + 1);
					if (this.lang.contains(ext)) {
						format_name = this.lang[ext];
					}
				}
				if (format_name != null) {
					if (!this.hash_lang.contains(format_name)) {
						this.hash_lang.set(format_name, new LangFile(format_name));
					}
					this.hash_lang.get(format_name).add_file(child.get_path());
				}   
			}
		}
	}
}


int	main(string[] args)
{
	if (args.length != 2)
	{
		print("ft_cloc <dir> or <file>\n");
		return (1);
	}
	if (args[1] == "-v" || args[1] == "--version")
	{
		print("ft_cloc version : %s\n", Config.PROJECT_VERSION);
		return (0);
	}
	var app = new MyApplication(args[1]);
	app.print_all();
	return (0);
}
