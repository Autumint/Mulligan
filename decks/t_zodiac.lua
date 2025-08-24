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
    atlas = "tainted_atlas", 
    pos = {x = 6, y = 1}, 
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