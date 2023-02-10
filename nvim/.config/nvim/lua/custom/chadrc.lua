-- Just an example, supposed to be placed in /lua/custom/

local M = {}

-- make sure you maintain the structure of `core/default_config.lua` here,
-- example of changing theme:
M.ui = {
  theme = "nightowl",
}

-- @see https://github.dev/siduck/dotfiles/tree/master/nvchad/custom
M.truzen = {
  n = {
    ["<leader>ta"] = { "<cmd> TZAtaraxis <CR>", "   truzen ataraxis" },
    ["<leader>tm"] = { "<cmd> TZMinimalist <CR>", "   truzen minimal" },
    ["<leader>tf"] = { "<cmd> TZFocus <CR>", "   truzen focus" },
  },
}
M.mappings = {
  telescope = {
    n = {
      ["<leader>fa"] = { "<cmd> Telescope find_files follow=true hidden=true <CR>", "find all" },
    }
  }
}
M.plugins = {
  ['folke/tokyonight.nvim'] = {},
  ['sonph/onehalf'] = {
    rtp = "vim"
  },
  override = {
    ["NvChad/nvterm"] = {
    },
    ["nvim-telescope/telescope.nvim"] = {
      ["<leader>fa"] = { "<cmd> Telescope find_files follow=true hidden=true <CR>", "find all" },

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
        -- "lua-language-server", -- done by nix
        -- "stylua", -- done by nix

        -- web dev
        "css-lsp",
        "html-lsp",
        -- "typescript-language-server", -- done by nix
        -- "deno", -- done by nix
        "json-lsp",

        -- shell
        -- "shfmt", -- done by nix
        -- "shellcheck", -- done by nix
        -- "bash-language-server", -- done by nix

        -- cloud and containerization
        -- "hadolint", - done by nix
        -- "dockerfile-language-server", -- done by nix
        -- "terraform-ls", -- done by nix
        -- "tflint", -- done by nix
        -- "yaml-language-server", -- done by nix
        -- "yamlfmt", -- todo
        -- "yamllint", -- done by nix

        -- Python
        -- "python-lsp-server", -- is now done by nix
        -- markdown
        -- "markdownlint", -- done by nix
        
        -- Java
        -- "jdtls" -- skip for now
      },
    },
  },
  user = require "custom.plugins",
}

M.mappings = {
  abc = {
    n = {
      ["C-d"] = "<C-d>zz",
      ["C-u"] = "<C-u>zz",
      ["n"] = "nzzzv",
      ["N"] = "Nzzzv",
      ["<C-k>"] = "<cmd>cnext<CR>zz",
      ["<C-j>"] = "<cmd>cprev<CR>zz",
      ["<leader>k"] = "<cmd>lnext<CR>zz",
      ["<leader>j"] = "<cmd>lprev<CR>zz",
    }
  }
}

return M
