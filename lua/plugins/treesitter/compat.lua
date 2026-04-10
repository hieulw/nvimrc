local M = {}

local function query_opts()
  if vim.fn.has("nvim-0.10") == 1 then
    return { force = true, all = false }
  end
  return true
end

local function normalize_node(node)
  if type(node) == "table" then
    for _, candidate in ipairs(node) do
      if type(candidate) == "userdata" then
        return candidate
      end
    end
    return nil
  end
  if type(node) == "userdata" then
    return node
  end
  return nil
end

local html_script_type_languages = {
  importmap = "json",
  module = "javascript",
  ["application/ecmascript"] = "javascript",
  ["text/ecmascript"] = "javascript",
}

local non_filetype_match_injection_language_aliases = {
  ex = "elixir",
  pl = "perl",
  sh = "bash",
  uxn = "uxntal",
  ts = "typescript",
}

local function parser_from_markdown_info_string(injection_alias)
  local match = vim.filetype.match({ filename = "a." .. injection_alias })
  return match or non_filetype_match_injection_language_aliases[injection_alias] or injection_alias
end

function M.setup()
  local ok, query = pcall(require, "vim.treesitter.query")
  if not ok then
    return
  end

  local opts = query_opts()

  query.add_directive("set-lang-from-mimetype!", function(match, _, bufnr, pred, metadata)
    local capture_id = pred[2]
    local node = normalize_node(match[capture_id])
    if not node then
      return
    end

    local type_attr_value = vim.treesitter.get_node_text(node, bufnr)
    local configured = html_script_type_languages[type_attr_value]
    if configured then
      metadata["injection.language"] = configured
    else
      local parts = vim.split(type_attr_value, "/", {})
      metadata["injection.language"] = parts[#parts]
    end
  end, opts)

  query.add_directive("set-lang-from-info-string!", function(match, _, bufnr, pred, metadata)
    local capture_id = pred[2]
    local node = normalize_node(match[capture_id])
    if not node then
      return
    end

    local text = vim.treesitter.get_node_text(node, bufnr)
    if not text or text == "" then
      return
    end
    local injection_alias = text:lower()
    metadata["injection.language"] = parser_from_markdown_info_string(injection_alias)
  end, opts)

  query.add_directive("downcase!", function(match, _, bufnr, pred, metadata)
    local id = pred[2]
    local node = normalize_node(match[id])
    if not node then
      return
    end

    local text = vim.treesitter.get_node_text(node, bufnr, { metadata = metadata[id] }) or ""
    if not metadata[id] then
      metadata[id] = {}
    end
    metadata[id].text = string.lower(text)
  end, opts)
end

return M
