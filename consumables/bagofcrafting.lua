local crafting_consumable_values = {
    c_fool           = 3,
    c_magician       = 2,
    c_high_priestess = 2,
    c_mercury        = 2,
    c_saturn         = 2,
    c_neptune        = 2,
    c_pluto          = 2,
    c_ceres          = 3,
    c_eris           = 3,
    c_planet_x       = 3,
    c_soul           = 12,
    c_black_hole     = 12,
    c_ectoplasm      = 3,
    c_trance         = 3,
    c_talisman       = 3,
    c_medium         = 2,
    c_death          = 3,
    c_hermit         = 3,
    c_justice        = 3,
    c_chariot        = 3,
    c_temperance     = 3,
    c_emperor        = 3,
    c_hanged_man     = 3,
    c_devil          = 2,
    c_immolate       = 3,
    c_deja_vu        = 3,
    c_cryptid        = 3
}

local function roll_joker_rarity(total_value)
    if total_value >= 12 then
        return "legendary"
    elseif total_value >= 9 then
        return "rare"
    elseif total_value >= 6 then
        return "uncommon"
    elseif total_value >= 3 then
        return "common"
    end
end

SMODS.Consumable {
    atlas = "tainted_atlas",
    pos = { x = 6, y = 1 },
    unlocked = true,
    discovered = true,
    key = "bagofcrafting",
    set = "taintedcards",

    loc_vars = function(self, info_queue, card)
        local stored = #G.GAME.CraftingBag or 0
        local status_text = stored .. "/3 Collected"
        local colour = G.C.MONEY

        if stored == 3 then
            local total = 0
            local has_SorB = false
            for _, key in ipairs(G.GAME.CraftingBag) do
                if key == "c_soul" or key == "c_black_hole" then
                    has_SorB = true
                end
                total = total + (crafting_consumable_values[key] or 1)
            end
            local rarity = has_special and "legendary" or roll_joker_rarity(total)
            if rarity == "common" then
                colour = G.C.BLUE
                status_text = "Common Joker"
            elseif rarity == "uncommon" then
                colour = G.C.GREEN
                status_text = "Uncommon Joker"
            elseif rarity == "rare" then
                colour = G.C.RED
                status_text = "Rare Joker"
            elseif rarity == "legendary" then
                colour = G.C.PURPLE
                status_text = "Legendary Joker"
            end
        end

        local main_end = {
            {
                n = G.UIT.C,
                config = { align = "bm", padding = 0.02 },
                nodes = {
                    {
                        n = G.UIT.C,
                        config = { align = "m", colour = colour, r = 0.02, padding = 0.1 },
                        nodes = {
                            { n = G.UIT.T, config = { text = status_text, colour = G.C.UI.TEXT_LIGHT, scale = 0.3, shadow = true } }
                        }
                    }
                }
            }
        }

        return { vars = { stored }, main_end = main_end }
    end,

    keep_on_use = function(self) return true end,

    can_use = function(self, card)
        return true
    end,

    use = function(self, card, area, copier)
        if #G.GAME.CraftingBag == 3 then
            card:juice_up()
            local total = 0
            local has_SorB = false
            for _, key in ipairs(G.GAME.CraftingBag) do
                if key == "c_soul" or key == "c_black_hole" then
                    has_SorB = true
                end
                total = total + (crafting_consumable_values[key] or 1)
            end
            local rarity_key = has_special and "legendary" or roll_joker_rarity(total)

            local rarity_mapping = {
                common = "Common",
                uncommon = "Uncommon",
                rare = "Rare",
                legendary = "Legendary"
            }

            local append_rarity = rarity_mapping[rarity_key]

            G.E_MANAGER:add_event(Event({
                trigger = "after",
                func = function()
                    local c = SMODS.create_card {
                        set = "Joker",
                        rarity = append_rarity,
                        key_append = "crafted_by_bag",
                    }
                    c.is_crafted = true
                    G.jokers:emplace(c)
                    c:add_to_deck()
                    return true
                end
            }))

            G.GAME.CraftingBag = {}
            G.GAME.CraftingBagOpen = false
        else
            G.GAME.CraftingBagOpen = not G.GAME.CraftingBagOpen
            card:juice_up(0.8, 0.8)
            G.E_MANAGER:add_event(Event({
                func = function()
                    card_eval_status_text(card, "extra", nil, nil, nil,
                        { message = G.GAME.CraftingBagOpen and "Unsealed.." or "Sealed.." })
                    return true
                end
            }))
        end
    end,

    in_pool = function(self)
        return false
    end,
}

do
    local orig_use = Card.use_consumeable
    function Card:use_consumeable(area, copier)
        local used_key = self.config.center.key

        if G.GAME.CraftingBagOpen and used_key ~= "c_tdec_bagofcrafting" then
            if #G.GAME.CraftingBag < 3 then
                table.insert(G.GAME.CraftingBag, used_key)
            else
                G.GAME.CraftingBag[3] = used_key
            end
            return
        end
        return orig_use(self, area, copier)
    end
end

do
    local orig_can_use = Card.can_use_consumeable
    function Card:can_use_consumeable(area, copier)
        if G.GAME.CraftingBagOpen and self.config.center.key ~= "c_tdec_bagofcrafting" then
            return true
        end
        return orig_can_use(self, area, copier)
    end
end

local start_run_refbag = Game.start_run
function Game:start_run(args)
    start_run_refbag(self, args)
    if not G.GAME.CRAFTINGBAGLOADED then
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.CRAFTINGBAGLOADED = true
                G.GAME.CraftingBag = {}
                G.GAME.CraftingBagOpen = false
                return true
            end
        }))
    end
end
