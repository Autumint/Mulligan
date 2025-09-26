return {
    descriptions = {
        Mod = {
            Mulligan = {
                name = "Tainted Decks",
                text = {
                    "- Adds tainted decks, inspired by TBOI, implemented by",
                    "{C:attention}Autumint{} and {C:attention}lord.ruby{}.",
                    "- Featuring sprites by {C:attention}lord.ruby{}, {C:attention}MrCr33ps{} and {C:attention}danihunn{}",
                    "- Extra credits go to {C:attention}MaxBoi{}"
                }
            }
        },
        Blind = {
            bl_tdec_famine = {
                name = "???",
                text = {
                    "???"
                }
            },
            bl_tdec_pestilence = {
                name = "Pestilence",
                text = {
                    "Debuff cards depending on",
                    "deck size per hand played"
                }
            },
            bl_tdec_war = {
                name = "War",
                text = {
                    "Destroy 3 random",
                    "cards per hand played",
                }
            },
            bl_tdec_death = {
                name = "Death",
                text = {
                    "1 in 4 chance",
                    "for jokers to not trigger"
                }
            },
            bl_tdec_beast = {
                name = "The Beast",
            },
        },
        Joker = {
            j_tdec_eyeofgreed = {
                name = "Eye of Greed",
                text = {
                    "Each played card costs {C:money}$1{}",
                    "and grants {X:mult,C:white}0.5X{} Mult",
                    "For the played {C:blue}hand{}",
                    "{C:inactive}(Starts at {X:mult,C:white}X1{C:inactive} Mult){}"
                }
            },
            j_tdec_photoquestion = {
                name = "Faded Photograph?",
                text = {
                    "I remember {C:attention}this{} one!"
                }
            },
            j_tdec_Sumptorium = {
                name = "Sumptorium",
                text = {
                    "{C:blue}-2{} Hands",
                    "At the end of each boss blind",
                    "summon a {C:red}Clot{}"
                }
            },
            j_tdec_SumptoClot = {
                name = "Clot",
                text = {
                    "Summoned by {C:red}Sumptorium{}",
                    "Grants {X:mult,C:white}X1.5{} Mult"
                }
            },
            j_tdec_purgatory = {
                name = "Purgatory",
                text = {
                    "{C:blue}Spectral{} cards grant {X:mult,C:white}X1{} Mult and {C:purple}Tarot{}",
                    "cards grant {X:mult,C:white}X0.5{} Mult for the next played {C:blue}hand{}",
                    "{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult){}"
                }
            },
            j_tdec_dried_joker = {
                name = "Dried Joker",
                text = {
                    "Does {C:red}Nothing{}. Consumed by {C:red}Erosion{}",
                    "You can probably {C:attention}Reshape{} it?"
                }
            },
            j_tdec_hierophant_locust = {
                name = "Bonus Locust",
                text = {
                    "Grants {C:blue}#2#{} chips."
                }
            },
            j_tdec_lucky_locust = {
                name = "Lucky Locust",
                text = {
                    "{C:green}#1# in #4#{} chance",
                    "to grant {C:mult}+#3#{} Mult.",
                    "{C:green}#2# in #6#{} chance",
                    "to grant {C:money}$#5#{}.",
                }
            },
            j_tdec_empress_locust = {
                name = "Empress Locust",
                text = {
                    "Grants {C:red}+#2#{} mult."
                }
            },
            j_tdec_wealthy_locust = {
                name = "Wealthy Locust",
                text = {
                    "Grants {C:red}+#2# mult{} per {C:money}$#3#{} held",
                    "and {C:money}$#5#{} at the end of a round.",
                    "{C:inactive}(Currently {X:mult,C:white} +#4# {C:inactive} Mult){}"
                }
            },
            j_tdec_executioner_locust = {
                name = "Executioner Locust",
                text = {
                    "Grants {C:red}+#2# mult{} when {C:red}destroying{} a {C:attention}card{}",
                    "{C:inactive}(Currently {X:mult,C:white} +#3# {C:inactive} Mult){}"
                }
            },
            j_tdec_foolish_locust = {
                name = "Foolish Locust",
                text = {
                    "Copies {C:money}ability{} of the {C:red}locust{} to the right."
                }
            },
            j_tdec_powerful_locust = {
                name = "Powerful Locust",
                text = {
                    "Grants {C:red}+#1# mult{} and {C:blue}+#2# chips{}",
                    "per currently owned {C:red}Locust.{}",
                    "{C:inactive}(Currently {X:mult,C:white} +#4# {C:inactive} Mult){}",
                    "{C:inactive}(Currently {X:blue,C:white} +#5# {C:inactive} Chips){}"
                }
            },
            j_tdec_soulless_locust = {
                name = "{C:dark_edition}Soulless Locust{}",
                text = {
                    "{C:green}#2# in #3#{} chance to invoke the effect of a",
                    "random {C:purple,E:2}Legendary{} joker. After every",
                    "{C:attention}#6#{} discards gain {X:mult,C:white}X#5#{} Mult.",
                    "{C:inactive}(Currently {X:mult,C:white} X#14# {C:inactive} Mult){}"
                }
            },
            j_tdec_singularity_locust = {
                name = "{C:dark_edition}Singularity Locust{}",
                text = {
                    "{C:green}Upgrade{} the level of the {C:attention}first played hand{}"
                }
            },
            j_tdec_golden_locust = {
                name = "Golden Locust",
                text = {
                    "Grants {C:money}$#2#{} at the end of a round.",
                }
            },
            j_tdec_mitosis_locust = {
                name = "Mitosis Locust",
                text = {
                    "Disappears and {C:attention}duplicates{} another {C:red}locust{} after {C:attention}#2#{} rounds",
                    "{C:inactive}(Currently {X:mult,C:white} #3#/#2# {C:inactive} Rounds){}"
                }
            },
            j_tdec_fragile_locust = {
                name = "Fragile Locust",
                text = {
                    "grants {X:mult,C:white}X1.5{} Mult",
                    "{C:green}#1# in #3#{} chance to break",
                }
            },
            j_tdec_bloody_locust = {
                name = "Bloody Locust",
                text = {
                    "grants {X:mult,C:white}X#2#{} Mult per used {C:blue}hand{}",
                    "within a round",
                    "{C:inactive}(Currently {X:mult,C:white} X#3# {C:inactive} Mult){}"
                }
            },
            j_tdec_flint_locust = {
                name = "Flinty Locust",
                text = {
                    "grants {C:blue}#2#{} Chips per used {C:blue}hand{}",
                    "within a round",
                    "{C:inactive}(Currently {C:blue}#3#{} {C:inactive}Chips){}"
                }
            },
            j_tdec_lunar_locust = {
                name = "Lunar Locust",
                text = {
                    "grants {X:mult,C:white}+#2#{} Mult per used {C:blue}hand{}",
                    "within a round",
                    "{C:inactive}(Currently {X:mult,C:white}+#3#{} {C:inactive}Mult){}"
                }
            },
            j_tdec_grateful_locust = {
                name = "Grateful Locust",
                text = {
                    "grants {C:money}$#2#{} sell value to",
                    "a random joker",
                }
            },
            j_tdec_heavy_locust = {
                name = "Heavy Locust",
                text = {
                    "grants {X:mult,C:white}+#2#{} Mult for",
                    "each card held in hand"
                }
            },
        },

        Back = {
            b_tdec_tainted_red = {
                name = "Curdled Deck",
                text = {
                    "{C:red,T:c_tdec_curdletext}Less{} is {C:blue,T:c_tdec_curdletext}More{}",
                    "{C:blue}-2{} Hands"
                }
            },
            b_tdec_tainted_black = {
                name = "Umbral Deck",
                text = {
                    "Start run with the {C:purple,T:c_tdec_lemegeton}Lemegeton{}",
                    "{C:purple,T:c_tdec_lemegetontext}Lifeblood{}"
                }
            },
            b_tdec_tainted_yellow = {
                name = "Avarice Deck",
                text = {
                    "Start run with the {C:money,T:c_tdec_turnover}Turnover{}",
                    "{C:red,T:c_tdec_wastelandtext}Economic Wasteland{}"
                }
            },
            b_tdec_tainted_green = {
                name = "Mi$er Deck",
                text = {
                    "{C:attention,T:c_tdec_greedtext}Greed{} is Good",
                    "{C:red,T:c_tdec_wealthtext}Chasing Wealth{}"
                }
            },
            b_tdec_tainted_nebula = {
                name = "Singularity Deck",
                text = {
                    "Start run with the {C:red,T:c_tdec_abyss}Abyss{}",
                    "{C:red}-1{} consumable slot"
                }

            },
            b_tdec_tainted_ghost = {
                name = "Phantasm Deck",
                text = {
                    "{C:blue,T:c_tdec_holy_card}Holier{} Cards",
                    "{C:red,T:c_tdec_phantasmtext}Last Purge{}"
                }
            },
            b_tdec_tainted_checkered = {
                name = "Enigma Deck",
                text = {
                    "Start run with the {C:attention,T:c_tdec_flip_card}Flip?{}",
                    "{V:1,T:c_tdec_fliptext}#1#{V:2,T:c_tdec_fliptext}#2#{}",
                },
            },
            b_tdec_tainted_zodiac = {
                name = "Benighted Deck",
                text = {
                    "Start run with the {C:dark_edition,T:c_tdec_bagofcrafting}Star Shaper{}",
                    "{C:red,T:c_tdec_shatteredtext}Shattered Stars{}"
                }
            },
            b_tdec_tainted_painted = {
                name = "Dried Deck",
                text = {
                    "Start run with the {C:money,T:c_tdec_artisan}Artisan{}",
                    "{C:red,T:c_tdec_erodetext}Destined To Erode{}"
                }
            },
            b_tdec_tainted_anaglyph = {
                name = "Dauntless Deck",
                text = {
                    "{C:blue,T:c_tdec_skiptext}Restless{}",
                    "{C:red,T:c_tdec_fervency}Fervency{}"
                }
            },
            b_tdec_tainted_erratic = {
                name = "C@PRIC10US D?CK",
                text = {
                    "{C:red}ST?RT RUN W_?{} {C:red,T:c_tdec_debugcard}DBG_CARD?{}",
                    "{C:red,T:c_tdec_errtext}@% EVERCHANGING? !_UNRESPONSIVE[indexfailed]{}"
                }
            },
            b_tdec_tainted_placeholder = {
                name = "Coming Soon",
                text = {
                    "...?"
                },
                unlock = {
                    "Coming Soon..."
                }
            }
        },
        Other = {
            tdec_tainted_perish = {
                name = "ERR_EVCHANGING",
                text = {
                    "{C:red}dbg = nil{}",
                }
            },
            tdec_Eroding = {
                name = "Eroding",
                text = {
                    "{C:red}Unsellable{}. Erodes over {C:attention}2{} Rounds",
                    "Becomes {C:red}Dried Joker{} after Eroding",
                    "{C:inactive}({C:attention}#2#{C:inactive} remaining){}"
                }
            }
        },
        taintedcards = {
            c_tdec_debugcard = {
                name = "Debug Card",
                text = {
                    "{C:red}[!] OUTPUT: Defined_Global_Input Corrected{}",
                    "{C:red}[!] DEBUG_JOKER when ?CHARGE? == 3",
                    "{C:inactive}(Currently {X:mult,C:white} #1#/3 {C:inactive} Charges){}"

                }
            },
            c_tdec_flip_card = {
                name = "Flip?",
                text = {
                    "Swap between the {C:blue}Alive{} and {C:attention}Dead{} state",
                    "{C:inactive}(Currently {X:mult,C:white} #1#/3 {C:inactive} Charges){}"
                }
            },
            c_tdec_holy_card = {
                name = "Holy Card",
                text = {
                    "Gain {C:blue}+1{} hand. If the extra hand is used, the effect is {C:red}lost{}"
                }
            },
            c_tdec_fervency = {
                name = "Fervency",
                text = {
                    "Going below {C:attention}40{} or above {C:attention}60{} {C:red}Fervency{} reduces {X:mult,C:white}Xmult{}",
                    "{C:attention}Challenging{} blinds swaps between {C:red}Heating{} and {C:blue}Cooling{}",
                    "{C:attention}Actions{} {C:red}increase{}/{C:blue}decrease{} {C:red}Fervency{} depending on the state",
                    "Reaching {C:attention}0{} or {C:attention}100{} {C:red}Fervency ends{} the run",
                    "{C:inactive}(Currently {X:attention,C:white} #1#/100 {C:inactive} Fervency){}"
                }
            },
            c_tdec_artisan = {
                name = "The Artisan",
                text = {
                    "Carve and Sketch your {C:attention}Destiny.{}",
                    "{C:inactive}(Currently {X:mult,C:white} #2#/3 {C:inactive} Chisel Charges){}",
                    "{C:inactive}(Currently {X:mult,C:white} #1#/8 {C:inactive} Sketch Charges){}"
                }
            },
            c_tdec_turnover = {
                name = "{C:money}Turnover{}",
                text = {
                    "Spend {C:money}$5{} to open a {C:money}Shop{}",
                    "or to {C:money}upgrade{} an existing {C:money}Shop{}",
                }
            },
            c_tdec_abyss = {
                name = "{C:red}Abyss{}",
                text = {
                    "Destroy a {C:attention}Consumable{} to",
                    "Turn it into a {C:red}Locust{} with special {C:attention}effects{}",
                    "{C:inactive}(Currently {X:mult,C:white} #1#/2 {C:inactive} Charges){}"
                }
            },
            c_tdec_bagofcrafting = {
                name = "{C:dark_edition}Star Shaper{}",
                text = {
                    "Collect up to 3 {C:attention}Consumables{}",
                    "To create a random {C:attention}Joker{}",
                }
            },
            c_tdec_lemegeton = {
                name = "{C:purple}Lemegeton{}",
                text = {
                    "Create a random {C:purple}Frail Joker{}",
                    "Unusable when there are {C:purple}5+ Frail Jokers{}",
                    "{C:inactive}(Currently {X:purple,C:white} #1#/4 {C:inactive} [Max: 8] Charges){}"
                }
            },
            c_tdec_curdletext = {
                name = "Curdling",
                text = {
                    "{C:red}+2{} Discard Limit",
                    "Discarding {C:red}1{} card grants",
                    "an additional {C:blue}hand{}"
                }
            },
            c_tdec_lemegetontext = {
                name = "Lifeblood",
                text = {
                    "{C:red}No money{} from leftover {C:blue}hands{}",
                    "Convert leftover {C:blue}hands{} into",
                    "{C:purple}lemegeton charges{}"
                }
            },
            c_tdec_greedtext = {
                name = "Greed",
                text = {
                    "Gain {X:mult,C:white}X0.05{} Mult per {C:money}$5{} held",
                    "Leaving a shop without purchases grants {C:money}money{}",
                    "{C:inactive}(Starts at {X:mult,C:white} X1 {C:inactive} Mult)"
                }
            },
            c_tdec_wealthtext = {
                name = "Chasing Wealth",
                text = {
                    "Shop prices {C:red}increase{} the more",
                    "{C:money}money{} is held currently."
                }
            },
            c_tdec_phantasmtext = {
                name = "Last Purge",
                text = {
                    "Limited to {C:blue}1 Hand{}",
                    "Grants {X:mult,C:white}X1.75{} Mult"
                }
            },
            c_tdec_wastelandtext = {
                name = "Economic Wasteland",
                text = {
                    "Shops can {C:red}no longer appear{}"
                }
            },
            c_tdec_shatteredtext = {
                name = "Shattered Stars",
                text = {
                    "Jokers are turned into {C:purple}consumables{}"
                }
            },
            c_tdec_skiptext = {
                name = "Restless",
                text = {
                    "{C:red}No skips{}",
                    "Attempting to skip a blind will",
                    "{C:attention}challenge{} it instead, increasing",
                    "score requirement by {X:mult,C:white}X1.5{}"
                }
            },
            c_tdec_errtext = {
                name = "EVERCHANGING?",
                text = {
                    "Jokers are {C:red}rerolled{} after",
                    "leaving a shop"
                }
            },
            c_tdec_fliptext = {
                name = "Flipside",
                text = {
                    "Entering a shop swaps between",
                    "the {C:attention}Alive{} and {C:blue}Dead{} state",
                    "{C:attention}Jokers{} and {C:money}Money{} aren't shared"
                }
            },
            c_tdec_erodetext = {
                name = "Erosion",
                text = {
                    "If no jokers are affected by {C:red}Erosion{}",
                    "apply it to any joker when the round ends",
                    "After {C:attention}2{} rounds, turn {C:red}Eroding{} jokers",
                    "into {C:attention}Dried Jokers{}"
                }
            },
        },

        Edition = {
            e_tdec_clotting = {
                name = "Clotting",
                text = {
                    "{C:blue}+1{} Joker Slot, {C:red}Removed{}",
                    "if {C:red}Sumptorium{} isn't present"
                }
            },
            e_tdec_frailty = {
                name = "Frailty",
                text = {
                    "{C:purple}+1{} Joker Slot",
                    "{C:purple}-15%{} Total Score",
                }
            },

        }
    },
    misc = {
        achievement_names = {
            ach_tdec_beast_red       = "The Curdled",
            ach_tdec_beast_blue      = "??? ???",
            ach_tdec_beast_yellow    = "The Monopoly",
            ach_tdec_beast_green     = "The Rapacity",
            ach_tdec_beast_black     = "The Profane",
            ach_tdec_beast_magic     = "The Twisted",
            ach_tdec_beast_nebula    = "The Plagued",
            ach_tdec_beast_ghost     = "The Baleful",
            ach_tdec_beast_abandoned = "??? ???",
            ach_tdec_beast_checkered = "The Liminal",
            ach_tdec_beast_zodiac    = "The Hoarder",
            ach_tdec_beast_painted   = "The Crumbled",
            ach_tdec_beast_anaglyph  = "The Flatline",
            ach_tdec_beast_plasma    = "??? ???",
            ach_tdec_beast_erratic   = "TH$_; _#$_$o$u$op(_){$?",
        },
        achievement_descriptions = {
            ach_tdec_beast_red       = "Defeat ??? with the Red Deck",
            ach_tdec_beast_blue      = "Defeat ??? with the Blue Deck",
            ach_tdec_beast_yellow    = "Defeat ??? with the Yellow Deck",
            ach_tdec_beast_green     = "Defeat ??? with the Green Deck",
            ach_tdec_beast_black     = "Defeat ??? with the Black Deck",
            ach_tdec_beast_magic     = "Defeat ??? with the Magic Deck",
            ach_tdec_beast_nebula    = "Defeat ??? with the Nebula Deck",
            ach_tdec_beast_ghost     = "Defeat ??? with the Ghost Deck",
            ach_tdec_beast_abandoned = "Defeat ??? with the Abandoned Deck",
            ach_tdec_beast_checkered = "Defeat ??? with the Checkered Deck",
            ach_tdec_beast_zodiac    = "Defeat ??? with the Zodiac Deck",
            ach_tdec_beast_painted   = "Defeat ??? with the Painted Deck",
            ach_tdec_beast_anaglyph  = "Defeat ??? with the Anaglyph Deck",
            ach_tdec_beast_plasma    = "Defeat ??? with the Plasma Deck",
            ach_tdec_beast_erratic   = "Defeat ??? with the Erratic Deck",

        },
        labels = {
            tdec_clotting = "Clotting",
            tdec_tainted_perish = "EVERCHANGING",
            tdec_Eroding = "Eroding",
            tdec_frailty = "Frailty"
        }
    }
}
