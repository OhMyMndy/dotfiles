-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  { "AstroNvim/astrocommunity", dev = true },
  -- { import = "astrocommunity.motion.harpoon" },
  { import = "astrocommunity.colorscheme.catppuccin" },
  -- { import = "astrocommunity.completion.codeium-nvim" },
  { import = "astrocommunity.completion.avante-nvim" },
  {
    "yetone/avante.nvim",
    opts = {
      provider = "openai",
      openai = {
        endpoint = "https://openrouter.ai/api/v1",
        -- model = "anthropic/claude-3.5-sonnet",
        model = "meta-llama/llama-3.1-70b-instruct",
        timeout = 30000, -- Timeout in milliseconds
        temperature = 0,
        max_tokens = 4096,
      },
    },
  },
  -- { import = "astrocommunity.colorscheme.tokyonight-nvim" },
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
  {
    import = "astrocommunity.lsp.nvim-lint",
  },
  { import = "astrocommunity.editing-support.telescope-undo-nvim" },
  { import = "astrocommunity.markdown-and-latex.vimtex" },
  { import = "astrocommunity.git.blame-nvim" },
  { import = "astrocommunity.neovim-lua-development.lazydev-nvim" },
  { import = "astrocommunity.pack.ansible" },
  { import = "astrocommunity.pack.bash" },
  { import = "astrocommunity.pack.dart" },
  { import = "astrocommunity.pack.docker" },
  { import = "astrocommunity.pack.go" },
  { import = "astrocommunity.pack.json" },
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.markdown" },

  { import = "astrocommunity.pack.html-css" },
  { import = "astrocommunity.pack.svelte" },
  { import = "astrocommunity.pack.terraform" },

  { import = "astrocommunity.pack.nix" },
  { import = "astrocommunity.pack.php" },
  { import = "astrocommunity.pack.laravel" },
  { import = "astrocommunity.pack.python-ruff" },
  { import = "astrocommunity.pack.rust" },
  { import = "astrocommunity.pack.terraform", dev = true },

  { import = "astrocommunity.pack.toml" },
  { import = "astrocommunity.pack.yaml" },

  -- import/override with your plugins folder
}
