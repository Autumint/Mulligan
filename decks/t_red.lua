SMODS.Back{
    original = "b_red",
    key   = "tainted_red",    
    atlas = "tainted_atlas",
    pos   = { x = 0, y = 0 },
    unlocked = true,
    discovered = true,
    config = {
        max_highlight_mod = 2,
        hands = -2        
    },
    apply = function(self)
        G.E_MANAGER:add_event(Event{
            func = function()
                SMODS.change_discard_limit(self.config.max_highlight_mod)
                return true
            end
        })
    end,
    calculate = function(self, back, context)
        if context.pre_discard and #G.hand.highlighted == 1 then
            ease_hands_played(1)
        end
    end
}