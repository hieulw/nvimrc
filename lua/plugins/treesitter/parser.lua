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
}

function M.setup()
  local parser_config = require("nvim-treesitter.parsers")
  if type(parser_config.get_parser_configs) == "function" then
    parser_config = parser_config.get_parser_configs()
  end

  for parser, config in pairs(parsers) do
    if parser_config[parser] == nil then
      parser_config[parser] = config
    end
  end
end

return M
