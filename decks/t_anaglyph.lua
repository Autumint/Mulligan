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

        G.GAME.tainted_anaglyph_scaled = true

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

local set_blind_ref = Blind.set_blind
function Blind:set_blind(blind, reset, silent)
    set_blind_ref(self, blind, reset, silent)

    if G.GAME and G.GAME.tainted_anaglyph_scaled then
        G.GAME.tainted_anaglyph_scaled = nil

        if G.GAME.blind and G.GAME.blind.chips then
            G.GAME.blind.chips = G.GAME.blind.chips * 1.5
            G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
            G.HUD_blind:recalculate() 
        end
    end
end