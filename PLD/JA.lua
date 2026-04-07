local Enmity = require('PLD/Enmity.lua')

return {
  default = Enmity.FullEnmity,
  ['Divine Emblem'] = {
    hands = {
      name = 'Souv. Handsch. +1',
      augments = { 'HP+105', 'Enmity+9', 'Potency of "Cure" effect received +15%' },
      priority = 13,
    },
    head = {
      name = 'Souveran Schaller',
      augments = { 'HP+80', 'Enmity+7', 'Potency of "Cure" effect received +10%' },
      priority = 12,
    },
    legs = {
      name = 'Souv. Diechlings +1',
      augments = { 'HP+105', 'Enmity+9', 'Potency of "Cure" effect received +15%' },
      priority = 11,
    },
    body = {
      name = 'Souveran Cuirass',
      augments = { 'HP+80', 'Enmity+7', 'Potency of "Cure" effect received +10%' },
      priority = 10,
    },
    back = { name = "Rudianos's Mantle", augments = { 'HP+60', 'Eva.+20 /Mag. Eva.+20', 'Enmity+10' }, priority = 9 },
    feet = { name = 'Chev. Sabatons +2', priority = 8 },
    right_ear = { name = 'Cryptic Earring', priority = 7 },
    waist = { name = 'Creed Baudrier', priority = 6 },
    right_ring = { name = 'Supershear Ring', priority = 5 },
    left_ring = { name = 'Apeile Ring', priority = 4 },
    left_ear = { name = 'Friomisi Earring', priority = 3 },
    neck = { name = 'Unmoving Collar', priority = 2 },
    ammo = { name = 'Staunch Tathlum', priority = 1 },
  },
}
