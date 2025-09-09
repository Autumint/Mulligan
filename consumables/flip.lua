SMODS.Consumable{
    unlocked = true,
    key = "flip_card",
    set = "taintedcards",
    cost = 4,
    rarity = 1,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        return do_flip()
    end,
    in_pool = function(self)
        return false
    end
}

local t_check_dt = 0
local update_ref = Game.update
function Game:update(dt)
    update_ref(self, dt)
    t_check_dt = t_check_dt + dt
    if G.GAME.TCFlip and G.P_CENTERS and G.P_CENTERS.b_tdec_tainted_checkered and t_check_dt > 0.1 then
		t_check_dt = 0
		local obj = G.P_CENTERS.b_tdec_tainted_checkered
		if G.GAME.TCFlip.state ~= "Alive" then
            obj.pos.x = obj.pos.x + 1
            if obj.pos.x > 6 then obj.pos.x = 6 else
                update_tcheck_backs()
            end
		else
            obj.pos.x = obj.pos.x - 1
            if obj.pos.x < 0 then obj.pos.x = 0 else
                update_tcheck_backs()
            end
		end
        G.P_CENTERS.b_tdec_tainted_checkered = obj
	end
end