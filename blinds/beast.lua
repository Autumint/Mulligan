SMODS.Blind {
    key = "famine",
    pos = { x = 0, y = 25 },
    mult = 2550,
    boss = { min = 1 },
    boss_colour = HEX("675b5b"),
    tdecks_next_phase = "bl_tdec_pestilence",

    in_pool = function(self)
        return false
    end
}

SMODS.Blind {
    key = "pestilence",
    pos = { x = 0, y = 25 },
    mult = 2550,
    boss = { min = 1 },
    boss_colour = HEX("008000"),
    tdecks_next_phase = "bl_tdec_war",

    in_pool = function(self)
        return false
    end
}

SMODS.Blind {
    key = "war",
    pos = { x = 0, y = 25 },
    mult = 2550,
    boss = { min = 1 },
    boss_colour = HEX("ff000d"),
    tdecks_next_phase = "bl_tdec_death",

    in_pool = function(self)
        return false
    end
}

SMODS.Blind {
    key = "death",
    pos = { x = 0, y = 25 },
    mult = 2550,
    boss = { min = 1 },
    boss_colour = HEX("fbfbfd"),
    tdecks_next_phase = "bl_tdec_beast",

    in_pool = function(self)
        return false
    end
}

SMODS.Blind {
    key = "beast",
    pos = { x = 0, y = 25 },
    mult = 3500,
    boss = { min = 1 },
    boss_colour = HEX("a84024"),

    in_pool = function(self)
        return false
    end,
}

local update_ref = Game.update
function Game:update(dt)
    update_ref(self, dt)

    if G.GAME.round_resets.ante == 0 and G.jokers and G.jokers.cards then
        for _, j in ipairs(G.jokers.cards) do
            if j.config and j.config.center and j.config.center.key == "j_tdec_photoquestion" then
                if G.GAME.blind.config.blind.key == "bl_tdec_famine" or G.GAME.blind.config.blind.key == "bl_tdec_pestilence" or G.GAME.blind.config.blind.key == "bl_tdec_war" or G.GAME.blind.config.blind.key == "bl_tdec_death" or G.GAME.blind.config.blind.key == "bl_tdec_beast" then
                    local blind_def = G.GAME.blind.config.blind
                    if blind_def.boss_colour then
                        ease_background_colour { new_colour = blind_def.boss_colour, contrast = 1 }
                    end
                end
            end
        end
    end
end

local end_roundref = end_round
function end_round()
    if G.GAME.blind.config.blind.key == "bl_tdec_beast" then
        win_game()
        remove_save()
    end
    if G.GAME.blind and G.GAME.blind.config and G.GAME.blind.config.blind.tdecks_next_phase then
        G.GAME.chips = 0
        G.GAME.round_resets.lost = true
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.blind:set_blind(G.P_BLINDS[G.GAME.blind.config.blind.tdecks_next_phase])
                change_phase()
                G.GAME.blind:juice_up()
                ease_hands_played(G.GAME.round_resets.hands-G.GAME.current_round.hands_left)
                ease_discard(
                    math.max(0, G.GAME.round_resets.discards + G.GAME.round_bonus.discards) - G.GAME.current_round.discards_left
                )
                G.FUNCS.draw_from_discard_to_deck()
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
    for i, v in pairs({G.jokers, G.hand, G.consumeables, G.discard, G.deck}) do
        for ind, card in pairs(v.cards) do
            if card.ability then
                if card.ability.temporary or card.ability.temporary2 then
                    if card.area ~= G.hand and card.area ~= G.play and card.area ~= G.jokers and card.area ~= G.consumeables then card.states.visible = false end
                    card:remove_from_deck()
                    card:start_dissolve()
                    if card.ability.temporary then remove_temp[#remove_temp+1]=card end
                end
            end
        end
    end
    if #remove_temp > 0 then
        SMODS.calculate_context({remove_playing_cards = true, removed=remove_temp})
    end
    G.deck:shuffle()
    G.E_MANAGER:add_event(Event({func = function()
        G.GAME.ChangingPhase = nil
        return true
    end}))
end

TDECKS.ENDLESSBUTTON = function()
    if G.GAME.round_resets.ante == 0 then return {} else return {
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
        return found and {"Ascend?"} or {localize('b_endless')}
    end)(),
    minw = 6.5, maxw = 5, minh = 1.2, scale = 0.7,
    shadow = true, colour = G.C.BLUE,
    focus_args = {nav = 'wide', button = 'x', set_button_pip = true}
}),
      } end
end