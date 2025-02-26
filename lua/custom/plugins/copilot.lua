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
        -- It is recommended to disable copilot.lua's suggestion and panel modules,
        -- as they can interfere with completions properly appearing in copilot-cmp.
        suggestion = { enabled = false },
        panel = { enabled = false },
      }
    end,
  },
}
