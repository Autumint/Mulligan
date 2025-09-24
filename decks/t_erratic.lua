SMODS.Back {
    original = "b_erratic",
    key = "tainted_erratic",
    atlas = "tainted_atlas",
    pos = { x = 2, y = 1 },
    unlocked = true,
    discovered = true,
    config = { joker_slot = 1 },

    apply = function(self)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            func = function()
                if G.pactive_area then
                    local c = SMODS.create_card({ key = "c_tdec_debugcard", no_edition = true })
                    c:add_to_deck()
                    G.pactive_area:emplace(c)
                    c:align()
                    c:flip()
                end
                return true
            end
        }))
    end
}

SMODS.Sticker {
    atlas = "erratic_perish",
    key = "tainted_perish",
    pos = { x = 0, y = 0 },
    badge_colour = HEX("FF0000"),
    should_apply = function(self, card)
        return card.ability
            and card.ability.set == "Joker"
            and card.config.center.key ~= "j_tdec_photoquestion"
            and G.GAME.selected_back and G.GAME.selected_back.effect.center.key == "b_tdec_tainted_erratic"
    end,

    apply = function(self, card, val)
        card.ability[self.key] = val
    end,

    calculate = function(self, card, context)
        if not card.ability[self.key] then return end

        if context.check_eternal and card.ability._tdec_force_eternal then
            return { no_destroy = { override_compat = true } }
        end

        if context.ending_shop then
            G.E_MANAGER:add_event(Event({
                trigger = "before",
                func = function()
                    card:flip()
                    return true
                end
            }))

            G.E_MANAGER:add_event(Event({
                func = function()
                    if not G.GAME._tdec_erratic_sound_played then
                        play_sound('tdec_erratic_bug2')
                        G.GAME._tdec_erratic_sound_played = true
                    end
                    card:set_ability(TDECKS.random_joker_center())
                    return true
                end
            }))

            G.E_MANAGER:add_event(Event({
                trigger = "after",
                func = function()
                    card:flip()
                    return true
                end
            }))
        end

        if context.setting_blind then
            G.GAME._tdec_erratic_sound_played = false
        end
    end
}
