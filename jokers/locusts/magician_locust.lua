do
    local original_use_and_sell = G.UIDEF.use_and_sell_buttons

    local function remove_sell_button(node)
        if not node or not node.nodes then return end
        for i = #node.nodes, 1, -1 do
            local child = node.nodes[i]
            if child.config and child.config.button == "sell_card" then
                table.remove(node.nodes, i)
            else
                remove_sell_button(child)
            end
        end
    end

    function G.UIDEF.use_and_sell_buttons(card)
        local m = original_use_and_sell(card)
        if card.config and card.config.center and card.config.center.key == "j_tdec_lucky_locust" then
            remove_sell_button(m)
        end
        return m
    end
end


SMODS.Joker {
    key = "lucky_locust",
    atlas = "tainted_atlas",
    blueprint_compat = false,
    perishable_compat = false,
    rarity = 1,
    cost = 0,
    pos = { x = 0, y = 0 },
    no_collection = true,
    unlocked = true,
    discovered = true,
    config = { extra = { size = 1, mult = 15, dollars = 15, mult_odds = 6, dollars_odds = 20 } },

    loc_vars = function(self, info_queue, card)
        local mn, md = SMODS.get_probability_vars(card, 1, card.ability.extra.mult_odds, 'lucky_locust_mult')
        local dn, dd = SMODS.get_probability_vars(card, 1, card.ability.extra.dollars_odds, 'lucky_locust_money')
        return { vars = { mn, dn, card.ability.extra.mult, md, card.ability.extra.dollars, dd, card.ability.extra.size } }
    end,

    add_to_deck = function(self, card, from_debuff)
        G.locust_area.config.card_limit = G.locust_area.config.card_limit + card.ability.extra.size
    end,

    remove_from_deck = function(self, card, from_debuff)
        G.locust_area.config.card_limit = G.locust_area.config.card_limit - card.ability.extra.size
    end,

    in_pool = function(self)
        return false
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            local ret = {}

            if SMODS.pseudorandom_probability(card, 'lucky_locust_mult', 1, card.ability.extra.mult_odds) then
                card.lucky_trigger = true
                ret.mult = (ret.mult or 0) + card.ability.extra.mult
            end

            if SMODS.pseudorandom_probability(card, 'lucky_locust_money', 1, card.ability.extra.dollars_odds) then
                card.lucky_trigger = true
                ret.dollars = (ret.dollars or 0) + card.ability.extra.dollars
            end

            G.E_MANAGER:add_event(Event {
                func = function()
                    card.lucky_trigger = nil
                    return true
                end
            })

            return ret
        end
    end,
}

