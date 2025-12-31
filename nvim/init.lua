require("basic")
require("keybinds")
require("iface")


-- tab completion minimal
-- Based on https://vonheikemen.github.io/devlog/tools/neovim-lsp-client-guide/
local function tab_complete()
    if vim.fn.pumvisible() == 1 then -- if completion menu is open, scroll
        return '<Down>'
    end

    -- check if \t is needed instead of autocompletion
    local c = vim.fn.col('.') - 1
    local is_whitespace = c == 0 or vim.fn.getline('.'):sub(c, c):match('%s')

    if is_whitespace then
        return '<Tab>'
    end

    -- check if lsp autocomplete works, else use nvim's default
    local lsp_completion = vim.bo.omnifunc == 'v:lua.vim.lsp.omnifunc'

    if lsp_completion then
        return '<C-x><C-o>'
    end

    return '<C-x><C-n>'
end

local function tab_scroll_up()
    if vim.fn.pumvisible() == 1 then
        return '<Up>'
    end

    return '<Tab>'
end
-- End tab completion config
--
-- Inlay hints
vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'Enable inlay hints',
    callback = function(event)
        local id = vim.tbl_get(event, 'data', 'client_id')
        local client = id and vim.lsp.get_client_by_id(id)
        if client == nil or not client:supports_method('textDocument/inlayHint') then
            return
        end

        vim.lsp.inlay_hint.enable(true, {bufnr = event.buf})
    end,
})

-- Config for pyright
vim.lsp.config("pyright", {
    cmd = { 'pyright-langserver', '--stdio' },
    filetypes = { 'python' },
    root_markers = {
        'pyrightconfig.json',
        'pyproject.toml',
        'setup.py',
        'setup.cfg',
        'requirements.txt',
        'Pipfile',
        '.git',
    },
    settings = {
        python = {
            analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = 'openFilesOnly',
            },
        },
    },
})
vim.lsp.enable("pyright")

-- Tab completion keybind
vim.keymap.set("i", "<Tab>", tab_complete, {expr = true})
vim.keymap.set("i", "<S-Tab>", tab_scroll_up, {expr = true})

