return{
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()

        end
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config =function()
            require("mason-lspconfig").setup({ensure_installed = {"lua_ls","phpactor","html","eslint","css_variables","harper_ls"}})
        end
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require("lspconfig")
            lspconfig.lua_ls.setup({})
            lspconfig.phpactor.setup({})
            lspconfig.html.setup({})
            lspconfig.eslint.setup({})
            lspconfig.css_variables.setup({})
            lspconfig.harper_ls.setup({})
            vim.keymap.set("n","<leader>cs",vim.lsp.buf.hover,{desc = "show docs"})
            vim.keymap.set("n","<leader>cg",vim.lsp.buf.definition,{desc = "go to definition"})
            vim.keymap.set("n","<leader>cG",vim.lsp.buf.declaration,{desc = "go to declaration"})
            vim.keymap.set({"n","v"},"<leader>ca",vim.lsp.buf.code_action,{desc = "show actions"})
            vim.keymap.set("n","<leader>cr",require("telescope.builtin").lsp_references,{desc = "references"})
            vim.keymap.set("n","<leader>ci",require("telescope.builtin").lsp_implementations,{desc = "implemetations"})
            vim.keymap.set("n","<leader>cR",vim.lsp.buf.rename,{desc = "rename"})
        end
    },
}
