-- This file configures the CodeCompanion.nvim plugin for Neovim.
-- It includes dependencies, options, and extensions to enhance the development experience.
-- https://codecompanion.olimorris.dev/installation.html

return {
  'olimorris/codecompanion.nvim',
  lazy = false,
  dependencies = {
    { 'nvim-lua/plenary.nvim', branch = 'master' },
    'nvim-treesitter/nvim-treesitter',
    'ravitemer/mcphub.nvim',
    {
      'saghen/blink.cmp',
      ---@module 'blink.cmp'
      ---@type blink.cmp.Config
      opts = {
        sources = {
          default = { 'codecompanion' },
          providers = {
            codecompanion = {
              name = 'CodeCompanion',
              module = 'codecompanion.providers.completion.blink',
              enabled = true,
            },
          },
        },
      },
      opts_extend = {
        'sources.default',
      },
    },
  },
  opts = {
    -- opts = {
    --   log_level = 'DEBUG',
    -- },
    display = {
      action_palette = {
        provider = 'snacks',
      },
      chat = {
        -- Enable to inspect the chat settings, but when enabled is impossible to change provider
        show_settings = false,
      },
    },
    adapters = {
      opts = {
        show_defaults = true,
        show_model_choices = true,
      },
      copilot_claude = function()
        return require('codecompanion.adapters').extend('copilot', {
          name = 'copilot_claude',
          schema = {
            model = {
              default = 'claude-3.7-sonnet',
            },
          },
        })
      end,
    },
    strategies = {
      chat = {
        adapter = 'copilot_claude',
        keymaps = {
          send = {
            callback = function(chat)
              vim.cmd 'stopinsert'
              chat:add_buf_message { role = 'llm', content = '' }
              chat:submit()
            end,
            index = 1,
            description = 'Send',
          },
        },
        slash_commands = {
          ['git_diff'] = {
            description = 'Use git diff',
            ---@param chat CodeCompanion.Chat
            callback = function(chat)
              local snacks = require 'snacks'

              snacks.picker.pick {
                source = 'custom_git_diff_source',
                title = 'Git diff sources',
                items = {
                  { text = 'Working Tree' },
                  { text = 'Staged' },
                },
                format = function(item, picker)
                  local ret = {
                    { item.text, item.text_hl },
                  } ---@type snacks.picker.Highlight[]
                  return ret
                end,
                single_select = true,
                layout = {
                  fullscreen = false,
                  hidden = { 'preview' },
                },
                confirm = function(picker, item)
                  picker:close()
                  local cmd = item.text == 'Working Tree' and 'git --no-pager diff --no-ext-diff --no-color'
                    or 'git --no-pager diff --no-ext-diff --no-color --staged'

                  local handle = io.popen(cmd)
                  if handle ~= nil then
                    local result = handle:read '*a'
                    handle:close()
                    if result ~= '' then
                      chat:add_reference({ role = 'user', content = result }, 'git', '<git_diff>')
                    else
                      vim.notify('No changes in git diff', vim.log.levels.INFO, { title = 'CodeCompanion' })
                    end
                  else
                    vim.notify('Could not retrieve git diff', vim.log.levels.ERROR, { title = 'CodeCompanion' })
                  end
                end,
              }
            end,
            opts = {
              contains_code = true,
            },
          },
        },
      },
      inline = { adapter = 'copilot_claude' },
    },
    --
    extensions = {
      mcphub = {
        callback = 'mcphub.extensions.codecompanion',
        opts = {
          make_vars = true,
          make_slash_commands = true,
          show_result_in_chat = true,
        },
      },
    },
    prompt_library = {
      ['Review git diff in working tree'] = {
        strategy = 'chat',
        description = 'Review git diff',
        opts = {
          index = 12,
          is_default = true,
          is_slash_cmd = false,
          short_name = 'git_diff_review',
          auto_submit = false,
        },
        prompts = {
          {
            role = 'user',
            content = function()
              return string.format(
                [[You are an expert Senior Software Engineer tasked to review some code.
Follow these steps:
1. Identify the programming language
2. Look at the git diff and contextualize it
3. Read carefully the changes and try to understand the final goal, if not clear, ask to the user.
4. Identify potential issues, improvements, and best practices
5. Consider any security risks
6. Consider alternative approaches and optimizations to reach the same result
7. Provide a summary of your review and suggestions for improvement

**git diff**

```diff
%s
```]],
                vim.fn.system 'git --no-pager diff --no-ext-diff'
              )
            end,
            opts = {
              contains_code = true,
            },
          },
        },
      },
    },
  },
  config = function(_, opts)
    local spinner = require 'custom.functions.code-companion-spinner'
    spinner:init()

    -- Setup the entire opts table
    require('codecompanion').setup(opts)
  end,
}
