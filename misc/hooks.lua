G.FUNCS.stupidfailurebutton = function() end

local old_run_setup = G.UIDEF.run_setup
G.UIDEF.run_setup = function(run_type, saved_game)
    local ui = old_run_setup(run_type, saved_game)

    if ui and ui.nodes then
        local play_row = ui.nodes[#ui.nodes - 1]
        if play_row and play_row.n == G.UIT.R and play_row.nodes then
            table.insert(play_row.nodes, {
                n = G.UIT.C,
                config = {
                    align   = "cm",
                    minw    = 1.0,
                    minh    = 1.0,
                    maxw    = 1.0,
                    maxh    = 1.0,
                    r       = 0.2,
                    emboss  = 0.1,
                    colour  = G.C.PURPLE,
                    button  = "toggle_tainted",
                    func    = "can_toggle_tainted",
                    shadow  = true,
                    no_fill = false,
                },
                nodes = {
                    {
                        n = G.UIT.T,
                        config = {
                            text   = ">",
                            scale  = 0.45,
                            colour = G.C.UI.TEXT_LIGHT,
                        }
                    }
                }
            })
        end
    end

    return ui
end

G.FUNCS.can_toggle_tainted = function(e)
    e.config.colour = G.C.PURPLE
    e.config.button = "toggle_tainted"
end

G.FUNCS.toggle_tainted = function(e)
    G.TAINTED_ENABLED = not G.TAINTED_ENABLED
    G.FORCE_NEW_RUN = true
    G.FUNCS.setup_run({ config = { id = "from_game_over" } })
    G.FORCE_NEW_RUN = nil
end

function can_be_tainted(center)
    for i, v in pairs(SMODS.collection_pool(G.P_CENTER_POOLS.Back)) do
        if v.original == center.key then return v end
    end
end

function get_decks_centers()
    local pool = {}
    for i, v in pairs(SMODS.collection_pool(G.P_CENTER_POOLS.Back)) do
        if not v.original and not v.hidden then
            pool[#pool + 1] = v
        end
    end
    if G.TAINTED_ENABLED then
        for i, v in pairs(pool) do
            pool[i] = can_be_tainted(v) or G.P_CENTERS.b_tdec_tainted_placeholder
        end
    end
    return pool
end

function G.FUNCS.get_decks_tainted()
    local names = {}
    for i, v in pairs(get_decks_centers()) do
        names[#names + 1] = v
    end
    return names
end

G.FUNCS.change_viewed_back = function(args)
    G.viewed_stake = G.viewed_stake or 1
    local deck_pool = get_decks_centers()
    G.GAME.viewed_back:change_to(deck_pool[args.to_key])
    if G.sticker_card then G.sticker_card.sticker = get_deck_win_sticker(G.GAME.viewed_back.effect.center) end
    local max_stake = get_deck_win_stake(G.GAME.viewed_back.effect.center.key) or 0
    G.viewed_stake = math.min(G.viewed_stake, max_stake + 1)
    G.PROFILES[G.SETTINGS.profile].MEMORY.deck = args.to_val
    for key, val in pairs(G.sticker_card.area.cards) do
        val.children.back = false
        val:set_ability(val.config.center, true)
    end
end

function get_viewed_back()
    local v = G.PROFILES[G.SETTINGS.profile].MEMORY.deck
    if type(v) ~= "table" then
        G.PROFILES[G.SETTINGS.profile].MEMORY.deck = get_deck_from_name(G.PROFILES[G.SETTINGS.profile].MEMORY.deck)
        v = G.PROFILES[G.SETTINGS.profile].MEMORY.deck
    end
    if v then
        if not ((G.TAINTED_ENABLED and (v.original or not can_be_tainted(v))) or (not v.original and not G.TAINTED_ENABLED)) then
            v = can_be_tainted(v)
        end
    end
    for i, v2 in pairs(get_decks_centers()) do
        if i == G.viewed_deck then
            v = v2
        end
    end
    if v and (G.TAINTED_ENABLED and not v.original) then
        v = G.P_CENTERS.b_tdec_tainted_placeholder
        G.P_CENTERS.b_tdec_tainted_placeholder.unlocked = false
        G.P_CENTERS.b_tdec_tainted_placeholder.discovered = false
    end
    return Back(v)
end

local change_back = G.FUNCS.change_viewed_back
G.FUNCS.change_viewed_back = function(args)
    change_back(args)
    G.viewed_deck = args.to_key
    G.PROFILES[G.SETTINGS.profile].MEMORY.deck_view = G.viewed_deck
end

local game_start_run_ref = Game.start_run
function Game:start_run(args)
    game_start_run_ref(self, args)
    if G.GAME.selected_back and G.GAME.selected_back.effect.center.key == "b_tdec_tainted_nebula" then
        self.locust_buttons = UIBox {
            definition = {
                n = G.UIT.ROOT,
                config = {
                    align = "cm",
                    minw = 1,
                    minh = 0.3,
                    padding = 0.15,
                    r = 0.1,
                    colour = G.C.CLEAR
                },
                nodes = {
                    {
                        n = G.UIT.C,
                        config = {
                            align = "tm",
                            minw = 2,
                            padding = 0.1,
                            r = 0.1,
                            hover = true,
                            colour = G.C.RED,
                            shadow = true,
                            button = "SwapSets",
                            func = "can_swap_sets"
                        },
                        nodes = {
                            {
                                n = G.UIT.R,
                                config = { align = "bcm", padding = 0 },
                                nodes = {
                                    {
                                        n = G.UIT.T,
                                        config = {
                                            text = "Swap",
                                            scale = 0.35,
                                            colour = G.C.UI.TEXT_LIGHT
                                        }
                                    }
                                }
                            },
                        }
                    }
                }
            },
            config = {
                align = "tr",
                offset = { x = -2.2, y = 0.1 },
                major = G.jokers,
                bond = 'Weak'
            }
        }
    end

    G.FUNCS.SwapSets = function(e)
        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = function()
                if not G.locust_area or not G.jokers then
                    return
                end

                if G.locust_area.states.visible == false then
                    G.jokers.states.visible = false
                    G.locust_area.states.visible = true
                else
                    G.jokers.states.visible = true
                    G.locust_area.states.visible = false
                end

                return true
            end
        }))
    end
