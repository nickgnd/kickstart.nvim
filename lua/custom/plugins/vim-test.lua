-- Testing
-- A Vim wrapper for running tests on different granularities | https://github.com/vim-test/vim-test
return {
  "vim-test/vim-test",
  config = function()
    vim.keymap.set("n", "<leader>tn", ":TestNearest<CR>", { desc = 'Runs nearest test'})
    vim.keymap.set("n", "<leader>tf", ":TestFile<CR>", { desc = 'Runs all tests in the current file'})
    vim.keymap.set("n", "<leader>ts", ":TestSuite<CR>", { desc = 'Runs the whole test suite'})
    vim.keymap.set("n", "<leader>tl", ":TestLast<CR>", { desc = 'Runs the last test'})
    vim.keymap.set("n", "<leader>tv", ":TestVisit<CR>", { desc = 'Visits the test file from which you last run your tests'})
    vim.cmd([[
      let g:test#strategy = 'neovim'
    ]])
  end
}
