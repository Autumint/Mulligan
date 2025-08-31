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
        if card.config and card.config.center and card.config.center.key == "c_tdec_turnover" then
            remove_sell_button(m)
        end
        return m
    end
end

SMODS.Consumable{
    atlas = "tainted_atlas",
    unlocked = true,
    key = 'turnover',
    set = 'taintedcards',
    pos = { x = 3, y = 0 },
    eternal_compat = true,

    use = function(self, card)
        G.GAME.TAINTED_SHOP_STATE = G.STATE
        G.STATE = G.STATES.SHOP
        G.STATE_COMPLETE = false
        if G.blind_select then        
            G.blind_select:remove()
            G.blind_prompt_box:remove()
        end
        if #G.hand.cards > 0 then
            local hand_count = #G.hand.cards
            for i = 1, hand_count do
                draw_card(G.hand, G.deck, i * 100 / hand_count, "down", nil, nil, 0.07)
            end
        end
        G.E_MANAGER:add_event(Event{
            trigger = 'immediate',
            func = function()
                G.GAME.shop_free = nil
                G.GAME.shop_d6ed = nil
                G.GAME.current_round.jokers_purchased = 0
                G.GAME.TAINTED_SHOP_STATE = G.STATE
                G.STATE = G.STATES.SHOP
                G.STATE_COMPLETE = false
                return true
            end
        })
    end,

    keep_on_use = function(self, card)
        return true
    end,

    in_pool = function(self)
        return false
    end,

    can_use = function(self, card)
        if G.GAME.dollars >= 15 and not G.GAME.in_blind then
            return true
        end
    end
}