end

G.FUNCS.can_swap_sets = function(e)
    if G.STATE ~= G.STATES.ROUND_EVAL then
        e.config.colour = G.C.RED
        e.config.button = "SwapSets"
    else
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    end
end

local allowed_decks = {
    "b_tdec_tainted_yellow",
    "b_tdec_tainted_erratic",
    "b_tdec_tainted_nebula",
    "b_tdec_tainted_checkered",
    "b_tdec_tainted_zodiac"
}

local function is_allowed(key, list)
    for _, v in ipairs(list) do
        if key == v then return true end
    end
    return false
end

local game_start_run_ref = Game.start_run
function Game:start_run(args)
    game_start_run_ref(self, args)

    if G.GAME and G.pactive_area and G.pactive_area.states.visible then
        local back = G.GAME.selected_back
        local key = back and back.effect and back.effect.center and back.effect.center.key
        if key and is_allowed(key, allowed_decks) then
            self.pactive_button = UIBox {
                definition = {
                    n = G.UIT.ROOT,
                    config = {
                        align = "cm",
                        minw = 2,
                        minh = 0.3,
                        padding = 0.15,
                        r = 0.1,
                        colour = G.C.CLEAR
                    },
                    nodes = {
                        {
                            n = G.UIT.C,
                            config = {
                                align = "cm",
                                minw = 2,
                                padding = 0.1,
                                r = 0.1,
                                hover = true,
                                colour = G.C.RED,
                                shadow = true,
                                button = "use_pactive",
                                func = "can_use_pactive"
                            },
                            nodes = {
                                {
                                    n = G.UIT.R,
                                    config = { align = "bcm", padding = 0 },
                                    nodes = {
                                        {
                                            n = G.UIT.T,
                                            config = {
                                                text = "Use",
                                                scale = 0.35,
                                                colour = G.C.UI.TEXT_LIGHT
                                            }
                                        }
                                    }
                                },
                            }
                        }
                    }
                },
                config = {
                    align = "tr",
                    offset = { x = -2.1, y = 3.5 },
                    major = G.pactive_area,
                    bond = 'Weak'
                }
            }
        end
        if G.GAME.selected_back and G.GAME.selected_back.effect.center.key == "b_tdec_tainted_painted" then
            self.chisel_button = UIBox {
                definition = {
                    n = G.UIT.ROOT,
                    config = {
                        align = "cm",
                        minw = 0.6,
                        minh = 1,
                        padding = 0.15,
                        r = 0.1,
                        colour = G.C.CLEAR
                    },
                    nodes = {
                        {
                            n = G.UIT.C,
                            config = {
                                align = "cm",
                                minw = 1.5,
                                minh = 1,
                                maxw = 1.5,
                                padding = 0.1,
                                r = 0.1,
                                hover = true,
                                colour = G.C.RED,
                                shadow = true,
                                button = "use_chisel",
                                func = "can_use_chisel"
                            },
                            nodes = {
                                {
                                    n = G.UIT.R,
                                    config = { align = "bcm", padding = 0 },
                                    nodes = {
                                        {
                                            n = G.UIT.T,
                                            config = {
                                                text = "Use Chisel",
                                                scale = 0.35,
                                                colour = G.C.UI.TEXT_LIGHT
                                            }
                                        }
                                    }
                                },
                            }
                        }
                    }
                },
                config = {
                    align = "tr",
                    offset = { x = 0.05, y = 1.3 },
                    major = G.pactive_area,
                    bond = 'Weak'
                }
            }

            self.sketch_button = UIBox {
                definition = {
                    n = G.UIT.ROOT,
                    config = {
                        align = "cm",
                        minw = 0.6,
                        minh = 1,
                        padding = 0.15,
                        r = 0.1,
                        colour = G.C.CLEAR
                    },
                    nodes = {
                        {
                            n = G.UIT.C,
                            config = {
                                align = "cm",
                                minw = 1.5,
                                minh = 1,
                                maxw = 1.5,
                                padding = 0.1,
                                r = 0.1,
                                hover = true,
                                colour = G.C.RED,
                                shadow = true,
                                button = "use_sketch",
                                func = "can_use_sketch"
                            },
                            nodes = {
                                {
                                    n = G.UIT.R,
                                    config = { align = "bcm", padding = 0 },
                                    nodes = {
                                        {
                                            n = G.UIT.T,
                                            config = {
                                                text = "Use Sketch",
                                                scale = 0.35,
                                                colour = G.C.UI.TEXT_LIGHT
                                            }
                                        }
                                    }
                                },
                            }
                        }
                    }
                },
                config = {
                    align = "tr",
                    offset = { x = 0.05, y = 2.5 },
                    major = G.pactive_area,
                    bond = 'Weak'
                }
            }
        end
    end
