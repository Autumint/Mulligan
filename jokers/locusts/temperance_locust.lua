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
        if card.config and card.config.center and card.config.center.key == "j_tdec_grateful_locust" then
            remove_sell_button(m)
        end
        return m
    end
end


SMODS.Joker {
    key = "grateful_locust",
    atlas = "tainted_atlas",
    blueprint_compat = true,
    perishable_compat = false,
    rarity = 1,
    cost = 0,
    pos = { x = 0, y = 0 },
    no_collection = true,
    unlocked = true,
    discovered = true,
    config = { extra = { size = 1, sell_value = 1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.size, card.ability.extra.sell_value } }
    end,

    calculate = function(self, card, context)
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            local pool = {}
            for _, j in ipairs(G.jokers.cards) do
                if j ~= card then
                    pool[#pool + 1] = j
                end
            end
            if #pool > 0 then
                local target = pseudorandom_element(pool, card.key)
                if target.set_cost then
                    target.sell_cost = (target.sell_cost or 0) + card.ability.extra.sell_value
                end
            end
            return {
                message = localize('k_val_up'),
                colour = G.C.MONEY
            }
        end
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
}