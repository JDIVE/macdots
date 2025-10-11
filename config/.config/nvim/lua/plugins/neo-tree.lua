return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
      filtered_items = {
        visible = true, -- Show hidden files by default
        hide_dotfiles = false,
        hide_gitignored = false,
      },
      hijack_netrw_behavior = "disabled", -- Don't auto-open when opening a directory
    },
  },
}
