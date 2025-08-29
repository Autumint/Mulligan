local debugkeeper = false
local roundkeeper = 3

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
        if card.config and card.config.center and card.config.center.key == "c_tdec_debugcard" then
            remove_sell_button(m)
        end
        return m
    end
end

SMODS.Consumable {
    atlas = "debugcard_atlas",
    unlocked = true, 
    key = 'debugcard',
    set = 'taintedcards',
    pos = { x = 0, y = 0 },
    eternal_compat = true,

    loc_vars = function(self, info_queue, card)
        return { vars = { roundkeeper } }
    end,

    keep_on_use = function(self, card)
        return true 
    end,

    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tdec_erratic_bug1')
                debugkeeper = true
                roundkeeper = 0
                for _, j in ipairs(G.jokers.highlighted) do
                    if j.ability and j.ability.tdec_tainted_perish then
                        j.ability.tdec_tainted_perish = nil
                    end
                end
                return true
            end
        }))
    end,

    in_pool = function(self)
        return false
    end,

    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval and debugkeeper and roundkeeper < 3 then
            roundkeeper = roundkeeper + 1
        end

        if context.end_of_round and context.main_eval and roundkeeper >= 3 and G.GAME.round ~= 1 then
            debugkeeper = false
            return { message = "ERRDEC? ACTIVE?" }
        end
    end,

    can_use = function(self, card)
        if not debugkeeper and #G.jokers.highlighted > 0 then
            for _, j in ipairs(G.jokers.highlighted) do
                if j.ability and j.ability.tdec_tainted_perish then
                    return true
                end
            end
        end
        return false
    end
}