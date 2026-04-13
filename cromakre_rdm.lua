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
  'refresh',
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
  equip(sets.idle[idle_modes[idle_mode]], sets.tp.subjob[player.sub_job] or sets.tp.subjob.default)
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

  sets.tp = {}
  sets.tp.default = {
    ammo = 'Ginsen',
    head = 'Aya. Zucchetto +2',
    body = 'Ayanmo Corazza +2',
    hands = 'Aya. Manopolas +2',
    legs = 'Aya. Cosciales +2',
    feet = 'Aya. Gambieras +2',
    neck = 'Lissome Necklace',
    waist = 'Sailfi Belt +1',
    left_ear = 'Mache Earring',
    right_ear = 'Brutal Earring',
    left_ring = 'Hetairoi Ring',
    right_ring = 'Petrov Ring',
    back = {
      name = "Sucellos's Cape",
      augments = { 'DEX+20', 'Accuracy+20 Attack+20', 'Accuracy+10', '"Dbl.Atk."+10', 'Damage taken-5%' },
    },
  }

  sets.tp.subjob = {}
  sets.tp.subjob.default = {
    main = 'Naegling',
    sub = "Genbu's Shield",
  }
  sets.tp.subjob['NIN'] = {
    main = 'Naegling',
    sub = 'Colada',
    left_ear = 'Suppanomimi',
  }
  sets.tp.subjob['DNC'] = sets.tp.subjob['NIN']

  sets.precast = {}
  sets.precast = {}
  sets.precast.spells = {}
  sets.precast.types = {}
  sets.precast.default = {
    ammo = 'Kalboron Stone',
    head = 'Atrophy Chapeau +3',
    body = 'Viti. Tabard +2',
    hands = 'Jhakri Cuffs +2',
    legs = 'Enif Cosciales',
    feet = { name = 'Carmine Greaves', augments = { 'HP+60', 'MP+60', 'Phys. dmg. taken -3' } },
    neck = 'Voltsurge Torque',
    waist = 'Embla Sash',
    left_ear = 'Loquac. Earring',
    right_ear = {
      name = 'Lethargy Earring',
      augments = { 'System: 1 ID: 1676 Val: 0', 'Accuracy+7', 'Mag. Acc.+7' },
    },
    left_ring = 'Kishar Ring',
    right_ring = 'Jhakri Ring',
    back = {
      name = "Sucellos's Cape",
      augments = { 'MND+20', 'Mag. Acc+20 /Mag. Dmg.+20', 'Mag. Acc.+10', '"Fast Cast"+10' },
    },
  }
  sets.precast.types['Enhancing Magic'] = set_combine(sets.precast.default, { waist = 'Siegel Sash' })
  sets.precast.spells['Stoneskin'] = set_combine(sets.precast.types['Enhancing Magic'], {
    main = 'Pukulatmuj +1',
  })
  sets.precast.spells['Cure'] = set_combine(sets.precast.default, {
    main = { name = 'Serenity', augments = { 'MP+35', 'Enha.mag. skill +8', '"Cure" spellcasting time -6%' } },
  })
  sets.precast.spells['Utsusemi: Ichi'] = set_combine(sets.precast.default, {
    neck = 'Magoraga Beads',
  })
  sets.precast.spells['Utsusemi: Ni'] = sets.precast.spells['Utsusemi: Ichi']

  sets.midcast = {}
  sets.midcast.enfeebles = {}
  sets.midcast['Elemental Magic'] = {
    main = 'Marin Staff +1',
    sub = "Elder's Grip +1",
    ammo = 'Ghastly Tathlum +1',
    head = 'Leth. Chappel +2',
    body = 'Lethargy Sayon +2',
    hands = 'Leth. Ganth. +2',
    legs = 'Leth. Fuseau +2',
    feet = 'Leth. Houseaux +2',
    neck = 'Sanctity Necklace',
    waist = 'Witful Belt',
    left_ear = 'Friomisi Earring',
    right_ear = 'Novio Earring',
    left_ring = 'Metamor. Ring +1',
    right_ring = 'Jhakri Ring',
    back = {
      name = "Sucellos's Cape",
      augments = { 'MND+20', 'Mag. Acc+20 /Mag. Dmg.+20', 'Mag. Acc.+10', '"Fast Cast"+10' },
    },
  }
  sets.midcast.magic_burst = set_combine(sets.midcast['Elemental Magic'], {
    head = 'Ea Hat',
    feet = 'Jhakri Pigaches +2',
  })
  -- ###############################################################

  -- ###############################################################
  sets.midcast['Dark Magic'] = {
    ammo = 'Ghastly Tathlum +1',
    head = 'Atrophy Chapeau +3',
    body = 'Jhakri Robe +2',
    hands = 'Jhakri Cuffs +2',
    legs = 'Jhakri Slops +2',
    feet = 'Jhakri Pigaches +2',
    neck = 'Sanctity Necklace',
    waist = 'Witful Belt',
    left_ear = "Hecate's Earring",
    right_ear = 'Moldavite Earring',
    left_ring = 'Metamor. Ring +1',
    right_ring = 'Kishar Ring',
    back = {
      name = "Sucellos's Cape",
      augments = { 'MND+20', 'Mag. Acc+20 /Mag. Dmg.+20', 'Mag. Acc.+10', '"Fast Cast"+10' },
    },
  }
  sets.midcast['Aspir'] = set_combine(sets.midcast['Dark Magic'], {
    left_ring = 'Excelsis Ring',
  })
  sets.midcast['Drain'] = sets.midcast['Aspir']
  -- ###############################################################

  -- ###############################################################
  sets.midcast['Enfeebling Magic'] = {
    ammo = 'Kalboron Stone',
    head = 'Viti. Chapeau +1',
    body = 'Lethargy Sayon +2',
    hands = 'Leth. Gantherots +2',
    legs = 'Jhakri Slops +2',
    feet = 'Vitiation Boots +1',
    neck = { name = 'Dls. Torque +1', augments = { 'Path: A' } },
    waist = 'Witful Belt',
    left_ear = "Hecate's Earring",
    right_ear = 'Snotra Earring',
    left_ring = 'Kishar Ring',
    right_ring = 'Metamor. Ring +1',
    back = {
      name = "Sucellos's Cape",
      augments = { 'MND+20', 'Mag. Acc+20 /Mag. Dmg.+20', 'Mag. Acc.+10', '"Fast Cast"+10' },
    },
  }
  sets.midcast.enfeebles.macc = {
    ammo = 'Kalboron Stone',
    head = 'Viti. Chapeau +1',
    body = 'Atrophy Tabard +3',
    hands = 'Leth. Ganth. +2',
    legs = 'Leth. Fuseau +2',
    feet = 'Vitiation Boots +1',
    neck = { name = 'Dls. Torque +1', augments = { 'Path: A' } },
    waist = 'Rumination Sash',
    left_ear = 'Snotra Earring',
    right_ear = {
      name = 'Lethargy Earring',
      augments = { 'System: 1 ID: 1676 Val: 0', 'Accuracy+7', 'Mag. Acc.+7' },
    },
    left_ring = 'Kishar Ring',
    right_ring = 'Metamor. Ring +1',
    back = {
      name = "Sucellos's Cape",
      augments = { 'MND+20', 'Mag. Acc+20 /Mag. Dmg.+20', 'Mag. Acc.+10', '"Fast Cast"+10' },
    },
  }
  sets.midcast.enfeebles.skill = {
    ammo = 'Kalboron Stone',
    head = 'Viti. Chapeau +1',
    body = 'Atrophy Tabard +3',
    hands = 'Leth. Ganth. +2',
    legs = 'Jhakri Slops +2',
    feet = 'Vitiation Boots +1',
    neck = { name = 'Dls. Torque +1', augments = { 'Path: A' } },
    waist = 'Rumination Sash',
    left_ear = "Hecate's Earring",
    right_ear = 'Snotra Earring',
    left_ring = 'Kishar Ring',
    right_ring = 'Metamor. Ring +1',
    back = {
      name = "Sucellos's Cape",
      augments = { 'MND+20', 'Mag. Acc+20 /Mag. Dmg.+20', 'Mag. Acc.+10', '"Fast Cast"+10' },
    },
  }
  sets.midcast.enfeebles.macc_dur = {
    ammo = 'Kalboron Stone',
    head = 'Viti. Chapeau +1',
    body = 'Lethargy Sayon +2',
    hands = 'Leth. Ganth. +2',
    legs = 'Leth. Fuseau +2',
    feet = 'Vitiation Boots +1',
    neck = { name = 'Dls. Torque +1', augments = { 'Path: A' } },
    waist = 'Rumination Sash',
    left_ear = "Hecate's Earring",
    right_ear = 'Snotra Earring',
    left_ring = 'Kishar Ring',
    right_ring = 'Metamor. Ring +1',
    back = {
      name = "Sucellos's Cape",
      augments = { 'MND+20', 'Mag. Acc+20 /Mag. Dmg.+20', 'Mag. Acc.+10', '"Fast Cast"+10' },
    },
  }
  sets.midcast.enfeebles.macc_pot = {
    ammo = 'Kalboron Stone',
    head = 'Viti. Chapeau +2',
    body = 'Lethargy Sayon +2',
    hands = 'Leth. Ganth. +2',
    legs = 'Leth. Fuseau +2',
    feet = 'Vitiation Boots +1',
    neck = { name = 'Dls. Torque +1', augments = { 'Path: A' } },
    waist = 'Rumination Sash',
    left_ear = 'Snotra Earring',
    right_ear = {
      name = 'Lethargy Earring',
      augments = { 'System: 1 ID: 1676 Val: 0', 'Accuracy+7', 'Mag. Acc.+7' },
    },
    left_ring = 'Kishar Ring',
    right_ring = 'Metamor. Ring +1',
    back = {
      name = "Sucellos's Cape",
      augments = { 'MND+20', 'Mag. Acc+20 /Mag. Dmg.+20', 'Mag. Acc.+10', '"Fast Cast"+10' },
    },
  }
  sets.midcast['Dispel'] = sets.midcast.enfeebles.macc
  sets.midcast['Distract III'] = sets.midcast.enfeebles.skill
  sets.midcast['Frazzle III'] = sets.midcast.enfeebles.skill
  sets.midcast['Poison'] = sets.midcast.enfeebles.skill
  sets.midcast['Poison II'] = sets.midcast.enfeebles.skill
  sets.midcast['Sleep'] = sets.midcast.enfeebles.macc_dur
  sets.midcast['Sleep II'] = sets.midcast.enfeebles.macc_dur
  sets.midcast['Sleepga'] = sets.midcast.enfeebles.macc_dur
  sets.midcast['Bind'] = sets.midcast.enfeebles.macc_dur
  sets.midcast['Break'] = sets.midcast.enfeebles.macc_dur
  sets.midcast['Silence'] = sets.midcast.enfeebles.macc_dur
  sets.midcast['Gravity'] = sets.midcast.enfeebles.macc_pot
  sets.midcast['Gravity II'] = sets.midcast.enfeebles.macc_pot
  -- ###############################################################

  -- ###############################################################
  sets.midcast['Healing Magic'] = {
    main = { name = 'Serenity', augments = { 'MP+35', 'Enha.mag. skill +8', '"Cure" spellcasting time -6%' } },
    ammo = 'Kalboron Stone',
    head = 'Jhakri Coronal +2',
    body = 'Viti. Tabard +2',
    hands = 'Atrophy Gloves +3',
    legs = 'Atrophy Tights +3',
    feet = 'Leth. Houseaux +1',
    neck = 'Sanctity Necklace',
    waist = 'Witful Belt',
    left_ear = 'Mache Earring',
    right_ear = 'Brutal Earring',
    left_ring = 'Metamor. Ring +1',
    right_ring = 'Kishar Ring',
    back = {
      name = "Sucellos's Cape",
      augments = { 'MND+20', 'Mag. Acc+20 /Mag. Dmg.+20', 'Mag. Acc.+10', '"Fast Cast"+10' },
    },
  }

  sets.midcast['Enhancing Magic'] = {
    ammo = 'Kalboron Stone',
    head = 'Jhakri Coronal +2',
    body = 'Viti. Tabard +2',
    hands = 'Atrophy Gloves +3',
    legs = 'Atrophy Tights +3',
    feet = 'Leth. Houseaux +2',
    neck = { name = 'Dls. Torque +1', augments = { 'Path: A' } },
    waist = 'Embla Sash',
    left_ear = "Hecate's Earring",
    right_ear = {
      name = 'Lethargy Earring',
      augments = { 'System: 1 ID: 1676 Val: 0', 'Accuracy+7', 'Mag. Acc.+7' },
    },
    left_ring = 'Metamor. Ring +1',
    right_ring = 'Kishar Ring',
    back = {
      name = "Sucellos's Cape",
      augments = { 'MND+20', 'Mag. Acc+20 /Mag. Dmg.+20', 'Mag. Acc.+10', '"Fast Cast"+10' },
    },
  }
  sets.midcast['Composure'] = {
    head = 'Leth. Chappel +2',
    body = 'Lethargy Sayon +2',
    hands = 'Leth. Ganth. +2',
    legs = 'Leth. Fuseau +2',
    feet = 'Leth. Houseaux +2',
  }
  sets.midcast.EnhancingDuration = {
    self = {
      ammo = 'Kalboron Stone',
      head = 'Atrophy Chapeau +3',
      body = 'Viti. Tabard +2',
      hands = 'Atrophy Gloves +3',
      legs = 'Atrophy Tights +3',
      feet = 'Leth. Houseaux +2',
      neck = { name = 'Dls. Torque +1', augments = { 'Path: A' } },
      waist = 'Embla Sash',
      left_ear = 'Halasz Earring',
      right_ear = {
        name = 'Lethargy Earring',
        augments = {
          'System: 1 ID: 1676 Val: 0',
          'Accuracy+7',
          'Mag. Acc.+7',
        },
      },
      left_ring = 'Metamor. Ring +1',
      right_ring = 'Kishar Ring',
      back = {
        name = "Sucellos's Cape",
        augments = { 'MND+20', 'Mag. Acc+20 /Mag. Dmg.+20', 'Mag. Acc.+10', '"Fast Cast"+10' },
      },
    },
    other = {
      ammo = 'Kalboron Stone',
      head = 'Leth. Chappel +2',
      body = 'Lethargy Sayon +2',
      hands = 'Atrophy Gloves +3',
      legs = 'Leth. Fuseau +2',
      feet = 'Leth. Houseaux +2',
      neck = { name = 'Dls. Torque +1', augments = { 'Path: A' } },
      waist = 'Embla Sash',
      left_ear = 'Halasz Earring',
      right_ear = {
        name = 'Lethargy Earring',
        augments = {
          'System: 1 ID: 1676 Val: 0',
          'Accuracy+7',
          'Mag. Acc.+7',
        },
      },
      left_ring = 'Metamor. Ring +1',
      right_ring = 'Kishar Ring',
      back = {
        name = "Sucellos's Cape",
        augments = { 'MND+20', 'Mag. Acc+20 /Mag. Dmg.+20', 'Mag. Acc.+10', '"Fast Cast"+10' },
      },
    },
  }
  sets.midcast['Haste'] = sets.midcast.EnhancingDuration
  sets.midcast['Haste II'] = sets.midcast.EnhancingDuration
  sets.midcast.barspells = set_combine(sets.midcast['Enhancing Magic'], {
    legs = 'Shedir Seraweels',
  })
  sets.midcast['Stoneskin'] = sets.midcast.barspells
  sets.midcast['Aquaveil'] = sets.midcast.barspells

  sets.midcast['Savage Blade'] = {
    ammo = 'Ginsen',
    head = 'Viti. Chapeau +2',
    body = 'Nyame Mail',
    hands = 'Atrophy Gloves +3',
    legs = 'Nyame Flanchard',
    feet = 'Leth. Houseaux +2',
    neck = 'Lissome Necklace',
    waist = 'Sailfi Belt +1',
    left_ear = 'Brutal Earring',
    right_ear = 'Moonshade Earring',
    left_ring = 'Petrov Ring',
    right_ring = 'Karieyh Ring',
    back = {
      name = "Sucellos's Cape",
      augments = {
        'STR+20',
        'Accuracy+20 Attack+20',
        'STR+5',
        'Weapon skill damage +10%',
      },
    },
  }
  sets.midcast['Requiescat'] = {
    ammo = 'Ginsen',
    head = 'Jhakri Coronal +2',
    body = 'Jhakri Robe +2',
    hands = 'Atrophy Gloves +3',
    legs = 'Jhakri Slops +2',
    feet = 'Jhakri Pigaches +2',
    neck = 'Fotia Gorget',
    waist = 'Fotia Belt',
    left_ear = 'Moonshade Earring',
    right_ear = 'Brutal Earring',
    left_ring = 'Hetairoi Ring',
    right_ring = 'Karieyh Ring',
    back = {
      name = "Sucellos's Cape",
      augments = {
        'MND+20',
        'Mag. Acc+20 /Mag. Dmg.+20',
        'Mag. Acc.+10',
        '"Fast Cast"+10',
      },
    },
  }
  sets.midcast['Chant du Cygne'] = {
    ammo = 'Ginsen',
    head = 'Atrophy Chapeau +3',
    body = 'Ayanmo Corazza +2',
    hands = 'Atrophy Gloves +3',
    legs = 'Aya. Cosciales +2',
    feet = 'Leth. Houseaux +2',
    neck = 'Fotia Gorget',
    waist = 'Fotia Belt',
    left_ear = 'Moonshade Earring',
    right_ear = 'Mache Earring',
    left_ring = 'Petrov Ring',
    right_ring = 'Karieyh Ring',
    back = {
      name = "Sucellos's Cape",
      augments = { 'DEX+20', 'Accuracy+20 Attack+20', 'Accuracy+10', '"Dbl.Atk."+10', 'Damage taken-5%' },
    },
  }

  sets.obis = {}
  sets.obis.Fire = { waist = 'Hachirin-no-Obi' }
  sets.obis.Earth = { waist = 'Hachirin-no-Obi' }
  sets.obis.Water = { waist = 'Hachirin-no-Obi' }
  sets.obis.Wind = { waist = 'Hachirin-no-Obi' }
  sets.obis.Ice = { waist = 'Hachirin-no-Obi' }
  sets.obis.Lightning = { waist = 'Hachirin-no-Obi' }
  sets.obis.Light = { waist = 'Hachirin-no-Obi' }
  sets.obis.Dark = { waist = 'Hachirin-no-Obi' }

  lockstyleset = 6

  macro_book = 5
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

  -- just add refresh gear here
  if string.match(spell.name, '^Refresh') and spell.target.name == player.name then
    equip({ waist = 'Gishdubar Sash' })
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
