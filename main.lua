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
    "misc/pactives",

    "decks/t_checkered",
    "decks/t_erratic",
    "decks/t_yellow",
    "decks/t_green",
    "decks/t_painted",
    "decks/t_zodiac",
    "decks/t_red",
    "decks/t_ghost",
    "decks/t_anaglyph",
    "decks/t_nebula",

    "consumables/consumabletype",
    "consumables/debugcard",
    "consumables/holycard",
    "consumables/flip",
    "consumables/sketchandchisel",
    "consumables/turnover",
    "consumables/abyss",

    "jokers/sumptorium",
    "jokers/purgatory",
    "jokers/eyeofgreed",
    "jokers/locusts/hierophant_locust",
    "jokers/locusts/chariot_locust",
    "jokers/locusts/death_locust",
    "jokers/locusts/devil_locust",
    "jokers/locusts/emperor_locust",
    "jokers/locusts/fool_locust",
    "jokers/locusts/hanged_locust",
    "jokers/locusts/hermit_locust",
    "jokers/locusts/judgement_locust",
    "jokers/locusts/justice_locust",
    "jokers/locusts/lovers_locust",
    "jokers/locusts/magician_locust",
    "jokers/locusts/moon_locust",
    "jokers/locusts/priestess_locust",
    "jokers/locusts/soul_locust",
    "jokers/locusts/star_locust",
    "jokers/locusts/strength_locust",
    "jokers/locusts/sun_locust",
    "jokers/locusts/temperance_locust",
    "jokers/locusts/tower_locust",
    "jokers/locusts/wheel_locust",
    "jokers/locusts/world_locust",
}
for i, v in pairs(files) do
    SMODS.load_file(v..".lua")()  
end