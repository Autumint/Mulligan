local start_run_reflocust = Game.start_run
function Game:start_run(args)
    self.locust_area = CardArea(
        0, 0,
        self.CARD_W * 4.9,
        self.CARD_H * 0.95,
        { card_limit = 5, type = "jokers", highlight_limit = 1 }
    )
    G.locust_area = self.locust_area
    start_run_reflocust(self, args)
    
    self.locust_ui = UIBox {
        definition = {
            n = G.UIT.ROOT,
            config = { align = 'cm', r = 0.1, colour = G.C.CLEAR, padding = 0.2 },
            nodes = {
                { n = G.UIT.O, config = { object = self.locust_area, draw_layer = 1 } }
            }
        },
        config = { align = 'cmi', offset = { x = 0, y = 0 }, major = self.jokers, bond = 'Weak' }
    }
    G.locust_ui = self.locust_ui

    if G.jokers and G.jokers.config and G.jokers.config.type then
        G.locust_area.states.visible = false
        self.locust_area.config.type = G.jokers.config.type
    end
        local old_can_highlight = CardArea.can_highlight
        function CardArea:can_highlight(card)
            if self == G.locust_area then
                return false
            end
            return old_can_highlight(self, card)
        end
    end