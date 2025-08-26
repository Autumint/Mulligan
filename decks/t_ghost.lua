SMODS.Back{
    original = "b_ghost",
    key = "tainted_ghost",
    atlas = "tainted_atlas",
    pos = {x = 6, y = 0},
    config = { consumables = {'c_tdec_holy_card'},
        hands = -3,
        discards = 2,
    },

    apply = function(self)
        G.GAME.common_mod   = (G.GAME.common_mod   or 1) * 0.8
        G.GAME.uncommon_mod = (G.GAME.uncommon_mod or 1) * 1.5
        G.GAME.rare_mod     = (G.GAME.rare_mod     or 1) * 2.0

        G.GAME.banned_keys["j_card_sharp"] = true
        G.GAME.banned_keys["j_troubadour"] = true
        G.GAME.banned_keys["j_burglar"]    = true
        G.GAME.banned_keys["v_grabber"]    = true
        G.GAME.banned_keys["v_hieroglyph"] = true
    end,

    calculate = function(self, back, context)
        if context.end_of_round and context.beat_boss and not context.individual and not context.repetition then
            G.E_MANAGER:add_event(Event({
                func = function()
                    SMODS.add_card{ set = "TaintedCards", key = "c_tdec_holy_card" }
                    return true
                end
            }))
        end

        if context.final_scoring_step then
            return { xmult = 1.75 }
        end

        if G.GAME and G.GAME.round_resets then
            if G.GAME.current_round.hands_left == 0 and context.end_of_round then
                G.GAME.round_resets.hands = 1
            end
        end

        if G.GAME and G.GAME.round_resets then
            if G.GAME.current_round.hands_left > 2 then
                G.GAME.current_round.hands_left = 2
            end
        end
    end,
}

SMODS.Consumable {
    unlocked = true,
    key = 'holy_card',
    set = 'TaintedCards',
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
    end
}