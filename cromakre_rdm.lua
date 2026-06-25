-- Load and initialize the include file.
include('Mirdain-Include')

--Set to ingame lockstyle and Macro Book/Set
LockStylePallet = '6'
MacroBook = '5'
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
state.OffenseMode:options('TP', 'ACC', 'DT', 'PDL', 'SB', 'CRIT', 'Enspell')
state.OffenseMode:set('DT')

--Command to Lock Style and Set the correct macros
jobsetup(LockStylePallet, MacroBook, MacroSet)

--Modes for TP
state.WeaponMode:options(
  'Savage Blade',
  'Evisceration',
  'Aeolian Edge',
  'Black Halo',
  'Chant du Cygne',
  'Seraph Blade',
  'Sanguine Blade',
  'Ullr',
  'Unlocked'
)
state.WeaponMode:set('Savage Blade')

-- Goal 2100 hp and 1300 MP
function get_sets()
  -- ===================================================================================================================
  --		sets.Weapons
  -- ===================================================================================================================

  --Set the weapon options.  This is set below in job customization section
  sets.Weapons = {}

  sets.Weapons['Seraph Blade'] = {
    -- main = { name = 'Crocea Mors', augments = { 'Path: C' } },
    -- sub = 'Daybreak',
  }

  sets.Weapons['Sanguine Blade'] = {
    -- main = { name = 'Crocea Mors', augments = { 'Path: C' } },
    -- sub = { name = 'Demers. Degen +1', augments = { 'Path: A' } },
  }

  sets.Weapons['Chant du Cygne'] = {
    -- main = { name = 'Crocea Mors', augments = { 'Path: C' } },
    -- sub = { name = 'Demers. Degen +1', augments = { 'Path: A' } },
  }

  sets.Weapons['Savage Blade'] = {
    main = 'Naegling',
    sub = { name = 'Machaera +2', augments = { 'TP Bonus +1000' } },
  }

  sets.Weapons['Evisceration'] = {
    main = 'Kaja Knife',
    sub = "Gleti's Knife",
  }

  sets.Weapons['Aeolian Edge'] = {
    main = 'Kaja Knife',
    sub = "Gleti's Knife",
  }

  sets.Weapons['Black Halo'] = {
    main = 'Kaja Rod',
    sub = { name = 'Machaera +2', augments = { 'TP Bonus +1000' } },
  }

  sets.Weapons['Ullr'] = {
    -- range="Ullr",
    -- ammo="Beryllium Arrow",
  }

  sets.Weapons['Unlocked'] = {
    -- main={ name="Crocea Mors", augments={'Path: C',}},
    -- sub={ name="Demers. Degen +1", augments={'Path: A',}},
  }

  --Shield used when melee and not dual wield.
  sets.Weapons.Shield = {
    sub = "Genbu's Shield",
    -- sub="Sacro Bulwark",
  }

  sets.Weapons.Sleep = {
    -- sub="Caliburnus",
  }

  --Default arrow to use
  Ammo.RA = ''
  Ammo.ACC = ''

  -- ===================================================================================================================
  --		sets.Idle
  -- ===================================================================================================================

  -- Standard Idle set with -DT,Refresh,Regen and movement gear
  sets.Idle = {
    ammo = 'Staunch Tathlum',
    head = 'Viti. Chapeau +3',
    body = 'Lethargy Sayon +2',
    hands = 'Leth. Ganth. +2',
    legs = 'Leth. Fuseau +2',
    feet = 'Leth. Houseaux +2',
    neck = 'Loricate Torque',
    waist = 'Sailfi Belt +1',
    left_ear = 'Alabaster Earring',
    right_ear = 'Brutal Earring',
    left_ring = 'Ayanmo Ring',
    right_ring = 'Gelatinous Ring +1',
    back = {
      name = "Sucellos's Cape",
      augments = { 'DEX+20', 'Accuracy+20 Attack+20', 'Accuracy+10', '"Dbl.Atk."+10', 'Damage taken-5%' },
    },
  }
  sets.Idle.TP = sets.Idle
  sets.Idle.ACC = sets.Idle
  sets.Idle.DT = sets.Idle
  sets.Idle.PDL = sets.Idle
  sets.Idle.SB = sets.Idle
  sets.Idle.MEVA = sets.Idle
  sets.Idle.CRIT = sets.Idle
  sets.Idle.Enspell = sets.Idle
  sets.Idle.Resting = sets.Idle

  -- Set is only applied when sublimation is charging
  sets.Idle.Sublimation = set_combine(sets.Idle, {
    waist = 'Embla Sash', -- +3 Submlimation when active
  })

  -- Gear to swap out for Movement
  sets.Movement = {
    legs = { name = 'Carmine Cuisses +1', augments = { 'HP+80', 'STR+12', 'INT+12' }, hp = 130 },
  }

  -- Set to be used if you get
  sets.Cursna_Received = {
    -- neck = "Nicander's Necklace",
    -- left_ring = { name = "Eshmun's Ring", bag = 'wardrobe1', priority = 2 },
    -- right_ring = { name = "Eshmun's Ring", bag = 'wardrobe2', priority = 1 },
    waist = 'Gishdubar Sash',
  }

  -- ===================================================================================================================
  --		sets.OffenseMode
  -- ===================================================================================================================

  -- 'TP','ACC','DT','PDL','SB','Enspell'
  sets.OffenseMode = {
    ammo = 'Coiste Bodhar',
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

  sets.OffenseMode.TP = set_combine(sets.OffenseMode, {})
  sets.OffenseMode.DT = set_combine(sets.OffenseMode, {})
  sets.OffenseMode.ACC = set_combine(sets.OffenseMode, {})
  sets.OffenseMode.PDT = set_combine(sets.OffenseMode, {})
  sets.OffenseMode.MEVA = set_combine(sets.OffenseMode, {})

  sets.OffenseMode.SB = set_combine(sets.OffenseMode, {
    -- hands = 'Volte Mittens',
    -- legs = 'Volte Tights',
    -- neck = 'Bathy Choker +1',
    -- waist = 'Sarissapho. Belt',
  })

  sets.OffenseMode.CRIT = set_combine(sets.OffenseMode, {
    ammo = 'Yetshila',
    -- head = { name = 'Blistering Sallet +1', augments = { 'Path: A' } },
    -- body = 'Adamantite Armor',
    hands = 'Leth. Ganth. +2',
    -- legs = "Bunzi's Pants",
    -- feet = 'Thereoid Greaves',
    -- neck = 'Null Loop',
    -- waist = 'Reiki Yotai',
    -- left_ear = 'Sherida Earring',
    -- right_ear = {
    --   name = 'Leth. Earring +1',
    --   augments = { 'System: 1 ID: 1676 Val: 0', 'Accuracy+14', 'Mag. Acc.+14', '"Dbl.Atk."+5' },
    -- },
    -- left_ring = "Lehko's Ring",
    right_ring = { name = 'Gelatinous Ring +1' },
    back = {
      name = "Sucellos's Cape",
      augments = { 'DEX+20', 'Accuracy+20 Attack+20', 'Accuracy+10', '"Dbl.Atk."+10', 'Damage taken-5%' },
    },
    -- back = {
    --   name = "Sucellos's Cape",
    --   augments = { 'DEX+20', 'Accuracy+20 Attack+20', 'DEX+10', 'Crit.hit rate+10', 'Damage taken-5%' },
    -- },
  })

  sets.OffenseMode.Enspell = set_combine(sets.OffenseMode, {
    -- sub = 'Ammurapi Shield',
    -- range = 'Ullr',
    -- head = 'Umuthi Hat',
    body = 'Lethargy Sayon +2',
    hands = 'Aya. Manopolas +2',
    -- legs = { name = 'Viti. Tights +3', augments = { 'Enspell Damage', 'Accuracy' } },
    feet = 'Leth. Houseaux +2',
    neck = 'Quanpur Necklace',
    -- waist = "Orpheus's Sash",
    -- left_ear = 'Malignance Earring',
    -- right_ear = 'Leth. Earring +1',
    -- left_ring = 'Freke Ring',
    right_ring = { name = 'Metamor. Ring +1' },
    -- back = 'Null Shawl',
  })

  sets.DualWield = {
    -- waist = 'Reiki Yotai',
    left_ear = 'Eabani Earring',
  }

  sets.Enspell = {}

  sets.Saboteur = { hands = 'Leth. Ganth. +2' }

  sets.TreasureHunter = {
    ammo = 'Per. Lucky Egg',
    -- head = 'Volte Cap',
    -- legs = 'Volte Hose',
    -- waist = 'Chaac Belt',
  }

  -- ===================================================================================================================
  --		sets.Precast
  -- ===================================================================================================================

  -- Used for Magic Spells
  sets.Precast = {}

  -- 42% Fast Cast is needed on RDM (Fast Cast IX - 38%)
  -- 10% is Quick Magic limit
  sets.Precast.FastCast = {
    ammo = 'Kalboron Stone',
    head = 'Atrophy Chapeau +3',
    body = 'Viti. Tabard +3',
    hands = 'Jhakri Cuffs +2',
    legs = 'Enif Cosciales',
    feet = { name = 'Carmine Greaves', augments = { 'HP+60', 'MP+60', 'Phys. dmg. taken -3' } },
    neck = 'Voltsurge Torque',
    waist = 'Embla Sash',
    left_ear = 'Loquac. Earring',
    right_ear = { name = 'Lethargy Earring', augments = { 'System: 1 ID: 1676 Val: 0', 'Accuracy+7', 'Mag. Acc.+7' } },
    left_ring = 'Kishar Ring',
    right_ring = 'Jhakri Ring',
    back = {
      name = "Sucellos's Cape",
      augments = { 'MND+20', 'Mag. Acc+20 /Mag. Dmg.+20', 'Mag. Acc.+10', '"Fast Cast"+10' },
    },
  } -- 50%+ total Fast Cast and 11% Quick Magic

  -- Used for Enhancing Magic
  sets.Precast.Enhancing = set_combine(sets.Precast.FastCast, {})

  -- Used for Healing Magic
  sets.Precast.Cure = set_combine(sets.Precast.FastCast, {
    head = { name = 'Kaykaus Mitra', augments = { 'MP+60', '"Cure" spellcasting time -5%', 'Enmity-5' } },
  })

  sets.Precast.RA = set_combine(sets.Precast, {
    -- ammo = Ammo.RA,
    -- waist = 'Yemaya Belt', -- 0 / 5
    -- right_ring = 'Crepuscular Ring', -- 3
  })

  -- Flurry
  sets.Precast.RA.Flurry = set_combine(sets.Precast.RA, {})

  -- Flurry II
  sets.Precast.RA.Flurry_II = set_combine(sets.Precast.RA.Flurry, {})

  sets.Precast.BlueMagic = set_combine(sets.Precast.FastCast, {})

  -- ===================================================================================================================
  --		sets.midcast
  -- ===================================================================================================================

  --Base set for midcast - if not defined will notify and use your idle set for surviability
  sets.Midcast = set_combine(sets.Idle, {})

  sets.Midcast.Utsusemi = set_combine(sets.Midcast, {})

  -- Ranged Attack Gear (Normal Midshot)
  sets.Midcast.RA = set_combine(sets.Midcast, {})

  -- Ranged Attack Gear (High Accuracy Midshot)
  sets.Midcast.RA.ACC = set_combine(sets.Midcast.RA, {
    ammo = Ammo.ACC,
  })

  -- Ranged Attack Gear (Physical Damage Limit)
  sets.Midcast.RA.PDL = set_combine(sets.Midcast.RA, {})

  -- Ranged Attack Gear (Critical Build)
  sets.Midcast.RA.CRIT = set_combine(sets.Midcast.RA, {})

  --This set is used as base as is overwrote by specific gear changes (Spell Interruption Rate Down)
  sets.Midcast.SIRD = {}

  -- Cure Set
  sets.Midcast.Cure = {
    main = { name = 'Serenity', augments = { 'MP+35', 'Enha.mag. skill +8', '"Cure" spellcasting time -6%' } },
    ammo = 'Staunch Tathlum',
    head = { name = 'Kaykaus Mitra', augments = { 'MP+60', '"Cure" spellcasting time -5%', 'Enmity-5' } }, -- 11
    body = 'Viti. Tabard +3',
    hands = 'Leth. Ganth. +2',
    legs = 'Gyve Trousers',
    feet = 'Leth. Houseaux +2',
    neck = { name = 'Loricate Torque' },
    waist = 'Witful Belt',
    right_ear = { name = 'Lethargy Earring', augments = { 'System: 1 ID: 1676 Val: 0', 'Accuracy+7', 'Mag. Acc.+7' } },
    -- right_ear = { name = 'Lethargy Earring', augments = { 'System: 1 ID: 1676 Val: 0', 'Accuracy+7', 'Mag. Acc.+7' } },
    left_ear = { name = 'Loquac. Earring', priority = 1 }, -- Used to Keep HP/MP pool
    left_ring = 'Defending Ring',
    right_ring = { name = "Naji's Loop" },
    back = {
      name = "Sucellos's Cape",
      augments = { 'MND+20', 'Mag. Acc+20 /Mag. Dmg.+20', 'Mag. Acc.+10', '"Fast Cast"+10' },
    },
  } -- 50% Cure I, 16% Cure II

  sets.Midcast.Curaga = set_combine(sets.Midcast.Cure, {})

  -- Regen
  sets.Midcast.Regen = {
    -- feet = { name = "Bunzi's Sabots", augments = { 'Path: A' } },
  }

  -- Enhancing Duration on SELF
  sets.Midcast.Enhancing = {
    -- sub = 'Ammurapi Shield',
    ammo = 'Staunch Tathlum',
    head = 'Jhakri Coronal +2',
    body = { name = 'Viti. Tabard +3', augments = { 'Enhances "Chainspell" effect' } }, --15
    hands = 'Atrophy Gloves +3', -- 20
    legs = 'Atrophy Tights +3',
    feet = 'Leth. Houseaux +2', -- 35
    neck = { name = 'Dls. Torque +1', augments = { 'Path: A' } }, --25
    waist = 'Embla Sash', --10
    left_ear = "Hecate's Earring",
    right_ear = { name = 'Lethargy Earring', augments = { 'System: 1 ID: 1676 Val: 0', 'Accuracy+7', 'Mag. Acc.+7' } },
    left_ring = 'Metamor. Ring +1',
    right_ring = 'Kishar Ring',
    back = {
      name = "Sucellos's Cape",
      augments = { 'MND+20', 'Mag. Acc+20 /Mag. Dmg.+20', 'Mag. Acc.+10', '"Fast Cast"+10' },
    }, -- 20
  } -- 150% Duration

  -- Enhancing Duration on OTHERS
  sets.Midcast.Enhancing.Others = set_combine(sets.Midcast.Enhancing, {
    head = 'Leth. Chappel +2',
    body = 'Lethargy Sayon +2',
    hands = 'Leth. Ganth. +2',
    legs = 'Leth. Fuseau +2',
    feet = 'Leth. Houseaux +2', -- 35
  })

  -- Spells that require SKILL - RDM only needs 500 or more except Temper II
  sets.Midcast.Enhancing.Skill = set_combine(sets.Midcast.Enhancing, {
    -- sub = 'Ammurapi Shield',
    -- head = 'Befouled Crown',
    body = { name = 'Viti. Tabard +3', augments = { 'Enhances "Chainspell" effect' } },
    -- hands = { name = 'Viti. Gloves +3', augments = { 'Enhancing Magic duration' } },
    legs = 'Atrophy Tights +3',
    feet = 'Leth. Houseaux +2',
    -- neck = "Incanter's Torque",
    waist = 'Olympus Sash',
    -- left_ear = 'Andoaa Earring',
    -- right_ear = 'Mimir Earring',
  })

  -- used to boost Gain Spells
  sets.Midcast.Enhancing.Gain = set_combine(sets.Midcast.Enhancing, {
    -- hands = { name = 'Viti. Gloves +3', augments = { 'Enhancing Magic duration' } },
  })

  -- Elemental
  sets.Midcast.Enhancing.Elemental = set_combine(sets.Midcast.Enhancing, {})

  -- Status
  sets.Midcast.Enhancing.Status = set_combine(sets.Midcast.Enhancing, {})

  -- Blue Magic
  sets.Midcast.BlueMagic = {}
  sets.Midcast.BlueMagic.Skill = set_combine(sets.Midcast.Enhancing, {})
  sets.Midcast.BlueMagic.Nuke = set_combine(sets.Midcast.Enhancing, {})
  sets.Midcast.BlueMagic.Healing = set_combine(sets.Midcast.Cure, {})
  sets.Midcast.BlueMagic.ACC = set_combine(sets.Midcast.Enhancing, {})
  sets.Midcast.BlueMagic.Enmity = set_combine(sets.Enmity, {})

  -- Enfeebling
  sets.Midcast.Enfeebling = {
    -- ammo = 'Regal Gem',
    head = { name = 'Viti. Chapeau +3', augments = { 'Enfeebling Magic duration', 'Magic Accuracy' } },
    body = 'Atrophy Tabard +3',
    hands = 'Leth. Ganth. +2',
    legs = 'Jhakri Slops +2',
    feet = { name = 'Vitiation Boots +1', augments = { 'Immunobreak Chance' } },
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

  -- Skill Based ('Dispel','Aspir','Aspir II','Aspir III','Drain','Drain II','Drain III','Frazzle','Frazzle II','Stun','Poison','Poison II','Poisonga')
  sets.Midcast.Enfeebling.MACC = set_combine(sets.Midcast.Enfeebling, {
    main = 'Marin Staff +1',
    sub = 'Mephitis Grip',
    ammo = 'Kalboron Stone',
    head = 'Atrophy Chapeau +3',
    body = 'Atrophy Tabard +3',
    hands = 'Leth. Ganth. +2',
    legs = 'Leth. Fuseau +2',
    feet = 'Jhakri Pigaches +2',
    neck = { name = 'Dls. Torque +1', augments = { 'Path: A' } },
    waist = 'Rumination Sash',
    left_ear = 'Snotra Earring',
    right_ear = { name = 'Lethargy Earring', augments = { 'System: 1 ID: 1676 Val: 0', 'Accuracy+7', 'Mag. Acc.+7' } },
    left_ring = 'Jhakri Ring',
    right_ring = 'Metamor. Ring +1',
    back = {
      name = "Sucellos's Cape",
      augments = { 'MND+20', 'Mag. Acc+20 /Mag. Dmg.+20', 'Mag. Acc.+10', '"Fast Cast"+10' },
    },
  })

  -- Potency Basted ('Paralyze','Paralyze II','Slow','Slow II','Addle','Addle II','Distract','Distract II','Distract III','Frazzle III','Blind','Blind II')
  sets.Midcast.Enfeebling.Potency = set_combine(sets.Midcast.Enfeebling, {
    -- ammo = 'Regal Gem', -- 10%
    body = 'Lethargy Sayon +2', -- 14%
    back = {
      name = "Sucellos's Cape",
      augments = { 'MND+20', 'Mag. Acc+20 /Mag. Dmg.+20', 'Mag. Acc.+10', '"Fast Cast"+10' },
    },
    -- feet = { name = 'Vitiation Boots +3', augments = { 'Immunobreak Chance' } }, -- 10%
    neck = { name = 'Dls. Torque +1', augments = { 'Path: A' } }, -- 10%
  })

  -- Duration Based ('Sleep','Sleep II','Sleepga','Sleepga II','Diaga','Dia','Dia II','Dia III','Bio','Bio II','Bio III','Silence','Gravity','Gravity II','Inundation','Break','Breakaga', 'Bind', 'Bind II')
  sets.Midcast.Enfeebling.Duration = set_combine(sets.Midcast.Enfeebling, {
    head = 'Leth. Chappel +2',
    body = 'Lethargy Sayon +2',
    hands = 'Leth. Ganth. +2',
    legs = 'Leth. Fuseau +2',
    feet = 'Leth. Houseaux +2', -- 35
    -- head = { name = 'Viti. Chapeau +3', augments = { 'Enfeebling Magic duration', 'Magic Accuracy' } }, -- 15s (3 seconds x 5 merits)
    -- hands = 'Regal Cuffs', --20% swaps out with Saboteur active
    right_ear = 'Snotra Earring', -- 10%
    left_ring = 'Kishar Ring', -- 10%
    -- waist = { name = 'Obstin. Sash', augments = { 'Path: A' } }, -- 5%
    neck = { name = 'Dls. Torque +1', augments = { 'Path: A' } }, -- 25%
  })

  -- Specific gear for spells
  sets.Midcast['Stoneskin'] = set_combine(sets.Midcast.Enhancing, {
    waist = 'Siegel Sash',
    legs = 'Shedir Seraweels',
    -- neck = 'Nodens Gorget',
    -- left_ear = 'Earthcry Earring',
  })

  sets.Midcast['Aquaveil'] = set_combine(sets.Midcast.Enhancing, {
    legs = 'Shedir Seraweels',
    -- hands = 'Regal Cuffs',
    -- head = 'Amalric Coif +1',
  })

  -- Spells that require SKILL - RDM only needs +500 skill except Temper II
  sets.Midcast['Temper II'] = set_combine(sets.Midcast.Enhancing, {
    ammo = 'Psilomene',
    -- head = 'Befouled Crown',
    -- hands = { name = 'Viti. Gloves +3', augments = { 'Enhancing Magic duration' } },
    legs = 'Atrophy Tights +3',
    -- neck = "Incanter's Torque",
    -- left_ear = 'Mimir Earring',
    -- right_ear = 'Andoaa Earring',
    waist = 'Olympus Sash',
    -- back = 'Perimede Cape',
  }) -- Max Enhancing 672

  sets.Midcast['Diaga'] = set_combine(sets.Midcast.Enfeebling, sets.TreasureHunter)
  sets.Midcast['Dispelga'] = set_combine(sets.Midcast.Enfeebling, sets.TreasureHunter)

  sets.Midcast.Refresh = set_combine(sets.Midcast.Enhancing, {
    body = 'Atrophy Tabard +3',
    legs = 'Leth. Fuseau +2',
  })

  sets.Midcast.Phalanx = set_combine(sets.Midcast.Enhancing.Skill, {})

  sets.Midcast.Dark = set_combine(sets.Midcast.Enfeebling, {})

  sets.Midcast.Dark.MACC = set_combine(sets.Midcast.Enfeebling.MACC, {})

  sets.Midcast.Dark.Absorb = set_combine(sets.Midcast.Enfeebling, {})

  sets.Midcast.Nuke = {
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

  sets.Midcast.Burst = set_combine(sets.Midcast.Nuke, {
    head = 'Ea Hat',
    feet = 'Jhakri Pigaches +2',
  })

  -- ===================================================================================================================
  --		sets.JA
  -- ===================================================================================================================

  -- Job Abilities
  sets.JA = {}
  sets.JA['Chainspell'] = { body = { name = 'Viti. Tabard +3', augments = { 'Enhances "Chainspell" effect' } } }
  sets.JA['Saboteur'] = {}
  sets.JA['Spontaneity'] = {}
  sets.JA['Stymie'] = {}
  sets.JA['Convert'] = {}
  sets.JA['Composure'] = {}

  -- Dancer JA Section
  sets.Flourish = set_combine(sets.Idle.DT, {})

  sets.Jig = set_combine(sets.Idle.DT, {})

  sets.Step = set_combine(sets.OffenseMode.DT, {})

  sets.Samba = set_combine(sets.Idle.DT, {})

  -------------------------------------------------------------------------------
  -- Waltz Potency gear caps at 50%, while Waltz received potency caps at 30%. --
  -------------------------------------------------------------------------------
  sets.Waltz = set_combine(sets.OffenseMode.DT, {
    -- legs = 'Dashing Subligar', -- 10
    --ammo="Yamarang", -- 5
    --body={ name="Gleti's Cuirass", augments={'Path: A',}}, -- 10
    --hands="Slither Gloves +1", -- 5
  }) -- 10% Potency

  -- ===================================================================================================================
  --		sets.WS
  -- ===================================================================================================================

  sets.WS = {
    ammo = { name = 'Coiste Bodhar' },
    head = 'Viti. Chapeau +3',
    body = { name = 'Nyame Mail', augments = { 'Path: B' } },
    hands = { name = 'Nyame Gauntlets', augments = { 'Path: B' } },
    legs = { name = 'Nyame Flanchard', augments = { 'Path: B' } },
    feet = 'Leth. Houseaux +2',
    neck = { name = 'Dls. Torque +1', augments = { 'Path: A' } },
    waist = { name = 'Sailfi Belt +1' },
    left_ear = 'Moonshade Earring',
    right_ear = { name = 'Lethargy Earring', augments = { 'System: 1 ID: 1676 Val: 0', 'Accuracy+7', 'Mag. Acc.+7' } },
    left_ring = 'Ayanmo Ring',
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

  sets.WS.ACC = set_combine(sets.WS, {})

  sets.WS.PDL = set_combine(sets.WS, {
    -- ammo = 'Crepuscular Pebble',
    -- right_ring = 'Sroda Ring',
  })

  sets.WS.WSD = set_combine(sets.WS, {
    -- ammo = "Oshasha's Treatise",
    -- left_ear = 'Ishvara Earring',
  })

  sets.WS.MAB = set_combine(sets.WS, {
    -- ammo = "Oshasha's Treatise",
    neck = 'Sanctity Necklace',
    -- waist = "Orpheus's Sash",
    -- left_ear = 'Malignance Earring',
    -- right_ear = 'Regal Earring',
  })

  sets.WS.CRIT = set_combine(sets.WS, {
    ammo = 'Yetshila',
    -- head = { name = 'Blistering Sallet +1', augments = { 'Path: A' } },
    neck = 'Fotia Gorget',
    waist = 'Fotia Belt',
    right_ring = 'Hetairoi Ring',
    -- back = {
    --   name = "Sucellos's Cape",
    --   augments = { 'DEX+20', 'Accuracy+20 Attack+20', 'DEX+10', 'Crit.hit rate+10', 'Damage taken-5%' },
    -- },
  })

  sets.WS.RA = set_combine(sets.WS, {})

  sets.WS.SB = sets.Subtle_Blow

  sets.WS['Seraph Blade'] = set_combine(sets.WS.MAB, {
    -- right_ring = 'Weather. Ring',
    right_ear = { name = 'Moonshade Earring', augments = { 'Attack+4', 'TP Bonus +250' } },
  })

  sets.WS['Sanguine Blade'] = set_combine(sets.WS.MAB, {
    -- head = 'Pixie Hairpin +1',
    -- right_ring = 'Archon Ring',
  })

  sets.WS['Aeolian Edge'] = set_combine(sets.WS.MAB, {
    right_ear = { name = 'Moonshade Earring', augments = { 'Attack+4', 'TP Bonus +250' } },
  })

  sets.WS['Red Lotus Blade'] = sets.WS.MAB

  sets.WS['Chant du Cygne'] = sets.WS.CRIT

  sets.WS['Savage Blade'] = sets.WS.WSD

  sets.WS['Black Halo'] = sets.WS.WSD
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

  return equipSet
end

-- Augment basic equipment sets
function midcast_custom(spell)
  local equipSet = {}
  if buffactive['Saboteur'] and spell.skill == 'Enfeebling Magic' then
    equipSet = sets.Saboteur
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

--Function used to automate Job Ability use
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
