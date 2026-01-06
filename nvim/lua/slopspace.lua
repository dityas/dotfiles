local fim_prefix = "<|fim_prefix|>"
local fim_suffix = "<|fim_suffix|>"
local fim_middle = "<|fim_middle|>"



-- Use curl to make a request to a local ollama model
-- First check if curl is installed on the system
local function check_curl()
    local result = vim.fn.system("curl --help")
    if vim.v.shell_error == 0 then
        return true
    else
        return false
    end
end

local function check_ollama_alive()
    local result = vim.fn.system("curl -s http://localhost:11434/api/version")
    if vim.v.shell_error == 0 then
        local status, version_table = pcall(vim.json.decode, result)

        if not status then
            vim.api.nvim_put({"[!] Error: Ollama is not responding"}, "", true, true)
            return false
        end

        return true
    else
        return false
    end
end

-- For now, instead of being adventerous, I'll just open a new buffer for
-- the LLM interaction. Hopefully copying back and forth will be easy.
local function open_workspace()
    vim.cmd("vnew")
    local buf = vim.api.nvim_get_current_buf()
    vim.bo[buf].buftype = 'nofile'
    vim.bo[buf].bufhidden = 'wipe'
    vim.bo[buf].swapfile = false

    if not check_curl() then
        vim.api.nvim_put({"[!] Error: curl not installed"}, "", true, true)
    end

    if not check_ollama_alive() then
        vim.api.nvim_put({"[!] Error: Ollama is not responding"}, "", true, true)
    end
end

local function get_prompt()
    prefix = table.concat(prompt_prefix, "\r\n")
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    --local prompt = prefix .. "\r\n" .. table.concat(lines, "\r\n")
    local prompt = table.concat(lines, "\r\n")

    return prompt
end

-- There has to be a better way than hard-coding the model name
local function build_request()
    local request = {
        model = "codegemma:2b",
        messages = {
            {
                role = "user",
                content = get_prompt()
            }
        },
        stream = true
    }

    return request
end

-- Response capture
local LLMResponse = {}

local function handle_stdout(err, output)

    if output == nil or output == "" then
        return
    end

    if err ~= nil and err ~= "" then
        print("Got error " .. err)
    end

    for c in string.gmatch(output, "[^\r\n]+") do
        local status, parsed = pcall(vim.json.decode, c)

        if status and parsed.message ~= nil then
            table.insert(LLMResponse, parsed.message.content)
        end
    end
end

local function send_prompt(prompt)
    local curl_req = {"curl", "-s", "http://localhost:11434/api/chat", "-d", prompt}
--    local curl_req = {"ping", "-c", "4", "google.com"}

    -- Begin writing response
    vim.cmd("normal! o")
    vim.api.nvim_put({"[Response]"}, "", true, true)
    vim.cmd("normal! o")
    local result = vim.system(curl_req,
    {text = true, stdout = vim.schedule_wrap(handle_stdout)},
    vim.schedule_wrap(function(code)
        local response = table.concat(LLMResponse)
        local lines = {}
        for line in string.gmatch(response, "[^\r\n]+") do
            table.insert(lines, line)
        end
        vim.api.nvim_put(lines, "", true, true)
        LLMResponse = {}
    end))
end

local function get_tree()

    local parser = vim.treesitter.get_parser()
    if parser then
        local tree = parser:parse()[1]
        return tree
    else
        print("[X] Error: Could not get treesitter parser")
        return
    end

end

local function make_fim_prompt(node)
    local start_row, start_col, end_row, end_col = node:range()

    -- Get cursor pos
    local buffer = vim.api.nvim_get_current_buf()
    local c_row, c_col = unpack(vim.api.nvim_win_get_cursor(0))
    c_row = c_row - 1 -- 0 indexing for API compat

    if c_row < start_row or (c_row == start_row and c_col < start_col) then
        print("[X] Error: Cursor is before root???")
        return
    end

    -- get lines from node
    local lines = vim.api.nvim_buf_get_lines(buffer, start_row, end_row + 1, false)

    if #lines < 1 then
        print("[X] Error (make_fin_prompt): No lines fetched from buffer")
        return
    end

    lines[1] = fim_prefix .. lines[1] -- Add prefix token
    lines[#lines] = lines[#lines] .. fim_middle  -- Add middle token
    print(table.concat(lines, "\r\n"))

end

local function get_full_prefix(tree)
    local root = tree:root()
    print(root)
end

-- Get fim for the entire file from the current cursor position
local function fim_file()
    local tree = get_tree()
    -- Do we want to include the full file in the prompt or just the function?
    if tree then
        local root = tree:root()
        if root then
            return make_fim_prompt(root)
        else
            print("[X] Error: Could not get root node")
        end
    else
        print("[X] Error: Could not get treesitter tree")
        return
    end
end

local function get_llm_slop()
    get_prefix()
--    local request = vim.json.encode(build_request())
--    vim.cmd("normal! o")
--    send_prompt(request)
end

-- Slop workspace keybind
vim.keymap.set("n", "<C-s>i", open_workspace, {desc = "Open temp buffer"})
vim.keymap.set("n", "<C-s>a", fim_file, {desc = "Send prompt to LLM"})
