math.randomseed(os.time() + vim.fn.getpid())

vim.api.nvim_create_user_command(
    'TangledWorlds',
    require('tangled-worlds').print_random_elements,
    {
        nargs = '*',
        complete = require('tangled-worlds').dinamic_completer
    }
)
