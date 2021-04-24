import contextlib
import functools
import importlib
import os
import pathlib
import sys

import pynvim


def _path_without_virtualenv():
    """Filter out the currently active virtual environment from sys.path."""
    # Check for the VIRTUAL_ENV environment variable. If we are not in
    # a virtual environment, there is nothing to do.
    if (VIRTUAL_ENV := os.getenv('VIRTUAL_ENV')) is None:
        return sys.path

    # Neovim runs Python processes from a dedicated virtual environment.
    # We do not want to remove this virtual environment from the path.
    # We can work out if this virtual environment is the neovim virtual environment
    # by seeing if the current Python executable is located within it.
    if sys.executable.startswith(VIRTUAL_ENV):
        return sys.path

    return list(filter(lambda p: not p.startswith(VIRTUAL_ENV), sys.path))


@contextlib.contextmanager
def _patch_sys_path(new_path):
    """Briefly change sys.path, being careful to reset it once we're done."""
    old_path = sys.path[:]
    try:
        sys.path = new_path
        yield
    finally:
        sys.path = old_path


def _import_isort_api():
    """
    Try and import isort.api from the neovim virtualenv,
    and _not_ from the currently activated virtualenv.
    This requires a small number of shenanigans.
    """
    with _patch_sys_path(_path_without_virtualenv()):
        assert 'isort' not in sys.modules
        importlib.invalidate_caches()
        importlib.import_module('isort.api')
        return importlib.import_module('isort')


@pynvim.plugin
class Isort(object):
    var = 'isort_automatic'

    def __init__(self, vim):
        self.vim = vim

    @functools.cached_property
    def isort(self):
        """
        The isort module, with isort.api available.
        Equivalient to `import isort.api`.
        """
        try:
            return _import_isort_api()
        except ImportError as err:
            self.err_write(str(err) + "\n")
            return None

    @pynvim.command('Isort', nargs=0)
    @pynvim.function('Isort')
    def sort_current_buffer(self, was_automatic=False):
        if self.isort is None:
            self.vim.err_write("isort not found\n")
            return

        current_content = '\n'.join(self.vim.current.buffer[:])
        # output always has an extra newline appended. We can safely trim it

        if buffer_name := self.vim.current.buffer.name:
            file_path = pathlib.Path(buffer_name)
        else:
            file_path = None

        sorted_content = self.isort.api.sort_code_string(
            current_content,
            file_path=file_path,
            disregard_skip=not was_automatic,
        )

        # If sorting the file results in modifications...
        if current_content != sorted_content:
            # Update the buffer.
            self.vim.current.buffer[:] = sorted_content.split('\n')

    def is_automatic(self):
        if self.isort is None:
            return False

        scopes = [self.vim.current.buffer, self.vim.current.window,
                  self.vim.current.tabpage, self.vim]
        for scope in scopes:
            if self.var in scope.vars:
                return bool(scope.vars[self.var])
        return True  # Default to enabled

    @pynvim.autocmd('BufWrite', pattern='*.py', sync=True)
    def sort_if_automatic(self):
        if self.is_automatic():
            self.sort_current_buffer(was_automatic=True)
