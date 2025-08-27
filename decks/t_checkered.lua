function do_flip()
    play_sound('tdec_checkered_sound')
    G.GAME.TCFlip.swapped_this_round = true

    local preserved = {}
    for _, j in ipairs(G.jokers.cards) do
        preserved[#preserved+1] = j:save()
    end
    G.GAME.TCFlip.preserved[G.GAME.TCFlip.state] = preserved

    local to_remove = {}
    for _, j in ipairs(G.jokers.cards) do
        if not j.getting_sliced then
            to_remove[#to_remove+1] = j
        end
    end

    local flipcolor = (G.GAME.TCFlip.state == 'Alive') and G.C.ORANGE or G.C.BLUE


    for _, j in ipairs(to_remove) do
        j.getting_sliced = true
        G.E_MANAGER:add_event(Event({
            func = function()
                j:start_dissolve({ flipcolor }, nil, 1.6)
                return true
            end
        }))
    end

    G.GAME.TCFlip.state = (G.GAME.TCFlip.state == 'Alive') and 'Dead' or 'Alive'
    local spawn_data = G.GAME.TCFlip.preserved[G.GAME.TCFlip.state] or {}

    G.E_MANAGER:add_event(Event({
        func = function()
            return #G.jokers.cards == 0
        end
    }))

    for _, data in ipairs(spawn_data) do
        G.E_MANAGER:add_event(Event({
            func = function()
                local new_card = SMODS.add_card{
                    key = data.key,
                    set = "Joker",
                    no_juice = true
                }
                if new_card then
                    new_card:load(data)
                    new_card:hard_set_T()
                end
                return true
            end
        }))
    end

    return {
        message = "Flip",
        colour = flipcolor
    }
end

SMODS.Back{
    original = "b_checkered",
    key = "tainted_checkered",
    atlas = "tainted_checkered",
    pos = { x = 0, y = 0 },
    config = {
        extra_hand_bonus = 2,
        extra_discard_bonus = 2,
        dollars = 6
    },
    loc_vars = function(self, info_queue, back)
        return {
            vars = {
                'Flip',
                'side',
                colours = {
                    G.C.SUITS.Clubs,
                    G.C.SUITS.Diamonds,
                }
            },
        }
    end,
    apply = function(self, back)
        G.GAME.TCFlip = {
            state = 'Alive',
            preserved = { Alive = {}, Dead = {} },
            swapped_this_round = false,
        }
        G.GAME.TCFlip.is_active = true
        G.E_MANAGER:add_event(Event({
            func = function()
                for k, v in pairs(G.playing_cards) do
                    if v.base.suit == 'Spades' then
                        v:change_suit('Clubs')
                    end
                    if v.base.suit == 'Hearts' then
                        v:change_suit('Diamonds')
                    end
                end
                return true
            end
        }))
    end,
    calculate = function(self, card, context)
        if context and context.setting_blind then
            G.GAME.TCFlip.swapped_this_round = false
            return
        end

        if context and context.end_of_round
        and not context.repetition
        and not G.GAME.TCFlip.swapped_this_round then
            return do_flip()
        end
    end
}