return {
    "folke/which-key.nvim",
    config = function()
        require("which-key").setup({
            winow= {
                border = "single",
                position = "bottom"
            },
            triggers = { "<leader>f", "<leader>c" },
        })

        vim.api.nvim_set_keymap(
        'n',
        '<leader>?',
        ':WhichKey<CR>',
        { noremap = true, silent = true , desc="which key"}
        )
    end,
}

