ITEM.name = "Комбинезон 'Заря'[Дигерская]"
ITEM.description = "Дигерский вариант 'Зари', многие элементы были подвергнуты изменениям дабы владелец в поисках 'металлического клада' чувствовал наименьший дискомфорт. Повышает защиту от радиации, но взамен уменьшает сопротивление пулям. [Прибавка к навыкам + Технические 30. + Взрывчатка 20.]"
ITEM.model = "models/flaymi/anomaly/dynamics/equipments/sumka4.mdl" -- Исправлена ошибка с кавычками
ITEM.width = 2
ITEM.height = 3
ITEM.armorAmount = 250
ITEM.gasmask = false
ITEM.category = "armor"
ITEM.resistance = true
ITEM.damage = {
    0.2, -- Bullets
    0.3, -- Slash
    0.3, -- Shock
    0.5, -- Burn
    0.5, -- Radiation
    0.5, -- Acid
    0.3, -- Explosion
}

ITEM.skillBoosts = {
    ["technical"] = 30, -- Увеличит технические науки на 30
    ["explosive"] = 20 -- Увеличит взрывчатку на 20
}