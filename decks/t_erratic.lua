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

function TDECKS.random_joker_center(_rarity)
    local center
    local _pool, _pool_key = get_current_pool("Joker", _rarity, false, "tdeck_erratic")
    center = pseudorandom_element(_pool, pseudoseed(_pool_key))
    local it = 1
    while center == 'UNAVAILABLE' do
        it = it + 1
        center = pseudorandom_element(_pool, pseudoseed(_pool_key..'_resample'..it))
    end

    center = G.P_CENTERS[center]
    return center
end

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
    badge_colour = HEX("FF0000"),
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

        --card.ability._tdec_triggered = card.ability._tdec_triggered or false
        --G.GAME._tdec_erratic_sound_played = G.GAME._tdec_erratic_sound_played or false --Not Needed; nil evaluates as false

        if context.check_eternal and card.ability._tdec_force_eternal then
            return { no_destroy = { override_compat = true } }
        end

        if context.setting_blind and not card.ability._tdec_triggered then
            card.ability._tdec_triggered = true

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