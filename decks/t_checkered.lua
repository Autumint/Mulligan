local TDEC = {
    state = 'Alive',                     
    saved = { Alive = {}, Dead = {} },   
    swapped_this_round = false,          
}

local game_start_run_ref = Game.start_run
function Game:start_run(args)
    if not args or not args.savetext then
        TDEC = {
            state = 'Alive',
            saved = { Alive = {}, Dead = {} },
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

            local keys = {}
            for _, j in ipairs(G.jokers.cards) do
                if not SMODS.is_eternal(j) then
                    keys[#keys+1] = j.config.center.key
                end
            end
            TDEC.saved[TDEC.state] = keys

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
            local spawn_keys = TDEC.saved[TDEC.state] or {}

            G.E_MANAGER:add_event(Event({
                func = function()
                    local remaining = 0
                    for _, j in ipairs(G.jokers.cards) do
                        if not SMODS.is_eternal(j) then
                            remaining = remaining + 1
                        end
                    end
                    return remaining == 0
                end
            }))

            for _, k in ipairs(spawn_keys) do
                G.E_MANAGER:add_event(Event({
                    func = function()
                        SMODS.add_card{
                            key = k,
                            area = G.jokers,
                            no_juice = true
                        }
                        return true
                    end
                }))
            end
                    return {
            message = "Flip",
            colour = G.C.BLUE
        }
        end
    end,
}