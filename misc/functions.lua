function spawn_beast_hp_ui()
    if not (G.GAME.blind and G.GAME.blind.config.blind.key == "bl_tdec_beast") then
        return
    end
    if not G.GAME.BeastProgress then
        return
    end

    G.HP_ui = UIBox {
        definition = {
            n = G.UIT.ROOT,
            config = {
                align = "cm",
                padding = 0.05,
                colour = G.C.CLEAR,
                offset = { x = 0, y = 0 },
                major = G.jokers,
                bond = "Weak"
            },
            nodes = {
                create_progress_bar({
                    label = "The Beast",
                    ref_table = G.GAME,
                    ref_value = "BeastProgress",
                    w = 7,
                    h = 0.5,
                    min = 0,
                    max = 100,
                    colour = G.C.RED,
                    bg_colour = G.C.BLACK,
                    bar_rotation = "Horizontal",
                })
            }
        },
        config = {
            align = "cm",
            padding = 0.05,
            colour = G.C.CLEAR,
            offset = { x = 0, y = 2.2 },
            major = G.jokers,
            bond = "Weak"
        }
    }
end