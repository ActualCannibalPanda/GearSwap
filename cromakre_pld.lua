lockstyleset = nil
macro_book = nil
macro_page = nil

local swap_main = true
local swap_back = true

local bindings = {
  ['^#'] = 'gs c echodrops',
  ['^F4'] = 'gs c toggle_tp',
  ['^F3'] = 'gs c toggle_main',
  ['^F2'] = 'gs c toggle_back',
  ['^F1'] = 'gs c toggle_idle',
}

local idle_mode = 1
local idle_modes = {
  'default',
  'default speed',
}

local tp_mode = 1
local tp_modes = {
  'default',
}

local status = 'Idle'

send_command('bind ^a gs c nothing')

------------------------------
-- custom functions
local function setup_bindings()
  for key, command in pairs(bindings) do
    send_command('bind ' .. key .. ' ' .. command)
  end
end

local function destroy_bindings()
  for _, key in pairs(bindings) do
    send_command('unbind ' .. key)
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
  equip(set_combine(sets.tp.default, sets.tp[tp_modes[tp_mode]] or {}))
end

-- custom functions
------------------------------
function get_sets()
  sets = require('PLD.lua')(sets)

  lockstyleset = 14

  macro_book = 7
  macro_page = 1

  setup_bindings()
  set_macros()
  set_lockstyle()
  equip_idle()
end

function file_unload()
  destroy_bindings()
end

function precast(spell)
  local skill = sets.precast.types[spell.skill] or {}
  local spellGear = sets.precast.spells[spell.name] or {}
  if type(spellGear) == 'string' then
    spellGear = sets.precast.spells[spellGear]
  end
  equip(set_combine(sets.precast.default, spellGear, skill))
end

function midcast(spell)
  if spell.type == 'JobAbility' then
    equip(sets.ja.default)
    if sets.ja[spell.name] ~= nil then
      equip(sets.ja[spell.name])
    end
  elseif spell.type == 'WeaponSkill' then
    equip(sets.ws)
  else
    if spell.skill == '(N/A)' then
      return
    end
    local gear = sets.midcast[spell.skill].default
    local spellGear = sets.midcast[spell.skill].spells[spell.name] or {}
    if type(spellGear) == 'string' then
      spellGear = sets.midcast[spell.skill].spells[spellGear]
    end
    if gear ~= nil then
      equip(set_combine(gear, spellGear))
    end
  end
end

function aftercast()
  if status == 'Idle' then
    equip_idle()
  elseif status == 'Engaged' then
    equip_tp()
  end
end

function status_change(new)
  status = new
  if new == 'Idle' then
    equip_idle()
  elseif new == 'Engaged' then
    equip_tp()
  end
end

function sub_job_change()
  set_macros()
  set_lockstyle()
  equip_idle()
end

function self_command(command)
  if command == 'echodrops' then
    send_command("/input item 'echo drops' <me>")
  elseif command == 'toggle_main' then
    swap_main = not swap_main
    if swap_main then
      send_command('gs enable main')
      send_command('gs enable sub')
    else
      send_command('gs disable main')
      send_command('gs disable sub')
    end
  elseif command == 'toggle_back' then
    swap_back = not swap_back
    if swap_back then
      send_command('gs enable back')
    else
      send_command('gs disable back')
    end
  elseif command == 'toggle_idle' then
    if idle_mode + 1 > #idle_modes then
      idle_mode = 1
    else
      idle_mode = idle_mode + 1
    end
    print('Idle Mode:', idle_modes[idle_mode])
    equip_idle()
  elseif command == 'toggle_tp' then
    if tp_mode + 1 > #tp_modes then
      tp_mode = 1
    else
      tp_mode = tp_mode + 1
    end
    print('TP Mode: ', tp_modes[tp_mode])
    equip_tp()
  end
end

send_command('wait 1; gs equip idle')
