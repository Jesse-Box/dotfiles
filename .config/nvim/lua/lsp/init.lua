local status_ok, _ = pcall(require, 'lspconfig')
if not status_ok then
  return
end

require 'lsp._nvim-lsp-installer'
require('lsp.handlers').setup()
