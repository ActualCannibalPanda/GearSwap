local lockstyleset = nil
local macro_book = nil
local macro_page = nil

local jp_mode = false

local bindings = {
  ['^R'] = 'gs c toggle_speed',
  ['^F3'] = 'gs c toggle_tp',
  ['^F2'] = 'gs c toggle_jp',
  ['^F1'] = 'gs c toggle_idle',
}

local speed = false

local idle_mode = 1
local idle_modes = {
  'dt',
}

local tp_mode = 1
local tp_modes = {
  'default',
  'hybrid',
}

local enspell_active = false

local status = 'Idle'

send_command('bind ^a gs c nothing')

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
  send_command('wait 10; input /lockstyleset ' .. lockstyleset)
end

local function equip_idle()
  equip(sets.idle[idle_modes[idle_mode]], sets.tp.subjob[player.sub_job] or sets.tp.subjob.default)
  if speed then
    equip(sets.idle.speed)
  end
end

local function equip_tp()
  equip(
    set_combine(sets.tp.default, sets.tp[tp_modes[tp_mode]], sets.tp.subjob[player.sub_job] or sets.tp.subjob.default)
  )
end

local function weathercheck(spell_element, set)
  if not set then
    return
  end
  if spell_element == world.weather_element or spell_element == world.day_element then
    equip(set, sets.obis[spell_element])
  else
    equip(set)
  end
  if set[spell_element] then
    equip(set[spell_element])
  end
end

local function set_priorities(key1, key2)
  local future, current = gearswap.equip_list, gearswap.equip_list_history
  local function get_val(piece, key)
    if piece and type(piece) == 'table' and piece[key] and type(piece[key]) == 'number' then
      return piece[key]
    end
    return 0
  end
  for i, v in pairs(future) do
    local priority = get_val(future[i], key1)
      - get_val(current[i], key1)
      + (get_val(future[i], key2) - get_val(current[i], key2))
    if type(v) == 'table' then
      future[i].priority = priority
    else
      future[i] = { name = v, priority = priority }
    end
  end
end

-- custom functions
------------------------------
function get_sets()
  sets.idle = {}
  sets.idle.dt = {
    ammo = 'Staunch Tathlum',
    head = "Sakpata's Helm",
    body = "Sakpata's Plate",
    hands = "Sakpata's Gauntlets",
    legs = "Sakpata's Cuisses",
    feet = "Sakpata's Leggings",
    neck = 'Loricate Torque',
    waist = 'Sailfi Belt +1',
    left_ear = 'Brutal Earring',
    right_ear = 'Mache Earring',
    left_ring = "Sulevia's Ring",
    right_ring = 'Gelatinous Ring +1',
    back = { name = 'Mecisto. Mantle', augments = { 'Cap. Point+49%', 'MND+1', 'Rng.Acc.+5', 'DEF+6' } },
  }

  sets.idle.speed = {}

  sets.tp = {}
  sets.tp.default = {
    ammo = 'Coiste Bodhar',
    head = 'Flam. Zucchetto +2',
    body = 'Flamma Korazin +2',
    hands = 'Sulev. Gauntlets +2',
    legs = 'Sulev. Cuisses +2',
    feet = 'Flam. Gambieras +2',
    neck = 'Lissome Necklace',
    waist = 'Sailfi Belt +1',
    left_ear = 'Brutal Earring',
    right_ear = 'Mache Earring',
    left_ring = 'Flamma Ring',
    right_ring = 'Petrov Ring',
    back = { name = 'Mecisto. Mantle', augments = { 'Cap. Point+49%', 'MND+1', 'Rng.Acc.+5', 'DEF+6' } },
  }

  sets.tp.hybrid = {
    head = "Sakpata's Helm",
    body = "Sakpata's Plate",
    hands = "Sakpata's Gauntlets",
    legs = "Sakpata's Cuisses",
    feet = "Sakpata's Leggings",
  }

  sets.tp.subjob = {}
  sets.tp.subjob.default = {
    main = { name = 'Kaja Chopper' },
    sub = 'Utu Grip',
  }

  sets.precast = {}
  sets.precast.default = {}

  sets.midcast = {
    ['Aggressor'] = {
      head = 'Pumm. Mask +1',
    },
    ['Berserk'] = {
      body = "Pummeler's Lorica",
    },
    ['Retaliation'] = {
      hands = 'Pumm. Mufflers +2',
    },
  }

  lockstyleset = 17

  macro_book = 3
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
  if sets.precast.spells[spell.name] then
    equip(sets.precast.spells[spell.name])
  elseif string.find(spell.name, 'Cur') and spell.name ~= 'Cursna' then
    equip(sets.precast.spells['Cure'])
  elseif spell.action_type == 'Magic' then
    if sets.precast.types[spell.skill] then
      equip(sets.precast.types[spell.skill])
    else
      equip(sets.precast.default)
    end
  end
  set_priorities('mp', 'hp')
end

function midcast(spell)
  if spell.skill == 'Elemental Magic' then
    if can_burst(spell) then
      weathercheck(spell.element, sets.midcast.magic_burst)
    else
      weathercheck(spell.element, sets.midcast[spell.skill])
    end
  elseif spell.skill == 'Enfeebling Magic' and buffactive['Saboteur'] then
    weathercheck(spell.element, { hands = 'Leth. Gantherots +2' })
  else
    local gear = sets.midcast[spell.name] or {}
    if gear.self and spell.target.name == player.name then
      weathercheck(spell.element, gear.self)
    elseif gear.other and spell.target.name ~= player.name then
      weathercheck(spell.element, gear.other)
    else
      weathercheck(spell.element, gear)
    end
  end

  if buffactive['Light Arts'] then
    if buffactive['Perpetuance'] then
      equip(sets.midcast['Perpetuance'])
    end
  end

  if buffactive['Dark Arts'] then
    if spell.skill == 'Elemental Magic' and buffactive['Immanence'] then
      equip(sets.midcast['Immanence'])
    end
  end

  set_priorities('mp', 'hp')
end

function aftercast()
  if status == 'Idle' then
    equip_idle()
  elseif status == 'Engaged' then
    equip_tp()
  end
  set_priorities('mp', 'hp')
end

function status_change(new)
  status = new
  if new == 'Idle' then
    equip_idle()
    enable('main', 'sub')
  elseif new == 'Engaged' then
    equip_tp()
    disable('main', 'sub')
  end
  set_priorities('mp', 'hp')
end

function sub_job_change()
  set_macros()
  set_lockstyle()
  equip_idle()
  set_priorities('mp', 'hp')
end

function self_command(command)
  if command == 'echodrops' then
    send_command("@input item 'echo drops' <me>")
  elseif command == 'toggle_jp' then
    jp_mode = not jp_mode
    if jp_mode then
      send_command('@input /echo JP MODE Off')
      enable('back')
      aftercast()
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
    aftercast()
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
