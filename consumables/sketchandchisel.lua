local function ensure_CSData()
    if not G.GAME then return end
    G.GAME.CSData = G.GAME.CSData or {
        roundkeeper = 0,
        sroundkeeper = 4,
        sketched_joker_key = nil,
        sketchrecordactive = false,
        messagechisel = false,
        messagesketch = false,
    }
end

function TDECKS.random_joker_center(_rarity)
    local center
    local _pool, _pool_key = get_current_pool("Joker", _rarity, false, "tdeck_painted")
    center = pseudorandom_element(_pool, pseudoseed(_pool_key))
    local it = 1
    while center == 'UNAVAILABLE' do
        it = it + 1
        center = pseudorandom_element(_pool, pseudoseed(_pool_key..'_resample'..it))
    end

    center = G.P_CENTERS[center]
    return center
end

do
    local original_use_and_sell = G.UIDEF.use_and_sell_buttons

    local function remove_sell_button(node)
        if not node or not node.nodes then return end
        for i = #node.nodes, 1, -1 do
            local child = node.nodes[i]
            if child.config and child.config.button == "sell_card" then
                table.remove(node.nodes, i)
            else
                remove_sell_button(child)
            end
        end
    end

    function G.UIDEF.use_and_sell_buttons(card)
        local m = original_use_and_sell(card)
        if card.config and card.config.center and card.config.center.key == "c_tdec_thechisel" or card.config.center.key == "c_tdec_thesketch" or card.ability.tdec_Eroding then
            remove_sell_button(m)
        end
        return m
    end
end

SMODS.Consumable {
    unlocked = true, 
    key = 'thesketch',
    set = 'taintedcards',
    pos = { x = 0, y = 0 },
    eternal_compat = true,

    loc_vars = function(self, info_queue, card)
        if not G.GAME then return { vars = {0, "None"}, main_end = {} } end
        ensure_CSData()
        local sketched_center = G.GAME.CSData.sketched_joker_key and G.P_CENTERS[G.GAME.CSData.sketched_joker_key] or nil
        local joker_name = sketched_center and localize { type = 'name_text', key = sketched_center.key, set = sketched_center.set } or localize('k_none')
        local colour = sketched_center and G.C.GREEN or G.C.RED
        if sketched_center then info_queue[#info_queue+1] = sketched_center end
        local main_end = {
            { n = G.UIT.C, config = { align = "bm", padding = 0.02 }, nodes = {
                { n = G.UIT.C, config = { align = "m", colour = colour, r = 0.05, padding = 0.05 }, nodes = {
                    { n = G.UIT.T, config = { text = ' ' .. joker_name .. ' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.3, shadow = true } }
                }}
            }}
        }
        return { vars = { G.GAME.CSData.sroundkeeper, G.GAME.CSData.sketched_joker_key or "None" }, main_end = main_end }
    end,

    keep_on_use = function(self, card) return true end,

    use = function(self, card, area, copier)
    ensure_CSData()
    for _, j in ipairs(G.jokers.highlighted) do
        if j.config and j.config.center and j.config.center.key ~= "j_tdec_dried_joker" then
            G.GAME.CSData.sketched_joker_key = j.config.center.key
            G.E_MANAGER:add_event(Event({
                func = function()
                    card:juice_up()
                    G.GAME.CSData.sroundkeeper = 0
                    G.GAME.CSData.sketchrecordactive = true
                    G.GAME.CSData.messagesketch = false
                    return true
                end
            }))
        end
    end

    if G.shop_jokers and G.shop_jokers.highlighted then
        for _, j in ipairs(G.shop_jokers.highlighted) do
            if j.config and j.config.center and j.config.center.key ~= "j_tdec_dried_joker" then
                G.GAME.CSData.sketched_joker_key = j.config.center.key
                G.E_MANAGER:add_event(Event({
                    func = function()
                        card:juice_up()
                        G.GAME.CSData.sroundkeeper = 0
                        G.GAME.CSData.sketchrecordactive = true
                        G.GAME.CSData.messagesketch = false
                        return true
                    end
                }))
            end
        end
    end
end,

    in_pool = function(self) 
        return false 
    end,

    calculate = function(self, card, context)
        ensure_CSData()
        if context.end_of_round and context.main_eval and G.GAME.CSData.sroundkeeper < 8 then
            G.GAME.CSData.sroundkeeper = G.GAME.CSData.sroundkeeper + 1
        end
        if context.end_of_round and context.main_eval and G.GAME.CSData.sroundkeeper == 8 and not G.GAME.CSData.messagesketch then
            G.GAME.CSData.messagesketch = true
            return { message = "Write the future..." }
        end
    end,

    can_use = function(self, card)
        ensure_CSData()
    

    if G.GAME.CSData.sroundkeeper >= 8 and #G.jokers.highlighted > 0 then
        for _, j in ipairs(G.jokers.highlighted) do
            if j.config and j.config.center and j.config.center.key ~= "j_tdec_dried_joker" then
                return true
            end
        end
    end

    if G.GAME.CSData.sroundkeeper >= 8 and G.shop_jokers and #G.shop_jokers.highlighted > 0 then
        for _, j in ipairs(G.shop_jokers.highlighted) do
            if j.config and j.config.center and j.config.center.key ~= "j_tdec_dried_joker" then
                return true
            end
        end
    end

    return false
end
}

SMODS.Consumable {
    unlocked = true, 
    key = 'thechisel',
    set = 'taintedcards',
    pos = { x = 0, y = 0 },
    eternal_compat = true,

    loc_vars = function(self, info_queue, card)
        if not G.GAME then return { vars = {0}, main_end = {} } end
        ensure_CSData()
        return { vars = { G.GAME.CSData.roundkeeper } }
    end,

    keep_on_use = function(self, card) return true end,

    use = function(self, card, area, copier)
    ensure_CSData()
    for _, j in ipairs(G.jokers.highlighted) do
        if j.config and j.config.center and j.config.center.key == "j_tdec_dried_joker" then
            G.E_MANAGER:add_event(Event({
                trigger = "before",
                func = function()
                    G.GAME.CSData.roundkeeper = 0
                    j:flip()
                    return true
                end
            }))
            G.E_MANAGER:add_event(Event({
                func = function()
                    if G.GAME.CSData.sketchrecordactive and G.GAME.CSData.sketched_joker_key then
                        j:set_ability(G.P_CENTERS[G.GAME.CSData.sketched_joker_key])
                        G.GAME.CSData.sketched_joker_key = nil
                        G.GAME.CSData.sketchrecordactive = false
                    else      
                        j:set_ability(TDECKS.random_joker_center())
                    end
                    G.GAME.CSData.messagechisel = false
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
        end
    end
end,

    in_pool = function(self) 
        return false 
    end,

    calculate = function(self, card, context)
        ensure_CSData()
        if context.end_of_round and context.main_eval and G.GAME.CSData.roundkeeper < 3 then
            G.GAME.CSData.roundkeeper = G.GAME.CSData.roundkeeper + 1
        end
        if context.end_of_round and context.main_eval and G.GAME.CSData.roundkeeper == 3 and G.GAME.round ~= 1 and not G.GAME.CSData.messagechisel then
            G.GAME.CSData.messagechisel = true
            return { message = "Carve it..." } 
        end
    end,

    can_use = function(self, card)
        ensure_CSData()
        if G.GAME.CSData.roundkeeper == 3 and #G.jokers.highlighted > 0 then
            for _, j in ipairs(G.jokers.highlighted) do
                if j.config and j.config.center and j.config.center.key == "j_tdec_dried_joker" then
                    return true
                end
            end
        end
        return false
    end
}
