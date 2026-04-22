return {
  'stevearc/conform.nvim',
  opts = {
    formatters_by_ft = {
      json = { 'prettier', 'jq', stop_after_first = true },
      lua = { 'stylua' },
      markdown = { 'prettier', 'rumdl', stop_after_first = true },
      toml = { 'taplo' },
      yaml = { 'prettier', 'yq', stop_after_first = true },
    },
  },
}
