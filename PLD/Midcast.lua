local Enmity = require('PLD/Enmity.lua')

return {
  ['Healing Magic'] = {
    default = Enmity.SIRD,
    spells = {},
  },
  ['Enhancing Magic'] = {
    default = Enmity.SIRD,
    spells = {
      ['Phalanx'] = {
        hands = {
          name = 'Souv. Handsch. +1',
          augments = {
            'HP+105',
            'Enmity+9',
            'Potency of "Cure" effect received +15%',
          },
        },
        legs = "Sakpata's Cuisses",
        feet = 'Souveran Schuhs',
        waist = 'Olympus Sash',
      },
    },
  },
  ['Divine Magic'] = {
    default = Enmity.SIRD,
    spells = {
      ['Flash'] = Enmity.FullEnmity,
    },
  },
  ['Blue Magic'] = {
    default = Enmity.SIRD,
    spells = {
      ['Jettatura'] = Enmity.FullEnmity,
    },
  },
}
