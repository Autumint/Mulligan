SMODS.Back {
    original = "b_green",
    key = "tainted_green",
    atlas = "tainted_atlas",
    pos = { x = 3, y = 0 },
    config = { extra_hand_bonus = 1, extra_discard_bonus = 1, dollars = 4 },

    apply = function(self)
        G.GAME.banned_keys["j_astronomer"] = true
    end,

    calculate = function(self, back, context)
        if not G.GAME.selected_back and G.GAME.selected_back.effect.center.key == "b_tdec_tainted_green" then
            return
        end

        if context.starting_shop then
            G.GAME.money_spent = false
        end

        if context.buying_card or context.open_booster or context.reroll_shop then
            G.GAME.money_spent = true
        end

        if context.ending_shop and not G.GAME.money_spent then
            local bonus_from_held = math.floor(G.GAME.dollars / 25)
            local total_bonus = 4 + bonus_from_held

            G.GAME.dollars = G.GAME.dollars + total_bonus

            return {
                message = "More... +$" .. total_bonus,
                colour = G.C.MONEY
            }
        end

        if context.final_scoring_step then
            local money = G.GAME.dollars
            local bonus_mult = 1 + math.floor(money / 5) * 0.05
            return { xmult = bonus_mult }
        end
    end
}

local old_set_cost = Card.set_cost
function Card:set_cost(...)
    old_set_cost(self, ...)

    if G.GAME.selected_back 
        and G.GAME.selected_back.effect.center.key == "b_tdec_tainted_green" 
        and self.ability and self.ability.set 
        and (
            self.ability.set == "Joker" 
            or self.ability.set == "Voucher" 
            or self.ability.set == "Booster" 
            or self.ability.set == "Planet" 
            or self.ability.set == "Tarot"
        ) 
    then
        local extra_mult = 0.15 * math.floor(G.GAME.dollars / 20)
        local multiplier = 1.5 + extra_mult

        if not self.base_cost then
            self.base_cost = self.cost
        end

        self.cost = math.floor(self.base_cost * multiplier)
    end
end
