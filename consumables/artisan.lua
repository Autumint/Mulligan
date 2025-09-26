SMODS.Consumable {
    unlocked = true,
    discovered = true,
    key = 'artisan',
    set = 'taintedcards',
    pos = { x = 0, y = 0 },
    eternal_compat = true,

    loc_vars = function(self, info_queue, card)
        local sketched_center = G.GAME.SketchedJokerKey and G.P_CENTERS[G.GAME.SketchedJokerKey] or nil
        local joker_name = sketched_center and
            localize { type = 'name_text', key = sketched_center.key, set = sketched_center.set } or localize('k_none')
        if sketched_center then info_queue[#info_queue + 1] = sketched_center end
        local colour = sketched_center and G.C.GREEN or G.C.RED
        local main_end = {
            {
                n = G.UIT.C,
                config = { align = "bm", padding = 0.02 },
                nodes = {
                    {
                        n = G.UIT.C,
                        config = { align = "m", colour = colour, r = 0.05, padding = 0.05 },
                        nodes = {
                            { n = G.UIT.T, config = { text = ' ' .. joker_name .. ' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.3, shadow = true } }
                        }
                    }
                }
            }
        }
        return {
            vars = {
                G.GAME.SketchRounds or 0,
                G.GAME.ChiselRounds or 0,
                G.GAME.SketchedJokerKey or "None"
            },
            main_end = main_end
        }
    end,

    keep_on_use = function(self, card) return true end,

    use = function(self, card, area, copier)
        for _, j in ipairs(G.jokers.highlighted) do
            if j.config and j.config.center and j.config.center.key == "j_tdec_dried_joker" then
                G.E_MANAGER:add_event(Event({
                    trigger = "before",
                    func = function()
                        G.GAME.ChiselRounds = 0
                        j:flip()
                        return true
                    end
                }))
                G.E_MANAGER:add_event(Event({
                    func = function()
                        if G.GAME.SketchRecordActive and G.GAME.SketchedJokerKey then
                            j:set_ability(G.P_CENTERS[G.GAME.SketchedJokerKey])
                            G.GAME.SketchedJokerKey = nil
                            G.GAME.SketchRecordActive = false
                        else
                            j:set_ability(TDECKS.random_joker_center())
                        end
                        G.GAME.ChiselMessageCheck = false
                        return true
                    end
                }))
                G.E_MANAGER:add_event(Event({
                    trigger = "after",
                    func = function()
                        j:flip()
                        return true
                    end
                }))
                return
            end
        end
        local highlight_sets = {}
        if G.jokers then table.insert(highlight_sets, G.jokers.highlighted) end
        if G.shop_jokers then table.insert(highlight_sets, G.shop_jokers.highlighted) end
        if G.pack_cards then table.insert(highlight_sets, G.pack_cards.highlighted) end
        for _, set in ipairs(highlight_sets) do
            for _, j in ipairs(set) do
                if j.config and j.config.center and j.config.center.key ~= "j_tdec_dried_joker" then
                    G.GAME.SketchedJokerKey = j.config.center.key
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            card:juice_up()
                            G.GAME.SketchRounds = 0
                            G.GAME.SketchRecordActive = true
                            G.GAME.SketchMessageCheck = false
                            return true
                        end
                    }))
                    return
                end
            end
        end
    end,

    in_pool = function(self) return false end,

    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval then
            if (G.GAME.SketchRounds or 0) < 8 then
                G.GAME.SketchRounds = (G.GAME.SketchRounds or 0) + 1
            end
            if (G.GAME.ChiselRounds or 0) < 3 then
                G.GAME.ChiselRounds = (G.GAME.ChiselRounds or 0) + 1
            end
        end

        if context.end_of_round and context.main_eval then
            if G.GAME.SketchRounds == 8 and not G.GAME.SketchMessageCheck then
                G.GAME.SketchMessageCheck = true
                return { message = "Write the future..." }
            end
            if G.GAME.ChiselRounds == 3 and G.GAME.round ~= 1 and not G.GAME.ChiselMessageCheck then
                G.GAME.ChiselMessageCheck = true
                return { message = "Carve it..." }
            end
        end
    end,

    can_use = function(self, card)
        local highlight_groups = 0
        if #G.jokers.highlighted > 0 then highlight_groups = highlight_groups + 1 end
        if G.shop_jokers and #G.shop_jokers.highlighted > 0 then highlight_groups = highlight_groups + 1 end
        if G.pack_cards and #G.pack_cards.highlighted > 0 then highlight_groups = highlight_groups + 1 end
        if highlight_groups > 1 then return false end

        if G.GAME.SketchRounds >= 8 then
            for _, j in ipairs(G.jokers.highlighted) do
                if j.config and j.config.center and j.config.center.key ~= "j_tdec_dried_joker" then
                    return true
                end
            end
            if G.shop_jokers then
                for _, j in ipairs(G.shop_jokers.highlighted) do
                    if j.config and j.config.center and j.config.center.key ~= "j_tdec_dried_joker" then
                        return true
                    end
                end
            end
            if G.pack_cards then
                for _, j in ipairs(G.pack_cards.highlighted) do
                    if j.config and j.config.center and j.config.center.key ~= "j_tdec_dried_joker" and j.ability.set == "Joker" then
                        return true
                    end
                end
            end
        end

        if G.GAME.ChiselRounds >= 3 then
            for _, j in ipairs(G.jokers.highlighted) do
                if j.config and j.config.center and j.config.center.key == "j_tdec_dried_joker" then
                    return true
                end
            end
        end

        return false
    end
}

local start_run_ref = Game.start_run
function Game:start_run(args)
    start_run_ref(self, args)
    if not G.GAME.ARTISANLOADED then
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.ARTISANLOADED = true
                G.GAME.SketchRounds = 4
                G.GAME.SketchedJokerKey = nil
                G.GAME.SketchRecordActive = false
                G.GAME.SketchMessageCheck = false
                G.GAME.ChiselRounds = 0
                G.GAME.ChiselMessageCheck = false
                return true
            end
        }))
    end
end
