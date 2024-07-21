-- Project configuration
return {
  'tpope/vim-projectionist',
  config = function()
    vim.g.projectionist_heuristics = {
      ['mix.exs'] = {
        ['*'] = {
          console = 'iex -S mix',
          make = 'mix',
        },
        ['lib/*.ex'] = {
          type = 'source',
          alternate = 'test/{}_test.exs',
          template = {
            'defmodule {camelcase|capitalize|dot} do',
            'end',
          },
        },
        ['test/*_test.exs'] = {
          type = 'test',
          alternate = 'lib/{}.ex',
          template = {
            'defmodule {camelcase|capitalize|dot}Test do',
            '  use ExUnit.Case, async: true',
            '',
            '  alias {camelcase|capitalize|dot}',
            'end',
          },
        },
      },
    }
  end,
}
