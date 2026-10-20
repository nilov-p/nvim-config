local treesitter = require("nvim-treesitter")

treesitter.setup({})

local ensure_installed = {
    "vim",
    "vimdoc",
    "rust",
    "c",
    "cpp",
    "c_sharp",
    "go",
    "html",
    "css",
    "javascript",
    "typescript",
    "tsx",
    "json",
    "lua",
    "markdown",
    "markdown_inline",
    "python",
    "vue",
    "svelte",
    "bash",
    "http",
    "dockerfile",
    "java",
    "terraform",
    "yaml",
}

local config = require("nvim-treesitter.config")
local installed = config.get_installed("parsers")
local missing = {}

for _, parser in ipairs(ensure_installed) do
    if not vim.list_contains(installed, parser) then
        table.insert(missing, parser)
    end
end

if #missing > 0 then
    treesitter.install(missing)
end

local group = vim.api.nvim_create_augroup("TreeSitterConfig", {
    clear = true,
})

vim.api.nvim_create_autocmd("FileType", {
    group = group,
    callback = function(args)
        local lang = vim.treesitter.language.get_lang(args.match)

        if not lang then
            return
        end

        -- Only enable highlighting when the parser is installed.
        if vim.list_contains(config.get_installed("parsers"), lang) then
            vim.treesitter.start(args.buf)
        end
    end,
})
