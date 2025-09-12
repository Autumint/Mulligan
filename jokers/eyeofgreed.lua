-- THIS WILL BE THE TAINTED GREEN UNLOCK BTWW

SMODS.Joker{
    key = "eyeofgreed",
    atlas = "tainted_atlas",
    blueprint_compat = true,
    perishable_compat = false,
    rarity = 2,
    cost = 5,
    pos = { x = 3, y = 0 },
    config = { extra = { moneygive = 3, xmult = 0.5, base = 1 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.moneygive, card.ability.extra.xmult } }
    end,

    in_pool = function(self)
        return false
    end,

    calculate = function(self, card, context)
        if context.after then
            local played_count = #G.play.cards

            for i = 1, played_count do
                G.E_MANAGER:add_event(Event({
                    func = function()
                        if G.play.cards[i] then
                        G.play.cards[i]:juice_up()
                    end
                    return true
                end,
                }))
                ease_dollars(-1)
                delay(0.23)
            end
        end

        if context.joker_main then
            local count = #context.full_hand or 0
            return {
                xmult = card.ability.extra.base + count * card.ability.extra.xmult
            }
        end
    end
}