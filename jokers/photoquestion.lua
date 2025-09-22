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
        if card.config and card.config.center and card.config.center.key == "j_tdec_photoquestion" then
            remove_sell_button(m)
        end
        return m
    end
end

SMODS.Joker {
    key = "photoquestion",
    blueprint_compat = false,
    perishable_compat = false,
    rarity = 1,
    cost = 1,
    config = { extra_slots_used = -1 },
    atlas = "Photo_Atlas",
    pos = { x = 0, y = 0 },
    pixel_size = { h = 95 / 1.2 },

    in_pool = function(self, args)
        return false
    end,

    apply = function(self, card)
        G.GAME.modifiers.ascent_started = true
    end,

    calculate = function(self, card, context)
        if G.GAME.round_resets.ante == 0 and context.setting_blind then
            G.GAME.modifiers.photoq_switch = true
            if G.GAME.selected_back.effect.center.key ~= "b_tdec_tainted_ghost" then
                G.GAME.round_resets.hands = G.GAME.round_resets.hands + 1
                ease_hands_played(1)
                return {
                    message = "+1 hands",
                    colour = G.C.BLUE
                }
            else
                return {
                    message = "Befallen Purge..",
                    colour = G.C.BLUE
                }
            end
        end

        if G.GAME.round_resets.ante == 0 and context.joker_main then
            if G.GAME.selected_back.effect.center.key ~= "b_tdec_tainted_ghost" then
                return { xmult = 1.5 }
            else
                return { xmult = 3 }
            end
        end

        if context.check_eternal and context.other_card == card then
            return { no_destroy = true }
        end

        if context.modify_ante then
            return { modify = -2 }
        end
    end
}

