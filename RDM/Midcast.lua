return {
	["Elemental Magic"] = {
		default = {
			ammo = "Ghastly Tathlum +1",
			head = "Leth. Chappel +2",
			body = "Lethargy Sayon +2",
			hands = "Leth. Ganth. +2",
			legs = "Leth. Fuseau +2",
			feet = "Leth. Houseaux +2",
			neck = "Saevus Pendant +1",
			waist = "Witful Belt",
			left_ear = "Friomisi Earring",
			right_ear = "Novio Earring",
			left_ring = "Ayanmo Ring",
			right_ring = "Jhakri Ring",
			back = {
				name = "Sucellos's Cape",
				augments = { "MND+20", "Mag. Acc+20 /Mag. Dmg.+20", "Mag. Acc.+10", '"Fast Cast"+10' },
			},
		},
		burst = {
			ammo = "Ghastly Tathlum +1",
			head = "Leth. Chappel +2",
			body = "Lethargy Sayon +2",
			hands = "Leth. Ganth. +2",
			legs = "Leth. Fuseau +2",
			feet = "Leth. Houseaux +2",
			neck = "Saevus Pendant +1",
			waist = "Witful Belt",
			left_ear = "Friomisi Earring",
			right_ear = "Novio Earring",
			left_ring = "Ayanmo Ring",
			right_ring = "Jhakri Ring",
			back = {
				name = "Sucellos's Cape",
				augments = { "MND+20", "Mag. Acc+20 /Mag. Dmg.+20", "Mag. Acc.+10", '"Fast Cast"+10' },
			},
		},
		spells = {},
	},
	["Dark Magic"] = {
		default = {
			ammo = "Ghastly Tathlum +1",
			head = "Atrophy Chapeau +3",
			body = "Jhakri Robe +2",
			hands = "Jhakri Cuffs +2",
			legs = "Jhakri Slops +2",
			feet = "Jhakri Pigaches +2",
			neck = "Sanctity Necklace",
			waist = "Witful Belt",
			left_ear = "Hecate's Earring",
			right_ear = "Moldavite Earring",
			left_ring = "Ayanmo Ring",
			right_ring = "Jhakri Ring",
			back = {
				name = "Sucellos's Cape",
				augments = { "MND+20", "Mag. Acc+20 /Mag. Dmg.+20", "Mag. Acc.+10", '"Fast Cast"+10' },
			},
		},
		spells = {
			["Aspir"] = {
				left_ring = "Excelsis Ring",
			},
			["Drain"] = "Aspir",
		},
	},
	["Enfeebling Magic"] = {
		default = {
			ammo = "Kalboron Stone",
			head = "Viti. Chapeau +1",
			body = "Lethargy Sayon +2",
			hands = "Leth. Gantherots +2",
			legs = "Jhakri Slops +2",
			feet = "Vitiation Boots +1",
			neck = { name = "Dls. Torque +1", augments = { "Path: A" } },
			waist = "Witful Belt",
			left_ear = "Hecate's Earring",
			right_ear = "Snotra Earring",
			left_ring = "Ayanmo Ring",
			right_ring = "Jhakri Ring",
			back = {
				name = "Sucellos's Cape",
				augments = { "MND+20", "Mag. Acc+20 /Mag. Dmg.+20", "Mag. Acc.+10", '"Fast Cast"+10' },
			},
		},
		spells = {
			["Dispel"] = {
				neck = { name = "Dls. Torque +1", augments = { "Path: A" } },
			},
		},
	},
	["Healing Magic"] = {
		default = {
			ammo = "Kalboron Stone",
			head = "Jhakri Coronal +2",
			body = "Viti. Tabard +1",
			hands = "Atrophy Gloves +3",
			legs = "Atrophy Tights +3",
			feet = "Leth. Houseaux +1",
			neck = "Sanctity Necklace",
			waist = "Witful Belt",
			left_ear = "Mache Earring",
			right_ear = "Brutal Earring",
			left_ring = "Ayanmo Ring",
			right_ring = "Karieyh Ring",
			back = {
				name = "Sucellos's Cape",
				augments = { "MND+20", "Mag. Acc+20 /Mag. Dmg.+20", "Mag. Acc.+10", '"Fast Cast"+10' },
			},
		},
		spells = {
			["Cure"] = {
				self = {
					waist = "Gishdubar Sash",
				},
			},
			["Cure II"] = "Cure",
			["Cure III"] = "Cure",
			["Cure IV"] = "Cure",
			["Curaga"] = "Cure",
			["Curaga II"] = "Cure",
		},
	},
	["Enhancing Magic"] = {
		default = {
			ammo = "Kalboron Stone",
			head = "Jhakri Coronal +2",
			body = "Viti. Tabard +1",
			hands = "Atrophy Gloves +3",
			legs = "Atrophy Tights +3",
			feet = "Leth. Houseaux +2",
			neck = { name = "Dls. Torque +1", augments = { "Path: A" } },
			waist = "Embla Sash",
			left_ear = "Hecate's Earring",
			right_ear = {
				name = "Lethargy Earring",
				augments = { "System: 1 ID: 1676 Val: 0", "Accuracy+7", "Mag. Acc.+7" },
			},
			left_ring = "Ayanmo Ring",
			right_ring = "Jhakri Ring",
		},
		barspells = {
			waist = "Olympus Sash",
			legs = "Shedir Seraweels",
			neck = "Sroda Necklace",
		},
		spells = {
			["Refresh"] = {
				self = {
					body = "Atrophy Tabard +3",
					legs = "Leth. Fuseau +1",
					waist = "Gishdubar Sash",
				},
				other = {
					body = "Atrophy Tabard +3",
					legs = "Leth. Fuseau +1",
					waist = "Embla Sash",
				},
			},
			["Refresh II"] = "Refresh",
			["Refresh III"] = "Refresh",
			["Stoneskin"] = {
				legs = "Shedir Seraweels",
			},
			["Aquaveil"] = {
				legs = "Shedir Seraweels",
			},
		},
	},
	["Ninjutsu"] = {
		default = {},
		spells = {},
	},
}
