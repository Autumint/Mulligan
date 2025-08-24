SMODS.Back{
    original = "b_painted",
    key = "tainted_painted",
    atlas = "tainted_atlas",
    pos = {x = 4, y = 1},
    config = {
        hands = -3,
        hand_size = 3,
        discards = 2,
    },
    loc_txt = {
        name = "Dried Deck",
        text = {
            "{C:White}Better Jokers.",
            "{C:red,E:2}Dry Paint.{}"
        }
    },
    calculate = function(self, back, context)
        if context.final_scoring_step then
            return { xmult = 2 }
        end

        if G.STATE == 8 and not self._gave_money then
            ease_dollars(3)
            self._gave_money = true
        elseif G.STATE ~= 8 then
            self._gave_money = false
        end

        G.GAME.banned_keys["j_burglar"] = true
        G.GAME.banned_keys["j_troubadour"] = true
        G.GAME.banned_keys["v_grabber"] = true
        G.GAME.banned_keys["v_hieroglyph"] = true

        if G.GAME and G.GAME.round_resets then
            if G.GAME.round_resets.hands > 1 then
                G.GAME.round_resets.hands = 1
            end
        end
    end
}