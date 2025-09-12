SMODS.Consumable {
    atlas = "tainted_atlas",
    pos = { x = 1, y = 1 },
    unlocked = true,
    key = "flip_card",
    set = "taintedcards",
    cost = 4,
    rarity = 1,
    loc_vars = function(self, info_queue, card)
        return { vars = { G.GAME.FlipCharges or 0 } }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval and G.GAME.FlipCharges ~= 5 then
            G.GAME.FlipCharges = G.GAME.FlipCharges + 1
        end
        if context.end_of_round and G.GAME.FlipCharges == 5 and not G.GAME.FlipMessageCheck then
            G.GAME.FlipMessageCheck = true
            return {
                message = "Resurrection?"
            }
        end
    end,
    keep_on_use = function(self)
        return true
    end,
    can_use = function(self, card)
        return G.GAME.FlipCharges >= 5
    end,
    use = function(self, card, area, copier)
        G.GAME.FlipMessageCheck = false
        G.GAME.FlipCharges = 0
        return do_flip()
    end,
    in_pool = function(self)
        return false
    end
}

local start_run_refflip = Game.start_run
function Game:start_run(args)
    start_run_refflip(self, args)
    G.E_MANAGER:add_event(Event({
        func = function()
            G.GAME.FlipCharges = 1
            G.GAME.FlipMessageCheck = false
            return true
        end
    }))
end
