SMODS.Back{
    original = "b_anaglyph",
    key   = "tainted_anaglyph",    
    atlas = "tainted_atlas",
    pos   = { x = 5, y = 1 },
    unlocked = true,
    discovered = true,
    apply = function()
        G.GAME.modifiers.tainted_anaglyph = true
    end,
}

    local skip_blind_ref = G.FUNCS.skip_blind
G.FUNCS.skip_blind = function(e)
    if G.GAME and G.GAME.selected_back and G.GAME.modifiers.tainted_anaglyph then
        e.config.ref_table = e.UIBox:get_UIE_by_ID('select_blind_button').config.ref_table
        local _tag = e.UIBox:get_UIE_by_ID('tag_container')
        G.GAME.skips = (G.GAME.skips or 0) + 1
        if _tag then 
          add_tag(_tag.config.ref_table, true)
        end
        return G.FUNCS.select_blind(e)
    end
    return skip_blind_ref(e)
end

local add_tag_ref = add_tag
function add_tag(...)
    if G.GAME and G.GAME.modifiers.tainted_anaglyph then
        add_tag_ref(...)
    end
    return add_tag_ref(...)
end