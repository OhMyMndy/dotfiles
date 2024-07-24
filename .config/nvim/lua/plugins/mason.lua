-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- Customize Mason plugins

---@type LazySpec
return {
  -- use mason-lspconfig to configure LSP installations
  {
    "williamboman/mason-lspconfig.nvim",
    -- overrides `require("mason-lspconfig").setup(...)`
    opts = {
      ensure_installed = {
        -- "ansiblels",
        -- "bashls",
        -- "clangd", -- c, c++
        -- "dockerls",
        -- "gopls",
        -- "html",
        -- "htmx",
        -- "jsonls",
        -- "lua_ls",
        -- "nil_ls",   -- nix
        -- "ruby_lsp", -- ruby
        -- "ruff_lsp", -- python
        -- "rust_analyzer",
        -- "taplo",    -- toml
        -- "terraformls",
        -- "tflint",
        -- "tsserver", -- javascript, typescript
        -- "yamlls",
      },
    },
  },
  -- use mason-null-ls to configure Formatters/Linter installation for null-ls sources
  {
    "jay-babu/mason-null-ls.nvim",
    -- overrides `require("mason-null-ls").setup(...)`
    opts = {
      ensure_installed = {
        -- "stylua",
      },
    },
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    -- overrides `require("mason-nvim-dap").setup(...)`
    opts = {
      ensure_installed = {
        -- "python",
      },
    },
  },
}
