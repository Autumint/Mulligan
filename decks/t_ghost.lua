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
        G.GAME.taintedcards_rate = 1
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
