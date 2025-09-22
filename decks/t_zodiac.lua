SMODS.Back {
    original = "b_zodiac",
    key = "tainted_zodiac",
    atlas = "tainted_atlas",
    pos = { x = 6, y = 1 },
    unlocked = true,
    discovered = true,
    config = {
        consumable_slot = 3,
        vouchers = { "v_overstock_norm", "v_tarot_merchant", "v_planet_merchant", "v_tarot_tycoon", "v_planet_tycoon" },
    },
    apply = function(self)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            func = function()
                if G.pactive_area then
                    local c = SMODS.create_card({key = "c_tdec_bagofcrafting", no_edition = true})
                    c:add_to_deck()
                    G.pactive_area:emplace(c)
                    c:align()
                    c:flip()
                end
                return true
            end
        }))
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.discount_percent = 25
                for _, v in pairs(G.I.CARD) do
                    if v.set_cost then v:set_cost() end
                end
                return true
            end
        }))
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.round_resets.reroll_cost = G.GAME.round_resets.reroll_cost - 2
                G.GAME.current_round.reroll_cost = math.max(0,
                    G.GAME.current_round.reroll_cost - 2)
                return true
            end
        }))
    end
}