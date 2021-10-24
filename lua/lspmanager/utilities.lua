local utilities = {}

function utilities.available_for_filetype(on_buf)
	local available = lspmanager.available_servers()
	local available_for_filetype = {}
	for _, lsp_name in pairs(utilities.servers_list) do
		local server = require("lspmanager.servers."..lsp_name)
		if vim.tbl_contains(available, lsp_name) then
			local current = vim.bo[on_buf or 0].ft
			if vim.tbl_contains(server.config.default_config.filetypes, current) then
				table.insert(available_for_filetype, lsp_name)
			end
		end
	end
	return available_for_filetype
end

function utilities.get_config(name)
    -- needed so we can restore the initial state at the end
    local was_config_set = require("lspconfig/configs")[name]
    local was_package_loaded = package.loaded["lspconfig/" .. name]

    -- gets or requires config
    local config = require("lspconfig")[name].document_config

    -- restore the initial state
    if not was_config_set then
        require("lspconfig/configs")[name] = nil
    end
    if not was_package_loaded then
        package.loaded["lspconfig/" .. name] = nil
    end

    return vim.deepcopy(config)
end

function utilities.get_path(lsp)
    if utilities.is_vscode_lsp(lsp) then
        return vim.fn.stdpath("data") .. "/lspmanager/vscode_lsps"
    else
        return vim.fn.stdpath("data") .. "/lspmanager/" .. lsp
    end
end

function utilities.is_vscode_lsp(lsp)
    local vscode_lsps = { "cssls", "html", "jsonls" }

    for _, value in ipairs(vscode_lsps) do
        if lsp == value then
            return true
        end
    end
    return false
end

utilities.servers_list = {
    "angularls",
    "bashls",
    "clangd",
    "clojure_lsp",
    "cmake",
    "cssls",
    "dockerls",
    "elixirls",
    "emmet_ls",
    "fsautocomplete",
    "hls",
    "html",
    "jsonls",
    "kotlinls",
    "omnisharp",
    "purescriptls",
    "pyright",
    "rust_analyzer",
    "solang",
    "sumneko_lua",
    "svelte",
    "tailwindcss",
    "terraformls",
    "texlab",
    "tsserver",
    "vimls",
    "volar",
    "vuels",
}

return utilities
