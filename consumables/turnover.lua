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

    can_use = function(self, card)
        if G.GAME.dollars >= 10 and G.STATE == 7 or G.STATE == 1 then
            return true
        end
    end,

    use = function(self, card)
        ease_dollars(-10)

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            blockable = false,
            blocking = false,
            delay = 2,
            func = function()
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

                G.GAME.shop_free = nil
                G.GAME.shop_d6ed = nil
                G.GAME.current_round.jokers_purchased = 0

                return true
            end
        }))

        local toggle_shopref = G.FUNCS.toggle_shop
        function G.FUNCS.toggle_shop(e)
            if G.GAME.TAINTED_SHOP_STATE then
                stop_use()
                G.CONTROLLER.locks.toggle_shop = true
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.5,
                    func = function()
                        G.shop:remove()
                        G.shop = nil
                        G.SHOP_SIGN:remove()
                        G.SHOP_SIGN = nil
                        G.STATE_COMPLETE = false
                        G.STATE = G.GAME.TAINTED_SHOP_STATE
                        G.CONTROLLER.locks.toggle_shop = nil
                        return true
                    end
                }))
            else
                toggle_shopref(e)
            end
        end
    end,

    keep_on_use = function(self, card)
        return true
    end,

    in_pool = function(self)
        return false
    end
}