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
        if card.config and card.config.center and card.config.center.key == "j_tdec_mitosis_locust" then
            remove_sell_button(m)
        end
        return m
    end
end

SMODS.Joker{
    key = "mitosis_locust",
    atlas = "tainted_atlas",
    blueprint_compat = true,
    perishable_compat = false,
    rarity = 3,
    cost = 0,
    pos = { x = 0, y = 0 },
    config = { extra = { size = 1, invis_rounds = 0, total_rounds = 3 }},
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.size, card.ability.extra.total_rounds, card.ability.extra.invis_rounds } }
    end,

    add_to_deck = function(self, card, from_debuff)
        G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.extra.size
    end,

    remove_from_deck = function(self, card, from_debuff)
        G.jokers.config.card_limit = G.jokers.config.card_limit - card.ability.extra.size
    end,

calculate = function(self, card, context)
    if context.end_of_round and not context.blueprint and not context.game_over
       and not context.individual and not context.repetition then

        card.ability.extra.invis_rounds = card.ability.extra.invis_rounds + 1

        if card.ability.extra.invis_rounds >= card.ability.extra.total_rounds then
            local locusts = {}
            for _, joker in ipairs(G.jokers.cards) do
                if joker ~= card
                and joker.config
                and joker.config.center
                and joker.config.center.key
                and joker.config.center.key:match("^j_tdec.*locust$") then
                    table.insert(locusts, joker)
                end
            end

            if #locusts > 0 then
                local chosen_joker = pseudorandom_element(locusts, 'mitosis_locust_copy')
                local copied_joker = copy_card(chosen_joker, nil, nil, nil,
                    chosen_joker.edition and chosen_joker.edition.negative)
                copied_joker:add_to_deck()
                G.jokers:emplace(copied_joker)
            end

            card:start_dissolve()
            return { message = "Mitosis!" }
        end

        return {
            message = (card.ability.extra.invis_rounds .. '/' .. card.ability.extra.total_rounds),
            colour = G.C.FILTER
        }
    end
end,
    in_pool = function(self)
        return false
    end,
}