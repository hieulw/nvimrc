local colors = require("gruvbox").palette

return {
  normal = {
    a = { bg = "None", fg = colors.light4, gui = "bold" },
    b = { bg = "None", fg = colors.light4 },
    c = { bg = "None", fg = colors.light4 },
  },
  insert = {
    a = { bg = "None", fg = colors.bright_blue, gui = "bold" },
    b = { bg = "None", fg = colors.light4 },
    c = { bg = "None", fg = colors.light4 },
  },
  visual = {
    a = { bg = "None", fg = colors.bright_yellow, gui = "bold" },
    b = { bg = "None", fg = colors.light4 },
    c = { bg = "None", fg = colors.light4 },
  },
  replace = {
    a = { bg = "None", fg = colors.bright_red, gui = "bold" },
    b = { bg = "None", fg = colors.light4 },
    c = { bg = "None", fg = colors.light4 },
  },
  command = {
    a = { bg = "None", fg = colors.bright_green, gui = "bold" },
    b = { bg = "None", fg = colors.light4 },
    c = { bg = "None", fg = colors.light4 },
  },
  inactive = {
    a = { bg = "None", fg = colors.light4, gui = "bold" },
    b = { bg = "None", fg = colors.light4 },
    c = { bg = "None", fg = colors.light4 },
  },
}
