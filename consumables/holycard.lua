SMODS.Consumable {
    unlocked = true,
    key = 'holy_card',
    cost = 4,
    rarity = 1,
    set = 'taintedcards',
    pos = { x = 0, y = 0 },
    config = { extra = { hands = 1 }},
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.hands } }
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area)
        G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.extra.hands
        ease_hands_played(card.ability.extra.hands)
    end,
    in_pool = function(self, args)
        if G.GAME.selected_back and G.GAME.selected_back.effect.center.key == "b_tdec_tainted_ghost" then
            return true, { allow_duplicates = false }
        end
    end
}