function do_flip()
    play_sound('tdec_checkered_sound')
    G.GAME.TCFlip.swapped_this_round = true

    local preserved = {}
    for _, j in ipairs(G.jokers.cards) do
        if j.area == G.jokers and j.area ~= G.shop_jokers then
            if j.config and j.config.center and j.config.center.key == "j_tdec_photoquestion" then

            else
                preserved[#preserved + 1] = j:save()
            end
        end
    end
    G.GAME.TCFlip.preserved[G.GAME.TCFlip.state] = preserved

    local to_remove = {}
    for _, j in ipairs(G.jokers.cards) do
        if j.area == G.jokers and j.area ~= G.shop_jokers and not j.getting_sliced then
            if not (j.config and j.config.center and j.config.center.key == "j_tdec_photoquestion") then
                to_remove[#to_remove + 1] = j
            end
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

    local old_state = G.GAME.TCFlip.state
    local new_state = (old_state == 'Alive') and 'Dead' or 'Alive'

    G.GAME.TCFlip.money[old_state] = G.GAME.dollars
    G.GAME.TCFlip.state = new_state
    G.GAME.dollars = G.GAME.TCFlip.money[new_state]

    local spawn_data = G.GAME.TCFlip.preserved[new_state] or {}

    G.E_MANAGER:add_event(Event({
        func = function()
            for _, j in ipairs(G.jokers.cards) do
                if not (j.config and j.config.center and j.config.center.key == "j_tdec_photoquestion") then
                    return false 
                end
            end
            return true
        end
    }))

    for _, data in ipairs(spawn_data) do
        G.E_MANAGER:add_event(Event({
            func = function()
                local new_card = create_card('Joker', G.jokers, nil, nil, true, nil, data.key)
                if new_card then
                    new_card.no_juice = true
                    new_card:load(data)
                    new_card:hard_set_T()
                    G.jokers:emplace(new_card)
                    new_card.added_to_deck = false
                    new_card:add_to_deck()
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

SMODS.Back {
    original = "b_checkered",
    key = "tainted_checkered",
    atlas = "tainted_checkered",
    pos = { x = 0, y = 0 },
    config = { extra_hand_bonus = 1 },

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
        G.GAME.modifiers.tainted_checkered = true
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            func = function()
                if G.pactive_area then
                    local c = create_card("taintedcards", G.pactive_area, nil, nil, nil, nil, "c_tdec_flip_card")
                    c:add_to_deck()
                    table.insert(G.pactive_area.cards, c)
                    c.area = G.pactive_area
                    c:align()
                end
                return true
            end
        }))
        G.GAME.TCFlip = {
            state = 'Alive',
            preserved = { Alive = {}, Dead = {} },
            money = { Alive = 4, Dead = 4 },
            swapped_this_round = false,
            is_active = true,
        }
        G.GAME.dollars = G.GAME.TCFlip.money.Alive
        G.E_MANAGER:add_event(Event({
            func = function()
                for k, v in pairs(G.playing_cards) do
                    if v.base.suit == 'Spades' then
                        v:change_suit('Clubs')
                    end
                    if v.base.suit == 'Hearts' then
                        v:change_suit('Diamonds')
                    end
                    G.GAME.FlippedSuits = true
                end
                return true
            end
        }))
    end,
    calculate = function(self, card, context)
        if context.setting_blind then
            G.GAME.TCFlip.swapped_this_round = false
            return
        end

        if context.starting_shop
            and not context.repetition
            and not G.GAME.TCFlip.swapped_this_round then
            return do_flip()
        end

        if context.end_of_round and context.main_eval then
            local inactive = (G.GAME.TCFlip.state == "Alive") and "Dead" or "Alive"
            local reward = G.GAME.blind.config.blind.dollars

            if not (G.GAME.blind:get_type() == 'Small' and G.GAME.stake == 2) then
                local hands_remaining = G.GAME.current_round.hands_left
                G.GAME.TCFlip.money[inactive] = G.GAME.TCFlip.money[inactive] + reward + hands_remaining
                return {
                    message = "+$" .. reward + hands_remaining
                }
            end
        end
    end
}

local smods_add_to_pool_ref = SMODS.add_to_pool
function SMODS.add_to_pool(prototype_obj, args)
    if prototype_obj.suit_nominal and G.GAME.FlippedSuits then
        if prototype_obj.key == "Hearts" or prototype_obj.key == "Spades" then
            return false
        end
    end
    return smods_add_to_pool_ref(prototype_obj, args)
end