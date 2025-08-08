mummy_raise_adjectives={
    "crypt",
    "tomb",
    "entombed",
    "buried",
    "once-resting",
    "sanctified",
    "sacred",
    "profane",
    "mausoleum",
    "coffin",
    "grave",
    "sepulcher",
    "interred",
}

mummy_raise_nouns={
    {"one","ones"},
    {"corpse","corpses"},
    {"ghoul","ghouls"},
    {"zombie","zombies"},
    {"stalker","stalkers"},
    {"butcher","butchers"},
    {"hunter","hunters"},
    {"slayer","slayers"},
}

mummy_curses={
    default=function(idx)
        local tbl={"[INTERACTION:"..random_object_parameters.token_prefix.."DISTURBANCE_CURSE_"..tostring(idx).."]"}
        tbl=add_generated_info(tbl)
        tbl=split_to_lines(tbl,[[
            [I_TARGET:A:CREATURE]
            [IT_LOCATION:CONTEXT_CREATURE]
            [IT_CANNOT_TARGET_IF_ALREADY_AFFECTED]
            [IT_MANUAL_INPUT:victim]
        [I_EFFECT:ADD_SYNDROME]
            [IE_TARGET:A]
            [IE_IMMEDIATE]
            [IE_ARENA_NAME:Cursed]
            [SYNDROME]
                [SYN_CONCENTRATION_ADDED:1000:0]//just in case
                [CE_SKILL_ROLL_ADJUST:PERC:0:PERC_ON:20:START:0:ABRUPT]

        ]])
        return {raws=tbl,weight=1}
    end
}

mummy_animations={
    default=function(idx)
        local tbl={"[INTERACTION:"..random_object_parameters.token_prefix.."DISTURBANCE_ANIMATE_"..tostring(idx).."]"}
        tbl=add_generated_info(tbl)
        return {raws=table_merge(tbl,basic_animation()),weight=1}
    end
}

