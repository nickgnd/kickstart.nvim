-- Copilot Chat for Neovim
--
-- https://github.com/CopilotC-Nvim/CopilotChat.nvim
--
return {
  'CopilotC-Nvim/CopilotChat.nvim',
  lazy = false,
  dependencies = {
    { 'zbirenbaum/copilot.lua' },
    { 'nvim-lua/plenary.nvim', branch = 'master' }, -- for curl, log and async functions
  },
  build = 'make tiktoken', -- Only on MacOS or Linux
  opts = {
    -- See Configuration section for options
    model = 'claude-3.5-sonnet',
  },
  keys = {
    {
      '<leader>ccq',
      function()
        -- Create floating window
        local float = require('custom.functions.floating_window').create_centered_float {
          width = 60,
          height = 2,
          border = 'rounded',
          title = 'Copilot Quick Chat',
        }

        -- Set the buffer type to nofile for a temporary buffer
        vim.bo[float.buf].buftype = 'nofile'

        -- Set up callback for when Enter is pressed
        vim.keymap.set('i', '<CR>', function()
          local input = vim.api.nvim_buf_get_lines(float.buf, 0, -1, false)[1]

          -- Close the floating window
          vim.api.nvim_win_close(float.win, true)

          -- If input is not empty, send to Copilot and use
          -- the current buffer as selection
          if input ~= '' then
            require('CopilotChat').ask(input, { selection = require('CopilotChat.select').buffer })
          end
        end, { buffer = float.buf, noremap = true })

        -- Set up escape to close window
        vim.keymap.set('i', '<Esc>', function()
          vim.api.nvim_win_close(float.win, true)
        end, { buffer = float.buf, noremap = true })

        -- Enter insert mode at the end of prompt
        vim.cmd 'startinsert!'
      end,
      desc = 'CopilotChat - Quick chat',
    },
  },
  -- See Commands section for default commands if you want to lazy load on them
}
