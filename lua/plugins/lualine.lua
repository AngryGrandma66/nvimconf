return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("lualine").setup({
      options = {
        -- You can set a theme such as "gruvbox", "onedark", "tokyonight", etc.
        -- "auto" tries to pick from your current colorscheme if possible.
        theme = "auto",

        -- If you want separators between sections/components:
        section_separators = { left = "", right = "" },
        component_separators = { left = "", right = "" },

        -- Enable icons (requires "nvim-tree/nvim-web-devicons")
        icons_enabled = true,
      },
      sections = {
        -- These are the sections in the status line from left -> right.
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { "filename" },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      -- Feel free to customize any other sections (lualine_x, lualine_y, etc.)
    })
  end,
}

