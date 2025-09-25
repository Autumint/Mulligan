SMODS.Back {
    original = "b_black",
    key = "tainted_black",
    atlas = "tainted_atlas",
    pos = { x = 4, y = 0 },
    unlocked = true,
    discovered = true,
    config = { joker_slot = 1, extra_hand_bonus = 0 },

    apply = function(self)
        G.GAME.FrailtyCount = 0
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            func = function()
                if G.pactive_area then
                    local c = SMODS.create_card({ key = "c_tdec_lemegeton", no_edition = true })
                    c:add_to_deck()
                    G.pactive_area:emplace(c)
                    c:align()
                end
                return true
            end
        }))
    end,

    calculate = function(self, back, context)
        if G.jokers then
            for _, j in ipairs(G.jokers.cards) do
                if j.edition.tdec_frailty then
                    G.GAME.FrailtyCount = G.GAME.FrailtyCount + 1
                end
            end
        end
        if context.final_scoring_step and G.GAME.FrailtyCount > 0 then
            G.E_MANAGER:add_event(Event({
                func = function()
                    play_sound('gong', 0.5, 0.5)
                    play_sound('gong', 0.5 * 1.2, 0.4)
                    play_sound('tarot1', 0.6)
                    ease_colour(G.C.UI_CHIPS, { 0.4, 0.0, 0.6, 1 })
                    ease_colour(G.C.UI_MULT, { 0.4, 0.0, 0.6, 1 })
                    attention_text({
                        text = 'FRAIL..',
                        scale = 1.4,
                        hold = 2,
                        major = G.play,
                        colour = G.C.PURPLE,
                        align = 'cm',
                        offset = { x = 0, y = -2.7 },
                    })

                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        blockable = false,
                        blocking = false,
                        delay = 4.3,
                        func = function()
                            ease_colour(G.C.UI_CHIPS, G.C.BLUE, 2)
                            ease_colour(G.C.UI_MULT, G.C.RED, 2)
                            return true
                        end
                    }))

                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        blockable = false,
                        blocking = false,
                        no_delete = true,
                        delay = 6.3,
                        func = function()
                            for i = 1, 4 do
                                G.C.UI_CHIPS[i] = G.C.BLUE[i]
                                G.C.UI_MULT[i]  = G.C.RED[i]
                            end
                            return true
                        end
                    }))
                    return true
                end
            }))
            return true
        end
    end,
}
