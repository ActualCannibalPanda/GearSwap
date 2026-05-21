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
local idle_mode = M({ ['description'] = 'What mode to idle in', 'dt' })
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
local tp_mode = M({ ['description'] = 'What TP Mode to use', 'two_handed', 'single', ' dual_wielc' })
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
  local weapon = sets.tp.weapons[weapon_mode.value]

  if not string.match(weapon_mode.current, 'Great') and weapon_mode.current ~= 'Polearm' then
    if dual_wield.value then
      weapon = weapon.dual
    else
      weapon = weapon.single
    end
  end

  equip(sets.tp[tp_mode.value], weapon)
end

local function equip_gear()
  if player.status == 'Engaged' then
    equip_tp()
    return
  end
  local weapon = sets.tp.weapons[weapon_mode.current]

  if not string.match(weapon_mode.current, 'Great') and weapon_mode.current ~= 'Polearm' then
    if dual_wield.value then
      weapon = weapon.dual
    else
      weapon = weapon.single
    end
  end

  equip(sets.idle[idle_mode.current], weapon)

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
    ammo = 'Staunch Tathlum',
    head = { name = "Sakpata's Helm", hp = 91 },
    body = { name = "Sakpata's Plate", hp = 136 },
    hands = { name = "Sakpata's Gauntlets", hp = 91 },
    legs = { name = "Sakpata's Cuisses", hp = 114 },
    feet = { name = "Sakpata's Leggings", hp = 68 },
    neck = 'Loricate Torque',
    waist = 'Sailfi Belt +1',
    left_ear = 'Brutal Earring',
    right_ear = 'Mache Earring',
    left_ring = "Sulevia's Ring",
    right_ring = 'Gelatinous Ring +1',
    back = "Cichol's Mantle",
  }

  sets.idle.speed = {}

  sets.tp = {}
  sets.tp.two_handed = {}
  sets.tp.two_handed.normal = {
    ammo = 'Coiste Bodhar',
    head = 'Flam. Zucchetto +2',
    body = "Sakpata's Plate",
    hands = "Sakpata's Gauntlets",
    legs = 'Sulev. Cuisses +2',
    feet = 'Flam. Gambieras +2',
    neck = 'Lissome Necklace',
    waist = 'Sailfi Belt +1',
    left_ear = 'Brutal Earring',
    right_ear = 'Mache Earring',
    left_ring = 'Flamma Ring',
    right_ring = 'Petrov Ring',
    back = "Cichol's Mantle",
  }

  sets.tp.two_handed.hyrbid = set_combine(sets.tp.two_handed, {
    head = "Sakpata's Helm",
    body = "Sakpata's Plate",
    hands = "Sakpata's Gauntlets",
    legs = "Sakpata's Cuisses",
    feet = "Sakpata's Leggings",
  })

  sets.tp.weapons = {
    ['Great Axe'] = {
      main = 'Kaja Chopper',
      sub = 'Utu Grip',
    },
    ['Great Sword'] = {
      main = 'Montante +1',
      sub = 'Utu Grip',
    },
    ['Polearm'] = {
      main = 'Kaja Lance',
      sub = 'Utu Grip',
    },
    ['Axe'] = {
      single = {
        main = { name = 'Purgation', augments = { 'Attack+4' } },
      },
      dual = {
        main = { name = 'Purgation', augments = { 'Attack+4' } },
        sub = 'Sangarius',
      },
    },
    ['Dagger'] = {
      single = {
        main = { name = 'Malevolence', augments = { 'INT+3', 'Mag. Acc.+5', '"Mag.Atk.Bns."+7' } },
      },
      dual = {
        main = { name = 'Malevolence', augments = { 'INT+3', 'Mag. Acc.+5', '"Mag.Atk.Bns."+7' } },
        sub = 'Sangarius',
      },
    },
    ['Sword'] = {
      single = {
        main = 'Naegling',
      },
      dual = {
        main = 'Naegling',
        sub = 'Sangarius',
      },
    },
    ['Club'] = {
      single = {
        main = 'Mafic Cudgel',
      },
      dual = {
        main = 'Mafic Cudgel',
        sub = 'Sangarius',
      },
    },
  }

  sets.tp.dw = {}
  sets.tp.dw.normal = {
    ammo = 'Coiste Bodhar',
    head = 'Flam. Zucchetto +2',
    body = "Sakpata's Plate",
    hands = "Sakpata's Gauntlets",
    legs = 'Sulev. Cuisses +2',
    feet = 'Flam. Gambieras +2',
    neck = 'Lissome Necklace',
    waist = 'Ioskeha Belt',
    left_ear = 'Brutal Earring',
    right_ear = 'Eabani Earring',
    left_ring = 'Flamma Ring',
    right_ring = 'Petrov Ring',
    back = "Cichol's Mantle",
  }
  sets.tp.dw.hyrbid = set_combine(sets.tp.dw, {
    head = "Sakpata's Helm",
    body = "Sakpata's Plate",
    hands = "Sakpata's Gauntlets",
    legs = "Sakpata's Cuisses",
    feet = "Sakpata's Leggings",
  })

  sets.tp.subjob = {}
  sets.tp.subjob.default = {}

  sets.ws = {}
  sets.ws.default = {
    ammo = 'Knobkierrie',
    head = 'Nyame Helm',
    body = 'Nyame Mail',
    hands = 'Nyame Gauntlets',
    legs = 'Nyame Flanchard',
    feet = 'Sulev. Leggings +2',
    neck = 'Fotia Gorget',
    waist = 'Fotia Belt',
    left_ear = 'Moonshade Earring',
    right_ear = 'Thrud Earring',
    left_ring = 'Hetairoi Ring',
    right_ring = 'Petrov Ring',
    back = "Cichol's Mantle",
  }

  sets.ws["Ukko's Fury"] = {
    ammo = 'Yetshila',
    head = 'Flam. Zucchetto +2',
    body = "Sakpata's Plate",
    hands = 'Flam. Manopolas +2',
    legs = "Sakpata's Cuisses",
    feet = "Sakpata's Leggings",
    neck = 'Lissome Necklace',
    waist = 'Sailfi Belt +1',
    left_ear = 'Brutal Earring',
    right_ear = 'Moonshade Earring',
    left_ring = 'Hetairoi Ring',
    right_ring = 'Karieyh Ring',
    back = "Cichol's Mantle",
  }

  sets.ws.Upheaval = {}
  sets.ws.Upheaval.multi = {
    ammo = 'Coiste Bodhar',
    head = 'Flam. Zucchetto +2',
    body = "Sakpata's Plate",
    hands = 'Sulev. Gauntlets +2',
    legs = 'Sulev. Cuisses +2',
    feet = 'Flam. Gambieras +2',
    neck = 'Lissome Necklace',
    waist = 'Fotia Belt',
    left_ear = 'Brutal Earring',
    right_ear = 'Mache Earring',
    left_ring = 'Hetairoi Ring',
    right_ring = 'Petrov Ring',
    back = "Cichol's Mantle",
  }
  sets.ws.Upheaval.wsd = {
    ammo = 'Knobkierrie',
    head = 'Nyame Helm',
    body = 'Nyame Mail',
    hands = 'Nyame Gauntlets',
    legs = 'Nyame Flanchard',
    feet = 'Sulev. Leggings +2',
    neck = 'Lissome Necklace',
    waist = 'Sailfi Belt +1',
    left_ear = 'Moonshade Earring',
    right_ear = 'Thrud Earring',
    left_ring = 'Karieyh Ring',
    right_ring = 'Petrov Ring',
    back = "Cichol's Mantle",
  }

  sets.precast = {}
  sets.precast.default = {}

  sets.ja = {
    ['Aggressor'] = {
      head = 'Pumm. Mask +1',
    },
    ['Berserk'] = {
      body = "Pummeler's Lorica",
      back = "Cichol's Mantle",
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
  equip_gear()
end

function file_unload()
  destroy_bindings()
end

function precast(spell)
  if spell.type == 'WeaponSkill' then
    if spell.name == 'Upheaval' then
      if player.tp < 1749 then
        equip(sets.ws[spell.name].multi)
      else
        equip(sets.ws[spell.name].wsd)
      end
    else
      if sets.ws[spell.name] then
        equip(sets.ws[spell.name])
      else
        equip(sets.ws.default)
      end
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
  if status == 'Idle' then
    equip_gear()
  elseif status == 'Engaged' then
    equip_tp()
  end
  set_priorities('hp', 'mp')
end

function status_change(new)
  status = new
  if new == 'Idle' then
    equip_gear()
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
    equip_gear()
  end
end
