local function ensure_abyss()
    if not G.GAME then return end
    G.GAME.abyss = G.GAME.abyss or {
        abyssround = 2,
        abyssactive = false
    }
end


local abyss_consumable_to_joker = {
    c_heirophant   = "j_tdec_hierophant_locust",
    c_magician = "j_tdec_lucky_locust",
    c_empress = "j_tdec_empress_locust",
    c_hermit = "j_tdec_wealthy_locust",
    c_fool = "j_tdec_foolish_locust"
    -- this is where we'll store data for consumables and which locust it spawns. A lil rough but it's a pretty simple method :)
}
do
    local original_use_consumeable = Card.use_consumeable

    function Card:use_consumeable(area, copier)
        if G.GAME and G.GAME.abyss and G.GAME.abyss.abyssactive then
            if self.config and self.config.center then
                local used_key = self.config.center.key
                G.GAME.abyss.last_consumable = used_key
                G.GAME.abyss.abyssactive = false

                local spawn_key = abyss_consumable_to_joker[used_key]
                if spawn_key then
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        func = function()
                            local c = create_card('Joker', G.jokers, nil, nil, nil, nil, spawn_key)
                            c:add_to_deck()
                            G.jokers:emplace(c)
                            c:juice_up(0.8, 0.8)
                            return true
                        end
                    }))
                end
            end
            return
        end
        return original_use_consumeable(self, area, copier)
    end
end

do
    local original_can_use_consumeable = Card.can_use_consumeable

    function Card:can_use_consumeable(area, copier)
        if G.GAME and G.GAME.abyss and G.GAME.abyss.abyssactive then
            if self.config and self.config.center and self.config.center.key ~= "c_tdec_abyss" then
                return true
            end
        end
        return original_can_use_consumeable(self, area, copier)
    end
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
        if card.config and card.config.center and card.config.center.key == "c_tdec_abyss" then
            remove_sell_button(m)
        end
        return m
    end
end

SMODS.Consumable{
    atlas = "tainted_atlas",
    unlocked = true,
    key = "abyss",
    set = "taintedcards",
    pos = {x = 0, y = 0},
    eternal_compat = true,

apply = function(self)
    G.GAME.abyssroundkeeper = 1
    return true
end,

loc_vars = function(self, info_queue, card)
    ensure_abyss()
    if not G.GAME then return { vars = {0}, main_end = {} } end
    return { vars = { G.GAME.abyss.abyssround } }
end,

    keep_on_use = function(self, card)
        return true
    end,

    use = function(self, card, area, copier)
        ensure_abyss()
        G.GAME.abyss.abyssround = 0
        G.GAME.abyss.abyssactive = true
        return {
            message = "Consume"
        }
    end,

    calculate = function(self, card, context)
        ensure_abyss()
        if context.end_of_round and context.main_eval and G.GAME.abyss.abyssround  < 2 and not G.GAME.abyss.abyssactive then
            G.GAME.abyss.abyssround = G.GAME.abyss.abyssround + 1
        end
        if context.end_of_round and G.GAME.abyss.abyssactive then
            G.GAME.abyss.abyssactive = false
        end
    end,


    in_pool = function(self)
        return false
    end,

    can_use = function(self, card)
        ensure_abyss()
        if G.GAME.abyss.abyssround == 2 then
            return true
        end
    end
}

