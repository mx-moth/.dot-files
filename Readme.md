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

Configuring
-----------

### bash

Create a `~/.bashrd.local` file.
It will be sourced before all other files when starting the shell.
Common variables you might want to set include:

```bash
# If a system sets TMOUT, unset it
TMOUT_BUST=1

# Where to find a conda installation for this system
CONDA_ROOT=$HOME/.local/share/miniconda3

# Which editor to use
export EDITOR=nvim
export VISUAL=nvim
```

### git

Create a `~/.config/git/config.local` file.
Common settings you might want to include:

```ini
[user]
name = "Tim Heap"
email = "tim@example.com"
```

License
-------

All the work that I have done is released into the Public Domain. All works by
others are under the licence for that work. See each individual file for more
information regarding the works of others contained within.
