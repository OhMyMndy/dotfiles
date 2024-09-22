-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE
return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = function(_, opts)
    opts.event_handlers = {
      -- event = "neo_tree_buffer_enter",
      event = "file_opened",
      handler = function(_) vim.opt_local.relativenumber = true end,
    }
  end,
}
