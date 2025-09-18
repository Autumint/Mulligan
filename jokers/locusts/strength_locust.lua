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
        if card.config and card.config.center and card.config.center.key == "j_tdec_powerful_locust" then
            remove_sell_button(m)
        end
        return m
    end
end

SMODS.Joker {
    key = "powerful_locust",
    atlas = "tainted_atlas",
    rarity = 3,
    cost = 0,
    pos = { x = 0, y = 0 },
    no_collection = true,
    unlocked = true,
    discovered = true,
    config = { extra = { mult = 1, chips = 5, size = 1 } },

    in_pool = function(self)
        return false
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            local count = 0
            if G.locust_area and G.locust_area.cards then
                for _, j in ipairs(G.locust_area.cards) do
                    if j.config and j.config.center and j.config.center.key
                        and j.config.center.key:match("^j_tdec.*locust$") then
                        count = count + 1
                    end
                end
            end
            if count > 0 then
                return {
                    mult  = card.ability.extra.mult * count,
                    chips = card.ability.extra.chips * count
                }
            end
        end
    end,

    loc_vars = function(self, info_queue, card)
        local count = 0
        if G.jokers and G.locust_area then
            for _, j in ipairs(G.locust_area.cards) do
                if j.config and j.config.center and j.config.center.key
                    and j.config.center.key:match("^j_tdec.*locust$") then
                    count = count + 1
                end
            end
        end
        return { vars = { card.ability.extra.mult, card.ability.extra.chips, card.ability.extra.size, math.floor(card.ability.extra.mult * count), math.floor(card.ability.extra.chips * count) } }
    end,


    add_to_deck = function(self, card, from_debuff)
        if G and G.jokers and G.jokers.config then
            G.locust_area.config.card_limit = G.locust_area.config.card_limit + card.ability.extra.size
        end
    end,

    remove_from_deck = function(self, card, from_debuff)
        if G and G.jokers and G.jokers.config then
            G.locust_area.config.card_limit = G.locust_area.config.card_limit - card.ability.extra.size
        end
    end,
}

