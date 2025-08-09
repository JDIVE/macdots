return {
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    lazy = false, -- Load immediately
    config = function()
      require("claudecode").setup({
        -- Optional configuration
        port_range = { min = 10000, max = 65535 },
        auto_start = true,
        log_level = "info",
        track_selection = true,
        terminal = {
          split_side = "right",
          split_width_percentage = 0.30,
          provider = "native", -- Use "native" if you encounter terminal issues
        },
      })
    end,
    keys = {
      { "<leader>cc", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
    },
  },
}