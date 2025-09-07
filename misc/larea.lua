local start_run_reflocust = Game.start_run
function Game:start_run(args)
    if not self.locust_area then
        self.locust_area = CardArea(
            0, 0,
            self.CARD_W * 4.9,
            self.CARD_H * 0.95,
            { card_limit = 5, type = "jokers", highlight_limit = 1 }
        )
    end
    G.locust_area = self.locust_area
    start_run_reflocust(self, args)

    if not self.locust_ui then
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
    end

    if G.jokers and G.jokers.config and G.jokers.config.type then
        self.locust_area.config.type = G.jokers.config.type
    end

local allowed_decks = {
    "b_tdec_tainted_nebula"
}

local function is_allowed(key, list)
    for _, v in ipairs(list) do
        if key == v then return false end
    end
    return false
end

    if G.GAME.selected_back then
        local key = G.GAME.selected_back.effect.center.key
        G.locust_area.states.visible = is_allowed(key, allowed_decks)
    end
end