SMODS.Back {
    original = "b_zodiac",
    key = "tainted_zodiac",
    atlas = "tainted_atlas",
    pos = { x = 6, y = 1 },
    unlocked = true,
    discovered = true,
    config = {
        consumable_slot = 2,
        vouchers = { "v_overstock_norm", "v_tarot_merchant", "v_planet_merchant", "v_tarot_tycoon", "v_planet_tycoon" },
    },
    apply = function(self)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            func = function()
                if G.pactive_area then
                    local c = create_card("taintedcards", G.pactive_area, nil, nil, nil, nil, "c_tdec_bagofcrafting")
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
