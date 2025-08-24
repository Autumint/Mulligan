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

SMODS.Back{
    original = "b_painted",
    key = "tainted_painted",
    atlas = "tainted_atlas",
    pos = {x = 4, y = 1},
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