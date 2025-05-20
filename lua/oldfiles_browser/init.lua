local M = {}

local ui = require("oldfiles_browser.ui")

function M.open_window()
    ui.open_oldfiles_browser()
    vim.cmd("startinsert")
end

return M
