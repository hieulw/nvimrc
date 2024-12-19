vim.treesitter.language.register("bash", { "tmux", "zsh", "sh" })
vim.filetype.add({
  extension = {
    html = function(_, bufnr)
      local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false) or { "" }
      local content = table.concat(lines, "\n")
      if vim.regex([[{{\|{#\|{%\s.+\s%}\|#}\|}}]]):match_str(content) ~= nil then
        return "htmldjango"
      end
      return "html"
    end,
    tfstate = "json",
  },
  pattern = {
    [".*/hypr/.*%.conf"] = "hyprlang",
    [".*/templates/.*%.yaml"] = "helm",
    [".*/templates/.*%.tpl"] = "helm",
    [".*%.blade%.php"] = "blade",
    ["Dockerfile-.*"] = "dockerfile",
    ["Jenkinsfile-.*"] = "groovy",
  },
})
