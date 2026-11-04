return {
  -- 1. Syntax highlighting (with Treesitter indent disabled for GDScript)
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, {
          "gdscript",
          "godot_resource",
          "gdshader",
        })
      end
      -- Disable broken Treesitter indentation for GDScript
      opts.indent = opts.indent or {}
      opts.indent.disable = opts.indent.disable or {}
      vim.list_extend(opts.indent.disable, { "gdscript" })
    end,
  },

  -- 2. Configure Godot's built-in LSP (Keep Godot Editor open for LSP to connect!)
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gdscript = {
          mason = false, -- gdscript LSP is built directly into the Godot Engine binary
        },
      },
    },
  },

  -- 3. Install gdtoolkit via Mason (provides gdformat and gdlint)
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "gdtoolkit" })
    end,
  },
  -- 4. Auto-formatting with gdformat
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        gdscript = { "gdformat" },
      },
    },
  },

  -- 6. Step Debugging with nvim-dap
  {
    "mfussenegger/nvim-dap",
    optional = true,
    opts = function()
      local dap = require("dap")
      dap.adapters.godot = {
        type = "server",
        host = "127.0.0.1",
        port = 6006,
      }
      dap.configurations.gdscript = {
        {
          type = "godot",
          request = "launch",
          name = "Launch Main Scene",
          project = "${workspaceFolder}",
          launch_scene = true,
        },
      }
    end,
  },

  -- 7. Enforce Godot's 4-space tab indentation + Working ':' auto-indent
  {
    "LazyVim/LazyVim",
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "gdscript", "godot_resource" },
        callback = function(ev)
          -- vim.schedule ensures this runs AFTER LazyVim's treesitter FileType autocmd
          vim.schedule(function()
            if not vim.api.nvim_buf_is_valid(ev.buf) then
              return
            end

            vim.bo[ev.buf].expandtab = false
            vim.bo[ev.buf].tabstop = 4
            vim.bo[ev.buf].shiftwidth = 4
            vim.bo[ev.buf].softtabstop = 4
            vim.bo[ev.buf].includeexpr = "substitute(v:fname,'^res://','','')"

            if vim.bo[ev.buf].filetype == "gdscript" then
              -- Load Neovim's built-in Python indent function if not already loaded
              vim.cmd("runtime! autoload/python.vim")
              vim.bo[ev.buf].autoindent = true
              vim.bo[ev.buf].smartindent = false
              vim.bo[ev.buf].indentexpr = "python#GetIndent(v:lnum)"
              vim.bo[ev.buf].indentkeys = "0{,0},0),0],!^F,o,O,e,<:>,=elif,=except"
            end
          end)
        end,
      })
    end,
  },

  -- 2. Configure Godot's built-in LSP + Fix <leader>ss and <leader>sS
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gdscript = {
          mason = false,
          keys = {
            -- 1. Current File (<leader>ss): Show everything (variables, functions, signals, enums)
            {
              "<leader>ss",
              function()
                Snacks.picker.lsp_symbols({
                  filter = { gdscript = true },
                })
              end,
              desc = "Goto Symbol (Godot File - All)",
            },
            -- 2. Workspace (<leader>sS): ONLY show class_name declarations across the project
            {
              "<leader>sS",
              function()
                Snacks.picker.grep({
                  title = "Godot Classes",
                  search = "^class_name\\s+\\w+",
                  args = { "--pcre2" },
                  glob = "*.gd",
                  live = false,
                })
              end,
              desc = "Goto Class (Godot Workspace)",
            },
          },
        },
      },
    },
  },

  -- 8. Hide Godot .uid and .import clutter from <Space><Space> and <Space>sg
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          files = {
            exclude = {
              "*.uid",
              "*.import",
              "*.translation",
              ".godot",
            },
          },
          grep = {
            exclude = {
              "*.uid",
              "*.import",
              "*.translation",
              ".godot",
            },
          },
        },
      },
    },
  },
}
