local original_get_cost = Card.get_cost
Card.get_cost = function(self)
    local base = original_get_cost(self)

    if G.GAME and G.GAME.selected_back and G.GAME.selected_back.effect.center.key == "b_tdec_tainted_green" then
        return base * 2
    end

    return base
end

SMODS.Back{
    original = "b_green",
    key = "tainted_green",
    atlas = "tainted_atlas",
    pos = { x = 3, y = 0 },
    config = { extra_hand_bonus = 1, extra_discard_bonus = 1, dollars = 4 },
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
            local held_money = G.GAME.dollars or 0
            local bonus_from_held = math.floor(held_money / 25)
            local total_bonus = 4 + bonus_from_held

            G.GAME.dollars = held_money + total_bonus

            return {
                message = "More... +$" .. total_bonus,
                colour = G.C.MONEY
            }
        end

        G.GAME.banned_keys["j_astronomer"] = true

        if context.final_scoring_step then
            local money = G.GAME.dollars or 0
            local bonus_mult = 1 + math.floor(money / 5) * 0.05
            return { xmult = bonus_mult }
        end
    end
}

if not Card._original_set_cost then
    Card._original_set_cost = Card.set_cost
end

function Card:set_cost(...)
    Card._original_set_cost(self, ...)

    if not (G.GAME and G.GAME.selected_back and G.GAME.selected_back.effect.center.key == "b_tdec_tainted_green") then
        return
    end

    if self.ability and self.ability.set and (
        self.ability.set == "Joker" or
        self.ability.set == "Voucher" or
        self.ability.set == "Booster" or
        self.ability.set == "Planet" or
        self.ability.set == "Tarot"
    ) then
        local held_money = G.GAME and G.GAME.dollars or 0
        local extra_mult = 0.15 * math.floor(held_money / 20)
        local multiplier = 1.5 + extra_mult

        if not self.base_cost then
            self.base_cost = self.cost or 0
        end

        self.cost = math.floor(self.base_cost * multiplier)
    end
end