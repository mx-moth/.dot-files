require('lspconfig')

local api = vim.api
local util = vim.lsp.util
local callbacks = vim.lsp.callbacks
local log = vim.lsp.log
local border = "single"

local opts = { noremap=true, silent=true }
-- Open diagnostic float with \d
vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, opts)

-- Go to previous/next diagnostics with [d/]d
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)

-- Override all floating windows to have borders
local _open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
	opts = opts or {}
	opts.border = opts.border or "rounded"
	return _open_floating_preview(contents, syntax, opts, ...)
end

local function goto_definition(split_cmd)
	local util = vim.lsp.util
	local log = require("vim.lsp.log")
	local api = vim.api

	-- note, this handler style is for neovim 0.5.1/0.6, if on 0.5, call with function(_, method, result)
	local handler = function(_, result, ctx)
		if result == nil or vim.tbl_isempty(result) then
			local _ = log.info() and log.info(ctx.method, "No location found")
			return nil
		end

		if split_cmd then
			vim.cmd(split_cmd)
		end

		if vim.tbl_islist(result) then
			util.jump_to_location(result[1])

			if #result > 1 then
				util.set_qflist(util.locations_to_items(result))
				api.nvim_command("copen")
				api.nvim_command("wincmd p")
			end
		else
			util.jump_to_location(result)
		end
	end

	return handler
end

vim.lsp.handlers["textDocument/definition"] = goto_definition('tabnew')

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


local exepathin = function(command, directory)
	if string.sub(directory, -1) ~= '/' then
		directory = directory .. '/'
	end
	path = vim.fn.exepath(command)
	if path ~= nil and string.sub(path, 0, #directory) == directory then
		return path
	else
		return nil
	end
end

local venv = os.getenv('VENV_DIR')
local in_virtual_env = venv ~= nil

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

-- If we are not in a virtual environment, activate ruff linting.
if not in_virtual_env and vim.uv.fs_stat(vim.g.python3_bin .. "/ruff") then
	require('lspconfig').ruff.setup({
		on_attach = on_attach,
		cmd = { vim.g.python3_bin .. "/ruff", "server" },
		init_options = {
			settings = {
				args = {},
			},
		},
	})
end

-- If we are in a virtual environment,
-- check which tools are available and activate them as necessary.
if in_virtual_env then
	ruff = exepathin('ruff', venv)
	if ruff ~= nil then
		ruff_version = vim.system({ruff, '--version'}, { text = true }):wait().stdout
		if not vim.version.lt(ruff_version, '0.5.3') then
			require('lspconfig').ruff.setup({
				on_attach = on_attach,
				cmd = { ruff, "server" }
			})
		else
			ruff_lsp = exepathin('ruff-lsp', venv)
			if ruff_lsp ~= nil then
				require('lspconfig').ruff_lsp.setup({
					on_attach = on_attach,
					cmd = { ruff_lsp },
				})
			end
		end
	end

	pylsp_plugins = pylsp_args['settings']['pylsp']['plugins']

	flake8 = exepathin('flake8', venv)
	if flake8 ~= nil then
		pylsp_args['configurationSources'] = { 'flake8' }
		pylsp_plugins['flake8'] = {
			enabled = true,
			executable = flake8,
		}
	else
		-- Maybe configure the above things?
	end

	isort = exepathin('isort', venv)
	if isort ~= nil then
		pylsp_plugins['pyls_isort'] = {
			enabled = true,
			executable = isort,
		}
	end

	mypy = exepathin('mypy', venv)
	if isort ~= nil then
		pylsp_plugins['pylsp_mypy'] = {
			enabled = true,
			executable = mypy,
			dmypy = true,
		}
	end
end

if #pylsp_args['settings']['pylsp']['plugins'] then
	require('lspconfig').pylsp.setup(pylsp_args)
end

if in_virtual_env then
	if vim.fn.executable('vscode-eslint-language-server') == 1 then
		require'lspconfig'.eslint.setup{}
	end
end
