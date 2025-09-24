SMODS.Back{
    original = "b_nebula",
    key = "tainted_nebula",
    atlas = "tainted_atlas",
    pos = {x = 0, y = 2},
    unlocked = true,
    discovered = true,
    config = { consumable_slot = -1 },

    apply = function(self, card)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            func = function()
                if G.pactive_area then
                    local c = SMODS.create_card({key = "c_tdec_abyss", no_edition = true})
                    c:add_to_deck()
                    G.pactive_area:emplace(c)
                    c:align()
                end
                return true
            end
        }))
    end
}