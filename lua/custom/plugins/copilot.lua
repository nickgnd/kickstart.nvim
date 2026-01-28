-- Copilot plugin and transform it into a blink.cmp source
-- https://github.com/fang2hou/blink-copilot
--
return {
  'zbirenbaum/copilot.lua',
  dependencies = {
    'copilotlsp-nvim/copilot-lsp', -- (optional) for NES functionality
  },
  cmd = 'Copilot',
  event = 'InsertEnter',
  config = function()
    require('copilot').setup {}
  end,
  opts = {
    -- It is recommended to disable copilot.lua's suggestion and panel modules,
    -- as they can interfere with completions properly appearing in copilot-cmp.
    suggestion = { enabled = false },
    panel = { enabled = false },
    filetypes = {
      markdown = true,
      help = true,
    },
    nes = {
      enabled = true, -- requires copilot-lsp as a dependency
    },
  },
}
