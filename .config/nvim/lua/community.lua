-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.colorscheme.catppuccin" },
  { import = "astrocommunity.colorscheme.tokyonight-nvim" },
  { import = "astrocommunity.debugging.telescope-dap-nvim" },
  -- { import = "astrocommunity.diagnostics.lsp_lines-nvim" },
  { import = "astrocommunity.diagnostics.trouble-nvim" },
  { import = "astrocommunity.editing-support.cloak-nvim" },
  { import = "astrocommunity.editing-support.nvim-treesitter-context" },
  {
    "nvim-treesitter/nvim-treesitter-context",
    opts = {
      mode = "topline",
    },
  },
  { import = "astrocommunity.editing-support.telescope-undo-nvim" },
  { import = "astrocommunity.git.blame-nvim" },
  -- { import = "astrocommunity.motion.harpoon" },
  { import = "astrocommunity.neovim-lua-development.lazydev-nvim" },
  { import = "astrocommunity.pack.lua" },

  -- import/override with your plugins folder
}
