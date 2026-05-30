--Yavanna

-- Load and initialize the include file.
include('Mirdain-Include')

--Set to ingame lockstyle and Macro Book/Set
LockStylePallet = '13'
MacroBook = '19'
MacroSet = '1'

--Uses Items Automatically
AutoItem = false

--Upon Job change will use a random lockstyleset
Random_Lockstyle = false

--Lockstyle sets to randomly equip
Lockstyle_List = {}

-- Use "gs c food" to use the specified food item
Food = 'Tropical Crepe'

--Set default mode (TP,ACC,DT)
state.OffenseMode:options('TP', 'ACC', 'DT', 'PDT', 'MEVA')
state.OffenseMode:set('DT')

--Command to Lock Style and Set the correct macros
jobsetup(LockStylePallet, MacroBook, MacroSet)

--Weapon Modes
state.WeaponMode:options('Unlocked', 'Locked')
state.WeaponMode:set('Unlocked')

function get_sets()
  --Set the weapon options.  This is set below in job customization section
  sets.Weapons = {}

  -- sets.Weapons['Musa'] = {
  --   main = { name = 'Musa', augments = { 'Path: C' } },
  --   sub = 'Enki Strap',
  -- }

  -- sets.Weapons['Mpaca'] = {
  --   main = { name = "Mpaca's Staff", augments = { 'Path: A' } },
  --   sub = 'Enki Strap',
  -- }

  sets.Weapons['Unlocked'] = {
    -- main = { name = 'Musa', augments = { 'Path: C' } },
    -- sub = 'Enki Strap',
  }

  sets.Weapons.Shield = {
    -- main = 'Daybreak',
    -- sub = 'Genmei Shield',
  }

  sets.Weapons.Sleep = {
    -- main = 'Opashoro',
  }

  -- Standard idle set
  sets.Idle = { -- HP:2151 MP:1493
    main = 'Marin Staff +1',
    sub = "Elder's Grip +1",
    ammo = 'Staunch Tathlum',
    head = 'Jhakri Coronal +2',
    body = 'Mallquis Saio +1',
    hands = 'Jhakri Cuffs +2',
    legs = 'Jhakri Slops +2',
    feet = "Herald's Gaiters",
    neck = 'Loricate Torque',
    waist = 'Embla Sash',
    left_ear = 'Friomisi Earring',
    right_ear = 'Alabaster Earring',
    left_ring = 'Gelatinous Ring +1',
    right_ring = 'Defending Ring',
    back = { name = 'Mecisto. Mantle', augments = { 'Cap. Point+49%', 'MND+1', 'Rng.Acc.+5', 'DEF+6' } },
  } -- 57 PDT / 58 MDT

  -- 'TP','PDL','ACC','DT','PDT','MEVA'
  sets.Idle.TP = set_combine(sets.Idle, {})
  sets.Idle.ACC = set_combine(sets.Idle, {})
  sets.Idle.DT = set_combine(sets.Idle, {})
  sets.Idle.PDT = set_combine(sets.Idle, {})
  sets.Idle.Resting = set_combine(sets.Idle, {})
  sets.Idle.MEVA = set_combine(sets.Idle, {
    -- neck = "Warder's Charm +1",
    -- waist = "Carrier's Sash",
  })

  -- Set is only applied when sublimation is charging
  sets.Idle.Sublimation = set_combine(sets.Idle, {
    head = 'Acad. Mortar. +1', -- +2 Submlimation when active
    right_ring = 'Defending Ring',
    waist = 'Embla Sash', -- +3 Submlimation when active
  })

  -- Set to swap into when player is moving
  sets.Movement = {
    feet = "Herald's Gaiters",
  }

  -- Set to be used if you get
  sets.Cursna_Received = {
    -- neck = "Nicander's Necklace",
    -- left_ring = { name = "Eshmun's Ring", bag = 'wardrobe1', priority = 2 },
    -- right_ring = { name = "Eshmun's Ring", bag = 'wardrobe2', priority = 1 },
    waist = 'Gishdubar Sash',
  }

  -- Sets are used for when player is engaged
  sets.OffenseMode = {
    main = 'Marin Staff +1',
    sub = 'Umbra Strap',
    ammo = 'Staunch Tathlum',
    head = 'Jhakri Coronal +2',
    body = 'Mallquis Saio +1',
    hands = 'Jhakri Cuffs +2',
    legs = 'Jhakri Slops +2',
    feet = 'Jhakri Pigaches +2',
    neck = 'Loricate Torque',
    waist = 'Embla Sash',
    left_ear = 'Friomisi Earring',
    right_ear = 'Alabaster Earring',
    left_ring = 'Gelatinous Ring +1',
    right_ring = 'Defending Ring',
    back = { name = 'Mecisto. Mantle', augments = { 'Cap. Point+49%', 'MND+1', 'Rng.Acc.+5', 'DEF+6' } },
  }

  sets.OffenseMode.TP = set_combine(sets.OffenseMode, {})
  sets.OffenseMode.DT = set_combine(sets.OffenseMode, {})
  sets.OffenseMode.ACC = set_combine(sets.OffenseMode, {})
  sets.OffenseMode.PDT = set_combine(sets.OffenseMode, {})
  sets.OffenseMode.MEVA = set_combine(sets.OffenseMode, {})

  -- Set to use when Dual Wielding
  sets.DualWield = {}

  -- Set to use when casting spells (sent with Mid-Cast packet - only concern is HP/MP and Fastcast)
  sets.Precast = {}

  sets.Precast.FastCast = {
    ammo = 'Staunch Tathlum',
    head = 'Jhakri Coronal +2',
    body = 'Jhakri Robe +2',
    hands = 'Gende. Gages +1',
    legs = 'Gyve Trousers',
    feet = 'Jhakri Pigaches +2',
    neck = 'Voltsurge Torque',
    waist = 'Embla Sash',
    left_ear = 'Friomisi Earring',
    right_ear = 'Loquac. Earring',
    left_ring = 'Kishar Ring',
    right_ring = 'Defending Ring',
    back = { name = 'Mecisto. Mantle', augments = { 'Cap. Point+49%', 'MND+1', 'Rng.Acc.+5', 'DEF+6' } },
  } -- 80 Fastcast, and 25% Grimoire all in one

  sets.Precast.Enhancing = set_combine(sets.Precast.FastCast, {})

  sets.Precast.Cure = set_combine(sets.Precast.FastCast, {
    head = { name = 'Kaykaus Mitra', augments = { 'MP+60', '"Cure" spellcasting time -5%', 'Enmity-5' } },
  })

  sets.Precast.Healing = set_combine(sets.Precast.FastCast, {})

  -- Swaps for Grimoire Fast Cast (Should be over 80% FC)
  sets.Precast.Grimoire = {}

  -- Job Abilities
  sets.JA = {}
  sets.JA['Light Arts'] = {}
  sets.JA['Penury'] = {}
  sets.JA['Celerity'] = {}
  sets.JA['Rapture'] = {}
  sets.JA['Accession'] = {}
  sets.JA['Perpetuance'] = {}
  sets.JA['Addendum: White'] = {}

  sets.JA['Dark Arts'] = {}
  sets.JA['Parsimony'] = {}
  sets.JA['Alacrity'] = {}
  sets.JA['Ebullience'] = {}
  sets.JA['Manifestation'] = {}
  sets.JA['Focalization'] = {}
  sets.JA['Immanence'] = {}
  sets.JA['Addendum: White'] = {}

  sets.JA['Sublimation'] = {}
  -- sets.JA['Tabula Rasa'] = { legs = { name = 'Peda. Pants +3', augments = { 'Enhances "Tabula Rasa" effect' } } }
  sets.JA['Tabula Rasa'] = {}
  sets.JA['Modus Veritas'] = {}
  sets.JA['Libra'] = {}
  sets.JA['Caper Emissarius'] = {}

  sets.JA['Convert'] = {}

  -- ===================================================================================================================
  --		sets.midcast
  -- ===================================================================================================================

  --Base set for midcast - if not defined will notify and use your idle set for surviability
  sets.Midcast = set_combine(sets.Idle, {})

  -- Cure Set
  sets.Midcast.Cure = {
    main = { name = 'Serenity', augments = { 'MP+35', 'Enha.mag. skill +8', '"Cure" spellcasting time -6%' } },
    ammo = 'Kalboron Stone',
    head = { name = 'Kaykaus Mitra', augments = { 'MP+60', '"Cure" spellcasting time -5%', 'Enmity-5' } },
    body = 'Jhakri Robe +2',
    hands = 'Jhakri Cuffs +2',
    legs = 'Gyve Trousers',
    feet = 'Jhakri Pigaches +2',
    neck = 'Loricate Torque',
    waist = 'Hachirin-no-Obi',
    left_ear = 'Friomisi Earring',
    right_ear = 'Novio Earring',
    left_ring = "Naji's Loop",
    right_ring = 'Metamorph Ring +1',
    back = { name = 'Mecisto. Mantle', augments = { 'Cap. Point+49%', 'MND+1', 'Rng.Acc.+5', 'DEF+6' } },
  }

  -- Cursna Gear
  sets.Midcast.Cursna = set_combine(sets.Midcast.Cure, {
    -- body = { name = 'Peda. Gown +3', augments = { 'Enhances "Enlightenment" effect' } },
    -- legs = 'Acad. Pants +3',
    -- feet = 'Gende. Galosh. +1',
    -- neck = 'Debilis Medallion',
    -- left_ring = "Menelaus's Ring",
    -- right_ring = "Haoma's Ring",
  })

  -- Enhancing Skill
  sets.Midcast.Enhancing = {
    ammo = 'Kalboron Stone',
    head = 'Jhakri Coronal +2',
    body = 'Jhakri Robe +2',
    hands = 'Jhakri Cuffs +2',
    legs = 'Jhakri Slops +2',
    feet = 'Jhakri Pigaches +2',
    neck = 'Loricate Torque',
    waist = 'Embla Sash',
    left_ear = 'Friomisi Earring',
    right_ear = 'Novio Earring',
    left_ring = 'Kishar Ring',
    right_ring = 'Metamor. Ring +1',
    back = { name = 'Mecisto. Mantle', augments = { 'Cap. Point+49%', 'MND+1', 'Rng.Acc.+5', 'DEF+6' } },
  }

  -- Spells that require SKILL
  sets.Midcast.Enhancing.Skill = set_combine(sets.Midcast.Enhancing, {})

  sets.Midcast.Enhancing.Others = set_combine(sets.Midcast.Enhancing, {})

  --Used for elemental Bar Magic Spells
  sets.Midcast.Enhancing.Elemental = set_combine(sets.Midcast.Enhancing, {})

  sets.Midcast.Phalanx = set_combine(sets.Midcast.Enhancing, {})

  sets.Midcast.Regen = set_combine(sets.Midcast.Enhancing, {
    -- body = { name = 'Telchine Chas.', augments = { '"Regen"+2', 'Enh. Mag. eff. dur. +10' } },
    -- back = { name = "Bookworm's Cape", augments = { 'INT+1', 'MND+2', 'Helix eff. dur. +10', '"Regen" potency+10' } },
    head = 'Arbatel Bonnet +1',
  })

  sets.Midcast.Refresh = set_combine(sets.Midcast.Enhancing, {})

  -- High MACC for landing spells
  sets.Midcast.Enfeebling = {
    ammo = 'Kalboron Stone',
    head = 'Jhakri Coronal +2',
    body = 'Jhakri Robe +2',
    hands = 'Jhakri Cuffs +2',
    legs = 'Jhakri Slops +2',
    feet = 'Jhakri Pigaches +2',
    neck = 'Loricate Torque',
    waist = 'Hachirin-no-Obi',
    left_ear = 'Friomisi Earring',
    right_ear = 'Novio Earring',
    left_ring = 'Kishar Ring',
    right_ring = 'Metamor. Ring +1',
    back = { name = 'Mecisto. Mantle', augments = { 'Cap. Point+49%', 'MND+1', 'Rng.Acc.+5', 'DEF+6' } },
  }

  sets.Midcast.Enfeebling.MACC = set_combine(sets.Midcast.Enfeebling, {})
  sets.Midcast.Enfeebling.Potency = set_combine(sets.Midcast.Enfeebling, {})
  sets.Midcast.Dark = set_combine(sets.Midcast.Enfeebling, {})
  sets.Midcast.Dark.MACC = set_combine(sets.Midcast.Enfeebling.MACC, {})
  sets.Midcast.Dark.Absorb = set_combine(sets.Midcast.Enfeebling, {})

  sets.Midcast['Dispelga'] = set_combine(sets.Midcast.Enfeebling, {
    -- main = 'Daybreak',
    -- sub = 'Ammurapi Shield',
  })

  -- Used for Vagary (6k+ nuke no kill)
  sets.Midcast.Vagary = {
    -- main = 'Chatoyant Staff',
    -- ammo = 'Hasty Pinion +1',
    -- head = { name = 'Vanya Hood', augments = { 'MP+50', '"Fast Cast"+10', 'Haste+2%' } },
    -- body = 'Zendik Robe',
    -- hands = 'Gende. Gages +1',
    -- legs = 'Pinga Pants +1',
    -- feet = { name = 'Merlinic Crackows', augments = { '"Mag.Atk.Bns."+29', '"Fast Cast"+6', 'DEX+7', 'Mag. Acc.+14' } },
    -- neck = { name = 'Unmoving Collar +1', augments = { 'Path: A' } },
    -- waist = 'Embla Sash',
    -- left_ear = { name = 'Odnowa Earring +1', augments = { 'Path: A' } },
    -- right_ear = 'Etiolation Earring',
    -- left_ring = 'Weather. Ring',
    -- right_ring = 'Kishar Ring',
    -- back = {
    --   name = "Lugh's Cape",
    --   augments = { 'HP+60', 'Eva.+20 /Mag. Eva.+20', 'Mag. Evasion+10', '"Fast Cast"+10', 'Damage taken-5%' },
    -- },
  }

  sets.Midcast.Nuke = {
    sub = "Elder's Grip +1",
    ammo = 'Ghastly Tathlum +1',
    head = 'Jhakri Coronal +2',
    body = 'Jhakri Robe +2',
    hands = 'Arbatel Bracers +2',
    legs = 'Jhakri Slops +2',
    feet = 'Arbatel Loafers +2',
    neck = 'Saevus Pendant +1',
    waist = 'Oneiros Sash',
    left_ear = 'Barkaro. Earring',
    right_ear = 'Friomisi Earring',
    left_ring = 'Jhakri Ring',
    right_ring = 'Metamor. Ring +1',
    back = { name = 'Mecisto. Mantle', augments = { 'Cap. Point+49%', 'MND+1', 'Rng.Acc.+5', 'DEF+6' } },
  }

  sets.Midcast.Nuke.Earth = set_combine(sets.Midcast.Nuke, { neck = 'Quanpur Necklace' })

  sets.Midcast.Burst = set_combine(sets.Midcast.Nuke, {})

  sets.Helix = set_combine(sets.Midcast.Nuke, {
    ammo = { name = 'Ghastly Tathlum +1' },
    -- head = { name = "Agwu's Cap", augments = { 'Path: A' } },
    -- body = { name = "Agwu's Robe", augments = { 'Path: A' } },
    -- hands = { name = "Agwu's Gages", augments = { 'Path: A' } },
    -- legs = { name = "Agwu's Slops", augments = { 'Path: A' } },
    feet = 'Arbatel Loafers +2',
    neck = { name = 'Argute Stole +1' },
    -- waist = { name = 'Acuity Belt +1', augments = { 'Path: A' } },
    -- left_ear = 'Regal Earring',
    -- right_ear = 'Malignance Earring',
    -- right_ring = 'Freke Ring',
    right_ring = { name = 'Metamorph Ring +1' },
    -- back = {
    --   name = "Lugh's Cape",
    --   augments = { 'INT+20', 'Mag. Acc+20 /Mag. Dmg.+20', 'INT+10', '"Mag.Atk.Bns."+10', 'Damage taken-5%' },
    -- },
  })

  sets.Helix.Dark = set_combine(sets.Helix, {
    -- head = 'Pixie Hairpin +1',
    -- left_ring = 'Archon Ring',
  })

  sets.Helix.Light = set_combine(sets.Helix, {
    -- main = 'Daybreak',
    -- left_ring = 'Weather. Ring',
  })

  -- Specific gear for spells
  sets.Midcast['Stoneskin'] = set_combine(sets.Midcast.Enhancing, {
    -- ammo = 'Hasty Pinion +1',
    -- head = 'Arbatel Bonnet +3',
    -- body = 'Arbatel Gown +3',
    -- hands = { name = 'Nyame Gauntlets', augments = { 'Path: B' } },
    -- legs = 'Arbatel Pants +3',
    -- feet = { name = 'Nyame Sollerets', augments = { 'Path: B' } },
    waist = 'Siegel Sash',
    left_ring = 'Defending Ring',
    right_ring = { name = 'Gelatinous Ring +1' },
    -- neck = 'Nodens Gorget',
    -- left_ear = 'Earthcry Earring',
  })

  sets.Midcast['Aquaveil'] = set_combine(sets.Midcast.Enhancing, {
    -- head = 'Amalric Coif +1',
  })

  sets.Midcast['Klimaform'] = set_combine(sets.Midcast.Enhancing, {})

  sets.Midcast['Impact'] = set_combine(sets.Midcast.Enfeebling, {
    -- body = 'Crepuscular Cloak',
  })

  sets.Midcast['Embrava'] = set_combine(sets.Midcast.Enhancing, {})

  sets.Midcast['Stun'] = set_combine(sets.Midcast.Enfeebling.MACC, {})

  sets.Perpetuance = { hands = 'Arbatel Bracers +2' }
  sets.Immanence = { hands = 'Arbatel Bracers +2' }
  -- sets.Ebullience = { head = 'Arbatel Bonnet +3' }
  -- sets.Rapture = { head = 'Arbatel Bonnet +3' }
  -- sets.Penury = { legs = 'Arbatel Pants +3' } -- not swapped due to duration
  -- sets.Parsimony = { legs = 'Arbatel Pants +3' }
  -- sets.Storms = { feet = 'Pedagogy Loafers +3' }
  sets.Ebullience = {}
  sets.Rapture = {}
  sets.Penury = {} -- not swapped due to duration
  sets.Parsimony = {}
  sets.Klimaform = { feet = 'Arbatel Loafers +2' }
  sets.Storms = {}

  sets.WS = {
    -- ammo = "Oshasha's Treatise",
    -- head = { name = 'Nyame Helm', augments = { 'Path: B' } },
    -- body = { name = 'Nyame Mail', augments = { 'Path: B' } },
    -- hands = { name = 'Nyame Gauntlets', augments = { 'Path: B' } },
    -- legs = { name = 'Nyame Flanchard', augments = { 'Path: B' } },
    -- feet = { name = 'Nyame Sollerets', augments = { 'Path: B' } },
    -- neck = 'Sanctity Necklace',
    -- waist = 'Eschan Stone',
    -- left_ear = 'Crep. Earring',
    -- right_ear = 'Telos Earring',
    -- left_ring = "Cornelia's Ring",
    -- right_ring = "Epaminondas's Ring",
    -- back = {
    --   name = "Lugh's Cape",
    --   augments = { 'HP+60', 'Eva.+20 /Mag. Eva.+20', 'Mag. Evasion+10', '"Fast Cast"+10', 'Damage taken-5%' },
    -- },
  }

  -- Set used to tag treasure hunger
  sets.TreasureHunter = {
    ammo = 'Per. Lucky Egg',
    -- head = 'Volte Cap',
    -- legs = 'Volte Hose',
    -- waist = 'Chaac Belt',
  }
