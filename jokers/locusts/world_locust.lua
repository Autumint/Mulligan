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
        if card.config and card.config.center and card.config.center.key == "j_tdec_flint_locust" then
            remove_sell_button(m)
        end
        return m
    end
end


SMODS.Joker {
    key = "flint_locust",
    atlas = "tainted_atlas",
    blueprint_compat = true,
    perishable_compat = false,
    rarity = 1,
    cost = 0,
    pos = { x = 0, y = 0 },
    no_collection = true,
    unlocked = true,
    discovered = true,
    config = { extra = { size = 1, chips = 20 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.size, card.ability.extra.chips, 1 + card.ability.extra.chips * math.floor(G.GAME.Carvings or 0) } }
    end,
    calculate = function(self, card, context)
        if context.setting_blind then
            G.GAME.Carvings = 0
            return {
                message = "Carved Down",
                colour = G.C.BLUE
            }
        end
        if context.before then
            G.GAME.Carvings = G.GAME.Carvings + 1
        end
        if context.joker_main then
            return {
                chips = card.ability.extra.chips * G.GAME.Carvings
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