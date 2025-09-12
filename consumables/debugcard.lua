SMODS.Consumable {
    atlas = "debugcard_atlas",
    pos = { x = 0, y = 0 },
    unlocked = true,
    key = "debugcard",
    set = "taintedcards",
    eternal_compat = true,
    rarity = 1,

    loc_vars = function(self, info_queue, card)
        return { vars = { G.GAME.DebugRounds } }
    end,

    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval and G.GAME.DebugRounds < 3 then
            G.GAME.DebugRounds = G.GAME.DebugRounds + 1
        end

        if context.end_of_round and context.main_eval and G.GAME.DebugRounds >= 3 then
            G.GAME.DebugMessageCheck = true
            return { message = "DBG_ACTIVE?" }
        end
    end,

    keep_on_use = function(self) 
        return true 
    end,

    can_use = function(self, card)
        if #G.jokers.highlighted > 0 then
            for _, j in ipairs(G.jokers.highlighted) do
                if j.ability and j.ability.tdec_tainted_perish then
                    return true
                end
            end
        end
    end,

    use = function(self, card, area, copier)
        play_sound('tdec_erratic_bug1')
        G.GAME.DebugRounds = 0
        G.GAME.DebugMessageCheck = false

        for _, j in ipairs(G.jokers.highlighted) do
            if j.ability and j.ability.tdec_tainted_perish then
                j.ability.tdec_tainted_perish = nil
            end
        end
    end,

    in_pool = function(self)
        return false
    end,
}

local start_run_refdebug = Game.start_run
function Game:start_run(args)
    start_run_refdebug(self, args)
    G.E_MANAGER:add_event(Event({
        func = function()
            G.GAME.DebugRounds = 1
            G.GAME.DebugMessageCheck = false
            return true
        end
    }))
end