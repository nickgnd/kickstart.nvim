-- Seamless ctrl-hjkl navigation between neovim splits and the outer multiplexer.
-- Works in BOTH tmux (via christoomey/vim-tmux-navigator) and herdr (via the
-- `herdr pane focus` CLI, paired with bin/herdr-nav), and falls back to plain
-- window moves when there is no multiplexer.
local cap = { h = 'Left', j = 'Down', k = 'Up', l = 'Right' }
local word = { h = 'left', j = 'down', k = 'up', l = 'right' }

-- Hand focus to the herdr pane in direction `key`, if we're inside herdr.
local function herdr_focus(key)
  if vim.env.HERDR_PANE_ID or vim.env.HERDR_SOCKET_PATH then
    vim.fn.system({ 'herdr', 'pane', 'focus', '--direction', word[key], '--current' })
  end
end

-- Is a floating window flush against the screen edge in direction `key`?
-- Inside a float (e.g. the snacks explorer sidebar) `wincmd`/`winnr()` pick an
-- arbitrary window instead of respecting direction, so we can't detect an edge
-- by moving. A docked float sits at a screen edge, which is exactly the
-- "no nvim window that way, hand off to the multiplexer" condition.
local function float_at_edge(key)
  local pos = vim.fn.win_screenpos(0)
  local row, col = pos[1], pos[2]
  local w = vim.api.nvim_win_get_width(0)
  local h = vim.api.nvim_win_get_height(0)
  if key == 'h' then return col <= 1 end
  if key == 'l' then return col + w - 1 >= vim.o.columns end
  if key == 'k' then return row <= 1 end
  return row + h - 1 >= vim.o.lines - vim.o.cmdheight - 1 -- 'j'
end

-- Move focus in direction `key` ('h'|'j'|'k'|'l').
local function nav(key)
  if vim.env.TMUX then
    -- tmux: let vim-tmux-navigator handle the wincmd + tmux pane handoff.
    vim.cmd('TmuxNavigate' .. cap[key])
    return
  end
  -- herdr / no multiplexer: move within nvim; at an edge hand off to herdr.
  if vim.api.nvim_win_get_config(0).relative ~= '' then
    -- Floating window: the winnr() diff below misfires, so use the screen box.
    if float_at_edge(key) then
      herdr_focus(key)
    else
      vim.cmd('wincmd ' .. key)
    end
    return
  end
  local before = vim.fn.winnr()
  vim.cmd('wincmd ' .. key)
  if vim.fn.winnr() == before then
    herdr_focus(key)
  end
end

-- Terminal mode: leave terminal-insert first, then navigate.
local function tnav(key)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-\\><C-n>', true, false, true), 'n', false)
  vim.schedule(function() nav(key) end)
end

return {
  'christoomey/vim-tmux-navigator',
  cmd = {
    'TmuxNavigateLeft',
    'TmuxNavigateDown',
    'TmuxNavigateUp',
    'TmuxNavigateRight',
    'TmuxNavigatePrevious',
    'TmuxNavigatorProcessList',
  },
  keys = {
    { mode = 'n', '<c-h>', function() nav('h') end, desc = 'Nav split/pane left' },
    { mode = 'n', '<c-j>', function() nav('j') end, desc = 'Nav split/pane down' },
    { mode = 'n', '<c-k>', function() nav('k') end, desc = 'Nav split/pane up' },
    { mode = 'n', '<c-l>', function() nav('l') end, desc = 'Nav split/pane right' },
    { mode = 'n', '<c-\\>', '<cmd>TmuxNavigatePrevious<cr>', desc = 'Nav previous (tmux)' },
    { mode = 't', '<c-h>', function() tnav('h') end, desc = 'Nav split/pane left' },
    { mode = 't', '<c-j>', function() tnav('j') end, desc = 'Nav split/pane down' },
    { mode = 't', '<c-k>', function() tnav('k') end, desc = 'Nav split/pane up' },
    { mode = 't', '<c-l>', function() tnav('l') end, desc = 'Nav split/pane right' },
  },
  init = function()
    -- Disable default mappings; we define our own above.
    -- https://github.com/christoomey/vim-tmux-navigator/issues/468
    vim.g.tmux_navigator_no_mappings = 1
  end,
}
