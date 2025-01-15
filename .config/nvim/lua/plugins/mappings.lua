return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    mappings = {
      i = {
        ["<Left>"] = { "<Nop>" },
        ["<Down>"] = { "<Nop>" },
        ["<Up>"] = { "<Nop>" },
        ["<Right>"] = { "<Nop>" },

        ["<C-h>"] = { "<Left>" },
        ["<C-j>"] = { "<Down>" },
        ["<C-k>"] = { "<Up>" },
        ["<C-l>"] = { "<Right>" },
      },
      v = {
        ["<Left>"] = { "<Nop>" },
        ["<Down>"] = { "<Nop>" },
        ["<Up>"] = { "<Nop>" },
        ["<Right>"] = { "<Nop>" },

        ["<leader>y"] = { [["+y]], desc = "Yank" },
        ["<leader>d"] = { [["_d]], desc = "Delete" },
        ["<"] = { "<gv" },
        [">"] = { ">gv" },
      },
      n = {
        ["<Left>"] = { "<Nop>" },
        ["<Down>"] = { "<Nop>" },
        ["<Up>"] = { "<Nop>" },
        ["<Right>"] = { "<Nop>" },

        ["<leader>Y"] = { [["+Y]], desc = "Yank" },
        ["<leader>y"] = { [["+y]], desc = "Yank" },
        ["<leader>d"] = { [["_d]], desc = "Delete" },
        ["<C-d>"] = { "<C-d>zz" },
        ["<C-u>"] = { "<C-u>zz" },
        ["n"] = { "nzzzv" },
        ["N"] = { "Nzzzv" },
        -- ["<leader>a"] = { require("harpoon.mark").add_file },
        -- ["<C-e>"] = { require("harpoon.ui").toggle_quick_menu },
        -- ["<C-h>"] = { function() require("harpoon.ui").nav_file(1) end },
        -- ["<C-t>"] = { function() require("harpoon.ui").nav_file(2) end },
        -- ["<C-n>"] = { function() require("harpoon.ui").nav_file(3) end },
      },
    },
  },
}

-- vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
-- vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
--

--
-- -- greatest remap ever
-- vim.keymap.set("x", "<leader>P", [["_dP]], { desc = "Paste" })
--
-- -- next greatest remap ever : asbjornHaland
-- vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank" })
-- vim.keymap.set("n", "<leader>Y", [["+Y]])
--
-- vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Cut" })
