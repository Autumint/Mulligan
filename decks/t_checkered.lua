local TCFlip = {
    state = 'Alive',
    preserved = { Alive = {}, Dead = {} },
    swapped_this_round = false,
}

local game_start_run_ref = Game.start_run
function Game:start_run(args)
    if not args or not args.savetext then
        TCFlip.state = 'Alive'
        TCFlip.preserved = { Alive = {}, Dead = {} }
        TCFlip.swapped_this_round = false
    end
    game_start_run_ref(self, args)
end

function TCFlip.do_flip()
    play_sound('tdec_checkered_sound')
    TCFlip.swapped_this_round = true

    local preserved = {}
    for _, j in ipairs(G.jokers.cards) do
        preserved[#preserved+1] = j:save()
    end
    TCFlip.preserved[TCFlip.state] = preserved

    local to_remove = {}
    for _, j in ipairs(G.jokers.cards) do
        if not j.getting_sliced then
            to_remove[#to_remove+1] = j
        end
    end

    local flipcolor = (TCFlip.state == 'Alive') and G.C.ORANGE or G.C.BLUE


    for _, j in ipairs(to_remove) do
        j.getting_sliced = true
        G.E_MANAGER:add_event(Event({
            func = function()
                j:start_dissolve({ flipcolor }, nil, 1.6)
                return true
            end
        }))
    end

    TCFlip.state = (TCFlip.state == 'Alive') and 'Dead' or 'Alive'
    local spawn_data = TCFlip.preserved[TCFlip.state] or {}

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
    atlas = "tainted_atlas",
    pos = { x = 1, y = 1 },
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
    loc_txt = {
        name = "Enigma Deck",
        text = {
            "{V:1}#1#{V:2}#2#{}",
            "Between {V:2}Life{} and {V:1}Death{}",
        },
    },
    apply = function(self, back)
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
            TCFlip.swapped_this_round = false
            return
        end

        if context and context.end_of_round
        and not context.repetition
        and not TCFlip.swapped_this_round then
            return TCFlip.do_flip()
        end
    end
}

SMODS.Consumable{
    unlocked = true,
    key = "flip_card",
    set = "TaintedCards",
    loc_txt = {
        name = "Flip?",
        text = {"Placeholder"},
    },
    cost = 4,
    rarity = 1,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        return TCFlip.do_flip()
    end
}