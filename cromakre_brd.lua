include('Modes')

local res = require('resources')

local lockstyleset = nil
local macro_book = nil
local macro_page = nil

local bindings = {
  ['^R'] = 'gs c toggle_speed',
  ['^F5'] = 'gs c toggle_dualwield',
  ['^F4'] = 'gs c cycle_weapon',
  ['^F3'] = 'gs c cycle_tp',
  ['^F2'] = 'gs c toggle_jp',
  ['^F1'] = 'gs c cycle_idle',
}

local speed = M(false, 'Whether to use speed equipment')
local idle_mode = M({ ['description'] = 'What mode to idle in', 'dt', 'refresh' })
local dual_wield = M(false, 'Whether to use dual wield')
local weapon_mode = M({
  ['description'] = 'What weapon mode to use',
  'Great Axe',
  'Great Sword',
  'Polearm',
  'Axe',
  'Dagger',
  'Sword',
  'Club',
})
local tp_mode = M({ ['description'] = 'What TP Mode to use', 'normal', 'hybrid' })
local jp_mode = M(false, 'Whether to use JP Cape')

local enspell_active = false

local status = 'Idle'

send_command('bind ^a gs c nothing')

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

local function equip_tp()
  if enspell_active then
    equip(
      set_combine(sets.tp[tp_mode.value], sets.tp.subjob[player.sub_job] or sets.tp.subjob.default, sets.tp.enspell)
    )
  else
    equip(set_combine(sets.tp[tp_mode.value], sets.tp.subjob[player.sub_job] or sets.tp.subjob.default))
  end
end

local function equip_gear()
  if player.status == 'Engaged' then
    equip_tp()
    return
  end
  equip(sets.idle[idle_mode.current], sets.tp.subjob[player.sub_job] or sets.tp.subjob.default)

  if speed then
    equip(sets.idle.speed)
  end
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
    head = 'Aya. Zucchetto +2',
    body = 'Ayanmo Corazza +2',
    hands = 'Aya. Manopolas +2',
    legs = 'Aya. Cosciales +2',
    feet = 'Aya. Gambieras +2',
    neck = 'Loricate Torque',
    waist = 'Sailfi Belt +1',
    left_ear = 'Brutal Earring',
    right_ear = 'Alabaster Earring',
    left_ring = 'Defending Ring',
    right_ring = 'Gelatinous Ring +1',
    back = { name = 'Mecisto. Mantle', augments = { 'Cap. Point+49%', 'MND+1', 'Rng.Acc.+5', 'DEF+6' } },
  }

  sets.idle.refresh = {}

  sets.idle.speed = {
    feet = "Aoidos' Cothrn. +1",
  }

  sets.tp = {}
  sets.tp.default = {
    ammo = 'Coiste Bodhar',
    head = 'Aya. Zucchetto +2',
    body = 'Ayanmo Corazza +2',
    hands = 'Aya. Manopolas +2',
    legs = 'Aya. Cosciales +2',
    feet = 'Aya. Gambieras +2',
    neck = 'Lissome Necklace',
    waist = 'Sailfi Belt +1',
    left_ear = 'Brutal Earring',
    right_ear = 'Alabaster Earring',
    left_ring = 'Hetairoi Ring',
    right_ring = 'Petrov Ring',
    back = { name = 'Mecisto. Mantle', augments = { 'Cap. Point+49%', 'MND+1', 'Rng.Acc.+5', 'DEF+6' } },
  }

  sets.tp.hybrid = {
    left_ring = 'Defending Ring',
    right_ring = 'Gelatinous Ring +1',
    left_ear = 'Alabaster Earring',
  }

  sets.tp.subjob = {}
  sets.tp.subjob.default = {
    main = 'Naegling',
    sub = "Genbu's Shield",
  }
  sets.tp.subjob['NIN'] = {
    -- main = 'Naegling',
    -- sub = 'Machaera +2',
    -- left_ear = 'Suppanomimi',
  }
  sets.tp.subjob['DNC'] = sets.tp.subjob['NIN']

  sets.precast = {}
  sets.precast.spells = {}
  sets.precast.types = {}
  sets.precast.default = {}
  sets.precast.types['BardSong'] = {
    ammo = 'Staunch Tathlum',
    head = 'Aya. Zucchetto +2',
    body = 'Ayanmo Corazza +2',
    hands = 'Aya. Manopolas +2',
    legs = 'Aya. Cosciales +2',
    feet = 'Aya. Gambieras +2',
    neck = "Aoidos' Matinee",
    waist = 'Embla Sash',
    left_ear = 'Alabaster Earring',
    right_ear = "Aoidos' Earring",
    left_ring = 'Kishar Ring',
    right_ring = 'Petrov Ring',
    back = { name = 'Mecisto. Mantle', augments = { 'Cap. Point+49%', 'MND+1', 'Rng.Acc.+5', 'DEF+6' } },
  }
  sets.precast.spells['Utsusemi: Ichi'] = set_combine(sets.precast.default, {
    neck = 'Magoraga Beads',
  })
  sets.precast.spells['Utsusemi: Ni'] = sets.precast.spells['Utsusemi: Ichi']

  sets.midcast = {}

  -- ###############################################################

  -- ###############################################################
  sets.midcast['Healing Magic'] = {}

  sets.midcast['Enhancing Magic'] = {}

  sets.ws = {}
  sets.ws['Savage Blade'] = {}
  sets.ws['Requiescat'] = {}
  sets.ws['Chant du Cygne'] = {}

  sets.obis = {}
  sets.obis.Fire = { waist = 'Hachirin-no-Obi' }
  sets.obis.Earth = { waist = 'Hachirin-no-Obi' }
  sets.obis.Water = { waist = 'Hachirin-no-Obi' }
  sets.obis.Wind = { waist = 'Hachirin-no-Obi' }
  sets.obis.Ice = { waist = 'Hachirin-no-Obi' }
  sets.obis.Lightning = { waist = 'Hachirin-no-Obi' }
  sets.obis.Light = { waist = 'Hachirin-no-Obi' }
  sets.obis.Dark = { waist = 'Hachirin-no-Obi' }

  lockstyleset = 12

  macro_book = 10
  macro_page = 1

  setup_bindings()
  set_macros()
  set_lockstyle()
  equip_gear()
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

  if spell.type == 'WeaponSkill' then
    equip(sets.ws[spell.name] or sets.ws['Savage Blade'])
  end
  set_priorities('mp', 'hp')