end

G.FUNCS.can_use_pactive = function(e)
    local usable = false
    if G.pactive_area and G.pactive_area.cards then
        for _, card in ipairs(G.pactive_area.cards) do
            if card:can_use_consumeable() then
                usable = true
                break
            end
        end
    end

    if usable then
        e.config.colour = G.C.RED
        e.config.button = "use_pactive"
    else
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    end
end

G.FUNCS.use_pactive = function(e)
    if G.STATE == 999 then
        G.GAME.pack_choices = G.GAME.pack_choices + 1
    end
    if G.pactive_area and G.pactive_area.cards then
        for _, card in ipairs(G.pactive_area.cards) do
            if card:can_use_consumeable() then
                G.FUNCS.use_card { config = { ref_table = card } }
                return
            end
        end
    end
end

G.FUNCS.can_use_chisel = function(e)
    local chiselusable = false
    if G.pactive_area and G.pactive_area.cards then
        for _, card in ipairs(G.pactive_area.cards) do
            if card.config.center.key == "c_tdec_thechisel" and card:can_use_consumeable() then
                chiselusable = true
                break
            end
        end
    end


    if chiselusable then
        e.config.colour = G.C.RED
        e.config.button = "use_chisel"
    else
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    end
end

G.FUNCS.use_chisel = function(e)
    if G.pactive_area and G.pactive_area.cards then
        for _, card in ipairs(G.pactive_area.cards) do
            if card.config.center.key == "c_tdec_thechisel" and card:can_use_consumeable() then
                G.FUNCS.use_card { config = { ref_table = card } }
                return
            end
        end
    end
end

G.FUNCS.can_use_sketch = function(e)
    local sketchusable = false
    if G.pactive_area and G.pactive_area.cards then
        for _, card in ipairs(G.pactive_area.cards) do
            if card.config.center.key == "c_tdec_thesketch" and card:can_use_consumeable() then
                sketchusable = true
                break
            end
        end
    end

    if sketchusable then
        e.config.colour = G.C.RED
        e.config.button = "use_sketch"
    else
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    end
end

G.FUNCS.use_sketch = function(e)
    if G.pactive_area and G.pactive_area.cards then
        for _, card in ipairs(G.pactive_area.cards) do
            if card.config.center.key == "c_tdec_thesketch" and card:can_use_consumeable() then
                G.FUNCS.use_card { config = { ref_table = card } }
                return
            end
        end
    end
end

