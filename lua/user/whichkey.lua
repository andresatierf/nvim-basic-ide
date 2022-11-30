local status_ok, whichkey = pcall(require, "which-key")
if not status_ok then
	return
end

local setup = {
	plugins = {
		marks = true, -- shows a list of your marks on ' and `
		registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
		spelling = {
			enabled = false, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
			suggestions = 20, -- how many suggestions should be shown in the list?
		},
		-- the presets plugin, adds help for a bunch of default keybindings in Neovim
		-- No actual key bindings are created
		presets = {
			operators = false, -- adds help for operators like d, y, ... and registers them for motion / text object completion
			motions = false, -- adds help for motions
			text_objects = false, -- help for text objects triggered after entering an operator
			windows = true, -- default bindings on <c-w>
			nav = true, -- misc bindings to work with windows
			z = true, -- bindings for folds, spelling and others prefixed with z
			g = true, -- bindings for prefixed with g
		},
	},
	-- add operators that will trigger motion and text object completion
	-- to enable all native operators, set the preset / operators plugin above
	operators = { gc = "Comments" },
	key_labels = {
		-- override the label used to display some keys. It doesn't effect WK in any other way.
		-- For example:
		-- ["<space>"] = "SPC",
		-- ["<cr>"] = "RET",
		-- ["<tab>"] = "TAB",
	},
	icons = {
		breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
		separator = "➜", -- symbol used between a key and it's label
		group = "+", -- symbol prepended to a group
	},
	popup_mappings = {
		scroll_down = "<c-d>", -- binding to scroll down inside the popup
		scroll_up = "<c-u>", -- binding to scroll up inside the popup
	},
	window = {
		border = "rounded", -- none, single, double, shadow
		position = "bottom", -- bottom, top
		margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
		padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
		winblend = 0,
	},
	layout = {
		height = { min = 4, max = 25 }, -- min and max height of the columns
		width = { min = 20, max = 50 }, -- min and max width of the columns
		spacing = 3, -- spacing between columns
		align = "left", -- align columns left, center or right
	},
	ignore_missing = false, -- enable this to hide mappings for which you didn't specify a label
	hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
	show_help = true, -- show help message on the command line when the popup is visible
	show_keys = true, -- show the currently pressed key and its label as a message in the command line
	triggers = "auto", -- automatically setup triggers
	-- triggers = {"<leader>"} -- or specify a list manually
	triggers_blacklist = {
		-- list of mode / prefixes that should never be hooked by WhichKey
		-- this is mostly relevant for key maps that start with a native binding
		-- most people should not need to change this
		i = { "j", "k" },
		v = { "j", "k" },
	},
	-- disable the WhichKey popup for certain buf types and file types.
	-- Disabled by default for Telescope
	disable = {
		buftypes = {},
		filetypes = { "TelescopePrompt" },
	},
}

local opts = {
	mode = "n", -- NORMAL mode
	prefix = "",
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = true, -- use `nowait` when creating keymaps
}