interactions.disturbance.default=function(idx)
    local tbl={}
    local pref=random_object_parameters.token_prefix
    local adj = pick_random(mummy_raise_adjectives)
    local noun = pick_random(mummy_raise_nouns)
    local raise_name = adj.." "..noun[1]
    local raise_name_plural = adj.." "..noun[2]
    tbl=split_to_lines(tbl,[[
        [I_SOURCE:DISTURBANCE]
        [I_TARGET:A:CORPSE]
            [IT_LOCATION:CONTEXT_ITEM]
            [IT_FORBIDDEN:NOT_LIVING]
            [IT_REQUIRES:FIT_FOR_RESURRECTION]
            [IT_REQUIRES:CAN_LEARN]
            [IT_REQUIRES:CAN_SPEAK]
            [IT_CANNOT_HAVE_SYNDROME_CLASS:WERECURSE]
            [IT_CANNOT_HAVE_SYNDROME_CLASS:VAMPCURSE]
            [IT_CANNOT_HAVE_SYNDROME_CLASS:DISTURBANCE_CURSE]
            [IT_CANNOT_HAVE_SYNDROME_CLASS:RAISED_UNDEAD]
            [IT_CANNOT_HAVE_SYNDROME_CLASS:RAISED_GHOST]
            [IT_CANNOT_HAVE_SYNDROME_CLASS:GHOUL]
        [I_EFFECT:RESURRECT]
            [IE_TARGET:A]
            [IE_IMMEDIATE]
            [IE_ARENA_NAME:Disturbed dead]
            [SYNDROME]
                [SYN_CLASS:DISTURBED_DEAD]
                [SYN_CONCENTRATION_ADDED:1000:0]//just in case
                [SYN_CLASS:DISTURBANCE_CURSE]
                [CE_DISPLAY_TILE:TILE:165:6:0:1:START:0:ABRUPT]
                [CE_DISPLAY_NAME:NAME:mummy:mummies:mummified:START:0:ABRUPT]
                [CE_PHYS_ATT_CHANGE:STRENGTH:300:1000:TOUGHNESS:300:1000:START:0:ABRUPT]
                [CE_ADD_TAG:NO_AGING:NOT_LIVING:STERILE:EXTRAVISION:NOEXERT:NOPAIN:NOBREATHE:NOSTUN:NONAUSEA:NO_DIZZINESS:NO_FEVERS:NOEMOTION:PARALYZEIMMUNE:NOFEAR:NO_EAT:NO_DRINK:NO_SLEEP:NO_PHYS_ATT_GAIN:NO_PHYS_ATT_RUST:NOTHOUGHT:NO_THOUGHT_CENTER_FOR_MOVEMENT:NO_CONNECTIONS_FOR_MOVEMENT:START:0:ABRUPT]
                [CE_REMOVE_TAG:HAS_BLOOD:TRANCES:MISCHIEVOUS:START:0:ABRUPT]
                [CE_CHANGE_PERSONALITY:FACET:ANXIETY_PROPENSITY:50:FACET:TRUST:-50:FACET:VENGEFUL:100:START:0:ABRUPT]
                [CE_CAN_DO_INTERACTION:START:0:ABRUPT]
                    [CDI:ADV_NAME:Curse]
                    [CDI:INTERACTION:]]..random_object_parameters.token_prefix.."DISTURBANCE_CURSE_"..tostring(idx)..[[]
                    [CDI:TARGET:A:LINE_OF_SIGHT:DISTURBER_ONLY]
                    [CDI:TARGET_RANGE:A:25]
                    [CDI:USAGE_HINT:MAJOR_CURSE]
                    [CDI:VERBAL]
                    [CDI:VERBAL_SPEECH:curse.txt]
                    [CDI:TARGET_VERB:feel horrible:looks horrible]
                    [CDI:MAX_TARGET_NUMBER:A:1]
                    [CDI:WAIT_PERIOD:20]
                    [CDI:DEFAULT_ICON:ADVENTURE_INTERACTION_ICON_LUCK_CURSE]
                [CE_CAN_DO_INTERACTION:START:0:ABRUPT]
                    [CDI:ADV_NAME:Animate corpse]
                    [CDI:INTERACTION:]]..random_object_parameters.token_prefix.."DISTURBANCE_ANIMATE_"..tostring(idx)..[[]
                    [CDI:TARGET:A:LINE_OF_SIGHT]
                    [CDI:TARGET_RANGE:A:25]
                    [CDI:VERB:gesture:gestures:NA]
                    [CDI:TARGET_VERB:shudder and begin to move:shudders and begins to move]
                    [CDI:WAIT_PERIOD:10]
                    [CDI:DEFAULT_ICON:ADVENTURE_INTERACTION_ICON_ANIMATE_CORPSE]
                [CE_CAN_DO_INTERACTION:START:0:ABRUPT]
                    [CDI:ADV_NAME:Raise ]]..raise_name..[[]
                    [CDI:INTERACTION:]]..random_object_parameters.token_prefix.."DISTURBANCE_UNDEAD_RES_"..tostring(idx)..[[]
                    [CDI:TARGET:A:LINE_OF_SIGHT]
                    [CDI:TARGET_RANGE:A:10]
                    [CDI:VERB:gesture:gestures:NA]
                    [CDI:TARGET_VERB:shudder and begin to move:shudders and begins to move]
                //************************ RITUALS
                    [CDI:WAIT_PERIOD:10]
                    [CDI:DEFAULT_ICON:ADVENTURE_INTERACTION_ICON_RAISE_INTELLIGENT_UNDEAD]
    ]])
    local g=generate_from_list(mummy_curses,idx)
    local generated_tbl=g.raws or g.interaction
    table_merge(tbl,generated_tbl)
    local g=generate_from_list(mummy_animations,idx)
    local generated_tbl=g.raws or g.interaction
    table_merge(tbl,generated_tbl)
    tbl[#tbl+1]="[INTERACTION:"..random_object_parameters.token_prefix.."DISTURBANCE_UNDEAD_RES_"..tostring(idx).."]"
    add_generated_info(tbl)
    local t,et=basic_lieutenant(raise_name,raise_name_plural,random_object_parameters.token_prefix.."DISTURBANCE_UNDEAD_RES_"..tostring(idx))
    return {raws=table_merge(table_merge(tbl,t),et),weight=1}
end