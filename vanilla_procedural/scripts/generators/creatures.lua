require "generators.creatures.rcp"

require "generators.creatures.shared_info"


regiontypes={
    SWAMP={
        spheres={
            WATER=true,
            MUCK=true,
            PLANTS=true,
            ANIMALS=true,
            NATURE=true,
        },
        name=function(sr)
            local swamp_count = 0
            for k,v in pairs(sr.biome_count) do
                if string.find(k,"SWAMP") then
                    swamp_count = swamp_count + 1
                elseif string.find(k,"MARSH") then
                    swamp_count = swamp_count - 1
                end
            end
            return (swamp_count >= 0) and "swamp" or "marsh"
        end
    },
    DESERT={
        spheres={
            FIRE=true,
            PLANTS=true,
            ANIMALS=true,
            NATURE=true,
        },
        name=function(sr)
            return (sr.biome_count.DESERT_SAND > sr.biome_count.DESERT_ROCK + sr.biome_count.DESERT_BADLAND) and "sand" or "desert"
        end
    },
    FOREST={
        spheres={
            TREES=true,
            PLANTS=true,
            RIVERS=true,
            ANIMALS=true,
            NATURE=true,
        },
        name=function(sr)
            if sr.biome_count.FOREST_TAIGA>
              sr.biome_count.FOREST_TEMPERATE_CONIFER+
              sr.biome_count.FOREST_TEMPERATE_BROADLEAF+
              sr.biome_count.FOREST_TROPICAL_CONIFER+
              sr.biome_count.FOREST_TROPICAL_DRY_BROADLEAF+
              sr.biome_count.FOREST_TROPICAL_MOIST_BROADLEAF then
                return "taiga"
            elseif sr.biome_count.FOREST_TROPICAL_MOIST_BROADLEAF>
              sr.biome_count.FOREST_TAIGA+
              sr.biome_count.FOREST_TEMPERATE_CONIFER+
              sr.biome_count.FOREST_TEMPERATE_BROADLEAF+
              sr.biome_count.FOREST_TROPICAL_CONIFER+
              sr.biome_count.FOREST_TROPICAL_DRY_BROADLEAF then 
                return "jungle"    
            else
                return "forest"
            end
        end
    },
    MOUNTAINS={
        spheres={
            MOUNTAINS=true,
            CAVERNS=true,
            MINERALS=true,
            METALS=true,
            ANIMALS=true,
            NATURE=true,
        },
        name=function() return "mountain" end
    },
    OCEAN={
        spheres={
            WATER=true,
            OCEANS=true,
            FISH=true,
            ANIMALS=true,
            NATURE=true,
        },
        name=function() return "ocean" end
    },
    LAKE={
        spheres={
            WATER=true,
            LAKES=true,
            RIVERS=true,
            FISH=true,
            ANIMALS=true,
            NATURE=true,
        },
        name=function() return "lake" end
    },
    GLACIER={
        spheres={
            ANIMALS=true,
            NATURE=true,
        },
        name=function() return "glacier" end
    },
    TUNDRA={
        spheres={
            ANIMALS=true,
            NATURE=true,
        },
        name=function() return "tundra" end
    },
    GRASSLAND={
        spheres={
            ANIMALS=true,
            RIVERS=true,
            PLANTS=true,
            NATURE=true,
        },
        name=function(sr) 
            if sr.biome_count.SHRUBLAND_TEMPERATE+
              sr.biome_count.SHRUBLAND_TROPICAL>
              sr.biome_count.GRASSLAND_TEMPERATE+
              sr.biome_count.GRASSLAND_TROPICAL+
              sr.biome_count.SAVANNA_TEMPERATE+
              sr.biome_count.SAVANNA_TROPICAL then
                return "brush"
            elseif(sr.biome_count.SAVANNA_TEMPERATE+
              sr.biome_count.SAVANNA_TROPICAL>
              sr.biome_count.SHRUBLAND_TEMPERATE+
              sr.biome_count.SHRUBLAND_TROPICAL+
              sr.biome_count.GRASSLAND_TEMPERATE+
              sr.biome_count.GRASSLAND_TROPICAL) then 
                return "savanna"
            else
                return "plains"
            end
        end
    },
    HILLS={
        spheres={
            ANIMALS=true,
            RIVERS=true,
            PLANTS=true,
            NATURE=true,
        },
        name=function() return "hill" end
    },
    NONE={
        spheres={},
        name=function(subregion) return "buggy" end
    }
}

