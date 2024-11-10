-- src/terminal.lua

local terminal = {
    input = "",                                             -- Current command input by the user
    output = "",                                            -- Current output displayed to the user
    active = false,                                         -- Determines if the terminal is active or not
    commandHistory = {},                                    -- Stores previous commands entered by the user (up to 9)
    aliases = {},                                           -- Command aliases (e.g., shortcuts for longer commands)
    textColor = {                                           -- Predefined colors for terminal text, using Monokai theme
        lightMonokai = { 117/255, 113/255, 94/255 },
        darkMonokai = { 39/255, 40/255, 32/255 },
        screenBlue = { 125/255, 158/255, 164/255 },
    },
    terminalWidth = 374,
    terminalHeight = 246,
    inputScrollOffset = 0,
    outputScrollOffset = 0,
    historyScrollOffsets = {}
}

-- Adds a new alias to the terminal, mapping an aliasName to an actual command
function terminal.addAlias(aliasName, command)
    terminal.aliases[aliasName] = command
    terminal.output = "Alias '" .. aliasName .. "' added for command: " .. command
end

-- Lists all stored aliases
function terminal.listAliases()
    terminal.output = "Aliases Stored:\n"
    for aliasName, command in pairs(terminal.aliases) do
        terminal.output = terminal.output .. aliasName .. " -> " .. command .. "\n"
    end
end

function terminal.processSingleCommand(command)
    print("Processing Command: " .. command)  -- Debug output for testing purposes
    
end