end

-------------------------------------------------------------------------------------------------------------------
-- DO NOT EDIT BELOW THIS LINE UNLESS YOU NEED TO MAKE JOB SPECIFIC RULES
-------------------------------------------------------------------------------------------------------------------

-- Called when the player's subjob changes.
function sub_job_change_custom(new, old)
  -- Typically used for Macro pallet changing
end

--Adjust custom precast actions
function pretarget_custom(spell, action) end

-- Augment basic equipment sets
function precast_custom(spell)
  local equipSet = {}
  if spell.type == 'WhiteMagic' and (buffactive['Light Arts'] or buffactive['Addendum: White']) then
    log('Grimoire Set (White)')
    equipSet = set_combine(equipSet, sets.Precast.Grimoire)
  elseif spell.type == 'BlackMagic' and (buffactive['Dark Arts'] or buffactive['Addendum: Black']) then
    log('Grimoire Set (Dark)')
    equipSet = set_combine(equipSet, sets.Precast.Grimoire)
  end
  return equipSet
end

-- Augment basic equipment sets
function midcast_custom(spell)
  local equipSet = {}

  if buffactive['Immanence'] then
    log('Immanence Set')
    equipSet = set_combine(equipSet, sets.Immanence)
  end

  if buffactive['Ebullience'] then
    log('Ebullience Set')
    equipSet = set_combine(equipSet, sets.Ebullience)
  end

  if buffactive['Rapture'] then
    log('Rapture Set')
    equipSet = set_combine(equipSet, sets.Rapture)
  end

  -- Skipping Penury due to lack of duration gear (Embrava)
  --[[
	if buffactive["Penury"] then
		log("Penury Set")
		equipSet = sets.Penury
	end
	]]
  --

  if buffactive['Parsimony'] then
    log('Parsimony Set')
    equipSet = set_combine(equipSet, sets.Parsimony)
  end

  if buffactive['Perpetuance'] then
    log('Perpetuance Set')
    equipSet = set_combine(equipSet, sets.Perpetuance)
  end

  return equipSet
end

-- Augment basic equipment sets
function aftercast_custom(spell)
  local equipSet = {}

  return equipSet
end

--Function is called when the player gains or loses a buff
function buff_change_custom(name, gain)
  local equipSet = {}

  return equipSet
end

--This function is called when a update request the correct equipment set
function choose_set_custom()
  local equipSet = {}

  return equipSet
end

--Function is called when the player changes states
function status_change_custom(new, old)
  local equipSet = {}

  return equipSet
end

--Function is called when a self command is issued
function self_command_custom(command) end

-- This function is called when the job file is unloaded
function user_file_unload() end

--Function used to automate Job Ability use - Checked first
function check_buff_JA()
  local buff = 'None'
  return buff
end

--Function used to automate Spell use
function check_buff_SP()
  local buff = 'None'
  return buff
end

function pet_change_custom(pet, gain)
  local equipSet = {}

  return equipSet
end

function pet_aftercast_custom(spell)
  local equipSet = {}

  return equipSet
end

function pet_midcast_custom(spell)
  local equipSet = {}

  return equipSet
end
