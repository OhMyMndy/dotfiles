-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- Customize Treesitter

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  -- dev = true,
  opts = {
    auto_install = true,
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<C-space>", -- start selection at cursor node
        node_incremental = "<C-space>", -- grow to parent node
        scope_incremental = false, -- or "<C-s>" to jump by scope
        node_decremental = "<BS>", -- shrink back to child node
      },
    },
  },
}
