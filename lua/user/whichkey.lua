local status_ok, whichkey = pcall(require, "which-key")
if not status_ok then
	return
end

local setup = {
	plugins = {
		marks = true,                                                                -- shows a list of your marks on ' and `
		registers = true,                                                            -- shows your registers on " in NORMAL or <C-r> in INSERT mode
		spelling = {
			enabled = false,                                                            -- enabling this will show WhichKey when pressing z= to select spelling suggestions
			suggestions = 20,                                                           -- how many suggestions should be shown in the list?
		},
    -- the presets plugin, adds help for a bunch of default keybindings in Neovim
    -- No actual key bindings are created
		presets = {
			operators = false,                                                          -- adds help for operators like d, y, ... and registers them for motion / text object completion
			motions = false,                                                            -- adds help for motions
			text_objects = false,                                                       -- help for text objects triggered after entering an operator
			windows = true,                                                             -- default bindings on <c-w>
			nav = true,                                                                 -- misc bindings to work with windows
			z = true,                                                                   -- bindings for folds, spelling and others prefixed with z
			g = true,                                                                   -- bindings for prefixed with g
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
		breadcrumb = "»",                                                            -- symbol used in the command line area that shows your active key combo
		separator = "➜",                                                             -- symbol used between a key and it's label
		group = "+",                                                                 -- symbol prepended to a group
	},
	popup_mappings = {
		scroll_down = "<c-d>",                                                       -- binding to scroll down inside the popup
		scroll_up = "<c-u>",                                                         -- binding to scroll up inside the popup
	},
	window = {
		border = "rounded",                                                          -- none, single, double, shadow
		position = "bottom",                                                         -- bottom, top
		margin = { 1, 0, 1, 0 },                                                     -- extra window margin [top, right, bottom, left]
		padding = { 2, 2, 2, 2 },                                                    -- extra window padding [top, right, bottom, left]
		winblend = 0,
	},
	layout = {
		height = { min = 4, max = 25 },                                              -- min and max height of the columns
		width = { min = 20, max = 50 },                                              -- min and max width of the columns
		spacing = 3,                                                                 -- spacing between columns
		align = "left",                                                              -- align columns left, center or right
	},
	ignore_missing = false,                                                       -- enable this to hide mappings for which you didn't specify a label
	hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
	show_help = true,                                                             -- show help message on the command line when the popup is visible
	show_keys = true,                                                             -- show the currently pressed key and its label as a message in the command line
	triggers = "auto",                                                            -- automatically setup triggers
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
	mode    = "n",  -- NORMAL mode
	prefix  = "",
	buffer  = nil,  -- Global mappings. Specify a buffer number for buffer local mappings
	silent  = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait  = true, -- use `nowait` when creating keymaps
}

local mappings = {
  -- Windows
  --  Better window navigation
	["<C-h>"]     = { "<C-w>h",                  "Go to left window" },
	["<C-j>"]     = { "<C-w>j",                  "Go to bottom window" },
	["<C-k>"]     = { "<C-w>k",                  "Go to top window" },
	["<C-l>"]     = { "<C-w>l",                  "Go to right window" },
  -- Resize with arrows
	["<C-Left>"]  = { ":vertical resize -2<CR>", "Resize terminal left" },
	["<C-Down>"]  = { ":resize +2<CR>",          "Resize terminal down" },
	["<C-Up>"]    = { ":resize -2<CR>",          "Resize terminal up" },
	["<C-Right>"] = { ":vertical resize +2<CR>", "Resize terminal right" },
  -- Buffers
  -- Better buffer navigation
	["<S-l>"] = { ":BufferLineCycleNext<CR>", "Go to buffer to the right" },
	["<S-h>"] = { ":BufferLineCyclePrev<CR>", "Go to buffer to the left" },
  ["}"]     = { ":BufferLineMoveNext<CR>",  "Move buffer right" },
  ["{"]     = { ":BufferLineMovePrev<CR>",  "Move buffer left" },
  -- Utils
	["<S-q>"] = { ":Bdelete!<CR>",            "Close buffer" },
	["<S-r>"] = { ":e<CR>",                   "Reload buffer" },
  -- Code
  -- Better code navigation
	["<C-d>"] = { "<C-d>zz", "Navigate down half page" },
	["<C-u>"] = { "<C-u>zz", "Navigate up half page" },
  n         = { "nzz",     "Next match" },
  N         = { "Nzz",     "Previous match" },


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
    a = {
      name = "Align",
      a = {
        function()
          local a = require('align')
          a.operator(
            a.align_to_char,
            { length = 1, reverse = true, }
          )
        end,
        "Aligns motion to 1 character, looking left",
      },
      s = {
        function()
          local a = require('align')
          a.operator(
            a.align_to_char,
            { length = 2, reverse = true, preview = true, }
          )
        end,
        "Aligns motion to 2 characters, looking left and with previews" },
      w = {
        function()
          local a = require('align')
          a.operator(
            a.align_to_string,
            { is_pattern = false, reverse = true, preview = true, }
          )
        end,
        "Aligns motion to string, looking left",
      },
      r = {
        function()
          local a = require('align')
          a.operator(
            a.align_to_string,
            { is_pattern = true, reverse = true, preview = true, }
          )
        end,
        "Aligns motion to a Lua pattern, looking left and with previews" },
    },
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
      r = { ":Gitsigns reset_hunk<CR>", "Reset hunk" },
      R = { ":Gitsigns reset_buffer<CR>", "Reset buffer" },
			i = {
				name = "Issues",
				n = { ":Octo issue create<CR>",           "Create issue" },
				l = { ":Octo issue list states=OPEN<CR>", "List issues" },
				s = { ":Octo issue search<CR>",           "Search issues" },
			},
			p = {
				name = "Pull Requests",
				n = { ":Octo pr create<CR>",           "Create pull request" },
				l = { ":Octo pr list states=OPEN<CR>", "List pull requests" },
				s = { ":Octo pr search<CR>",           "Search pull request" },
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
	mode    = "v",  -- VISUAL mode
	prefix  = "",
	buffer  = nil,  -- Global mappings. Specify a buffer number for buffer local mappings
	silent  = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait  = true, -- use `nowait` when creating keymaps
}

local vmappings = {
  -- Better paste
  p =     { '"_dP', "which_key_ignore" },
  -- Stay in indent mode
  ["<"] = { "<gv",  "which_key_ignore" },
  [">"] = { ">gv",  "which_key_ignore" },
}


local iopts = {
	mode    = "i",  -- INSERT mode
	prefix  = "",
	buffer  = nil,  -- Global mappings. Specify a buffer number for buffer local mappings
	silent  = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait  = true, -- use `nowait` when creating keymaps
}

local imappings = {
  -- Press jk fast to enter NORMAL mode
  ["jk"] = { "<ESC>", "Toggle multiline comment" },
}

local xopts = {
	mode    = "x",  -- VISUAL-BLOCK mode
	prefix  = "",
	buffer  = nil,  -- Global mappings. Specify a buffer number for buffer local mappings
	silent  = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait  = true, -- use `nowait` when creating keymaps
}

local xmappings = {
  ["<leader>"] = {
	  ["/"] = { "<ESC>:lua require('Comment.api').toggle_linewise_op(vim.fn.visualmode())<CR>", "Toggle multiline comment" },
    a = {
      name = "Align",
      a = { function() require('align').align_to_char(1, true) end,              "Aligns to 1 character, looking left" },
      s = { function() require('align').align_to_char(2, true, true) end,        "Aligns to 2 characters, looking left and with previews" },
      w = { function() require('align').align_to_string(false, true, true) end,  "Aligns to a string, looking left and with previews" },
      r = { function() require('align').align_to_string(true, true, true) end,   "Aligns to a Lua pattern, looking left and with previews" },
    },
  },
}

whichkey.setup(setup)

whichkey.register(mappings, opts)
whichkey.register(vmappings, vopts)
whichkey.register(imappings, iopts)
whichkey.register(xmappings, xopts)

-- Set keybinds in octo pages
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "octo" },
  callback = function()
    local octoopts = {
      mode    = "n",  -- NORMAL mode
      prefix  = "<leader>",
      buffer  = 0,    -- Global mappings. Specify a buffer number for buffer local mappings
      silent  = true, -- use `silent` when creating keymaps
      noremap = true, -- use `noremap` when creating keymaps
      nowait  = true, -- use `nowait` when creating keymaps
    }

    local octomappings = {
      g = {
        name = "Git",
        i = {
          name = "Issues",
          x = { ":lua require('octo.mappings').close_issue()<CR>",     "Close issue" },
          o = { ":lua require('octo.mappings').reopen_issue()<CR>",    "Re-open issue" },
          e = { ":Octo issue edit<CR>",                                "Edit issue" },
          r = { ":lua require('octo.mappings').reload()<CR>",          "Reload issue" },
          b = { ":lua require('octo.mappings').open_in_browser()<CR>", "Open in browser" },
          y = { ":lua require('octo.mappings').copy_url()<CR>",        "Copy issue URL" },
          g = {
            name = "Goto",
            f = { ":lua require('octo.mappings).goto_file()<CR>",      "Go to file" },
            i = { ":lua require('octo.mappings).goto_issue()<CR>",     "Go to issue" },
          },
        },
        p = {
          name = "Pull Requests",
          x = { ":lua require('octo.mappings').close_issue()<CR>",                   "Close pull request" },
          o = { ":lua require('octo.mappings').reopen_issue()<CR>",                  "Re-open pull request" },
          e = { ":Octo pr edit<CR>",                                                 "Edit pull request" },
          r = { ":lua require('octo.mappings').reload()<CR>",                        "Reload pull request" },
          b = { ":lua require('octo.mappings').open_in_browser()<CR>",               "Open in browser" },
          y = { ":lua require('octo.mappings').copy_url()<CR>",                      "Copy issue URL" },
          g = {
            name = "Goto",
            f = { ":lua require('octo.mappings').goto_file()<CR>",                   "Go to file" },
            i = { ":lua require('octo.mappings').goto_issue()<CR>",                  "Go to issue" },
          },
          c = {
            name = "Changes",
            c = { ":lua require('octo.mappings').list_commits()<CR>",                "List PR commits" },
            f = { ":lua require('octo.mappings').list_changed_files()<CR>",          "List PR changed files" },
            d = { ":lua require('octo.mappings').show_pr_diff()<CR>",                "Show PR diff" },
          },
          ["<space>"] = { ":lua require('octo.mappings').checkout_pr()<CR>",         "Checkout PR" },
          m =           { ":lua require('octo.mappings').merge_pr()<CR>",            "Merge PR" },
          s =           { ":lua require('octo.mappings').squash_and_merge_pr()<CR>", "Squash and merge PR" },
        },
        r = {
          name = "Review",
          c = { ":lua require('octo.mappings').close_review_tab()<CR>", "Close review tab" },
          g = {
            name = "Goto",
            i = { ":lua require('octo.mappings').goto_issue()<CR>",     "Go to issue" },
          },
          a = { ":lua require('octo.mappings').approve_review()<CR>",   "Submit review - Approve" },
          m = { ":lua require('octo.mappings').comment_review()<CR>",   "Submit review - Comment" },
          r = { ":lua require('octo.mappings').request_changes()<CR>",  "Submit review - Request changes" },
        },
        u = {
          name = "Assign users",
          a = {
            name = "Assignees",
            a = { ":lua require('octo.mappings').add_assignee()<CR>",    "Add assignee" },
            d = { ":lua require('octo.mappings').remove_assignee()<CR>", "Remove assignee" },
          },
          r = {
            name = "Reviewers",
            a = { ":lua require('octo.mappings').add_reviewer()<CR>",    "Add reviewer" },
            d = { ":lua require('octo.mappings').remove_reviewer()<CR>", "Remove reviewer" },
          },
        },
        c = {
          name = "Comments",
          -- Comments/Sugestions
          a =     { ":lua require('octo.mappings').add_comment()<CR>",       "Add comment" },
          s =     { ":lua require('octo.mappings').add_sugestion()<CR>",     "Add sugestion" },
          d =     { ":lua require('octo.mappings').delete_comment()<CR>",    "Delete comment" },
          n =     { ":lua require('octo.mappings').next_comment()<CR>",      "Next comment" },
          N =     { ":lua require('octo.mappings').prev_comment()<CR>",      "Previous comment" },
          -- Reactions
          p =     { ":lua require('octo.mappings').react_horray()<CR>",      "Add/remove 🎉 reaction" },
          h =     { ":lua require('octo.mappings').react_heart()<CR>",       "Add/remove ❤️  reaction" },
          e =     { ":lua require('octo.mappings').react_eyes()<CR>",        "Add/remove 👀 reaction" },
          ["+"] = { ":lua require('octo.mappings').react_thumbs_up()<CR>",   "Add/remove 👍 reaction" },
          ["-"] = { ":lua require('octo.mappings').react_thumbs_down()<CR>", "Add/remove 👎 reaction" },
          r =     { ":lua require('octo.mappings').react_rocket()<CR>",      "Add/remove 🚀 reaction" },
          l =     { ":lua require('octo.mappings').react_laugh()<CR>",       "Add/remove 😄 reaction" },
          c =     { ":lua require('octo.mappings').react_confused()<CR>",    "Add/remove 😕 reaction" },
        },
        l = {
          name = "Labels",
          c = { ":lua require('octo.mappings').create_label()<CR>", "Create label" },
          a = { ":lua require('octo.mappings').add_label()<CR>",    "Add label" },
          d = { ":lua require('octo.mappings').remove_label()<CR>", "Remove label" },
        },
        -- issue = { -- DONE
        -- },
        -- pull_request = { -- DONE
        -- },
        -- review_thread = {
        --   select_next_entry = { lhs = "]q", desc = "move to previous changed file" },
        --   select_prev_entry = { lhs = "[q", desc = "move to next changed file" },
        -- },
        -- submit_win = { -- DONE
        -- },
        -- review_diff = {
        --   add_review_comment = { lhs = "<space>ca", desc = "add a new review comment" },
        --   add_review_suggestion = { lhs = "<space>sa", desc = "add a new review suggestion" },
        --   focus_files = { lhs = "<leader>e", desc = "move focus to changed file panel" },
        --   toggle_files = { lhs = "<leader>b", desc = "hide/show changed files panel" },
        --   next_thread = { lhs = "]t", desc = "move to next thread" },
        --   prev_thread = { lhs = "[t", desc = "move to previous thread" },
        --   select_next_entry = { lhs = "]q", desc = "move to previous changed file" },
        --   select_prev_entry = { lhs = "[q", desc = "move to next changed file" },
        --   close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
        --   toggle_viewed = { lhs = "<leader><space>", desc = "toggle viewer viewed state" },
        -- },
        -- file_panel = {
        --   next_entry = { lhs = "j", desc = "move to next changed file" },
        --   prev_entry = { lhs = "k", desc = "move to previous changed file" },
        --   select_entry = { lhs = "<cr>", desc = "show selected changed file diffs" },
        --   refresh_files = { lhs = "R", desc = "refresh changed files panel" },
        --   focus_files = { lhs = "<leader>e", desc = "move focus to changed file panel" },
        --   toggle_files = { lhs = "<leader>b", desc = "hide/show changed files panel" },
        --   select_next_entry = { lhs = "]q", desc = "move to previous changed file" },
        --   select_prev_entry = { lhs = "[q", desc = "move to next changed file" },
        --   close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
        --   toggle_viewed = { lhs = "<leader><space>", desc = "toggle viewer viewed state" },
        -- }
      },
    }
    whichkey.register(octomappings, octoopts)
  end,
})
