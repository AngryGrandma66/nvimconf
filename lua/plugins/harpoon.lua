return {
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    opts = {
      menu = {
        width = vim.api.nvim_win_get_width(0) - 4,
      },
      settings = {
        save_on_toggle = true,
      },
    },
    keys = function()
      local keys = {
        {
          "<leader>a",
          function()
            require("harpoon"):list():add()
          end,
          desc = "Harpoon File",
        },
        {
          "<leader>h",
          function()
            local harpoon = require("harpoon")
            harpoon.ui:toggle_quick_menu(harpoon:list())
          end,
          desc = "Harpoon Quick Menu",
        },
      }
      for i = 1, 5 do
        table.insert(keys, {
          "<leader>" .. i,
          function()
            require("harpoon"):list():select(i)
          end,
          desc = "Harpoon to File " .. i,
        })
      end
      return keys
    end,
    config = function(_, opts)
      require("harpoon").setup(opts)
      local M = {}
      local function is_current_mark(file)
        local bufname = vim.fn.expand("%:p")
        return bufname == vim.fn.expand(file)
      end
      function M.get_tabline()
        local list = require("harpoon"):list()
        local marks = list.items or {}
        local s = ""
        for i, mark in ipairs(marks) do
          s = s .. "%" .. i .. "T"
          if type(mark) == "table" and mark.value then
            local filename = mark.value
            if is_current_mark(filename) then
              s = s .. " " .. i .. ": " .. vim.fn.fnamemodify(filename, ":t") .. " "
            else
              s = s .. " " .. i .. ": " .. vim.fn.fnamemodify(filename, ":t") .. " "
            end
          else
            s = s .. " " .. i .. ": ? "
          end
        end
        s = s .. "%T"
        return s
      end
      package.loaded["harpoon_tabline"] = M

      vim.o.tabline = "%!v:lua.require'harpoon_tabline'.get_tabline()"
    end,
  },
}

