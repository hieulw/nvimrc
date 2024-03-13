return {
  {
    "kndndrj/nvim-dbee",
    enabled = false,
    build = function()
      require("dbee").install()
    end,
    opts = {
      extra_helpers = {
        ["postgres"] = {
          ["List All"] = "select * from {{ .Table }}",
        },
      },
      drawer = {
        disable_help = true,
      },
    },
    keys = function()
      local dbee = require("dbee")
      return {
        { "<leader>db", dbee.toggle, mode = "n", desc = "Open database UI" },
      }
    end,
  },
}
