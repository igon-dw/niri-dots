local M = {}

local placeholder = {
  title = '__MARKDOWN_PREVIEW_TITLE__',
  base_href = '__MARKDOWN_PREVIEW_BASE_HREF__',
  markdown_b64 = '__MARKDOWN_PREVIEW_MARKDOWN_B64__',
}

local function notify(message, level)
  local ok, snacks = pcall(require, 'snacks')
  if ok then
    snacks.notify(message, {
      title = 'Markdown Preview',
      level = level or vim.log.levels.INFO,
    })
    return
  end

  vim.notify(message, level or vim.log.levels.INFO, { title = 'Markdown Preview' })
end

local function html_escape(value)
  return value:gsub('&', '&amp;'):gsub('<', '&lt;'):gsub('>', '&gt;'):gsub('"', '&quot;'):gsub("'", '&#39;')
end

local function replace_token(content, token, value)
  return (content:gsub(token, function()
    return value
  end))
end

local function base64_encode(value)
  if vim.base64 and vim.base64.encode then
    return vim.base64.encode(value)
  end

  local encoded = vim.fn.system('base64 -w0', value)
  return encoded:gsub('%s+', '')
end

local function get_cache_dir()
  local cache_dir = vim.fs.joinpath(vim.fn.stdpath 'cache', 'markdown-preview')
  vim.fn.mkdir(cache_dir, 'p')
  return cache_dir
end

local function get_output_path(bufnr)
  local buffer_name = vim.api.nvim_buf_get_name(bufnr)
  if buffer_name == '' then
    return vim.fs.joinpath(get_cache_dir(), ('buffer-%d.html'):format(bufnr))
  end

  local absolute_path = vim.fn.fnamemodify(buffer_name, ':p')
  local safe_name = absolute_path:gsub('^/', ''):gsub('[^%w%._-]', '_')
  return vim.fs.joinpath(get_cache_dir(), safe_name .. '.html')
end

local function get_base_href(bufnr)
  local buffer_name = vim.api.nvim_buf_get_name(bufnr)
  local base_dir = buffer_name ~= '' and vim.fn.fnamemodify(buffer_name, ':p:h') or vim.fn.getcwd()
  local base_href = vim.uri_from_fname(base_dir)
  if not base_href:match '/$' then
    base_href = base_href .. '/'
  end
  return base_href
end

local function get_title(bufnr)
  local buffer_name = vim.api.nvim_buf_get_name(bufnr)
  if buffer_name == '' then
    return 'Markdown Preview'
  end
  return vim.fn.fnamemodify(buffer_name, ':t')
end

local function trim(value)
  return (value:gsub('^%s+', ''):gsub('%s+$', ''))
end

local function get_default_browser_desktop()
  if vim.fn.executable 'xdg-settings' ~= 1 then
    return nil
  end

  local output = vim.fn.system { 'xdg-settings', 'get', 'default-web-browser' }
  if vim.v.shell_error ~= 0 then
    return nil
  end

  local desktop = trim(output)
  if desktop == '' then
    return nil
  end

  return desktop
end

local function open_in_browser(output_path)
  local file_uri = vim.uri_from_fname(output_path)
  local browser_desktop = get_default_browser_desktop()

  if browser_desktop and vim.fn.executable 'gtk-launch' == 1 then
    local job_id = vim.fn.jobstart({ 'gtk-launch', browser_desktop, file_uri }, { detach = true })
    if job_id > 0 then
      return true, browser_desktop
    end
  end

  local job_id = vim.fn.jobstart({ 'xdg-open', output_path }, { detach = true })
  if job_id > 0 then
    return true, 'xdg-open'
  end

  return false, nil
end

