local res = require('resources')

local last_skillchain_id = 0
local last_skillchain_time = 0
local last_skillchain_elements = {}

local skillchains = {
  [288] = { id = 288, english = 'Light', elements = { 'Light', 'Lightning', 'Wind', 'Fire' } },
  [289] = { id = 289, english = 'Darkness', elements = { 'Dark', 'Ice', 'Water', 'Earth' } },
  [290] = { id = 290, english = 'Gravitation', elements = { 'Dark', 'Earth' } },
  [291] = { id = 291, english = 'Fragmentation', elements = { 'Lightning', 'Wind' } },
  [292] = { id = 292, english = 'Distortion', elements = { 'Ice', 'Water' } },
  [293] = { id = 293, english = 'Fusion', elements = { 'Light', 'Fire' } },
  [294] = { id = 294, english = 'Compression', elements = { 'Dark' } },
  [295] = { id = 295, english = 'Liquefaction', elements = { 'Fire' } },
  [296] = { id = 296, english = 'Induration', elements = { 'Ice' } },
  [297] = { id = 297, english = 'Reverberation', elements = { 'Water' } },
  [298] = { id = 298, english = 'Transfixion', elements = { 'Light' } },
  [299] = { id = 299, english = 'Scission', elements = { 'Earth' } },
  [300] = { id = 300, english = 'Detonation', elements = { 'Wind' } },
  [301] = { id = 301, english = 'Impaction', elements = { 'Lightning' } },
  [385] = { id = 385, english = 'Light', elements = { 'Light', 'Lightning', 'Wind', 'Fire' } },
  [386] = { id = 386, english = 'Darkness', elements = { 'Dark', 'Ice', 'Water', 'Earth' } },
  [387] = { id = 387, english = 'Gravitation', elements = { 'Dark', 'Earth' } },
  [388] = { id = 388, english = 'Fragmentation', elements = { 'Lightning', 'Wind' } },
  [389] = { id = 389, english = 'Distortion', elements = { 'Ice', 'Water' } },
  [390] = { id = 390, english = 'Fusion', elements = { 'Light', 'Fire' } },
  [391] = { id = 391, english = 'Compression', elements = { 'Dark' } },
  [392] = { id = 392, english = 'Liquefaction', elements = { 'Fire' } },
  [393] = { id = 393, english = 'Induration', elements = { 'Ice' } },
  [394] = { id = 394, english = 'Reverberation', elements = { 'Water' } },
  [395] = { id = 395, english = 'Transfixion', elements = { 'Light' } },
  [396] = { id = 396, english = 'Scission', elements = { 'Earth' } },
  [397] = { id = 397, english = 'Detonation', elements = { 'Wind' } },
  [398] = { id = 398, english = 'Impaction', elements = { 'Lightning' } },
  [767] = { id = 767, english = 'Radiance', elements = { 'Light', 'Lightning', 'Wind', 'Fire' } },
  [768] = { id = 768, english = 'Umbra', elements = { 'Dark', 'Ice', 'Water', 'Earth' } },
  [769] = { id = 769, english = 'Radiance', elements = { 'Light', 'Lightning', 'Wind', 'Fire' } },
  [770] = { id = 770, english = 'Umbra', elements = { 'Dark', 'Ice', 'Water', 'Earth' } },
}

function run_burst(data)
  local action = data.targets[1].actions[1]
  if
    (action.add_effect_message > 287 and action.add_effect_message < 302) -- Normal SC DMG
    or (action.add_effect_message > 384 and action.add_effect_message < 399) -- SC Heals
    or (action.add_effect_message > 766 and action.add_effect_message < 771) -- Umbra/Radiance
  then
    local t = windower.ffxi.get_mob_by_id(data.targets[1].id)
    -- valid party target and within range
    if t and t.spawn_type == 16 and t.distance:sqrt() < 21 then
      -- Update the enemy to track
      last_skillchain_id = t.id
      last_skillchain_time = os.clock()
      last_skillchain_elements = {}
      -- get the type of skillchain
      local skillchain = skillchains[action.add_effect_message]
      -- Find the elements
      for index, element in pairs(skillchain.elements) do
        last_skillchain_elements[element] = element
      end
    end
    -- This is used to stop bursting if a ws happened to close the window
  elseif data.category == 3 and data.param ~= 0 then
    local t = windower.ffxi.get_mob_by_id(data.targets[1].id)
    if t and t.id == last_skillchain_id then
      last_skillchain_elements = {}
      last_skillchain_id = 0
      last_skillchain_time = 0
    end
  end
end

windower.register_event('action', function(data)
  if data ~= nil then
    if data.category == 3 and data.param ~= 0 then
      run_burst(data)
      -- Casting finish
    elseif data.category == 4 then
      run_burst(data)
    end
  end
end)

return function(spell)
  local element = res.spells[spell.id].element
  local element_name = res.elements[element].en
  if
    spell.target.id == last_skillchain_id
    and os.clock() - last_skillchain_time < 8
    and last_skillchain_elements[element_name]
  then
    return true
  else
    return false
  end
end
