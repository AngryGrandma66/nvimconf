-- Single-file config for Neo-tree with Lazy

--------------------------------------------------------------------------------
-- We'll define a local table to hold our helper functions and plugin setup.
--------------------------------------------------------------------------------
local M = {}
--------------------------------------------------------------------------------
-- 1. Git Root Detection
--------------------------------------------------------------------------------
local function find_git_root(path)
    local cmd = string.format("git -C %q rev-parse --show-toplevel 2>/dev/null", path)
    local handle = io.popen(cmd)
    if handle then
        local result = handle:read("*all")
        handle:close()
        if result and #result > 0 then
            -- Trim trailing whitespace/newline:
            return result:gsub("%s+$", "")
        end
    end
    return nil
end

local function is_git_repo(path)
    return (find_git_root(path) ~= nil)
end

--------------------------------------------------------------------------------
-- 2. "Netrw-like" tree with full renderers (icons, git, etc.)
--------------------------------------------------------------------------------
local function open_netrw_like(dir)
    -- If in a Git repo, use the Git root
    local path = dir or vim.fn.getcwd()
    if is_git_repo(path) then
        path = find_git_root(path)
    end

    require("neo-tree.command").execute({
        position  = "current",
        dir       = path or vim.fn.getcwd(),
        reveal = true,
    })
end
-------------------
-- 4. Toggling the right-side panel
--    We'll rely on Neo-tree's "toggle = true" to open/close it automatically.
--------------------------------------------------------------------------------
local function toggle_side_condensed(dir)
    local path = dir or vim.fn.getcwd()
    if is_git_repo(path) then
        path = find_git_root(path)
    end

    -- 'toggle = true' tells Neo-tree to open if it's closed,
    -- or close it if it's open at 'position = "right"'.
    require("neo-tree.command").execute({
        position  = "left",
        toggle    = true,
        dir       = path,
        reveal    = true,
    })
end

--------------------------------------------------------------------------------
-- 5. Setup function: disable netrw, configure Neo-tree, set up autocmd & keymaps
--------------------------------------------------------------------------------
function M.setup()
    ------------------------------------------------------------------------------
    -- Configure Neo-tree globally: enable Git status, etc.
    ------------------------------------------------------------------------------
    require("neo-tree").setup({
        remove_legacy_commands = true,
        close_if_last_window = false,
        enable_git_status    = true,   -- Show Git info
        enable_diagnostics   = false,  -- Enable if you want LSP diagnostics in tree
        commands = {
            cd_or_open = function(state)
                local node = state.tree:get_node()
                if node.type == "directory" then
                    -- Navigate into the directory (change tree root)
                    require("neo-tree.sources.filesystem").navigate(state, node:get_id())
                else
                    -- If it’s a file, fallback to the normal 'open' command
                    require("neo-tree.sources.filesystem.commands").open(state)
                end
            end,
        },


        -- Just some default keymaps you can tweak. This affects the in-tree mappings.
        filesystem = {
            follow_current_file = {
                enabled = true, 
            },            
            window = {
                width = 20, -- applies to left and right positions
                auto_expand_width = true,
                mappings = {
                    ["<space>"] = "toggle_node",
                    ["<cr>"]     = "cd_or_open",
                    ["l"]        = "open",
                    ["h"]        = "close_node",
                    ["<bs>"]     = "navigate_up",
                    ["S"]        = "open_split",
                    ["s"]        = "open_vsplit",
                    ["t"]        = "open_tabnew",
                    ["z"]        = "close_all_nodes",
                    ["a"]        = "add",
                    ["A"]        = "add_directory",
                    ["d"]        = "delete",
                    ["r"]        = "rename",
                    ["y"]        = "copy_to_clipboard",
                    ["x"]        = "cut_to_clipboard",
                    ["p"]        = "paste_from_clipboard",
                    ["c"]        = "copy",
                    ["m"]        = "move",
                    ["H"]        = "toggle_hidden",
                    ["R"]        = "refresh",
                    ["?"]        = "show_help",
                }
            },
        },
    })
    ------------------------------------------------------------------------------
    -- Keybinds
    ------------------------------------------------------------------------------
    -- 1) Netrw-like in the current window (uncondensed)
    vim.keymap.set("n", "<leader>rt", function()
        local dir = vim.fn.expand("%:p:h")
        open_netrw_like(dir)
    end, { desc = "Neo-tree in current window (netrw-like)" })

    vim.keymap.set("n", "<leader>po", function()
        local dir = vim.fn.expand("%:p:h")
        toggle_side_condensed(dir)
    end, { desc = "Toggle condensed Neo-tree on the right" })
end

--------------------------------------------------------------------------------
-- 6. Return a table for Lazy: a single plugin spec with our config
--------------------------------------------------------------------------------
return {
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "main", 
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- recommended for icons
            "MunifTanjim/nui.nvim",
        },
        config = function()
            M.setup()
        end,
    },
}

