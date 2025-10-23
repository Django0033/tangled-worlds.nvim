require('tangled-worlds.tables.world-name')
require('tangled-worlds.tables.people-name')
require('tangled-worlds.tables.world-aspects')
require('tangled-worlds.tables.world-inhabitants')

M = {}

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
    local primary_tbl = _G[opts.fargs[1]]

    if #primary_tbl == 2 then
        local secondary_tbl1 = primary_tbl[1]
        local secondary_tbl2 = primary_tbl[2]

        print(get_random_element(secondary_tbl1) .. '-' .. get_random_element(secondary_tbl2))

    elseif #primary_tbl == 3 then
        local secondary_tbl1 = primary_tbl[1]
        local secondary_tbl2 = primary_tbl[2]
        local secondary_tbl3 = primary_tbl[3]

        print(get_random_element(secondary_tbl1) .. '-' .. get_random_element(secondary_tbl2) .. '-' .. get_random_element(secondary_tbl3))

    else
        print(get_random_element(primary_tbl))

    end
end

return M
