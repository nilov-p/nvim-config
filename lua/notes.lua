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
