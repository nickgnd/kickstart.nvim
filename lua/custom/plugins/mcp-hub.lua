return {
  'ravitemer/mcphub.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  -- In case mcphub executable is not found, just install it manually
  -- `npm install -g mcp-hub`
  build = 'bundled_build.lua', -- Bundles `mcp-hub` binary along with the neovim plugin
  config = function()
    require('mcphub').setup {
      use_bundled_binary = true, -- Use local `mcp-hub` binary
    }
  end,
}
