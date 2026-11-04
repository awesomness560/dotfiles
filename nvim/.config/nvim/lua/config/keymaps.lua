-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Use Alt-x to escape terminal mode (Alt is rarely intercepted)
vim.keymap.set("t", "<A-x>", [[<C-\><C-n>]], { desc = "Escape Terminal" })

-- In your LazyVim keymaps (e.g., lua/config/keymaps.lua)
vim.keymap.set("n", "<leader>tp", function()
  vim.cmd("split | terminal uv run " .. vim.fn.expand("%"))
end, { desc = "Run Python file with uv" })

vim.keymap.set("n", "<leader>tj", function()
  local file = vim.fn.expand("%:t")
  local name = vim.fn.expand("%:t:r")
  local dir = vim.fn.expand("%:p:h")
  vim.cmd("w")

  -- Check if file has a package declaration
  local lines = vim.api.nvim_buf_get_lines(0, 0, 10, false)
  local package = nil
  for _, line in ipairs(lines) do
    local match = line:match("^%s*package%s+([%w%.]+)%s*;")
    if match then
      package = match
      break
    end
  end

  local cmd
  if package then
    local depth = select(2, package:gsub("%.", "")) + 1
    local root = dir
    for _ = 1, depth do
      root = vim.fn.fnamemodify(root, ":h")
    end
    cmd = "cd "
      .. root
      .. " && javac "
      .. package:gsub("%.", "/")
      .. "/"
      .. file
      .. " && java "
      .. package
      .. "."
      .. name
  else
    cmd = "cd " .. dir .. " && javac " .. file .. " && java " .. name
  end

  vim.cmd("split | terminal " .. cmd)
end, { desc = "Compile & Run Java file" })

-- Compile & Run a single C file with Clang
vim.keymap.set("n", "<leader>tc", function()
  -- Get paths and names of the current file
  local file = vim.fn.expand("%")
  local name = vim.fn.expand("%:t:r")
  local dir = vim.fn.expand("%:p:h")

  -- Force write/save the file before compilation
  vim.cmd("w")

  -- Construct a command chain:
  -- 1. Move to the file's directory
  -- 2. Compile with clang
  -- 3. Run the executable if compilation succeeds
  -- 4. Delete the generated temporary binary right after execution
  local cmd = string.format("cd %s && clang %s -o %s && ./%s ; rm %s", dir, file, name, name, name)

  -- Open a split window and execute inside Neovim's terminal emulator
  vim.cmd("split | terminal " .. cmd)
end, { desc = "Compile & Run C file (Clang)" })

local api = require("remote-sshfs.api")
vim.keymap.set("n", "<leader>rc", api.connect, {})
vim.keymap.set("n", "<leader>rd", api.disconnect, {})
vim.keymap.set("n", "<leader>re", api.edit, {})

-- Cycle forward through installed colorschemes with Ctrl + n
vim.keymap.set("n", "<C-n>", function()
  local schemes = vim.fn.getcompletion("", "color")
  local current = vim.g.colors_name
  for i, scheme in ipairs(schemes) do
    if scheme == current then
      local next_scheme = schemes[(i % #schemes) + 1]
      vim.cmd("colorscheme " .. next_scheme)
      print("Theme: " .. next_scheme)
      return
    end
  end
  vim.cmd("colorscheme " .. schemes[1])
end, { desc = "Next colorscheme" })
