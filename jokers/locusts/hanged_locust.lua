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
        if card.config and card.config.center and card.config.center.key == "j_tdec_executioner_locust" then
            remove_sell_button(m)
        end
        return m
    end
end


SMODS.Joker{
    key = "executioner_locust",
    atlas = "tainted_atlas",
    blueprint_compat = true,
    perishable_compat = false,
    rarity = 1,
    cost = 0,
    pos = { x = 0, y = 0 },
    config = { extra = { size = 1, mult = 2, mult_gain = 2 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.size, card.ability.extra.mult_gain, card.ability.extra.mult } }
    end,

    add_to_deck = function(self, card, from_debuff)
        G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.extra.size
    end,

    remove_from_deck = function(self, card, from_debuff)
        G.jokers.config.card_limit = G.jokers.config.card_limit - card.ability.extra.size
    end,

    calculate = function(self, card, context)
        if context.remove_playing_cards and not context.blueprint then
            local removed_count = #context.removed
            if removed_count > 0 then
                card.ability.extra.mult = card.ability.extra.mult + removed_count * card.ability.extra.mult_gain
                return { message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } } }
            end
        end
        if context.joker_main then
            return { mult = card.ability.extra.mult }
        end
    end,
}