local mappings = {
  -- Windows
  --  Better window navigation
	["<C-h>"] = { "<C-w>h", "Go to left window" },
	["<C-j>"] = { "<C-w>j", "Go to down window" },
	["<C-k>"] = { "<C-w>k", "Go to up window" },
	["<C-l>"] = { "<C-w>l", "Go to right window" },
  -- Resize with arrows
	["<C-Left>"]  = { ":vertical resize -2<CR>", "Resize terminal left" },
	["<C-Down>"]  = { ":resize +2<CR>",          "Resize terminal down" },
	["<C-Up>"]    = { ":resize -2<CR>",          "Resize terminal up" },
	["<C-Right>"] = { ":vertical resize +2<CR>", "Resize terminal right" },
  -- Buffers
  -- Better buffer navigation
	["<S-l>"] = { ":bnext<CR>",     "Go to buffer to the right" },
	["<S-h>"] = { ":bprevious<CR>", "Go to buffer to the left" },
  -- Utils
	["<S-q>"] = { ":Bdelete!<CR>", "Close buffer" },
	["<S-r>"] = { ":e<CR>",        "Reload buffer" },

  --
	["<C-\\>"] = { "Open Terminal" },
	g = {
		name = "LSP goto",
		D = { "Goto declaration" },
		d = { "Goto definitions" },
		I = { "Goto implementation" },
		r = { "Goto references" },
		l = { "Open float" },
	},
	K = { "Hover" },
	["<leader>"] = {
    name = "Leader",
		h = { ":nohlsearch<CR>",                                               "Clear highlight" },
		e = { ":NvimTreeToggle<CR>",                                           "Toggle NvimTree" },
		r = { ":NvimTreeRefresh<CR>",                                          "Refresh NvimTree" },
		["/"] = { ":lua require('Comment.api').toggle_current_linewise()<CR>", "Toggle line comment" },
		d = {
			name = "DAP",
			b = { ":lua require('dap').toggle_breakpoint()<cr>", "Toggle breakpoint" },
			c = { ":lua require('dap').continue()<cr>",          "Continue" },
			i = { ":lua require('dap').step_into()<cr>",         "Step into" },
			o = { ":lua require('dap').step_over()<cr>",         "Step over" },
			O = { ":lua require('dap').step_out()<cr>",          "Step out" },
			r = { ":lua require('dap').repl.toggle()<cr>",       "Toggle repl" },
			l = { ":lua require('dap').run_last()<cr>",          "Run last" },
			u = { ":lua require('dapui').toggle()<cr>",          "Toggle DAP UI" },
			t = { ":lua require('dap').terminate()<cr>",         "Terminate" },
		},
		f = {
			name = "Telescope",
			f = { ":Telescope find_files<CR>",      "Find files" },
			t = { ":Telescope live_grep<CR>",       "Find text" },
			p = { ":Telescope projects<CR>",        "Find projects" },
			b = { ":Telescope buffers<CR>",         "Find buffers" },
			s = { ":Telescope possession list<CR>", "Find sessions" },
		},
		g = {
			name = "Git",
			g = { ":lua _LAZYGIT_TOGGLE()<CR>", "Toggle lazygit" },
      r = { ":Gitsigns reset_hunk", "Reset hunk" },
      R = { ":Gitsigns reset_buffer", "Reset buffer" },
			I = {
				name = "Issues",
				l = { ":Octo issue list states=OPEN<CR>", "List Issues" },
				c = { ":Octo issue create<CR>",           "Create Issue" },
				o = { ":Octo issue reopen<CR>",           "Re-open Issue" },
				x = { ":Octo issue close<CR>",            "Close Issue" },
				s = { ":Octo issue search<CR>",           "Search Issues" },
				b = { ":Octo issue browser<CR>",          "Open in browser" },
				y = { ":Octo issue url<CR>",              "Copy issue URL" },
			},
			P = {
				name = "Pull Requests",
				l = { ":Octo pr list states=OPEN<CR>", "List Pull Requests" },
				c = { ":Octo pr create<CR>",           "Create Pull Request" },
				o = { ":Octo pr reopen<CR>",           "Re-open Pull Request" },
				x = { ":Octo pr close<CR>",            "Close Pull Request" },
				s = { ":Octo pr search<CR>",           "Search Pull Request" },
				b = { ":Octo pr browser<CR>",          "Open in browser" },
				y = { ":Octo pr url<CR>",              "Copy issue URL" },
			},
		},
		l = {
			name = "LSP",
			f = { "Format code" },
			i = { "Lsp info" },
			I = { "Lsp install info" },
			a = { "Code action" },
			j = { "Goto next" },
			k = { "Goto previous" },
			r = { "Rename" },
			s = { "Signature help" },
			q = { "Set loc list" },
		},
	},
}

local vopts = {
	mode = "v", -- VISUAL mode
	prefix = "",
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = true, -- use `nowait` when creating keymaps
}

local vmappings = {
  -- Better paste
  p = { '"_dP', "which_key_ignore" },
  -- Stay in indent mode
  ["<"] = { "<gv", "which_key_ignore" },
  [">"] = { ">gv", "which_key_ignore" },
}


local iopts = {
	mode = "i", -- INSERT mode
	prefix = "",
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = true, -- use `nowait` when creating keymaps
}

local imappings = {
  -- Press jk fast to enter NORMAL mode
  ["jk"] = { "<ESC>", "Toggle multiline comment" },
}

local xopts = {
	mode = "x", -- VISUAL-BLOCK mode
	prefix = "",
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = true, -- use `nowait` when creating keymaps
}

local xmappings = {
  ["<leader>"] = {
	  ["/"] = { '<ESC>:lua require("Comment.api").toggle_linewise_op(vim.fn.visualmode())<CR>', "Toggle multiline comment" },
  },
}

whichkey.setup(setup)

whichkey.register(mappings, opts)
whichkey.register(vmappings, vopts)
whichkey.register(imappings, iopts)
whichkey.register(xmappings, xopts)
