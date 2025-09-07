local function ensure_abyss()
    if not G.GAME then return end
    G.GAME.abyss = G.GAME.abyss or {
        abyssround = 2,
        abyssactive = false,
        abyssmessage = true
    }
end


local abyss_consumable_to_joker = {
    c_heirophant   = "j_tdec_hierophant_locust",
    c_magician = "j_tdec_lucky_locust",
    c_empress = "j_tdec_empress_locust",
    c_hermit = "j_tdec_wealthy_locust",
    c_fool = "j_tdec_foolish_locust",
    c_strength = "j_tdec_powerful_locust",
    c_soul = "j_tdec_soulless_locust",
    c_hanged_man = "j_tdec_executioner_locust",
    c_talisman = "j_tdec_golden_locust",
    c_black_hole = "j_tdec_singularity_locust",
    c_death = "j_tdec_mitosis_locust"
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
    loc_vars = function(self, info_queue, card)
    ensure_abyss()
    if not G.GAME then return { vars = {0}, main_end = {} } end

    local active = G.GAME.abyss.abyssactive
    local status_text = active and "Ready To Consume" or "Dormant..."
    local colour = active and G.C.GREEN or G.C.RED

    local main_end = {
        { n = G.UIT.C, config = { align = "bm", padding = 0.02 }, nodes = {
            { n = G.UIT.C, config = { align = "m", colour = colour, r = 0.05, padding = 0.05 }, nodes = {
                { n = G.UIT.T, config = { text = ' ' .. status_text .. ' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.3, shadow = true } }
            }}
        }}
    }

    return { vars = { G.GAME.abyss.abyssround }, main_end = main_end }
end,

    keep_on_use = function(self, card)
        return true
    end,

    use = function(self, card, area, copier)
        ensure_abyss()
        G.GAME.abyss.abyssround = 0
        G.GAME.abyss.abyssactive = true
        G.GAME.abyss.abyssmessage = false
        card:juice_up(0.8, 0.8)
        G.E_MANAGER:add_event(Event({
            func = function()
                card_eval_status_text(card, 'extra', nil, nil, nil, {
                    message = "Consume.."
                })
                return true
            end
        }))
    end,

    calculate = function(self, card, context)
        ensure_abyss()
        if context.end_of_round and context.main_eval and G.GAME.abyss.abyssround  < 2 and not G.GAME.abyss.abyssactive then
            G.GAME.abyss.abyssround = G.GAME.abyss.abyssround + 1
        end
        if context.end_of_round and G.GAME.abyss.abyssround == 2 and context.main_eval and not G.GAME.abyss.abyssmessage then
            G.E_MANAGER:add_event(Event({
            func = function()
                card_eval_status_text(card, 'extra', nil, nil, nil, {
                    message = "Ready.."
                })
                G.GAME.abyss.abyssmessage = true
                return true
            end
        }))
        end
        if context.end_of_round and G.GAME.abyss.abyssactive then
            G.E_MANAGER:add_event(Event({
            func = function()
                card_eval_status_text(card, 'extra', nil, nil, nil, {
                    message = "Enshadowed.."
                })
                return true
            end
        }))
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
