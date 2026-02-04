private void list_children (File file, Cancellable? cancellable = null) throws Error {
	FileEnumerator enumerator = file.enumerate_children (
		"standard::name",
		FileQueryInfoFlags.NOFOLLOW_SYMLINKS, 
		cancellable
	);
	string[] ext_file = {"vala", "c", "js", "ts", "meson.build"};
	FileInfo info = null;
	int file_count = 0;
	int file_line = 0;
	
	while (cancellable.is_cancelled () == false && ((info = enumerator.next_file (cancellable)) != null)) {
		File child = file.get_child(info.get_name());
		string name = info.get_name();
		if (name.has_prefix(".") || info.get_is_hidden()) {
			continue;
		}
		if (info.get_file_type () == FileType.DIRECTORY) {
			File subdir = file.resolve_relative_path (info.get_name ());
			list_children (subdir, cancellable);
		} else {
			if (name.contains(".")) {
				string ext = name.substring(name.last_index_of("."));
				if (ext[1:] in ext_file) {
					string contents;
					FileUtils.get_contents(child.get_path(), out contents);
					file_line = contents.split("\n").length;
//					print ("number of line is : %d\n", file_line);
					file_line = 0;
					print ("Extension: %s\n", ext[1:]);
					++file_count;
				}
			}
		}
	}
	/*
	if (file_count == 0) {
		print ("No code file in this directory :^(");
	} else {
		print ("Count of %s is %d\n", (file_count > 1) ? "files" : "file", file_count);
	}
	*/
	if (cancellable.is_cancelled ()) {
		throw new IOError.CANCELLED ("Operation was cancelled");
	}
}

