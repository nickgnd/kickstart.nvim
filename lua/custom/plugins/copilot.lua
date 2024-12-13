-- Copilot plugin and transform it into a cmp source
-- https://github.com/zbirenbaum/copilot-cmp
--
return {
  'zbirenbaum/copilot-cmp',
  event = 'InsertEnter',
  config = function()
    require('copilot_cmp').setup()
  end,
  dependencies = {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    config = function()
      require('copilot').setup {
        suggestion = { enabled = false },
        panel = { enabled = true },
      }
    end,
  },
}
