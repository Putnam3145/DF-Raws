interactions.blessing.minor.luck=function(idx)
    local tbl={}
    tbl=split_to_lines(tbl,[[
        [IS_TRIGGER_STRING_SECOND:have]
        [IS_TRIGGER_STRING_THIRD:has]
        [IS_TRIGGER_STRING:been blessed with a week's good fortune!]
    [I_TARGET:A:CREATURE]
        [IT_LOCATION:CONTEXT_CREATURE]
        [IT_MANUAL_INPUT:recipient]
    [I_EFFECT:ADD_SYNDROME]
        [IE_TARGET:A]
        [IE_IMMEDIATE]
        [SYNDROME]
            [SYN_CONCENTRATION_ADDED:1000:0]//just in case
            [CE_SKILL_ROLL_ADJUST:PERC:150:PERC_ON:50:START:0:PEAK:0:END:8400:ABRUPT]//one week

]])
    return {raws=tbl,weight=1}
end

interactions.blessing.medium.holy_item=function(idx)
    local tbl={}
    local item_names={
        WEAPON="weapon",
        SHIELD="shield",
        ARMOR="bodywear",
        PANTS="legwear",
        HELM="headwear",
        GLOVES="handwear",
        SHOES="footwear",
    }
    local i_type
    local include_article=false
    if one_in(3) then i_type="WEAPON" include_article=true
    elseif one_in(2) then i_type="SHIELD" include_article=true
    else i_type=pick_random({"ARMOR","PANTS","HELM","GLOVES","SHOES"})
    end
    tbl=split_to_lines(tbl,[[
    [IS_TRIGGER_STRING_SECOND:have]
    [IS_TRIGGER_STRING_THIRD:has]
    [IS_TRIGGER_STRING:been blessed with]]..(include_article and " a " or " ").."holy"..item_names[i_type]..[[!]
    [I_TARGET:A:CREATURE]
        [IT_LOCATION:CONTEXT_CREATURE]
        [IT_MANUAL_INPUT:recipient]
    [I_EFFECT:CREATE_ITEM]
        [IE_TARGET:A]
        [IE_IMMEDIATE]
        [IE_ITEM:100:1:]]..i_type..[[:NONE:NONE:NONE]
        [IE_ITEM_QUALITY:ARTIFACT]
]])
    return {raws=tbl,weight=1}
end

interactions.blessing.medium.improve_equipment=function(idx)
    local tbl={}
    tbl=split_to_lines(tbl,[[
        [IS_TRIGGER_STRING_SECOND:have]
        [IS_TRIGGER_STRING_THIRD:has]
        [IS_TRIGGER_STRING:been blessed with improved equipment!]
    [I_TARGET:A:CREATURE]
        [IT_LOCATION:CONTEXT_CREATURE]
        [IT_MANUAL_INPUT:recipient]
    [I_EFFECT:CHANGE_ITEM_QUALITY]
        [IE_TARGET:A]
        [IE_IMMEDIATE]
        [IE_CHANGE_QUALITY:2]
]])
    return {raws=tbl,weight=1}
end

interactions.blessing.medium.pet=function(idx)
    local tbl={}
    tbl=split_to_lines(tbl,[[
        [IS_TRIGGER_STRING_SECOND:have]
        [IS_TRIGGER_STRING_THIRD:has]
        [IS_TRIGGER_STRING:been blessed with a pet!]
    [I_TARGET:A:LOCATION]
        [IT_LOCATION:CONTEXT_LOCATION]
    [I_TARGET:B:LOCATION]
        [IT_LOCATION:RANDOM_NEARBY_LOCATION:A:5]
    [I_EFFECT:SUMMON_UNIT]
        [IE_TARGET:B]
        [IE_IMMEDIATE]
        [IE_FORBIDDEN_CREATURE_FLAG:SMALL_RACE]
        [IE_CREATURE_CASTE_FLAG:LARGE_PREDATOR]
        [IE_CREATURE_CASTE_FLAG:NATURAL_ANIMAL]
        [IE_FORBIDDEN_CREATURE_CASTE_FLAG:CANNOT_BREATHE_AIR]
        [IE_FORBIDDEN_CREATURE_CASTE_FLAG:IMMOBILE_LAND]
        [IE_FORBIDDEN_CREATURE_CASTE_FLAG:CAN_LEARN]
        [IE_FORBIDDEN_CREATURE_CASTE_FLAG:MEGABEAST]
        [IE_FORBIDDEN_CREATURE_CASTE_FLAG:SEMIMEGABEAST]
        [IE_FORBIDDEN_CREATURE_CASTE_FLAG:TITAN]
        [IE_FORBIDDEN_CREATURE_CASTE_FLAG:DEMON]
        [IE_FORBIDDEN_CREATURE_CASTE_FLAG:UNIQUE_DEMON]
        [IE_FORBIDDEN_CREATURE_CASTE_FLAG:SUPERNATURAL]
        [IE_MAKE_PET_IF_POSSIBLE]
]])
    return {raws=tbl,weight=1}
end

interactions.blessing.medium.healing=function(idx)
    local tbl={}
    tbl=split_to_lines(tbl,[[
        [IS_TRIGGER_STRING_SECOND:have]
        [IS_TRIGGER_STRING_THIRD:has]
        [IS_TRIGGER_STRING:been granted healing!]
    [I_TARGET:A:CREATURE]
        [IT_LOCATION:CONTEXT_CREATURE]
        [IT_MANUAL_INPUT:recipient]
    [I_EFFECT:ADD_SYNDROME]
        [IE_TARGET:A]
        [IE_IMMEDIATE]
        [SYNDROME]
            [SYN_CONCENTRATION_ADDED:1000:0]//just in case
            [CE_STOP_BLEEDING:SEV:100:PROB:100:START:0:PEAK:0:END:12:ABRUPT]
            [CE_CLOSE_OPEN_WOUNDS:SEV:100:PROB:100:START:0:PEAK:0:END:12:ABRUPT]
            [CE_HEAL_TISSUES:SEV:100:PROB:100:START:0:PEAK:0:END:12:ABRUPT]
            [CE_HEAL_NERVES:SEV:100:PROB:100:START:0:PEAK:0:END:12:ABRUPT]
            [CE_REDUCE_PAIN:SEV:100:PROB:100:START:0:PEAK:0:END:12:ABRUPT]
            [CE_REDUCE_SWELLING:SEV:100:PROB:100:START:0:PEAK:0:END:12:ABRUPT]
            [CE_CURE_INFECTION:SEV:100:PROB:100:START:0:PEAK:0:END:12:ABRUPT]
            [CE_REDUCE_PARALYSIS:SEV:100:PROB:100:START:0:PEAK:0:END:12:ABRUPT]
            [CE_REDUCE_DIZZINESS:SEV:100:PROB:100:START:0:PEAK:0:END:12:ABRUPT]
            [CE_REDUCE_NAUSEA:SEV:100:PROB:100:START:0:PEAK:0:END:12:ABRUPT]
            [CE_REDUCE_FEVER:SEV:100:PROB:100:START:0:PEAK:0:END:12:ABRUPT]
            [CE_REGROW_PARTS:SEV:100:PROB:100:START:0:PEAK:0:END:12:ABRUPT]

]])
    return {raws=tbl,weight=1}
end
