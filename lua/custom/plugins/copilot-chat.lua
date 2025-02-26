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
    model = 'claude-3.7-sonnet',
    contexts = {
      -- Open a file picker to select a file
      -- https://github.com/CopilotC-Nvim/CopilotChat.nvim/issues/690#issuecomment-2551162017
      file = {
        input = function(callback)
          local telescope = require 'telescope.builtin'
          local actions = require 'telescope.actions'
          local action_state = require 'telescope.actions.state'
          telescope.find_files {
            attach_mappings = function(prompt_bufnr)
              actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                callback(selection[1])
              end)
              return true
            end,
          }
        end,
      },
    },
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
