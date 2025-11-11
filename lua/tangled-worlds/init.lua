M = {}

Tangled_tbls = {}

Tangled_tbls.Creation = require("tangled-worlds.tables.creation")
Tangled_tbls.Exploration = require("tangled-worlds.tables.exploration")
Tangled_tbls.World = require("tangled-worlds.tables.world")
Tangled_tbls.People = require("tangled-worlds.tables.people")
Tangled_tbls.Scene = require("tangled-worlds.tables.scene")
Tangled_tbls.Quest = require("tangled-worlds.tables.quest")
Tangled_tbls.Location = require("tangled-worlds.tables.location")

local function get_random_number(top_number)
    local random_number = math.random(1, top_number)

    return random_number
end

local function get_random_element(tbl)
    local size = #tbl

    if size == 0 then
        return nil
    end

    local random_index = get_random_number(size)

    return tbl[random_index]
end

function M.print_random_elements(opts)
    local primary_tbl = Tangled_tbls[opts.fargs[1]]
    local secondary_tbl = primary_tbl[opts.fargs[2]]

    if #secondary_tbl == 2 then
        local tertiary_tbl1 = secondary_tbl[1]
        local tertiary_tbl2 = secondary_tbl[2]

        print(get_random_element(tertiary_tbl1) .. "-" .. get_random_element(tertiary_tbl2))
    elseif #secondary_tbl == 3 then
        local tertiary_tbl1 = secondary_tbl[1]
        local tertiary_tbl2 = secondary_tbl[2]
        local tertiary_tbl3 = secondary_tbl[3]

        print(
            get_random_element(tertiary_tbl1)
            .. "-"
            .. get_random_element(tertiary_tbl2)
            .. "-"
            .. get_random_element(tertiary_tbl3)
        )
    else
        print(get_random_element(secondary_tbl))
    end
end

function M.dinamic_completer(_, cmd_line, _)
    local args = vim.fn.split(cmd_line, " ")

    if #args < 2 then
        local keys = {}

        for key, _ in pairs(Tangled_tbls) do
            table.insert(keys, key)
        end

        return keys
    elseif #args < 3 then
        local main_table_name = args[2]
        local sub_table = Tangled_tbls[main_table_name]

        if sub_table and type(sub_table) == "table" then
            local keys = {}

            for k, _ in pairs(sub_table) do
                table.insert(keys, k)
            end

            return keys
        end
    end
    return {}
end

return M
