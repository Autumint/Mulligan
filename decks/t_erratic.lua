SMODS.Back({
    original = "b_erratic",
    key = "tainted_erratic",
    loc_txt = {
        name = "C@PRIC10US D?CK",
        text = {
            "{C:red}ERR: ATT.GET ?JOKER?, GOT_NIL{}", 
            "{C:red}@% EVERCHANGING? !_UNRESPONSIVE[indexfailed]{}"
        }
    },
    atlas = "tainted_atlas", 
    pos = {x = 2, y = 1}, 
    unlocked = true,
    discovered = true,
    config = {
        joker_slot = 1
    },
    calculate = function(self, card, context)
    if context.end_of_round and context.beat_boss and not context.individual and not context.repetition then
        G.E_MANAGER:add_event(Event({
            func = function()
                SMODS.add_card{ set = "DebugScript", key = "c_tdec_debugcard"}
                return true
            end
        }))
    end
end
})

SMODS.Sticker{
    atlas = "erratic_perish",
    key = "tainted_perish",
    pos = { x = 0, y = 0 },

    loc_txt = {
        name = "ERR_EVCHANGING",
        text = {
            "{C:red}dbg = nil{}",
        }
    },

    should_apply = function(self, card)
        return card.ability
           and card.ability.set == "Joker"
           and G.GAME.selected_back and G.GAME.selected_back.effect.center.key == "b_tdec_tainted_erratic"
    end,

    apply = function(self, card, val)
        card.ability[self.key] = val
    end,

    calculate = function(self, card, context)
        if not card.ability[self.key] then return end

        card.ability._tdec_triggered = card.ability._tdec_triggered or false
        G.GAME._tdec_erratic_sound_played = G.GAME._tdec_erratic_sound_played or false

        if context.check_eternal and card.ability._tdec_force_eternal then
            return { no_destroy = { override_compat = true } }
        end

        if context.setting_blind and not card.ability._tdec_triggered then
            card.ability._tdec_triggered = true

            G.E_MANAGER:add_event(Event({
                delay = 0,
                func = function()
                    if not G.GAME._tdec_erratic_sound_played then
                        play_sound('tdec_erratic_bug2')
                        G.GAME._tdec_erratic_sound_played = true
                    end

                    local had_eternal = card.ability.eternal
                    local had_rental = card.ability.rental

                    G.GAME.joker_buffer = (G.GAME.joker_buffer or 0) + 1
                    local new_card = SMODS.add_card{
                        set = 'Joker',
                        sticker = 's_tdec_tainted_perish'
                    }
                    G.GAME.joker_buffer = 0

                    if had_rental and new_card then
                        new_card.ability.rental = true
                    end

                    if had_eternal and new_card then
                        new_card.ability.eternal = true
                        new_card.ability._tdec_force_eternal = true
                    end

                    if card.start_dissolve then
                        card:start_dissolve(nil, true)
                    end

                    return true
                end
            }))
        end

        if not context.setting_blind then
            card.ability._tdec_triggered = false
        end

        if G.STATE == G.STATES.SHOP then
            G.GAME._tdec_erratic_sound_played = false
        end
    end
}

SMODS.ConsumableType {
    key = 'DebugScript',
    default = 'c_tdec_debugcard',
    primary_colour = G.C.SET.Tarot,
    secondary_colour = G.C.SECONDARY_SET.Tarot,
    collection_rows = { 1 },
    shop_rate = 0
}

SMODS.Consumable {
    loc_txt = {
        name = "Debug Card",
        text = {
            "{C:red}[!] OUTPUT: Defined_Global_Input Corrected{}"
        }
    },
    atlas = "debugcard_atlas",
    unlocked = true, 
    key = 'debugcard',
    set = 'DebugScript',
    pos = { x = 0, y = 0 },
    
    in_pool = function(self, args)
        return false
    end,

    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tdec_erratic_bug1')

                for _, j in ipairs(G.jokers.highlighted) do
                    if j.ability and j.ability.tdec_tainted_perish then
                        j.ability.tdec_tainted_perish = nil
                    end
                end

                return true
            end
        }))
        delay(0.6)
    end,

    can_use = function(self, card)
        if #G.jokers.highlighted > 0 then
            for _, j in ipairs(G.jokers.highlighted) do
                if j.ability and j.ability.tdec_tainted_perish then
                    return true
                end
            end
        end
        return false
    end
}