return {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
    -- or                              , branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>ff', function()
            local is_git = os.execute('git') == 0
            if is_git then
                builtin.git_files()
            else
                builtin.find_files()
            end
        end,{desc="fuzzy find files"})
        vim.api.nvim_set_keymap(
        'n', -- mode: normal
        '<leader>fg', -- key sequence
        '<cmd>Telescope live_grep<CR>', -- command to run
        { noremap = true, silent = true, desc="search all files"} -- options: non-recursive, silent
        )
    end
}

