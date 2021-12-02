local Info = {}
local ns = vim.api.nvim_create_namespace("lspmanager_info")
local config_file = require("lspmanager.info.config")
local lspmanager = require("lspmanager")
local config = config_file.options

local function create_info_window()
    package.loaded["lspmanager.info"] = nil
    local opts = { noremap = true, silent = true }

    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_keymap(buf, "n", "q", ":q<CR>", opts)
    vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", ":q<CR>", opts)
    vim.api.nvim_buf_set_option(buf, "filetype", "lspinfo")
    vim.api.nvim_buf_set_option(buf, "tabstop", config.tabspace)

    local height, width = vim.o.lines, vim.o.columns
    local h = math.ceil(height * 0.8 - 2)
    local w = math.ceil(width * 0.7)
    local row = math.ceil((height - h) / 2 - 1)
    local col = math.ceil((width - w) / 2)
    local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        border = config.border,
        style = "minimal",
        row = row,
        col = col,
        width = w,
        height = h,
    })

    return buf, win
end

local function set_level(tbl, i)
    -- local levels = { " ", " ", " " }
    local padded_table = {}
    for _, item in ipairs(tbl) do
        table.insert(padded_table, (("\t"):rep(i)) .. (config.levels[i] or " ") .. item)
    end

    return padded_table
end

local count = 1
local function set_lines(buf, text, hi)
    vim.api.nvim_buf_set_lines(buf, count, count + #text - 1, false, text)
    for i = count, count + #text do
        vim.api.nvim_buf_add_highlight(buf, ns, hi, i, 0, -1)
    end
    count = count + #text
end

local function empty()
    set_lines(0, { "" }, "None")
end

local function center(tbl)
    local w = (vim.api.nvim_win_get_width(0) - #config.header[1]) / 2 - 1
    local pad = (" "):rep(math.floor(w))

    local new_tbl = {}
    for _, item in ipairs(tbl) do
        table.insert(new_tbl, pad .. item)
    end

    return new_tbl
end

local function get_active_clients()
    local clients_table = {}
    local available_servers = lspmanager.suggested_servers(Info.on_buf)

    local config_list = {}
    for _, config_name in ipairs(available_servers) do
        local server_config = require("lspconfig/configs")[config_name]
        table.insert(config_list, server_config)
    end

    for _, item in ipairs(config_list) do
        local client = item.name
        local default_conf = item.document_config.default_config

        clients_table[client] = {}
        clients_table[client]["Autostart"] = item["autostart"]
        clients_table[client]["Full Command"] = vim.fn.join(item["cmd"], " ")
        clients_table[client]["Root Directory"] = item.get_root_dir(vim.api.nvim_buf_get_name(Info.on_buf))
        clients_table[client]["cmd"] = default_conf["cmd_cwd"]
        clients_table[client]["Has executable"] = vim.fn.executable(item["cmd"][1]) == 1

        -- clients_table[client]["Initialized"] = config["initialized"]
        -- clients_table[client]["id"] = config["id"]
    end

    return clients_table
end

local function local_pad(str, i)
    return (" "):rep(i) .. str
end

local do_client_stuff = function(buf)
    local total_clients = get_active_clients()
    if vim.tbl_isempty(total_clients) then
        set_lines(buf, set_level({ "No Clients Attatched! :(" }, 2), "String")
        return
    end
    for client_name, client_props in pairs(total_clients) do
        if not client_props["Has executable"] then
            client_name = "(❗) " .. client_name
            vim.fn.matchadd("Error", "Has executable  : \\zsfalse\\ze")
        end
        set_lines(buf, set_level({ client_name }, 2), "String")
        for prop_name, prop_value in pairs(client_props) do
            set_lines(
                buf,
                set_level({
                    prop_name .. local_pad(" : ", 15 - prop_name:len()) .. ("%s"):format(prop_value),
                }, 3),
                "TSVariable"
            )
        end
    end
end

function Info.display()
    Info.on_buf = vim.api.nvim_get_current_buf()
    local buf, _ = create_info_window()

    set_lines(buf, center(config.header), "TSConstructor")
    empty()

    set_lines(buf, set_level({ "Servers for current buffer:" }, 1), "Function")
    do_client_stuff(buf)
    empty()

    local installed = require("lspmanager").installed_servers()
    local installed_count = vim.tbl_count(installed)
    set_lines(buf, set_level({ "Installed servers (" .. installed_count .. "): " }, 1), "Function")
    set_lines(buf, set_level({ vim.fn.join(installed, ", ") }, 2), "String")
    empty()

    local available_servers = lspmanager.suggested_servers(Info.on_buf)
    local suggestions = {}
    for _, lsp_name in pairs(available_servers) do
        if require("lspmanager").is_lsp_installed(lsp_name) == 0 then
            table.insert(suggestions, lsp_name)
        end
    end

    if #suggestions > 0 then
        local suggestions_count = vim.tbl_count(suggestions)
        set_lines(buf, set_level({ "Suggested servers (" .. suggestions_count .. "): " }, 1), "Function")
        set_lines(buf, set_level(suggestions, 2), "String")
        empty()
    end

    set_lines(buf, set_level({ "Find logs at: " .. vim.lsp.get_log_path() }, 1), "TSVariable")

    vim.api.nvim_buf_set_option(buf, "modifiable", false)
end

return Info
