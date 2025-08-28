SMODS.Back{
    original = "b_anaglyph",
    key   = "tainted_anaglyph",    
    atlas = "tainted_atlas",
    pos   = { x = 5, y = 1 },
    unlocked = true,
    discovered = true,
}

    local skip_blind_ref = G.FUNCS.skip_blind
G.FUNCS.skip_blind = function(e)
    if G.GAME and G.GAME.selected_back and G.GAME.selected_back.effect.center.key == "b_tdec_tainted_anaglyph" then
        e.config.ref_table = e.UIBox:get_UIE_by_ID('select_blind_button').config.ref_table
        return G.FUNCS.select_blind(e)
    end
    return skip_blind_ref(e)
end


