SMODS.Back{
    original = "b_nebula",
    key = "tainted_nebula",
    atlas = "tainted_atlas",
    pos = {x = 2, y = 0},
    unlocked = true,
    discovered = true,
    config = { consumable_slots = -1 },

    apply = function(self, card)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            func = function()
                if G.pactive_area then
                    local c = create_card("taintedcards", G.pactive_area, nil, nil, nil, nil, "c_tdec_abyss")
                    c:add_to_deck()
                    table.insert(G.pactive_area.cards, c)
                    c.area = G.pactive_area
                    c:align()
                end
                return true
            end
        }))
    end
}