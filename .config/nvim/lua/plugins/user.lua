-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- You can also add or configure plugins by creating files in this `plugins/` folder
-- Here are some examples:

---@type LazySpec
return {
  -- { "Mofiqul/dracula.nvim" },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup {
        -- Configuration here, or leave empty to use defaults
      }
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {},
  },
  {
    "jay-babu/mason-null-ls.nvim",
    opts = {},
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = {},
  },
  {
    "stevearc/conform.nvim",
    opts = {},
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      auto_update = false,
      run_on_start = true,
    },
  },
  {
    "nvimtools/none-ls.nvim",
    opts = {},
  },
}
