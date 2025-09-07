do
    local original_use_and_sell = G.UIDEF.use_and_sell_buttons

    local function remove_sell_button(node)
        if not node or not node.nodes then return end
        for i = #node.nodes, 1, -1 do
            local child = node.nodes[i]
            if child.config and child.config.button == "sell_card" then
                table.remove(node.nodes, i)
            else
                remove_sell_button(child)
            end
        end
    end

    function G.UIDEF.use_and_sell_buttons(card)
        local m = original_use_and_sell(card)
        if card.config and card.config.center and card.config.center.key == "c_tdec_soulless_locust" then
            remove_sell_button(m)
        end
        return m
    end
end

SMODS.Joker{
    key = "soulless_locust",
    atlas = "tainted_atlas",
    blueprint_compat = true,
    perishable_compat = false,
    rarity = 4,
    cost = 0,
    pos = { x = 0, y = 0 },

    config = { extra = {
        size = 1,
        xmult = 1,
        face_gain = 0.5,
        canio_odds = 3,
        yorick_gain = 0.5,
        discards = 30,
        discards_remaining = 30,
        triboulet_xmult = 1.5,
        triboulet_odds = 3,
        perkeo_odds = 3,
        chicot_odds = 3
    }},

    loc_vars = function(self, info_queue, card)
        local cn, cd = SMODS.get_probability_vars(card, 1, card.ability.extra.canio_odds, 'soulless_canio')
        local yn, yd = SMODS.get_probability_vars(card, 1, card.ability.extra.triboulet_odds, 'soulless_triboulet')
        local pn, pd = SMODS.get_probability_vars(card, 1, card.ability.extra.perkeo_odds, 'soulless_perkeo')
        local chn, chd = SMODS.get_probability_vars(card, 1, card.ability.extra.chicot_odds, 'soulless_chicot')
        return { vars = {
            card.ability.extra.size,
            cn, cd,
            card.ability.extra.face_gain,
            card.ability.extra.yorick_gain,
            card.ability.extra.discards,
            yn, yd,
            card.ability.extra.triboulet_xmult,
            pn, pd,
            chn, chd,
            card.ability.extra.xmult
        }}
    end,

    in_pool = function(self)
        return false
    end,

    add_to_deck = function(self, card, from_debuff)
        G.locust_area.config.card_limit = G.locust_area.config.card_limit + card.ability.extra.size
        if G.GAME.blind and G.GAME.blind.boss and not G.GAME.blind.disabled then
            if SMODS.pseudorandom_probability(card, 'soulless_chicot_add', 1, card.ability.extra.chicot_odds) then
                G.GAME.blind:disable()
                play_sound('timpani')
                SMODS.calculate_effect({ message = localize('ph_boss_disabled') }, card)
            end
        end
    end,

    remove_from_deck = function(self, card, from_debuff)
        G.locust_area.config.card_limit = G.locust_area.config.card_limit - card.ability.extra.size
    end,

    calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint and context.blind and context.blind.boss then
            if SMODS.pseudorandom_probability(card, 'soulless_chicot', 1, card.ability.extra.chicot_odds) then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                if G.GAME.blind and not G.GAME.blind.disabled then
                                    G.GAME.blind:disable()
                                    play_sound('timpani')
                                end
                                delay(0.4)
                                return true
                            end
                        }))
                        SMODS.calculate_effect({ message = localize('ph_boss_disabled') }, card)
                        return true
                    end
                }))
                return nil, true
            end
        end

        if context.ending_shop and not context.blueprint and G.consumeables.cards[1] then
            if SMODS.pseudorandom_probability(card, 'soulless_perkeo', 1, card.ability.extra.perkeo_odds) then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        local card_to_copy = nil
                        if G.consumeables and G.consumeables.cards and #G.consumeables.cards > 0 then
                            card_to_copy = select(1, pseudorandom_element(G.consumeables.cards, 'soulless_perkeo'))
                        end
                        if card_to_copy then
                            local copied = copy_card(card_to_copy)
                            copied:set_edition('e_negative', true)
                            copied:add_to_deck()
                            G.consumeables:emplace(copied)
                        end
                        return true
                    end
                }))
                return { message = localize('k_duplicated_ex') }
            end
        end

        if context.remove_playing_cards and not context.blueprint and context.removed then
            local faces = 0
            for _, removed_card in ipairs(context.removed) do
                if removed_card.is_face and removed_card:is_face() then
                    faces = faces + 1
                end
            end
            if faces > 0 then
                if SMODS.pseudorandom_probability(card, 'soulless_canio', 1, card.ability.extra.canio_odds) then
                    card.ability.extra.xmult = card.ability.extra.xmult + faces * card.ability.extra.face_gain
                    return {
                        message = localize{ type = 'variable', key = 'a_xmult', vars = { card.ability.extra.xmult } }
                    }
                end
            end
        end

        if context.discard and not context.blueprint then
            if card.ability.extra.discards_remaining <= 1 then
                card.ability.extra.discards_remaining = card.ability.extra.discards
                card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.yorick_gain
                return {
                    message = localize{ type = 'variable', key = 'a_xmult', vars = { card.ability.extra.xmult } },
                    colour = G.C.RED
                }
            else
                card.ability.extra.discards_remaining = card.ability.extra.discards_remaining - 1
                return nil, true
            end
        end

        if context.individual and context.cardarea == G.play and context.other_card then
            local id = context.other_card.get_id and context.other_card:get_id()
            if id and (id == 12 or id == 13) then
                if SMODS.pseudorandom_probability(card, 'soulless_triboulet', 1, card.ability.extra.triboulet_odds) then
                    return { xmult = card.ability.extra.triboulet_xmult }
                end
            end
        end

        if context.joker_main then
            return { xmult = card.ability.extra.xmult }
        end
    end,
}