function update_tcheck_backs()
    for i, self in pairs(G.I.CARD) do
        if self.children.back then
            self.children.back:remove()
            self.children.back = Sprite(self.T.x, self.T.y, self.T.w, self.T.h, G.ASSET_ATLAS["tdec_tainted_checkered"],
                G.P_CENTERS['b_tdec_tainted_checkered'].pos)
            self.children.back.states.hover = self.states.hover
            self.children.back.states.click = self.states.click
            self.children.back.states.drag = self.states.drag
            self.children.back.states.collide.can = false
            self.children.back:set_role({ major = self, role_type = 'Glued', draw_major = self })
        end
    end
end

function TDECKS.get_bg_colour()
    if G.GAME.TCFlip and G.GAME.TCFlip.is_active then
        return G.GAME.TCFlip.state == "Dead" and HEX("4f6367") or HEX("8baeca")
    end
    return G.C.BLIND['Small']
end

local t_check_dt = 0
local update_ref = Game.update
function Game:update(dt)
    update_ref(self, dt)
    t_check_dt = t_check_dt + dt
    if G.GAME.TCFlip and G.P_CENTERS and G.P_CENTERS.b_tdec_tainted_checkered and t_check_dt > 0.1 then
        t_check_dt = 0
        local obj = G.P_CENTERS.b_tdec_tainted_checkered
        if G.GAME.TCFlip.state ~= "Alive" then
            obj.pos.x = obj.pos.x + 1
            if obj.pos.x > 6 then
                obj.pos.x = 6
            else
                update_tcheck_backs()
            end
        else
            obj.pos.x = obj.pos.x - 1
            if obj.pos.x < 0 then
                obj.pos.x = 0
            else
                update_tcheck_backs()
            end
        end
        G.P_CENTERS.b_tdec_tainted_checkered = obj
    end
end

local old_get_new_boss = get_new_boss
function get_new_boss(self)
    if G.jokers and G.jokers.cards then
        for _, j in ipairs(G.jokers.cards) do
            if j.config and j.config.center and j.config.center.key == "j_tdec_photoquestion" then
                if G.GAME.round_resets.ante == 0 then
                    return "bl_tdec_famine"
                end
            end
        end
    end
    return old_get_new_boss(self)
end

local old_get_blind_amount = get_blind_amount
function get_blind_amount(ante)
    if G.jokers and G.jokers.cards then
        for _, j in ipairs(G.jokers.cards) do
            if j.config and j.config.center and j.config.center.key == "j_tdec_photoquestion" then
                if ante == 0 then
                    return old_get_blind_amount(8)
                end
            end
        end
    end
    return old_get_blind_amount(ante)
end

local set_textref = Blind.set_text
function Blind:set_text()
    set_textref(self)
    if self.config.blind.hidden then
        self.loc_name = "The Famine"
        self.loc_debuff_lines = {
            "-1 Hand Size",
            "-1 Discard Limit"
        }
        self.loc_debuff_text = "-1 Hand Size, -1 Discard Limit"
    end
end

local update_ref = Game.update
function Game:update(dt)
    update_ref(self, dt)

    if G.GAME.round_resets.ante == 0 and G.jokers and G.jokers.cards then
        for _, j in ipairs(G.jokers.cards) do
            if j.config and j.config.center and j.config.center.key == "j_tdec_photoquestion" then
                if G.GAME.blind.config.blind.key == "bl_tdec_famine" or G.GAME.blind.config.blind.key == "bl_tdec_pestilence" or G.GAME.blind.config.blind.key == "bl_tdec_war" or G.GAME.blind.config.blind.key == "bl_tdec_death" or G.GAME.blind.config.blind.key == "bl_tdec_beast" then
                    local blind_def = G.GAME.blind.config.blind
                    if blind_def.boss_colour then
                        ease_background_colour { new_colour = blind_def.boss_colour, contrast = 1 }
                    end
                end
            end
        end
    end
end

-- thank you bepis i love you

function G.FUNCS.progress_bar_h(e)
    local c = e.children[1]
    local rt = c.config.ref_table
    local target = (rt.ref_table[rt.ref_value] - rt.min) / (rt.max - rt.min) * rt.w

    if target <= 0 then
        c.states.visible = false
    else
        c.states.visible = true
    end

    c.T.w = c.T.w or 0
    c.config.w = c.config.w or 0

    c.T.w = c.T.w + (target - c.T.w) * 0.1
    c.config.w = c.T.w

    if rt.callback then G.FUNCS[rt.callback](rt) end
end

function G.FUNCS.progress_bar_v(e)
    local c = e.children[1]
    local rt = c.config.ref_table
    local target = (rt.ref_table[rt.ref_value] - rt.min) / (rt.max - rt.min) * rt.h

    if target <= 0 then
        c.states.visible = false
    else
        c.states.visible = true
    end

    c.T.h = c.T.h or 0
    c.config.h = c.config.h or 0

    c.T.h = c.T.h + (target - c.T.h) * 0.1
    c.config.h = c.T.h

    if rt.callback then G.FUNCS[rt.callback](rt) end
