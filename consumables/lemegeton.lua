SMODS.Consumable {
    atlas = "tainted_atlas",
    pos = { x = 4, y = 0 },
    unlocked = true,
    discovered = true,
    key = "lemegeton",
    set = "taintedcards",
    eternal_compat = true,

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.e_tdec_frailty
        return { vars = { G.GAME.LemegetonCharges or 0 } }
    end,

    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval and G.GAME.LemegetonCharges < 8 then
            G.GAME.LemegetonCharges = G.GAME.LemegetonCharges + G.GAME.current_round.hands_left
            if G.GAME.LemegetonCharges > 8 then
                G.GAME.LemegetonCharges = 8
            end
        end

        if context.end_of_round and context.main_eval and G.GAME.LemegetonCharges >= 4 and not G.GAME.LemegetonMessageCheck then
            G.GAME.LemegetonMessageCheck = true
            return { message = "Charged" }
        end
    end,

    keep_on_use = function(self)
        return true
    end,

    can_use = function(self, card)
        if G.GAME.LemegetonCharges >= 3 and G.GAME.FrailtyCount < 5 then
            return true
        end
    end,

    use = function(self, card, area, copier)
        G.GAME.LemegetonCharges = G.GAME.LemegetonCharges - 3
        G.GAME.LemegetonMessageCheck = false
        G.E_MANAGER:add_event(Event({
            trigger = "after",
            func = function()
                local c = SMODS.create_card {
                    set = "Joker",
                    key_append = "created_by_lemegeton",
                    edition = "e_tdec_frailty"
                }
                c.is_crafted = true
                G.jokers:emplace(c)
                c:add_to_deck()
                return true
            end
        }))
    end,

    in_pool = function(self)
        return false
    end,
}

local start_run_refdebug = Game.start_run
function Game:start_run(args)
    start_run_refdebug(self, args)
    if not G.GAME.LEMEGETONLOADED then
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.LEMEGETONLOADED = true
                G.GAME.LemegetonCharges = 1
                G.GAME.LemegetonMessageCheck = false
                return true
            end
        }))
    end
end

SMODS.Edition({
    key = "frailty",
    shader = false,
    disable_shadow = false,
    disable_base_shader = false,
    discovered = true,
    unlocked = true,
    config = { card_limit = 1 },

    on_apply = function(card)
        card.children.particles_frailty = Particles(1, 1, 0, 0, {
            timer = 0.06,
            scale = 0.15,
            speed = 0.6,
            lifespan = 1.5,
            attach = card,
            colours = { G.C.PURPLE, lighten(G.C.PURPLE, 0.15), darken(G.C.PURPLE, 0.2) },
            fill = true
        })
    end,
    on_load = function(card)
        card.children.particles_frailty = Particles(1, 1, 0, 0, {
            timer = 0.06,
            scale = 0.15,
            speed = 0.6,
            lifespan = 1.5,
            attach = card,
            colours = { G.C.PURPLE, G.C.RED, lighten(G.C.PURPLE, 0.15), lighten(G.C.RED, 0.2) },
            fill = true
        })
    end,
    in_pool = function(self)
        return false
    end,
    on_remove = function(card)
        card.children.particles_frailty:remove()
    end,
    apply_to_float = true,
})
