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

    loc_vars = function(self, info_queue, card)
        if not G.GAME then 
            return { vars = {0}, main_end = {} } 
        end

        local nodes
        if G.GAME.TAINTED_SHOP_STATE then
            local lvl = G.GAME.TAINTED_SHOP_LEVEL or 0
            local display = (lvl == 3) and "Max" or tostring(lvl)

            nodes = {
                { n = G.UIT.C, config = { align = "m", colour = G.C.MONEY, r = 0.05, padding = 0.05 }, nodes = {
                    { n = G.UIT.T, config = { text = ' Shop Level: ' .. display .. ' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.3, shadow = true } }
                }}
            }
            return { vars = { display }, main_end = { { n = G.UIT.C, config = { align = "bm", padding = 0.02 }, nodes = nodes } } }
        else
            nodes = {
                { n = G.UIT.C, config = { align = "m", colour = G.C.RED, r = 0.05, padding = 0.05 }, nodes = {
                    { n = G.UIT.T, config = { text = ' No Active Shop ', colour = G.C.UI.TEXT_LIGHT, scale = 0.3, shadow = true } }
                }}
            }
            return { vars = { "None" }, main_end = { { n = G.UIT.C, config = { align = "bm", padding = 0.02 }, nodes = nodes } } }
        end
    end,

    can_use = function(self, card)
        if G.GAME.dollars >= 10 and G.STATE ~= 999 and G.STATE ~= 8 and G.GAME.TAINTED_SHOP_LEVEL ~= 3 then
            return true
        end
    end,

    use = function(self, card)
        ease_dollars(-10)
        if G.GAME.TAINTED_SHOP_STATE then
            G.GAME.TAINTED_SHOP_LEVEL = (G.GAME.TAINTED_SHOP_LEVEL or 0) + 1
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                blockable = false,
                func = function()
                    local lvl = G.GAME.TAINTED_SHOP_LEVEL
                    if lvl == 1 then
                        SMODS.change_booster_limit(1)
                        SMODS.change_voucher_limit(1)
                    elseif lvl == 2 then
                        SMODS.change_booster_limit(1)
                        change_shop_size(1)
                    elseif lvl == 3 then
                        change_shop_size(1)
                        SMODS.change_booster_limit(1)
                        SMODS.change_voucher_limit(1)
                    end
                    return true
                end
            }))
            return
        end

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            blockable = false,
            blocking = false,
            delay = 1,
            func = function()
                G.GAME.TAINTED_SHOP_STATE = G.STATE
                G.GAME.TAINTED_SHOP_LEVEL = 0
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

                local toggle_shopref = G.FUNCS.toggle_shop
                G.FUNCS.toggle_shop = function(e)
                    if G.GAME.TAINTED_SHOP_STATE then
                        stop_use()
                        G.CONTROLLER.locks.toggle_shop = true
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.5,
                            func = function()
                                SMODS.change_booster_limit((-(G.GAME.modifiers.extra_boosters or 0)-2)+1)
                                change_shop_size((-G.GAME.shop.joker_max)+1)
                                G.shop:remove()
                                G.shop = nil
                                G.SHOP_SIGN:remove()
                                G.SHOP_SIGN = nil
                                G.STATE_COMPLETE = false
                                G.STATE = G.GAME.TAINTED_SHOP_STATE
                                G.GAME.TAINTED_SHOP_STATE = nil
                                G.GAME.TAINTED_SHOP_LEVEL = 0
                                G.GAME.TURNOVER_CHECK = false
                                G.FUNCS.toggle_shop = toggle_shopref 
                                G.CONTROLLER.locks.toggle_shop = nil
                                return true
                            end
                        }))
                    else
                        toggle_shopref(e)
                    end
                end

                return true
            end
        }))
    end,

    keep_on_use = function(self, card)
        return true
    end,

    in_pool = function(self)
        return false
    end
}