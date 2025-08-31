SMODS.Back{
    original = "b_yellow",
    key = "tainted_yellow",
    atlas = "tainted_atlas",
    pos = { x = 2, y = 0 },
    unlocked = true,
    discovered = true,
    config = {},

    -- these are useless since we want to skip shops fully. I was just messing around
    apply = function(self)
        change_shop_size(-2)
        SMODS.change_booster_limit(-2)
        SMODS.change_voucher_limit(-1)
    end
}