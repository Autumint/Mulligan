SMODS.Back{
    original = "b_yellow",
    key = "tainted_yellow",
    atlas = "tainted_atlas",
    pos = { x = 2, y = 0 },
    unlocked = true,
    discovered = true,
    config = {
		extra_hand_bonus = 1, extra_discard_bonus = 1, dollars = 6, consumable_slots = 1
	},
    apply = function(self)
        G.GAME.interest_amount = G.GAME.interest_amount + 1
        G.GAME.banned_keys["v_overstock"] = true
		SMODS.change_booster_limit(-1)
		SMODS.change_voucher_limit(-1)
		change_shop_size(-1)
        G.GAME.modifiers.tainted_yellow = true
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            func = function()
                if G.pactive_area then
                    local c = create_card("taintedcards", G.pactive_area, nil, nil, nil, nil, "c_tdec_turnover")
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
