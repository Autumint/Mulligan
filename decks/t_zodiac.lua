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
        if card.config and card.config.center and card.config.center.key == "j_tdec_tainted_madness" then
            remove_sell_button(m)
        end
        return m
    end
end

SMODS.Joker {
    key = "tainted_madness",
    atlas = "madness_atlas",
    allow_duplicates = false,
    rarity = 1,
    cost = 1,
    pos = { x = 0, y = 0 },
    eternal_compat = true,
    blueprint_compat = false,
    config = { extra = { every = 3, count = 0, armed = false } },

    in_pool = function(self, args)
        return false
    end,

    calculate = function(self, card, context)
        if context.check_eternal then return { no_destroy = true } end
        if (G.GAME.round_resets and G.GAME.round_resets.ante or 0) < 2 then
            return {}
        end

        if context.setting_blind then
            card.ability.extra.count = 0
            card.ability.extra.armed = false
        end

        if context.joker_main then
            card.ability.extra.count = card.ability.extra.count + 1
            if card.ability.extra.count >= card.ability.extra.every then
                if not card.ability.extra.armed then
                    local eval = function(c) return card.ability.extra.armed and not G.RESET_JIGGLES end
                    juice_card_until(card, eval, true)
                end
                card.ability.extra.armed = true
            end
        end

        if context.end_of_round and not context.blueprint and card.ability.extra.armed then
            local pool = {}
            for _, j in ipairs(G.jokers.cards) do
                if j ~= card and not j.getting_sliced and not SMODS.is_eternal(j) then
                    pool[#pool + 1] = j
                end
            end

            if #pool > 0 then
                local target = pseudorandom_element(pool, card.key)
                target.getting_sliced = true
                G.E_MANAGER:add_event(Event({
                    func = function()
                        card:juice_up(0.8, 0.8)
                        target:start_dissolve({ G.C.RED }, nil, 1.6)
                        return true
                    end
                }))
            end

            card.ability.extra.count = 0
            card.ability.extra.armed = false
        end
    end
}

SMODS.Back {
    original = "b_zodiac",
    key = "tainted_zodiac",
    atlas = "tainted_atlas",
    pos = { x = 6, y = 1 },
    unlocked = true,
    discovered = true,
    config = {
        jokers = { "j_tdec_tainted_madness" },
        vouchers = { "v_overstock_norm", "v_reroll_surplus" },
        joker_slot = 1
    },
    apply = function(self)
        SMODS.change_booster_limit(1)
    end
}
