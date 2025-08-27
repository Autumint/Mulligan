-- THIS WILL BE THE TAINTED RED DECK UNLOCK

SMODS.Joker {
    key = "Sumptorium",
    atlas = "Sumptorium_Atlas",
    blueprint_compat = false,
    eternal_compat = false,
    rarity = 3,
    cost = 6,
    pos = { x = 0, y = 0 },
    config = { extra = { h_plays = -2 } },

calculate = function(self, card, context)
    if context.end_of_round and context.beat_boss and not context.individual and not context.repetition then
        if #SMODS.find_card('j_tdec_SumptoClot') < 3 then
            play_sound('tdec_heart_out')
            G.E_MANAGER:add_event(Event({
                func = function()
                    SMODS.add_card{ 
                        set = "Joker", 
                        key = "j_tdec_SumptoClot", 
                        edition = "e_tdec_clotting", 
                    }
                    return true
                end
            }))
        end
    end
end,

    add_to_deck = function(self, card, from_debuff)
        G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.extra.h_plays
    end,

remove_from_deck = function(self, card)
    G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.extra.h_plays

    local cards_to_destroy = SMODS.find_card('j_tdec_SumptoClot')
    if cards_to_destroy and #cards_to_destroy > 0 then
        SMODS.destroy_cards(cards_to_destroy, true)
    end
end
}

SMODS.Joker {
    key = "SumptoClot",
    atlas = "Clot_Atlas",
    blueprint_compat = false,
    rarity = 1,
    cost = 4,
    pos = { x = 0, y = 0 },
    config = { extra = { Xmult = 1.5 } },

    in_pool = function(self, card)
        return false
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return { xmult = card.ability.extra.Xmult }
        end
    end,
}

SMODS.Edition {
    key = 'clotting',
    shader = false,
    badge_colour = G.C.RED,
    config = { card_limit = 1 },
    in_shop = false,
    weight = 1,
    extra_cost = 1,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.edition.card_limit } }
    end,
    get_weight = function(self)
        return self.weight
    end
}