SMODS.Blind {
    key = "beast",
    pos = { x = 0, y = 2 },
    boss = { min = 1 },
    boss_colour = HEX("b95b08"),
    loc_vars = function(self)
        return { vars = {} }
    end,

    in_pool = function(self)
        return true
    end
}


local end_roundref = end_round
function end_round()
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