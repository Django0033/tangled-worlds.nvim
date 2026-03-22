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

local function is_markdown_buffer()
    return vim.bo.filetype == 'markdown' or vim.fn.expand('%:e') == 'md'
end

local function insert_at_cursor(category, subcategory, content, original_win)
    if not vim.api.nvim_win_is_valid(original_win) then
        return
    end

    local text = '(' .. category .. ' -> ' .. subcategory .. ') ' .. content
    vim.api.nvim_set_current_win(original_win)

    local mode = vim.fn.mode()
    local start_row, start_col, end_row, end_col

    if mode:find('v') or mode:find('V') or mode == 'nt' then
        local s = vim.fn.getpos("'<")
        local e = vim.fn.getpos("'>")
        start_row = s[2] - 1
        start_col = s[3] - 1
        end_row = e[2] - 1
        end_col = e[3]
    else
        local cursor = vim.api.nvim_win_get_cursor(original_win)
        start_row = cursor[1] - 1
        start_col = cursor[2]
        end_row = start_row
        end_col = start_col
    end

    local lines = vim.api.nvim_buf_get_lines(0, start_row, end_row + 1, false)
    local line = lines[1]

    local before = string.sub(line, 1, start_col)
    local after = string.sub(line, end_col + 1)

    vim.api.nvim_buf_set_lines(0, start_row, end_row + 1, false, { before .. text .. after })
    vim.api.nvim_win_set_cursor(original_win, { start_row + 1, start_col + #text })
end

local function show_floating_window(category, subcategory, content, is_md)
    local original_win = vim.api.nvim_get_current_win()
    local hint = is_md
        and 'Press <CR> to insert | q to cancel'
        or 'Press q to close'

    local lines = {
        category .. ' -> ' .. subcategory,
        content,
        '',
        hint,
    }

    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.api.nvim_buf_set_keymap(buf, 'n', 'q', '<cmd>bd!<cr>', { noremap = true })

    if is_md then
        vim.keymap.set('n', '<CR>', function()
            if vim.api.nvim_win_is_valid(win_id) then
                vim.api.nvim_win_close(win_id, true)
            end
            vim.api.nvim_buf_delete(buf, { force = true })
            insert_at_cursor(category, subcategory, content, original_win)
        end, { buffer = buf, noremap = true, silent = true })
    end

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

    local md = is_markdown_buffer()
    show_floating_window(category_name, subcategory_name, content, md)
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
