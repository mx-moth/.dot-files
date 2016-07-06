import neovim
from isort import SortImports


@neovim.plugin
class Isort(object):
    var = 'isort_automatic'

    def __init__(self, vim):
        self.vim = vim

    @neovim.command('Isort', nargs=0)
    @neovim.function('Isort')
    def sort_current_buffer(self):
        current_buffer = '\n'.join(self.vim.current.buffer[:])
        # output always has an extra newline appended. We can safely trim it
        sorted = SortImports(file_contents=current_buffer).output[:-1]

        # If sorting the file results in modifications...
        if current_buffer != sorted:
            # Update the buffer.
            self.vim.current.buffer[:] = sorted.split('\n')

    def is_automatic(self):
        vim = self.vim
        scopes = [self.vim.current.buffer, self.vim.current.window,
                  self.vim.current.tabpage, vim]
        for scope in scopes:
            if self.var in scope.vars:
                return bool(scope.vars[self.var])
        return True  # Default to enabled

    @neovim.autocmd('BufWrite', pattern='*.py', sync=True)
    def sort_if_automatic(self):
        if self.is_automatic():
            self.sort_current_buffer()
