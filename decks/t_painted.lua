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
            "Better {C:money}Jokers.{}",
            "{C:red,E:2}Dry Paint.{}"
        }
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
        if context.final_scoring_step then
            return { xmult = 2 }
        end

        if G.STATE == 8 and not self._gave_money then
            ease_dollars(3)
            self._gave_money = true
        elseif G.STATE ~= 8 then
            self._gave_money = false
        end

        if G.GAME and G.GAME.round_resets then
            if G.GAME.round_resets.hands > 1 then
                G.GAME.round_resets.hands = 1
            end
        end
    end
}