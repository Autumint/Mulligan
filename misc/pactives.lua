local start_run_ref = Game.start_run
function Game:start_run(args)
    if not self.pactive_area then
        self.pactive_area = CardArea(
            17.4, 5,
            self.CARD_W * 1,
            self.CARD_H * 1,
            { card_limit = 1, type = "jokers", highlight_limit = 1 }
        )
    end
    G.pactive_area = self.pactive_area
    start_run_ref(self, args)

    if not self.pactive_ui then
        self.pactive_ui = UIBox {
            definition = {
                n = G.UIT.ROOT,
                config = { align = 'cm', r = 0.1, colour = G.C.CLEAR, padding = 0.2 },
                nodes = {
                    { n = G.UIT.O, config = { object = self.pactive_area, draw_layer = 1 } }
                }
            },
            config = { align = 'cmi', offset = { x = 8.7, y = 5 }, major = self.jokers, bond = 'Weak' }
        }
        G.pactive_ui = self.pactive_ui
    end

    if G.consumeables and G.consumeables.config and G.consumeables.config.type then
        self.pactive_area.config.type = G.consumeables.config.type
    end
end