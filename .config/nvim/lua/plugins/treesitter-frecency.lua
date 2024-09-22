return {
  "nvim-telescope/telescope-frecency.nvim",
  keys = {
    -- { "<leader>fr", "<cmd>Telescope frecency<cr>", desc = "frecency (root dir)" },
    { "<leader>fR", "<cmd>Telescope frecency workspace=CWD<cr>", desc = "frecency (cwd)" },
  },
  config = function() require("telescope").load_extension "frecency" end,
}
