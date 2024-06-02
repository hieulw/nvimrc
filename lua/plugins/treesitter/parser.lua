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
  local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
  for parser, config in pairs(parsers) do
    parser_config[parser] = config
  end
end

return M
