require('lspconfig')

local api = vim.api
local util = vim.lsp.util
local callbacks = vim.lsp.callbacks
local log = vim.lsp.log

local opts = { noremap=true, silent=true }
-- Open diagnostic float with \d
vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, opts)

-- Go to previous/next diagnostics with [d/]d
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)


-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
	-- Mappings.
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	local go_to_first = function(options)
		if #(options.items) > 0 then
			vim.cmd.tabnew(options.items[1].filename)
			vim.fn['cursor'](options.items[1].lnum, options.items[1].col)
		end
	end
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>d', '', {
		noremap = true,
		silent = true,
		callback = function()
			vim.lsp.buf.definition({on_list = go_to_first})
		end
	})
	-- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>i', '<cmd>tab split | lua vim.lsp.buf.implementation()<CR>', opts)
	-- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>k', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
	-- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader><C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
	-- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>f', '<cmd>lua vim.lsp.buf.format()<CR>', opts)

	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

	-- Mappings.
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	local bufopts = { noremap=true, silent=true, buffer=bufnr }
	vim.keymap.set('n', '<leader>D', vim.lsp.buf.declaration, bufopts)
	vim.keymap.set('n', '<leader>d', vim.lsp.buf.definition, bufopts)
	vim.keymap.set('n', '<leader>k', vim.lsp.buf.hover, bufopts)
	vim.keymap.set('n', '<leader>K', vim.lsp.buf.signature_help, bufopts)
	vim.keymap.set('n', '<leader>i', vim.lsp.buf.implementation, bufopts)

	vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
	vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
	vim.keymap.set('n', '<leader>wl', function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, bufopts)

	vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
	vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
	vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, bufopts)
end


-- Defaults for pylsp
-- This disables all linting by default,
-- specific linters will be enabled if they are found in the virtual environment.
local pylsp_args = {
	cmd = { vim.g.python3_bin .. "/pylsp", "-vv" },
	on_attach = on_attach,
	settings = {
		pylsp = {
			plugins = {
				autopep8 = { enabled = false },
				flake8 = { enabled = false },
				pyls_isort = { enabled = false },
				mccabe = { enabled = false },
				pylsp_mypy = { enabled = false },
				pycodestyle = { enabled = false },
				pyflakes = { enabled = false },
				yapf = { enabled = false },
			},
		},
	},
}

local virtual_env = os.getenv('VIRTUAL_ENV')
local venv = os.getenv('VENV_DIR')
local in_virtual_env = virtual_env ~= nil or venv ~= nill

-- If we are not in a virtual environment, activate ruff linting.
-- If we are in a virtual environment,
-- check which tools are available and activate them as necessary.
if not in_virtual_env or vim.fn.executable('ruff') == 1 then
	require('lspconfig').ruff_lsp.setup({
		on_attach = on_attach,
		cmd = { vim.g.python3_bin .. "/ruff-lsp" },
		init_options = {
			settings = {
				args = {},
			},
		},
	})
end

if in_virtual_env then
	pylsp_plugins = pylsp_args['settings']['pylsp']['plugins']

	if vim.fn.executable('flake8') == 1 then
		pylsp_args['configurationSources'] = { 'flake8' }
		pylsp_plugins['flake8'] = {
			enabled = true,
		}
	else
		-- Maybe configure the above things?
	end

	if vim.fn.executable('isort') == 1 then
		pylsp_plugins['pyls_isort'] = {
			enabled = true,
		}
	end

	if vim.fn.executable('mypy') == 1 then
		pylsp_plugins['pylsp_mypy'] = {
			enabled = true,
			dmypy = true,
		}
	end
end

require('lspconfig').pylsp.setup(pylsp_args)
