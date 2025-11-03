-- snacks.nvim is a plugin that contains a collection of QoL improvements.
-- https://github.com/folke/snacks.nvim
--
-- Picker
-- One of those plugins is called snacks-picker
-- It is a fuzzy finder, inspired by Telescope, that comes with a lot of different
-- things that it can fuzzy find! It's more than just a "file finder", it can search
-- many different aspects of Neovim, your workspace, LSP, and more!
--
-- Two important keymaps to use while in a picker are:
--  - Insert mode: <c-/>
--  - Normal mode: ?
--
-- This opens a window that shows you all of the keymaps for the current
-- Snacks picker. This is really useful to discover what nacks-picker can
-- do as well as how to actually do it!
--
return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  dependencies = {
    -- Useful for getting pretty icons, but requires a Nerd Font.
    { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
  },
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    explorer = {
      replace_netrw = true,
    },
    dashboard = {
      enabled = true,
      sections = {
        { section = 'header' },
        {
          pane = 2,
          section = 'terminal',
          cmd = 'ascii_pacman',
          height = 6,
          padding = 1,
        },
        { section = 'keys', gap = 1, padding = 1 },
        { pane = 2, icon = ' ', title = 'Recent Files', section = 'recent_files', indent = 2, padding = 1 },
        { pane = 2, icon = ' ', title = 'Projects', section = 'projects', indent = 2, padding = 1 },
        {
          pane = 2,
          icon = ' ',
          title = 'Git Status',
          section = 'terminal',
          enabled = function()
            local Snacks = require 'snacks'
            return Snacks.git.get_root() ~= nil
          end,
          cmd = 'git status --short --branch --renames',
          height = 5,
          padding = 1,
          ttl = 5 * 60,
          indent = 3,
        },
        { section = 'startup' },
      },
    },
    gh = {
      -- your gh configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
    lazygit = { enabled = false },
    notifier = { enabled = true },
    picker = {
      -- [[ Configure Snacks Pickers ]]
      -- See `:help snacks-picker` and `:help snacks-picker-setup`
      matcher = {
        fuzzy = true, -- use fuzzy matching
        -- NOTE: what's the value of smartcase?
        smartcase = false, -- use smartcase
        ignorecase = true, -- use ignorecase
        sort_empty = false, -- sort results when the search string is empty
        filename_bonus = true, -- give bonus for matching file names (last part of the path)
        file_pos = true, -- support patterns like `file:line:col` and `file:line`
        -- the bonusses below, possibly require string concatenation and path normalization,
        -- so this can have a performance impact for large lists and increase memory usage
        cwd_bonus = true, -- give bonus for matching files in the cwd
        frecency = true, -- frecency bonus
        history_bonus = true, -- give more weight to chronological order
      },
      sources = {
        explorer = {},
        gh_issue = {
          -- your gh_issue picker configuration comes here
          -- or leave it empty to use the default settings
        },
        gh_pr = {
          -- your gh_pr picker configuration comes here
          -- or leave it empty to use the default settings
        },
      },
      actions = {
        -- Send picker selections directly to Sidekick's AI CLI tools with `Alt+a`
        -- https://github.com/folke/sidekick.nvim?tab=readme-ov-file#snacksnvim-picker-integrationz
        sidekick_send = function(...)
          return require('sidekick.cli.picker.snacks').send(...)
        end,
      },
      win = {
        input = {
          keys = {
            ['<a-a>'] = {
              'sidekick_send',
              mode = { 'n', 'i' },
            },
          },
        },
      },
    },
    quickfile = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    scratch = { enabled = true },
    styles = {
      notification = {
        wo = { wrap = true }, -- Wrap notifications
      },
    },
  },
  keys = {
    -- Picker - see :help `snacks-pickers-sources`
    {
      '<leader>sh',
      function()
        Snacks.picker.help()
      end,
      desc = '[S]earch [H]elp',
    },
    {
      '<leader>sk',
      function()
        Snacks.picker.keymaps()
      end,
      desc = '[S]earch [K]eymaps',
    },
    {
      '<leader>s:',
      function()
        Snacks.picker.command_history()
      end,
      desc = '[S]earch [:]Command History',
    },
    {
      '<leader>e',
      function()
        Snacks.explorer()
      end,
      desc = 'File Explorer',
    },
    {
      '\\',
      desc = 'File Explorer Toggle',
      -- Based on https://www.reddit.com/r/neovim/comments/1k7rkfp/comment/mp2j44i
      (function()
        -- Create a closure to store both previous buffer and window
        local previous_buffer = nil
        local previous_window = nil

        return function()
          local explorer_pickers = Snacks.picker.get { source = 'explorer' }
          -- Check if there are any explorer pickers open
          if #explorer_pickers == 0 then
            -- If none exist, store current buffer/window and open a new explorer picker
            previous_buffer = vim.api.nvim_get_current_buf()
            previous_window = vim.api.nvim_get_current_win()
            Snacks.picker.explorer()
          elseif explorer_pickers[1]:is_focused() then
            -- If the explorer is already focused, close it and return to previous buffer/window
            -- explorer_pickers[1]:close()
            if previous_buffer and vim.api.nvim_buf_is_valid(previous_buffer) and previous_window and vim.api.nvim_win_is_valid(previous_window) then
              -- Focus the previous window first
              vim.api.nvim_set_current_win(previous_window)
              -- Then set the buffer in that window
              vim.api.nvim_win_set_buf(previous_window, previous_buffer)
            end
          else
            -- If the explorer exists but isn't focused, store current buffer/window and focus explorer
            previous_buffer = vim.api.nvim_get_current_buf()
            previous_window = vim.api.nvim_get_current_win()
            explorer_pickers[1]:focus()
          end
        end
      end)(),
    },
    {
      '<leader>sf',
      function()
        Snacks.picker.smart()
        -- Snacks.picker.files()
      end,
      desc = '[S]earch [F]iles',
    },
    {
      '<leader>ss',
      function()
        Snacks.picker.pickers()
      end,
      desc = '[S]earch [S]elect Snacks',
    },
    {
      '<leader>sw',
      function()
        Snacks.picker.grep_word()
      end,
      desc = '[S]earch current [W]ord',
      mode = { 'n', 'x' },
    },
    {
      '<leader>sg',
      function()
        Snacks.picker.grep()
      end,
      desc = '[S]earch by [G]rep',
    },
    {
      '<leader>sd',
      function()
        Snacks.picker.diagnostics()
      end,
      desc = '[S]earch [D]iagnostics',
    },
    {
      '<leader>sr',
      function()
        Snacks.picker.resume()
      end,
      desc = '[S]earch [R]esume',
    },
    {
      '<leader>s.',
      function()
        Snacks.picker.recent()
      end,
      desc = '[S]earch Recent Files ("." for repeat)',
    },
    {
      '<leader>sm',
      function()
        Snacks.picker.marks()
      end,
      desc = '[S]earch [M]arks',
    },
    {
      '<leader><leader>',
      function()
        Snacks.picker.buffers()
      end,
      desc = '[ ] Find existing buffers',
    },
    {
      '<leader>/',
      function()
        Snacks.picker.lines {}
      end,
      desc = '[/] Fuzzily search in current buffer',
    },
    {
      '<leader>s/',
      function()
        Snacks.picker.grep_buffers()
      end,
      desc = '[S]earch [/] in Open Files',
    },
    -- Shortcut for searching your Neovim configuration files
    {
      '<leader>sn',
      function()
        Snacks.picker.files { cwd = vim.fn.stdpath 'config' }
      end,
      desc = '[S]earch [N]eovim files',
    },
    -- Gh
    {
      '<leader>gi',
      function()
        Snacks.picker.gh_issue()
      end,
      desc = 'GitHub Issues (open)',
    },
    {
      '<leader>gI',
      function()
        Snacks.picker.gh_issue { state = 'all' }
      end,
      desc = 'GitHub Issues (all)',
    },
    {
      '<leader>gp',
      function()
        Snacks.picker.gh_pr()
      end,
      desc = 'GitHub Pull Requests (open)',
    },
    {
      '<leader>gP',
      function()
        Snacks.picker.gh_pr { state = 'all' }
      end,
      desc = 'GitHub Pull Requests (all)',
    },
    -- Scratch
    {
      '<leader>.',
      function()
        Snacks.scratch()
      end,
      desc = 'Toggle Scratch Buffer',
    },
    {
      '<leader>S',
      function()
        Snacks.scratch.select()
      end,
      desc = 'Select Scratch Buffer',
    },
  },
}
