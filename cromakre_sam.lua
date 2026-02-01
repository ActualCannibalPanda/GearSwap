lockstyleset = nil
macro_book = nil
macro_page = nil

local swap_main = true
local swap_back = true

local bindings = {
    ["^F3"] = "gs c toggle_main",
    ["^F2"] = "gs c toggle_back",
    ["^F1"] = "gs c toggle_idle",
}

local idle_mode = 1
local idle_modes = {
    "default", "dt"
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

local function equip_idle()
    equip(sets.idle[idle_modes[idle_mode]])
end

local function equip_tp()
    equip(sets.tp.default)
end

local function equip_weapons()
    local subjob = sets.subjob[player.sub_job] or {}
    equip(set_combine(sets.subjob.default, subjob))
end

-- custom functions
------------------------------
function get_sets()
    sets = require("SAM.lua")

    lockstyleset = 7

    macro_book = 12
    macro_page = 1

    setup_bindings()
    set_macros()
    set_lockstyle()
    equip_idle()
    equip_weapons()
end

function file_unload()
    destroy_bindings()
end

function precast(spell, position)
    if spell.type == "WeaponSkill" then
        equip(sets.ws)
    elseif spell.type == "JobAbility" then
        if sets.ja[spell.name] ~= nil then
            equip(sets.ja[spell.name])
        end
    else
        local skill = sets.precast.types[spell.skill] or {}
        local spell = sets.precast.spells[spell.name] or {}
        if type(spell) == "string" then
            spell = sets.precast.spells[spell]
        end
        equip(set_combine(
            sets.precast.default,
            spell,
            skill
        ))
    end
end

function midcast(spell)
    if spell.type == "JobAbility" then
        equip(sets.ja[spell.name])
    elseif spell.type == "WeaponSkill" then
    else
        local a = sets.midcast[spell.skill]
        if a ~= nil then
            equip(a.default)
        end
    end
end

function aftercast(spell)
    if player.status == "Idle" then
        equip_idle()
    else
        equip_tp()
    end
    equip_weapons()
end

function status_change(new, old)
    if new == "Idle" then
        equip_idle()
    elseif new == "Engaged" then
        equip_tp()
    end
    equip_weapons()
end

function sub_job_change(new, old)
    if new == "SCH" then
        macro_page = 3
    elseif new == "WHM" then
        macro_page = 2
    else
        macro_page = 1
    end

    set_macros()
    set_lockstyle()
    equip_weapons()
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
    elseif command == "toggle_idle" then
        idle_mode = (idle_mode + 1) % #idle_modes + 1
        print("Idle Mode:", idle_modes[idle_mode])
        equip_idle()
    end
end

send_command("wait 1; gs equip idle")
