require('vis')


vis.events.subscribe(vis.events.INIT, function()
    vis:command("set theme mono")
end)

vis.events.subscribe(vis.events.WIN_OPEN, function(win)
    vis:command("set tabwidth 4")
    vis:command("set numbers true")
    vis:command("set relativenumbers true")
    vis:command("set autoindent true")
    vis:command("set showspaces true")
    vis:command("set showtabs false")
    vis:command("set expandtab on")
end)

-- local paw = require('plugins/vis-paw')
local modal = require('plugins/vis-modal')
local autoclose = require('plugins/vis-autoclose')
local colorizer = require('plugins/vis-colorizer')
local remove_trailing_whitespace = require('plugins/vis-remove-trailing-whitespace')
