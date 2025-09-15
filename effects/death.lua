SMODS.DrawStep {
    key = "death_shader",
    order = 20,
    func = function(self)
        if G.GAME.blind and G.GAME.blind.config.blind.key == "bl_tdec_death" then
            if self.ability.set == "Joker" and self.config.center.key ~= "j_tdec_photoquestion" and self.sprite_facing == 'front' and (self.config.center.discovered or self.bypass_discovery_center) then
                self.children.center:draw_shader('voucher', nil, self.ARGS.send_to_shader)
            end
        end
    end
}