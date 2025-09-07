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

        -- #ROMANIANPATCH #THISSHITBLOWS #TEMPORARYSOLUTION #IGNOREYOURPROBLEMSUNTILTHEYGETWORSE
    if not CardArea.__pactive_patch then
    CardArea.__pactive_patch = true

    local old_update = CardArea.update
    function CardArea:update(dt)
        old_update(self, dt)

        if self ~= G.pactive_area then return end

        local booster_states = {
            [G.STATES.TAROT_PACK] = true,
            [G.STATES.SPECTRAL_PACK] = true,
            [G.STATES.PLANET_PACK] = true,
            [G.STATES.STANDARD_PACK] = true,
            [G.STATES.BUFFOON_PACK] = true,
            [G.STATES.SMODS_BOOSTER_OPENED] = true,
        }

        local booster_screen = booster_states[G.STATE]

        if booster_screen and self.states.visible and G.consumeables ~= self then
            if not G._pactive_backup then
                G._pactive_backup = G.consumeables
            end
            G.consumeables = self
            self.config.type = "consumeable"
        end

        if (not booster_screen or not self.states.visible) and G.consumeables == self then
            if G._pactive_backup then
                G.consumeables = G._pactive_backup
                G._pactive_backup = nil
            else
                G.consumeables = nil
            end
        end
    end

    local old_draw = CardArea.draw
    function CardArea:draw(...)
        if self == G.pactive_area and self.config.type == "consumeable" then
            if self.ARGS and self.ARGS.invisible_area_types then
                self.ARGS.invisible_area_types.consumeable = nil
            end
        end
        return old_draw(self, ...)
    end
end

local allowed_decks = {
    "b_tdec_tainted_yellow",
    "b_tdec_tainted_erratic",
    "b_tdec_tainted_nebula"
}

local function is_allowed(key, list)
    for _, v in ipairs(list) do
        if key == v then return true end
    end
    return false
end

    if G.GAME.selected_back then
        local key = G.GAME.selected_back.effect.center.key
        G.pactive_area.states.visible = is_allowed(key, allowed_decks)
    end
end