end

function midcast(spell)
  if spell.skill == 'Elemental Magic' then
    weathercheck(spell.element, sets.midcast[spell.skill])
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

  set_priorities('mp', 'hp')
end

function aftercast()
  if status == 'Idle' then
    equip_gear()
  elseif status == 'Engaged' then
    equip_tp()
  end
  set_priorities('mp', 'hp')
end

function status_change(new)
  status = new
  if new == 'Idle' then
    equip_gear()
  elseif new == 'Engaged' then
    equip_tp()
  end
  set_priorities('mp', 'hp')
end

function sub_job_change()
  set_macros()
  set_lockstyle()
  equip_gear()
  set_priorities('mp', 'hp')
end

function self_command(command)
  if command == 'warp' then
    equip({ left_ring = 'Warp Ring' })
    local item_table = res.items:with('en', 'Warp Ring')
    send_command('@input /echo Equipping Warp Ring')
    coroutine.schedule(function()
      send_command('@input /echo /item "Warp Ring"')
      send_command('@input /item "Warp Ring" ' .. player.id)
    end, item_table.cast_delay + 3)
  elseif command == 'echodrops' then
    send_command("@input item 'echo drops' <me>")
  elseif command == 'toggle_jp' then
    jp_mode:toggle()
    if jp_mode.value then
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
  elseif command == 'cycle_idle' then
    idle_mode:cycle()
    send_command('@input /echo Idle Mode: ' .. idle_mode.value)
    equip_gear()
  elseif command == 'cycle_weapon' then
    weapon_mode:cycle()
    send_command('@input /echo Weapon Mode: ' .. weapon_mode.value)
    equip_gear()
  elseif command == 'cycle_tp' then
    tp_mode:cycle()
    send_command('@input /echo TP Mode: ' .. tp_mode.value)
    equip_gear()
  elseif command == 'toggle_dualwield' then
    dual_wield:toggle()
    send_command('@input /echo Dual Wield: ' .. dual_wield.current)
    equip_gear()
  end
end

send_command('wait 1; gs equip idle')
