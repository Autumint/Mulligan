SMODS.Blind {
    key = "beast",
    pos = { x = 0, y = 2 },
    boss = { min = 1 },
    boss_colour = HEX("b95b08"),
    loc_vars = function(self)
        return { vars = {} }
    end,

    in_pool = function(self)
        return true
    end
}
