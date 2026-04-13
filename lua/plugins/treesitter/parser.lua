local M = {}

local parsers = {
  blade = {
    install_info = {
      url = "https://github.com/emranmr/tree-sitter-blade",
      files = { "src/parser.c" },
      branch = "main",
    },
    filetype = "blade",
  },
  jsonc = {
    install_info = {
      url = "https://github.com/sunilunnithan/tree-sitter-jsonc",
      files = { "src/parser.c" },
      branch = "main",
    },
    filetype = "jsonc",
  },
}

local function register_custom_parsers()
  local parser_config = require("nvim-treesitter.parsers")
  if type(parser_config.get_parser_configs) == "function" then
    parser_config = parser_config.get_parser_configs()
  end

  for parser, config in pairs(parsers) do
    parser_config[parser] = config
  end
end

function M.setup()
  register_custom_parsers()

  local group = vim.api.nvim_create_augroup("user_treesitter_custom_parsers", { clear = true })
  vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = "TSUpdate",
    callback = register_custom_parsers,
  })
end

return M
