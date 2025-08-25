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
    if not ((G.TAINTED_ENABLED and (v.original or not can_be_tainted(v))) or (not v.original and not G.TAINTED_ENABLED)) then
        v = can_be_tainted(v)
    end
    if G.TAINTED_ENABLED and not can_be_tainted(v) then
        v = G.P_CENTERS["b_tdec_tainted_placeholder"]
    end
    if v and not G.TAINTED_ENABLED and v.original then
        v = G.P_CENTERS[v.original]
    end
    return Back(v)
end

local change_back = G.FUNCS.change_viewed_back
G.FUNCS.change_viewed_back = function(args)
    change_back(args)
    G.viewed_deck = args.to_key
    G.PROFILES[G.SETTINGS.profile].MEMORY.viewed_deck = G.viewed_deck
end