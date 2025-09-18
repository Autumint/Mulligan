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
        if card.config and card.config.center and card.config.center.key == "j_tdec_bloody_locust" then
            remove_sell_button(m)
        end
        return m
    end
end


SMODS.Joker {
    key = "bloody_locust",
    atlas = "tainted_atlas",
    blueprint_compat = true,
    perishable_compat = false,
    rarity = 2,
    cost = 0,
    pos = { x = 0, y = 0 },
    no_collection = true,
    unlocked = true,
    discovered = true,
    config = { extra = { size = 1, Xmult = 0.2, bloodlust = 0 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.size, card.ability.extra.Xmult, 1 + card.ability.extra.Xmult * math.floor(card.ability.extra.bloodlust) } }
    end,

    calculate = function(self, card, context)
        if context.setting_blind then
            card.ability.extra.bloodlust = 0
            return {
                message = "More!",
                colour = G.C.RED
            }
        end
        if context.before then
            card.ability.extra.bloodlust = card.ability.extra.bloodlust+ 1
        end
        if context.joker_main then
            return {
                xmult = 1 + (card.ability.extra.Xmult * card.ability.extra.bloodlust)
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