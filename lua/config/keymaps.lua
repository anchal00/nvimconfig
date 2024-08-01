local keymap = vim.keymap


-- Directory Navigation
keymap.set("n", "<leader>f", ":NvimTreeFocus<CR>", { noremap = true, silent = true})
keymap.set("n", "<leader>b", ":NvimTreeToggle<CR>", { noremap = true, silent = true})


-- Pane Navigation
keymap.set("n", "<C-h>", "<C-w>h", opts) -- Move Left
keymap.set("n", "<C-j>", "<C-w>j", opts) -- Move Down
keymap.set("n", "<C-k>", "<C-w>k", opts) -- Move Up 
keymap.set("n", "<C-l>", "<C-w>l", opts) -- Move Right


-- Window Management
keymap.set("n", "<leader>sv", ":vsplit<CR>", opts) -- Split Vertically
keymap.set("n", "<leader>sh", ":split<CR>", opts) -- Split Horizontally
keymap.set("n", "<leader>sm", ":MaximizerToggle<CR>", opts) -- Toggle Minimize 

-- Indenting
keymap.set("v", "<", "<gv")
keymap.set("v", ">", ">gv")

-- Comments
vim.api.nvim_set_keymap("n", "<C-_>", "gcc", {noremap = false})
vim.api.nvim_set_keymap("v", "<C-_>", "gcc", {noremap = false})
