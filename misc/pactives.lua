local start_run_ref = Game.start_run
function Game:start_run(args)
    if not CardArea.__pactive_counter_patch then
        CardArea.__pactive_counter_patch = true

        local old_draw = CardArea.draw
        function CardArea:draw(...)
            if not self.states.visible then return end

            if self == G.pactive_area then
                if not self.children.area_uibox then
                    self.children.area_uibox = UIBox{
                        definition = {
                            n = G.UIT.ROOT,
                            config = { align = 'cm', colour = G.C.CLEAR },
                            nodes = {
                                { n = G.UIT.R, config = {
                                    minw = self.T.w,
                                    minh = self.T.h,
                                    align = "cm",
                                    padding = 0.1,
                                    mid = true,
                                    r = 0.1,
                                    colour = {0,0,0,0.1},
                                    ref_table = self
                                } }
                            }
                        },
                        config = { align = 'cm', offset = { x = 0, y = 0 }, major = self, parent = self }
                    }
                end

                self.children.area_uibox:draw()
                self:draw_boundingrect()
                add_to_drawhash(self)

                for _, layer in ipairs(self.ARGS.draw_layers or {'shadow','card'}) do
                    for _, card in ipairs(self.cards) do
                        if card ~= G.CONTROLLER.dragging.target then
                            card:draw(layer)
                        end
                    end
                end

                if self.config.type == "consumeable" and self.ARGS and self.ARGS.invisible_area_types then
                    self.ARGS.invisible_area_types.consumeable = nil
                end

                return
            end
            return old_draw(self, ...)
        end

        local old_can_highlight = CardArea.can_highlight
        function CardArea:can_highlight(card)
            if self == G.pactive_area then
                return false
            end
            return old_can_highlight(self, card)
        end
    end

    if not self.pactive_area then
        self.pactive_area = CardArea(
            17.4, 5,
            self.CARD_W,
            self.CARD_H,
            { card_limit = 1, type = "consumeable", highlight_limit = 1 }
        )
    end
    G.pactive_area = self.pactive_area

    start_run_ref(self, args)

    if not self.pactive_ui then
        self.pactive_ui = UIBox{
            definition = {
                n = G.UIT.ROOT,
                config = { align = 'cm', r = 0.1, colour = G.C.CLEAR, padding = 0.2 },
                nodes = { { n = G.UIT.O, config = { object = self.pactive_area, draw_layer = 1 } } }
            },
            config = { align = 'cmi', offset = { x = 8.7, y = 5 }, major = self.jokers, bond = 'Weak' }
        }
        G.pactive_ui = self.pactive_ui
    end

    if G.consumeables and G.consumeables.config and G.consumeables.config.type then
        self.pactive_area.config.type = G.consumeables.config.type
    end

    if G.GAME and G.GAME.selected_back then
        local allowed_decks = {
            "b_tdec_tainted_yellow",
            "b_tdec_tainted_erratic",
            "b_tdec_tainted_nebula",
            "b_tdec_tainted_painted",
            "b_tdec_tainted_anaglyph",
            "b_tdec_tainted_checkered"
        }

        local function is_allowed(key, list)
            for _, v in ipairs(list) do
                if key == v then return true end
            end
            return false
        end

        local key = G.GAME.selected_back.effect.center.key
        G.pactive_area.states.visible = is_allowed(key, allowed_decks)
    end
end