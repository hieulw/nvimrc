local M = {}

local colors = {
  black = "#282828",
  white = "#ebdbb2",
  red = "#fb4934",
  green = "#b8bb26",
  blue = "#83a598",
  yellow = "#fe8019",
  gray = "#a89984",
  darkgray = "#3c3836",
  lightgray = "#504945",
  inactivegray = "#7c6f64",
}

M.lualine = {
  normal = {
    a = { bg = colors.black, fg = colors.gray, gui = "bold" },
    b = { bg = colors.lightgray, fg = colors.white },
    c = { bg = colors.black, fg = colors.gray },
  },
  insert = {
    a = { bg = colors.black, fg = colors.blue, gui = "bold" },
    b = { bg = colors.lightgray, fg = colors.white },
    c = { bg = colors.black, fg = colors.white },
  },
  visual = {
    a = { bg = colors.black, fg = colors.yellow, gui = "bold" },
    b = { bg = colors.lightgray, fg = colors.white },
    c = { bg = colors.black, fg = colors.white },
  },
  replace = {
    a = { bg = colors.black, fg = colors.red, gui = "bold" },
    b = { bg = colors.lightgray, fg = colors.white },
    c = { bg = colors.black, fg = colors.white },
  },
  command = {
    a = { bg = colors.black, fg = colors.green, gui = "bold" },
    b = { bg = colors.lightgray, fg = colors.white },
    c = { bg = colors.black, fg = colors.white },
  },
  inactive = {
    a = { bg = colors.darkgray, fg = colors.gray, gui = "bold" },
    b = { bg = colors.darkgray, fg = colors.gray },
    c = { bg = colors.darkgray, fg = colors.gray },
  },
}

return M
