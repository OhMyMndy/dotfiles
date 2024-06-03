-- You can also add or configure plugins by creating files in this `plugins/` folder
-- Here are some examples:

---@type LazySpec
return {
  {
    "nvim-telescope/telescope-frecency.nvim",
    config = function()
      require("telescope").load_extension "frecency"
      -- I don't use find register
      vim.keymap.set("n", "<Leader>fr", function()
        require("telescope").extensions.frecency.frecency {}
      end)
    end,
  }
}
