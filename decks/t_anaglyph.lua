SMODS.Back{
    original = "b_anaglyph",
    key   = "tainted_anaglyph",    
    atlas = "tainted_atlas",
    pos   = { x = 5, y = 1 },
    unlocked = true,
    discovered = true,
    apply = function(self)
        G.GAME.modifiers.tainted_anaglyph = true
        G.GAME.FervencyCounter = 100
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            func = function()
                if G.pactive_area then
                    local c = create_card("taintedcards", G.pactive_area, nil, nil, nil, nil, "c_tdec_fervency")
                    c:add_to_deck()
                    table.insert(G.pactive_area.cards, c)
                    c.area = G.pactive_area
                    c:align()
                end
                return true
            end
        }))
    end,
}

local skip_blind_ref = G.FUNCS.skip_blind
G.FUNCS.skip_blind = function(e)
if G.GAME and G.GAME.selected_back and G.GAME.modifiers.tainted_anaglyph then
    G.GAME.ChallengedBlind = true
    G.GAME.FervencyCounter = G.GAME.FervencyCounter + 20
    if G.GAME.FervencyCounter > 100 then
        G.GAME.FervencyCounter = 100
    end
end
    if G.GAME and G.GAME.selected_back and G.GAME.modifiers.tainted_anaglyph then
        e.config.ref_table = e.UIBox:get_UIE_by_ID('select_blind_button').config.ref_table
        G.GAME.skips = (G.GAME.skips or 0) + 1

        
        local tag_key
        local _tag = e.UIBox:get_UIE_by_ID('tag_container')
        if _tag and _tag.config and _tag.config.ref_table and _tag.config.ref_table.key then
            tag_key = _tag.config.ref_table.key
        end

        G.GAME.tainted_anaglyph_scaled = true

        local ret = G.FUNCS.select_blind(e)
        if tag_key then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                func = function()
                    local new_tag = Tag(tag_key)
                    if new_tag then
                        add_tag(new_tag)
                    end
                    return true
                end
            }))
        end
        if tag_key then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                func = function()
                    local new_tag = Tag(tag_key)
                    if new_tag then
                        add_tag(new_tag)
                    end
                    return true
                end
            }))
        end

        return ret
    end
    return skip_blind_ref(e)
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