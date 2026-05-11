# Kickstart upstream review (since 2d541c4)

Last updated: 2026-05-11

| Hash | Link | Description | Relevant? | Risk | Category | Notes |
| --- | --- | --- | --- | --- | --- | --- |
| e79572c | [github](https://github.com/nvim-lua/kickstart.nvim/commit/e79572c9e6978787af2bca164a85ab6821caeb7b) | fix: continue cleaning up docs and config | yes | mid | lsp | Partially applied (mason-lspconfig removal + lua_ls setup); diagnostic reorg not applied |
| 7e54a4c | [github](https://github.com/nvim-lua/kickstart.nvim/commit/7e54a4c5c80ccefa993777accbce97a20f5348cc) | fix: trimming down config and updating stylua | yes | low | style | Applied (stylua collapse_simple_statement + formatting cleanup) |
| 8c6b78c | [github](https://github.com/nvim-lua/kickstart.nvim/commit/8c6b78c770e34f8b9cb028633403b85010f28d7e) | feat(grep-string): works with visual selection too | no | n/a | keymap | Telescope grep_string visual mode; you use Snacks and already map visual mode |
| 560d9dc | [github](https://github.com/nvim-lua/kickstart.nvim/commit/560d9dc894b78152920f576fb1bdee1e20d83ee7) | docs: Document methods to get the latest neovim | yes | low | docs | Applied (README updated) |
| 21d5aab | [github](https://github.com/nvim-lua/kickstart.nvim/commit/21d5aabc22ac44fc9404953a0b77944879465dd0) | fix: simplify diagnostic config | yes | mid | diagnostics | Deferred (keeping custom virtual_lines/signs config) |
| 318bd3e | [github](https://github.com/nvim-lua/kickstart.nvim/commit/318bd3e65c1bd1b4f55e179b87c073191746b272) | fix: update neovim min required version | yes | low | setup | Applied (health check now requires 0.11) |
| e87b728 | [github](https://github.com/nvim-lua/kickstart.nvim/commit/e87b7281ed19a49d528dec16dc0967616c1dc045) | feat: move Telescope config to be contained by plugin | no | n/a | telescope | Telescope-only reorg; you use Snacks |
| 88c6559 | [github](https://github.com/nvim-lua/kickstart.nvim/commit/88c65592ae8130224e9b132a75f95c685d62d5bd) | chore: Add .DS_Store to .gitignore | yes | low | chore | Applied |
| b15cca8 | [github](https://github.com/nvim-lua/kickstart.nvim/commit/b15cca8d3176e90a0fa59ce04e5baf966f0da395) | chore: fix help tag | yes | low | docs | Applied (comment fix) |
| 8f479db | [github](https://github.com/nvim-lua/kickstart.nvim/commit/8f479db12312e44e697dd3a222f9552505af189a) | feat: add Telescope binding for searching through commands | no | n/a | telescope | Telescope-only keymap |
| 3582280 | [github](https://github.com/nvim-lua/kickstart.nvim/commit/35822809e6c059cd7c0f7a46266ac4fba2890a61) | fix: remove deprecated methods | yes | low | lsp | Applied (direct supports_method calls) |
| b2af42a | [github](https://github.com/nvim-lua/kickstart.nvim/commit/b2af42acb33dc411498e4c2e1717a33348b6954c) | fix: call setup on guess indent | yes | low | plugin-setup | Already applied (`opts = {}`) |
| c8e189f | [github](https://github.com/nvim-lua/kickstart.nvim/commit/c8e189ff7876d1af2d79afa343c1c6228ddd9f8b) | fix: adjust after mini.nvim transfer to nvim-mini org | yes | low | plugin-update | Applied (repo updated to `nvim-mini/mini.nvim`) |
| ad246eb | [github](https://github.com/nvim-lua/kickstart.nvim/commit/ad246eb5dd5fdd3e4ad42ae974b919ff887f2f0a) | fix: remove mason-lspconfig, we do not need it anymore | yes | mid | lsp | Applied with local Mason package mapping |
| 0c17d32 | [github](https://github.com/nvim-lua/kickstart.nvim/commit/0c17d320bb70b8e0a59608747508f102b1e41173) | maybe: seeing if we can get away without lazydev | yes | mid | lsp | Applied (lazydev removed; lua_ls on_init kept) |
| 7ea937d | [github](https://github.com/nvim-lua/kickstart.nvim/commit/7ea937dbc5933c7769b163e079b244f3a7a45063) | fix: updated to the right tree sitter stuff | yes | high | treesitter | Applied (rewrite to install list + vim.treesitter.start; expanded parser/filetype list; auto-install removed) |
| 3ddda4a | [github](https://github.com/nvim-lua/kickstart.nvim/commit/3ddda4a8b8fd25f3a1d982ec0821043d1d9c607b) | update: remove client_supports_method | yes | mid | lsp | Applied |
| 5740ddc | [github](https://github.com/nvim-lua/kickstart.nvim/commit/5740ddcf9c89c616b114e0b6c39ac66f857d609b) | note: add info about why we ignore lazy-lock | yes | low | chore | Applied (.gitignore note) |
| 2d541c4 | [github](https://github.com/nvim-lua/kickstart.nvim/commit/2d541c41402abd53aa601e9a10e1dafea42b975c) | fix: update main module reference for nvim-treesitter | yes | low | treesitter | Not applied (rewrite no longer uses `main` module) |

## 2026-05-11 update: post-`dabce46` selective backport plan

Current baseline (GitHub compare `master...nickgnd:nico/nvim-kickstarter`):

- Status: diverged
- Fork branch behind upstream: 77 commits
- Fork branch ahead upstream: 89 commits
- Common ancestor: `e947649`
- Latest upstream tip reviewed: merge commit `cfdc17b` (contains `a5d4d12`)

### Missing upstream tail (after `dabce46`)

| Order | Upstream hash | Description | Relevant? | Risk | Impact | Size | Plan |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | a5d4d12 (via cfdc17b) | fix: deprecated diagnostic jumping config | yes | low | med | S | Apply first (diagnostic jump callback update) |
| 2 | d97de4f | Remove blink from nvim-lspconfig dependencies | yes | low | low-med | S | Apply (dependency cleanup) |
| 3 | 9b4fbc5 + 4b065ad | Fix mini.ai mapping conflicts + example | yes | low | med | S | Apply (avoid Neovim 0.12 key collisions) |
| 4 | 886f2bc + 648471c + 16dd8f5 | Clarify gitsigns/lint comments and labels | optional | low | low | S | Apply only if no local preference conflict |
| 5 | 8ac4b12 + e01e1eb + c7f05a0 + f27810d | Treesitter attach/auto-install/indent fallback updates | yes | med | med | M | Evaluate and adapt incrementally |
| 6 | 459b868 + ce353a9 | Conform + lua_ls formatting behavior changes | yes | med | med | M | Evaluate against local formatting workflow |
| 7 | c460542 + 716d746 + 2e8d5b1 + 2fccee4 | Migrate to vim.pack and major init refactor | no (for now) | high | high | L | Explicitly deferred |

### Execution plan

1. Apply commit 1 (`a5d4d12`) as a surgical diagnostics-only patch.
2. Apply commit 2 (`d97de4f`) and commit 3 (`9b4fbc5` + `4b065ad`) as isolated small patches.
3. Run focused validation after each commit:
   - `stylua` formatting check
   - headless startup check
   - LSP smoke test on an Elixir file (`*.exs`) and verify no startup/LSP errors
4. Defer medium/high scope items to a separate follow-up branch/PR.
