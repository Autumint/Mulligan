local abyss_consumable_to_joker = {
    c_heirophant = "j_tdec_hierophant_locust",
    c_magician   = "j_tdec_lucky_locust",
    c_empress    = "j_tdec_empress_locust",
    c_hermit     = "j_tdec_wealthy_locust",
    c_fool       = "j_tdec_foolish_locust",
    c_strength   = "j_tdec_powerful_locust",
    c_soul       = "j_tdec_soulless_locust",
    c_hanged_man = "j_tdec_executioner_locust",
    c_talisman   = "j_tdec_golden_locust",
    c_black_hole = "j_tdec_singularity_locust",
    c_death      = "j_tdec_mitosis_locust",
    c_justice    = "j_tdec_fragile_locust",
    c_world      = "j_tdec_flint_locust",
    c_sun        = "j_tdec_bloody_locust",
    c_temperance = "j_tdec_grateful_locust",
    c_chariot    = "j_tdec_heavy_locust",
    c_moon       = "j_tdec_lunar_locust",
    c_emperor    = "j_tdec_spacious_locust"
}


do
    local orig_use = Card.use_consumeable
    function Card:use_consumeable(area, copier)
        if G.GAME.AbyssActive and self.ability.set ~= "Planet" then
            local used_key = self.config.center.key
            G.GAME.AbyssActive = false
            G.GAME.AbyssLastConsumable = used_key

            G.GAME.AbyssConsuming = true  

            local spawn_key = abyss_consumable_to_joker[used_key]
            if spawn_key then
                G.E_MANAGER:add_event(Event({
                    trigger = "after",
                    func = function()
                        local c = create_card("Joker", G.locust_area, nil, nil, nil, nil, spawn_key)
                        c:set_edition(nil)
                        c:add_to_deck()
                        G.locust_area:emplace(c)
                        c:juice_up(0.8, 0.8)
                        return true
                    end
                }))
            end

            G.E_MANAGER:add_event(Event({
                trigger = "after",
                func = function()
                    G.GAME.AbyssConsuming = false
                    return true
                end
            }))

            return
        end
        return orig_use(self, area, copier)
    end
end

SMODS.Consumable {
    atlas = "Echo_Atlas",
    pos = { x = 0, y = 0 },
    unlocked = true,
    discovered = true,
    key = "abyss",
    set = "taintedcards",
    eternal_compat = true,

    loc_vars = function(self, info_queue, card)
        local active = G.GAME.AbyssActive
        local status_text = active and "Ready To Consume" or "Dormant..."
        local colour = active and G.C.GREEN or G.C.RED

        local main_end = {
            {
                n = G.UIT.C,
                config = { align = "bm", padding = 0.02 },
                nodes = {
                    {
                        n = G.UIT.C,
                        config = { align = "m", colour = colour, r = 0.05, padding = 0.05 },
                        nodes = {
                            { n = G.UIT.T, config = { text = status_text, colour = G.C.UI.TEXT_LIGHT, scale = 0.3, shadow = true } }
                        }
                    }
                }
            }
        }

        return { vars = { G.GAME.AbyssRounds or 0 }, main_end = main_end }
    end,

    keep_on_use = function(self) return true end,

    can_use = function(self, card)
        if G.GAME.AbyssRounds >= 2 then
            return true
        end
    end,

    use = function(self, card, area, copier)
        G.GAME.AbyssRounds = 0
        G.GAME.AbyssActive = true
        G.GAME.AbyssMessageCheck = false
        card:juice_up(0.8, 0.8)

        G.E_MANAGER:add_event(Event({
            func = function()
                card_eval_status_text(card, "extra", nil, nil, nil, { message = "Consume.." })
                return true
            end
        }))
    end,

    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval then
            if not G.GAME.AbyssActive and G.GAME.AbyssRounds < 2 then
                G.GAME.AbyssRounds = G.GAME.AbyssRounds + 1
            end

            if G.GAME.AbyssRounds >= 2 and not G.GAME.AbyssMessageCheck then
                G.GAME.AbyssMessageCheck = true
                return { message = "Ready.." }
            end

            if G.GAME.AbyssActive then
                G.GAME.AbyssActive = false
                return { message = "Enshadowed.." }
            end
        end
    end,

    in_pool = function(self) return false end,
}

local start_run_refabyss = Game.start_run
function Game:start_run(args)
    start_run_refabyss(self, args)
    if not G.GAME.ABYSSLOADED then
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.ABYSSLOADED = true
                G.GAME.AbyssRounds = 2
                G.GAME.AbyssActive = false
                G.GAME.AbyssMessageCheck = true
                G.GAME.AbyssLastConsumable = nil
                return true
            end
        }))
    end
end
