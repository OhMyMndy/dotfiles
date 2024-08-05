-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- You can also add or configure plugins by creating files in this `plugins/` folder
-- Here are some examples:

---@type LazySpec
return {
  {
    "OXY2DEV/markview.nvim",
    lazy = false, -- Recommended
    -- ft = "markdown" -- If you decide to lazy-load anyway

    dependencies = {
      -- You will not need this if you installed the
      -- parsers manually
      -- Or if the parsers are in your $RUNTIMEPATH
      "nvim-treesitter/nvim-treesitter",

      "nvim-tree/nvim-web-devicons",
    },
  },
  -- {
  --   "nvim-telescope/telescope-frecency.nvim",
  --   config = function()
  --     require("telescope").load_extension "frecency"
  --     -- I don't use find register
  --     vim.keymap.set("n", "<Leader>fr", function()
  --       require("telescope").extensions.frecency.frecency {}
  --     end)
  --   end,
  -- }

  -- TODO: make the ignore alpha work
  -- {
  --   "pjvds/dynumbers.nvim",
  --   event = "VeryLazy",
  --   config = function()
  --     require("dynumbers").setup({
  --       ignore = { "NvimTree", "startify", "alpha" }
  --     })
  --   end,
  -- },
}
