--[[
    Yes, it is 100% intended for other mods to use the stuff in this.
    generators.lua includes everything that the game will genuinely not work
    right if it's not available--this mod can be removed and things will still work.
    Any mods that want to build on vanilla can use any globals in this mod's lua,
    this is good and proper.
]]

interactions=interactions or {}

interactions.powers={}

interactions.powers.ice={
    tags={
        lieutenant=true
    },
    rarity=10, -- one_in called on this
    gen=function(name)
        local tbl={}
        tbl=split_to_lines(tbl,[[
            [CE_CAN_DO_INTERACTION:START:0:ABRUPT]
			[CDI:ADV_NAME:Launch ice bolt]
            [CDI:INTERACTION:]]..name..[[]
			[CDI:MATERIAL:WATER:SHARP_ROCK]
			[CDI:TARGET:C:LINE_OF_SIGHT]
			[CDI:TARGET_RANGE:C:25]
			[CDI:BP_REQUIRED:BY_TYPE:GRASP]
			[CDI:USAGE_HINT:ATTACK]
            ]]
        )
        tbl[#tbl+1]="[CDI:VERB:"..pick_random(gestures)..":NA]"
        tbl=split_to_lines(tbl,[[
			[CDI:MAX_TARGET_NUMBER:C:1]
			[CDI:WAIT_PERIOD:50]
			[CDI:DEFAULT_ICON:ADVENTURE_INTERACTION_ICON_LAUNCH_ICE_BOLT]
            ]])
        local end_tbl={}
        end_tbl[#end_tbl+1]="[INTERACTION:"..name.."]"
        end_tbl=add_generated_info(end_tbl)
        end_tbl=split_to_lines(end_tbl,[[
			[I_TARGET:A:MATERIAL]
				[IT_MATERIAL:CONTEXT_MATERIAL]
			[I_TARGET:B:LOCATION]
				[IT_LOCATION:CONTEXT_LOCATION]
			[I_TARGET:C:LOCATION]
				[IT_LOCATION:CONTEXT_CREATURE_OR_LOCATION]
				[IT_MANUAL_INPUT:target]
			[I_EFFECT:MATERIAL_EMISSION]
				[IE_TARGET:A]
				[IE_TARGET:B]
				[IE_TARGET:C]
				[IE_IMMEDIATE]
        ]])
        return tbl,end_tbl
    end
}

interactions.powers.vanish={
    tags={
        lieutenant=true
    },
    rarity=10,
    gen=function(name)
        local tbl={}
        tbl=split_to_lines(tbl,[[
            [CE_CAN_DO_INTERACTION:START:0:ABRUPT]
			[CDI:ADV_NAME:Vanish]
            [CDI:INTERACTION:]]..name..[[]
			[CDI:TARGET:A:SELF_ONLY]
			[CDI:BP_REQUIRED:BY_TYPE:GRASP]
			[CDI:USAGE_HINT:DEFEND]
			[CDI:USAGE_HINT:FLEEING]
            ]]
        )
        --tbl[#tbl+1]="[CDI:VERB:"..pick_random(gestures)..":NA]"
        tbl=split_to_lines(tbl,[[
			[CDI:VERB:vanish:vanishes:NA]
			[CDI:MAX_TARGET_NUMBER:C:1]
			[CDI:WAIT_PERIOD:50]
			[CDI:DEFAULT_ICON:ADVENTURE_INTERACTION_ICON_VANISH]
            ]])
        local end_tbl={}
        end_tbl[#end_tbl+1]="[INTERACTION:"..name.."]"
        end_tbl=add_generated_info(end_tbl)
        end_tbl=split_to_lines(end_tbl,[[
			[I_TARGET:A:CREATURE]
				[IT_LOCATION:CONTEXT_CREATURE]
			[I_EFFECT:HIDE]
				[IE_TARGET:A]
				[IE_IMMEDIATE]
        ]])
        return tbl,end_tbl
    end
}

interactions.powers.propel={
    tags={
        lieutenant=true
    },
    rarity=10,
    gen=function(name)
        local tbl={}
        tbl=split_to_lines(tbl,[[
            [CE_CAN_DO_INTERACTION:START:0:ABRUPT]
			[CDI:ADV_NAME:Propel away]
            [CDI:INTERACTION:]]..name..[[]
			[CDI:TARGET:B:LINE_OF_SIGHT]
			[CDI:TARGET_RANGE:B:25]
			[CDI:BP_REQUIRED:BY_TYPE:GRASP]
			[CDI:USAGE_HINT:ATTACK]
            ]]
        )
        tbl[#tbl+1]="[CDI:VERB:"..get_abstract_gesture()..":NA]"
        tbl=split_to_lines(tbl,[[
			[CDI:MAX_TARGET_NUMBER:B:1]
			[CDI:WAIT_PERIOD:50]
			[CDI:DEFAULT_ICON:ADVENTURE_INTERACTION_ICON_PROPEL_AWAY])
            ]])
        local end_tbl={}
        end_tbl="[INTERACTION:"..name.."]"
        end_tbl=add_generated_info(end_tbl)
        end_tbl=split_to_lines(end_tbl,[[
			[I_TARGET:A:LOCATION]
				[IT_LOCATION:CONTEXT_LOCATION]
			[I_TARGET:B:CREATURE]
				[IT_LOCATION:CONTEXT_CREATURE]
				[IT_MANUAL_INPUT:target]
			[I_EFFECT:PROPEL_UNIT]
				[IE_PROPEL_FORCE:100000]
				[IE_TARGET:A]
				[IE_TARGET:B]
				[IE_IMMEDIATE]
        ]])
        return tbl,end_tbl
    end
}

interactions.powers.fog={
    tags={
        lieutenant=true
    },
    rarity=10,
    gen=function(name)
        local tbl={}
        tbl=split_to_lines(tbl,[[
            [CE_CAN_DO_INTERACTION:START:0:ABRUPT]
			[CDI:ADV_NAME:Raise fog]
            [CDI:INTERACTION:]]..name..[[]
			[CDI:BP_REQUIRED:BY_TYPE:GRASP]
			[CDI:LOCATION_HINT:NO_THICK_FOG]
			[CDI:LOCATION_HINT:OUTSIDE]
			[CDI:USAGE_HINT:DEFEND]
			[CDI:USAGE_HINT:FLEEING]
			[CDI:VERB:raise a heavy fog:raises a heavy fog:NA]
			[CDI:WAIT_PERIOD:500]
			[CDI:DEFAULT_ICON:ADVENTURE_INTERACTION_ICON_RAISE_FOG]
        ]])
        local end_tbl={}
        end_tbl[#end_tbl+1]="[INTERACTION:"..name.."]"
        end_tbl=add_generated_info(end_tbl)
        end_tbl=split_to_lines(end_tbl,[[
			[I_EFFECT:CHANGE_WEATHER]
				[IE_ADD_WEATHER:FOG_THICK]
				[IE_IMMEDIATE]
        ]])
        return tbl,end_tbl
    end
}

function basic_animation(regional)
    local tbl={}
    tbl[#tbl+1]="[I_TARGET:A:CORPSE]"
    if regional then
        tbl[#tbl+1]="[IT_LOCATION:CONTEXT_REGION]"
    else
        tbl[#tbl+1]="[IT_LOCATION:CONTEXT_ITEM]"
    end
    tbl[#tbl+1]="[IT_AFFECTED_CLASS:GENERAL_POISON]"
    tbl[#tbl+1]="[IT_REQUIRES:FIT_FOR_ANIMATION]"
    tbl[#tbl+1]="[IT_FORBIDDEN:NOT_LIVING]"
    tbl[#tbl+1]="[IT_MANUAL_INPUT:corpses]"
    tbl[#tbl+1]="[I_EFFECT:ANIMATE]"
    tbl[#tbl+1]="  [IE_TARGET:A]"
    if regional then
        tbl[#tbl+1]="  [IE_INTERMITTENT:WEEKLY]"
    else
        tbl[#tbl+1]="  [IE_IMMEDIATE]"
    end
    tbl[#tbl+1]="  [IE_ARENA_NAME:Animated corpse]"
    tbl[#tbl+1]="  [SYNDROME]"
    tbl[#tbl+1]="    [SYN_CLASS:ZOMBIE]"
    tbl[#tbl+1]="    [SYN_CONCENTRATION_ADDED:1000:0]" --just in case
    tbl[#tbl+1]="    [CE_FLASH_TILE:TILE:165:3:0:0:FREQUENCY:2000:1000:START:0:ABRUPT]"
    tbl[#tbl+1]="    [CE_PHYS_ATT_CHANGE:STRENGTH:130:0:TOUGHNESS:300:1000:START:0:ABRUPT]"
    if not one_in(3) then 
        tbl[#tbl+1]="    [CE_SPEED_CHANGE:SPEED_PERC:60:START:0:ABRUPT]"
    elseif one_in(2) then 
        tbl[#tbl+1]="    [CE_SPEED_CHANGE:SPEED_PERC:20:START:0:ABRUPT]"
    end
    tbl[#tbl+1]="    [CE_ADD_TAG:NO_AGING:NOT_LIVING:OPPOSED_TO_LIFE:EXTRAVISION:NOEXERT:NOPAIN:NOBREATHE:NOSTUN:NONAUSEA:NO_DIZZINESS:NO_FEVERS:NOEMOTION:PARALYZEIMMUNE:NOFEAR:NO_EAT:NO_DRINK:NO_SLEEP:NO_PHYS_ATT_GAIN:NO_PHYS_ATT_RUST:NOTHOUGHT:NO_THOUGHT_CENTER_FOR_MOVEMENT:NO_CONNECTIONS_FOR_MOVEMENT:START:0:ABRUPT]"
    tbl[#tbl+1]="    [CE_REMOVE_TAG:HAS_BLOOD:TRANCES:MISCHIEVOUS:START:0:ABRUPT]"
    return tbl
end

function basic_lieutenant_powers(token)
    local tbl,end_tbl={},{}
    local power_index=1
    local powers={}
    local curse_number=0
    repeat
        for k,v in ipairs(interactions.powers) do
            if v.tags.lieutenant and one_in(v.rarity) then
                powers[#powers+1]=v
            end
        end
        if one_in(3) then
            curse_number=1
            if one_in(10) then
                curse_number=3
                if one_in(10) then
                    curse_number=5
                end
            end
        end
    until(curse_number~=0 or #powers>0)
    tbl,end_tbl,power_index=add_curses(tbl,end_tbl,token,curse_number,power_index,500,{
        "PAIN","BLISTERS","PARALYSIS","BLEEDING",
        "SICKEN","NECROSIS","IMPAIR","DIZZY"
    })
    for k,power in ipairs(powers) do
        local t,et=power.gen(token.."_"..power_index)
        power_index = power_index+1
        table_merge(tbl,t)
        table_merge(end_tbl,et)
    end
    return tbl,end_tbl
end

function basic_lieutenant(name,name_plural,token)
    local tbl={}
    local end_tbl={}
    tbl=split_to_lines(tbl,[[
        [I_TARGET:A:CORPSE]
        [IT_LOCATION:CONTEXT_ITEM]
        [IT_AFFECTED_CLASS:GENERAL_POISON]
        [IT_REQUIRES:FIT_FOR_RESURRECTION]
        [IT_REQUIRES:CAN_LEARN]
        [IT_FORBIDDEN:NOT_LIVING]
        [IT_MANUAL_INPUT:corpses]
        [IT_CANNOT_HAVE_SYNDROME_CLASS:WERECURSE]
        [IT_CANNOT_HAVE_SYNDROME_CLASS:VAMPCURSE]
        [IT_CANNOT_HAVE_SYNDROME_CLASS:DISTURBANCE_CURSE]
        [IT_CANNOT_HAVE_SYNDROME_CLASS:RAISED_UNDEAD]
        [IT_CANNOT_HAVE_SYNDROME_CLASS:RAISED_GHOST]
        [IT_CANNOT_HAVE_SYNDROME_CLASS:GHOUL]
    [I_EFFECT:RESURRECT]
        [IE_TARGET:A]
        [IE_IMMEDIATE]
        [IE_ARENA_NAME:Raised ]]..name..[[]
        [SYNDROME]
        [SYN_CLASS:RAISED_UNDEAD]
        [SYN_CONCENTRATION_ADDED:1000:0]//just in case
        [CE_DISPLAY_TILE:TILE:165:3:0:1:START:0:ABRUPT]
        [CE_DISPLAY_NAME:NAME:]]..name..":"..name_plural..":"..name..[[:START:0:ABRUPT]
        [CE_PHYS_ATT_CHANGE:STRENGTH:200:1000:TOUGHNESS:200:1000:START:0:ABRUPT]
        [CE_ADD_TAG:NO_AGING:NOT_LIVING:STERILE:EXTRAVISION:NOEXERT:NOPAIN:NOBREATHE:NOSTUN:NONAUSEA:NO_DIZZINESS:NO_FEVERS:NOEMOTION:PARALYZEIMMUNE:NOFEAR:NO_EAT:NO_DRINK:NO_SLEEP:NO_PHYS_ATT_GAIN:NO_PHYS_ATT_RUST:NOTHOUGHT:NO_THOUGHT_CENTER_FOR_MOVEMENT:NO_CONNECTIONS_FOR_MOVEMENT:START:0:ABRUPT]
        [CE_REMOVE_TAG:HAS_BLOOD:TRANCES:MISCHIEVOUS:START:0:ABRUPT]
    ]])
    local t,et=basic_lieutenant_powers(token)
    return table_merge(tbl,t),table_merge(end_tbl,et)
end

interactions.regional.animate=function()
    return {raws=basic_animation(true),weight=1}
end

require "generators.interactions.disturbance"

require "generators.interactions.secret"

require "generators.interactions.blessing"

require "generators.interactions.curse"

require "generators.interactions.mythical"

require "generators.interactions.item_power"