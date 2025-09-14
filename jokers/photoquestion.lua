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
        if context.check_eternal then return {no_destroy  = true} end
        if context.modify_ante then
            print("att")
            return { modify = -2 }
        end
    end
}
