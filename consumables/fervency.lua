SMODS.Consumable {
    set = "taintedcards",
    atlas = "tainted_atlas",
    unlocked = true,
    key = 'fervency',
    pos = { x = 5, y = 1 },

    loc_vars = function(self, info_queue, card)
        if not G.GAME then
            return { vars = { 50 }, main_end = {} }
        end

        local state = G.GAME.FervencyState or "Cooling"
        local colour = (state == "Cooling") and G.C.BLUE or G.C.RED

        local nodes = {
            {
                n = G.UIT.C,
                config = { align = "cm", colour = colour, r = 0.02, padding = 0.1 },
                nodes = {
                    {
                        n = G.UIT.T,
                        config = {
                            text = state,
                            colour = G.C.UI.TEXT_LIGHT,
                            scale = 0.3,
                            shadow = true
                        }
                    }
                }
            },
        }

        return {
            vars = { G.GAME.FervencyCounter or 50 },
            main_end = {
                { n = G.UIT.C, config = { align = "bm", padding = 0.02 }, nodes = nodes }
            }
        }
    end,

    in_pool = function(self) return false end,

    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval then
            if G.GAME.FervencyState == "Cooling" then
                G.GAME.FervencyCounter = G.GAME.FervencyCounter - 5
            else
                G.GAME.FervencyCounter = G.GAME.FervencyCounter + 5
            end
        end
        if context.buying_card or context.reroll_shop or context.open_booster then
            if G.GAME.FervencyState == "Cooling" then
                G.GAME.FervencyCounter = G.GAME.FervencyCounter - 2
            else
                G.GAME.FervencyCounter = G.GAME.FervencyCounter + 2
            end
        end
        if context.before or (context.discard and context.other_card == context.full_hand[#context.full_hand]) then
            if G.GAME.FervencyState == "Cooling" then
                G.GAME.FervencyCounter = G.GAME.FervencyCounter - 1
            else
                G.GAME.FervencyCounter = G.GAME.FervencyCounter + 1
            end
        end

        if G.GAME.FervencyCounter <= 0 or G.GAME.FervencyCounter >= 100 then
            G.GAME.FervencyCounter = math.max(0, math.min(G.GAME.FervencyCounter, 100))
            G.E_MANAGER:add_event(Event({
                blockable = false,
                trigger = 'after',
                func = function()
                    G.STATE = G.STATES.GAME_OVER
                    if not G.GAME.won and not G.GAME.seeded and not G.GAME.challenge then
                        G.PROFILES[G.SETTINGS.profile].high_scores.current_streak.amt = 0
                    end
                    G:save_settings()
                    G.FILE_HANDLER.force = true
                    G.STATE_COMPLETE = false
                    G.SETTINGS.paused = false
                    return true
                end
            }))
        end
        if context.final_scoring_step and (G.GAME.FervencyCounter < 40 or G.GAME.FervencyCounter > 60) then
            local xmultred = 1 -
                (((G.GAME.FervencyCounter < 40) and (40 - G.GAME.FervencyCounter) or (G.GAME.FervencyCounter - 60)) * 0.015)
            return { xmult = xmultred }
        end
        if context.starting_shop then
            G.GAME.ChallengedBlind = false
        end
    end
}

local start_run_refferv = Game.start_run
function Game:start_run(args)
    G.GAME.FervencyCounter = 50
    G.GAME.FervencyState = "Cooling"
    start_run_refferv(self, args)
end

local ferv_timer1, ferv_timer2 = 0, 0
local old_update = Game.update


local timer1, timer2, timer3, timer4 = 0, 0, 0, 0
local old_update = Game.update

function Game:update(dt)
    old_update(self, dt)

    if G.GAME.FervencyCounter then
        if G.GAME.FervencyCounter <= 40 and G.GAME.FervencyCounter > 20 then
            timer1 = timer1 + dt
            if timer1 >= 1 then
                play_sound('tdec_hbeat1')
                timer1 = 0
            end
        end
        if G.GAME.FervencyCounter <= 20 then
            timer2 = timer2 + dt
            if timer2 >= 0.45 then
                play_sound('tdec_hbeat2')
                timer2 = 0
            end
        end
        if G.GAME.FervencyCounter then
            if G.GAME.FervencyCounter >= 60 and G.GAME.FervencyCounter < 80 then
                timer3 = timer3 + dt
                if timer3 >= 1 then
                    play_sound('tdec_hbeat1')
                    timer3 = 0
                end
            end
            if G.GAME.FervencyCounter >= 80 then
                timer4 = timer4 + dt
                if timer4 >= 0.45 then
                    play_sound('tdec_hbeat2')
                    timer4 = 0
                end
            end
        end
    end
end

local start_run_refferv = Game.start_run
function Game:start_run(args)
    start_run_refferv(self, args)
    if not G.GAME.FERVENCYLOADED then
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.FERVENCYLOADED = true
                G.GAME.FervencyCounter = 50
                G.GAME.FervencyState = "Cooling"

                return true
            end
        }))
    end
end
