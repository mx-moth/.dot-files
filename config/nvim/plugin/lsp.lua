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
	local api = vim.api

	-- note, this handler style is for neovim 0.5.1/0.6, if on 0.5, call with function(_, method, result)
	local handler = function(err, result, ctx)
		if err ~= nil then
			return nil, err
		end

		if result == nil or vim.tbl_isempty(result) then
			log.info(ctx.method, "No location found")
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

vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('my-lsp', {}),
	callback = function(ev)
		local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))

		-- Enable completion triggered by <c-x><c-o>
		vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

		local bufopts = { noremap=true, silent=true, buffer=ev.buf }

		local go_to_first = function(options)
			if #(options.items) > 0 then
				vim.cmd.tabnew(options.items[1].filename)
				vim.fn['cursor'](options.items[1].lnum, options.items[1].col)
			end
		end
		vim.keymap.set('n', '<leader>d', function()
			vim.lsp.buf.definition({on_list = go_to_first})
		end, bufopts)
		-- vim.api.nvim_buf_set_keymap(ev.buf, 'n', '<leader>i', '<cmd>tab split | lua vim.lsp.buf.implementation()<CR>', opts)
		-- vim.api.nvim_buf_set_keymap(ev.buf, 'n', '<leader>k', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
		-- vim.api.nvim_buf_set_keymap(ev.buf, 'n', '<leader><C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
		-- vim.api.nvim_buf_set_keymap(ev.buf, 'n', '<leader>f', '<cmd>lua vim.lsp.buf.format()<CR>', opts)


		-- Mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		vim.keymap.set('n', '<leader>D', vim.lsp.buf.declaration, bufopts)
		-- vim.keymap.set('n', '<leader>d', vim.lsp.buf.definition, bufopts)
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
	end,
})


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
	vim.lsp.config('ruff', {
		on_attach = on_attach,
		cmd = { vim.g.python3_bin .. "/ruff", "server" },
		init_options = {
			settings = {
				args = {},
			},
		},
	})
	vim.lsp.enable('ruff')
end

-- If we are in a virtual environment,
-- check which tools are available and activate them as necessary.
if in_virtual_env then
	ruff = exepathin('ruff', venv)
	if ruff ~= nil then
		vim.lsp.config('ruff', {
			on_attach = on_attach,
			cmd = { ruff, "server" }
		})
		vim.lsp.enable('ruff')
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

vim.lsp.config('pylsp', pylsp_args)
vim.lsp.enable('pylsp')

if in_virtual_env then
	if vim.fn.executable('vscode-eslint-language-server') == 1 then
		vim.lsp.enable('eslint')
	end
end
