vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])
return {
    {
  "nvim-neo-tree/neo-tree.nvim",
    config = {
        branch = "v2.x",
    },
    dependencies = { 
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    }
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = {
        "nvim-treesitter/nvim-treesitter"
    },
    config = function()
        require'treesitter-context'.setup{}
    end,
  }
}