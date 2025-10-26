math.randomseed(os.time() + vim.fn.getpid())

local function get_tables_completion()
    return {

        'CreationPurpose',
        'ExplorationEvent',
        'ExplorationFindings',
        'ExplorationOrnament',
        'ExplorationTerrain',
        'PeopleName',
        'WorldAspects',
        'WorldInhabitants',
        'WorldName',

    }
end

vim.api.nvim_create_user_command(
    'TangledWorlds',
    require('tangled-worlds').print_random_elements,
    {
        nargs = 1,
        complete = get_tables_completion
    }
)
