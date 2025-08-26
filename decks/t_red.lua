SMODS.Back{
    original = "b_red",
    key   = "tainted_red",    
    atlas = "tainted_atlas",
    pos   = { x = 0, y = 0 },
    unlocked = true,
    discovered = true,
    config = {
        max_highlight = 7,
        hands = -2        
    },
    calculate = function(self, back, context)
        if context.pre_discard and #G.hand.highlighted == 1 then
            ease_hands_played(1)
        end
    end
}

local start_run_hook = G.start_run
function G.start_run(self, args)
    local ret = start_run_hook(self, args)
    if G.GAME.selected_back 
       and G.GAME.selected_back.effect.center.key == "b_tdec_tainted_red" then
        SMODS.change_discard_limit(2)
    end
    return ret
end

