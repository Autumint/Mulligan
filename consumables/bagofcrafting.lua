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
    c_soul           = 10,
    c_black_hole     = 10,
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
    c_cryptid        = 3,
    c_ouija          = 2,
    c_wraith         = 2,
    c_familiar       = 2,
    c_grim           = 2,
    c_incantation    = 2,
    c_aura           = 2,
    c_sigil          = 2,
    c_ankh           = 2,
    c_hex            = 2,
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

local function has(tbl, val)
    for _, v in ipairs(tbl) do
        if v == val then return true end
    end
    return false
end

local function calc_total(bag)
    local total = 0
    for _, key in ipairs(bag) do
        total = total + (crafting_consumable_values[key] or 1)
    end
    return total
end

local function get_special_recipe(bag)
    local total = calc_total(bag)

    if total >= 3 and total <= 5 then
        if has(bag, "c_stars") and not (has(bag, "c_world") or has(bag, "c_moon") or has(bag, "c_sun")) then
            return "j_greedy_joker"
        elseif has(bag, "c_sun") and not (has(bag, "c_world") or has(bag, "c_moon") or has(bag, "c_stars")) then
            return "j_lusty_joker"
        elseif has(bag, "c_world") and not (has(bag, "c_stars") or has(bag, "c_moon") or has(bag, "c_sun")) then
            return "j_wrathful_joker"
        elseif has(bag, "c_moon") and not (has(bag, "c_world") or has(bag, "c_stars") or has(bag, "c_sun")) then
            return "j_gluttonous_joker"
        elseif has(bag, "c_wraith") and total == 4 then
            return "j_credit_card"
        elseif has(bag, "c_tower") and (has(bag, "c_incantation")) and total == 4 then
            return "j_marble"
        elseif has(bag, "c_emperor") then
            return "j_8_ball"
        elseif has(bag, "c_familiar") and has(bag, "c_heirophant") then
            return "j_scary_face"
        elseif has(bag, "c_grim") then
            return "j_scholar"
        elseif has(bag, "c_hanged_man") or has(bag, "c_immolate") then
            return "j_half"
        end
    end
    if total >= 6 and total <= 9 then
        if has(bag, "c_stars") and not (has(bag, "c_world") or has(bag, "c_moon") or has(bag, "c_sun")) then
            return "j_rough_gem"
        elseif has(bag, "c_sun") and not (has(bag, "c_world") or has(bag, "c_moon") or has(bag, "c_stars")) then
            return "j_bloodstone"
        elseif has(bag, "c_world") and not (has(bag, "c_stars") or has(bag, "c_moon") or has(bag, "c_sun")) then
            return "j_arrowhead"
        elseif has(bag, "c_moon") and not (has(bag, "c_world") or has(bag, "c_stars") or has(bag, "c_sun")) then
            return "j_onyx_agate"
        elseif has(bag, "c_ankh") and has(bag, "c_empress") then
            return "j_ceremonial_dagger"
        elseif has(bag, "c_ankh") then
            return "j_stencil"
        elseif has(bag, "c_chariot") then
            return "j_steel"
        elseif has(bag, "c_familiar") then
            return "j_pareidolia"
        elseif has(bag, "c_death") and has(bag, "c_cryptid") and not has(bag, "c_immolate") or has(bag, "c_hanged_man") then
            return "j_dna"
        elseif #bag > 0 then
            local emperorfool = true
            for _, k in ipairs(bag) do
                if k ~= "c_fool" and k ~= "c_emperor" then
                    emperorfool = false
                    break
                end
            end
            if emperorfool then
                return "j_cartomancer"
            end
        end
    end

    return nil
end

SMODS.Consumable {
    atlas = "tainted_atlas",
    pos = { x = 6, y = 1 },
    unlocked = true,
    discovered = true,
    key = "bagofcrafting",
    set = "taintedcards",

    loc_vars = function(self, info_queue, card)
        local stored = G.GAME.CraftingBag and #G.GAME.CraftingBag or 0
        local status_text = stored .. "/3 Collected"
        local colour = G.C.MONEY

        if stored == 3 then
            local total = 0
            for _, key in ipairs(G.GAME.CraftingBag) do
                total = total + (crafting_consumable_values[key] or 1)
            end
            local special_recipe = get_special_recipe(G.GAME.CraftingBag)

            if special_recipe then
                local recipe = G.P_CENTERS[special_recipe]
                status_text = recipe.name
                colour = G.C.GREEN
            else
                local rarity = has_special and "legendary" or roll_joker_rarity(total)
                if rarity == "common" then
                    colour = G.C.BLUE
                    status_text = "Common"
                elseif rarity == "uncommon" then
                    colour = G.C.GREEN
                    status_text = "Uncommon"
                elseif rarity == "rare" then
                    colour = G.C.RED
                    status_text = "Rare"
                elseif rarity == "legendary" then
                    colour = G.C.PURPLE
                    status_text = "Legendary"
                end
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
            for _, key in ipairs(G.GAME.CraftingBag) do
                total = total + (crafting_consumable_values[key] or 1)
            end
            local special_recipe = get_special_recipe(G.GAME.CraftingBag)
            local rarity_key, append_value_rarity

            if special_recipe then
                rarity_key = nil
                append_value_rarity = nil
            else
                rarity_key = roll_joker_rarity(total)
                local rarity_mapping = {
                    common = "Common",
                    uncommon = "Uncommon",
                    rare = "Rare",
                    legendary = "Legendary"
                }
                append_value_rarity = rarity_mapping[rarity_key]
            end
            G.E_MANAGER:add_event(Event({
                trigger = "after",
                func = function()
                    local c = SMODS.create_card {
                        key = special_recipe or nil,
                        set = "Joker",
                        rarity = append_value_rarity,
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
