TDECKS = SMODS.current_mod

SMODS.Back({
    key = "tainted_placeholder",
    atlas = "tainted_atlas",
    pos = {x = 999, y = 999},
    unlocked = false,
    discovered = false,
    check_for_unlock = function() end,
    hidden = true
})


local files = {
    "misc/atlases",
    "misc/sounds",
    "misc/hooks",

    "decks/t_checkered",
    "decks/t_yellow",
    "decks/t_erratic",
    "decks/t_green",
    "decks/t_painted",
    "decks/t_zodiac",
    "decks/t_red",
    "decks/t_ghost",
    "decks/t_anaglyph",

    "consumables/consumabletype",
    "consumables/debugcard",
    "consumables/holycard",
    "consumables/flip",
    "consumables/sketchandchisel",

    "jokers/sumptorium",
    "jokers/purgatory",
    "jokers/eyeofgreed"
}
for i, v in pairs(files) do
    SMODS.load_file(v..".lua")()  
end