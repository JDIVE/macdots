return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("codecompanion").setup({
        adapters = {
          acp = {
            claude_code = function()
              return require("codecompanion.adapters").extend("claude_code", {
                -- Uses Claude Max subscription via OAuth token
                -- Set CLAUDE_CODE_OAUTH_TOKEN in your shell profile
                env = {
                  CLAUDE_CODE_OAUTH_TOKEN = os.getenv("CLAUDE_CODE_OAUTH_TOKEN"),
                },
              })
            end,
          },
        },
        strategies = {
          -- Use Claude Code ACP adapter for all interactions
          chat = { adapter = "claude_code" },
          inline = { adapter = "claude_code" },
        },
      })
    end,
    keys = {
      -- Chat with Claude Code
      { "<leader>cc", "<cmd>CodeCompanionChat claude_code<cr>", desc = "Claude Code Chat" },

      -- Focus on Claude Code chat window
      { "<leader>af", "<cmd>CodeCompanionChat Toggle<cr>", desc = "Toggle Claude Chat" },

      -- Send selected code to Claude
      { "<leader>as", "<cmd>CodeCompanionChat claude_code<cr>", mode = "v", desc = "Send to Claude" },

      -- Inline assistance
      { "<leader>ai", "<cmd>CodeCompanion claude_code<cr>", desc = "Inline Claude" },

      -- Action palette
      { "<leader>aa", "<cmd>CodeCompanionActions<cr>", desc = "Claude Actions" },
    },
  },
}
