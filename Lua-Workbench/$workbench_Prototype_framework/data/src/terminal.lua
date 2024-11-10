
local terminal = {
    input = "",
    output = "",
    active = false,
    commandHistory = {},
    aliases = {}
}

terminal.commandList = {       
    "start.cell1",
    "stop.cell1",
    "start.cell2",
    "stop.cell2"
}

function terminal.addAlias(aliasName, command)
    terminal.aliases[aliasName] = command
    terminal.output = "Alias '"..aliasName.."' added for command: "..command
end

function terminal.listAliases()
    terminal.output = "Aliases Stored:\n"
    for aliasName, command in pairs(terminal.aliases) do
        terminal.output = terminal.output..aliasName.."->"..command.."\n"
    end
end

function terminal.processSingleCommand(command, fuelCells)
    local trimmedInput = command:match("^%s*(.-)%s*$")

    if terminal.aliases[command] then
        command = terminal.aliases[command]
    end

    if command == "start.cell1" then
        fuelCells.fuelCell1.running = true
        terminal.output = "Fuel Cell A Online."
    elseif command == "stop.cell1" then
        fuelCells.fuelCell1.running = false
        terminal.output = "Fuel Cell A Offline."
    elseif command == "start.cell2" then
        fuelCells.fuelCell2.running = true
        terminal.output = "Fuel Cell B Online."
    elseif command == "stop.cell2" then
        fuelCells.fuelCell2.running = false
        terminal.output = "Fuel Cell B Offline."
    else
        terminal.output = "Unknown command: " .. trimmedInput
    end
end

function terminal.processCommand(command, fuelCells)
    local commands = {}
    for command in string.gmatch(command, "([^;]+)") do
        table.insert(commands, command:match("^%s*(.-)%s*$"))
    end

    for _, command in ipairs(commands) do
        terminal.processSingleCommand(command, fuelCells)
        table.insert(terminal.commandHistory, command)
        if #terminal.commandHistory > 9 then
            table.remove(terminal.commandHistory, 1)
        end
    end

    if string.sub(command, 1, 6) == "alias " then
        local aliasName, fullCommand = string.match(command, "^alias (%S+) (.+)$")
        if aliasName and fullCommand then
            terminal.addAlias(aliasName, fullCommand)
        elseif command == "alias list" then
            terminal.listAliases()
        else
            terminal.output = "Usage: alias <alias_name> <command>, alias list"
        end
        return
    end
end

return terminal
