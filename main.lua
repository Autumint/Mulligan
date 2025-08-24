G.FUNCS = G.FUNCS or {}
G.FUNCS.stupidfailurebutton = function() end

local old_run_setup = G.UIDEF.run_setup
G.UIDEF.run_setup = function(run_type, saved_game)
  local ui = old_run_setup(run_type, saved_game)

  if ui and ui.nodes then
    local play_row = ui.nodes[#ui.nodes-1]
    if play_row and play_row.n == G.UIT.R and play_row.nodes then
      table.insert(play_row.nodes, {
        n = G.UIT.C,
        config = {
          align     = "cm",
          minw      = 1.0,  
          minh      = 1.0,  
          maxw      = 1.0,  
          maxh      = 1.0,  
          r         = 0.2,
          emboss    = 0.1,
          colour    = G.C.PURPLE,
          button    = "toggle_tainted",
          func = "can_toggle_tainted",
          shadow    = true,
          no_fill   = false,  
        },
        nodes = {
          { n = G.UIT.T, config = {
              text   = ">",
              scale  = 0.45,
              colour = G.C.UI.TEXT_LIGHT,
          }}
        }
      })
    end
  end

  return ui
end

G.FUNCS.can_toggle_tainted = function(e)
    e.config.colour = G.C.PURPLE
    e.config.button = "toggle_tainted"
end

G.FUNCS.toggle_tainted = function(e)
    G.TAINTED_ENABLED = not G.TAINTED_ENABLED
    G.FORCE_NEW_RUN = true
    G.FUNCS.setup_run({config = {id = "from_game_over"}})
    G.FORCE_NEW_RUN = nil
end

SMODS.Atlas{
    key = "madness_atlas",
    path = "tainted_madness.png",
    px = 71,
    py = 95
}

SMODS.Joker{
    key = "taintedmadness",
    atlas = "madness_atlas",
    allow_duplicates = false,
    rarity = 1,
    cost = 1,
    pos = { x = 0, y = 0 },
    eternal_compat = true,
    blueprint_compat = false,

    config = { extra = { every = 3, count = 0, armed = false } },

    loc_txt = {
        name = "Tainted Madness",
        text = {
            "{C:red,E:2}What's yours is mine{}",
        }
    },

    set_ability = function(self, card, initial, delay_sprites)
        card:set_eternal(true)
        card:set_edition(nil, true)
    end,

    in_pool = function(self, args)
        return false
    end,

calculate = function(self, card, context)
    if (G.GAME.round_resets and G.GAME.round_resets.ante or 0) < 2 then
        return {}
    end

    if context.setting_blind then
        card.ability.extra.count = 0
        card.ability.extra.armed = false
    end

    if context.joker_main then
        card.ability.extra.count = card.ability.extra.count + 1
        if card.ability.extra.count >= card.ability.extra.every then
            if not card.ability.extra.armed then
                local eval = function(c) return card.ability.extra.armed and not G.RESET_JIGGLES end
                juice_card_until(card, eval, true)
            end
            card.ability.extra.armed = true
        end
    end

    if context.end_of_round and not context.blueprint and card.ability.extra.armed then
        local pool = {}
        for _, j in ipairs(G.jokers.cards) do
            if j ~= card and not j.getting_sliced and not SMODS.is_eternal(j) then
                pool[#pool+1] = j
            end
        end

        if #pool > 0 then
            local target = pseudorandom_element(pool, card.key)
            target.getting_sliced = true
            G.E_MANAGER:add_event(Event({
                func = function()
                    card:juice_up(0.8, 0.8)
                    target:start_dissolve({ G.C.RED }, nil, 1.6)
                    return true
                end
            }))
        end

        card.ability.extra.count = 0
        card.ability.extra.armed = false
     end
end
}

SMODS.Atlas{
    key = "painted_atlas",
    path = "tainted_painted.png",
    px = 71,
    py = 95
}

SMODS.Back{
    original = "b_painted",
    key = "tainted_painted",
    atlas = "painted_atlas",
    pos = {x = 0, y = 0},
    config = {
        hands = -3,
        hand_size = 3,
        discards = 2,
    },
    loc_txt = {
        name = "Dried Deck",
        text = {
            "{C:White}Better Jokers.",
            "{C:red,E:2}Dry Paint.{}"
        }
    },
    calculate = function(self, back, context)
        if context.final_scoring_step then
            return { xmult = 2 }
        end

        if G.STATE == 8 and not self._gave_money then
            ease_dollars(3)
            self._gave_money = true
        elseif G.STATE ~= 8 then
            self._gave_money = false
        end

        G.GAME.banned_keys["j_burglar"] = true
        G.GAME.banned_keys["j_troubadour"] = true
        G.GAME.banned_keys["v_grabber"] = true
        G.GAME.banned_keys["v_hieroglyph"] = true

        if G.GAME and G.GAME.round_resets then
            if G.GAME.round_resets.hands > 1 then
                G.GAME.round_resets.hands = 1
            end
        end
    end
}

local original_get_cost = Card.get_cost
Card.get_cost = function(self)
    local base = original_get_cost(self)

    if G.GAME and G.GAME.selected_back and G.GAME.selected_back.effect.center.key == "b_tdec_tainted_green" then
        return base * 2
    end

    return base
end


SMODS.Atlas{
    key = "green_atlas",
    path = "Tainted_Green.png",
    px = 71,
    py = 95
}

SMODS.Back{
    original = "b_green",
    key = "tainted_green",
    atlas = "green_atlas",
    pos = { x = 0, y = 0 },
    config = { extra_hand_bonus = 1, extra_discard_bonus = 1, dollars = 4 },
    loc_txt = {
        name = "Mi$er Deck",
        text = {
            "{C:attention}Greed{} is Good.",
            "{C:red,E:2}Chasing Wealth.{}"
        }
    },

    calculate = function(self, back, context)
        if not G.GAME.selected_back and G.GAME.selected_back.effect.center.key == "b_tdec_tainted_green" then
            return
        end

        if context.starting_shop then
            G.GAME.money_spent = false
        end

        if context.buying_card or context.open_booster or context.reroll_shop then
            G.GAME.money_spent = true
        end

        if context.ending_shop and not G.GAME.money_spent then
            local held_money = G.GAME.dollars or 0
            local bonus_from_held = math.floor(held_money / 25)
            local total_bonus = 4 + bonus_from_held

            G.GAME.dollars = held_money + total_bonus

            return {
                message = "More... +$" .. total_bonus,
                colour = G.C.MONEY
            }
        end

        G.GAME.banned_keys["j_astronomer"] = true

        if context.final_scoring_step then
            local money = G.GAME.dollars or 0
            local bonus_mult = 1 + math.floor(money / 5) * 0.05
            return { xmult = bonus_mult }
        end
    end
}

if not Card._original_set_cost then
    Card._original_set_cost = Card.set_cost
end

function Card:set_cost(...)
    Card._original_set_cost(self, ...)

    if not (G.GAME and G.GAME.selected_back and G.GAME.selected_back.effect.center.key == "b_tdec_tainted_green") then
        return
    end

    if self.ability and self.ability.set and (
        self.ability.set == "Joker" or
        self.ability.set == "Voucher" or
        self.ability.set == "Booster" or
        self.ability.set == "Planet" or
        self.ability.set == "Tarot"
    ) then
        local held_money = G.GAME and G.GAME.dollars or 0
        local extra_mult = 0.15 * math.floor(held_money / 20)
        local multiplier = 1.5 + extra_mult

        if not self.base_cost then
            self.base_cost = self.cost or 0
        end

        self.cost = math.floor(self.base_cost * multiplier)
    end
end

SMODS.Atlas{
    key = "zodiac_atlas",
    path = "tainted_zodiac.png",
    px = 71,
    py = 95
}

SMODS.Back({
    original = "b_zodiac",
    key = "tainted_zodiac",
    loc_txt = {
        name = "Benighted Deck",
        text = {
            "Better {C:money}Shops.{}",
            "{C:red,E:2}Repent for your Debt.{}"
        }
    },
    atlas = "zodiac_atlas", 
    pos = {x = 0, y = 0}, 
    unlocked = true,
    discovered = true,
    config = {
        jokers = { "j_tdec_taintedmadness" },
        vouchers = { "v_overstock_norm", "v_reroll_surplus", "v_clearance_sale" },
        joker_slot = 1
    },
    apply = function(self)
        SMODS.change_booster_limit(1)
    end
})

SMODS.Atlas{
    key = "erratic_atlas",
    path = "tainted_erratic.png",
    px = 71,
    py = 95
}

SMODS.Back({
    original = "b_erratic",
    key = "tainted_erratic",
    loc_txt = {
        name = "C@PRIC10US D?CK",
        text = {
            "{C:red}ERR: ATT.GET ?JOKER?, GOT_NIL{}", 
            "{C:red}@% EVERCHANGING? !_UNRESPONSIVE[indexfailed]{}"
        }
    },
    atlas = "erratic_atlas", 
    pos = {x = 0, y = 0}, 
    unlocked = true,
    discovered = true,
    config = {
        joker_slot = 1
    },
    calculate = function(self, card, context)
    if context.end_of_round and context.beat_boss and not context.individual and not context.repetition then
        G.E_MANAGER:add_event(Event({
            func = function()
                SMODS.add_card{ set = "DebugScript", key = "c_tdec_debugcard"}
                return true
            end
        }))
    end
end
})

SMODS.Atlas{
    key = "erratic_perish",
    path = "tainted_perish.png",
    px = 71,
    py = 19
}

SMODS.Sticker{
    atlas = "erratic_perish",
    key = "tainted_perish",
    pos = { x = 0, y = 0 },

    loc_txt = {
        name = "ERR_EVCHANGING",
        text = {
            "{C:red}dbg = nil{}",
        }
    },

    should_apply = function(self, card)
        return card.ability
           and card.ability.set == "Joker"
           and G.GAME.selected_back and G.GAME.selected_back.effect.center.key == "b_tdec_tainted_erratic"
    end,

    apply = function(self, card, val)
        card.ability[self.key] = val
    end,

    calculate = function(self, card, context)
        if not card.ability[self.key] then return end

        card.ability._tdec_triggered = card.ability._tdec_triggered or false
        G.GAME._tdec_erratic_sound_played = G.GAME._tdec_erratic_sound_played or false

        if context.check_eternal and card.ability._tdec_force_eternal then
            return { no_destroy = { override_compat = true } }
        end

        if context.setting_blind and not card.ability._tdec_triggered then
            card.ability._tdec_triggered = true

            G.E_MANAGER:add_event(Event({
                delay = 0,
                func = function()
                    if not G.GAME._tdec_erratic_sound_played then
                        play_sound('tdec_erratic_bug2')
                        G.GAME._tdec_erratic_sound_played = true
                    end

                    local had_eternal = card.ability.eternal
                    local had_rental = card.ability.rental

                    G.GAME.joker_buffer = (G.GAME.joker_buffer or 0) + 1
                    local new_card = SMODS.add_card{
                        set = 'Joker',
                        sticker = 's_tdec_tainted_perish'
                    }
                    G.GAME.joker_buffer = 0

                    if had_rental and new_card then
                        new_card.ability.rental = true
                    end

                    if had_eternal and new_card then
                        new_card.ability.eternal = true
                        new_card.ability._tdec_force_eternal = true
                    end

                    if card.start_dissolve then
                        card:start_dissolve(nil, true)
                    end

                    return true
                end
            }))
        end

        if not context.setting_blind then
            card.ability._tdec_triggered = false
        end

        if G.STATE == G.STATES.SHOP then
            G.GAME._tdec_erratic_sound_played = false
        end
    end
}

SMODS.ConsumableType {
    key = 'DebugScript',
    default = 'c_tdec_debugcard',
    primary_colour = G.C.SET.Tarot,
    secondary_colour = G.C.SECONDARY_SET.Tarot,
    collection_rows = { 1 },
    shop_rate = 0
}

SMODS.Atlas{
    key = "debugcard_atlas",
    path = "debug_print.png",
    px = 71,
    py = 95
}

SMODS.Consumable {
    loc_txt = {
        name = "Debug Card",
        text = {
            "{C:red}[!] OUTPUT: Defined_Global_Input Corrected{}"
        }
    },
    atlas = "debugcard_atlas",
    unlocked = true, 
    key = 'debugcard',
    set = 'DebugScript',
    pos = { x = 0, y = 0 },
    
    in_pool = function(self, args)
        return false
    end,

    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tdec_erratic_bug1')

                for _, j in ipairs(G.jokers.highlighted) do
                    if j.ability and j.ability.tdec_tainted_perish then
                        j.ability.tdec_tainted_perish = nil
                    end
                end

                return true
            end
        }))
        delay(0.6)
    end,

    can_use = function(self, card)
        if #G.jokers.highlighted > 0 then
            for _, j in ipairs(G.jokers.highlighted) do
                if j.ability and j.ability.tdec_tainted_perish then
                    return true
                end
            end
        end
        return false
    end
}


