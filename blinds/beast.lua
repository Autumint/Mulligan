-- famine effect
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
-- pestilence effect
SMODS.Blind {
    key = "pestilence",
    pos = { x = 0, y = 25 },
    mult = 2,
    boss = { min = 1 },
    boss_colour = HEX("008000"),
    tdecks_next_phase = "bl_tdec_war",

    calculate = function(self, blind, context)
        if context.press_play then
            G.E_MANAGER:add_event(Event({
                func = function()
                    local candidates = {}
                    for _, card in ipairs(G.deck.cards) do
                        if not card.debuff then
                            table.insert(candidates, card)
                        end
                    end
                    for _, card in ipairs(G.hand.cards) do
                        if not card.debuff then
                            table.insert(candidates, card)
                        end
                    end

                    pseudoshuffle(candidates)
                    local half_size = math.floor((#G.deck.cards + #G.hand.cards) / 10)

                    for i = 1, math.min(half_size, #candidates) do
                        local selected_card = candidates[i]
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            func = function()
                                play_sound('tarot2', 1, 0.4)
                                selected_card:juice_up(0.5, 0.5)
                                selected_card.debuff = true
                                return true
                            end
                        }))
                    end

                    return true
                end
            }))

            blind.triggered = true
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

        if context.debuff_card and context.debuff_card.debuff then
            return { debuff = true }
        end
    end,

    in_pool = function(self)
        return false
    end,
}
-- war effect
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
-- death effect
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
--pick playing card which will damage the beast
local function beast_damage_card()
    G.GAME.current_round.tdec_beast_card = { rank = 'Ace' }
    local valid_damage_cards = {}
    for _, playing_card in ipairs(G.playing_cards) do
        if not SMODS.has_no_suit(playing_card) and not SMODS.has_no_rank(playing_card) then
            valid_damage_cards[#valid_damage_cards + 1] = playing_card
        end
    end
    local damage_card = pseudorandom_element(valid_damage_cards, 'tdec_beast' .. G.GAME.round_resets.ante)
    if damage_card then
        G.GAME.current_round.tdec_beast_card.rank = damage_card.base.value
        G.GAME.current_round.tdec_beast_card.id = damage_card.base.id
    end
end
-- beast effect
SMODS.Blind {
    key = "beast",
    pos = { x = 0, y = 25 },
    mult = 10,
    boss = { min = 1 },
    boss_colour = HEX("a84024"),

    calculate = function(self, blind, context)
        -- keep loading progress for the health bar 
        G.GAME.BeastProgress = (G.GAME.blind.chips - G.GAME.chips) / G.GAME.blind.chips * 100
        -- warning text to tell you which card is the damaging card
        if G.hand and #G.hand.highlighted > 0 then
            if G.GAME.current_round.tdec_beast_card and not self.boss_warning_text then
                self.boss_warning_text = UIBox {
                    definition =
                    { n = G.UIT.ROOT, config = { align = 'cm', colour = G.C.CLEAR, padding = 0.2 }, nodes = {
                        { n = G.UIT.R, config = { align = 'cm', maxw = 1 }, nodes = {
                            { n = G.UIT.O, config = { object = DynaText({
                                scale = 0.7,
                                string = "The sacrifice is.. The " .. G.GAME.current_round.tdec_beast_card.rank,
                                maxw = 9,
                                colours = { G.C.WHITE },
                                float = true,
                                shadow = true,
                                silent = true,
                                pop_in = 0,
                                pop_in_rate = 6
                            }) } },
                        } },
                    } },
                    config = {
                        align = 'cm',
                        offset = { x = 0, y = -3.1 },
                        major = G.play,
                    }
                }
            end
        else
            if self.boss_warning_text then
                self.boss_warning_text:remove()
                self.boss_warning_text = nil
            end
        end
        -- shuffle played and discarded cards back into the deck
        if context.discard then
            G.FUNCS.draw_from_discard_to_deck()
        end
        if context.after then
            G.FUNCS.draw_from_discard_to_deck()
            -- pick card
            beast_damage_card()
        end
        -- check if the card is a damage card, if it is then deal damage
        if context.before then
            if G.GAME.current_round.tdec_beast_card and G.GAME.current_round.tdec_beast_card.id then
                for _, card in ipairs(context.scoring_hand) do
                    if card:get_id() == G.GAME.current_round.tdec_beast_card.id then
                        if G.GAME.blind and G.GAME.blind.config.blind.key == "bl_tdec_beast" then
                            if not G.GAME.blind.starting_chips then
                                G.GAME.blind.starting_chips = G.GAME.blind.chips
                                G.GAME.blind.reduction_amount = math.floor(G.GAME.blind.starting_chips * 0.03)
                            end

                            G.GAME.blind.chips = G.GAME.blind.chips - G.GAME.blind.reduction_amount

                            G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                            G.HUD_blind:recalculate()
                            G.GAME.blind:juice_up()

                            attention_text({
                                text = 'Damaged',
                                scale = 1.4,
                                hold = 1.5,
                                major = G.play,
                                colour = G.C.RED,
                                align = 'cm',
                                offset = { x = 0, y = -2.7 },
                                silent = true
                            })
                        end
                    end
                end
            end
        end
    end,

    in_pool = function(self)
        return false
    end,
}

--phase changing
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
    -- win game if beast is defeated
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

                if G.GAME.blind and G.GAME.blind.config.blind.key == "bl_tdec_beast" then
                    ease_hands_played(4)
                    beast_damage_card()
                    if G.GAME.blind and G.GAME.blind.config.blind.key == "bl_tdec_beast" and G.GAME.BeastProgress then
                        G.HP_ui = UIBox {
                            definition = {
                                n = G.UIT.ROOT,
                                config = { align = "cm", padding = 0.05, colour = G.C.CLEAR, offset = { x = 0, y = 0 }, major = G.jokers, bond = "Weak" },
                                nodes = {
                                    create_progress_bar({
                                        label = "The Beast",
                                        ref_table = G.GAME,
                                        ref_value = 'BeastProgress',
                                        w = 7,
                                        h = 0.5,
                                        min = 0,
                                        max = 100,
                                        colour = G.C.RED,
                                        bg_colour = G.C.BLACK,
                                        bar_rotation = "Horizontal",
                                    })
                                }
                            },
                            config = { align = "cm", padding = 0.05, colour = G.C.CLEAR, offset = { x = 0, y = 2.2 }, major = G.jokers, bond = "Weak" }
                        }
                    end
                end

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
