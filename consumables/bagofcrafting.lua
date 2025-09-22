local crafting_consumable_values = {
    c_fool             = 4,
    c_magician         = 3,
    c_high_priestess   = 2,
    c_mercury          = 2,
    c_saturn           = 2,
    c_neptune          = 2,
    c_pluto            = 2,
    c_ceres            = 3,
    c_eris             = 3,
    c_planet_x         = 3,
    c_soul             = 10,
    c_black_hole       = 10,
    c_ectoplasm        = 4,
    c_trance           = 5,
    c_talisman         = 5,
    c_medium           = 4,
    c_death            = 4,
    c_hermit           = 4,
    c_justice          = 3,
    c_chariot          = 3,
    c_temperance       = 4,
    c_emperor          = 3,
    c_hanged_man       = 4,
    c_devil            = 3,
    c_immolate         = 5,
    c_deja_vu          = 5,
    c_cryptid          = 5,
    c_ouija            = 5,
    c_wraith           = 3,
    c_familiar         = 3,
    c_grim             = 3,
    c_incantation      = 3,
    c_aura             = 3,
    c_sigil            = 3,
    c_ankh             = 3,
    c_hex              = 3,
    c_strength         = 3,
    c_lovers           = 2,
    c_wheel_of_fortune = 2,
    c_judgement        = 3,
}

local function check_joker_rarity(total_value)
    if total_value >= 16 then
        return "legendary"
    elseif total_value >= 9 then
        return "rare"
    elseif total_value >= 6 then
        return "uncommon"
    elseif total_value >= 3 then
        return "common"
    end
end

local function calc_total(bag)
    local total = 0
    for _, key in ipairs(bag) do
        total = total + (crafting_consumable_values[key] or 1)
    end
    return total
end

local function has(tbl, value)
    for _, v in ipairs(tbl) do
        if v == value then
            return true
        end
    end
    return false
end