local template = [[
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>__MARKDOWN_PREVIEW_TITLE__</title>
    <base href="__MARKDOWN_PREVIEW_BASE_HREF__">
    <style>
      :root {
        color-scheme: light dark;
        --page-width: 960px;
        --page-padding: clamp(16px, 4vw, 40px);
        --border-color: color-mix(in srgb, currentColor 14%, transparent);
        --muted-color: color-mix(in srgb, currentColor 62%, transparent);
        --code-background: color-mix(in srgb, currentColor 8%, transparent);
      }

      * {
        box-sizing: border-box;
      }

      body {
        margin: 0;
        font-family: "Iosevka Aile", "Noto Sans", sans-serif;
        line-height: 1.7;
        background:
          radial-gradient(circle at top left, color-mix(in srgb, canvasText 9%, transparent), transparent 26%),
          linear-gradient(180deg, canvas, color-mix(in srgb, canvas 92%, canvasText 8%));
      }

      main {
        width: min(var(--page-width), calc(100vw - 2 * var(--page-padding)));
        margin: 0 auto;
        padding: 48px 0 72px;
      }

      article {
        overflow-wrap: anywhere;
      }

      h1, h2, h3, h4, h5, h6 {
        line-height: 1.25;
        margin-top: 1.7em;
        margin-bottom: 0.6em;
      }

      p, ul, ol, blockquote, table, pre {
        margin: 1em 0;
      }

      a {
        color: inherit;
      }

      blockquote {
        margin-left: 0;
        padding-left: 1em;
        border-left: 3px solid var(--border-color);
        color: var(--muted-color);
      }

      code {
        font-family: "Iosevka", "JetBrains Mono", monospace;
        font-size: 0.95em;
      }

      :not(pre) > code {
        padding: 0.15em 0.35em;
        border-radius: 0.35em;
        background: var(--code-background);
      }

      pre {
        padding: 1em 1.2em;
        border-radius: 14px;
        overflow-x: auto;
        background: var(--code-background);
      }

      table {
        width: 100%;
        border-collapse: collapse;
      }

      th, td {
        padding: 0.6em 0.8em;
        border: 1px solid var(--border-color);
        text-align: left;
      }

      img {
        max-width: 100%;
        height: auto;
      }

      hr {
        border: 0;
        border-top: 1px solid var(--border-color);
      }

      .mermaid {
        display: flex;
        justify-content: center;
        margin: 1.25em 0;
        overflow-x: auto;
      }
    </style>
  </head>
  <body>
    <main>
      <article id="preview"></article>
    </main>
    <script src="https://cdn.jsdelivr.net/npm/marked/marked.min.js"></script>
    <script type="module">
      import mermaid from 'https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.esm.min.mjs';

      const decodeBase64 = (value) => {
        const bytes = Uint8Array.from(atob(value), (character) => character.charCodeAt(0));
        return new TextDecoder().decode(bytes);
      };

      const preview = document.getElementById('preview');
      const markdown = decodeBase64('__MARKDOWN_PREVIEW_MARKDOWN_B64__');

      marked.setOptions({
        gfm: true,
        breaks: true,
      });

      preview.innerHTML = marked.parse(markdown);

      for (const codeBlock of preview.querySelectorAll('pre code.language-mermaid')) {
        const pre = codeBlock.parentElement;
        const container = document.createElement('div');
        container.className = 'mermaid';
        container.textContent = codeBlock.textContent;
        pre.replaceWith(container);
      }

      mermaid.initialize({
        startOnLoad: false,
        theme: window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'default',
      });

      await mermaid.run({
        nodes: preview.querySelectorAll('.mermaid'),
      });
    </script>
  </body>
</html>
]]

function M.preview()
  local bufnr = vim.api.nvim_get_current_buf()
  local markdown = table.concat(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false), '\n')

  if markdown == '' then
    notify('Current buffer is empty.', vim.log.levels.WARN)
    return
  end

  local html = replace_token(template, placeholder.title, html_escape(get_title(bufnr)))
  html = replace_token(html, placeholder.base_href, html_escape(get_base_href(bufnr)))
  html = replace_token(html, placeholder.markdown_b64, base64_encode(markdown))

  local output_path = get_output_path(bufnr)
  local file = io.open(output_path, 'w')
  if not file then
    notify(('Failed to write preview file: %s'):format(output_path), vim.log.levels.ERROR)
    return
  end

  file:write(html)
  file:close()

  local ok, launcher = open_in_browser(output_path)
  if not ok then
    notify('Failed to open preview in the browser.', vim.log.levels.ERROR)
    return
  end

  notify(('Opened browser preview via %s: %s'):format(launcher, output_path))
end

return M
