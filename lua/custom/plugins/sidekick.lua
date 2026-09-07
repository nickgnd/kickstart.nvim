-- sidekick.nvim is your Neovim AI sidekick that integrates Copilot LSP's "Next Edit Suggestions" with a built-in terminal for any AI CLI.

return {
  'folke/sidekick.nvim',
  opts = {
    debug = true,
    cli = {
      mux = {
        -- Placeholder to satisfy sidekick's {tmux,zellij} validation at setup;
        -- the real backend is our custom 'herdr' one, selected in config() below.
        backend = 'tmux',
        enabled = true,
      },
    },
  },
  config = function(_, opts)
    -- Talk to the AI agent running in a peer herdr pane. sidekick validates
    -- cli.mux.backend against {tmux,zellij} during setup, so we register the
    -- herdr backend and switch to it *after* setup (validate runs on a
    -- vim.schedule, hence the deferred assignment) instead of via opts.
    require('sidekick.cli.session').register('herdr', require 'custom.sidekick.herdr')
    require('sidekick').setup(opts)
    vim.schedule(function() require('sidekick.config').cli.mux.backend = 'herdr' end)
  end,
  keys = {
    {
      '<tab>',
      function()
        -- if there is a next edit, jump to it, otherwise apply it if any
        if not require('sidekick').nes_jump_or_apply() then
          return '<Tab>' -- fallback to normal tab
        end
      end,
      expr = true,
      desc = 'Goto/Apply Next Edit Suggestion',
    },
    {
      '<leader>aa',
      function() require('sidekick.cli').toggle() end,
      mode = { 'n', 'v' },
      desc = 'Sidekick Toggle CLI',
    },
    {
      '<leader>as',
      function() require('sidekick.cli').select() end,
      -- Or to select only installed tools:
      -- require("sidekick.cli").select({ filter = { installed = true } })
      desc = 'Sidekick Select CLI',
    },
    {
      '<leader>as',
      function() require('sidekick.cli').send { selection = true } end,
      mode = { 'v' },
      desc = 'Sidekick Send Visual Selection',
    },
    {
      '<leader>ap',
      function() require('sidekick.cli').prompt() end,
      mode = { 'n', 'v' },
      desc = 'Sidekick Select Prompt',
    },
    {
      '<c-.>',
      function() require('sidekick.cli').focus() end,
      mode = { 'n', 'x', 'i', 't' },
      desc = 'Sidekick Switch Focus',
    },
    -- Example of a keybinding to open Claude directly
    {
      '<leader>ac',
      function() require('sidekick.cli').toggle { name = 'claude', focus = true } end,
      desc = 'Sidekick Claude Toggle',
      mode = { 'n', 'v' },
    },
  },
}