end

function G.FUNCS.pb_rotate_ui(e)
    e.T.r = math.rad(e.config.degree or 0)
end

function create_progress_bar(args)
    args = args or {}
    args.colour = args.colour or G.C.RED
    args.bg_colour = args.bg_colour or G.C.BLACK
    args.label_scale = args.label_scale or 0.5
    args.label_padding = args.label_padding or 0.1
    args.label_minh = args.label_minh or 1
    args.label_minw = args.label_minw or 1
    args.label_vert = args.label_vert or nil
    args.label_position = args.label_position or "Top" --Can be "Left", "Right", "Top", "Bottom"
    args.min = args.min or 0
    args.max = args.max or 1
    args.tooltip = args.tooltip or nil

    args.reverse_fill = args.reverse_fill or false

    args.bar_rotation = args.bar_rotation or "Horizontal" --Can be "Horizontal", "Vertical"
    args.w = args.w or ((args.bar_rotation == "Horizontal" and 1) or (args.bar_rotation == "Vertical" and 0.5))
    args.h = args.h or ((args.bar_rotation == "Horizontal" and 0.5) or (args.bar_rotation == "Vertical" and 1))
    args.label_degree = args.label_degree or 0

    args.detailed_tooltip = args.detailed_tooltip or nil
    if not args.detailed_tooltip and args.detailed_tooltip_k then
        args.detailed_tooltip = { key = args.detailed_tooltip_k, set = args.detailed_tooltip_s or nil }
    end

    local t = nil
    if args.bar_rotation == "Horizontal" then
        local startval = args.w * (args.ref_table[args.ref_value] - args.min) / (args.max - args.min)
        t =
        {
            n = G.UIT.C,
            config = { align = "cm", minw = args.w, minh = args.h, padding = 0.1, r = 0.1, colour = G.C.CLEAR, focus_args = { type = 'slider' } },
            nodes = {
                {
                    n = G.UIT.C,
                    config = { align = (args.reverse_fill and "cr") or "cl", detailed_tooltip = args.detailed_tooltip, tooltip = args.tooltip, minw = args.w, r = 0.1, minh = args.h, colour = args.bg_colour, emboss = 0.05, func = 'progress_bar_h', refresh_movement = true },
                    nodes = {
                        { n = G.UIT.B, config = { w = startval, h = args.h, r = 0.1, colour = args.colour, ref_table = args, refresh_movement = true } },
                    }
                },
            }
        }
    elseif args.bar_rotation == "Vertical" then
        local startval = args.h * (args.ref_table[args.ref_value] - args.min) / (args.max - args.min)
        t =
        {
            n = G.UIT.C,
            config = { align = "cm", minw = args.w, minh = args.h, padding = 0.1, r = 0.1, colour = G.C.CLEAR, focus_args = { type = 'slider' } },
            nodes = {
                {
                    n = G.UIT.C,
                    config = { align = (args.reverse_fill and "tm") or "bm", detailed_tooltip = args.detailed_tooltip, tooltip = args.tooltip, minw = args.w, r = 0.1, minh = args.h, colour = args.bg_colour, emboss = 0.05, func = 'progress_bar_v', refresh_movement = true },
                    nodes = {
                        { n = G.UIT.B, config = { w = args.w, h = startval, r = 0.1, colour = args.colour, ref_table = args, refresh_movement = true } },
                    }
                },
            }
        }
    end

    if args.label then
        if args.label_position == "Top" then
            local label_node = {
                n = G.UIT.R,
                config = { align = "cm", padding = 0 },
                nodes = {
                    { n = G.UIT.T, config = { func = 'pb_rotate_ui', degree = args.label_degree, text = args.label, scale = args.label_scale, colour = G.C.UI.TEXT_LIGHT, vert = args.label_vert } }
                }
            }

            t =
            {
                n = G.UIT.R,
                config = { align = "cm", minh = args.label_minh, minw = args.label_minw, padding = args.label_padding * args.label_scale, colour = G.C.CLEAR },
                nodes = {
                    label_node,
                    {
                        n = G.UIT.R,
                        config = { align = "cm", padding = 0 },
                        nodes = {
                            t
                        }
                    }
                }
            }
        elseif args.label_position == "Bottom" then
            local label_node = {
                n = G.UIT.R,
                config = { align = "cm", padding = 0 },
                nodes = {
                    { n = G.UIT.T, config = { func = 'pb_rotate_ui', degree = args.label_degree, text = args.label, scale = args.label_scale, colour = G.C.UI.TEXT_LIGHT, vert = args.label_vert } }
                }
            }

            t =
            {
                n = G.UIT.R,
                config = { align = "cm", minh = args.label_minh, minw = args.label_minw, padding = args.label_padding * args.label_scale, colour = G.C.CLEAR },
                nodes = {
                    {
                        n = G.UIT.R,
                        config = { align = "cm", padding = 0 },
                        nodes = {
                            t
                        }
                    },
                    label_node,
                }
            }
        elseif args.label_position == "Left" then
            local label_node = {
                n = G.UIT.C,
                config = { align = "cm", padding = 0 },
                nodes = {
                    { n = G.UIT.T, config = { func = 'pb_rotate_ui', degree = args.label_degree, text = args.label, scale = args.label_scale, colour = G.C.UI.TEXT_LIGHT, vert = args.label_vert } }
                }
            }

            t =
            {
                n = G.UIT.C,
                config = { align = "cm", minh = args.label_minh, minw = args.label_minw, padding = args.label_padding * args.label_scale, colour = G.C.CLEAR },
                nodes = {
                    label_node,
                    {
                        n = G.UIT.C,
                        config = { align = "cm", padding = 0 },
                        nodes = {
                            t
                        }
                    },
                }
            }
        elseif args.label_position == "Right" then
            local label_node = {
                n = G.UIT.C,
                config = { align = "cm", padding = 0 },
                nodes = {
                    { n = G.UIT.T, config = { func = 'pb_rotate_ui', degree = args.label_degree, text = args.label, scale = args.label_scale, colour = G.C.UI.TEXT_LIGHT, vert = args.label_vert } }
                }
            }

            t =
            {
                n = G.UIT.C,
                config = { align = "cm", minh = args.label_minh, minw = args.label_minw, padding = args.label_padding * args.label_scale, colour = G.C.CLEAR },
                nodes = {
                    {
                        n = G.UIT.C,
                        config = { align = "cm", padding = 0 },
                        nodes = {
                            t
                        }
                    },
                    label_node,
                }
            }
        end
    end

    return t
