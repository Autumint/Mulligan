SMODS.Consumable {
    atlas = "debugcard_atlas",
    unlocked = true, 
    key = 'debugcard',
    set = 'taintedcards',
    pos = { x = 0, y = 0 },

    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tdec_erratic_bug1')

                for _, j in ipairs(G.jokers.highlighted) do
                    if j.ability and j.ability.tdec_tainted_perish then
                        j.ability.tdec_tainted_perish = nil
                    end
                end

                return true
            end
        }))
        delay(0.6)
    end,

    in_pool = function(self)
        return false
    end,
    
    can_use = function(self, card)
        if #G.jokers.highlighted > 0 then
            for _, j in ipairs(G.jokers.highlighted) do
                if j.ability and j.ability.tdec_tainted_perish then
                    return true
                end
            end
        end
        return false
    end
}