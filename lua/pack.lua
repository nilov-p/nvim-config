vim.pack.add({
  "https://github.com/mason-org/mason.nvim",
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/mason-org/mason-lspconfig.nvim",
  "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
  "https://github.com/nvim-mini/mini.nvim",
  "https://www.github.com/nvim-tree/nvim-tree.lua",
  {
    src = "https://github.com/nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
  },
  "https://github.com/tpope/vim-fugitive",
  "https://www.github.com/ibhagwan/fzf-lua",
  "https://github.com/MeanderingProgrammer/render-markdown.nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/nvim-lualine/lualine.nvim",
  "https://github.com/obsidian-nvim/obsidian.nvim"
})

require("nvim-tree").setup({
  filters = {
		dotfiles = false
	},
})

-- Mini nvim config start

local MiniFiles = require("mini.files")
MiniFiles.setup({
    mappings = {
        go_in = "<CR>",
        go_in_plus = "L",
        go_out = "_",
        go_out_plus = "H",
    },
})

vim.keymap.set("n", "-", "<cmd>lua MiniFiles.open()<CR>", { desc = "Toggle mini file explorer" })
vim.keymap.set("n", "<leader>-", function()
    MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
    MiniFiles.reveal_cwd()
end, { desc = "Toggle into currently opened file" })

require("mini.notify").setup({
	-- only show messages
    content = {
        format = function(notif)
            return notif.msg
        end,
    },
})

require("mini.pairs").setup({})

require("mini.cmdline").setup({
    autocorrect = { enable = false }
})

require('mini.icons').setup()
require("mini.surround").setup()
-- Default Keymaps
-- | `sa` | Add surrounding or Direct with 'saiw' |
-- | `sd` | Delete surrounding |
-- | `sr` | Replace surrounding |
-- | `sf` | Find surrounding (right) |
-- | `sF` | Find surrounding (left) |
-- | `sh` | Highlight surrounding |
-- | `sn` | Update n_lines |
-- | `l` / `n` | as suffix for prev/next |


require("mini.completion").setup({
    lsp_completion = {
        auto_setup = true,
    }
})

require("mini.comment").setup({
  mappings = {
    comment = "gc",
    comment_line = "gcc",
    comment_visual = "gc",
    textobject = "gc",
  },
})

local MiniDiff = require("mini.diff")
MiniDiff.setup({
	source = MiniDiff.gen_source.git({ index = false }),
})

local MiniTrailspace = require("mini.trailspace")
MiniTrailspace.setup()

vim.api.nvim_create_autocmd("BufWritePre", {
    callback = function()
        MiniTrailspace.trim()
    end,
})
-- Mini nvim config end

vim.keymap.set("n", "<leader>gg", "<cmd>tabnew | Git | only<cr>", { desc = "Fugitive Full Page New Tab" })
vim.keymap.set("n", "<leader>gd", "<cmd>Gvdiffsplit<CR>", { desc = "Git diff split", })
vim.keymap.set("n", "<leader>gc", require("fzf-lua").git_branches, { desc = "Fzf-lua checkout branch" })
vim.keymap.set("n", "<leader>gb", "<cmd>Git blame<CR>", { desc = "Git blame sidebar" })

require("lualine").setup({
	options = {
		icons_enabled = true,
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		globalstatus = false, -- keep per-window active/inactive styling
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { { "branch", icon = "\u{e725}" } }, -- nf-dev-git_branch
		lualine_c = { { "filename", path = 0 } },
		lualine_x = {
			function()
				local size = vim.fn.getfsize(vim.fn.expand("%"))
				if size < 0 then
					return ""
				elseif size < 1024 then
					return size .. "B"
				elseif size < 1024 * 1024 then
					return string.format("%.1fK", size / 1024)
				else
					return string.format("%.1fM", size / 1024 / 1024)
				end
			end,
			{ "filetype", icon_only = false },
		},
		lualine_y = { "location" }, -- %l:%c equivalent
		lualine_z = { "progress" }, -- %P equivalent
	},
	inactive_sections = {
		lualine_c = { { "filename", path = 0 } },
		lualine_x = { "filetype" },
	},
})

local function get_obsidian_vault_path()
  local os_release = vim.fn.system("cat /etc/os-release")
  if os_release:match("Fedora") then
    return vim.fn.expand("~/obsidian-vault")
  else
    return vim.fn.expand("~/Documents/notes")
  end
end

-- Obsidian setup
local function setup_obsidian()
  require("obsidian").setup({
      legacy_commands = false,
      workspaces = { { name = "Notes", path = get_obsidian_vault_path()} },
      picker = { name = "fzf-lua" },
  })

  vim.keymap.set("n", "<leader>nn", function()
    vim.cmd("Obsidian workspace")
    vim.defer_fn(function()
      vim.cmd("Obsidian new")
    end, 500)
  end, { desc = "New note" })
  vim.keymap.set("n", "<leader>nf", "<cmd>Obsidian quick_switch<cr>", { desc = "Find note" })
  vim.keymap.set("n", "<leader>ns", "<cmd>Obsidian search<cr>",       { desc = "Search notes" })
  vim.keymap.set("n", "<leader>nt", "<cmd>Obsidian today<cr>",        { desc = "Today's daily note" })
  vim.keymap.set("n", "<leader>nw", "<cmd>Obsidian workspace<cr>",    { desc = "Switch workspace" })
end

setup_obsidian()
