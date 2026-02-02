return {
  default = {
    ammo = 'Kalboron Stone',
    head = 'Atrophy Chapeau +3',
    body = 'Viti. Tabard +1',
    hands = 'Jhakri Cuffs +2',
    legs = 'Aya. Cosciales +2',
    feet = 'Jhakri Pigaches +2',
    neck = 'Voltsurge Torque',
    waist = 'Embla Sash',
    left_ear = 'Loquac. Earring',
    right_ear = {
      name = 'Lethargy Earring',
      augments = { 'System: 1 ID: 1676 Val: 0', 'Accuracy+7', 'Mag. Acc.+7' },
    },
    left_ring = 'Ayanmo Ring',
    right_ring = 'Jhakri Ring',
    back = {
      name = "Sucellos's Cape",
      augments = { 'MND+20', 'Mag. Acc+20 /Mag. Dmg.+20', 'Mag. Acc.+10', '"Fast Cast"+10' },
    },
  },
  spells = {
    ['Stoneskin'] = {
      main = 'Pukulatmuj +1',
    },
    ['Cure'] = {
      main = { name = 'Serenity', augments = { 'MP+35', 'Enha.mag. skill +8', '"Cure" spellcasting time -6%' } },
      sub = 'Mephitis Grip',
    },
    ['Cure II'] = 'Cure',
    ['Cure III'] = 'Cure',
    ['Cure IV'] = 'Cure',
    ['Utsusemi: Ichi'] = {
      neck = 'Magoraga Beads',
    },
    ['Utsusemi: Ni'] = 'Utsusemi: Ichi',
  },
  types = {
    ['Enfeebling Magic'] = {
      head = 'Leth. Chappel +2',
    },
  },
}
