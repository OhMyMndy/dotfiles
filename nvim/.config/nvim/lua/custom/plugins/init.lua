return {
    -- -- autoclose tags in html, jsx etc
    -- ["windwp/nvim-ts-autotag"] = {
    --     ft = { "html", "javascriptreact" },
    --     after = "nvim-treesitter",
    --     config = function()
    --         require("custom.plugins.smolconfigs").autotag()
    --     end,
    -- },

    -- -- format & linting
    -- ["jose-elias-alvarez/null-ls.nvim"] = {
    --     after = "nvim-lspconfig",
    --     config = function()
    --         require "custom.plugins.null-ls"
    --     end,
    -- },

    -- minimal modes
    ["Pocco81/TrueZen.nvim"] = {
        cmd = {
            "TZAtaraxis",
            "TZMinimalist",
            "TZFocus",
        },
        config = function()
            require "custom.plugins.truezen"
        end,
    },
}
