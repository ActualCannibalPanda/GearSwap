local lockstyleset = nil
local macro_book = nil
local macro_page = nil

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
  'xp',
}

local tp_mode = 1
local tp_modes = {
  'default',
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
  if idle_modes[idle_mode] == 'xp' then
    equip(sets.idle[idle_modes[idle_mode]])
  else
    equip(sets.idle[idle_modes[idle_mode]], sets.tp.subjob[player.sub_job] or sets.tp.subjob.default)
  end
  if speed then
    equip(sets.idle.speed)
  end
end

local function equip_tp()
  if enspell_active then
    equip(set_combine(sets.tp.default, sets.tp.subjob[player.sub_job] or sets.tp.subjob.default, sets.tp.enspell))
  else
    equip(set_combine(sets.tp.default, sets.tp.subjob[player.sub_job] or sets.tp.subjob.default))
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
    body = { name = 'Rev. Surcoat +3', hp = 254, mp = 62 },
    hands = {
      name = 'Souv. Handsch. +1',
      augments = { 'HP+105', 'Enmity+9', 'Potency of "Cure" effect received +15%' },
      hp = 239,
      mp = 14,
    },
    head = { name = 'Chev. Armet +2', hp = 135, mp = 119 },
    legs = { name = 'Chev. Cuisses +2', hp = 117, mp = 61 },
    right_ring = { name = "K'ayres Ring", hp = 70 },
    feet = { name = "Sakpata's Leggings", hp = 68, mp = 35 },
    back = {
      name = "Rudianos's Mantle",
      augments = { 'HP+60', 'Eva.+20 /Mag. Eva.+20', 'Enmity+10' },
      priority = 7,
      hp = 60,
    },
    left_ear = { name = 'Cryptic Earring', hp = 40 },
    left_ring = { name = 'Supershear Ring', hp = 30, mp = 30 },
    waist = { name = 'Sailfi Belt +1' },
    right_ear = {
      name = 'Chev. Earring +1',
      augments = { 'System: 1 ID: 1676 Val: 0', 'Accuracy+15', 'Mag. Acc.+15', 'Damage taken-5%' },
    },
    neck = { name = 'Loricate Torque' },
    ammo = { name = 'Staunch Tathlum' },
  }
  sets.idle.xp = {
    main = { name = "Sakpata's Sword", hp = 100, mp = 40 },
    sub = { name = 'Priwen', hp = 30 },
    ammo = 'Staunch Tathlum',
    head = { name = 'Chev. Armet +2', hp = 135, mp = 119 },
    body = { name = 'Chev. Cuirass +2', hp = 141, mp = 134 },
    hands = {
      name = 'Souv. Handsch. +1',
      augments = { 'HP+105', 'Enmity+9', 'Potency of "Cure" effect received +15%' },
      hp = 239,
      mp = 14,
    },
    legs = { name = 'Chev. Cuisses +2', hp = 117, mp = 61 },
    feet = { name = 'Chev. Sabatons +2', hp = 42, mp = 34 },
    neck = 'Loricate Torque',
    waist = { name = 'Creed Baudrier', hp = 40 },
    left_ear = { name = 'Cryptic Earring', hp = 40 },
    right_ear = {
      name = 'Chev. Earring +1',
      augments = { 'System: 1 ID: 1676 Val: 0', 'Accuracy+15', 'Mag. Acc.+15', 'Damage taken-5%' },
    },
    left_ring = 'Apeile Ring',
    right_ring = { name = "K'ayres Ring", hp = 70 },
    back = { name = "Rudianos's Mantle", augments = { 'HP+60', 'Eva.+20 /Mag. Eva.+20', 'Enmity+10' }, hp = 60 },
  }

  sets.idle.speed = {
    legs = { name = 'Carmine Cuisses +1', augments = { 'Accuracy+20', 'Attack+12', '"Dual Wield"+6' }, hp = 50 },
  }

  sets.tp = {}
  sets.tp.default = {
    body = { name = 'Rev. Surcoat +3', hp = 254, mp = 62 },
    hands = {
      name = 'Souv. Handsch. +1',
      augments = { 'HP+105', 'Enmity+9', 'Potency of "Cure" effect received +15%' },
      hp = 239,
      mp = 14,
    },
    head = { name = 'Chev. Armet +2', hp = 135, mp = 119 },
    legs = { name = 'Chev. Cuisses +2', hp = 117, mp = 61 },
    right_ring = { name = "K'ayres Ring", hp = 70 },
    feet = { name = "Sakpata's Leggings", hp = 68, mp = 35 },
    back = {
      name = "Rudianos's Mantle",
      augments = { 'HP+60', 'Eva.+20 /Mag. Eva.+20', 'Enmity+10' },
      priority = 7,
      hp = 60,
    },
    left_ear = { name = 'Cryptic Earring', hp = 40 },
    left_ring = { name = 'Supershear Ring', hp = 30, mp = 30 },
    waist = { name = 'Sailfi Belt +1' },
    right_ear = {
      name = 'Chev. Earring +1',
      augments = { 'System: 1 ID: 1676 Val: 0', 'Accuracy+15', 'Mag. Acc.+15', 'Damage taken-5%' },
    },
    neck = { name = 'Loricate Torque' },
    ammo = { name = 'Staunch Tathlum' },
  }

  sets.tp.subjob = {}
  sets.tp.subjob.default = {
    main = 'Brilliance',
    sub = { name = 'Priwen', hp = 30 },
  }

  sets.precast = {}
  sets.precast.default = {
    body = { name = 'Rev. Surcoat +3', hp = 254, mp = 62 },
    hands = {
      name = 'Souv. Handsch. +1',
      augments = { 'HP+105', 'Enmity+9', 'Potency of "Cure" effect received +15%' },
      hp = 239,
      mp = 14,
    },
    head = { name = 'Chev. Armet +2', hp = 135, mp = 119 },
    legs = { name = 'Chev. Cuisses +2', hp = 117, mp = 61 },
    back = {
      name = "Rudianos's Mantle",
      augments = { 'HP+60', 'Eva.+20 /Mag. Eva.+20', 'Enmity+10' },
      priority = 7,
      hp = 60,
    },
    waist = { name = 'Creed Baudrier', hp = 40 },
    feet = {
      name = 'Odyssean Greaves',
      augments = { 'Blood Pact Dmg.+1', '"Fast Cast"+3', 'Phalanx +4', 'Mag. Acc.+4 "Mag.Atk.Bns."+4' },
      hp = 20,
      mp = 14,
    },
    neck = { name = 'Voltsurge Torque', mp = 20 },
    left_ear = { name = 'Loquac. Earring', mp = 30 },
    right_ear = {
      name = 'Chev. Earring +1',
      augments = { 'System: 1 ID: 1676 Val: 0', 'Accuracy+15', 'Mag. Acc.+15', 'Damage taken-5%' },
    },
    left_ring = { name = "Naji's Loop" },
    right_ring = { name = 'Kishar Ring' },
    ammo = { name = 'Ginsen' },
  }

  sets.midcast = {}
  sets.midcast.full_enmity = {
    hands = {
      name = 'Souv. Handsch. +1',
      augments = { 'HP+105', 'Enmity+9', 'Potency of "Cure" effect received +15%' },
      hp = 239,
      mp = 14,
    },
    head = {
      name = 'Souveran Schaller',
      augments = { 'HP+80', 'Enmity+7', 'Potency of "Cure" effect received +10%' },
      hp = 205,
      mp = 109,
    },
    legs = {
      name = 'Souv. Diechlings +1',
      augments = { 'HP+105', 'Enmity+9', 'Potency of "Cure" effect received +15%' },
      hp = 162,
      mp = 41,
    },
    body = {
      name = 'Souveran Cuirass',
      augments = { 'HP+80', 'Enmity+7', 'Potency of "Cure" effect received +10%' },
      priority = 10,
      hp = 146,
      mp = 59,
    },
    back = { name = "Rudianos's Mantle", augments = { 'HP+60', 'Eva.+20 /Mag. Eva.+20', 'Enmity+10' }, hp = 60 },
    right_ear = { name = 'Cryptic Earring', hp = 40 },
    waist = { name = 'Creed Baudrier', hp = 40 },
    right_ring = { name = 'Supershear Ring', hp = 30 },
    feet = {
      name = 'Eschite Greaves',
      augments = { 'Mag. Evasion+15', 'Spell interruption rate down +15%', 'Enmity+7' },
      hp = 18,
    },
    left_ring = { name = 'Apeile Ring', priority = 4 },
    left_ear = { name = 'Friomisi Earring', priority = 3 },
    neck = { name = 'Unmoving Collar', priority = 2 },
    ammo = { name = 'Staunch Tathlum', priority = 1 },
  }
  sets.midcast.sird = {
    hands = {
      name = 'Souv. Handsch. +1',
      augments = { 'HP+105', 'Enmity+9', 'Potency of "Cure" effect received +15%' },
      hp = 239,
      mp = 14,
    },
    head = {
      name = 'Souveran Schaller',
      augments = { 'HP+80', 'Enmity+7', 'Potency of "Cure" effect received +10%' },
      hp = 205,
      mp = 109,
    },
    body = { name = 'Chev. Cuirass +2', hp = 141, mp = 134 },
    left_ring = { name = "K'ayres Ring", hp = 70 },
    back = { name = "Rudianos's Mantle", augments = { 'HP+60', 'Eva.+20 /Mag. Eva.+20', 'Enmity+10' }, hp = 60 },
    legs = { name = 'Carmine Cuisses +1', augments = { 'Accuracy+20', 'Attack+12', '"Dual Wield"+6' }, hp = 50 },
    right_ear = { name = 'Cryptic Earring', hp = 40 },
    right_ring = { name = 'Supershear Ring', hp = 30, mp = 30 },
    feet = {
      name = 'Odyssean Greaves',
      augments = { 'Attack+12', 'Enmity+6', 'VIT+6', 'Accuracy+3' },
      hp = 20,
      mp = 40,
    },
    neck = { name = 'Unmoving Collar', priority = 4 },
    waist = { name = 'Rumination Sash', priority = 3 },
    left_ear = { name = 'Knightly Earring', priority = 2 },
    ammo = { name = 'Staunch Tathlum', priority = 1 },
  }
  -- ###############################################################

  -- ###############################################################
  sets.midcast['Healing Magic'] = sets.midcast.sird
  sets.midcast['Enhancing Magic'] = sets.midcast.sird
  sets.midcast['Divine Magic'] = sets.midcast.sird
  sets.midcast['Blue Magic'] = sets.midcast.sird

  sets.midcast['Flash'] = sets.midcast.full_enmity
  sets.midcast['Jettatura'] = sets.midcast.full_enmity

  sets.midcast['Savage Blade'] = sets.midcast.full_enmity
  sets.midcast['Requiescat'] = sets.midcast.full_enmity
  sets.midcast['Chant du Cygne'] = sets.midcast.full_enmity

  sets.obis = {}
  sets.obis.Fire = { waist = 'Hachirin-no-Obi' }
  sets.obis.Earth = { waist = 'Hachirin-no-Obi' }
  sets.obis.Water = { waist = 'Hachirin-no-Obi' }
  sets.obis.Wind = { waist = 'Hachirin-no-Obi' }
  sets.obis.Ice = { waist = 'Hachirin-no-Obi' }
  sets.obis.Lightning = { waist = 'Hachirin-no-Obi' }
  sets.obis.Light = { waist = 'Hachirin-no-Obi' }
  sets.obis.Dark = { waist = 'Hachirin-no-Obi' }

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

function precast()
  equip(sets.precast.default)
  set_priorities('hp', 'mp')
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

  -- just add refresh gear here
  if string.match(spell.name, '^Refresh') and spell.target.name == player.name then
    equip({ waist = 'Gishdubar Sash' })
  end
  set_priorities('hp', 'mp')
end

function aftercast()
  if status == 'Idle' then
    equip_idle()
  elseif status == 'Engaged' then
    equip_tp()
  end
  set_priorities('hp', 'mp')
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
  set_priorities('hp', 'mp')
end

function sub_job_change()
  set_macros()
  set_lockstyle()
  equip_idle()
  set_priorities('hp', 'mp')
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
