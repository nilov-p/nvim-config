vim.api.nvim_create_user_command("MermaidPreview", function(opts)
  local lines = {}

  if opts.range == 2 then
    -- Visual selection: extract only selected lines
    lines = vim.api.nvim_buf_get_lines(0, opts.line1 - 1, opts.line2, false)
  else
    -- Normal mode fallback: entire buffer
    lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  end

  -- Automatically strip ```mermaid and ``` fences if selected
  local clean_lines = {}
  for _, line in ipairs(lines) do
    if not line:match("^%s*```") then
      table.insert(clean_lines, line)
    end
  end

  if #clean_lines == 0 then
    vim.notify("No Mermaid diagram content found in selection.", vim.log.levels.WARN)
    return
  end

  local input_file = "/tmp/mermaid_snippet.mmd"
  local output_file = "/tmp/mermaid_preview.svg"

  -- Write the extracted diagram to a temporary .mmd file
  local f = io.open(input_file, "w")
  if not f then
    vim.notify("Failed to write temporary Mermaid file.", vim.log.levels.ERROR)
    return
  end
  f:write(table.concat(clean_lines, "\n"))
  f:close()

  vim.notify("Rendering Mermaid snippet...", vim.log.levels.INFO)

  -- Compile .mmd to PNG and launch macOS Quick Look
  local cmd = string.format(
    "mmdc -i %s -o %s && qlmanage -p %s > /dev/null 2>&1 &",
    vim.fn.shellescape(input_file),
    vim.fn.shellescape(output_file),
    vim.fn.shellescape(output_file)
  )

  vim.fn.jobstart(cmd, {
    on_exit = function(_, code)
      if code ~= 0 then
        vim.notify("Failed to render Mermaid chart. Check diagram syntax.", vim.log.levels.ERROR)
      end
    end,
  })
end, { range = true, desc = "Render Mermaid selection in Quick Look" })

-- Visual mode mapping (operates strictly on highlighted lines)
vim.keymap.set("v", "<leader>mp", ":MermaidPreview<CR>", { desc = "Preview selected Mermaid chart" })

-- Normal mode mapping (falls back to rendering the entire file)
vim.keymap.set("n", "<leader>mp", "<cmd>MermaidPreview<CR>", { desc = "Preview Mermaid chart" })