end

local start_run_ref = Game.start_run
function Game:start_run(...)
    local ret = start_run_ref(self, ...)
    if self.HP_ui then
        self.HP_ui:remove()
        self.HP_ui = nil
    end
    if G.GAME.blind and G.GAME.blind.config.blind.key == "bl_tdec_beast" and G.GAME.BeastProgress then
        spawn_beast_hp_ui()
        return ret
    end
end

-- blind hud removal by win'ter

local function set_blind_score_visible(bool)
    local hud_def = create_UIBox_HUD()
    local blind_def = create_UIBox_HUD_blind()

    -- reset hud
    if G.HUD then
        G.HUD:remove(); G.HUD = nil
    end
    if G.HUD_blind then
        -- manually nil out the blind object so this remove call doesn't destroy it unnecessarily
        G.HUD_blind.UIRoot.children[2].children[2].children[1].config.object = nil
        G.HUD_blind:remove();
        G.HUD_blind = nil
    end

    if not bool then
        local blind_node = blind_def.nodes[2].nodes[2]
        blind_node.nodes = {
            { n = G.UIT.C, config = { align = "cm", minw = 1.4, id = 'HUD_blind_count' }, nodes = {} },
            blind_def.nodes[2].nodes[2].nodes[1],
            -- below are dummy equivalents to prevent having to invasively change some code in blind.lua
            {
                n = G.UIT.C,
                config = { align = "cm", minw = 1.4, id = 'HUD_blind_reward' },
                nodes = {
                    { n = G.UIT.O, config = { object = DynaText({ string = { "" }, colours = { G.C.CLEAR }, silent = true, scale = 0 }), id = 'dollars_to_be_earned' } },
                }
            },
        }
        hud_def.nodes[1].nodes[1].nodes[3] = {
            n = G.UIT.R,
            config = { align = "cm", r = 0.1, id = 'row_dollars_chips' },
            nodes = { {
                n = G.UIT.C,
                config = { align = "cm", minw = 3.3, minh = 0.95 },
                nodes = {
                    { n = G.UIT.R, config = { align = "cm", id = 'chip_UI_count' } }
                }
            }
            }
        }
    end

    G.HUD = UIBox {
        definition = hud_def,
        config = { align = ('cli'), offset = { x = -0.7, y = 0 }, major = G.ROOM_ATTACH }
    }

    G.HUD_blind = UIBox {
        definition = blind_def,
        config = { major = G.HUD:get_UIE_by_ID('row_blind_bottom'), align = 'bmi', offset = { x = 0, y = 0 }, bond = 'Weak' }
    }

    G.hand_text_area = {
        chips = G.HUD:get_UIE_by_ID('hand_chips'),
        mult = G.HUD:get_UIE_by_ID('hand_mult'),
        ante = G.HUD:get_UIE_by_ID('ante_UI_count'),
        round = G.HUD:get_UIE_by_ID('round_UI_count'),
        chip_total = G.HUD:get_UIE_by_ID('hand_chip_total'),
        handname = G.HUD:get_UIE_by_ID('hand_name'),
        hand_level = G.HUD:get_UIE_by_ID('hand_level'),
        game_chips = G.HUD:get_UIE_by_ID('chip_UI_count'),
        blind_chips = G.HUD_blind:get_UIE_by_ID('HUD_blind_count'),
        blind_spacer = G.HUD:get_UIE_by_ID('blind_spacer')
    }
