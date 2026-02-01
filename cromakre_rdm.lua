lockstyleset = nil
macro_book = nil
macro_page = nil

local swap_main = true
local swap_back = true

local bindings = {
	["^#"] = "gs c echodrops",
	["^F4"] = "gs c toggle_tp",
	["^F3"] = "gs c toggle_main",
	["^F2"] = "gs c toggle_back",
	["^F1"] = "gs c toggle_idle",
}

local idle_mode = 1
local idle_modes = {
	"default",
	"refresh",
	"refresh speed",
}

local tp_mode = 1
local tp_modes = {
	"default",
	"hybrid",
}

local enspell_active = false

local status = "Idle"

send_command("bind ^a gs c nothing")

------------------------------
-- custom functions
local can_burst = require("magic.lua")

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
	send_command("@input /macro book " .. macro_book .. "; wait 1; @input /macro set " .. macro_page)
end

local function set_lockstyle()
	if lockstyleset ~= nil then
		send_command("wait 10; input /lockstyleset " .. lockstyleset)
	end
end

local function equip_idle()
	equip(sets.idle[idle_modes[idle_mode]])
end

local function equip_tp()
	if enspell_active then
		equip(set_combine(sets.tp.default, sets.tp.subjob[player.sub_job] or {}, sets.tp.enspell))
	else
		equip(set_combine(sets.tp.default, sets.tp.subjob[player.sub_job] or {}))
	end
	if tp_mode > 1 then
		equip(sets.tp[tp_modes[tp_mode]])
	end
end

local function equip_weapons()
	local subjob = sets.subjob[player.sub_job] or {}
	equip(set_combine(sets.subjob.default, subjob))
end

-- custom functions
------------------------------
function get_sets()
	sets = require("RDM.lua")

	lockstyleset = 6

	macro_book = 5
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

function buff_change(name, value, buff_details)
	if
		string.match(name, "^Enfire")
		or string.match(name, "^Enwater")
		or string.match(name, "^Enblizzard")
		or string.match(name, "^Enaero")
		or string.match(name, "^Enthunder")
	then
		-- enspells change
		enspell_active = value
		equip_tp()
	end
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
		local spellGear = sets.precast.spells[spell.name] or {}
		if type(spellGear) == "string" then
			spellGear = sets.precast.spells[spellGear]
		end
		equip(set_combine(sets.precast.default, spellGear, skill))
	end
end

function midcast(spell)
	if spell.type == "JobAbility" then
		equip(sets.ja[spell.name])
	elseif spell.type == "WeaponSkill" then
		equip(sets.ws)
	else
		if spell.skill == "(N/A)" then
			return
		end
		local gear = sets.midcast[spell.skill].default
		local spellGear = sets.midcast[spell.skill].spells[spell.name] or {}
		if type(spellGear) == "string" then
			spellGear = sets.midcast[spell.skill].spells[spellGear]
		end
		if spell.skill == "Enhancing Magic" then
			if spellGear.self ~= nil then
				if spell.target.name == player.name then
					spellGear = set_combine(spellGear, spellGear.self)
				end
			elseif spellGear.other ~= nil then
				if spell.target.name ~= player.name then
					spellGear = set_combine(spellGear, spellGear.other)
				end
			end
		end
		if spell.skill == "Elemental Magic" then
			if can_burst() then
				gear = sets.midcast[spell.skill].burst
			end
		end
		if gear ~= nil then
			if string.match(spell.name, "^Bar") then
				equip(set_combine(gear, spellGear, sets.midcast[spell.skill].barspells))
			else
				equip(set_combine(gear, spellGear))
			end
		end
		if string.match(spell.name, "^Refresh") and spell.target.name == player.name then
			equip({ waist = "Gishdubar Sash" })
		end
		if spell.skill == "Enhancing Magic" and spell.target.name ~= player.name and buffactive["Composure"] then
			equip(sets.ja.Composure)
		end
		if spell.skill == "Enfeebling Magic" and buffactive["Saboteur"] then
			equip(sets.ja.Saboteur)
		end
	end
end

function aftercast(spell)
	if status == "Idle" then
		equip_idle()
	elseif status == "Engaged" then
		equip_tp()
	end
	equip_weapons()
end

function status_change(new, old)
	status = new
	if new == "Idle" then
		equip_idle()
	elseif new == "Engaged" then
		equip_tp()
	end
	equip_weapons()
end

function sub_job_change(new, old)
	set_macros()
	set_lockstyle()
	equip_idle()
	equip_weapons()
end

function self_command(command)
	if command == "echodrops" then
		send_command("/input item 'echo drops' <em>")
	elseif command == "toggle_main" then
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
		if idle_mode + 1 > #idle_modes then
			idle_mode = 1
		else
			idle_mode = idle_mode + 1
		end
		print("Idle Mode:", idle_modes[idle_mode])
		equip_idle()
	elseif command == "toggle_tp" then
		if tp_mode + 1 > #tp_modes then
			tp_mode = 1
		else
			tp_mode = tp_mode + 1
		end
		print("TP Mode: ", tp_modes[tp_mode])
		equip_tp()
	end
end

send_command("wait 1; gs equip idle")
