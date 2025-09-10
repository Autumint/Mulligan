return {
    descriptions = {
        Joker = {
            j_tdec_eyeofgreed = {
                name = "Eye of Greed",
                text = {
                    "Each played card costs {C:money}$1{}",
                    "and grants {X:mult,C:white}0.5X{} mult",
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
                    "Provides {X:mult,C:white}X1.5{} mult"
                }
            },
            j_tdec_purgatory = {
                name = "Purgatory",
                text = {
                    "{C:blue}Spectral{} cards grant {X:mult,C:white}X1{} mult and {C:purple}Tarot{}",
                    "cards grant {X:mult,C:white}X0.5{} mult for the next played {C:blue}hand{}",
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
                    "Placeholder"
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
                    "{C:red}Fervency{} is lost passively through various {C:attention}actions{}",
                    "Going below {C:attention}50{} {C:red}Fervency{} will slowly reduce {X:mult,C:white}Xmult{}",
                    "Losing all {C:red}Fervency{} will immediately {C:red}end{} the run",
                    "Gain {C:red}Fervency{} by {C:attention}challenging{} blinds",
                    "{C:inactive}(Currently {X:mult,C:white} #1#/100 {C:inactive} Fervency)"
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
            }
        }
    },
    misc = {
        labels = {
            tdec_clotting = "Clotting",
            tdec_tainted_perish = "EVERCHANGING",
            tdec_Eroding = "Eroding"
    }
}

}