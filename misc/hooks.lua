G.FUNCS.stupidfailurebutton = function() end

local old_run_setup = G.UIDEF.run_setup
G.UIDEF.run_setup = function(run_type, saved_game)
  local ui = old_run_setup(run_type, saved_game)

  if ui and ui.nodes then
    local play_row = ui.nodes[#ui.nodes-1]
    if play_row and play_row.n == G.UIT.R and play_row.nodes then
      table.insert(play_row.nodes, {
        n = G.UIT.C,
        config = {
          align     = "cm",
          minw      = 1.0,  
          minh      = 1.0,  
          maxw      = 1.0,  
          maxh      = 1.0,  
          r         = 0.2,
          emboss    = 0.1,
          colour    = G.C.PURPLE,
          button    = "toggle_tainted",
          func = "can_toggle_tainted",
          shadow    = true,
          no_fill   = false,  
        },
        nodes = {
          { n = G.UIT.T, config = {
              text   = ">",
              scale  = 0.45,
              colour = G.C.UI.TEXT_LIGHT,
          }}
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
    G.FUNCS.setup_run({config = {id = "from_game_over"}})
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
            pool[#pool+1] = v
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
        names[#names+1] = v
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
                offset = { x = -7.3, y = 3.4 },
                major = G.ROOM_ATTACH,
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
    "b_tdec_tainted_nebula"
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
                        minw = 0.6,
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
                                minw = 1.2,
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

    if G.consumeables and usable then
        e.config.colour = G.C.RED
        e.config.button = "use_pactive"   
    else
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil            
    end
end

G.FUNCS.use_pactive = function(e)
    if G.pactive_area and G.pactive_area.cards then
        for _, card in ipairs(G.pactive_area.cards) do
            if card:can_use_consumeable() then
                G.FUNCS.use_card{ config = { ref_table = card } }
                return
            end
        end
    end
end