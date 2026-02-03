private void list_children (File file, Cancellable? cancellable = null) throws Error {
	FileEnumerator enumerator = file.enumerate_children (
		"standard::name",
		FileQueryInfoFlags.NOFOLLOW_SYMLINKS, 
		cancellable
	);

	FileInfo info = null;
	File child = file.get_child(info.get_name());
	int64 file_count = 0;
	while (cancellable.is_cancelled () == false && ((info = enumerator.next_file (cancellable)) != null)) {
		if (info.get_file_type () == FileType.DIRECTORY && !info.get_is_hidden()) {
			File subdir = file.resolve_relative_path (info.get_name ());
			list_children (subdir, cancellable);
		} else {
			string name = info.get_name();
			print ("%s\n", name);

			if (name.contains(".c")) {
				string ext = name.substring(name.last_index_of("."));
				string contents;
				FileUtils.get_contents(child.get_path(), out contents);
				print ("%s\n", contents);
				print ("number of line is : %d\n", 0);
				print ("Extension: %s\n", ext[1:]);
				++file_count;
			}
		}
	}
	if (file_count == 0) {
		print ("No code file in this directory :^(");
	} else {
		print ("Count of %s is %lld", (file_count > 1) ? "files" : "file", file_count);
	}
	if (cancellable.is_cancelled ()) {
		throw new IOError.CANCELLED ("Operation was cancelled");
	}
}

