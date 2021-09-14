local lsp_name = "rust_analyzer"
local config = require("lspmanager.utilities").get_config(lsp_name)
local os = require("lspmanager.os")
local path = require("lspmanager.utilities").get_path(lsp_name)

local cmd_exec = "./rust-analyzer"

if os.get_os() == os.OSes.Windows then
    cmd_exec = cmd_exec .. ".exe"
end

config.default_config.cmd[1] = cmd_exec

local function install_script()
    if os.get_os() == os.OSes.Windows then
        return [[
        [net.servicepointmanager]::securityprotocol = [net.securityprotocoltype]::tls12

        function get_latest_version() {
            $response = invoke-restmethod -uri "https://api.github.com/repos/rust-analyzer/rust-analyzer/releases/latest"
            return $response.tag_name
        }

        $version = get_latest_version
        $url = "https://github.com/rust-analyzer/rust-analyzer/releases/download/$($version)/rust-analyzer-x86_64-pc-windows-msvc.gz"
        $out = "rust-analyzer.gz"

        if (test-path -path get-location) {
            remove-item get-location -force -recurse
        }
        invoke-webrequest -uri $url -outfile $out

        function degzip-file{
            param(
            $infile,
            $outfile = ($infile -replace '\.gz$','')
            )

            $input = new-object system.io.filestream $infile, ([io.filemode]::open), ([io.fileaccess]::read), ([io.fileshare]::read)
            $output = new-object system.io.filestream $outfile, ([io.filemode]::create), ([io.fileaccess]::write), ([io.fileshare]::none)
            $gzipstream = new-object system.io.compression.gzipstream $input, ([io.compression.compressionmode]::decompress)

            $buffer = new-object byte[](1024)
            while($true){
                $read = $gzipstream.read($buffer, 0, 1024)
                if ($read -le 0){break}
                    $output.write($buffer, 0, $read)
                }

                $gzipstream.close()
                $output.close()
                $input.close()
            }

            $path = "]] .. path .. [["]] ..
            [[

            $infile="$($path)/$($out)"
            $outfile="$($path)/rust-analyzer.exe"

            degzip-file $infile $outfile

            out-file -filepath version -encoding string -inputobject "$($version)"
            remove-item $out
            ]]
        end
        return [[
        os=$(uname -s | tr "[:upper:]" "[:lower:]")
        mchn=$(uname -m | tr "[:upper:]" "[:lower:]")
        version=$(curl -s "https://api.github.com/repos/rust-analyzer/rust-analyzer/releases/latest" | jq -r '.tag_name')

        if [ $mchn = "arm64" ]; then
            mchn="aarch64"
            fi

            case $os in
            linux)
            platform="unknown-linux-gnu"
            ;;
            darwin)
            platform="apple-darwin"
            ;;
            esac

            curl -L -o "rust-analyzer.gz" "https://github.com/rust-analyzer/rust-analyzer/releases/download/$version/rust-analyzer-$mchn-$platform.gz"
            gzip -d rust-analyzer.gz

            rm rust-analyzer.gz
            mv rust-analyzer-$mchn-$platform rust-analyzer

            chmod +x rust-analyzer
            echo $version > VERSION
            ]]
        end

        return vim.tbl_extend("error", config, {
            install_script = install_script,

            update_script = function()
                return require("lspmanager.installers.manual").update_script("rust-analyzer/rust-analyzer")
            end,
        })
