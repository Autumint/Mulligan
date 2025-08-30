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
        if card.config and card.config.center and card.config.center.key == "j_tdec_dried_joker" then
            remove_sell_button(m)
        end
        return m
    end
end

SMODS.Back{
    original = "b_painted",
    key = "tainted_painted",
    atlas = "tainted_atlas",
    pos = {x = 4, y = 1},
    config = { joker_slot = -2, consumable_slot = 2 },

    apply = function(self)
        G.E_MANAGER:add_event(Event({
        trigger = 'after',
        func = function()
            local c = create_card("taintedcards", G.consumeables, nil, nil, nil, nil, "c_tdec_thechisel") 
            c:add_to_deck()
            G.consumeables:emplace(c)  
            return true
        end}))
     G.E_MANAGER:add_event(Event({
        trigger = 'after',
        func = function()
            local c = create_card("taintedcards", G.consumeables, nil, nil, nil, nil, "c_tdec_thesketch") 
            c:add_to_deck()
            G.consumeables:emplace(c)  
            return true
        end}))
    end
}

SMODS.Joker {
    key = "dried_joker",
    atlas = "tainted_atlas",
    pos = {x = 4, y = 1},
    blueprint_compat = true,
    perishable_compat = false,
    rarity = 1,
    cost = 5,
    config = { extra = { size = 1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.size } }
    end,

    add_to_deck = function(self, card, from_debuff)
        G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.extra.size
    end,
    in_pool = function(self)
        return false
    end,


}

SMODS.Sticker {
    key = "Eroding",
    badge_colour = HEX '895129',
    pos = { x = 0, y = 2 },

    should_apply = function(self, card, center, area, bypass_roll)
        return card.ability
            and card.ability.set == "Joker"
            and G.GAME.selected_back
            and G.GAME.selected_back.effect.center.key == "b_tdec_tainted_painted"
    end,

    apply = function(self, card, val)
        card.ability[self.key] = val
        if card.ability[self.key] then
            card.ability.perish_tally = G.GAME.perishable_rounds
        end
    end,

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.perishable_rounds or 5, card.ability.perish_tally or G.GAME.perishable_rounds } }
    end,

    calculate = function(self, card, context)
        if context.end_of_round and not context.repetition and not context.individual then
            card.ability.perish_tally = (card.ability.perish_tally or G.GAME.perishable_rounds) - 1

            if card.ability.perish_tally <= 0 then
                G.E_MANAGER:add_event(Event({
                    trigger = "before",
                    func = function()
                        card:flip()
                        return true
                    end
                }))
                G.E_MANAGER:add_event(Event({
                    func = function()
                        if not G.GAME._tdec_erratic_sound_played then
                            G.GAME._tdec_erratic_sound_played = true
                        if card.ability and card.ability.tdec_Eroding then
                            card.ability.tdec_Eroding = nil
                        end
                    end
                        card:set_ability("j_tdec_dried_joker")
                        return true
                    end
                }))
                card.ability.perish_tally = G.GAME.perishable_rounds
            end
        end
    end
}

