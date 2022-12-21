local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
  return
end

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/code_actions
local code_actions = null_ls.builtins.code_actions
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/hover
local hover = null_ls.builtins.hover
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/completion
local completion = null_ls.builtins.completion

-- https://github.com/prettier-solidity/prettier-plugin-solidity
null_ls.setup({
  debug = false,
  sources = {
    formatting.prettier,
    formatting.black.with({ extra_args = { "--fast" } }),
    formatting.stylua,
    formatting.google_java_format,
    diagnostics.flake8,
    diagnostics.eslint,
    diagnostics.cspell.with({
      diagnostics_postprocess = function (diagnostic)
        diagnostic.severity = vim.diagnostic.severity.INFO
      end,
      -- severities = {
      --   [vim.diagnostic.severity.ERROR] = vim.diagnostic.severity.INFO,
      -- },
    }),
  },
})