end

local ref_blind_debuff = G.FUNCS.HUD_blind_debuff
G.FUNCS.HUD_blind_debuff = function(e)
    if e.UIBox == G.HUD_blind then return ref_blind_debuff(e) end
end

local ref_blind_set = Blind.set_blind
function Blind:set_blind(...)
    local args = { ... }
    local blind, reset = args[1], args[2]

    if blind and blind.score_invisible then
        G.GAME.modifiers.hide_blind_score = true
        set_blind_score_visible(false)
    end

    G.GAME.modifiers.hide_blind_score = nil
    local ret = ref_blind_set(self, ...)

    return ret
end

local ref_blind_defeat = Blind.defeat
function Blind:defeat(...)
    local ret = ref_blind_defeat(self, ...)

    if self.config.blind.score_invisible and G.GAME.modifiers.hide_blind_score then
        G.GAME.modifiers.hide_blind_score = nil
        set_blind_score_visible(true)
    end

    return ret
end

local ref_blind_disable = Blind.disable
function Blind:disable(...)
    local ret = ref_blind_disable(self, ...)

    if self.config.blind.score_invisible and G.GAME.modifiers.hide_blind_score then
        G.GAME.modifiers.hide_blind_score = nil
        set_blind_score_visible(true)
    end


    return ret
end

local ref_blind_load = Blind.load
function Blind:load(blindTable)
    local ret = ref_blind_load(self, blindTable)

    if self.config.blind.score_invisible then
        set_blind_score_visible(false)
    end

    return ret
end

local ref_blind_choice = create_UIBox_blind_choice
function create_UIBox_blind_choice(...)
    local ret = ref_blind_choice(...)

    local args = { ... }
    local type = args[1]
    if G.P_BLINDS[G.GAME.round_resets.blind_choices[type]].score_invisible then
        local info_node = ret.nodes[1].nodes[3].nodes[1].nodes[2]
        info_node.config.colour = G.C.CLEAR
        info_node.nodes = {}
    end

    return ret
end

local ref_eval_row = add_round_eval_row
function add_round_eval_row(config)
    if G.GAME.blind.config.blind.key == "bl_tdec_beast" then
        config = config or {}
        local width = G.round_eval.T.w - 0.51
        local scale = 0.9

        if config.name ~= 'bottom' and config.name == 'blind1' then
            delay(0.4)
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                delay = 0.5,
                func = function()
                    --Add the far left text and context first:
                    local left_text = {}
                    if config.name == 'blind1' then
                        local stake_sprite = get_stake_sprite(G.GAME.stake or 1, 0.5)
                        local obj = G.GAME.blind.config.blind
                        local blind_sprite = AnimatedSprite(0, 0, 1.2, 1.2,
                            G.ANIMATION_ATLAS[obj.atlas] or G.ANIMATION_ATLAS['blind_chips'],
                            copy_table(G.GAME.blind.pos))
                        blind_sprite:define_draw_steps({
                            { shader = 'dissolve', shadow_height = 0.05 },
                            { shader = 'dissolve' }
                        })
                        table.insert(left_text,
                            { n = G.UIT.O, config = { w = 1.2, h = 1.2, object = blind_sprite, hover = true, can_collide = false } })
                        table.insert(left_text,
                            {
                                n = G.UIT.C,
                                config = { padding = 0.05, align = 'cm' },
                                nodes = {
                                    {
                                        n = G.UIT.R,
                                        config = { align = 'cm', minh = 0.8 },
                                        nodes = {
                                            { n = G.UIT.O, config = { w = 0.5, h = 0.5, object = stake_sprite, hover = true, can_collide = false } },
                                            { n = G.UIT.T, config = { text = "DEFEAT BOSS", scale = 0.8, colour = G.C.RED, shadow = true } }
                                        }
                                    }
                                }
                            })
                    end

                    local full_row = {
                        n = G.UIT.R,
                        config = { align = "cm", minw = 5 },
                        nodes = {
                            { n = G.UIT.C, config = { padding = 0.05, minw = width * 0.55, minh = 0.61, align = "cl" }, nodes = left_text },
                            { n = G.UIT.C, config = { padding = 0.05, minw = width * 0.45, align = "cr" },              nodes = {} }
                        }
                    }

                    G.GAME.blind:juice_up()
                    G.round_eval:add_child(full_row, G.round_eval:get_UIE_by_ID('base_round_eval'))
                    play_sound('cancel', config.pitch or 1)
                    play_sound('highlight1', (1.5 * config.pitch) or 1, 0.2)
                    if config.card then config.card:juice_up(0.7, 0.46) end
                    return true
                end
            }))
        end
    end
    return ref_eval_row(config)
