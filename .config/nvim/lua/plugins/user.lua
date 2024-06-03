-- You can also add or configure plugins by creating files in this `plugins/` folder
-- Here are some examples:

---@type LazySpec
return {
  {
    "nvim-treesitter/nvim-treesitter-context",
    lazy = false,
    opts = {
      mode = "topline",
    },
  },
}
