include('Modes')

local lockstyleset = nil
local macro_book = nil
local macro_page = nil

local jp_mode = false

local bindings = {
  ['^#'] = 'gs c echodrops',
  ['^R'] = 'gs c toggle_speed',
  ['^F4'] = 'gs c cycle_shield',
  ['^F3'] = 'gs c cycle_weapon',
  ['^F2'] = 'gs c cycle_tp',
  ['^F1'] = 'gs c cycle_idle',
}

local idle_mode = M({ ['description'] = 'What mode to idle in', 'dt' })
local tp_mode = M({ ['description'] = 'What mode to tp in', 'dt' })
local weapon = M({
  ['description'] = 'What weapon to use',
  'Ichigo',
  'Shining One',
  'Unlocked',
})
local run = M(false, 'If should equip movement gear')

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

local function equip_idle()
  equip(sets.weapons[weapon.current], sets.idle[idle_mode.current])
  if run.value then
    equip(sets.idle.speed)
  end
end

local function equip_tp()
  equip(sets.weapons[weapon.current], sets.tp[tp_mode.current])
end

local function refresh()
  if player.status == 'Engaged' then
    equip_tp()
  elseif player.status == 'Idle' then
    equip_idle()
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
  sets.weapons = {
    ['Ichigo'] = {
      main = { name = 'Ichigohitofuri', augments = { 'DMG:+30', 'STR+20', 'Accuracy+15' } },
    },
    ['Shining One'] = { main = 'Shining One' },
    ['Unlocked'] = { main = '' },
  }

  sets.idle = {}
  sets.idle.dt = {
    ammo = 'Coiste Bodhar',
    head = 'Flam. Zucchetto +2',
    body = 'Flamma Korazin +2',
    hands = 'Flam. Manopolas +2',
    legs = 'Tatena. Haidate +1',
    feet = 'Flam. Gambieras +2',
    neck = 'Loricate Torque',
    waist = 'Ioskeha Belt',
    left_ear = 'Alabaster Earring',
    right_ear = 'Mache Earring',
    left_ring = 'Petrov Ring',
    right_ring = 'Defending Ring',
    back = { name = 'Mecisto. Mantle', augments = { 'Cap. Point+49%', 'MND+1', 'Rng.Acc.+5', 'DEF+6' } },
  }

  sets.idle.speed = {}

  sets.tp = {}
  sets.tp.dt = {
    ammo = 'Coiste Bodhar',
    head = 'Flam. Zucchetto +2',
    body = 'Flamma Korazin +2',
    hands = 'Flam. Manopolas +2',
    legs = 'Tatena. Haidate +1',
    feet = 'Flam. Gambieras +2',
    neck = 'Moonbeam Nodowa',
    waist = 'Ioskeha Belt',
    left_ear = 'Alabaster Earring',
    right_ear = 'Mache Earring',
    left_ring = 'Petrov Ring',
    right_ring = 'Flamma Ring',
    back = { name = 'Mecisto. Mantle', augments = { 'Cap. Point+49%', 'MND+1', 'Rng.Acc.+5', 'DEF+6' } },
  }

  sets.precast = {}
  sets.precast.default = {}

  sets.midcast = {}

  sets.midcast['Meditate'] = {
    head = 'Wakido Kabuto',
  }

  -- ###############################################################

  sets.ws = set_combine(sets.tp.dt, {
    head = 'Nyame Helm',
    legs = 'Nyame Flanchard',
    left_ear = 'Thrud Earring',
    right_ear = 'Moonshade Earring',
  })

  -- ###############################################################

  lockstyleset = 2

  macro_book = 18
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
  if string.match(spell.type, 'Magic$') then
    equip(sets.precast.default)
  end
  set_priorities('hp', 'mp')
end

function midcast(spell)
  if spell.skill == 'Enhancing Magic' then
    if spell.name == 'Phalanx' then
      equip(sets.midcast['Phalanx'])
    end
  elseif sets.midcast[spell.name] then
    equip(sets.midcast[spell.name])
  elseif sets.midcast[spell.skill] then
    equip(sets.midcast[spell.skill])
  elseif spell.type == 'JobAbility' then
  elseif spell.type == 'WeaponSkill' then
    equip(sets.ws)
  end

  -- just add refresh gear here
  if string.match(spell.name, '^Refresh') and spell.target.name == player.name then
    equip({ waist = 'Gishdubar Sash' })
  end
  set_priorities('hp', 'mp')
end

function aftercast()
  refresh()
  set_priorities('hp', 'mp')
end

function status_change(new)
  refresh()
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
    run:cycle()
    send_command('@input /echo SPEED ' .. run.current)
    refresh()
  elseif command == 'cycle_idle' then
    idle_mode:cycle()
    send_command('@input /echo Idle Mode: ' .. idle_mode.current)
    refresh()
  elseif command == 'cycle_tp' then
    tp_mode:cycle()
    send_command('@input /echo TP Mode: ' .. tp_mode.current)
    refresh()
  elseif command == 'cycle_weapon' then
    weapon:cycle()
    send_command('@input /echo Weapon: ' .. weapon.current)
    refresh()
  end
end

send_command('wait 1; gs equip idle')