local special_recipes = {
    {
        range = { 0, 5 },
        key = "j_greedy_joker",
        requires = { "c_stars" },
        excludes = { "c_world", "c_moon", "c_sun" },
    },
    {
        range = { 0, 5 },
        key = "j_lusty_joker",
        requires = { "c_sun" },
        excludes = { "c_world", "c_moon", "c_star" },
    },
    {
        range = { 0, 5 },
        key = "j_wrathful_joker",
        requires = { "c_world" },
        excludes = { "c_star", "c_moon", "c_sun" },
    },
    {
        range = { 0, 5 },
        key = "j_gluttenous_joker",
        requires = { "c_moon" },
        excludes = { "c_world", "c_star", "c_sun" },
    },
    {
        range = { 0, 5 },
        key = "j_credit_card",
        requires = { "c_wraith" },
    },
    {
        range = { 0, 5 },
        key = "j_marble",
        requires = { "c_tower", "c_incantation" },
    },
    {
        range = { 0, 5 },
        key = "j_8_ball",
        requires = { "c_emperor", "c_wheel_of_fortune" },
    },
    {
        range = { 0, 5 },
        key = "j_scary_face",
        requires = { "c_familiar", "c_heirophant" },
    },
    {
        range = { 0, 5 },
        key = "j_scholar",
        requires = { "c_grim", "c_heirophant", "c_empress" },
    },
    {
        range = { 4, 6 },
        key = "j_rough_gem",
        requires = { "c_star", "c_hermit" },
        excludes = { "c_world", "c_moon", "c_sun" },
        priority = 1
    },
    {
        range = { 4, 7 },
        key = "j_bloodstone",
        requires = { "c_sun", "c_chariot", "c_hex" },
        excludes = { "c_world", "c_moon", "c_star" },
        priority = 1
    },
    {
        range = { 4, 8 },
        key = "j_arrowhead",
        requires = { "c_world", "c_heirophant" },
        excludes = { "c_star", "c_moon", "c_sun" },
        priority = 1
    },
    {
        range = { 4, 8 },
        key = "j_onyx_agate",
        requires = { "c_moon", "c_empress" },
        excludes = { "c_world", "c_star", "c_sun" },
        priority = 1
    },
    {
        range = { 4, 8 },
        key = "j_ceremonial",
        requires = { "c_ankh", "c_empress" },
    },
    {
        range = { 4, 8 },
        key = "j_stencil",
        requires = { "c_ankh", "c_hex" },
        excludes = { "c_judgement" },
        priority = 1
    },
    {
        range = { 4, 8 },
        key = "j_steel_joker",
        requires = { "c_chariot", "c_hex" },
        excludes = { "c_justice" }
    },
    {
        range = { 4, 8 },
        key = "j_glass",
        requires = { "c_justice", "c_hex" },
        excludes = { "c_chariot" }
    },
    {
        range = { 4, 7 },
        key = "j_pareidolia",
        requires = { "c_familiar", "c_hex" },
        excludes = { "c_incantation" },
    },
    {
        range = { 0, 10 },
        key = "j_dna",
        requires = { "c_death", "c_cryptid" },
        excludes = { "c_immolate" },
        priority = 2
    },
    {
        range = { 4, 9 },
        key = "j_sock_and_buskin",
        requires = { "c_familiar", "c_deja_vu" },
        excludes = { "c_incantation" },
        priority = 2
    },
    {
        range = { 4, 10 },
        key = "j_satellite",
        requires = { "c_trance", "c_hermit" },
        excludes = { "c_high_priestess" },
        requires_any = { "c_pluto", "c_mercury", "c_uranus", "c_venus", "c_saturn", "c_earth", "c_mars", "c_neptune", "c_planet_x", "c_ceres", "c_eris" },
        priority = 1
    },
    {
        range = { 4, 8 },
        key = "j_space",
        requires = { "c_trance", "c_wheel_of_fortune" },
        excludes = { "c_hermit", "c_high_priestess" },
        requires_any = { "c_pluto", "c_mercury", "c_uranus", "c_venus", "c_saturn", "c_earth", "c_mars", "c_neptune", "c_planet_x", "c_ceres", "c_eris" },
        priority = 1
    },
    {
        range = { 4, 8 },
        key = "j_constellation",
        requires = { "c_trance", "c_high_priestess" },
        excludes = { "c_hermit", "c_wheel_of_fortune" },
        requires_any = { "c_pluto", "c_mercury", "c_uranus", "c_venus", "c_saturn", "c_earth", "c_mars", "c_neptune", "c_planet_x", "c_ceres", "c_eris" },
        priority = 1
    },
    {
        range = { 4, 8 },
        key = "j_seeing_double",
        requires = { "c_moon", "c_cryptid" },
        requires_any = { "c_sun", "c_world", "c_stars" },
        priority = 1
    },
    {
        range = { 4, 8 },
        key = "j_egg",
        requires = { "c_temperance", "c_devil" },
        priority = 1
    },
    {
        range = { 0, 100 },
        key = "j_perkeo",
        requires = { "c_soul", "c_fool", "c_cryptid" },
        priority = 10,
        exact_total = 19
    },
    {
        range = { 0, 100 },
        key = "j_triboulet",
        requires = { "c_soul", "c_familiar", "c_hex" },
        priority = 10,
        exact_total = 16
    },
    {
        range = { 0, 100 },
        key = "j_caino",
        requires = { "c_soul", "c_familiar", "c_immolate" },
        priority = 10,
        exact_total = 18
    },
    {
        range = { 0, 100 },
        key = "j_yorick",
        requires = { "c_soul", "c_immolate", "c_hanged_man" },
        priority = 10,
        exact_total = 19
    },
    {
        range = { 0, 100 },
        key = "j_chicot",
        requires = { "c_soul", "c_ectoplasm", "c_hanged_man" },
        priority = 10,
        exact_total = 18
    },
    {
        range = { 6, 9 },
        key = "j_cartomancer",
        priority = 2,
        special = function(bag)
            for _, k in ipairs(bag) do
                if k ~= "c_fool" and k ~= "c_emperor" then
                    return false
                end
            end
            return true
        end
    },
}

