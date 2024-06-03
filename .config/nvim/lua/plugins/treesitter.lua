-- Customize Treesitter

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    -- add more things to the ensure_installed table protecting against community packs modifying it
    opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
      "lua",
      "vim",
      "bash",
      "c",
      "cpp",
      "csv",
      "dart",
      "dockerfile",
      "go",
      "helm",
      "hcl",
      "html",
      "json",
      "just",
      "kotlin",
      "lua",
      "make",
      "markdown",
      "nix",
      "php",
      "python",
      "rego",
      "ruby",
      "rust",
      "sql",
      "terraform",
      "twig",
      "vala",
      "xml",
      "yaml",
      "zig"


      -- add more arguments for adding more treesitter parsers
    })
  end,
}
