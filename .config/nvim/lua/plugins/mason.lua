-- Customize Mason plugins

---@type LazySpec
return {
  -- use mason-lspconfig to configure LSP installations
  {
    "williamboman/mason-lspconfig.nvim",
    -- overrides `require("mason-lspconfig").setup(...)`
    opts = function(_, opts)
      -- add more things to the ensure_installed table protecting against community packs modifying it
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
        "lua_ls",
        "terraformls",
        "pyright",
        "gopls",
        "helm_ls",
        "bashls",
        "dockerls",
        "nil_ls",
        "jsonls",
        "yamlls",
        "tsserver",
        "markdown_oxide",
        "phpactor"
        -- add more arguments for adding more language servers
      })
    end,
  },
  -- use mason-null-ls to configure Formatters/Linter installation for null-ls sources
  {
    "jay-babu/mason-null-ls.nvim",
    -- overrides `require("mason-null-ls").setup(...)`
    opts = function(_, opts)
      -- add more things to the ensure_installed table protecting against community packs modifying it
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
        "prettier",
        "stylua",
        "tflint",
        "tfsec",
        "ansible-lint",
        "shellcheck",
        "dcm",
        "gofumpt",
        "hclfmt",
        "phpcbf",
        "ruff"
        -- add more arguments for adding more null-ls sources
      })
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    -- overrides `require("mason-nvim-dap").setup(...)`
    opts = function(_, opts)
      -- add more things to the ensure_installed table protecting against community packs modifying it
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
        "debugpy",
        "bash-debug-adapter",
        "dart-debug-adapter",
        "go-debug-adapter",
        "php-debug-adapter"
        -- add more arguments for adding more debuggers
      })
    end,
  },
}
