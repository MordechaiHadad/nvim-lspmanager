-- Opens a file in append mode
file = io.open("test.sh", "a")

-- sets the default output file as test.lua
io.output(file)

-- appends a word test to the last line of the file
io.write(require("lspmanager.installers.pip").update_script({"cmake-language-server"}))

-- closes the open file
io.close(file)
