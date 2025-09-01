SMODS.Back{
    original = "b_yellow",
    key = "tainted_yellow",
    atlas = "tainted_atlas",
    pos = { x = 2, y = 0 },
    unlocked = true,
    discovered = true,
    config = {
		extra_hand_bonus = 1, extra_discard_bonus = 1
	},
    apply = function(self)
		SMODS.change_booster_limit(-1)
		SMODS.change_voucher_limit(-1)
		change_shop_size(-1)
        G.GAME.modifiers.tainted_yellow = true
        G.E_MANAGER:add_event(Event({
        trigger = 'after',
        func = function()
            local c = create_card("taintedcards", G.consumeables, nil, nil, nil, nil, "c_tdec_turnover") 
            c:add_to_deck()
            G.consumeables:emplace(c)  
            return true
        end}))
    end,

    calculate = function(self, back, context)
        if context.skip_blind then
			G.E_MANAGER:add_event(Event({
				trigger = 'before', delay = 0.2,
				func = function()
				  G.blind_prompt_box.alignment.offset.y = -10
				  G.blind_select.alignment.offset.y = 40
				  G.blind_select.alignment.offset.x = 0
				  return true
			end}))
			G.E_MANAGER:add_event(Event({
			trigger = 'immediate',
			func = function()
				G.blind_select:remove()
				G.blind_prompt_box:remove()
				G.blind_select = nil
				return true
			end}))
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = .9,
				func = function()

					G.GAME.current_round.jokers_purchased = 0
					G.STATE = G.STATES.SHOP
					G.GAME.shop_free = nil
					G.GAME.shop_d6ed = nil
					G.STATE_COMPLETE = false
					
					return true
				end,
			}))
		end
    end,
}