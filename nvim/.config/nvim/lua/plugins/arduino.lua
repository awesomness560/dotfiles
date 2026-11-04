return {
  -- 1. LSP Configuration
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        arduino_language_server = {},
      },
    },
  },

  -- 2. vim-arduino Configuration
  {
    "stevearc/vim-arduino",
    ft = "arduino",
    -- The 'init' function runs BEFORE the plugin starts,
    -- which is where we tell it where the CLI and boards are.

    init = function()
      vim.g.arduino_cmd = "arduino-cli"
      vim.g.arduino_home_dir = vim.fn.expand("~/.arduino15")
      vim.g.arduino_dir = vim.g.arduino_home_dir

      -- Use arduino-cli for the serial monitor instead of 'screen'
      -- This will open in a Neovim terminal buffer
      vim.g.arduino_serial_cmd = "arduino-cli monitor -p {port}"
    end,
    config = function()
      -- Your existing keymaps
      vim.api.nvim_set_keymap("n", "<leader>am", "<cmd>ArduinoVerify<CR>", { desc = "Verify Sketch" })
      vim.api.nvim_set_keymap("n", "<leader>au", "<cmd>ArduinoUpload<CR>", { desc = "Upload Sketch" })
      -- Added this one so you can fix the "board" selection easily
      vim.api.nvim_set_keymap("n", "<leader>ab", "<cmd>ArduinoChooseBoard<CR>", { desc = "Select Board" })
      vim.api.nvim_set_keymap("n", "<leader>ap", "<cmd>ArduinoChoosePort<CR>", { desc = "Select Serial Port" })
      vim.api.nvim_set_keymap("n", "<leader>as", "<cmd>ArduinoSerial<CR>", { desc = "Open Serial Monitor" })
    end,
  },
}
