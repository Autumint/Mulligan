-- THIS WILL BE THE TAINTED GHOST DECK UNLOCK

SMODS.Joker {
    key = "purgatory",
    atlas = "Purgatory_Atlas",
    blueprint_compat = true,
    perishable_compat = false,
    rarity = 2,
    cost = 5,
    pos = { x = 0, y = 0 },
    config = { extra = { Xmult = 1, Xmult_mod_tarot = 0.5, Xmult_mod_spectral = 1 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult_mod, card.ability.extra.Xmult } }
    end,

    calculate = function(self, card, context)
        if context.using_consumeable and not context.blueprint and context.consumeable.ability.set == 'Tarot' then
            card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_mod_tarot
            return {
                message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } }
            }
        end

        if context.using_consumeable and not context.blueprint and context.consumeable.ability.set == 'Spectral' then
            card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_mod_spectral
            return {
                message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } }
            }
        end

        if context.after and context.main_eval and not context.blueprint and card.ability.extra.Xmult ~= 1 then
            card.ability.extra.Xmult = 1
            return {
                message = ('Purged..')
            }
        end

        if context.joker_main then
            return {
                Xmult = card.ability.extra.Xmult
            }        
        end
    end
}