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
            require("mason-lspconfig").setup({
                ensure_installed = {"lua_ls","phpactor","html","ts_ls","css_variables","harper_ls"}
            })

        end
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require("lspconfig")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            lspconfig.lua_ls.setup({cabilities = capabilities})
            lspconfig.phpactor.setup({cabilities = capabilities})
            lspconfig.html.setup({cabilities = capabilities})
            lspconfig.ts_ls.setup({cabilities = capabilities})
            lspconfig.css_variables.setup({cabilities = capabilities})
            lspconfig.harper_ls.setup({cabilities = capabilities})
            lspconfig.cssls.setup({cabilities = capabilities})
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
