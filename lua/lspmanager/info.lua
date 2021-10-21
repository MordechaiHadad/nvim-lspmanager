local Info = {}
local ns = vim.api.nvim_create_namespace("lspmanager_info")

local header = {
    [[|  _._  ._ _  _.._  _. _  _ ._]],
    [[|__>|_) | | |(_|| |(_|(_|(/_| ]],
    [[    |                  _|     ]],
}

local function create_info_window()
	package.loaded['lspmanager.info'] = nil
    local opts = { noremap = true, silent = true }

    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_keymap(buf, "n", "q", ":q<CR>", opts)
    vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", ":q<CR>", opts)
    vim.api.nvim_buf_set_option(buf, "filetype", "lspinfo")
    vim.api.nvim_buf_set_option(buf, "tabstop", 3)

    local height, width = vim.o.lines, vim.o.columns
    local h = math.ceil(height * 0.8 - 2)
    local w = math.ceil(width * 0.7)
    local row = math.ceil((height - h) / 2 - 1)
    local col = math.ceil((width - w) / 2)
    local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor", border = "rounded", style = "minimal", row = row,
        col = col, width = w, height = h,
    })

    return buf, win
end

local function set_level(tbl, i)
    -- local levels = { " ", " ", " " }
    local levels = { "◈  ", "◇ ", " " }
    local padded_table = {}
    for _, item in ipairs(tbl) do
        table.insert(padded_table, (("\t"):rep(i)) .. (levels[i] or " ") .. item)
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

local function empty() set_lines(0, { "" }, "None") end

local function center(tbl)
    local w = (vim.api.nvim_win_get_width(0) - #header[1])/2 - 1
    local pad = (" "):rep(math.floor(w))

    local new_tbl = {}
    for _, item in ipairs(tbl) do
        table.insert(new_tbl, pad .. item)
    end

    return new_tbl
end

local function get_active_clients()
    local clients_table = {}

    for _, item in ipairs(vim.lsp.get_active_clients()) do
        local client = item.name
        clients_table[client] = {}
        clients_table[client]["Autostart"] = item.config["autostart"]
        clients_table[client]["full_command"] = vim.fn.join(item.config["cmd"], " ")
        clients_table[client]["cmd"] = item.config["cmd_cwd"]
        clients_table[client]["cmd_is_exe"] = vim.fn.executable(clients_table[client]["cmd"]) == 1
        clients_table[client]["root_dir"] = item.config["root_dir"]
        clients_table[client]["id"] = item.config["id"]
        clients_table[client]["initialized"] = item.config["initialized"]
    end

    return clients_table
end

local function local_pad(str, i)
    return (" "):rep(i) .. str
end

local do_client_stuff = function(buf)
	local total_clients = get_active_clients()
	if vim.tbl_isempty(total_clients) then
		set_lines(buf, set_level({"No Clients Attatched! :("}, 2), "String")
		return
	end
    for client_name, client_props in pairs(total_clients) do
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
	local on_buf = vim.api.nvim_get_current_buf()
    local buf, _ = create_info_window()

    vim.cmd([[hi Another gui=bold guifg=#eb6c76]])
    set_lines(buf, center(header), "Another")
    empty()

    set_lines(buf, set_level({ "Active Clients on current Buffer: " }, 1), "Function")
    do_client_stuff(buf)
    empty()

    local installed = require("lspmanager").installed_servers()
    set_lines(buf, set_level({ "Installed servers: " }, 1), "Function")
    set_lines(buf, set_level({ vim.fn.join(installed, ", ") }, 2), "String")
	empty()

	local suggestions = require("lspmanager.utilities").available_for_filetype(on_buf)
	set_lines(buf, set_level({ "Suggested servers: " }, 1), "Function")
	set_lines(buf, set_level(suggestions, 2), "String")
end

return Info
