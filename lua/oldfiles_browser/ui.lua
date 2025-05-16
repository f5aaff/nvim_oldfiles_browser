local M = {}

local selected_item = 1
local buf, win_id

local input_buf, input_win_id, result_buf, result_win_id
local selected_index = 1 -- Keeps track of the currently selected item

local results_win_config = {}

-- Helper to get only existing oldfiles
local function get_existing_oldfiles()
    local files = {}
    for _, file in ipairs(vim.v.oldfiles) do
        if vim.fn.filereadable(file) == 1 then
            table.insert(files, file)
        end
    end
    return files
end

-- Function to open the main input window for filtering items
function M.open_search_window(items, on_select)
    selected_index = 1
    input_buf = vim.api.nvim_create_buf(false, true)
    M.update_results()
    local width, height = 40, 3
    -- local row, col = math.floor((vim.o.lines - height) / 2 - 1), math.floor((vim.o.columns - width) / 2)
    -- position the input window horizontally aligned with results window
    local col = results_win_config.col or math.floor((vim.o.columns - width) / 2)

    -- position the input window just above the results window
    local row = (results_win_config.row or math.floor((vim.o.lines - height) / 2)) - height - 1
if row < 0 then row = 0 end  -- ensure it doesn't go off-screen
    input_win_id = vim.api.nvim_open_win(input_buf, true, {
        style = "minimal",
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        border = "rounded"
    })

    vim.api.nvim_buf_set_option(input_buf, "bufhidden", "wipe")
    vim.api.nvim_buf_set_option(input_buf, "modifiable", true)
    vim.api.nvim_buf_set_lines(input_buf, 0, -1, false, { "" })
    M.update_results()
    vim.api.nvim_create_autocmd("TextChangedI", {
        buffer = input_buf,
        callback = function() M.update_results() end
    })

    vim.api.nvim_buf_set_keymap(input_buf, "i", "<Down>", "<Cmd>lua require('oldfiles_browser.ui').move_selection(1)<CR>",
        { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(input_buf, "i", "<Up>", "<Cmd>lua require('oldfiles_browser.ui').move_selection(-1)<CR>",
        { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(input_buf, "i", "<CR>",
        "<Cmd>lua require('oldfiles_browser.ui').select_current_item()<CR>",
        { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(input_buf, "i", "<Esc>", "<Cmd>lua require('oldfiles_browser.ui').close_window()<CR>",
        { noremap = true, silent = true })
end

function M.update_results()
    local query = vim.api.nvim_get_current_line()
    local filtered_items = {}

    for _, filepath in ipairs(get_existing_oldfiles()) do
        if query == "" or filepath:lower():match(query:lower()) then
            table.insert(filtered_items, filepath)
        end
    end

    if #filtered_items == 0 then
        table.insert(filtered_items, "No recent files found.")
    end

    selected_index = 1
    M.show_results(filtered_items)
end

function M.show_results(filtered_items)
    if result_win_id and vim.api.nvim_win_is_valid(result_win_id) then
        vim.api.nvim_win_close(result_win_id, true)
    end

    result_buf = vim.api.nvim_create_buf(false, true)

    local width = vim.o.columns
    local height = vim.o.lines
    local win_width = math.ceil(width * 0.5)
    local win_height = math.ceil(height * 0.3)

    local row = math.ceil((height - win_height) / 2)
    local col = math.ceil((width - win_width) / 2)

    result_win_id = vim.api.nvim_open_win(result_buf, false, {
        style = "minimal",
        relative = "editor",
        width = win_width,
        height = win_height,
        row = row,
        col = col,
        border = "rounded",
    })
    results_win_config = { row = row, col = col, width = win_width, height = win_height }
    vim.api.nvim_buf_set_lines(result_buf, 0, -1, false, filtered_items)
    M.highlight_selected_item()
end

function M.highlight_selected_item()
    vim.api.nvim_buf_clear_namespace(result_buf, -1, 0, -1)
    vim.api.nvim_buf_add_highlight(result_buf, -1, "Visual", selected_index - 1, 0, -1)
end

function M.move_selection(direction)
    local line_count = vim.api.nvim_buf_line_count(result_buf)
    selected_index = math.max(1, math.min(selected_index + direction, line_count))
    M.highlight_selected_item()
end

function M.select_current_item()
    local selected = vim.api.nvim_buf_get_lines(result_buf, selected_index - 1, selected_index, false)[1]
    if not selected or selected == "No recent files found." then
        vim.notify("No file selected.", vim.log.levels.WARN)
        return
    end
    M.close_window()
    vim.cmd("edit " .. vim.fn.fnameescape(selected))
end

function M.close_window()
    if win_id and vim.api.nvim_win_is_valid(win_id) then vim.api.nvim_win_close(win_id, true) end
    if input_win_id and vim.api.nvim_win_is_valid(input_win_id) then vim.api.nvim_win_close(input_win_id, true) end
    if result_win_id and vim.api.nvim_win_is_valid(result_win_id) then vim.api.nvim_win_close(result_win_id, true) end
end

function M.open_oldfiles_browser()
    M.open_search_window(get_existing_oldfiles())
end

return M
