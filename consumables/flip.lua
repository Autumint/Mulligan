SMODS.Consumable {
    atlas = "Flip_Atlas",
    pos = { x = 0, y = 0 },
    unlocked = true,
    discovered = true,
    key = "flip_card",
    set = "taintedcards",

    loc_vars = function(self, info_queue, card)
        if not G.GAME or not G.GAME.TCFlip then
            return { vars = { 0 }, main_end = {} }
        end

        local inactive = (G.GAME.TCFlip.state == "Alive") and "Dead" or "Alive"
        local money = G.GAME.TCFlip.money[inactive] or 0
        local colour = (inactive == "Alive") and G.C.ORANGE or G.C.BLUE

        local nodes = {
            {
                n = G.UIT.C,
                config = { align = "cm", colour = colour, r = 0.02, padding = 0.1 },
                nodes = {
                    {
                        n = G.UIT.T,
                        config = {
                            text = inactive .. ": $" .. tostring(money),
                            colour = G.C.UI.TEXT_LIGHT,
                            scale = 0.3,
                            shadow = true
                        }
                    }
                }
            },
        }

        return {
            vars = { G.GAME.FlipCharges or 0 },
            main_end = {
                { n = G.UIT.C, config = { align = "bm", padding = 0.02 }, nodes = nodes }
            }
        }
    end,

    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval and G.GAME.FlipCharges ~= 3 then
            G.GAME.FlipCharges = G.GAME.FlipCharges + 1
        end
        if context.end_of_round and G.GAME.FlipCharges == 3 and not G.GAME.FlipMessageCheck then
            G.GAME.FlipMessageCheck = true
            return {
                message = "Resurrection?"
            }
        end
    end,

    keep_on_use = function(self) return true end,

    can_use = function(self, card)
        if G.GAME.FlipCharges >= 3 then
            return true
        end
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
    if not G.GAME.FLIPLOADED then
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.FLIPLOADED = true
                G.GAME.FlipCharges = 2
                G.GAME.FlipMessageCheck = false
                return true
            end
        }))
    end
end
