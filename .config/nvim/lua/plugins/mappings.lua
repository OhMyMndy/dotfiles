-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    mappings = {
      v = {
        ["<leader>y"] = { [["+y]], desc = "Yank" },
      },
      n = {
        ["<leader>Y"] = { [["+Y]], desc = "Yank" },
        ["<leader>y"] = { [["+y]], desc = "Yank" },
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