local function matches_recipe(bag, total, recipe)
    if recipe.range and (total < recipe.range[1] or total > recipe.range[2]) then
        return false
    end
    if recipe.exact_total and total ~= recipe.exact_total then
        return false
    end
    if recipe.requires then
        for _, req in ipairs(recipe.requires) do
            if not has(bag, req) then return false end
        end
    end
    if recipe.requires_any then
        local reqany = false
        for _, req in ipairs(recipe.requires_any) do
            if has(bag, req) then
                reqany = true
                break
            end
        end
        if not reqany then return false end
    end
    if recipe.excludes then
        for _, exc in ipairs(recipe.excludes) do
            if has(bag, exc) then return false end
        end
    end
    if recipe.special and not recipe.special(bag) then
        return false
    end
    return true
end

local function get_special_recipe(bag)
    local total = calc_total(bag)
    local scale_recipe = nil
    local scale_priority = -1

    for _, recipe in ipairs(special_recipes) do
        if matches_recipe(bag, total, recipe) then
            local p = recipe.priority or 0
            if p > scale_priority then
                scale_recipe = recipe
                scale_priority = p
            end
        end
    end

    return scale_recipe and scale_recipe.key or nil
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
        local total = 0

        if G.GAME.CraftingBag and #G.GAME.CraftingBag > 0 then
            for _, key in ipairs(G.GAME.CraftingBag) do
                local heldcons = G.P_CENTERS[key]
                if heldcons then
                    info_queue[#info_queue + 1] = heldcons
                end
                total = total + (crafting_consumable_values[key] or 1)
            end
        end

        local colour2 = G.C.GREY
        if total >= 16 then
            colour2 = G.C.PURPLE
        elseif total >= 9 then
            colour2 = G.C.RED
        elseif total >= 6 then
            colour2 = G.C.GREEN
        elseif total >= 3 then
            colour2 = G.C.BLUE
        end

        if stored == 3 then
            local special_recipe = get_special_recipe(G.GAME.CraftingBag)
            if special_recipe then
                local recipe = G.P_CENTERS[special_recipe]
                status_text = recipe.name
                colour = G.C.GREEN
            else
                local rarity = check_joker_rarity(total)
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
                    },
                    {
                        n = G.UIT.C,
                        config = { align = "m", colour = colour2, r = 0.02, padding = 0.1 },
                        nodes = {
                            { n = G.UIT.T, config = { text = (total == 0 and "No Value") or ("Value: " .. total), colour = G.C.UI.TEXT_LIGHT, scale = 0.3, shadow = true } }
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
                rarity_key = check_joker_rarity(total)
                local rarity_mapping = {
                    common = "Common",
                    uncommon = "Uncommon",
                    rare = "Rare",
                    legendary = "Legendary"
                }
                append_value_rarity = rarity_mapping[rarity_key]
            end

            if #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit then
                G.GAME.joker_buffer = G.GAME.joker_buffer + 1
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

                        for _, stk in ipairs(G.GAME.StoredStickers) do
                            if stk == "perishable" and has_sticker(G.GAME.StoredStickers, "eternal") then

                            elseif stk == "eternal" and not c.config.center.eternal_compat then

                            elseif stk == "perishable" and not c.config.center.perishable_compat then

                            else
                                c:add_sticker(stk, true)
                            end
                        end

                        G.GAME.joker_buffer = G.GAME.joker_buffer - 1
                        G.GAME.StoredStickers = {}
                        return true
                    end
                }))
            else

            end

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


local orig_use = Card.use_consumeable
function Card:use_consumeable(area, copier)
    local used_key = self.config.center.key

    if G.GAME.CraftingBagOpen and used_key ~= "c_tdec_bagofcrafting" then
        if #G.GAME.CraftingBag < 3 then
            table.insert(G.GAME.CraftingBag, used_key)
        else
            table.remove(G.GAME.CraftingBag, 1)
            table.insert(G.GAME.CraftingBag, used_key)
        end
        return
    end
    return orig_use(self, area, copier)
end

local orig_can_use = Card.can_use_consumeable
function Card:can_use_consumeable(area, copier)
    if G.GAME.CraftingBagOpen and self.config.center.key ~= "c_tdec_bagofcrafting" then
        return true
    end
    return orig_can_use(self, area, copier)
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
                G.GAME.StoredStickers = {}
                return true
            end
        }))
    end
end
