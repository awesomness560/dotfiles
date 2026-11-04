-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
--

-- Automatically start a server pipe if project.godot exists in the working directory
local godot_project_path = vim.fn.getcwd() .. "/project.godot"
if vim.uv.fs_stat(godot_project_path) then
  local pipe_path = vim.fn.getcwd() .. "/godothost"
  if not vim.uv.fs_stat(pipe_path) then
    vim.fn.serverstart(pipe_path)
  end
end

vim.filetype.add({
  extension = {
    mdx = "markdown",
  },
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "mdx" },
  callback = function()
    vim.opt_local.wrap = true
  end,
})
