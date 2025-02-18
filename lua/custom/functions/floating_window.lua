-- Function to create a centered floating window.
--
local M = {}

function M.create_centered_float(opts)
  -- Default options
  opts = opts or {}
  local width = opts.width or 80
  local height = opts.height or 20
  local border = opts.border or 'rounded'
  local title = opts.title or '' -- Add title option

  -- Get editor dimensions
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)
  --
  -- Window options
  local win_opts = {
    relative = 'editor',
    row = row,
    col = col,
    width = width,
    height = height,
    style = 'minimal',
    border = border,
    title = title,
    title_pos = 'center',
  }

  -- Create buffer
  local buf = vim.api.nvim_create_buf(false, true)

  -- Create window
  local win = vim.api.nvim_open_win(buf, true, win_opts)

  -- Return both buffer and window IDs
  return {
    buf = buf,
    win = win,
  }
end

return M
