return {
    descriptions = {
        Mod = {
            TaintedDecks = {
                name = "Tainted Decks",
                text = {
                    "- Adds tainted decks, inspired by TBOI, implemented by",
                    "{C:attention}Autumint{} and {C:attention}lord.ruby{}.",
                    "- Featuring sprites from {C:attention}lord.ruby{}",
                    "- {C:blue}Abyss Card{} and {C:blue}Flip Card{} sprites by {C:attention}danihunn{}"
                }
            }
        },
        Enhanced = {
            m_tdec_pestilence = {
                name = "Pestilence Card",
                text = {
                    "Card consumed by {C:green}Pestilence{}",
                    "Doesn't score"
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
                name = "The Pestilence",
                text = {
                    "Debuff cards depending on",
                    "deck size per hand played"
                }
            },
            bl_tdec_war = {
                name = "The War",
                text = {
                    "Destroy 3 random",
                    "cards per hand played",
                }
            },
            bl_tdec_death = {
                name = "The Death",
                text = {
                    "1 in 3 chance",
                    "for jokers to not trigger"
                }
            },
            bl_tdec_beast = {
                name = "The Beast",
                text = {
                }
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
            j_tdec_tainted_madness = {
                name = "Tainted Madness",
                text = {
                    "{C:red,E:2}What's yours is mine{}",
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
                    "Provides {X:mult,C:white}X1.5{} Mult"
                }
            },
            j_tdec_purgatory = {
                name = "Purgatory",
                text = {
                    "{C:blue}Spectral{} cards grant {X:mult,C:white}X1{} Mult and {C:purple}Tarot{}",
                    "cards grant {X:mult,C:white}X0.5{} Mult for the next played {C:blue}hand{}",
                    "{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult)"
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
                    "{C:inactive}(Currently {X:mult,C:white} +#4# {C:inactive} Mult)"
                }
            },
            j_tdec_executioner_locust = {
                name = "Executioner Locust",
                text = {
                    "Grants {C:red}+#2# mult{} when {C:red}destroying{} a {C:attention}card{}",
                    "{C:inactive}(Currently {X:mult,C:white} +#3# {C:inactive} Mult)"
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
                    "{C:inactive}(Currently {X:mult,C:white} +#4# {C:inactive} Mult)",
                    "{C:inactive}(Currently {X:blue,C:white} +#5# {C:inactive} Chips)"
                }
            },
            j_tdec_soulless_locust = {
                name = "{C:dark_edition}Soulless Locust{}",
                text = {
                    "{C:green}#2# in #3#{} chance to invoke the effect of a",
                    "random {C:purple,E:2}Legendary{} joker. After every",
                    "{C:attention}#6#{} discards gain {X:mult,C:white}X#5#{} Mult.",
                    "{C:inactive}(Currently {X:mult,C:white} X#14# {C:inactive} Mult)"
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
                    "{C:inactive}(Currently {X:mult,C:white} #3#/#2# {C:inactive} Rounds)"
                }
            },
        },

        Back = {
            b_tdec_tainted_red = {
                name = "Curdled Deck",
                text = {
                    "{C:red}Less{} is {C:blue}More{}",
                    "{C:blue}-2{} Hands"
                }
            },
            b_tdec_tainted_yellow = {
                name = "Avarice Deck",
                text = {
                    "Start run with the {C:money,T:c_tdec_turnover}Turnover{}",
                    "{C:red,E:2}Economic Wasteland.{}"
                }
            },
            b_tdec_tainted_green = {
                name = "Mi$er Deck",
                text = {
                    "{C:attention}Greed{} is Good",
                    "{C:red,E:2}Chasing Wealth.{}"
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
                    "{C:red,E:2}Last Purge.{}"
                }
            },
            b_tdec_tainted_checkered = {
                name = "Enigma Deck",
                text = {
                    "{V:1}#1#{V:2}#2#{}",
                    "Between {V:2}Life{} and {V:1}Death{}",
                },
            },
            b_tdec_tainted_zodiac = {
                name = "Benighted Deck",
                text = {
                    "Better {C:money}Shops{}",
                    "{C:red,E:2}Repent for your Debt.{}"
                }
            },
            b_tdec_tainted_painted = {
                name = "Dried Deck",
                text = {
                    "Start run with the",
                    "{C:money,T:c_tdec_thechisel}Chisel{} and {C:money,T:c_tdec_thesketch}Sketch{}",
                    "{C:red,E:2}Destined To Erode."

                }
            },
            b_tdec_tainted_anaglyph = {
                name = "Dauntless Deck",
                text = {
                    "{C:blue}Restless{}",
                    "{C:red,E:2}Fervency.{}"
                }
            },
            b_tdec_tainted_erratic = {
                name = "C@PRIC10US D?CK",
                text = {
                    "{C:red}ST?RT RUN W_?{} {C:red,T:c_tdec_debugcard}DBG_CARD?{}",
                    "{C:red}@% EVERCHANGING? !_UNRESPONSIVE[indexfailed]{}"
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

                    "{C:inactive}({C:attention}#2#{C:inactive} remaining)"
                }
            }
        },

        taintedcards = {
            c_tdec_debugcard = {
                name = "Debug Card",
                text = {
                    "{C:red}[!] OUTPUT: Defined_Global_Input Corrected{}",
                    "{C:red}[!] DEBUG_JOKER when ?CHARGE? == 3",
                    "{C:inactive}(Currently {X:mult,C:white} #1#/3 {C:inactive} Charges)"

                }
            },
            c_tdec_flip_card = {
                name = "Flip?",
                text = {
                    "Swap between the {C:blue}Alive{} and {C:attention}Dead{} state.",
                    "{C:inactive}(Currently {X:mult,C:white} #1#/3 {C:inactive} Charges)"
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
                    "{C:inactive}(Currently {X:attention,C:white} #1#/100 {C:inactive} Fervency)"
                }
            },
            c_tdec_thechisel = {
                name = "Chisel",
                text = {
                    "Carve your {C:attention}Destiny.{}",
                    "{C:inactive}(Currently {X:mult,C:white} #1#/3 {C:inactive} Charges)"
                }
            },
            c_tdec_thesketch = {
                name = "Sketch",
                text = {
                    "Write your {C:attention}Destiny.{}",
                    "{C:inactive}(Currently {X:mult,C:white} #1#/8 {C:inactive} Charges)"
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
                    "{C:inactive}(Currently {X:mult,C:white} #1#/2 {C:inactive} Charges)"
                }
            }
        },

        Edition = {
            e_tdec_clotting = {
                name = "Clotting",
                text = {
                    "{C:blue}+1{} Joker Slot, {C:red}Removed{}",
                    "if {C:red}Sumptorium{} isn't present"
                }
            },
            e_tdec_ghostly = {
                name = "Dead",
                text = {
                    "{C:green}#1# in #2#{} chance to {C:attention}trigger{} the joker's effect and {}remove{} itself"
                }
            }
        }
    },
    misc = {
            achievement_names={
            ach_tdec_beast_red       = "The Curdled",
            ach_tdec_beast_blue      = "The Drowned",
            ach_tdec_beast_yellow    = "The Monopoly",
            ach_tdec_beast_green     = "The Hoarder",
            ach_tdec_beast_black     = "??? ???",
            ach_tdec_beast_magic     = "The Twisted",
            ach_tdec_beast_nebula    = "The Plagued",
            ach_tdec_beast_ghost     = "The Baleful",
            ach_tdec_beast_abandoned = "??? ???",
            ach_tdec_beast_checkered = "The Liminal",
            ach_tdec_beast_zodiac    = "The Unforgiven",
            ach_tdec_beast_painted   = "The Crumbled",
            ach_tdec_beast_anaglyph  = "The Flatline",
            ach_tdec_beast_plasma    = "??? ???",
            ach_tdec_beast_erratic   = "TH$_; CRRPTD_#$_$o$u$op(_){$?",
        },
        achievement_descriptions={
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
            tdec_ghostly = "Ghostly"
        }
    }

}