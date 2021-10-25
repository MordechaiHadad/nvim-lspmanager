-- Opens a file in append mode
return {
    output = function(args)
        local file = io.open("output", "a")

        -- sets the default output file as test.lua
        io.output(file)

        -- appends a word test to the last line of the file
        io.write(vim.inspect(args))

        -- closes the open file
        io.close(file)

    end
}
