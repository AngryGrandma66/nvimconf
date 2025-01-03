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
        end)
        vim.keymap.set('n', '<leader>fg', function()
            builtin.grep_string({search = vim.fn.input("Grep > ")})
        end)
    end
}

