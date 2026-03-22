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

local function show_floating_window(category, subcategory, content)
    local hint = 'Press q to close'
    local lines = {
        category .. ' -> ' .. subcategory,
        content,
        '',
        hint,
    }

    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.api.nvim_buf_set_keymap(buf, 'n', 'q', '<cmd>bd!<cr>', { noremap = true })
    vim.keymap.set('n', '<Esc>', '<cmd>bd!<cr>', { buffer = buf, noremap = true })

    local width = math.max(
        #category + #subcategory + 5,
        #content,
        #hint
    ) + 4
    local height = 4

    local opts = {
        relative = 'editor',
        width = width,
        height = height,
        row = math.floor((vim.o.lines - height) / 2) - 1,
        col = math.floor((vim.o.columns - width) / 2),
        style = 'minimal',
        border = 'single',
        noautocmd = true,
    }

    local win_id = vim.api.nvim_open_win(buf, true, opts)
    vim.api.nvim_set_current_win(win_id)
end

function M.print_random_elements(opts)
    local category_name = opts.fargs[1]
    local subcategory_name = opts.fargs[2]
    local category = Tangled_tbls[category_name]
    local subcategory = category and category[subcategory_name]

    if not category or not subcategory then
        vim.notify('Invalid category or subcategory', vim.log.levels.ERROR)
        return
    end

    local first = subcategory[1]
    local is_nested = first and type(first) == 'table'

    local content
    if is_nested then
        local parts = {}
        for i = 1, #subcategory do
            parts[i] = get_random_element(subcategory[i])
        end
        content = table.concat(parts, '-')
    else
        content = get_random_element(subcategory)
    end

    show_floating_window(category_name, subcategory_name, content)
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
