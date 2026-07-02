-- https://github.com/norcalli/nvim-colorizer.lua
-- This plugin allows me to see the colors of hex code inside files

return {
  'catgoose/nvim-colorizer.lua',
  event = 'VeryLazy',
  config = function() require('colorizer').setup() end,
}
