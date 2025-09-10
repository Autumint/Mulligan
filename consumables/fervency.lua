SMODS.Consumable {
    set = "taintedcards",
    atlas = "tainted_atlas",
    unlocked = true,
    key = 'fervency',
    pos = { x = 5, y = 1 },

    loc_vars = function(self, info_queue, card)
        return { vars = { G.GAME.FervencyCounter or 100 } }
    end,

    in_pool = function(self)
        return false
    end,

    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval and not G.GAME.ChallengedBlind then
            G.GAME.FervencyCounter = G.GAME.FervencyCounter - 5
        end

        if context.buying_card or context.reroll_shop or context.open_booster and not G.GAME.ChallengedBlind then
            G.GAME.FervencyCounter = G.GAME.FervencyCounter - 2
        end

        if (context.before or context.discard) and not G.GAME.ChallengedBlind then
            G.GAME.FervencyCounter = G.GAME.FervencyCounter - 1
        end

        if G.GAME.FervencyCounter <= 0 then
            G.STATE = G.STATES.GAME_OVER
        end

        if context.final_scoring_step and G.GAME.FervencyCounter <= 50 then
            local xmultred = 0.5 + (G.GAME.FervencyCounter * 0.01)
            return { xmult = xmultred }
        end
        if context.starting_shop then
            G.GAME.ChallengedBlind = false
        end
    end
}


local timer1, timer2, timer3 = 0, 0, 0
local old_update = Game.update

function Game:update(dt)
    old_update(self, dt)

    if G.GAME.FervencyCounter then
        if G.GAME.FervencyCounter <= 50 and G.GAME.FervencyCounter > 20 then
            timer1 = timer1 + dt
            if timer1 >= 1 then
                play_sound('tdec_hbeat1')
                timer1 = 0
            end
        end
        if G.GAME.FervencyCounter <= 20 then
            timer2 = timer2 + dt
            if timer2 >= 0.4 then
                play_sound('tdec_hbeat2')
                timer2 = 0
            end
        end
    end
end