creatures.fb.default=function(layer_type,tok)
    local tbl={}
    local options={
        strong_attack_tweak=true,
        spheres={CAVERNS=true},
        is_evil=true,
        sickness_name="beast sickness",
        token=tok
    }
    tbl=split_to_lines(tbl,[[
    [FEATURE_BEAST]
    [ATTACK_TRIGGER:0:0:2]
    [NAME:forgotten beast:forgotten beasts:forgotten beast]
    [CASTE_NAME:forgotten beast:forgotten beasts:forgotten beast]
    [NO_GENDER]
    [CARNIVORE]
    [DIFFICULTY:10]

    [NATURAL_SKILL:WRESTLING:6]
    [NATURAL_SKILL:BITE:6]
    [NATURAL_SKILL:GRASP_STRIKE:6]
    [NATURAL_SKILL:STANCE_STRIKE:6]
    [NATURAL_SKILL:MELEE_COMBAT:6]
    [NATURAL_SKILL:DODGING:6]
    [NATURAL_SKILL:SITUATIONAL_AWARENESS:6]
    [LARGE_PREDATOR]
    ]])
    add_regular_tokens(tbl,options)
    tbl[#tbl+1]=layer_type==0 and "[BIOME:SUBTERRANEAN_WATER]" or "[BIOME:SUBTERRANEAN_CHASM]"
    if layer_type==0 then options.spheres.WATER=true end
    options.spheres[pick_random(evil_spheres)]=true
    options.do_water=layer_type==0
    populate_sphere_info(tbl,options)
    local rcp=get_random_creature_profile(options)
    add_body_size(tbl,math.max(10000000,rcp.min_size),options)
    tbl[#tbl+1]="[CREATURE_TILE:"..tile_string(rcp.tile).."]"
    build_procgen_creature(rcp,tbl,options)
    return {raws=tbl,weight=1}
end

creatures.titan.default=function(subregion,tok)
    local tbl={}
    local options={
        pick_sphere_rcm=true,
        strong_attack_tweak=true,
        sickness_name="titan sickness",
        token=tok
    }
    local atp = tostring(world.param.titan_attack_trigger_population)
    local atew = tostring(world.param.titan_attack_trigger_exported_wealth)
    local atcw = tostring(world.param.titan_attack_trigger_created_wealth)
    split_to_lines(tbl,[[
    [TITAN]
    [ATTACK_TRIGGER:]]..atp..":"..atew..":"..atcw..[[]
    [NO_GENDER]
    [NO_DRINK][NO_EAT][NO_SLEEP]
    [DIFFICULTY:10]
    [LAIR:SHRINE:100]

    [NATURAL_SKILL:WRESTLING:6]
    [NATURAL_SKILL:BITE:6]
    [NATURAL_SKILL:GRASP_STRIKE:6]
    [NATURAL_SKILL:STANCE_STRIKE:6]
    [NATURAL_SKILL:MELEE_COMBAT:6]
    [NATURAL_SKILL:DODGING:6]
    [NATURAL_SKILL:SITUATIONAL_AWARENESS:15]
    ]])
    add_regular_tokens(tbl,options)
    options.spheres={}
    if subregion then
        map_merge(options.spheres,regiontypes[subregion.type].spheres)
        if subregion.is_evil then
            options.spheres[pick_random(evil_spheres)]=true
            options.is_evil = true
        elseif subregion.is_good then
            options.spheres[pick_random(good_spheres)]=true
            options.is_good = true
        end
    end
    populate_sphere_info(tbl,options)
    local rcp=get_random_creature_profile(options)
    add_body_size(tbl,math.max(10000000,rcp.min_size),options)
    tbl[#tbl+1]="[CREATURE_TILE:"..tile_string(rcp.tile).."]"
    if options.is_good then
        tbl[#tbl+1]="[BENIGN]"
    else
        tbl[#tbl+1]="[LARGE_PREDATOR]"
    end
    build_procgen_creature(rcp,tbl,options)
    tbl[#tbl+1]="[GO_TO_START]"
    local subreg_name=subregion and regiontypes[subregion.type].name(subregion) or "buggy"
    local name_str = subreg_name.." titan:"..subreg_name.." titans:"..subreg_name.."-titan]"
    tbl[#tbl+1]="[NAME:"..name_str
    tbl[#tbl+1]="[CASTE_NAME:"..name_str
    return {raws=tbl,weight=1}
end

local adj_exploitable_check <const> = function(str)
    return not str or string.upper(str)~="BLACK"
end

demon_names={
    {name="demon",names="demons",name_adj="demonic",cond=function(options) return true end},
    {name="devil",names="devils",name_adj="devilish",cond=function(options) return true end},
    {name="fiend",names="fiends",name_adj="fiendish",cond=function(options) return true end},
    {name="brute",names="brutes",name_adj="brutish",cond=function(options) return adj_exploitable_check(options.fadj) end},
    {name="monster",names="monsters",name_adj="monster",cond=function(options) return true end},
    {name="spirit",names="spirits",name_adj="spirit",cond=function(options) return options.intangible end},
    {name="ghost",names="ghosts",name_adj="ghost",cond=function(options) return options.intangible end},
    {name="banshee",names="banshees",name_adj="banshee",cond=function(options) return options.intangible end},
    {name="haunt",names="haunts",name_adj="haunt",cond=function(options) return options.intangible end},
    {name="phantom",names="phantoms",name_adj="phantom",cond=function(options) return options.intangible end},
    {name="specter",names="specters",name_adj="specter",cond=function(options) return options.intangible end},
    {name="wraith",names="wraiths",name_adj="wraith",cond=function(options) return options.intangible end},
}

creatures.demon.default=function(demon_type,difficulty,tok)
    local tbl={}
    local l2=get_debug_logger(2)
    l2(tok,demon_type,difficulty)
    local options={
        is_evil=true,
        pick_sphere_rcm=true,
        strong_attack_tweak=true,
        always_nobreathe=true,
        force_goo=true,
        intangible_flier=true,
        fixed_temp=10040,
        forced_odor_chance=2,
        forced_odor_string="brimstone",
        forced_odor_level=90,
        sickness_name="demon sickness",
        feature_flavor_adj=true,
        fire_immune=true,
        token=tok
    }
    if demon_type=="unique" then
        tbl=split_to_lines(tbl,[[
[UNIQUE_DEMON]
[SPREAD_EVIL_SPHERES_IF_RULER]

[NATURAL_SKILL:WRESTLING:14]
[NATURAL_SKILL:BITE:14]
[NATURAL_SKILL:GRASP_STRIKE:14]
[NATURAL_SKILL:STANCE_STRIKE:14]
[NATURAL_SKILL:MELEE_COMBAT:14]
[NATURAL_SKILL:RANGED_COMBAT:14]
[NATURAL_SKILL:DODGING:14]
[NATURAL_SKILL:SITUATIONAL_AWARENESS:14]

[CAN_LEARN][CAN_SPEAK][DIFFICULTY:10]
        ]])
        options.humanoid_only=true
        options.can_learn=true
    else
        tbl=split_to_lines(tbl,[[
[DEMON]

[NATURAL_SKILL:WRESTLING:10]
[NATURAL_SKILL:BITE:10]
[NATURAL_SKILL:GRASP_STRIKE:10]
[NATURAL_SKILL:STANCE_STRIKE:10]
[NATURAL_SKILL:MELEE_COMBAT:10]
[NATURAL_SKILL:RANGED_COMBAT:10]
[NATURAL_SKILL:DODGING:10]
[NATURAL_SKILL:SITUATIONAL_AWARENESS:10]
        ]])
        if(demon_type=="humanoid_beast") then options.humanoid_only=true end
        if one_in(2) then 
            tbl[#tbl+1]="[CAN_LEARN][CAN_SPEAK]"
            options.can_learn=true
        end
        tbl=split_to_lines(tbl,[[
[LARGE_ROAMING]
[LARGE_PREDATOR][DIFFICULTY:]]..tostring(difficulty)..[[]
[BIOME:SUBTERRANEAN_CHASM]
[UNDERGROUND_DEPTH:5:5]
[POPULATION_NUMBER:5:10]
[CLUSTER_NUMBER:1:5]
]])
        options.fallback_pref_str="horrifying features"
    end
    pick_random({
        function()
            tbl[#tbl+1]="[CASTE:FEMALE]"
            tbl[#tbl+1]="[FEMALE]"
            tbl[#tbl+1]="[CASTE:MALE]"
            tbl[#tbl+1]="[MALE]"
            tbl[#tbl+1]="[SELECT_CASTE:ALL]"
        end,
        function()
            tbl[#tbl+1]="[MALE]"
        end,
        function()
            tbl[#tbl+1]="[FEMALE]"
        end,
        function()
            tbl[#tbl+1]="[NO_GENDER]"
        end
    })()
    tbl=split_to_lines(tbl,[[[PHYS_ATT_RANGE:STRENGTH:450:1050:1150:1250:1350:1550:2250]
[PHYS_ATT_RANGE:TOUGHNESS:450:1050:1150:1250:1350:1550:2250]
[PHYS_ATT_RANGE:ENDURANCE:450:1050:1150:1250:1350:1550:2250]
[PHYS_ATT_RANGE:RECUPERATION:450:1050:1150:1250:1350:1550:2250]
[PHYS_ATT_RANGE:DISEASE_RESISTANCE:700:1300:1400:1500:1600:1800:2500]
[MENT_ATT_RANGE:ANALYTICAL_ABILITY:1250:1500:1750:2000:2500:3000:5000]
[MENT_ATT_RANGE:FOCUS:1250:1500:1750:2000:2500:3000:5000]
[MENT_ATT_RANGE:WILLPOWER:1250:1500:1750:2000:2500:3000:5000]
[MENT_ATT_RANGE:PATIENCE:0:333:666:1000:2333:3666:5000]
[MENT_ATT_RANGE:MEMORY:1250:1500:1750:2000:2500:3000:5000]
[MENT_ATT_RANGE:LINGUISTIC_ABILITY:450:1050:1150:1250:1350:1550:2250]
[MENT_ATT_RANGE:MUSICALITY:0:333:666:1000:2333:3666:5000]
[MENT_ATT_RANGE:SOCIAL_AWARENESS:700:1300:1400:1500:1600:1800:2500]
[PERSONALITY:ANXIETY_PROPENSITY:0:0:0]
[PERSONALITY:DEPRESSION_PROPENSITY:0:0:0]
[PERSONALITY:BASHFUL:0:0:0]
[PERSONALITY:STRESS_VULNERABILITY:0:0:0]
[PERSONALITY:FRIENDLINESS:0:0:0]
[PERSONALITY:ASSERTIVENESS:100:100:100]
[PERSONALITY:DISDAIN_ADVICE:100:100:100]
[PERSONALITY:CHEER_PROPENSITY:0:0:0]
[PERSONALITY:GRATITUDE:0:0:0]
[PERSONALITY:TRUST:0:0:0]
[PERSONALITY:ALTRUISM:0:0:0]
[PERSONALITY:SWAYED_BY_EMOTIONS:0:0:0]
[PERSONALITY:CRUELTY:100:100:100]
[PERSONALITY:PRIDE:100:100:100]
[PERSONALITY:GREED:100:100:100]
[NO_DRINK][NO_EAT][NO_SLEEP]
[BODY_APPEARANCE_MODIFIER:HEIGHT:90:95:98:100:102:105:110]
[BODY_APPEARANCE_MODIFIER:BROADNESS:90:95:98:100:102:105:110]
[MAGMA_VISION]
[EVIL]
[FANCIFUL]
[SUPERNATURAL]
]])
    add_regular_tokens(tbl,options)
    local available_sphere_cur={}
    local available_sphere={}
    options.spheres={}
    l2("Starting spheres")
    for k,v in pairs(world.spheres) do
        available_sphere_cur[k]=true
        available_sphere[k]=true
    end
    --ANY SPHERE COLLECTION + ONE EVIL + NO PURE GOOD/CIVIS/FLUFF STUFF
    available_sphere_cur.AGRICULTURE=false;
    available_sphere_cur.BALANCE=false;
    available_sphere_cur.CHARITY=false;
    available_sphere_cur.CONSOLATION=false;
    available_sphere_cur.COURAGE=false;
    available_sphere_cur.DUTY=false;
    available_sphere_cur.FAMILY=false;
    available_sphere_cur.FERTILITY=false;
    available_sphere_cur.FESTIVALS=false;
    available_sphere_cur.FORGIVENESS=false;
    available_sphere_cur.FREEDOM=false;
    available_sphere_cur.GENEROSITY=false;
    available_sphere_cur.HAPPINESS=false;
    available_sphere_cur.HEALING=false;
    available_sphere_cur.HOSPITALITY=false;
    available_sphere_cur.JUSTICE=false;
    available_sphere_cur.LABOR=false;
    available_sphere_cur.LOVE=false;
    available_sphere_cur.LOYALTY=false;
    available_sphere_cur.MARRIAGE=false;
    available_sphere_cur.MERCY=false;
    available_sphere_cur.OATHS=false;
    available_sphere_cur.PEACE=false;
    available_sphere_cur.PREGNANCY=false;
    available_sphere_cur.RAINBOWS=false;
    available_sphere_cur.REVELRY=false;
    available_sphere_cur.SACRIFICE=false;
    available_sphere_cur.TRADE=false;
    available_sphere_cur.TRAVELERS=false;
    available_sphere_cur.TRUTH=false;
    available_sphere_cur.VALOR=false;
    available_sphere_cur.WISDOM=false;
    local branch_number=trandom(2)+1
    while branch_number > 0 do
        local candidates={}
        -- not cleverness, just paranoia
        if branch_number<=1 then
            for k,v in ipairs(evil_spheres) do
                if available_sphere_cur[v] then candidates[#candidates+1]=v end
            end
        end
        if #candidates==0 then
            for k,v in pairs(available_sphere_cur) do
                if v then candidates[#candidates+1]=k end
            end
        end
        if #candidates then
            local new_s = pick_random(candidates)
            add_sphere_mpp(options.spheres,new_s,available_sphere,available_sphere_cur)
            while one_in(2) do
                candidates={}
                for k,v in pairs(world.spheres[new_s].friends) do
                    if available_sphere_cur[k] then
                        candidates[#candidates+1]=k
                    end
                end
                new_s = pick_random(candidates)
                if new_s then
                    add_sphere_mpp(options.spheres,new_s,available_sphere,available_sphere_cur)
                else
                    break
                end
            end
        end
        branch_number = branch_number-1
    end
    l2("Done with spheres")
    options.beast_only=demon_type=="humanoid_beast" or demon_type=="beast"
    if demon_type=="flying_spirit" then
        options.always_insubstantial=true
        options.always_make_uniform=true
    end
    populate_sphere_info(tbl,options)
    local rcp=get_random_creature_profile(options)
    local body_size = difficulty==6 and (400000+trandom(9)*10000 + trandom(11)*1000) or (10000000)
    add_body_size(tbl,math.max(body_size, rcp.min_size),options)
    tbl[#tbl+1]="[CREATURE_TILE:'&']"
    build_procgen_creature(rcp,tbl,options)
    tbl[#tbl+1]="[GO_TO_START]"
    options.flavor_adj = options.flavor_adj or {}
    options.potential_end_phrase = options.potential_end_phrase or {}
    local name_str=""
    if (#options.flavor_adj>0 or #options.potential_end_phrase>0) and one_in(3) then
        if trandom(#options.flavor_adj + #options.potential_end_phrase) > #options.flavor_adj then
            options.eadj=pick_random(options.potential_end_phrase)
            local name=pick_random_conditional(demon_names,"cond",options)
            name_str=name.name..options.eadj..":"..name.names..options.eadj..":"..name.name_adj..options.eadj
        else
            options.fadj=pick_random(options.flavor_adj)
            local name=pick_random_conditional(demon_names,"cond",options)
            name_str=options.fadj.." "..name.name..":"..options.fadj.." "..name.names..":"..name.name_adj
        end
    elseif not options.name_mat or #options.name_mat==0 then
        local name=pick_random_conditional(demon_names,"cond",options)
        name_str=rcp.name_string.." "..name.name..":"..rcp.name_string.." "..name.names..":"..rcp.name_string.." "..name.name_adj
    else
        local name=pick_random_conditional(demon_names,"cond",options)
        local nmm=pick_random(options.name_mat)
        if one_in(2) then
            name_str=name.name.." of "..nmm..":"..name.names.." of "..nmm..":"..name.name.." of "..nmm
        else
            name_str=nmm.." "..name.name..":"..nmm.." "..name.names..":"..nmm..":"..name.name_adj
        end
    end
    if name_str=="" then
        local name=pick_random_conditional(demon_names,"cond",options)
        name_str=rcp.name_string.." "..name.name..":"..rcp.name_string.." "..name.names..":"..rcp.name_string.." "..name.name_adj
    end
    if name_str=="" then
        name_str="glitch demon:glitch demons:glitch demon"
    end
    tbl[#tbl+1]="[NAME:"..name_str.."]"
    tbl[#tbl+1]="[CASTE_NAME:"..name_str.."]"
    return {raws=tbl,weight=1}
end

function night_creature_universals(lines,options)
    map_merge(options,{
    humanoid_only=true,
    do_not_make_uniform=true,
    always_nobreathe=true,
    no_random_attack_tweak=true,
    cannot_have_mandibles=true,
    cannot_have_antennae=true,
    end_phrase="Now you will know why you fear the night.",
    sickness_name="night sickness",
    never_uniform=true,
    is_evil=true
    })
    -- obviously these can just be adjusted after the fact
    -- e.g. in bogeymen `options.cannot_have_antennae=false`
    lines[#lines+1]="[ATTACK_TRIGGER:"..tostring(world.param.werebeast_attack_trigger_population)..":"..tostring(world.param.werebeast_attack_trigger_exported_wealth)..":"..world.param.werebeast_attack_trigger_created_wealth.."]"
    lines[#lines+1]="[NO_DRINK][NO_EAT][NO_SLEEP]"
    lines[#lines+1]="[BODY_APPEARANCE_MODIFIER:HEIGHT:90:95:98:100:102:105:110]"
    lines[#lines+1]="[BODY_APPEARANCE_MODIFIER:BROADNESS:90:95:98:100:102:105:110]"
    lines[#lines+1]="[LARGE_PREDATOR]"
    lines[#lines+1]="[EVIL]"
    lines[#lines+1]="[SUPERNATURAL]"
    lines[#lines+1]="[FANCIFUL]"
end

night_troll_names={
    {name="troll",names="trolls",name_adj="troll",cond=function(options) return true end},
    {name="man",names="men",name_adj="man",cond=function(options) return adj_exploitable_check(options.fadj) and options.is_male_version end},
    {name="woman",names="women",name_adj="woman",cond=function(options) return adj_exploitable_check(options.fadj) and not options.is_male_version end},
    {name="brute",names="brutes",name_adj="brutish",cond=function(options) return options.is_male_version and options.night_creature_strength_pref and adj_exploitable_check(options.fadj) end},
    {name="hag",names="hags",name_adj="hag",cond=function(options) return not options.is_male_version end},
    {name="crone",names="crones",name_adj="crone",cond=function(options) return not options.is_male_version end},
    {name="monster",names="monsters",name_adj="monster",cond=function(options) return true end},
    {name="creature",names="creatures",name_adj="creature",cond=function(options) return true end},
    {name="ogre",names="ogres",name_adj="ogre",cond=function(options) return options.night_creature_strength_pref and options.is_male_version end},
    {name="ogress",names="ogresses",name_adj="ogress",cond=function(options) return options.night_creature_strength_pref and not options.is_male_version end},
    {name="freak",names="freak",name_adj="freak",cond=function(options) return adj_exploitable_check(options.fadj) end},
    {name="horror",names="horrors",name_adj="horror",cond=function(options) return true end},
}

night_troll_flavor_adjs={
    "night",
    "dark",
    "shadow",
    "midnight",
    "dusk",
    "vile",
    "wicked",
    "twilight",
    "moon",
    "gloom",
    "bleak",
}

night_troll_flavor={
    {
        add="it mutters to itself as it moves aimlessly",
        flavor_adj={"muttering","grumbling","whispering","brooding"}
    },
    {
        add="it groans from time to time",
        flavor_adj={"groaning","moaning","whispering","brooding"}
    },
    {
        add="it howls into high winds",
        flavor_adj={"screaming","howling","baying","bellowing","shrieking","wailing"}
    },
}
night_troll_strength_flavor={
    {
        add="it shambles sluggishly",
        flavor_adj={}
    },
    {
        add="it stamps the ground and snorts",
        flavor_adj={}
    },
    {
        add="it has a bloated body",
        flavor_adj={"bloated"}
    },
    {
        add="it lumbers along steadily from place to place",
        flavor_adj={}
    },
}
night_troll_agile_flavor={
    {
        add="its joints are backward",
        flavor_adj={"backward"}
    },
    {
        add="it moves with uneven jerking motions",
        flavor_adj={}
    },
    {
        add="its limbs jut out at asymmetric angles",
        flavor_adj={"crooked","twisted"}
    },
    {
        add="it lopes quickly along the ground",
        flavor_adj={}
    },
    {
        add="it strides in silence with purpose",
        flavor_adj={}
    },
}

night_troll_smells={
    "bug innards",
    "cooked flesh",
    "death"
}

creatures.night_creature.troll.default=function(tok)
    local lines={}
    local options={
        spheres={
            NIGHT=true,
            DEATH=true
        },
        fallback_pref_str="macabre ways",
        token=tok
    }
    options.is_male_version=one_in(2)
    if one_in(2) then
        options.night_creature_strength_pref=true
    else
        options.night_creature_agile_pref=true
    end
    night_creature_universals(lines,options)
    -- partially I started feeling split_to_lines is ugly,
    -- partially I want to show there's no one right way to do it
    -- hopefully my caprice isn't too aggravating
    lines[#lines+1]="[NIGHT_CREATURE_HUNTER]"
    lines[#lines+1]="[BIOME:ANY_FOREST]"
    lines[#lines+1]="[BIOME:ANY_SHRUBLAND]"
    lines[#lines+1]="[BIOME:ANY_SAVANNA]"
    lines[#lines+1]="[BIOME:ANY_GRASSLAND]"
    lines[#lines+1]="[BIOME:ANY_WETLAND]"
    lines[#lines+1]="[BIOME:TUNDRA]"
    if options.is_male_version then
        lines[#lines+1]="[CASTE:MALE]"
        lines[#lines+1]="[MALE]"
        lines[#lines+1]="[SPOUSE_CONVERTER]"
        lines[#lines+1]="[ORIENTATION:MALE:1:0:0]"
        lines[#lines+1]="[ORIENTATION:FEMALE:0:0:1]"
    lines[#lines+1]="[CASTE:FEMALE]"
        lines[#lines+1]="[FEMALE]"
        lines[#lines+1]="[CONVERTED_SPOUSE]"
    else
        lines[#lines+1]="[CASTE:FEMALE]"
        lines[#lines+1]="[FEMALE]"
        lines[#lines+1]="[SPOUSE_CONVERTER]"
        lines[#lines+1]="[ORIENTATION:MALE:0:0:1]"
        lines[#lines+1]="[ORIENTATION:FEMALE:1:0:0]"
    lines[#lines+1]="[CASTE:MALE]"
        lines[#lines+1]="[MALE]"
        lines[#lines+1]="[CONVERTED_SPOUSE]"
    end
    lines[#lines+1]="[SELECT_CASTE:ALL]"

    lines[#lines+1]="[CAN_LEARN]"
    if one_in(2) then lines[#lines+1]="[SLOW_LEARNER]" end
    lines[#lines+1]="[CAN_SPEAK]"
    lines[#lines+1]="[SENSE_CREATURE_CLASS:GENERAL_POISON:15:4:0:1]"
    if options.night_creature_strength_pref then
        lines[#lines+1]="[PHYS_ATT_RANGE:STRENGTH:1000:1250:1500:2000:2250:2500:3000]"
        lines[#lines+1]="[PHYS_ATT_RANGE:AGILITY:450:550:700:750:800:850:900]"
        lines[#lines+1]="[PHYS_ATT_RANGE:TOUGHNESS:850:900:950:1000:1050:1100:1150]"
        lines[#lines+1]="[PHYS_ATT_RANGE:ENDURANCE:850:900:950:1000:1050:1100:1150]"
        options.special_walk_speed=1000
    elseif options.night_creature_agile_pref then
        lines[#lines+1]="[PHYS_ATT_RANGE:STRENGTH:450:550:700:750:800:850:900]"
        lines[#lines+1]="[PHYS_ATT_RANGE:AGILITY:1000:1250:1500:2000:2250:2500:3000]"
        lines[#lines+1]="[PHYS_ATT_RANGE:TOUGHNESS:850:900:950:1000:1050:1100:1150]"
        lines[#lines+1]="[PHYS_ATT_RANGE:ENDURANCE:850:900:950:1000:1050:1100:1150]"
        options.special_walk_speed=800;
    elseif options.night_creature_strength_agile_pref then
        lines[#lines+1]="[PHYS_ATT_RANGE:STRENGTH:1000:1150:1250:1500:2000:2250:2500]"
        lines[#lines+1]="[PHYS_ATT_RANGE:AGILITY:1000:1150:1250:1500:2000:2250:2500]"
        lines[#lines+1]="[PHYS_ATT_RANGE:TOUGHNESS:850:900:950:1000:1050:1100:1150]"
        lines[#lines+1]="[PHYS_ATT_RANGE:ENDURANCE:850:900:950:1000:1050:1100:1150]"
        options.special_walk_speed=850;
    end
    lines[#lines+1]="[PHYS_ATT_RANGE:RECUPERATION:450:1050:1150:1250:1350:1550:2250]"
    lines[#lines+1]="[PHYS_ATT_RANGE:DISEASE_RESISTANCE:700:1300:1400:1500:1600:1800:2500]"
    lines[#lines+1]="[MENT_ATT_RANGE:ANALYTICAL_ABILITY:1250:1500:1750:2000:2500:3000:5000]"
    lines[#lines+1]="[MENT_ATT_RANGE:FOCUS:1250:1500:1750:2000:2500:3000:5000]"
    lines[#lines+1]="[MENT_ATT_RANGE:WILLPOWER:1250:1500:1750:2000:2500:3000:5000]"
    lines[#lines+1]="[MENT_ATT_RANGE:PATIENCE:0:333:666:1000:2333:3666:5000]"
    lines[#lines+1]="[MENT_ATT_RANGE:MEMORY:1250:1500:1750:2000:2500:3000:5000]"
    lines[#lines+1]="[MENT_ATT_RANGE:LINGUISTIC_ABILITY:450:1050:1150:1250:1350:1550:2250]"
    lines[#lines+1]="[MENT_ATT_RANGE:MUSICALITY:0:333:666:1000:2333:3666:5000]"
    lines[#lines+1]="[MENT_ATT_RANGE:SOCIAL_AWARENESS:700:1300:1400:1500:1600:1800:2500]"
    --[[
MENTAL_ATTRIBUTE_CREATIVITY,
MENTAL_ATTRIBUTE_INTUITION,
MENTAL_ATTRIBUTE_SPATIAL_SENSE,
MENTAL_ATTRIBUTE_KINESTHETIC_SENSE,
MENTAL_ATTRIBUTE_EMPATHY,
    ]]
    --lines[#lines+1]="[PERSONALITY:ANXIETY_PROPENSITY:0:0:0]"
    --lines[#lines+1]="[PERSONALITY:DEPRESSION_PROPENSITY:0:0:0]"
    lines[#lines+1]="[PERSONALITY:BASHFUL:0:0:0]"
    lines[#lines+1]="[PERSONALITY:STRESS_VULNERABILITY:0:0:0]"
    lines[#lines+1]="[PERSONALITY:FRIENDLINESS:0:0:0]"
    --lines[#lines+1]="[PERSONALITY:ASSERTIVENESS:100:100:100]"
    lines[#lines+1]="[PERSONALITY:DISDAIN_ADVICE:100:100:100]"
    lines[#lines+1]="[PERSONALITY:CHEER_PROPENSITY:0:0:0]"
    lines[#lines+1]="[PERSONALITY:GRATITUDE:0:0:0]"
    lines[#lines+1]="[PERSONALITY:TRUST:0:0:0]"
    lines[#lines+1]="[PERSONALITY:ALTRUISM:0:0:0]"
    --lines[#lines+1]="[PERSONALITY:SWAYED_BY_EMOTIONS:0:0:0]"
    lines[#lines+1]="[PERSONALITY:CRUELTY:100:100:100]"
    --lines[#lines+1]="[PERSONALITY:PRIDE:100:100:100]"

    add_regular_tokens(lines,options)
    populate_sphere_info(lines,options)
    local rcp={
        name_string="humanoid",
		tile='H',
		body_base="HUMANOID",
		c_class="AMPHIBIAN", -- FOR SKIN/ORGANS AND NO HAIR/FEATHERS AT FIRST
		min_size=1,
        cannot_have_shell=true
    }
    lines[#lines+1]="[NATURAL_SKILL:WRESTLING:6]"
    lines[#lines+1]="[NATURAL_SKILL:BITE:6]"
    lines[#lines+1]="[NATURAL_SKILL:GRASP_STRIKE:6]"
    lines[#lines+1]="[NATURAL_SKILL:STANCE_STRIKE:6]"
    lines[#lines+1]="[NATURAL_SKILL:MELEE_COMBAT:6]"
    lines[#lines+1]="[NATURAL_SKILL:DODGING:6]"
    lines[#lines+1]="[NATURAL_SKILL:SITUATIONAL_AWARENESS:6]"

    lines[#lines+1]="[DIFFICULTY:3]"
    lines[#lines+1]="[LAIR:SIMPLE_MOUND:50]"
    lines[#lines+1]="[LAIR:SIMPLE_BURROW:50]"
    lines[#lines+1]="[LAIR_CHARACTERISTIC:HAS_DOORS:100]"
    lines[#lines+1]="[HABIT_NUM:TEST_ALL]"
    lines[#lines+1]="[HABIT:GRIND_BONE_MEAL:50]"
    lines[#lines+1]="[HABIT:COOK_BLOOD:50]"
    lines[#lines+1]="[HABIT:GRIND_VERMIN:50]"
    lines[#lines+1]="[HABIT:COOK_VERMIN:50]"
    lines[#lines+1]="[HABIT:COOK_PEOPLE:50]"
    lines[#lines+1]="[HABIT:COLLECT_TROPHIES:50]"
    lines[#lines+1]="[ODOR_STRING:"..pick_random(night_troll_smells).."]"
    lines[#lines+1]="[ODOR_LEVEL:90]"
    local body_size=70000+trandom(8)*10000+trandom(11)*1000
    options.body_size=body_size
    lines[#lines+1]="[SELECT_CASTE:"..(options.is_male_version and "MALE" or "FEMALE").."]"
    lines[#lines+1]="[BODY_SIZE:0:0:"..tostring(math.floor(body_size/20)).."]"
    lines[#lines+1]="[BODY_SIZE:2:0:"..tostring(math.floor(body_size/4)).."]"
    lines[#lines+1]="[BODY_SIZE:12:0:"..tostring(math.floor(body_size)).."]"
    body_size_properties(lines,body_size)
    local spouse_size=math.floor(body_size*(trandom(51)+50)/100)
    lines[#lines+1]="[SELECT_CASTE:"..(options.is_male_version and "FEMALE" or "MALE").."]"
    add_body_size(lines,spouse_size)
    lines[#lines+1]="[SELECT_CASTE:ALL]"
    lines[#lines+1]="[BABY:1]"
    lines[#lines+1]="[CHILD:18]"
    lines[#lines+1]="[CREATURE_TILE:165]" --Ñ
    options.custom_desc_func=function(options)
        local add_tbl={}
        options.flavor_adj = options.flavor_adj or {}
        if one_in(4) then
            add_tbl=pick_random(night_troll_flavor)
        elseif options.night_creature_strength_pref then
            add_tbl=pick_random(night_troll_strength_flavor)
            options.flavor_adj[#options.flavor_adj+1]="lumbering"
            options.flavor_adj[#options.flavor_adj+1]="hulking"
        elseif options.night_creature_agile_pref then
            add_tbl=pick_random(night_troll_agile_flavor)
            options.flavor_adj[#options.flavor_adj+1]="narrow"
            options.flavor_adj[#options.flavor_adj+1]="starved"
            options.flavor_adj[#options.flavor_adj+1]="emaciated"
        end
        table_merge(options.flavor_adj,add_tbl.flavor_adj)
        return add_tbl.add
    end
    options.flavor_adj=options.flavor_adj or {}
    build_procgen_creature(rcp,lines,options)
    table_merge(options.flavor_adj,night_troll_flavor_adjs)
    night_troll_end_phrases=night_troll_end_phrases or {
        " of the night",
        " of evil",
        " of twilight",
        " of shadow",
    }
    options.potential_end_phrase = options.potential_end_phrase or {}
    table_merge(options.potential_end_phrase,night_troll_end_phrases)
    local name_str=""
    local used_ending=false
    local name={}
    if trandom(#options.flavor_adj + #options.potential_end_phrase) >= #options.flavor_adj then
        options.eadj=pick_random(options.potential_end_phrase)
        name=pick_random_conditional(night_troll_names,"cond",options)
        name_str=name.name..options.eadj..":"..name.names..options.eadj..":"..name.name_adj..options.eadj
        used_ending=true
    else
        options.fadj=pick_random(options.flavor_adj)
        name=pick_random_conditional(night_troll_names,"cond",options)
        name_str=options.fadj.." "..name.name..":"..options.fadj.." "..name.names..":"..options.fadj.." "..name.name_adj
    end
    night_troll_wife_names=night_troll_wife_names or {
        {"spouse","spouses"},
        {"mate","mates"},
        {"consort","consorts"},
        {"wife","wives"},
        {"bride","brides"},
    }
    night_troll_husband_names=night_troll_husband_names or {
        {"spouse","spouses"},
        {"mate","mates"},
        {"consort","consorts"},
        {"husband","husbands"},
        {"bridegroom","bridegrooms"},
        {"groom","grooms"}
    }
    local sn,sns="",""
    if options.is_male_version then
        sn,sns=table.unpack(pick_random(night_troll_wife_names))
        lines[#lines+1]="[SELECT_CASTE:MALE]"
    else
        sn,sns=table.unpack(pick_random(night_troll_husband_names))
        lines[#lines+1]="[SELECT_CASTE:FEMALE]"
    end
    local cstr=""
    if used_ending then
        cstr=name.name.." "..sn..options.eadj..":"..name.name.." "..sns..options.eadj..":"..name.name_adj.." "..sn..options.eadj
    elseif one_in(2) then
        cstr=options.fadj.." "..name.name.." "..sn..":"..options.fadj.." "..name.name.." "..sns..":"..options.fadj.." "..name.name.." "..sn
    else
        cstr=sn.." of the "..options.fadj.." "..name.name..":"..sns.." of the "..options.fadj.." "..name.name..":"..sn.." of the "..options.fadj.." "..name.name_adj
    end
    lines[#lines+1]="[CASTE_NAME:"..name_str.."]"
    if options.is_male_version then lines[#lines+1]="[SELECT_CASTE:FEMALE]"
    else lines[#lines+1] = "[SELECT_CASTE:MALE]" end
    lines[#lines+1]="[CASTE_NAME:"..cstr.."]"
    lines[#lines+1]="[GO_TO_START]"
    lines[#lines+1]="[NAME:"..name_str.."]"
    return {raws=lines,weight=1}
end

creatures.night_creature.bogeyman.default=function(tok)
    local lines={}
    local options={
        can_bogey_polymorph=true,
        spheres={
            NIGHT=true,
            NIGHTMARES=true,
            MISERY=true
        },
        forced_color={
            f=0,
            b=0,
            br=1
        },
        no_general_poison=true,
        blood_color=function(cl)
            -- DARKER MAGENTA COLORS
            return cl.h>=260 and cl.h <= 340 and cl.v <= 0.5 and cl.v >= 0.1
        end,
        fallback_pref_str="terror-inspiring antics",
        token=tok
    }
    night_creature_universals(lines,options)
    options.cannot_have_antennae=false
    if one_in(10) then options.glowing_eyes=true end
    lines[#lines+1]="[NIGHT_CREATURE_BOGEYMAN]"

    lines[#lines+1]="[NATURAL_SKILL:WRESTLING:6]"
    lines[#lines+1]="[NATURAL_SKILL:BITE:6]"
    lines[#lines+1]="[NATURAL_SKILL:MELEE_COMBAT:6]"
    lines[#lines+1]="[NATURAL_SKILL:GRASP_STRIKE:6]"
    lines[#lines+1]="[NATURAL_SKILL:STANCE_STRIKE:6]"
    lines[#lines+1]="[NATURAL_SKILL:DODGING:6]"
    lines[#lines+1]="[NATURAL_SKILL:SITUATIONAL_AWARENESS:6]"

    lines[#lines+1]="[CAN_LEARN][CAN_SPEAK]"
    options.can_learn=true;
    lines[#lines+1]="[NO_GENDER]"
    lines[#lines+1]="[CLUSTER_NUMBER:4:6]"
    --[[******************************* BOGEY
        --atts
    lines[#lines+1]="[PHYS_ATT_RANGE:STRENGTH:450:1050:1150:1250:1350:1550:2250]"
    lines[#lines+1]="[PHYS_ATT_RANGE:TOUGHNESS:450:1050:1150:1250:1350:1550:2250]"
    lines[#lines+1]="[PHYS_ATT_RANGE:ENDURANCE:450:1050:1150:1250:1350:1550:2250]"
    lines[#lines+1]="[PHYS_ATT_RANGE:RECUPERATION:450:1050:1150:1250:1350:1550:2250]"
    lines[#lines+1]="[PHYS_ATT_RANGE:DISEASE_RESISTANCE:700:1300:1400:1500:1600:1800:2500]"
    lines[#lines+1]="[MENT_ATT_RANGE:ANALYTICAL_ABILITY:1250:1500:1750:2000:2500:3000:5000]"
    lines[#lines+1]="[MENT_ATT_RANGE:FOCUS:1250:1500:1750:2000:2500:3000:5000]"
    lines[#lines+1]="[MENT_ATT_RANGE:WILLPOWER:1250:1500:1750:2000:2500:3000:5000]"
    lines[#lines+1]="[MENT_ATT_RANGE:PATIENCE:0:333:666:1000:2333:3666:5000]"
    lines[#lines+1]="[MENT_ATT_RANGE:MEMORY:1250:1500:1750:2000:2500:3000:5000]"
    lines[#lines+1]="[MENT_ATT_RANGE:LINGUISTIC_ABILITY:450:1050:1150:1250:1350:1550:2250]"
    lines[#lines+1]="[MENT_ATT_RANGE:MUSICALITY:0:333:666:1000:2333:3666:5000]"
    lines[#lines+1]="[MENT_ATT_RANGE:SOCIAL_AWARENESS:700:1300:1400:1500:1600:1800:2500]"
MENTAL_ATTRIBUTE_CREATIVITY,
MENTAL_ATTRIBUTE_INTUITION,
MENTAL_ATTRIBUTE_SPATIAL_SENSE,
MENTAL_ATTRIBUTE_KINESTHETIC_SENSE,
MENTAL_ATTRIBUTE_EMPATHY,
    ]]
    lines[#lines+1]="[PERSONALITY:ANXIETY_PROPENSITY:0:0:0]"
    lines[#lines+1]="[PERSONALITY:DEPRESSION_PROPENSITY:0:0:0]"
    lines[#lines+1]="[PERSONALITY:BASHFUL:0:0:0]"
    lines[#lines+1]="[PERSONALITY:STRESS_VULNERABILITY:0:0:0]"
    lines[#lines+1]="[PERSONALITY:FRIENDLINESS:0:0:0]"
    lines[#lines+1]="[PERSONALITY:ASSERTIVENESS:100:100:100]"
    lines[#lines+1]="[PERSONALITY:DISDAIN_ADVICE:100:100:100]"
    lines[#lines+1]="[PERSONALITY:CHEER_PROPENSITY:0:0:0]"
    lines[#lines+1]="[PERSONALITY:GRATITUDE:0:0:0]"
    lines[#lines+1]="[PERSONALITY:TRUST:0:0:0]"
    lines[#lines+1]="[PERSONALITY:ALTRUISM:0:0:0]"
    lines[#lines+1]="[PERSONALITY:SWAYED_BY_EMOTIONS:0:0:0]"
    lines[#lines+1]="[PERSONALITY:CRUELTY:100:100:100]"
    --lines[#lines+1]="[PERSONALITY:PRIDE:100:100:100]"
    lines[#lines+1]="[PERSONALITY:HUMOR:100:100:100]"
    add_regular_tokens(lines,options)
    populate_sphere_info(lines,options)
    local rcp={
        name_string="humanoid",
		tile='H',
		body_base="HUMANOID",
		c_class="AMPHIBIAN", -- FOR SKIN/ORGANS AND NO HAIR/FEATHERS AT FIRST
		min_size=1,
        cannot_have_shell=true
    }
    add_body_size(lines,10000+trandom(11)*1000,options)
    lines[#lines+1]="[CREATURE_TILE:164]" --ñ
    options.custom_desc_func=function(options)
        return "it hurls vicious insults constantly"
    end
    build_procgen_creature(rcp,lines,options)
    lines[#lines+1]="[GO_TO_START]"
    local name_str="bogeyman:bogeymen:bogeyman]"
    lines[#lines+1]="[NAME:"..name_str
    lines[#lines+1]="[CASTE_NAME:"..name_str
    return {raws=lines,weight=1}
end

creatures.night_creature.nightmare.default=function(tok)
    local lines={}
    local options={
        spheres={
            NIGHT=true,
            NIGHTMARES=true,
            MISERY=true
        },
        forced_color={
            f=0,
            b=0,
            br=1
        },
        no_general_poison=true,
        blood_color=function(cl)
            -- DARKER MAGENTA COLORS
            return cl.h>=260 and cl.h <= 340 and cl.v <= 0.5 and cl.v >= 0.1
        end,
        fallback_pref_str="unfathomably horrifying nature",
        token=tok
    }
    night_creature_universals(lines,options)
    options.humanoid_only=false
    options.cannot_have_antennae=false
    if one_in(10) then options.glowing_eyes=true end
    lines[#lines+1]="[NIGHT_CREATURE_NIGHTMARE]"

    lines[#lines+1]="[NATURAL_SKILL:WRESTLING:6]"
    lines[#lines+1]="[NATURAL_SKILL:BITE:6]"
    lines[#lines+1]="[NATURAL_SKILL:MELEE_COMBAT:6]"
    lines[#lines+1]="[NATURAL_SKILL:GRASP_STRIKE:6]"
    lines[#lines+1]="[NATURAL_SKILL:STANCE_STRIKE:6]"
    lines[#lines+1]="[NATURAL_SKILL:DODGING:6]"
    lines[#lines+1]="[NATURAL_SKILL:SITUATIONAL_AWARENESS:6]"

    lines[#lines+1]="[NO_GENDER]"
    lines[#lines+1]="[CLUSTER_NUMBER:1:1]"
    --[[******************************* BOGEY
        --atts
    lines[#lines+1]="[PHYS_ATT_RANGE:STRENGTH:450:1050:1150:1250:1350:1550:2250]"
    lines[#lines+1]="[PHYS_ATT_RANGE:TOUGHNESS:450:1050:1150:1250:1350:1550:2250]"
    lines[#lines+1]="[PHYS_ATT_RANGE:ENDURANCE:450:1050:1150:1250:1350:1550:2250]"
    lines[#lines+1]="[PHYS_ATT_RANGE:RECUPERATION:450:1050:1150:1250:1350:1550:2250]"
    lines[#lines+1]="[PHYS_ATT_RANGE:DISEASE_RESISTANCE:700:1300:1400:1500:1600:1800:2500]"
    lines[#lines+1]="[MENT_ATT_RANGE:ANALYTICAL_ABILITY:1250:1500:1750:2000:2500:3000:5000]"
    lines[#lines+1]="[MENT_ATT_RANGE:FOCUS:1250:1500:1750:2000:2500:3000:5000]"
    lines[#lines+1]="[MENT_ATT_RANGE:WILLPOWER:1250:1500:1750:2000:2500:3000:5000]"
    lines[#lines+1]="[MENT_ATT_RANGE:PATIENCE:0:333:666:1000:2333:3666:5000]"
    lines[#lines+1]="[MENT_ATT_RANGE:MEMORY:1250:1500:1750:2000:2500:3000:5000]"
    lines[#lines+1]="[MENT_ATT_RANGE:LINGUISTIC_ABILITY:450:1050:1150:1250:1350:1550:2250]"
    lines[#lines+1]="[MENT_ATT_RANGE:MUSICALITY:0:333:666:1000:2333:3666:5000]"
    lines[#lines+1]="[MENT_ATT_RANGE:SOCIAL_AWARENESS:700:1300:1400:1500:1600:1800:2500]"
MENTAL_ATTRIBUTE_CREATIVITY,
MENTAL_ATTRIBUTE_INTUITION,
MENTAL_ATTRIBUTE_SPATIAL_SENSE,
MENTAL_ATTRIBUTE_KINESTHETIC_SENSE,
MENTAL_ATTRIBUTE_EMPATHY,
    ]]
    lines[#lines+1]="[PERSONALITY:ANXIETY_PROPENSITY:0:0:0]"
    lines[#lines+1]="[PERSONALITY:DEPRESSION_PROPENSITY:0:0:0]"
    lines[#lines+1]="[PERSONALITY:BASHFUL:0:0:0]"
    lines[#lines+1]="[PERSONALITY:STRESS_VULNERABILITY:0:0:0]"
    lines[#lines+1]="[PERSONALITY:FRIENDLINESS:0:0:0]"
    lines[#lines+1]="[PERSONALITY:ASSERTIVENESS:100:100:100]"
    lines[#lines+1]="[PERSONALITY:DISDAIN_ADVICE:100:100:100]"
    lines[#lines+1]="[PERSONALITY:CHEER_PROPENSITY:0:0:0]"
    lines[#lines+1]="[PERSONALITY:GRATITUDE:0:0:0]"
    lines[#lines+1]="[PERSONALITY:TRUST:0:0:0]"
    lines[#lines+1]="[PERSONALITY:ALTRUISM:0:0:0]"
    lines[#lines+1]="[PERSONALITY:SWAYED_BY_EMOTIONS:0:0:0]"
    lines[#lines+1]="[PERSONALITY:CRUELTY:100:100:100]"
    --lines[#lines+1]="[PERSONALITY:PRIDE:100:100:100]"
    lines[#lines+1]="[PERSONALITY:HUMOR:100:100:100]"
    add_regular_tokens(lines,options)
    populate_sphere_info(lines,options)
    local rcp=get_random_creature_profile(options)
    add_body_size(lines,math.max(rcp.min_size,100000+trandom(11)*100000),options)
    lines[#lines+1]="[CREATURE_TILE:165]" --Ñ
    options.custom_desc_func=function(options)
        return "with singular purpose it seeks to destroy the living"
    end
    build_procgen_creature(rcp,lines,options)
    lines[#lines+1]="[GO_TO_START]"
    local name_str="nightmare:nightmares:nightmare]"
    lines[#lines+1]="[NAME:"..name_str
    lines[#lines+1]="[CASTE_NAME:"..name_str
    return {raws=lines,weight=1}
end

werebeast_origin_interactions={}

-- this takes options, but remember that these should be pure functions,
-- meaning that they have no side-effects. Don't put anything into options
-- in these functions! Only read from it. If you want to add to options
-- based on these functions, put it into a subordinate table to
-- the return table, it'll be incorporated in the generated temp function
-- (the default does this, so it's a fine example)
werebeast_origin_interactions.default=function(tok,name,options)
    -- just in case you want your werebeast to never generate like this
    if options.no_default_werebeast_curse then return {weight=0,interaction={}} end
    local lines={}
    -- ACTUAL CHANGE FROM 50.13 AND EARLIER: PREVIOUSLY, THESE WOULD BE "DEITY_CURSE_WEREBEAST_1" ETC
    -- WITH THIS THEY'RE "DEITY_CURSE_WEREBEAST_dragonfly" etc. (incl. the lowercase)
    -- THIS IS FINE BECAUSE WE ACTUALLY FILTER OUT RCPs NOW, WHICH IS ANOTHER CHANGE FROM V50
    local interaction_token="DEITY_CURSE_WEREBEAST_"..name
    lines[#lines+1]="[INTERACTION:"..interaction_token.."]"
    add_generated_info(lines)
    lines[#lines+1]="[I_SOURCE:DEITY]"
    lines[#lines+1]="[IS_USAGE_HINT:MAJOR_CURSE]"
    lines[#lines+1]="[IS_HIST_STRING_1: cursed ]"
    lines[#lines+1]="[IS_HIST_STRING_2: to assume the form of a "..name.."-like monster every full moon"
    lines[#lines+1]="[IS_TRIGGER_STRING_SECOND:have]"
    lines[#lines+1]="[IS_TRIGGER_STRING_THIRD:has]"
    lines[#lines+1]="[IS_TRIGGER_STRING:been cursed to assume the form of a "..name.."-like monster every fool moon!"
    lines[#lines+1]="[I_TARGET:A:CREATURE]"
    lines[#lines+1]="[IT_LOCATION:CONTEXT_CREATURE]"
    lines[#lines+1]="[IT_REQUIRES:CAN_LEARN]"
    lines[#lines+1]="[IT_REQUIRES:HAS_BLOOD]"
    lines[#lines+1]="[IT_FORBIDDEN:NOT_LIVING]"
    lines[#lines+1]="[IT_FORBIDDEN:SUPERNATURAL]"
    lines[#lines+1]="[IT_CANNOT_HAVE_SYNDROME_CLASS:WERECURSE]"
    lines[#lines+1]="[IT_CANNOT_HAVE_SYNDROME_CLASS:VAMPCURSE]"
    lines[#lines+1]="[IT_CANNOT_HAVE_SYNDROME_CLASS:DISTURBANCE_CURSE]"
    lines[#lines+1]="[IT_CANNOT_HAVE_SYNDROME_CLASS:RAISED_UNDEAD]"
    lines[#lines+1]="[IT_CANNOT_HAVE_SYNDROME_CLASS:RAISED_GHOST]"
    lines[#lines+1]="[IT_CANNOT_HAVE_SYNDROME_CLASS:GHOUL]"
lines[#lines+1]="[I_EFFECT:ADD_SYNDROME]"
    lines[#lines+1]="[IE_TARGET:A]"
    lines[#lines+1]="[IE_IMMEDIATE]"
    lines[#lines+1]="[IE_ARENA_NAME:Werebeast]"
    lines[#lines+1]="[SYNDROME]"
        lines[#lines+1]="[SYN_CLASS:WERECURSE]"
        lines[#lines+1]="[SYN_CONCENTRATION_ADDED:1000:0]"--just in case
        lines[#lines+1]="[CE_BODY_TRANSFORMATION:START:0:ABRUPT]"
        lines[#lines+1]="[CE:CREATURE:"..tok..":DEFAULT]"
        -- moon phase variety? not for default, surely
        -- (consider future cosmology stuff, too; should world push moon phase info into a lua table?)
        lines[#lines+1]="[CE:PERIODIC:MOON_PHASE:27:0]"
        lines[#lines+1]="[CE_ADD_TAG:NO_AGING:START:0:ABRUPT]"
    lines[#lines+1]="[INTERACTION:"..interaction_token.."_BITE]"
    add_generated_info(lines)
    lines[#lines+1]="[I_SOURCE:ATTACK]"
    lines[#lines+1]="[IS_HIST_STRING_1: bit ]"
    lines[#lines+1]="[IS_HIST_STRING_2: passing on the "..name.." monster curse"
    lines[#lines+1]="[I_TARGET:A:CREATURE]"
    lines[#lines+1]="[IT_LOCATION:CONTEXT_CREATURE]"
    lines[#lines+1]="[IT_REQUIRES:CAN_LEARN]"
    lines[#lines+1]="[IT_REQUIRES:HAS_BLOOD]"
    lines[#lines+1]="[IT_FORBIDDEN:NOT_LIVING]"
    lines[#lines+1]="[IT_FORBIDDEN:SUPERNATURAL]"
    lines[#lines+1]="[IT_CANNOT_HAVE_SYNDROME_CLASS:WERECURSE]"
    lines[#lines+1]="[IT_CANNOT_HAVE_SYNDROME_CLASS:VAMPCURSE]"
    lines[#lines+1]="[IT_CANNOT_HAVE_SYNDROME_CLASS:DISTURBANCE_CURSE]"
    lines[#lines+1]="[IT_CANNOT_HAVE_SYNDROME_CLASS:RAISED_UNDEAD]"
    lines[#lines+1]="[IT_CANNOT_HAVE_SYNDROME_CLASS:RAISED_GHOST]"
    lines[#lines+1]="[IT_CANNOT_HAVE_SYNDROME_CLASS:GHOUL]"
lines[#lines+1]="[I_EFFECT:ADD_SYNDROME]"
    lines[#lines+1]="[IE_TARGET:A]"
    lines[#lines+1]="[IE_IMMEDIATE]"
    lines[#lines+1]="[SYNDROME]"
        lines[#lines+1]="[SYN_CLASS:WERECURSE]"
        lines[#lines+1]="[SYN_CONCENTRATION_ADDED:1000:0]"--just in case
        lines[#lines+1]="[CE_BODY_TRANSFORMATION:START:16800:ABRUPT]" -- an easy-werebeasts mod could remove the delay... or would that make it harder? fascinating stuff
        lines[#lines+1]="[CE:CREATURE:"..tok..":DEFAULT]"
        lines[#lines+1]="[CE:PERIODIC:MOON_PHASE:27:0]"
        lines[#lines+1]="[CE_ADD_TAG:NO_AGING:START:0:ABRUPT]"
    return {raws=lines,weight=1,options={bite_interaction=interaction_token.."_BITE"}}
end

creatures.night_creature.werebeast.default=function(tok)
    local lines={}
    local options={
        spheres={
            CHAOS=true,
            ANIMALS=true,
            NIGHT=true,
            MOON=true
        },
        always_glowing_eyes=true,
        use_werebeast_pcg=true,
        animal_coloring_allowed=true,
        no_tweak=true,
        material_weakness=true,
        beast_only=true,
        prioritize_bite=true,
        token=tok
    }
    options.night_creature_agile_pref=true
    night_creature_universals(lines,options)
    lines[#lines+1]="[NIGHT_CREATURE_HUNTER]"
    lines[#lines+1]="[CAN_LEARN]"
    lines[#lines+1]="[CAN_SPEAK]"
    lines[#lines+1]="[NO_GENDER]"
    lines[#lines+1]="[BONECARN]"
    lines[#lines+1]="[CRAZED]"
    if options.night_creature_strength_pref then
        lines[#lines+1]="[PHYS_ATT_RANGE:STRENGTH:1000:1250:1500:2000:2250:2500:3000]"
        lines[#lines+1]="[PHYS_ATT_RANGE:AGILITY:450:550:700:750:800:850:900]"
        lines[#lines+1]="[PHYS_ATT_RANGE:TOUGHNESS:850:900:950:1000:1050:1100:1150]"
        lines[#lines+1]="[PHYS_ATT_RANGE:ENDURANCE:850:900:950:1000:1050:1100:1150]"
        options.special_walk_speed=1000
    elseif options.night_creature_agile_pref then
        lines[#lines+1]="[PHYS_ATT_RANGE:STRENGTH:450:550:700:750:800:850:900]"
        lines[#lines+1]="[PHYS_ATT_RANGE:AGILITY:1000:1250:1500:2000:2250:2500:3000]"
        lines[#lines+1]="[PHYS_ATT_RANGE:TOUGHNESS:850:900:950:1000:1050:1100:1150]"
        lines[#lines+1]="[PHYS_ATT_RANGE:ENDURANCE:850:900:950:1000:1050:1100:1150]"
        options.special_walk_speed=800;
    elseif options.night_creature_strength_agile_pref then
        lines[#lines+1]="[PHYS_ATT_RANGE:STRENGTH:1000:1150:1250:1500:2000:2250:2500]"
        lines[#lines+1]="[PHYS_ATT_RANGE:AGILITY:1000:1150:1250:1500:2000:2250:2500]"
        lines[#lines+1]="[PHYS_ATT_RANGE:TOUGHNESS:850:900:950:1000:1050:1100:1150]"
        lines[#lines+1]="[PHYS_ATT_RANGE:ENDURANCE:850:900:950:1000:1050:1100:1150]"
        options.special_walk_speed=850;
    end
    lines[#lines+1]="[PHYS_ATT_RANGE:RECUPERATION:450:1050:1150:1250:1350:1550:2250]"
    lines[#lines+1]="[PHYS_ATT_RANGE:DISEASE_RESISTANCE:700:1300:1400:1500:1600:1800:2500]"
    lines[#lines+1]="[MENT_ATT_RANGE:ANALYTICAL_ABILITY:1250:1500:1750:2000:2500:3000:5000]"
    lines[#lines+1]="[MENT_ATT_RANGE:FOCUS:1250:1500:1750:2000:2500:3000:5000]"
    lines[#lines+1]="[MENT_ATT_RANGE:WILLPOWER:1250:1500:1750:2000:2500:3000:5000]"
    lines[#lines+1]="[MENT_ATT_RANGE:PATIENCE:0:333:666:1000:2333:3666:5000]"
    lines[#lines+1]="[MENT_ATT_RANGE:MEMORY:1250:1500:1750:2000:2500:3000:5000]"
    lines[#lines+1]="[MENT_ATT_RANGE:LINGUISTIC_ABILITY:450:1050:1150:1250:1350:1550:2250]"
    lines[#lines+1]="[MENT_ATT_RANGE:MUSICALITY:0:333:666:1000:2333:3666:5000]"
    lines[#lines+1]="[MENT_ATT_RANGE:SOCIAL_AWARENESS:700:1300:1400:1500:1600:1800:2500]"
    --[[
MENTAL_ATTRIBUTE_CREATIVITY,
MENTAL_ATTRIBUTE_INTUITION,
MENTAL_ATTRIBUTE_SPATIAL_SENSE,
MENTAL_ATTRIBUTE_KINESTHETIC_SENSE,
MENTAL_ATTRIBUTE_EMPATHY,
    ]]
    --lines[#lines+1]="[PERSONALITY:ANXIETY_PROPENSITY:0:0:0]"
    --lines[#lines+1]="[PERSONALITY:DEPRESSION_PROPENSITY:0:0:0]"
    lines[#lines+1]="[PERSONALITY:BASHFUL:0:0:0]"
    lines[#lines+1]="[PERSONALITY:STRESS_VULNERABILITY:0:0:0]"
    lines[#lines+1]="[PERSONALITY:FRIENDLINESS:0:0:0]"
    --lines[#lines+1]="[PERSONALITY:ASSERTIVENESS:100:100:100]"
    lines[#lines+1]="[PERSONALITY:DISDAIN_ADVICE:100:100:100]"
    lines[#lines+1]="[PERSONALITY:CHEER_PROPENSITY:0:0:0]"
    lines[#lines+1]="[PERSONALITY:GRATITUDE:0:0:0]"
    lines[#lines+1]="[PERSONALITY:TRUST:0:0:0]"
    lines[#lines+1]="[PERSONALITY:ALTRUISM:0:0:0]"
    --lines[#lines+1]="[PERSONALITY:SWAYED_BY_EMOTIONS:0:0:0]"
    lines[#lines+1]="[PERSONALITY:CRUELTY:100:100:100]"
    --lines[#lines+1]="[PERSONALITY:PRIDE:100:100:100]"

    add_regular_tokens(lines,options)
    populate_sphere_info(lines,options)
    lines[#lines+1]="[NATURAL_SKILL:WRESTLING:6]"
    lines[#lines+1]="[NATURAL_SKILL:BITE:6]"
    lines[#lines+1]="[NATURAL_SKILL:GRASP_STRIKE:6]"
    lines[#lines+1]="[NATURAL_SKILL:STANCE_STRIKE:6]"
    lines[#lines+1]="[NATURAL_SKILL:MELEE_COMBAT:6]"
    lines[#lines+1]="[NATURAL_SKILL:DODGING:6]"
    lines[#lines+1]="[NATURAL_SKILL:SITUATIONAL_AWARENESS:6]"
    lines[#lines+1]="[NATURAL_SKILL:SNEAK:20]"

    lines[#lines+1]="[DIFFICULTY:3]"
    lines[#lines+1]="[LAIR:SIMPLE_BURROW:50]"
    local ropar=random_object_parameters
    ropar.werebeast_blacklist=ropar.werebeast_blacklist or {}
    local rcp=get_random_creature_profile(options,ropar.werebeast_blacklist)
    ropar.werebeast_blacklist[rcp.type]=true
    -- This sort of process should be fully generalized
    -- to all creatures you want to have bespoke associated interactions
    -- for example, you can have a blessing that allows a sort of
    -- uncrazed transformation into some sort of bespoke
    -- generated thing--at least, hopefully it's robust enough for that
    local choice=generate_from_list(werebeast_origin_interactions,tok,rcp.name_string,options)
    map_merge(options,choice.options)
    local werebeast_choice_raws=choice.interaction or choice.raws
    raws.register_interactions(werebeast_choice_raws)
    add_body_size(lines,math.max(rcp.min_size,80000+trandom(11)*1000),options)
    lines[#lines+1]="[CREATURE_TILE:165]" --Ñ
    options.forced_color={
        f=6,
        b=0,
        br=1
    }
    options.custom_desc_func=function(options)
        return "it is crazed for blood and flesh"
    end
    build_procgen_creature(rcp,lines,options)
    lines[#lines+1]="[GO_TO_START]"
    local name_str="were"..rcp.name_string..":were"..rcp.name_string.."s:were"..rcp.name_string.."]"
    lines[#lines+1]="[NAME:"..name_str
    lines[#lines+1]="[CASTE_NAME:"..name_str
    return {raws=lines,weight=1}
end

function experiment_tokens(lines,options)
    lines[#lines+1]="[NO_DRINK][NO_EAT][NO_SLEEP]"
    lines[#lines+1]="[LARGE_PREDATOR]"
    lines[#lines+1]="[NIGHT_CREATURE]"
    lines[#lines+1]="[SUPERNATURAL]"
    lines[#lines+1]="[FANCIFUL]"
    if not one_in(4) and random_object_parameters.experimenter_creature.flags.MATES_TO_BREED then
        lines[#lines+1]="[CASTE:FEMALE]"
            lines[#lines+1]="[FEMALE]"
        lines[#lines+1]="[CASTE:MALE]"
            lines[#lines+1]="[MALE]"
        lines[#lines+1]="[SELECT_CASTE:ALL]"
    else
        lines[#lines+1]="[NO_GENDER]"
    end
    lines[#lines+1]="[BIOME:ANY_LAND]"
    lines[#lines+1]="[PETVALUE:2000]"
    lines[#lines+1]="[ALL_ACTIVE]"
    lines[#lines+1]="[NOFEAR]"
    lines[#lines+1]="[NO_FEVERS]"
    options.spheres=options.spheres or {
        NIGHT=true,
        DEFORMITY=true
    }
    options.never_uniform=true
    options.experiment_colors=true
    options.forced_color={ -- overridden by humanoid, but that's fine
            f=2,
            b=0,
            br=1
        }
    options.experiment_attack_tweak=true
    options.sickness_name="night sickness"
    options.pref_str=options.pref_str or {"unsettling origin"}
--[[
************************** EXPERIMENT OBJECT def - desc phys/affect
	they expect the amalgamated giants to refer to all the pieces making them up -- do we do tissues differently though?  go all muscle?
		but don't actually give them tissues
]]
    options.no_extra_description=true
    options.cannot_swim=true
end

function experimenter_sphere_info(lines,options)
    local ropar=random_object_parameters
    if ropar.experimenter_creature.caste[ropar.experimenter_hf.caste].flags.UNIQUE_DEMON then
        -- ?. would be pretty cool, alas
        local spheres = ropar.experimenter_hf.profile and ropar.experimenter_hf.profile.mpp and ropar.experimenter_hf.profile.mpp.spheres
        if spheres then
            return spheres.CHAOS,spheres.DEFORMITY
        end
    end
    return false,false
end

function experiment_description(lines,options)
    local ropar=random_object_parameters
    local end_str=""
    local add_desc=function(str) end_str=end_str..str end
    if ropar.experimenter_hf then
        add_desc(" This night creature was first created ")
        if options.failed_experiment then
            add_desc("accidentally ")
        end
        add_desc("by the ")
        local ip = ropar.experimenter_hf.profile and ropar.experimenter_hf.profile.interaction_profile
        if ip and ip.uwss_display_name_sing~="" then
            add_desc(ropar.experimenter_race_adj..ip.uwss_display_name_sing)
        else
            add_desc(ropar.experimenter_race_name)
        end
        add_desc(" ")
        add_desc(ropar.experimenter_hf.name.translated)
        if ropar.experimenter_capital_st then
            add_desc(" of ")
            add_desc(ropar.experimenter_capital_st.name.translated)
        end
        local chaos,deformity=experimenter_sphere_info(lines,options)
        if deformity and chaos then
            add_desc(" through the fiend's terrifying power")
        elseif deformity then
            add_desc(" through the fiend's twisted power")
        elseif chaos then
            add_desc(" through the fiend's chaotic power")
        else
            add_desc(" after horrible experiments")
            if options.failed_experiment then
                add_desc(" gone wrong")
            end
        end
        if ropar.experimenter_source_hfid~=-1 or ropar.experimenter_source_race~=-1 then
            if deformity or chaos then add_desc(" unleashed upon ")
            else add_desc(" on ")
            end
            if options.amalgam_experiment then add_desc("multitudes")
            elseif ropar.experimenter_source_hfid~=-1 then
                add_desc("the ")
                if ropar.experiment_hf then
                    local ip = ropar.experiment_hf.profile and ropar.experiment_hf.profile.interaction_profile
                    if ip then
                        add_desc(ropar.experiment_source_race_adj.." "..ip.uwss_display_name_sing)
                    else
                        add_desc(ropar.experiment_source_race_name)
                    end
                else add_desc("an unknown creature")
                end
            elseif ropar.experimenter_source_race~=-1 then
                add_desc(ropar.experiment_source_race_name_plural)
            end
        end
        if ropar.experimenter_create_st then
            add_desc(" in "..ropar.experimenter_create_st.name.translated)
        end
        add_desc(" in the year "..tostring(world.year)..".")
    end
    return end_str
end

-- you can add more of your own, e.g. experiment_nouns.cyborg or whatever
experiment_nouns={
    humanoid={
        {"hand","hands"},
        {"demon","demons"},
        {"warrior","warriors"},
        {"soldier","soldiers"},
        {"fist","fists"},
        {"eye","eyes"},
    },
    humanoid_giant={
        {"giant","giants"},
        {"hulk","hulks"},
        {"tower","towers"},
        {"mountain","mountains"},
    },
    beast_small={
        {"dog","dogs"},
        {"hound","hounds"},
        {"wolf","wolves"},
    },
    beast_large={
        {"beast","beasts"},
        {"monster","monsters"},
        {"creature","creatures"},
    },
    failed_small={
        {"mistake","mistakes"},
        {"folly","follies"},
        {"experiment","experiments"},
    },
    failed_large={
        {"nightmare","nightmares"},
        {"catastrophe","catastrophes"},
        {"disaster","disasters"},
    }
}

experiment_random_names={
    --originally just a straight assignment, wanted to take the opportunity to let mods add variety
    deformity_chaos={"horror"},
    deformity={"misfortune"},
    chaos={"chaos"},
    night={"night"}
}

function experiment_name_token(lines,options)
    lines[#lines+1]="[GO_TO_START]"
    local ropar = random_object_parameters
    local name_to_use=ropar.experimenter_hf and ropar.experimenter_hf.name
    if one_in(4) then
        if one_in(2) then name_to_use=ropar.experimenter_create_st and ropar.experimenter_create_st.name or name_to_use
        else name_to_use=ropar.experimenter_capital_st and ropar.experimenter_capital_st.name or name_to_use
        end
    end
    local experiment_name=nil
    if name_to_use then
        -- we preprocess these indices for lua--i know it's inconsistent, sorry
        if string.len(name_to_use.firstname)>0 and ((name_to_use.words.FRONT_COMPOUND.index==0 and name_to_use.THE.index==0) or one_in(2)) then
            experiment_name=name_to_use.firstname
            experiment_name=capitalize_string_words(experiment_name)
        else
            if name_to_use.translated_epithet_the and (one_in(2) or not name_to_use.translated_epithet_compound) then
                -- "of The Murk"
                if one_in(2) then experiment_name=translated_epithet_the
                else experiment_name=native_epithet_the
                end
            elseif name_to_use.translated_epithet_compound then
                -- "of Tireshadows"
                if one_in(2) then experiment_name=translated_epithet_compound
                else experiment=native_epithet_compound
                end
            end
        end
    end
    if not experiment_name or one_in(10) then
        local chaos,deformity=experimenter_sphere_info(lines,options)
        if deformity and chaos then experiment_name=pick_random(experiment_random_names.deformity_chaos)
        elseif deformity then experiment_name=pick_random(experiment_random_names.deformity)
        elseif chaos then experiment_name=pick_random(experiment_random_names.chaos)
        else experiment_name=pick_random(experiment_random_names.night)
        end
    end
    options.experiment_name_type = options.experiment_name_type or ropar.making_experiment
    local nmm,pnmm=table.unpack(pick_random(experiment_nouns[options.experiment_name_type]))
    local full_name_str
    if one_in(2) then
        local possessive=experiment_name.."'s "
        full_name_str=possessive..nmm..":"..possessive..pnmm..":"..possessive..nmm
    else
        local possessive=" of "..experiment_name
        full_name_str=nmm..possessive..":"..pnmm..possessive..":"..nmm..possessive
    end
    lines[#lines+1]="[NAME:"..full_name_str.."]"
    lines[#lines+1]="[CASTE_NAME:"..full_name_str.."]"
end

creatures.experiment.humanoid.default=function(tok)
    local lines={}
    local options={
        token=tok,
        normal_biological=true
    }
    if one_in(2) then
        options.night_creature_strength_pref=true
    else
        options.night_creature_agile_pref=true
    end
    lines[#lines+1]="[CAN_LEARN]"
    lines[#lines+1]="[LOCAL_POPS_CONTROLLABLE]"
    lines[#lines+1]="[LOCAL_POPS_PRODUCE_HEROES]"
--[[************************** EXPERIMENT OBJECT personality + desc
        --do a few archetypes that'll be appended to the description
    lines[#lines+1]="[PERSONALITY:ANXIETY_PROPENSITY:0:0:0]"
    lines[#lines+1]="[PERSONALITY:DEPRESSION_PROPENSITY:0:0:0]"
    lines[#lines+1]="[PERSONALITY:BASHFUL:0:0:0]"
    lines[#lines+1]="[PERSONALITY:STRESS_VULNERABILITY:0:0:0]"
    lines[#lines+1]="[PERSONALITY:FRIENDLINESS:0:0:0]"
    lines[#lines+1]="[PERSONALITY:ASSERTIVENESS:100:100:100]"
    lines[#lines+1]="[PERSONALITY:DISDAIN_ADVICE:100:100:100]"
    lines[#lines+1]="[PERSONALITY:CHEER_PROPENSITY:0:0:0]"
    lines[#lines+1]="[PERSONALITY:GRATITUDE:0:0:0]"
    lines[#lines+1]="[PERSONALITY:TRUST:0:0:0]"
    lines[#lines+1]="[PERSONALITY:ALTRUISM:0:0:0]"
    lines[#lines+1]="[PERSONALITY:SWAYED_BY_EMOTIONS:0:0:0]"
    lines[#lines+1]="[PERSONALITY:CRUELTY:100:100:100]"
    lines[#lines+1]="[PERSONALITY:PRIDE:100:100:100]"
    lines[#lines+1]="[PERSONALITY:GREED:100:100:100]"
]]
    lines[#lines+1]="[CAN_SPEAK]"
    options.can_learn=true
    lines[#lines+1]="[BODY_APPEARANCE_MODIFIER:HEIGHT:90:95:98:100:102:105:110]"
    lines[#lines+1]="[BODY_APPEARANCE_MODIFIER:BROADNESS:90:95:98:100:102:105:110]"
    if options.night_creature_strength_pref then
        lines[#lines+1]="[PHYS_ATT_RANGE:STRENGTH:1000:1250:1500:2000:2250:2500:3000]"
        lines[#lines+1]="[PHYS_ATT_RANGE:AGILITY:450:550:700:750:800:850:900]"
        lines[#lines+1]="[PHYS_ATT_RANGE:TOUGHNESS:850:900:950:1000:1050:1100:1150]"
        lines[#lines+1]="[PHYS_ATT_RANGE:ENDURANCE:850:900:950:1000:1050:1100:1150]"
        options.special_walk_speed=1000;
    elseif options.night_creature_agile_pref then
        lines[#lines+1]="[PHYS_ATT_RANGE:STRENGTH:450:550:700:750:800:850:900]"
        lines[#lines+1]="[PHYS_ATT_RANGE:AGILITY:1000:1250:1500:2000:2250:2500:3000]"
        lines[#lines+1]="[PHYS_ATT_RANGE:TOUGHNESS:850:900:950:1000:1050:1100:1150]"
        lines[#lines+1]="[PHYS_ATT_RANGE:ENDURANCE:850:900:950:1000:1050:1100:1150]"
        options.special_walk_speed=800;
    end
    lines[#lines+1]="[PHYS_ATT_RANGE:RECUPERATION:450:1050:1150:1250:1350:1550:2250]"
    lines[#lines+1]="[PHYS_ATT_RANGE:DISEASE_RESISTANCE:700:1300:1400:1500:1600:1800:2500]"
    lines[#lines+1]="[MENT_ATT_RANGE:ANALYTICAL_ABILITY:1250:1500:1750:2000:2500:3000:5000]"
    lines[#lines+1]="[MENT_ATT_RANGE:FOCUS:1250:1500:1750:2000:2500:3000:5000]"
    lines[#lines+1]="[MENT_ATT_RANGE:WILLPOWER:1250:1500:1750:2000:2500:3000:5000]"
    lines[#lines+1]="[MENT_ATT_RANGE:PATIENCE:0:333:666:1000:2333:3666:5000]"
    lines[#lines+1]="[MENT_ATT_RANGE:MEMORY:1250:1500:1750:2000:2500:3000:5000]"
    lines[#lines+1]="[MENT_ATT_RANGE:LINGUISTIC_ABILITY:450:1050:1150:1250:1350:1550:2250]"
    lines[#lines+1]="[MENT_ATT_RANGE:MUSICALITY:0:333:666:1000:2333:3666:5000]"
    lines[#lines+1]="[MENT_ATT_RANGE:SOCIAL_AWARENESS:700:1300:1400:1500:1600:1800:2500]"
    experiment_tokens(lines,options)
    populate_sphere_info(lines,options)
    local rcp={
        type="GENERAL_HUMANOID",
		name_string="humanoid",
		tile='H',
		body_base="HUMANOID",
        --FOR SKIN/ORGANS AND NO HAIR/FEATHERS AT FIRST
		c_class="AMPHIBIAN",
		min_size=1,
        cannot_have_shell=true
    }
    add_body_size(lines,50000+trandom(4)*10000+trandom(11)*1000,options)
    lines[#lines+1]="[CREATURE_TILE:72]"
    options.forced_color={
        f=4,
        b=0,
        br=1
    }
    options.end_phrase=experiment_description(lines,options)
    options.experiment_layering=true
    build_procgen_creature(rcp,lines,options)
    experiment_name_token(lines,options)
    return {raws=lines,weight=1}
end

creatures.experiment.humanoid_giant.default=function(tok)
    local lines={}
    local options={
        amalgam_experiment=true,
        token=tok,
        normal_biological=true
    }
    if one_in(2) then
        options.night_creature_strength_pref=true
    else
        options.night_creature_agile_pref=true
    end
    lines[#lines+1]="[BODY_APPEARANCE_MODIFIER:HEIGHT:90:95:98:100:102:105:110]";
    lines[#lines+1]="[BODY_APPEARANCE_MODIFIER:BROADNESS:90:95:98:100:102:105:110]";
    experiment_tokens(lines,options)
    populate_sphere_info(lines,options)
    local rcp={
        type="GENERAL_HUMANOID",
		name_string="humanoid",
		tile='H',
		body_base="HUMANOID",
		c_class="FLESHY",
		min_size=1,
        cannot_have_shell=true
    }
    add_body_size(lines,5000000+trandom(4)*1000000+trandom(11)*100000,options)
    lines[#lines+1]="[CREATURE_TILE:165]"
    options.end_phrase=experiment_description(lines,options)
    build_procgen_creature(rcp,lines,options)
    experiment_name_token(lines,options)
    return {raws=lines,weight=1}
end

beast_experiment_rcps={
    {
        name_string="quadruped",
        tile='Q',
        body_base="QUADRUPED",
        maybe_slinky=true
    },
    {
        name_string="hexapod",
        tile='H',
        body_base="INSECT"
    },
    {
        name_string="spider",
        tile='S',
        body_base="SPIDER"
    },
    {
        name_string="scorpion",
        tile='S',
        body_base="SPIDER",
        must_have_pincers=true,
        must_have_scorpion_tail=true
    },
    {
        name_string="decapod",
        tile='D',
        body_base="TEN_LEGGED"
    },
    {
        name_string="octopod",
        tile='O',
        body_base="EIGHT_LEGGED"
    },
    {
        name_string="primate",
        tile='P',
        body_base="QUADRUPED_FRONT_GRASP"
    },
}

function make_beast_rcp(lines,options)
    local rcp={
        type="GENERAL_QUADRUPED",
        c_class="FLESHY",
        min_size=1,
        cannot_have_shell=true,
        cannot_have_get_more_legs=true
    }
    map_merge(rcp,pick_random(beast_experiment_rcps))
    if rcp.maybe_slinky then
        rcp.maybe_slinky=nil
        if one_in(2) then rcp.SLINKY_QUADRUPED=true end
    end
    return rcp
end

creatures.experiment.beast_small.default=function(tok)
    local lines={}
    local options={
        token=tok,
        normal_biological=true
    }
    if one_in(2) then
        options.night_creature_strength_pref=true
    else
        options.night_creature_agile_pref=true
    end
    lines[#lines+1]="[BODY_APPEARANCE_MODIFIER:LENGTH:90:95:98:100:102:105:110]";
    lines[#lines+1]="[BODY_APPEARANCE_MODIFIER:HEIGHT:90:95:98:100:102:105:110]";
    lines[#lines+1]="[BODY_APPEARANCE_MODIFIER:BROADNESS:90:95:98:100:102:105:110]";
    experiment_tokens(lines,options)
    populate_sphere_info(lines,options)
    local rcp=make_beast_rcp(lines,options)
    add_body_size(lines,50000+trandom(4)*10000+trandom(11)*1000,options)
    lines[#lines+1]="[CREATURE_TILE:"..rcp.tile.."]"
    options.end_phrase=experiment_description(lines,options)
    build_procgen_creature(rcp,lines,options)
    experiment_name_token(lines,options)
    return {raws=lines,weight=1}
end

creatures.experiment.beast_large.default=function(tok)
    local lines={}
    local options={
        token=tok,
        normal_biological=true

    }
    if one_in(2) then
        options.night_creature_strength_pref=true
    else
        options.night_creature_agile_pref=true
    end
    lines[#lines+1]="[BODY_APPEARANCE_MODIFIER:LENGTH:90:95:98:100:102:105:110]";
    lines[#lines+1]="[BODY_APPEARANCE_MODIFIER:HEIGHT:90:95:98:100:102:105:110]";
    lines[#lines+1]="[BODY_APPEARANCE_MODIFIER:BROADNESS:90:95:98:100:102:105:110]";
    experiment_tokens(lines,options)
    populate_sphere_info(lines,options)
    local rcp=make_beast_rcp(lines,options)
    add_body_size(lines,500000+trandom(4)*100000+trandom(11)*10000,options)
    lines[#lines+1]="[CREATURE_TILE:"..rcp.tile.."]"
    options.end_phrase=experiment_description(lines,options)
    build_procgen_creature(rcp,lines,options)
    experiment_name_token(lines,options)
    return {raws=lines,weight=1}
end

failed_experiment_rcps={
    {
        name_string="blob",
        tile='b',
        body_base="AMORPHOUS",
    },
    {
        name_string="maggot",
        tile='m',
        body_base="INSECT_LARVA",
    },
    {
        name_string="worm",
        tile='w',
        body_base="WORM",
    },
    {
        name_string="wyrm",
        tile='w',
        body_base="NO_LIMB",
    },
    {
        name_string="snake",
        tile='s',
        body_base="SNAKE",
    },
    {
        name_string="armless biped",
        tile='b',
        body_base="TWO_LEGS_NO_ARMS",
        always_flightless=true
    },
}

function make_failed_rcp(lines,options)
    local rcp={
        type="BLOB",
        c_class="FLESHY",
        min_size=1,
        cannot_have_shell=true,
    }
    map_merge(rcp,pick_random(failed_experiment_rcps))
    if options.is_large then rcp.tile=string.upper(rcp.tile) end
    return rcp
end

creatures.experiment.failed_small.default=function(tok)
    local lines={}
    local options={
        failed_experiment=true,
        token=tok,
        normal_biological=true
    }
    if one_in(2) then
        options.night_creature_strength_pref=true
    else
        options.night_creature_agile_pref=true
    end
    experiment_tokens(lines,options)
    populate_sphere_info(lines,options)
    local rcp=make_beast_rcp(lines,options)
    add_body_size(lines,50000+trandom(4)*10000+trandom(11)*1000,options)
    lines[#lines+1]="[CREATURE_TILE:"..rcp.tile.."]"
    options.end_phrase=experiment_description(lines,options)
    build_procgen_creature(rcp,lines,options)
    experiment_name_token(lines,options)
    return {raws=lines,weight=1}
end

creatures.experiment.failed_large.default=function(tok)
    local lines={}
    local options={
        is_large=true,
        failed_experiment=true,
        token=tok,
        normal_biological=true
    }
    if one_in(2) then
        options.night_creature_strength_pref=true
    else
        options.night_creature_agile_pref=true
    end
    experiment_tokens(lines,options)
    populate_sphere_info(lines,options)
    local rcp=make_beast_rcp(lines,options)
    add_body_size(lines,500000+trandom(4)*100000+trandom(11)*10000,options)
    lines[#lines+1]="[CREATURE_TILE:"..rcp.tile.."]"
    options.end_phrase=experiment_description(lines,options)
    build_procgen_creature(rcp,lines,options)
    experiment_name_token(lines,options)
    return {raws=lines,weight=1}
end

sphere_flavor={
    AGRICULTURE={add="it looks constantly to the sky for rain"},
    ANIMALS={add="it growls, buzzes, clicks and generally makes a varied racket"},
    ART={add="it is decorated with intricate patterns"},
    BALANCE={add="it is perfectly symmetric"},
    BEAUTY={add="it is strikingly beautiful"},
    BIRTH={add="it is covered with a filmy sac"},
    BLIGHT={add="nearby vegetation seem to shrink away from it"},
    BOUNDARIES={add="the pieces of its body are carefully separated by markings"},
    CAVERNS={add="its moans seem to echo no matter where it resides"},
    CHAOS={add="it spins wildly, lurching and howling"},
    CHARITY={add="it seems very pleasant"},
    CHILDREN={add="it never misses an opportunity to jump in puddles"},
    COASTS={add="it appears to be covered with rocky crags"},
    CONSOLATION={add="it radiates a sad kindness"},
    COURAGE={add="it makes those around it feel brave"},
    CRAFTS={add="it appears constructed"},
    CREATION={add="small objects seem to pop into existence around it"},
    DANCE={add="it whirls, skips and jumps whenever it moves"},
    DARKNESS={add="it is difficult to see clearly even in bright light"},
    DAWN={add="it always turns to welcome the rise of the sun"},
    DAY={add="it hums pleasantly when the sun is high in the sky"},
    DEATH={add="it has a rattling exhale"},
    DEFORMITY={add="its body is bent and misshapen"},
    DEPRAVITY={add="it slavers uncontrollably"},
    DISCIPLINE={add="it moves with great focus"},
    DISEASE={add="it bears malodorous pustules",odor="death"},
    DREAMS={add="the details of its form are easily forgotten without deliberate concentration"},
    DUSK={add="it never looks toward the sun"},
    DUTY={add="it is utterly still when not taking deliberate action"},
    EARTH={add="it looks very solid and stocky"},
    FAMILY={add="it appears to be closely related to every other of its kind"},
    FAME={add="fanfare follows it wherever it goes"},
    FATE={add="it never appears to be perturbed or surprised by any happening"},
    FERTILITY={add="it appears to be very healthy"},
    FESTIVALS={add="it skips and twirls as it moves"},
    FIRE={add="a sheen around it always seems to rise upward"},
    FISH={add="it only looks comfortable when it is in the water"},
    FISHING={add="it always moves carefully around water"},
    FOOD={add="it has the delicious smell of freshly-baked goods",odor="freshly-baked goods"},
    FORGIVENESS={add="it is impossible to hold a grudge near it"},
    FORTRESSES={add="it is very sturdy-looking"},
    FREEDOM={add="it eagerly moves from place to place"},
    GAMBLING={add="it changes between two colors intermittently"},
    GAMES={add="it giggles at random"},
    GENEROSITY={add="it makes those around it want to give up their possessions"},
    HAPPINESS={add="it seems to smile constantly"},
    HEALING={add="it is surrounded by a gentle atmosphere"},
    HOSPITALITY={add="it radiates an aura of welcoming"},
    HUNTING={add="it inspects the ground intently as it moves"},
    INSPIRATION={add="flashes of energy pulse across its surface intermittently"},
    JEALOUSY={add="it appears to be a very bitter creature"},
    JEWELS={add="its whole body appears to be faceted in a symmetric fashion"},
    JUSTICE={add="it seems eager to pronounce judgment on others"},
    LABOR={add="it appears very deliberate in its actions"},
    LAKES={add="it moves ponderously"},
    LAWS={add="it has a very stark look about it"},
    LIES={add="it seems unerringly honest if one does not concentrate"},
    LIGHT={add="it returns surrounding light with a new vibrance and intensity"},
    LIGHTNING={add="it crackles with energy"},
    LONGEVITY={add="it always seems to be looking far into the distance"},
    LOVE={add="it stares longingly at those nearby"},
    LOYALTY={add="it never abandons its companions"},
    LUCK={add="it changes direction suddenly at times"},
    LUST={add="it has an unnerving stare"},
    MARRIAGE={add="it heckles those it meets that are not married"},
    MERCY={add="it always seems like it is on the verge of crying"},
    METALS={add="it appears to have sharp shimmering edges on many parts of its body"},
    MINERALS={add="it has an angular appearance"},
    MISERY={add="it has a distinctly depressing moan"},
    MIST={add="it is difficult to see clearly"},
    MOON={add="it changes color with the phases of the moon"},
    MOUNTAINS={add="it is very solidly built"},
    MUCK={add="there is a foul reek about it"},
    MURDER={add="it cannot abide anything that lives"},
    MUSIC={add="it sounds clear tones as its body moves in time"},
    NATURE={add="it seems most at ease when it is outdoors"},
    NIGHT={add="it eerily reflects the light of the stars and moon"},
    NIGHTMARES={add="it reminds those that look upon it of their most unpleasant memories"},
    OATHS={add="it cannot look directly at somebody that has broken an oath"},
    OCEANS={add="it always raises a part of its body toward the moon"},
    ORDER={add="it moves very stiffly"},
    PAINTING={add="its surface is always enlivened with a refreshing play of color"},
    PEACE={add="it has an incredibly calm demeanor"},
    PERSUASION={add="it rocks back and forth whenever somebody changes their mind in its presence"},
    PLANTS={add="it always seems to point toward the sun when it is in the sky"},
    POETRY={add="it recites verses in a strange language on occasion"},
    PREGNANCY={add="it appears to be expecting"},
    RAIN={add="it leaves water wherever it goes"},
    RAINBOWS={add="it is strikingly colored"},
    REBIRTH={add="it alternates from instant to instant between sluggishness and extreme vibrancy"},
    REVELRY={add="it moves with a bouncing rhythm"},
    REVENGE={add="it has a fixed and unblinking gaze when interacting"},
    RIVERS={add="its outer surface seems to flow about its body"},
    RULERSHIP={add="it is hard to disobey"},
    RUMORS={add="it always nods eagerly when somebody is speaking"},
    SACRIFICE={add="it inspires those around it to acts of great sacrifice"},
    SALT={add="it makes nearby water undrinkable"},
    SCHOLARSHIP={add="it always seems to be deep in thought"},
    SEASONS={add="its form is ever-changing"},
    SILENCE={add="it makes absolutely no sound"},
    SKY={add="it has a slowly shifting pattern on its surface"},
    SONG={add="it sings beautiful songs endlessly"},
    SPEECH={add="it pays attention carefully to anybody that is speaking"},
    STARS={add="it appears to sparkle after night falls"},
    STORMS={add="its movement is the sound of wind and rain"},
    STRENGTH={add="it looks solidly built"},
    SUICIDE={add="it mutters to itself about death"},
    SUN={add="it is difficult to look at directly"},
    THEFT={add="it always seems to have its attention on the most valuable object in the area"},
    THRALLDOM={add="its movements sound like the rattling of chains"},
    THUNDER={add="it is incredibly noisy"},
    TORTURE={add="it appears to be covered with sharp hooks and barbs"},
    TRADE={add="it seems most content when a fair wind is blowing"},
    TRAVELERS={add="it never stops moving completely"},
    TREACHERY={add="it is unsettling to be around"},
    TREES={add="it is top-heavy"},
    TRICKERY={add="it has a tendency to laugh quietly to itself every so often"},
    TRUTH={add="it tenses up throughout its entire body whenever somebody tells a falsehood in its presence"},
    TWILIGHT={add="it chitters briefly before sunrise and just after nightfall"},
    VALOR={add="it always tries to embolden any fighting in its presence with exhortations of bravery, even its foes"},
    VICTORY={add="it looks very proud of itself"},
    VOLCANOS={add="it seems to glow brightly from within"},
    WAR={add="it bellows and cheers without pause"},
    WATER={add="it seems to flow as it moves"},
    WEALTH={add="it always seems to be counting something"},
    WEATHER={add="it changes appearance based on the clouds and precipitation above"},
    WIND={add="it is surrounded by an everpresent rush of wind"},
    WISDOM={add="it acts with unwavering calm"},
    WRITING={add="it is covered with divine writing"},
    YOUTH={add="it appears spry and vigorous"},
}

function angel_description(lines,options)
    local ropar=random_object_parameters
    local end_str=" It was created by "
    local add_desc=function(str) end_str=end_str..str end
    local hf=ropar.source_hf
    if hf then
        add_desc("the ")
        add_desc(ropar.source_hf_race_adj)
        if hf.gender==1 then add_desc("goddess")
        elseif hf.gender==0 then add_desc("god")
        else add_desc("deity") end
        add_desc(" ")
        add_desc(hf.name.translated)
    else
        add_desc("an unknown deity")
    end
    local sch=0
    for k,v in pairs(options.spheres) do
        if v then sch = sch+1 end
    end
    if sch>0 then
        add_desc(" and is of a part with ")
        for k,v in pairs(options.spheres) do
            add_desc(world.spheres[k].definite_name)
            sch=sch-1
            if sch>=2 then add_desc(", ")
            elseif sch == 1 then add_desc(" and ")
            end
        end
    end
    add_desc(".")
    return end_str
end

angel_names_humanoid_warrior={
    {"Angel","Angels","angelic"},
    {"Soldier","Soldiers","soldier"},
    {"Warrior","Warriors","warrior"},
    {"Champion","Champions","champion"},
    {"Fighter","Fighters","fighter"},
    {"Guardian","Guardians","guardian"},
    {"Spirit","Spirits","spirit"},
    {"Messenger","Messengers","messenger"},
    {"Slayer","Slayers","slayer"},
    {"Enforcer","Enforcers","enforcer"},
}

angel_names_great_beast={
    {"Beast","Beasts","beast"},
    {"Behemoth","Behemoths","behemoth"},
    {"Harbinger","Harbingers","harbinger"},
    {"Monster","Monsters","monster"},
    {"Destroyer","Destroyers","destroyer"},
    {"Doom","Dooms","doom"},
    {"Bane","Banes","bane"},
    {"Catastrophe","Catastrophes","catastrophe"},
    {"Ruination","Ruinations","ruination"},
    {"Judgment","Judgments","judgment"},
}

angel_names_humanoid_generic={
    {"Servant","Servants","servant"},
    {"Assistant","Assistants","assistant"},
    {"Attendant","Attendants","attendant"},
    {"Minion","Minions","minion"},
    {"Helper","Helpers","helper"},
    {"Worker","Workers","worker"},
    {"Hand","Hands","hand"},
    {"Being","Beings","being"},
    {"Puppet","Puppets","puppet"},
    {"Pawn","Pawns","pawn"},
    {"Retainer","Retainers","retainer"},
}

function angel_end_tokens(lines,options,names_tbl)
    lines[#lines+1]="[GO_TO_START]"
    local hf = random_object_parameters.source_hf
    local cand={}
    if hf.name.translated_epithet_compound then 
        cand[#cand+1]={
            hf.name.translated_epithet_compound,
            hf.name.native_epithet_compound,
            false}
    end
    if hf.name.translated_epithet_the then
        cand[#cand+1]={
            hf.name.translated_epithet_the,
            hf.name.native_epithet_the,
            false}
    end
    if hf.name.translated_epithet_the_adj1 then
        cand[#cand+1]={
            hf.name.translated_epithet_the_adj1,
            hf.name.native_epithet_the_adj1,
            false}
    end
    if string.len(hf.name.firstname) then
        cand[#cand+1]={hf.name.firstname,hf.name.firstname,true}
    end
    local god_name = pick_random(cand)
    local add_name,proper_name="",false
    if god_name then
        add_name=god_name[trandom(2)+1]
        proper_name=god_name[3]
    end
    local using_god_name=false
    local name_flags={}
    local have_adjective=false
    cand={}
    for k,v in pairs(options.spheres) do
        if v then cand[#cand+1]=k end
    end
    if #cand>0 and (not add_name or one_in(2)) then
        proper_name=false
        if one_in(2) then
            have_adjective=true
            add_name=get_random_sphere_adjective(pick_random(cand))
        else
            local ret=get_random_sphere_noun(pick_random(cand))
            name_flags=ret.flags
            add_name=ret.str
        end
    else using_god_name=true
    end
    local name,names,name_adj=table.unpack(pick_random(names_tbl))
    local ntype
    if using_god_name and proper_name then ntype=trandom(2)+1
    elseif using_god_name then ntype=2
    elseif have_adjective or #name_flags==0 then ntype=0
    else 
        local cand={}
        if name_flags.PRE then cand[#cand+1]=0 end
        if name_flags.PREPOS then cand[#cand+1]=1 end
        if name_flags.OF then cand[#cand+1]=2 end
        ntype=pick_random(cand) or 0
    end
    local ntypes={
        function()
            return add_name.." "..name..":"..add_name.." "..names..":"..add_name.." "..name_adj
        end,
        function()
            return add_name.."'s "..name..":"..add_name.."'s "..names..":"..add_name.."'s "..name_adj
        end,
        function()
            return name.." of "..add_name..":"..names.." of "..add_name..":"..name_adj
        end,
    }
    local str=ntypes[ntype+1]()
    lines[#lines+1]="[NAME:"..str.."]"
    lines[#lines+1]="[CASTE_NAME:"..str.."]"
end

creatures.angel.humanoid_warrior.default=function(tok)
    local lines={}
    local options={
        humanoid_only=true,
        can_learn=true,
        do_sphere_rcm=true,
        pick_sphere_rcm=true,
        force_ichor=true,
        sickness_name="divine sickness",
        forced_color={
            f=3,
            b=0,
            br=1
        },
        token=tok,
    }
    lines[#lines+1]="[DIFFICULTY:6]"
    lines[#lines+1]="[CAN_LEARN]"
    if one_in(2) then lines[#lines+1]="[CAN_SPEAK]" end
    add_regular_tokens(lines,options)
    options.spheres=options.spheres or {}
    local hf=random_object_parameters.source_hf
    if hf then
        if hf.profile and hf.profile.mpp then
            map_merge(options.spheres,hf.profile.mpp.sphere)
        end
    end
    local skill_amount = (options.spheres.WAR or options.spheres.VALOR or options.spheres.FORTRESSES) and "10" or "6"
    for k,v in ipairs({
    "WRESTLING","BITE","GRASP_STRIKE","STANCE_STRIKE",
    "MELEE_COMBAT","RANGED_COMBAT","DODGING","SITUATIONAL_AWARENESS",
    "AXE","SWORD","DAGGER","PIKE",
    "MACE","HAMMER","WHIP","SPEAR",}) do
        lines[#lines+1]="[NATURAL_SKILL:"..v..":"..skill_amount.."]"
    end
    populate_sphere_info(lines,options)
    local rcm
    if one_in(4) then
        rcp=get_random_creature_profile(options)
    else
        rcp={
            type="GENERAL_HUMANOID",
            name_string="humanoid",
            tile='H',
            body_base="HUMANOID",
            min_size=1,
        }
        if options.sphere_rcm then
            rcp.c_class="UNIFORM"
        else
            --FOR SKIN/ORGANS AND NO HAIR/FEATHERS AT FIRST
            rcp.c_class="AMPHIBIAN"
            rcp.cannot_have_shell=true
        end
    end
    add_body_size(lines,math.max(rcp.min_size,50000+trandom(4)*10000+trandom(11)*1000),options)
    lines[#lines+1]="[CREATURE_TILE:"..((options.body_size<=60000) and "132]" or "142]") -- ä or Ä
    options.custom_desc_func=function(options)
        local add_tbl=sphere_flavor[pick_random_conditional_pairs(sphere_flavor,function(sphere,_,options) 
            return options.spheres[sphere] 
        end,options)]
        if not add_tbl then add_tbl={add="it is a divine being"} end
        if add_tbl.odor then
            options.always_odor=true
            options.forced_odor_string=add_tbl.odor
            options.forced_odor_level=100
        end
        return add_tbl.add
    end
    options.end_phrase=angel_description(lines,options)
    build_procgen_creature(rcp,lines,options)
    angel_end_tokens(lines,options,angel_names_humanoid_warrior)
    return {raws=lines,weight=1}
end

creatures.angel.humanoid_generic.default=function(tok)
    local lines={}
    local options={
        humanoid_only=true,
        do_sphere_rcm=true,
        pick_sphere_rcm=true,
        force_ichor=true,
        sickness_name="divine sickness",
        forced_color={
            f=6,
            b=0,
            br=0
        },
        token=tok,
    }
    lines[#lines+1]="[LARGE_PREDATOR]"
    lines[#lines+1]="[DIFFICULTY:2]"
    lines[#lines+1]="[NATURAL_SKILL:WRESTLING:4]"
    lines[#lines+1]="[NATURAL_SKILL:BITE:4]"
    lines[#lines+1]="[NATURAL_SKILL:GRASP_STRIKE:4]"
    lines[#lines+1]="[NATURAL_SKILL:STANCE_STRIKE:4]"
    lines[#lines+1]="[NATURAL_SKILL:MELEE_COMBAT:4]"
    lines[#lines+1]="[NATURAL_SKILL:RANGED_COMBAT:4]"
    lines[#lines+1]="[NATURAL_SKILL:DODGING:4]"
    lines[#lines+1]="[NATURAL_SKILL:SITUATIONAL_AWARENESS:4]"
    add_regular_tokens(lines,options)
    options.spheres=options.spheres or {}
    local hf=random_object_parameters.source_hf
    if hf then
        if hf.profile and hf.profile.mpp then
            map_merge(options.spheres,hf.profile.mpp.sphere)
        end
    end
    populate_sphere_info(lines,options)
    local rcm
    if one_in(4) then
        rcp=get_random_creature_profile(options)
    else
        rcp={
            type="GENERAL_HUMANOID",
            name_string="humanoid",
            tile='H',
            body_base="HUMANOID",
            min_size=1,
        }
        if options.sphere_rcm then
            rcp.c_class="UNIFORM"
        else
            --FOR SKIN/ORGANS AND NO HAIR/FEATHERS AT FIRST
            rcp.c_class="AMPHIBIAN"
            rcp.cannot_have_shell=true
        end
    end
    add_body_size(lines,math.max(rcp.min_size,50000+trandom(4)*10000+trandom(11)*1000),options)
    lines[#lines+1]="[CREATURE_TILE:"..((options.body_size<=60000) and "132]" or "142]") -- ä or Ä
    options.custom_desc_func=function(options)
        local add_tbl=sphere_flavor[pick_random_conditional_pairs(sphere_flavor,function(sphere,_,options) 
            return options.spheres[sphere] 
        end,options)]
        if not add_tbl then add_tbl={add="it is a divine being"} end
        if add_tbl.odor then
            options.always_odor=true
            options.forced_odor_string=add_tbl.odor
            options.forced_odor_level=100
        end
        return add_tbl.add
    end
    options.end_phrase=angel_description(lines,options)
    build_procgen_creature(rcp,lines,options)
    angel_end_tokens(lines,options,angel_names_humanoid_generic)
    return {raws=lines,weight=1}
end

creatures.angel.great_beast.default=function(tok)
    local lines={}
    local l=get_debug_logger()
    local options={
        can_learn=true,
        do_sphere_rcm=true,
        pick_sphere_rcm=true,
        force_ichor=true,
        beast_only=true,
        sickness_name="divine sickness",
        forced_color={
            f=4,
            b=0,
            br=1
        },
        token=tok,
    }
    lines[#lines+1]="[LARGE_PREDATOR]"
    lines[#lines+1]="[DIFFICULTY:10]"
    lines[#lines+1]="[NATURAL_SKILL:WRESTLING:14]"
    lines[#lines+1]="[NATURAL_SKILL:BITE:14]"
    lines[#lines+1]="[NATURAL_SKILL:GRASP_STRIKE:14]"
    lines[#lines+1]="[NATURAL_SKILL:STANCE_STRIKE:14]"
    lines[#lines+1]="[NATURAL_SKILL:MELEE_COMBAT:14]"
    lines[#lines+1]="[NATURAL_SKILL:RANGED_COMBAT:14]"
    lines[#lines+1]="[NATURAL_SKILL:DODGING:14]"
    lines[#lines+1]="[NATURAL_SKILL:SITUATIONAL_AWARENESS:14]"
    add_regular_tokens(lines,options)
    options.spheres=options.spheres or {}
    local hf=random_object_parameters.source_hf
    if hf then
        if hf.profile and hf.profile.mpp then
            map_merge(options.spheres,hf.profile.mpp.sphere)
        end
    end
    local skill_amount = (options.spheres.WAR or options.spheres.VALOR or options.spheres.FORTRESSES) and "10" or "6"
    for k,v in ipairs({
    "WRESTLING","BITE","GRASP_STRIKE","STANCE_STRIKE",
    "MELEE_COMBAT","RANGED_COMBAT","DODGING","SITUATIONAL_AWARENESS",
    "AXE","SWORD","DAGGER","PIKE",
    "MACE","HAMMER","WHIP","SPEAR"}) do
        lines[#lines+1]="[NATURAL_SKILL:"..v..":"..skill_amount.."]"
    end
    populate_sphere_info(lines,options)
    local rcm
    rcp=get_random_creature_profile(options)
    add_body_size(lines,math.max(rcp.min_size,10000000),options)
    lines[#lines+1]="[CREATURE_TILE:"..((options.body_size<=60000) and "132]" or "142]") -- ä or Ä
    options.custom_desc_func=function(options)
        local add_tbl=sphere_flavor[pick_random_conditional_pairs(sphere_flavor,function(sphere,_,options) 
            return options.spheres[sphere] 
        end,options)]
        if not add_tbl then add_tbl={add="it is a divine being"} end
        if add_tbl.odor then
            options.always_odor=true
            options.forced_odor_string=add_tbl.odor
            options.forced_odor_level=100
        end
        return add_tbl.add
    end
    options.end_phrase=angel_description(lines,options)
    build_procgen_creature(rcp,lines,options)
    angel_end_tokens(lines,options,angel_names_great_beast)
    return {raws=lines,weight=1}
end