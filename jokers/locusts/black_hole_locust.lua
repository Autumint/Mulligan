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
        if card.config and card.config.center and card.config.center.key == "j_tdec_singularity_locust" then
            remove_sell_button(m)
        end
        return m
    end
end


SMODS.Joker {
    key = "singularity_locust",
    atlas = "tainted_atlas",
    blueprint_compat = true,
    perishable_compat = false,
    rarity = 4,
    cost = 0,
    pos = { x = 0, y = 0 },
    no_collection = true,
    unlocked = true,
    discovered = true,
    config = { extra = { size = 1, used_this_round = false } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.size } }
    end,

    add_to_deck = function(self, card, from_debuff)
        G.locust_area.config.card_limit = G.locust_area.config.card_limit + card.ability.extra.size
    end,

    remove_from_deck = function(self, card, from_debuff)
        G.locust_area.config.card_limit = G.locust_area.config.card_limit - card.ability.extra.size
    end,

    calculate = function(self, card, context)
        if context.before and G.GAME.current_round.hands_played <= 0 then
            return {
                level_up = true,
                message = localize('k_level_up_ex')
            }
        end
    end,


    in_pool = function(self)
        return false
    end,

}
