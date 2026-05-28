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
local idle_mode = M({ ['description'] = 'What mode to idle in', 'dt', 'regain' })
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
  equip(sets.tp.default[tp_mode.current])
end

local function equip_gear()
  if player.status == 'Engaged' then
    equip_tp()
    return
  end

  equip(sets.idle[idle_mode.current])

  if speed then
    equip(sets.idle.speed)
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
    head = 'Meghanada Visor',
    body = 'Meghanada Cuirie',
    hands = 'Meg. Gloves +2',
    legs = 'Meg. Chausses',
    feet = 'Meg. Jambeaux',
    neck = 'Loricate Torque',
    waist = 'Sailfi Belt +1',
    left_ear = 'Brutal Earring',
    right_ear = 'Alabaster Earring',
    left_ring = 'Gelatinous Ring +1',
    right_ring = 'Defending Ring',
    back = { name = "Camulus's Mantle", augments = { '"Dual Wield"+10', 'Phys. dmg. taken-10%' } },
  }

  sets.idle.regain = set_combine(sets.idle.dt, {
    left_ring = 'Karieyh Ring',
  })

  sets.idle.speed = {
    legs = { name = 'Carmine Cuisses +1', augments = { 'Accuracy+20', 'Attack+12', '"Dual Wield"+6' } },
  }

  sets.tp = {}
  sets.tp.default = {}
  sets.tp.default.normal = {
    head = 'Meghanada Visor',
    body = 'Meghanada Cuirie',
    hands = 'Meg. Gloves +2',
    legs = 'Meg. Chausses',
    feet = 'Meg. Jambeaux',
    neck = 'Lissome Necklace',
    waist = 'Sailfi Belt +1',
    left_ear = 'Brutal Earring',
    right_ear = {
      name = 'Chas. Earring +1',
      augments = { 'System: 1 ID: 1676 Val: 0', 'Accuracy+12', 'Mag. Acc.+12', 'Crit.hit rate+4' },
    },
    left_ring = "K'ayres Ring",
    right_ring = 'Petrov Ring',
    back = { name = "Camulus's Mantle", augments = { '"Dual Wield"+10', 'Phys. dmg. taken-10%' } },
  }

  sets.tp.default.hybrid = set_combine(sets.tp.default.normal, {})

  sets.ws = {}
  sets.ws.default = {
    head = 'Meghanada Visor',
    body = 'Meghanada Cuirie',
    hands = 'Meg. Gloves +2',
    legs = 'Meg. Chausses',
    feet = 'Meg. Jambeaux',
    neck = 'Lissome Necklace',
    waist = 'Sailfi Belt +1',
    left_ear = 'Moonshade Earring',
    right_ear = {
      name = 'Chas. Earring +1',
      augments = { 'System: 1 ID: 1676 Val: 0', 'Accuracy+12', 'Mag. Acc.+12', 'Crit.hit rate+4' },
    },
    left_ring = 'Karieyh Ring',
    right_ring = 'Petrov Ring',
    back = { name = "Camulus's Mantle", augments = { '"Dual Wield"+10', 'Phys. dmg. taken-10%' } },
  }

  sets.ws['Last Stand'] = {
    head = 'Meghanada Visor',
    body = 'Meghanada Cuirie',
    hands = 'Meg. Gloves +2',
    legs = { name = 'Carmine Cuisses +1', augments = { 'Accuracy+20', 'Attack+12', '"Dual Wield"+6' } },
    feet = 'Meg. Jambeaux',
    neck = 'Fotia Gorget',
    waist = 'Fotia Belt',
    left_ear = 'Moonshade Earring',
    right_ear = {
      name = 'Chas. Earring +1',
      augments = { 'System: 1 ID: 1676 Val: 0', 'Accuracy+12', 'Mag. Acc.+12', 'Crit.hit rate+4' },
    },
    left_ring = 'Karieyh Ring',
    right_ring = 'Meghanada Ring',
    back = { name = "Camulus's Mantle", augments = { '"Dual Wield"+10', 'Phys. dmg. taken-10%' } },
  }

  sets.ja = {
    ['Phantom Roll'] = {
      range = { name = 'Compensator', augments = { 'DMG:+15', 'AGI+15', 'Rng.Acc.+15' } },
      neck = 'Regal Necklace',
    },
  }

  lockstyleset = 9

  macro_book = 18
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
  if string.match(spell.type, 'Roll$') then
    equip(sets.ja['Phantom Roll'])
  elseif spell.type == 'WeaponSkill' then
    if sets.ws[spell.name] then
      equip(sets.ws[spell.name])
    else
      equip(sets.ws.default)
    end
  elseif spell.type == 'JobAbility' then
    if sets.ja[spell.name] then
      equip(sets.ja[spell.name])
    end
  end

  set_priorities('hp', 'mp')
end

function midcast(spell)
  set_priorities('hp', 'mp')
end

function aftercast()
  equip_gear()
  set_priorities('hp', 'mp')
end

function status_change(new)
  status = new
  if new == 'Idle' then
    equip_gear()
  elseif new == 'Engaged' then
    equip_tp()
  end
  set_priorities('hp', 'mp')
end

function sub_job_change()
  set_macros()
  set_lockstyle()
  equip_gear()
  set_priorities('hp', 'mp')
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
