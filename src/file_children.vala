private void list_children (File file, Cancellable? cancellable = null) throws Error {
	FileEnumerator enumerator = file.enumerate_children (
		"standard::*",
		FileQueryInfoFlags.NOFOLLOW_SYMLINKS, 
		cancellable);

	FileInfo info = null;
	while (cancellable.is_cancelled () == false && ((info = enumerator.next_file (cancellable)) != null)) {
		if (info.get_file_type () == FileType.DIRECTORY && !info.get_is_hidden()) {
			File subdir = file.resolve_relative_path (info.get_name ());
			list_children (subdir, cancellable);
		} else {
			string name = info.get_name();
			print ("%s\n", name);

			if (name.contains(".")) {
				string ext = name.substring(name.last_index_of("."));
				print ("Extension: %s\n", ext[1:]);
			}
		}
	}

	if (cancellable.is_cancelled ()) {
		throw new IOError.CANCELLED ("Operation was cancelled");
	}
}
