SMODS.Back({
    key = "tainted_placeholder",
    loc_txt = {
        name = "Coming Soon",
        text = {
            "...?"
        },
        unlock = {
            "Coming Soon..."
        }
    },
    atlas = "erratic_atlas",
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
    "decks/t_erratic",
    "decks/t_green",
    "decks/t_painted",
    "decks/t_zodiac",
}
for i, v in pairs(files) do
    SMODS.load_file(v..".lua")()  
end