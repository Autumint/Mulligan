local TDEC = {
    state = 'Alive',                     
    preserved = { Alive = {}, Dead = {} },   
    swapped_this_round = false,          
}

local game_start_run_ref = Game.start_run
function Game:start_run(args)
    if not args or not args.savetext then
        TDEC = {
            state = 'Alive',
            preserved = { Alive = {}, Dead = {} },
            swapped_this_round = false,
        }
    end
    game_start_run_ref(self, args)
end

SMODS.Back{
    original = "b_checkered",
    key = "tainted_checkered",
    atlas = "tainted_atlas",
    pos = { x = 1, y = 1 },
    config = { extra_hand_bonus = 2, extra_discard_bonus = 2, dollars = 6 }

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
        name = "Enigmatic Deck",
        text = {
            "{V:1}#1#{V:2}#2#{}",
            "{C:red}Between Life and Death",
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
            TDEC.swapped_this_round = false
            return
        end

        if context and context.end_of_round and not context.repetition and not context.blueprint and not TDEC.swapped_this_round then
            play_sound('tdec_checkered_sound')
            TDEC.swapped_this_round = true  

            local preserved = {}
            for _, j in ipairs(G.jokers.cards) do
                if not SMODS.is_eternal(j) then
                    preserved[#preserved+1] = j:save()
                end
            end
            TDEC.saved[TDEC.state] = preserved

            local to_remove = {}
            for _, j in ipairs(G.jokers.cards) do
                if not j.getting_sliced then
                    to_remove[#to_remove+1] = j
                end
            end
            for _, j in ipairs(to_remove) do
                j.getting_sliced = true
                G.E_MANAGER:add_event(Event({
                    func = function()
                        j:start_dissolve({ G.C.RED }, nil, 1.6)
                        return true
                    end
                }))
            end

            TDEC.state = (TDEC.state == 'Alive') and 'Dead' or 'Alive'
            local spawn_data = TDEC.saved[TDEC.state] or {}

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
                colour = G.C.BLUE
            }
        end
    end
}