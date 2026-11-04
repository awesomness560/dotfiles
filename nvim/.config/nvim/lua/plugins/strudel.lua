vim.filetype.add({
  extension = {
    str = "javascript",
    std = "javascript",
  },
})

return {
  {
    "gruvw/strudel.nvim",
    build = "npm ci",
    lazy = false,
    config = function()
      require("strudel").setup({
        start_on_launch = true,
        update_on_save = true,
      })
    end,
  },

  -- Make ts_ls also activate for .str files
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ts_ls = {
          filetypes = {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
          },
        },
      },
    },
  },
}
