SMODS.Back{
    original = "b_nebula",
    key = "tainted_nebula",
    atlas = "tainted_atlas",
    pos = {x = 2, y = 0},
    config = {},

    apply = function(self, card)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            func = function()
                if G.consumeables then
                    local c = create_card("taintedcards", G.consumeables, nil, nil, nil, nil, "c_tdec_abyss")
                    c:add_to_deck()
                    G.consumeables:emplace(c)
                end
                return true
            end
        }))
    end
}