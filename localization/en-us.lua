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
            }
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
                    "Start run with the {C:money}Turnover{}",
                    "{C:red,E:2}Economic Wasteland.{}"
                }
            },
            b_tdec_tainted_green = {
                name = "Mi$er Deck",
                text = {
                    "{C:attention}Greed{} is Good.",
                    "{C:red,E:2}Chasing Wealth.{}"
                }
            },
            b_tdec_tainted_ghost = {
                name = "Phantasm Deck",
                text = {
                    "{C:blue}Holier{} Cards",
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
                    "Better {C:money}Shops.{}",
                    "{C:red,E:2}Repent for your Debt.{}"
                }
            },
            b_tdec_tainted_painted = {
                name = "Dried Deck",
                text = {
                    "Start run with the",
                    "{C:money}Chisel{} and {C:money}Sketch{}",
                    "{C:red,E:2}Destined To Erode."

                }
            },
            b_tdec_tainted_anaglyph = {
                name = "Dauntless Deck",
                text = {
                    "{C:blue}Restless{}",
                    "{C:red,E:2}No Skips.{}"
                }
            },
            b_tdec_tainted_erratic = {
                name = "C@PRIC10US D?CK",
                text = {
                    "{C:red}ST?RT RUN W_? DBG_CARD?{}", 
                    "{C:red,E:2}@% EVERCHANGING? !_UNRESPONSIVE[indexfailed]{}"
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
                name = "Turnover",
                text = {
                    "Spend {C:money}$15{} to open a {C:money}Shop{}"
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