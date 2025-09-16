SMODS.current_mod.calculate = function(self, context)
    if G.GAME.round_resets.ante == 8 and G.GAME.round_resets.blind_states.Small == 'Upcoming' then
        if context.starting_shop then
            local card = SMODS.add_card {
                set = "Joker",
                area = G.shop_jokers,
                key_append = "v",
                key = "j_tdec_photoquestion"
            }
            card.ability.couponed = true
            card:set_cost()
            create_shop_card_ui(card, 'Joker', G.shop_jokers)
            G.shop_jokers.T.w = math.min((G.GAME.shop.joker_max+1)*1.02*G.CARD_W,4.08*G.CARD_W); G.shop:recalculate()
        end
    end
end
