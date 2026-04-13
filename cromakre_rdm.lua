lockstyleset = nil
macro_book = nil
macro_page = nil

local jp_mode = false

local bindings = {
  ['^#'] = 'gs c echodrops',
  ['^R'] = 'gs c toggle_speed',
  ['^F3'] = 'gs c toggle_tp',
  ['^F2'] = 'gs c toggle_jp',
  ['^F1'] = 'gs c toggle_idle',
}

local speed = false

local idle_mode = 1
local idle_modes = {
  'dt',
  'refresh',
}

local tp_mode = 1
local tp_modes = {
  'tp',
  'hybrid',
}

local enspell_active = false

local status = 'Idle'

send_command('bind ^a gs c nothing')

------------------------------
-- custom functions
local can_burst = require('magic.lua')

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
  if speed then
    equip(sets.idle.speed)
  end
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
  sets = require('RDM.lua')(sets)

  sets.idle = {}
  sets.idle.dt = {
    ammo = 'Kalboron Stone',
    head = 'Leth. Chappel +2',
    body = 'Lethargy Sayon +2',
    hands = 'Leth. Ganth. +2',
    legs = 'Nyame Flanchard',
    feet = 'Nyame Sollerets',
    neck = 'Loricate Torque',
    waist = 'Sailfi Belt +1',
    left_ear = 'Loquac. Earring',
    right_ear = 'Brutal Earring',
    left_ring = 'Ayanmo Ring',
    right_ring = 'Gelatinous Ring +1',
    back = {
      name = "Sucellos's Cape",
      augments = { 'DEX+20', 'Accuracy+20 Attack+20', 'Accuracy+10', '"Dbl.Atk."+10', 'Damage taken-5%' },
    },
  }

  sets.idle.refresh = {
    ammo = 'Ginsen',
    head = 'Viti. Chapeau +2',
    body = 'Atrophy Tabard +3',
    hands = 'Aya. Manopolas +2',
    legs = 'Leth. Fuseau +2',
    feet = 'Aya. Gambieras +2',
    neck = 'Sanctity Necklace',
    waist = 'Sailfi Belt +1',
    left_ear = 'Mache Earring',
    right_ear = 'Brutal Earring',
    left_ring = 'Ayanmo Ring',
    right_ring = 'Karieyh Ring',
    back = {
      name = "Sucellos's Cape",
      augments = { 'DEX+20', 'Accuracy+20 Attack+20', 'Accuracy+10', '"Dbl.Atk."+10', 'Damage taken-5%' },
    },
  }

  sets.idle.speed = {
    legs = { name = 'Carmine Cuisses +1', augments = { 'Accuracy+20', 'Attack+12', '"Dual Wield"+6' } },
  }

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
    string.match(name, '^Enfire')
    or string.match(name, '^Enwater')
    or string.match(name, '^Enblizzard')
    or string.match(name, '^Enaero')
    or string.match(name, '^Enthunder')
  then
    -- enspells change
    enspell_active = value
    equip_tp()
  end
end

function precast(spell, position)
  if spell.type == 'WeaponSkill' then
    equip(sets.ws[spell.name] or sets.ws)
  elseif spell.type == 'JobAbility' then
    if sets.ja[spell.name] ~= nil then
      equip(sets.ja[spell.name])
    end
  else
    local skill = sets.precast.types[spell.skill] or {}
    local spellGear = sets.precast.spells[spell.name] or {}
    if type(spellGear) == 'string' then
      spellGear = sets.precast.spells[spellGear]
    end
    equip(set_combine(sets.precast.default, spellGear, skill))
  end
end

function midcast(spell)
  if spell.type == 'JobAbility' then
    equip(sets.ja[spell.name])
  elseif spell.type == 'WeaponSkill' then
    equip(sets.ws[spell.name] or sets.ws)
  else
    if spell.skill == '(N/A)' then
      return
    end
    local gear = sets.midcast[spell.skill].default
    local spellGear = sets.midcast[spell.skill].spells[spell.name] or {}
    if type(spellGear) == 'string' then
      spellGear = sets.midcast[spell.skill].spells[spellGear]
    end
    -- you use different gear depending on who you are targetting
    if spell.skill == 'Enhancing Magic' then
      if spell.target.name == player.name and spellGear.self ~= nil then
        spellGear = set_combine(spellGear, spellGear.self)
      elseif spell.target.name ~= player.name and spellGear.other ~= nil then
        spellGear = set_combine(spellGear, spellGear.other)
      end
    end
    if spell.skill == 'Elemental Magic' then
      if can_burst(spell) then
        gear = sets.midcast[spell.skill].burst
      end
    end
    if gear ~= nil then
      equip(set_combine(gear, spellGear))
    end
    -- just add refresh gear here
    if string.match(spell.name, '^Refresh') and spell.target.name == player.name then
      equip({ waist = 'Gishdubar Sash' })
    end
    -- if Saboteur is active we want to add Empyrean Hands in the the bonus to it
    if spell.skill == 'Enfeebling Magic' and buffactive['Saboteur'] then
      equip(sets.ja.Saboteur)
    end
  end
end

function aftercast(spell)
  if status == 'Idle' then
    equip_idle()
  elseif status == 'Engaged' then
    equip_tp()
  end
  equip_weapons()
end

function status_change(new, old)
  status = new
  if new == 'Idle' then
    equip_idle()
    enable('main', 'sub')
  elseif new == 'Engaged' then
    equip_tp()
    disable('main', 'sub')
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
  if command == 'echodrops' then
    send_command("@input item 'echo drops' <me>")
  elseif command == 'toggle_jp' then
    jp_mode = not jp_mode
    if jp_mode then
      send_command('@input /echo JP MODE Off')
      enable('back')
      aftercast(nil)
    else
      send_command('@input /echo JP MODE On')
      equip({ back = { name = 'Mecisto. Mantle', augments = { 'Cap. Point+49%', 'MND+1', 'Rng.Acc.+5', 'DEF+6' } } })
      disable('back')
    end
  elseif command == 'toggle_speed' then
    speed = not speed
    if speed then
      send_command('@input /echo SPEED On')
    else
      send_command('@input /echo SPEED Off')
    end
    aftercast(nil)
  elseif command == 'toggle_idle' then
    if idle_mode + 1 > #idle_modes then
      idle_mode = 1
    else
      idle_mode = idle_mode + 1
    end
    send_command('@input /echo Idle Mode: ' .. idle_modes[idle_mode])
    equip_idle()
  elseif command == 'toggle_tp' then
    if tp_mode + 1 > #tp_modes then
      tp_mode = 1
    else
      tp_mode = tp_mode + 1
    end
    send_command('@input /echo TP Mode: ' .. tp_modes[tp_mode])
    equip_tp()
  end
end

send_command('wait 1; gs equip idle')
