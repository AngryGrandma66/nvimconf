return {
  -- 1) The main completion plugin
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      -- 2) Sources for nvim-cmp
      "hrsh7th/cmp-nvim-lsp",    -- LSP source
      "hrsh7th/cmp-buffer",      -- Buffer completions
      "hrsh7th/cmp-path",        -- Path completions
      "hrsh7th/cmp-cmdline",     -- Cmdline completions

      -- 3) Snippets
      "L3MON4D3/LuaSnip",        -- Snippet engine
      "saadparwaiz1/cmp_luasnip",-- Snippet completions
      "rafamadriz/friendly-snippets", -- Predefined snippets
    },
    config = function()
      -- Setup nvim-cmp after it’s loaded
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      -- Load VSCode-style snippets from 'friendly-snippets'
      require("luasnip.loaders.from_vscode").lazy_load()

      -- If you want to load custom snippet files, do so here:
      -- require("luasnip.loaders.from_lua").lazy_load({ paths = "~/.config/nvim/snippets" })

      ----------------------------------------------------------------------------
      -- Helper: check if there’s a word before the cursor
      ----------------------------------------------------------------------------
      local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        if col == 0 then
          return false
        end
        local current_line = vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]
        return current_line:sub(col, col):match("%s") == nil
      end

      ----------------------------------------------------------------------------
      -- Tab / Shift-Tab handling
      ----------------------------------------------------------------------------
      local t = function(str)
        return vim.api.nvim_replace_termcodes(str, true, true, true)
      end

      local tab_complete = function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end

      local s_tab_complete = function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end

      ----------------------------------------------------------------------------
      -- nvim-cmp Setup
      ----------------------------------------------------------------------------
      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = {
          ["<Tab>"] = vim.schedule_wrap(tab_complete),
          ["<S-Tab>"] = vim.schedule_wrap(s_tab_complete),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),  -- Accept currently selected item with <CR>
          ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-e>"] = cmp.mapping.close(),
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
        -- You can set formatting, sorting, etc. here if you want
      })

      ----------------------------------------------------------------------------
      -- If you want cmdline completion:
      ----------------------------------------------------------------------------
      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
      })
    end,
  },
}

