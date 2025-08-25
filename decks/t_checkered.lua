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
    loc_txt = {
        name = "Enigma Deck",
        text = {
            "{V:1}#1#{V:2}#2#{}",
            "Between {V:2}Life{} and {V:1}Death{}",
        },
    },
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
        return do_flip()
    end
}

local t_check_dt = 0
local update_ref = Game.update
function Game:update(dt)
    update_ref(self, dt)
    t_check_dt = t_check_dt + dt
    if G.GAME.TCFlip and G.P_CENTERS and G.P_CENTERS.b_tdec_tainted_checkered and t_check_dt > 0.1 then
		t_check_dt = 0
		local obj = G.P_CENTERS.b_tdec_tainted_checkered
		if G.GAME.TCFlip.state ~= "Alive" then
            obj.pos.x = obj.pos.x + 1
            if obj.pos.x > 6 then obj.pos.x = 6 else
                update_tcheck_backs()
            end
		else
            obj.pos.x = obj.pos.x - 1
            if obj.pos.x < 0 then obj.pos.x = 0 else
                update_tcheck_backs()
            end
		end
        G.P_CENTERS.b_tdec_tainted_checkered = obj
	end
end

function update_tcheck_backs()
    for i, self in pairs(G.I.CARD) do
        if self.children.back then 
            self.children.back:remove()
            self.children.back = Sprite(self.T.x, self.T.y, self.T.w, self.T.h, G.ASSET_ATLAS["tdec_tainted_checkered"], G.P_CENTERS['b_tdec_tainted_checkered'].pos)
            self.children.back.states.hover = self.states.hover
            self.children.back.states.click = self.states.click
            self.children.back.states.drag = self.states.drag
            self.children.back.states.collide.can = false
            self.children.back:set_role({major = self, role_type = 'Glued', draw_major = self})
        end
    end
end

function TDECKS.get_bg_colour()
    if G.GAME.TCFlip and G.GAME.TCFlip.is_active then
        return G.GAME.TCFlip.state == "Dead" and HEX("4f6367") or HEX("8baeca")
    end
    return G.C.BLIND['Small']
end