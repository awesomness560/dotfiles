return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Your other servers (like tsserver, pyright, etc.) will be here
        slint_lsp = {},
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              cargo = {
                buildScripts = {
                  enable = true,
                },
              },
            },
          },
        },
      },
    },
  },
}
