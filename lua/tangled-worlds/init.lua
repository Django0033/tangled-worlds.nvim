M = {}

Tangled_tbls = {}

Tangled_tbls.Creation = require('tangled-worlds.tables.creation')
Tangled_tbls.Exploration = require('tangled-worlds.tables.exploration')
Tangled_tbls.World = require('tangled-worlds.tables.world')
Tangled_tbls.People = require('tangled-worlds.tables.people')
Tangled_tbls.Scene = require('tangled-worlds.tables.scene')
Tangled_tbls.Quest = require('tangled-worlds.tables.quest')
Tangled_tbls.Location = require('tangled-worlds.tables.location')

local function get_random_element(tbl)
    return tbl[math.random(#tbl)]
end

function M.print_random_elements(opts)
    local category = Tangled_tbls[opts.fargs[1]]
    local subcategory = category and category[opts.fargs[2]]

    if not category or not subcategory then
        vim.notify('Invalid category or subcategory', vim.log.levels.ERROR)
        return
    end

    local first = subcategory[1]
    local is_nested = first and type(first) == 'table'

    if is_nested then
        local parts = {}
        for i = 1, #subcategory do
            parts[i] = get_random_element(subcategory[i])
        end
        print(table.concat(parts, '-'))
    else
        print(get_random_element(subcategory))
    end
end

function M.dynamic_completer(_, cmd_line, _)
    local args = vim.fn.split(cmd_line, ' ')

    if #args < 2 then
        local keys = {}
        for key, _ in pairs(Tangled_tbls) do
            table.insert(keys, key)
        end
        return keys
    elseif #args < 3 then
        local main_table = Tangled_tbls[args[2]]

        if main_table and type(main_table) == 'table' then
            local keys = {}
            for key, _ in pairs(main_table) do
                table.insert(keys, key)
            end
            return keys
        end
    end
    return {}
end

return M
