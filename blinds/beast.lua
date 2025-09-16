SMODS.Blind {
    key = "famine",
    pos = { x = 0, y = 25 },
    mult = 2,
    boss = { min = 1 },
    boss_colour = HEX("675b5b"),
    tdecks_next_phase = "bl_tdec_pestilence",
    hidden = true,

    calculate = function(self, blind, context)
        if context.setting_blind then
            G.hand:change_size(-1)
            SMODS.change_discard_limit(-1)
            blind._famine_applied = (blind._famine_applied or 0) + 1
        end
    end,

    in_pool = function(self)
        return false
    end,
}

SMODS.Blind {
    key = "pestilence",
    pos = { x = 0, y = 25 },
    mult = 2,
    boss = { min = 1 },
    boss_colour = HEX("008000"),
    tdecks_next_phase = "bl_tdec_war",

    in_pool = function(self)
        return false
    end,
}


SMODS.Blind {
    key = "war",
    pos = { x = 0, y = 25 },
    mult = 2,
    boss = { min = 1 },
    boss_colour = HEX("ff000d"),
    tdecks_next_phase = "bl_tdec_death",

    in_pool = function(self)
        return false
    end,

    calculate = function(self, blind, context)
        if context.press_play then
            G.E_MANAGER:add_event(Event({
                func = function()
                    local _cards = {}
                    for _, playing_card in ipairs(G.hand.cards) do
                        _cards[#_cards + 1] = playing_card
                    end
                    for i = 1, 3 do
                        if #_cards > 0 then
                            local selected_card, card_index = pseudorandom_element(_cards, 'tdec_war')
                            G.E_MANAGER:add_event(Event({
                                trigger = 'after',
                                delay = (i - 1) * 0.5,
                                func = function()
                                    selected_card:start_dissolve(nil, true)
                                    play_sound('card1', 1)
                                    return true
                                end
                            }))

                            table.remove(_cards, card_index)
                        end
                    end
                    return true
                end
            }))
            blind.triggered = true
            delay(0.7)
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = (function()
                    SMODS.juice_up_blind()
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.06 * G.SETTINGS.GAMESPEED,
                        blockable = false,
                        blocking = false,
                        func = function()
                            play_sound('tarot2', 0.76, 0.4); return true
                        end
                    }))
                    play_sound('tarot2', 1, 0.4)
                    return true
                end)
            }))
            delay(0.4)
        end
    end
}

SMODS.Blind {
    key = "death",
    pos = { x = 0, y = 25 },
    mult = 2,
    boss = { min = 1 },
    boss_colour = HEX("fbfbfd"),
    tdecks_next_phase = "bl_tdec_beast",

    in_pool = function(self) 
        return false 
    end,

    calculate = function(self, blind, context)
        if context.post_trigger then
            if not context.other_context.mod_probability and not context.other_context.fix_probability then
                if SMODS.pseudorandom_probability(self, 'ghostly', 1, 3) then
                    if context.other_card.config.center ~= G.P_CENTERS.j_tdec_photoquestion then
                        context.other_ret.jokers = {}
                        return {
                            message = "Fading",
                            colour = G.C.WHITE
                        }
                    end
                end
            end
        end
    end
}


SMODS.Blind {
    key = "beast",
    pos = { x = 0, y = 25 },
    mult = 2.5,
    boss = { min = 1 },
    boss_colour = HEX("a84024"),

    in_pool = function(self)
        return false
    end,
}

local end_roundref = end_round
function end_round()
    if G.GAME.current_round.hands_left == 0 and G.GAME.chips < G.GAME.blind.chips then
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
    if G.GAME.blind.config.blind.key == "bl_tdec_beast" then
        win_game()
        remove_save()
    end
    if G.GAME.blind and G.GAME.blind.config and G.GAME.blind.config.blind.tdecks_next_phase then
        G.GAME.chips = 0
        G.GAME.round_resets.lost = true
        G.E_MANAGER:add_event(Event({
            func = function()
                local fam_blind = G.GAME.blind
                if fam_blind and fam_blind.config and fam_blind.config.blind and fam_blind.config.blind.key == "bl_tdec_famine" then
                    local applied = fam_blind._famine_applied or 0
                    if applied > 0 then
                        for i = 1, applied do
                            G.hand:change_size(1)
                            SMODS.change_discard_limit(1)
                        end
                        fam_blind._famine_applied = 0
                    end
                end

                G.GAME.blind:set_blind(G.P_BLINDS[G.GAME.blind.config.blind.tdecks_next_phase])
                change_phase()
                G.GAME.blind:juice_up()
                ease_hands_played(G.GAME.round_resets.hands - G.GAME.current_round.hands_left)
                ease_discard(
                    math.max(0, G.GAME.round_resets.discards + G.GAME.round_bonus.discards) -
                    G.GAME.current_round.discards_left
                )
                G.FUNCS.draw_from_discard_to_deck()
                if G.GAME.modifiers.tainted_checkered then
                    do_flip()
                end
                return true
            end
        }))
    else
        end_roundref()
    end
end

function change_phase()
    G.STATE = 1
    G.STATE_COMPLETE = false
    --temporary stuff is from Entropy, im leaving it in for crossmod compatibility since it doesnt hurt
    local remove_temp = {}
    for i, v in pairs({ G.jokers, G.hand, G.consumeables, G.discard, G.deck }) do
        for ind, card in pairs(v.cards) do
            if card.ability then
                if card.ability.temporary or card.ability.temporary2 then
                    if card.area ~= G.hand and card.area ~= G.play and card.area ~= G.jokers and card.area ~= G.consumeables then card.states.visible = false end
                    card:remove_from_deck()
                    card:start_dissolve()
                    if card.ability.temporary then remove_temp[#remove_temp + 1] = card end
                end
            end
        end
    end
    if #remove_temp > 0 then
        SMODS.calculate_context({ remove_playing_cards = true, removed = remove_temp })
    end
    G.deck:shuffle()
    G.E_MANAGER:add_event(Event({
        func = function()
            G.GAME.ChangingPhase = nil
            return true
        end
    }))
end

TDECKS.ENDLESSBUTTON = function()
    if G.GAME.round_resets.ante == 0 then
        return {}
    else
        return {
            UIBox_button({
                button = 'exit_overlay_menu',
                label = (function()
                    local found = false
                    if G.jokers.cards then
                        for _, j in ipairs(G.jokers.cards) do
                            if j.config and j.config.center and j.config.center.key == "j_tdec_photoquestion" then
                                found = true
                                break
                            end
                        end
                    end
                    return found and { "Ascend?" } or { localize('b_endless') }
                end)(),
                minw = 6.5,
                maxw = 5,
                minh = 1.2,
                scale = 0.7,
                shadow = true,
                colour = G.C.BLUE,
                focus_args = { nav = 'wide', button = 'x', set_button_pip = true }
            }),
        }
    end
end
