return {
  {
    "neovim/nvim-lspconfig",
    event = "LazyFile",
    dependencies = {
      "williamboman/mason.nvim",
      "antosha417/nvim-lsp-file-operations",
    },
    opts = {},
    config = require("plugins.lsp.config").setup,
  },
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    opts = {
      registries = {
        "github:mason-org/mason-registry",
      },
      ensure_installed = {},
      ui = { border = "rounded", width = 0.6, height = 0.7 },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      local function ensure_installed()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end
      if mr.refresh then
        mr.refresh(ensure_installed)
      else
        ensure_installed()
      end
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    event = "LazyFile",
    opts = { sources = {} },
  },
}
