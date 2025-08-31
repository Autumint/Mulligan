SMODS.Back{
    original = "b_yellow",
    key = "tainted_yellow",
    atlas = "tainted_atlas",
    pos = { x = 2, y = 0 },
    unlocked = true,
    discovered = true,
    config = {},
    apply = function(self)
        G.GAME.modifiers.tainted_yellow = true
        G.E_MANAGER:add_event(Event({
        trigger = 'after',
        func = function()
            local c = create_card("taintedcards", G.consumeables, nil, nil, nil, nil, "c_tdec_turnover") 
            c:add_to_deck()
            G.consumeables:emplace(c)  
            return true
        end}))
    end
}

