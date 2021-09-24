local function test()
    vim.fn.jobstart(
        {
            "bash",
            "-c",
            [[

    if ! command -v jq &> /dev/null
        then
            echo "<the_command> could not be found"
            exit 69
            fi

            version=$(curl -s "https://api.github.com/repos/clangd/clangd/releases/latest" | jq -r '.tag_name')
            echo $version >> VERSION
            ]],
        },
        {
            cwd = path,
            on_exit = function(_, exitcode)
                print(exitcode)
            end,
        }
    )
end

print("starting")
test()
