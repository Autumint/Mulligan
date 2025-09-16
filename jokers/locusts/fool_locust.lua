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
        if card.config and card.config.center and card.config.center.key == "j_tdec_foolish_locust" then
            remove_sell_button(m)
        end
        return m
    end
end

SMODS.Joker {
    key = "foolish_locust",
    atlas = "tainted_atlas",
    rarity = 3,
    cost = 0,
    pos = { x = 0, y = 0 },
    config = { extra = { size = 1 }},
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.size } }
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
        local other_joker
        for i = 1, #G.locust_area.cards do
            if G.locust_area.cards[i] == card then
                other_joker = G.locust_area.cards[i + 1]
                break
            end
        end

        if other_joker
        and other_joker.config
        and other_joker.config.center
        and other_joker.config.center.key
        and other_joker.config.center.key:match("^j_tdec.*locust$") then
            return SMODS.blueprint_effect(card, other_joker, context)
        end
    end
}