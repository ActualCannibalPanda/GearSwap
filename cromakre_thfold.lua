lockstyleset = nil
macro_book = nil
macro_page = nil

local bindings = {
    ["^-"] = "gs c toggle_main",
    ["^="] = "gs c toggle_back",
}

send_command("bind ^a gs c nothing")

------------------------------
-- custom functions
local function setup_bindings()
    for key, command in pairs(bindings) do
        send_command("bind " .. key .. " " .. command)
    end
end

local function destroy_bindings()
    for _, key in pairs(bindings) do
        send_command("unbind " .. key)
    end
end
local function set_macros()
    send_command('@input /macro book ' .. macro_book .. '; wait 1; @input /macro set ' .. macro_page)
end

local function set_lockstyle()
    if lockstyleset ~= nil then
        send_command('wait 10; input /lockstyleset ' .. lockstyleset)
    end
end
-- custom functions
------------------------------
function get_sets()
    sets = require("THF.lua")
    sets.bone = set_combine(sets.idle, sets.bone)

    lockstyleset = 3

    macro_book = 6
    if player.sub_job == "NIN" then
        macro_page = 1
    else
        macro_page = 1
    end

    setup_bindings()
    set_macros()
    -- set_lockstyle()
end

function file_unload()
    destroy_bindings()
end

function precast(spell, position)
    equip(sets.precast)
end

function midcast(spell)
    if spell.type ~= "WeaponSkill" then
        equip(sets.midcast)
    end
end

function aftercast(spell)
    if player.status == "Idle" then
        equip(sets.idle)
    else
        equip(sets.tp)
    end
end

function status_change(new, old)
    if new == "Idle" then
        equip(sets.idle)
    elseif new == "Engaged" then
        equip(sets.tp)
    end
end

function sub_job_change(new, old)
    if new == "NIN" then
        macro_page = 1
    else
        macro_page = 1
    end

    set_macros()
    set_lockstyle()
end

function self_command(command)
    if command == "toggle_main" then
        swap_main = not swap_main
        if swap_main then
            send_command("gs enable main")
            send_command("gs enable sub")
        else
            send_command("gs disable main")
            send_command("gs disable sub")
        end
    elseif command == "toggle_back" then
        swap_back = not swap_back
        if swap_back then
            send_command("gs enable back")
        else
            send_command("gs disable back")
        end
    end
end

send_command("wait 1; gs equip idle")
