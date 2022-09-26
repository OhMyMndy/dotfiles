-- Just an example, supposed to be placed in /lua/custom/

local M = {}

-- make sure you maintain the structure of `core/default_config.lua` here,
-- example of changing theme:

M.ui = {
  theme = "tokyodark",
}

-- @see https://github.dev/siduck/dotfiles/tree/master/nvchad/custom
M.truzen = {
  n = {
    ["<leader>ta"] = { "<cmd> TZAtaraxis <CR>", "   truzen ataraxis" },
    ["<leader>tm"] = { "<cmd> TZMinimalist <CR>", "   truzen minimal" },
    ["<leader>tf"] = { "<cmd> TZFocus <CR>", "   truzen focus" },
  },
}

M.plugins = {
  ['folke/tokyonight.nvim'] = {},
  override = {
    ["NvChad/nvterm"] = {
    },
    ["nvim-treesitter/nvim-treesitter"] = {
      ensure_installed = {
        "css",
        "html",
        "javascript",
        "json",
        "typescript",
        "yaml",
        "bash",
        "java"
      },
    },
    ["williamboman/mason.nvim"] = {
      -- :Mason to show available
      ensure_installed = {
        -- lua stuff
        "lua-language-server",
        "stylua",

        -- web dev
        "css-lsp",
        "html-lsp",
        "typescript-language-server",
        "deno",
        "json-lsp",

        -- shell
        "shfmt",
        "shellcheck",
        "bash-language-server",

        -- cloud and containerization
        "hadolint",
        "dockerfile-language-server",
        "terraform-ls",
        "tflint",
        "yaml-language-server",
        "yamlfmt",
        "yamllint",

        -- Python
        "python-lsp-server",
        -- markdown
        "markdownlint",
        
        -- Java
        "jdtls"
      },
    },
  },
  user = require "custom.plugins",
}

return M