end

function has_sticker(tbl, sticker)
    for _, s in ipairs(tbl) do
        if s == sticker then return true end
    end
    return false
end

local old_add_to_deck = Card.add_to_deck
function Card:add_to_deck(from_debuff)
    old_add_to_deck(self, from_debuff)
    if G.GAME.selected_back.effect.center.key == "b_tdec_tainted_zodiac" then
        if self.ability.set == "Joker" and not self.is_crafted then
            local chance_spawn = 2
            local rarity = self.config.center.rarity
            local bagstickers = G.GAME.StoredStickers or {}
            G.GAME.StoredStickers = bagstickers

            if self.ability.eternal and not has_sticker(bagstickers, "eternal") then
                table.insert(bagstickers, "eternal")
            end
            if self.ability.rental and not has_sticker(bagstickers, "rental") then
                table.insert(bagstickers, "rental")
            end
            if self.ability.perishable and not has_sticker(bagstickers, "perishable") then
                table.insert(bagstickers, "perishable")
            end
            self:start_dissolve()
            if SMODS.pseudorandom_probability(card, 'destiny_drop', 1, 2) then
                chance_spawn = 3
            end
            if rarity == 3 then
                chance_spawn = 3
            end
            if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                local spawn_count = math.min(chance_spawn,
                    G.consumeables.config.card_limit - (#G.consumeables.cards + G.GAME.consumeable_buffer))
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + spawn_count
                local chosen_type = { 'Tarot', 'Spectral', 'Planet' }
                if rarity == 1 then
                    chosen_type = { 'Tarot', 'Planet' }
                end
                if rarity == 2 then
                    if SMODS.pseudorandom_probability(card, 'destiny_spectral', 1, 2) then
                        chosen_type = { 'Tarot', 'Planet', 'Spectral' }
                    else
                        chosen_type = { 'Tarot', 'Planet' }
                    end
                end
                G.E_MANAGER:add_event(Event({
                    func = function()
                        if rarity == 3 and spawn_count > 0 then
                            SMODS.add_card {
                                set = 'Spectral',
                                key_append = 'createdbydestiny'
                            }
                            spawn_count = spawn_count - 1
                        end
                        for i = 1, spawn_count do
                            local chosen_consumable = pseudorandom_element(chosen_type, 'tdec_tzodiac')
                            SMODS.add_card {
                                set = chosen_consumable,
                                key_append = 'createdbydestiny'
                            }
                        end
                        G.GAME.consumeable_buffer = 0
                        return true
                    end
                }))
            end
        end
    end
end

local old_check_for_buy_space = G.FUNCS.check_for_buy_space
function G.FUNCS.check_for_buy_space(card)
    if
        G.GAME.selected_back and G.GAME.selected_back.effect.center.key == "b_tdec_tainted_zodiac"
    then
        return true
    end
    return old_check_for_buy_space(card)
end

local orig_can_use = Card.can_use_consumeable
function Card:can_use_consumeable(area, copier)
    if G.GAME.selected_back and G.GAME.selected_back.effect.center.key == "b_tdec_tainted_zodiac" and self.config.center.key == "c_judgement" then
        return true
    end
    return orig_can_use(self, area, copier)
end

local orig_booster_select = G.FUNCS.can_select_card
function G.FUNCS.can_select_card(e)
    if G.GAME.selected_back and G.GAME.selected_back.effect.center.key == "b_tdec_tainted_zodiac" then
        e.config.colour = G.C.GREEN
        e.config.button = 'use_card'
        return true
    end
    return orig_booster_select(e)
end




