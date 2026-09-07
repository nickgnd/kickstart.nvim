-- sidekick.nvim multiplexer backend for herdr (https://github.com/ogulcancelik/herdr).
--
-- Lets sidekick discover the AI agent already running in a *peer* herdr pane and
-- send it context (file paths, selections, prompts) — the herdr equivalent of the
-- built-in tmux/zellij backends. herdr's socket CLI exposes everything we need:
--   herdr pane list                       -> panes, each tagged with its `agent`
--   herdr pane get <id>                   -> pane still alive?
--   herdr pane send-text <id> <text>      -> paste literal text (bracketed paste)
--   herdr pane send-keys <id> enter       -> submit
--   herdr pane split ... / pane run <id>  -> spawn a fresh agent pane
--   herdr pane read <id> ...              -> scrollback for context
--
-- Registered as the "herdr" backend and selected via cli.mux.backend in the
-- plugin spec (see custom/plugins/sidekick.lua).
--
-- We can remove this custom implementation when this PR land on main
-- https://github.com/folke/sidekick.nvim/pull/333
local Config = require 'sidekick.config'
local Util = require 'sidekick.util'

---@class sidekick.cli.muxer.Herdr: sidekick.cli.Session
---@field herdr_pane_id string
local M = {}
M.__index = M
M.priority = 50

-- Run a herdr subcommand. Returns (lines, stdout) like Util.exec, or nil on error.
---@param args string[]
---@param opts? table
local function herdr(args, opts) return Util.exec(vim.list_extend({ 'herdr' }, args), opts or { notify = false }) end

-- Run a herdr subcommand and return the decoded `.result`, or nil.
---@param args string[]
local function result(args)
  local _, stdout = herdr(args)
  if not stdout or stdout == '' then return nil end
  local ok, data = pcall(vim.json.decode, stdout)
  return ok and data and data.result or nil
end

-- Map a herdr agent label ("claude") to a configured sidekick tool.
---@param agent string
local function tool_for(agent)
  local tools = Config.tools()
  if tools[agent] then return tools[agent] end
  local want = agent:lower()
  for name, tool in pairs(tools) do
    if name:lower() == want then return tool end
  end
end

-- herdr panes are peers of Neovim, never embedded in an nvim terminal.
function M:init()
  self.external = true
  self.priority = 50
end

-- Discover agents running in herdr panes.
---@return sidekick.cli.session.State[]
function M.sessions()
  local res = result { 'pane', 'list' }
  local ret = {} ---@type sidekick.cli.session.State[]
  for _, pane in ipairs(res and res.panes or {}) do
    local tool = pane.agent and tool_for(pane.agent)
    if tool then
      ret[#ret + 1] = {
        id = 'herdr ' .. pane.pane_id,
        cwd = pane.foreground_cwd or pane.cwd,
        tool = tool,
        herdr_pane_id = pane.pane_id,
        mux_session = pane.workspace_id,
      }
    end
  end
  return ret
end

-- Existing peer pane: nothing to spawn, so no terminal Cmd is returned.
---@return sidekick.cli.terminal.Cmd?
function M:attach() end

-- No running agent yet: split off a new herdr pane and launch the tool in it.
---@return sidekick.cli.terminal.Cmd?
function M:start()
  local split = Config.cli.mux.split or {}
  local size = split.size or 0.4
  local args = {
    'pane',
    'split',
    '--direction',
    split.vertical and 'right' or 'down',
    '--ratio',
    tostring(size <= 1 and size or 0.4),
    '--cwd',
    self.cwd,
    '--focus',
  }
  for key, value in pairs(self.tool.env or {}) do
    if value ~= false then vim.list_extend(args, { '--env', ('%s=%s'):format(key, tostring(value)) }) end
  end
  local res = result(args)
  local pane = res and res.pane
  if not pane then
    Util.error('herdr: failed to split a pane for **' .. self.tool.name .. '**')
    return
  end
  self.herdr_pane_id = pane.pane_id
  self.started = true
  -- herdr queues the command until the pane's shell is ready.
  herdr { 'pane', 'run', pane.pane_id, table.concat(self.tool.cmd, ' ') }
  Util.info(('Started **%s** in a new herdr pane'):format(self.tool.name))
end

function M:is_running()
  local res = result { 'pane', 'get', self.herdr_pane_id }
  return res ~= nil and res.pane ~= nil
end

-- Paste text into the agent's pane (bracketed paste; does not submit).
function M:send(text) herdr { 'pane', 'send-text', self.herdr_pane_id, text } end

-- Submit the pasted input.
function M:submit() herdr { 'pane', 'send-keys', self.herdr_pane_id, 'enter' } end

-- Scrollback for context, so the AI can read what's on screen.
function M:dump()
  local _, stdout = herdr {
    'pane',
    'read',
    self.herdr_pane_id,
    '--source',
    'recent',
    '--lines',
    tostring(Config.cli.mux.dump or 1000),
    '--format',
    'ansi',
  }
  return stdout
end

return M
