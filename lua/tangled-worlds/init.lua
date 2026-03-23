M = {}

local predefined = {
    scene = {
        { label = 'Challenge', cat = 'Scene', sub = 'Challenge' },
        { label = 'Senses', cat = 'Scene', sub = 'Senses' },
    },
}

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

    local cursor = vim.api.nvim_win_get_cursor(original_win)
    local row = cursor[1] - 1
    local col = cursor[2]

    local line = vim.api.nvim_get_current_line()
    local before = string.sub(line, 1, col)
    local after = string.sub(line, col + 1)

    vim.api.nvim_buf_set_lines(0, row, row + 1, false, { before .. text })

    local line_count = vim.api.nvim_buf_line_count(0)
    local new_row = row + 2

    if #after > 0 then
        if new_row > line_count then
            vim.api.nvim_buf_set_lines(0, -1, -1, false, { after })
        else
            vim.api.nvim_buf_set_lines(0, row + 1, row + 1, false, { after })
        end
    end

    if new_row > line_count then
        vim.api.nvim_buf_set_lines(0, -1, -1, false, { '' })
        new_row = line_count + 1
    end

    vim.api.nvim_win_set_cursor(original_win, { new_row, 0 })
end

local function yank_results(results, category, subcategory)
    local text
    if type(results) == 'table' then
        local lines = {}
        for i = 1, #results do
            lines[i] = '(' .. category .. ' -> ' .. subcategory .. ') ' .. results[i]
        end
        text = table.concat(lines, '\n')
    else
        text = '(' .. category .. ' -> ' .. subcategory .. ') ' .. results
    end
    vim.fn.setreg('+', text)
end

local function show_floating_window(category, subcategory, results, is_md)
    local count = type(results) == 'table' and #results or 1
    local title = count > 1
        and category .. ' -> ' .. subcategory .. ' (' .. count .. ' results)'
        or category .. ' -> ' .. subcategory
    local hint = is_md and 'Press <CR> to insert | y to copy | q to cancel' or 'Press q to close'

    local lines = { title }
    if type(results) == 'table' then
        for i = 1, math.min(count, 10) do
            lines[#lines + 1] = results[i]
        end
    else
        lines[#lines + 1] = results
    end
    lines[#lines + 1] = ''
    lines[#lines + 1] = hint

    local width = #title + 4
    for i = 2, #lines do
        width = math.max(width, #lines[i] + 4)
    end
    local height = math.min(#lines + 1, 15)

    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.api.nvim_buf_set_keymap(buf, 'n', 'q', '<cmd>bd!<cr>', { noremap = true })

    local original_win = vim.api.nvim_get_current_win()

    if is_md then
        vim.keymap.set('n', '<CR>', function()
            vim.cmd('bd!')
            if type(results) == 'table' then
                for i = 1, #results do
                    insert_at_cursor(category, subcategory, results[i], original_win)
                end
            else
                insert_at_cursor(category, subcategory, results, original_win)
            end
        end, { buffer = buf, noremap = true, silent = true })

        vim.keymap.set('n', 'y', function()
            yank_results(results, category, subcategory)
        end, { buffer = buf, noremap = true, silent = true })
    end

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
    local args = opts.fargs
    local generator_name = args[1]

    if predefined[generator_name] then
        local elements = predefined[generator_name]
        local display_lines = { generator_name }
        local insert_parts = {}

        for _, elem in ipairs(elements) do
            local tbl = Tangled_tbls[elem.cat][elem.sub]
            local first = tbl[1]
            local is_nested = first and type(first) == 'table'
            local content

            if is_nested then
                local parts = {}
                for i = 1, #tbl do
                    parts[i] = get_random_element(tbl[i])
                end
                content = table.concat(parts, '-')
            else
                content = get_random_element(tbl)
            end

            display_lines[#display_lines + 1] = elem.label .. ': ' .. content
            insert_parts[#insert_parts + 1] = elem.label .. ': ' .. content
        end

        display_lines[#display_lines + 1] = ''
        display_lines[#display_lines + 1] = 'Press <CR> to insert | y to copy | q to cancel'

        local width = #generator_name + 4
        for i = 2, #display_lines do
            width = math.max(width, #display_lines[i] + 4)
        end

        local buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, display_lines)
        vim.api.nvim_buf_set_keymap(buf, 'n', 'q', '<cmd>bd!<cr>', { noremap = true })

        local original_win = vim.api.nvim_get_current_win()
        local insert_text = table.concat(insert_parts, ' | ')

        if is_markdown_buffer() then
            vim.keymap.set('n', '<CR>', function()
                vim.cmd('bd!')
                insert_at_cursor(generator_name, 'generator', insert_text, original_win)
            end, { buffer = buf, noremap = true, silent = true })

            vim.keymap.set('n', 'y', function()
                vim.fn.setreg('+', insert_text)
            end, { buffer = buf, noremap = true, silent = true })
        end

        local opts = {
            relative = 'editor',
            width = width,
            height = #display_lines + 1,
            row = math.floor((vim.o.lines - #display_lines - 1) / 2) - 1,
            col = math.floor((vim.o.columns - width) / 2),
            style = 'minimal',
            border = 'single',
            noautocmd = true,
        }

        local win_id = vim.api.nvim_open_win(buf, true, opts)
        vim.api.nvim_set_current_win(win_id)
        return
    end

    local count = 1
    
    local last_arg = args[#args]
    if last_arg and tonumber(last_arg) then
        count = math.min(tonumber(last_arg), 10)
        args[#args] = nil
    end
    
    local category_name = args[1]
    local subcategory_name = args[2]
    local category = Tangled_tbls[category_name]
    local subcategory = category and category[subcategory_name]

    if not category or not subcategory then
        vim.notify('Invalid category or subcategory', vim.log.levels.ERROR)
        return
    end

    local first = subcategory[1]
    local is_nested = first and type(first) == 'table'

    local results = {}
    for i = 1, count do
        if is_nested then
            local parts = {}
            for j = 1, #subcategory do
                parts[j] = get_random_element(subcategory[j])
            end
            results[i] = table.concat(parts, '-')
        else
            results[i] = get_random_element(subcategory)
        end
    end

    show_floating_window(category_name, subcategory_name, results, is_markdown_buffer())
end

function M.dynamic_completer(_, cmd_line, _)
    local args = vim.fn.split(cmd_line, ' ')

    if #args < 2 then
        local keys = {}
        for key, _ in pairs(Tangled_tbls) do
            keys[#keys + 1] = key
        end
        for key, _ in pairs(predefined) do
            keys[#keys + 1] = key
        end
        return keys
    elseif #args < 3 then
        local main_table = Tangled_tbls[args[2]]
        if main_table and type(main_table) == 'table' then
            local keys = {}
            for key, _ in pairs(main_table) do
                keys[#keys + 1] = key
            end
            return keys
        end
    end
    return {}
end

return M
