`.dot-files`
============

The configuration files for programs I often use.

Installing
----------

Just clone, set up the submodules, and link in the files

	$ cd
	$ git clone https://bitbucket.org/tim_heap/.dot-files.git
	$ cd .dot-files
	$ git submodule update --init
	$ ./create-links

The script `create-links` will create links to the files in your home
directory. It will back up any existing files first, so you can always roll
back to what you have. It will delete any symlinks already there.

License
-------

All the work that I have done is released into the Public Domain. All works by
others are under the licence for that work. See each individual file for more
information regarding the works of others contained within.