SMODS.Sound({
    vol = 1.0,
    pitch = 1,
    key = "erratic_bug1",
    path = "eden_glitch1.ogg",
})

SMODS.Sound({
    vol = 1.0,
    pitch = 1,
    key = "erratic_bug2",
    path = "eden_glitch2.ogg",
})

SMODS.Sound({
    vol = 1.0,
    pitch = 1,
    key = "checkered_sound",
    path = "lazarusflipdead.ogg",
})

SMODS.Atlas{
    key = "checkered_atlas",
    path = "tainted_checkered.png",
    px = 71,
    py = 95
}

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
    atlas = "checkered_atlas",
    pos = { x = 0, y = 0 },

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
        end
    end,
}

function can_be_tainted(center)
    for i, v in pairs(SMODS.collection_pool(G.P_CENTER_POOLS.Back)) do
        if v.original == center.key then return v end
    end
end

function get_decks_centers()
    local pool = {}
    for i, v in pairs(SMODS.collection_pool(G.P_CENTER_POOLS.Back)) do
        if not v.original and not v.hidden then
            pool[#pool+1] = v
        end
    end
    if G.TAINTED_ENABLED then
        for i, v in pairs(pool) do
            pool[i] = can_be_tainted(v) or G.P_CENTERS.b_tdec_tainted_placeholder
        end
    end
    return pool
end

function G.FUNCS.get_decks_tainted()
    local names = {}
    for i, v in pairs(get_decks_centers()) do
        names[#names+1] = v
    end
    return names
end


G.FUNCS.change_viewed_back = function(args)
  G.viewed_stake = G.viewed_stake or 1
  local deck_pool = get_decks_centers()
  G.GAME.viewed_back:change_to(deck_pool[args.to_key])
  if G.sticker_card then G.sticker_card.sticker = get_deck_win_sticker(G.GAME.viewed_back.effect.center) end
  local max_stake = get_deck_win_stake(G.GAME.viewed_back.effect.center.key) or 0
  G.viewed_stake = math.min(G.viewed_stake, max_stake + 1)
  G.PROFILES[G.SETTINGS.profile].MEMORY.deck = args.to_val
  for key, val in pairs(G.sticker_card.area.cards) do
  	val.children.back = false
  	val:set_ability(val.config.center, true)
  end
end

function get_viewed_back()
    local v = G.PROFILES[G.SETTINGS.profile].MEMORY.deck
    if type(v) ~= "table" then
        G.PROFILES[G.SETTINGS.profile].MEMORY.deck = get_deck_from_name(G.PROFILES[G.SETTINGS.profile].MEMORY.deck)
        v = G.PROFILES[G.SETTINGS.profile].MEMORY.deck
    end
    if not ((G.TAINTED_ENABLED and (v.original or not can_be_tainted(v))) or (not v.original and not G.TAINTED_ENABLED)) then
        v = can_be_tainted(v)
    end
    return Back(v)
end

SMODS.Back({
    key = "tainted_placeholder",
    loc_txt = {
        name = "Coming Soon",
        text = {
            "...?"
        },
        unlock = {
            "Coming Soon..."
        }
    },
    atlas = "erratic_atlas",
    pos = {x = 999, y = 999},
    unlocked = false,
    discovered = false,
    check_for_unlock = function() end,
    hidden = true
})
