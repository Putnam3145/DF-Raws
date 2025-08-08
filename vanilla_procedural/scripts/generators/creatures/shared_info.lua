function add_regular_tokens(lines,options)
    if not options.normal_biological then
        lines=split_to_lines(lines,[[
[AMPHIBIOUS]
[SWIMS_INNATE]
[NONAUSEA]
[NOEXERT]
[NO_DIZZINESS]
[NOPAIN]
[NOSTUN]
]])
    end
    lines[#lines+1]="[PETVALUE:2000]"
    lines[#lines+1]="[ALL_ACTIVE]"
    lines[#lines+1]="[NOFEAR]"
    lines[#lines+1]="[NO_FEVERS]"
    if options.material_weakness then
        local matgloss=world.inorganic.get_random_inorganic(nil,"ITEMS_WEAPON","SPECIAL")
        if matgloss and matgloss ~= "NONE" then
            lines[#lines+1]="[MATERIAL_FORCE_MULTIPLIER:INORGANIC:"..matgloss..":10:1]"
            lines[#lines+1]="[GENERAL_MATERIAL_FORCE_MULTIPLIER:1:2]"
        end
    end
end

function tile_string(arg)
    return type(arg)=='string' and "'"..string.sub(arg,1,1).."'" or tostring(arg)
end

function body_size_properties(tbl,size,options)
    if size >= 100000 then
        tbl=split_to_lines(tbl,[[
[GRASSTRAMPLE:20]
[TRAPAVOID]
    ]])
    end
    if size >= 80000 then tbl[#tbl+1]="[BUILDINGDESTROYER:2]" end
end

function add_body_size(tbl,size,options)
    options=options or {}
    options.body_size=size
    tbl[#tbl+1]="[BODY_SIZE:0:0:"..tostring(size).."]"
    body_size_properties(tbl,size,options)
    return tbl
end

local pal_selection={ -- local on purpose; this shouldn't be modified
    BEAST_SNAKE_WINGS_LACY_BACK=1,
    BEAST_SNAKE_WINGS_FEATHERED_BACK=1,
    BEAST_SNAKE_WINGS_BAT_BACK=1,
    BEAST_WORM_LONG_WINGS_LACY_BACK=1,
    BEAST_WORM_LONG_WINGS_FEATHERED_BACK=1,
    BEAST_WORM_LONG_WINGS_BAT_BACK=1,
    BEAST_WORM_SHORT_WINGS_LACY_BACK=1,
    BEAST_WORM_SHORT_WINGS_FEATHERED_BACK=1,
    BEAST_WORM_SHORT_WINGS_BAT_BACK=1,
    BEAST_INSECT_WINGS_LACY_BACK=1,
    BEAST_INSECT_WINGS_FEATHERED_BACK=1,
    BEAST_INSECT_WINGS_BAT_BACK=1,
    BEAST_SPIDER_WINGS_LACY_BACK=1,
    BEAST_SPIDER_WINGS_FEATHERED_BACK=1,
    BEAST_SPIDER_WINGS_BAT_BACK=1,
    BEAST_SCORPION_WINGS_LACY_BACK=1,
    BEAST_SCORPION_WINGS_FEATHERED_BACK=1,
    BEAST_SCORPION_WINGS_BAT_BACK=1,
    BEAST_BIPEDAL_DINOSAUR_WINGS_LACY_BACK=1,
    BEAST_BIPEDAL_DINOSAUR_WINGS_FEATHERED_BACK=1,
    BEAST_BIPEDAL_DINOSAUR_WINGS_BAT_BACK=1,
    BEAST_HUMANOID_WINGS_LACY_BACK=1,
    BEAST_HUMANOID_WINGS_FEATHERED_BACK=1,
    BEAST_HUMANOID_WINGS_BAT_BACK=1,
    BEAST_FRONT_GRASP_WINGS_LACY_BACK=1,
    BEAST_FRONT_GRASP_WINGS_FEATHERED_BACK=1,
    BEAST_FRONT_GRASP_WINGS_BAT_BACK=1,
    BEAST_QUADRUPED_BULKY_WINGS_LACY_BACK=1,
    BEAST_QUADRUPED_BULKY_WINGS_FEATHERED_BACK=1,
    BEAST_QUADRUPED_BULKY_WINGS_BAT_BACK=1,
    BEAST_QUADRUPED_SLINKY_WINGS_LACY_BACK=1,
    BEAST_QUADRUPED_SLINKY_WINGS_FEATHERED_BACK=1,
    BEAST_QUADRUPED_SLINKY_WINGS_BAT_BACK=1,
    BEAST_WALRUS_WINGS_LACY_BACK=1,
    BEAST_WALRUS_WINGS_FEATHERED_BACK=1,
    BEAST_WALRUS_WINGS_BAT_BACK=1,
    BEAST_SNAKE_WINGS_FEATHERED_BACK_DECORATION_1=7,
    BEAST_SNAKE_WINGS_FEATHERED_BACK_DECORATION_2=8,
    BEAST_SNAKE_WINGS_FEATHERED_BACK_DECORATION_3=9,
    BEAST_WORM_LONG_WINGS_FEATHERED_BACK_DECORATION_1=7,
    BEAST_WORM_LONG_WINGS_FEATHERED_BACK_DECORATION_2=8,
    BEAST_WORM_LONG_WINGS_FEATHERED_BACK_DECORATION_3=9,
    BEAST_WORM_SHORT_WINGS_FEATHERED_BACK_DECORATION_1=7,
    BEAST_WORM_SHORT_WINGS_FEATHERED_BACK_DECORATION_2=8,
    BEAST_WORM_SHORT_WINGS_FEATHERED_BACK_DECORATION_3=9,
    BEAST_INSECT_WINGS_FEATHERED_BACK_DECORATION_1=7,
    BEAST_INSECT_WINGS_FEATHERED_BACK_DECORATION_2=8,
    BEAST_INSECT_WINGS_FEATHERED_BACK_DECORATION_3=9,
    BEAST_SCORPION_WINGS_FEATHERED_BACK_DECORATION_1=7,
    BEAST_SCORPION_WINGS_FEATHERED_BACK_DECORATION_2=8,
    BEAST_SCORPION_WINGS_FEATHERED_BACK_DECORATION_3=9,
    BEAST_BIPEDAL_DINOSAUR_WINGS_FEATHERED_BACK_DECORATION_1=7,
    BEAST_BIPEDAL_DINOSAUR_WINGS_FEATHERED_BACK_DECORATION_2=8,
    BEAST_BIPEDAL_DINOSAUR_WINGS_FEATHERED_BACK_DECORATION_3=9,
    BEAST_HUMANOID_WINGS_FEATHERED_BACK_DECORATION_1=7,
    BEAST_HUMANOID_WINGS_FEATHERED_BACK_DECORATION_2=8,
    BEAST_HUMANOID_WINGS_FEATHERED_BACK_DECORATION_3=9,
    BEAST_FRONT_GRASP_WINGS_FEATHERED_BACK_DECORATION_1=7,
    BEAST_FRONT_GRASP_WINGS_FEATHERED_BACK_DECORATION_2=8,
    BEAST_FRONT_GRASP_WINGS_FEATHERED_BACK_DECORATION_3=9,
    BEAST_QUADRUPED_BULKY_WINGS_FEATHERED_BACK_DECORATION_1=7,
    BEAST_QUADRUPED_BULKY_WINGS_FEATHERED_BACK_DECORATION_2=8,
    BEAST_QUADRUPED_BULKY_WINGS_FEATHERED_BACK_DECORATION_3=9,
    BEAST_QUADRUPED_SLINKY_WINGS_FEATHERED_BACK_DECORATION_1=7,
    BEAST_QUADRUPED_SLINKY_WINGS_FEATHERED_BACK_DECORATION_2=8,
    BEAST_QUADRUPED_SLINKY_WINGS_FEATHERED_BACK_DECORATION_3=9,
    BEAST_WALRUS_WINGS_FEATHERED_BACK_DECORATION_1=7,
    BEAST_WALRUS_WINGS_FEATHERED_BACK_DECORATION_2=8,
    BEAST_WALRUS_WINGS_FEATHERED_BACK_DECORATION_3=9,
    BEAST_AMORPHOUS_SHELL_BACK="shell",
    BEAST_SNAKE_SHELL_BACK="shell",
    BEAST_WORM_LONG_SHELL_BACK="shell",
    BEAST_WORM_SHORT_SHELL_BACK="shell",
    BEAST_INSECT_SHELL_BACK="shell",
    BEAST_BIPEDAL_DINOSAUR_SHELL_BACK="shell",
    BEAST_HUMANOID_SHELL_BACK="shell",
    BEAST_FRONT_GRASP_SHELL_BACK="shell",
    BEAST_WALRUS_SHELL_BACK="shell",
    BEAST_ORGANIC_AMORPHOUS_SHELL_BACK="shell",
    BEAST_ORGANIC_SNAKE_SHELL_BACK="shell",
    BEAST_ORGANIC_WORM_LONG_SHELL_BACK="shell",
    BEAST_ORGANIC_WORM_SHORT_SHELL_BACK="shell",
    BEAST_ORGANIC_INSECT_SHELL_BACK="shell",
    BEAST_ORGANIC_BIPEDAL_DINOSAUR_SHELL_BACK="shell",
    BEAST_ORGANIC_HUMANOID_SHELL_BACK="shell",
    BEAST_ORGANIC_FRONT_GRASP_SHELL_BACK="shell",
    BEAST_ORGANIC_WALRUS_SHELL_BACK="shell",
    BEAST_SCORPION_TAIL_ONE=1,
    BEAST_SCORPION_TAIL_TWO=1,
    BEAST_SCORPION_TAIL_THREE=1,
    BEAST_BIPEDAL_DINOSAUR_TAIL_ONE=1,
    BEAST_BIPEDAL_DINOSAUR_TAIL_TWO=1,
    BEAST_BIPEDAL_DINOSAUR_TAIL_THREE=1,
    BEAST_HUMANOID_TAIL_ONE=1,
    BEAST_HUMANOID_TAIL_TWO=1,
    BEAST_HUMANOID_TAIL_THREE=1,
    BEAST_FRONT_GRASP_TAIL_ONE=1,
    BEAST_FRONT_GRASP_TAIL_TWO=1,
    BEAST_FRONT_GRASP_TAIL_THREE=1,
    BEAST_QUADRUPED_BULKY_TAIL_ONE=1,
    BEAST_QUADRUPED_BULKY_TAIL_TWO=1,
    BEAST_QUADRUPED_BULKY_TAIL_THREE=1,
    BEAST_QUADRUPED_SLINKY_TAIL_ONE=1,
    BEAST_QUADRUPED_SLINKY_TAIL_TWO=1,
    BEAST_QUADRUPED_SLINKY_TAIL_THREE=1,
    BEAST_WALRUS_TAIL_ONE=1,
    BEAST_WALRUS_TAIL_TWO=1,
    BEAST_WALRUS_TAIL_THREE=1,
    BEAST_AMORPHOUS=1,
    BEAST_SNAKE=1,
    BEAST_WORM_LONG=1,
    BEAST_WORM_SHORT=1,
    BEAST_INSECT=1,
    BEAST_SPIDER=1,
    BEAST_SCORPION=1,
    BEAST_BIPEDAL_DINOSAUR=1,
    BEAST_HUMANOID=1,
    BEAST_FRONT_GRASP=1,
    BEAST_FRONT_GRASP_HEX=1,
    BEAST_FRONT_GRASP_OCT=1,
    BEAST_QUADRUPED_BULKY=1,
    BEAST_QUADRUPED_BULKY_HEX=1,
    BEAST_QUADRUPED_BULKY_OCT=1,
    BEAST_QUADRUPED_SLINKY=1,
    BEAST_QUADRUPED_SLINKY_HEX=1,
    BEAST_QUADRUPED_SLINKY_OCT=1,
    BEAST_WALRUS=1,
    BEAST_AMORPHOUS_DECORATION_1=2,
    BEAST_AMORPHOUS_DECORATION_2=3,
    BEAST_AMORPHOUS_DECORATION_3=4,
    BEAST_AMORPHOUS_DECORATION_4=5,
    BEAST_AMORPHOUS_DECORATION_5=6,
    BEAST_SNAKE_DECORATION_1=2,
    BEAST_SNAKE_DECORATION_2=3,
    BEAST_SNAKE_DECORATION_3=4,
    BEAST_SNAKE_DECORATION_4=5,
    BEAST_SNAKE_DECORATION_5=6,
    BEAST_WORM_LONG_DECORATION_1=2,
    BEAST_WORM_LONG_DECORATION_2=3,
    BEAST_WORM_LONG_DECORATION_3=4,
    BEAST_WORM_LONG_DECORATION_4=5,
    BEAST_WORM_LONG_DECORATION_5=6,
    BEAST_WORM_SHORT_DECORATION_1=2,
    BEAST_WORM_SHORT_DECORATION_2=3,
    BEAST_WORM_SHORT_DECORATION_3=4,
    BEAST_WORM_SHORT_DECORATION_4=5,
    BEAST_WORM_SHORT_DECORATION_5=6,
    BEAST_INSECT_DECORATION_1=2,
    BEAST_INSECT_DECORATION_2=3,
    BEAST_INSECT_DECORATION_3=4,
    BEAST_INSECT_DECORATION_4=5,
    BEAST_INSECT_DECORATION_5=6,
    BEAST_SPIDER_DECORATION_1=2,
    BEAST_SPIDER_DECORATION_2=3,
    BEAST_SPIDER_DECORATION_3=4,
    BEAST_SPIDER_DECORATION_4=5,
    BEAST_SPIDER_DECORATION_5=6,
    BEAST_SCORPION_DECORATION_1=2,
    BEAST_SCORPION_DECORATION_2=3,
    BEAST_SCORPION_DECORATION_3=4,
    BEAST_SCORPION_DECORATION_4=5,
    BEAST_SCORPION_DECORATION_5=6,
    BEAST_BIPEDAL_DINOSAUR_DECORATION_1=2,
    BEAST_BIPEDAL_DINOSAUR_DECORATION_2=3,
    BEAST_BIPEDAL_DINOSAUR_DECORATION_3=4,
    BEAST_BIPEDAL_DINOSAUR_DECORATION_4=5,
    BEAST_BIPEDAL_DINOSAUR_DECORATION_5=6,
    BEAST_HUMANOID_DECORATION_1=2,
    BEAST_HUMANOID_DECORATION_2=3,
    BEAST_HUMANOID_DECORATION_3=4,
    BEAST_HUMANOID_DECORATION_4=5,
    BEAST_HUMANOID_DECORATION_5=6,
    BEAST_FRONT_GRASP_DECORATION_1=2,
    BEAST_FRONT_GRASP_DECORATION_2=3,
    BEAST_FRONT_GRASP_QUAD_DECORATION_1=4,
    BEAST_FRONT_GRASP_HEX_DECORATION_1=4,
    BEAST_FRONT_GRASP_OCT_DECORATION_1=4,
    BEAST_QUADRUPED_BULKY_DECORATION_1=2,
    BEAST_QUADRUPED_BULKY_DECORATION_2=3,
    BEAST_QUADRUPED_BULKY_QUAD_DECORATION_1=4,
    BEAST_QUADRUPED_BULKY_HEX_DECORATION_1=4,
    BEAST_QUADRUPED_BULKY_OCT_DECORATION_1=4,
    BEAST_QUADRUPED_SLINKY_DECORATION_1=2,
    BEAST_QUADRUPED_SLINKY_DECORATION_2=3,
    BEAST_QUADRUPED_SLINKY_QUAD_DECORATION_1=4,
    BEAST_QUADRUPED_SLINKY_HEX_DECORATION_1=4,
    BEAST_QUADRUPED_SLINKY_OCT_DECORATION_1=4,
    BEAST_WALRUS_DECORATION_1=2,
    BEAST_WALRUS_DECORATION_2=3,
    BEAST_WALRUS_DECORATION_3=4,
    BEAST_WALRUS_DECORATION_4=5,
    BEAST_WALRUS_DECORATION_5=6,
    BEAST_SPIDER_SHELL_FRONT="shell",
    BEAST_SCORPION_SHELL_FRONT="shell",
    BEAST_QUADRUPED_BULKY_SHELL_FRONT="shell",
    BEAST_QUADRUPED_SLINKY_SHELL_FRONT="shell",
    BEAST_ORGANIC_SPIDER_SHELL_FRONT="shell",
    BEAST_ORGANIC_SCORPION_SHELL_FRONT="shell",
    BEAST_ORGANIC_QUADRUPED_BULKY_SHELL_FRONT="shell",
    BEAST_ORGANIC_QUADRUPED_SLINKY_SHELL_FRONT="shell",
    BEAST_SNAKE_TRUNK=1,
    BEAST_WORM_LONG_TRUNK=1,
    BEAST_WORM_SHORT_TRUNK=1,
    BEAST_INSECT_PROBOSCIS=1,
    BEAST_INSECT_TRUNK=1,
    BEAST_SPIDER_TRUNK=1,
    BEAST_SCORPION_TRUNK=1,
    BEAST_BIPEDAL_DINOSAUR_TRUNK=1,
    BEAST_HUMANOID_TRUNK=1,
    BEAST_FRONT_GRASP_TRUNK=1,
    BEAST_QUADRUPED_BULKY_TRUNK=1,
    BEAST_QUADRUPED_SLINKY_TRUNK=1,
    BEAST_WALRUS_TRUNK=1,
    BEAST_SNAKE_ANTENNAE=1,
    BEAST_WORM_LONG_ANTENNAE=1,
    BEAST_WORM_SHORT_ANTENNAE=1,
    BEAST_INSECT_ANTENNAE=1,
    BEAST_SPIDER_ANTENNAE=1,
    BEAST_SCORPION_ANTENNAE=1,
    BEAST_BIPEDAL_DINOSAUR_ANTENNAE=1,
    BEAST_HUMANOID_ANTENNAE=1,
    BEAST_FRONT_GRASP_ANTENNAE=1,
    BEAST_QUADRUPED_BULKY_ANTENNAE=1,
    BEAST_QUADRUPED_SLINKY_ANTENNAE=1,
    BEAST_WALRUS_ANTENNAE=1,
    BEAST_SNAKE_HORNS=1,
    BEAST_WORM_LONG_HORNS=1,
    BEAST_WORM_SHORT_HORNS=1,
    BEAST_INSECT_HORNS=1,
    BEAST_SPIDER_HORNS=1,
    BEAST_SCORPION_HORNS=1,
    BEAST_BIPEDAL_DINOSAUR_HORNS=1,
    BEAST_HUMANOID_HORNS=1,
    BEAST_FRONT_GRASP_HORNS=1,
    BEAST_QUADRUPED_BULKY_HORNS=1,
    BEAST_QUADRUPED_SLINKY_HORNS=1,
    BEAST_WALRUS_HORNS=1,
    BEAST_SNAKE_MANDIBLES=1,
    BEAST_WORM_LONG_MANDIBLES=1,
    BEAST_WORM_SHORT_MANDIBLES=1,
    BEAST_INSECT_MANDIBLES=1,
    BEAST_SPIDER_MANDIBLES=1,
    BEAST_SCORPION_MANDIBLES=1,
    BEAST_BIPEDAL_DINOSAUR_MANDIBLES=1,
    BEAST_HUMANOID_MANDIBLES=1,
    BEAST_FRONT_GRASP_MANDIBLES=1,
    BEAST_QUADRUPED_BULKY_MANDIBLES=1,
    BEAST_QUADRUPED_SLINKY_MANDIBLES=1,
    BEAST_WALRUS_MANDIBLES=1,
    BEAST_SNAKE_EYE_ONE=1,
    BEAST_SNAKE_EYE_TWO=1,
    BEAST_SNAKE_EYE_THREE=1,
    BEAST_WORM_LONG_EYE_ONE=1,
    BEAST_WORM_LONG_EYE_TWO=1,
    BEAST_WORM_LONG_EYE_THREE=1,
    BEAST_WORM_SHORT_EYE_ONE=1,
    BEAST_WORM_SHORT_EYE_TWO=1,
    BEAST_WORM_SHORT_EYE_THREE=1,
    BEAST_INSECT_EYE_ONE=1,
    BEAST_INSECT_EYE_TWO=1,
    BEAST_INSECT_EYE_THREE=1,
    BEAST_SPIDER_EYE_ONE=1,
    BEAST_SPIDER_EYE_TWO=1,
    BEAST_SPIDER_EYE_THREE=1,
    BEAST_SCORPION_EYE_ONE=1,
    BEAST_SCORPION_EYE_TWO=1,
    BEAST_SCORPION_EYE_THREE=1,
    BEAST_BIPEDAL_DINOSAUR_EYE_ONE=1,
    BEAST_BIPEDAL_DINOSAUR_EYE_TWO=1,
    BEAST_BIPEDAL_DINOSAUR_EYE_THREE=1,
    BEAST_HUMANOID_EYE_ONE=1,
    BEAST_HUMANOID_EYE_TWO=1,
    BEAST_HUMANOID_EYE_THREE=1,
    BEAST_FRONT_GRASP_EYE_ONE=1,
    BEAST_FRONT_GRASP_EYE_TWO=1,
    BEAST_FRONT_GRASP_EYE_THREE=1,
    BEAST_QUADRUPED_BULKY_EYE_ONE=1,
    BEAST_QUADRUPED_BULKY_EYE_TWO=1,
    BEAST_QUADRUPED_BULKY_EYE_THREE=1,
    BEAST_QUADRUPED_SLINKY_EYE_ONE=1,
    BEAST_QUADRUPED_SLINKY_EYE_TWO=1,
    BEAST_QUADRUPED_SLINKY_EYE_THREE=1,
    BEAST_WALRUS_EYE_ONE=1,
    BEAST_WALRUS_EYE_TWO=1,
    BEAST_WALRUS_EYE_THREE=1,
    BEAST_SNAKE_WINGS_LACY_FRONT=1,
    BEAST_SNAKE_WINGS_FEATHERED_FRONT=1,
    BEAST_SNAKE_WINGS_BAT_FRONT=1,
    BEAST_WORM_LONG_WINGS_LACY_FRONT=1,
    BEAST_WORM_LONG_WINGS_FEATHERED_FRONT=1,
    BEAST_WORM_LONG_WINGS_BAT_FRONT=1,
    BEAST_WORM_SHORT_WINGS_LACY_FRONT=1,
    BEAST_WORM_SHORT_WINGS_FEATHERED_FRONT=1,
    BEAST_WORM_SHORT_WINGS_BAT_FRONT=1,
    BEAST_INSECT_WINGS_LACY_FRONT=1,
    BEAST_INSECT_WINGS_FEATHERED_FRONT=1,
    BEAST_INSECT_WINGS_BAT_FRONT=1,
    BEAST_SPIDER_WINGS_LACY_FRONT=1,
    BEAST_SPIDER_WINGS_FEATHERED_FRONT=1,
    BEAST_SPIDER_WINGS_BAT_FRONT=1,
    BEAST_SCORPION_WINGS_LACY_FRONT=1,
    BEAST_SCORPION_WINGS_FEATHERED_FRONT=1,
    BEAST_SCORPION_WINGS_BAT_FRONT=1,
    BEAST_BIPEDAL_DINOSAUR_WINGS_LACY_FRONT=1,
    BEAST_BIPEDAL_DINOSAUR_WINGS_FEATHERED_FRONT=1,
    BEAST_BIPEDAL_DINOSAUR_WINGS_BAT_FRONT=1,
    BEAST_HUMANOID_WINGS_LACY_FRONT=1,
    BEAST_HUMANOID_WINGS_FEATHERED_FRONT=1,
    BEAST_HUMANOID_WINGS_BAT_FRONT=1,
    BEAST_FRONT_GRASP_WINGS_LACY_FRONT=1,
    BEAST_FRONT_GRASP_WINGS_FEATHERED_FRONT=1,
    BEAST_FRONT_GRASP_WINGS_BAT_FRONT=1,
    BEAST_QUADRUPED_BULKY_WINGS_LACY_FRONT=1,
    BEAST_QUADRUPED_BULKY_WINGS_FEATHERED_FRONT=1,
    BEAST_QUADRUPED_BULKY_WINGS_BAT_FRONT=1,
    BEAST_QUADRUPED_SLINKY_WINGS_LACY_FRONT=1,
    BEAST_QUADRUPED_SLINKY_WINGS_FEATHERED_FRONT=1,
    BEAST_QUADRUPED_SLINKY_WINGS_BAT_FRONT=1,
    BEAST_WALRUS_WINGS_LACY_FRONT=1,
    BEAST_WALRUS_WINGS_FEATHERED_FRONT=1,
    BEAST_WALRUS_WINGS_BAT_FRONT=1,
    BEAST_SNAKE_WINGS_FEATHERED_FRONT_DECORATION_1=7,
    BEAST_SNAKE_WINGS_FEATHERED_FRONT_DECORATION_2=8,
    BEAST_SNAKE_WINGS_FEATHERED_FRONT_DECORATION_3=9,
    BEAST_WORM_LONG_WINGS_FEATHERED_FRONT_DECORATION_1=7,
    BEAST_WORM_LONG_WINGS_FEATHERED_FRONT_DECORATION_2=8,
    BEAST_WORM_LONG_WINGS_FEATHERED_FRONT_DECORATION_3=9,
    BEAST_WORM_SHORT_WINGS_FEATHERED_FRONT_DECORATION_1=7,
    BEAST_WORM_SHORT_WINGS_FEATHERED_FRONT_DECORATION_2=8,
    BEAST_WORM_SHORT_WINGS_FEATHERED_FRONT_DECORATION_3=9,
    BEAST_INSECT_WINGS_FEATHERED_FRONT_DECORATION_1=7,
    BEAST_INSECT_WINGS_FEATHERED_FRONT_DECORATION_2=8,
    BEAST_INSECT_WINGS_FEATHERED_FRONT_DECORATION_3=9,
    BEAST_SPIDER_WINGS_FEATHERED_FRONT_DECORATION_1=7,
    BEAST_SPIDER_WINGS_FEATHERED_FRONT_DECORATION_2=8,
    BEAST_SPIDER_WINGS_FEATHERED_FRONT_DECORATION_3=9,
    BEAST_SCORPION_WINGS_FEATHERED_FRONT_DECORATION_1=7,
    BEAST_SCORPION_WINGS_FEATHERED_FRONT_DECORATION_2=8,
    BEAST_SCORPION_WINGS_FEATHERED_FRONT_DECORATION_3=9,
    BEAST_BIPEDAL_DINOSAUR_WINGS_FEATHERED_FRONT_DECORATION_1=7,
    BEAST_BIPEDAL_DINOSAUR_WINGS_FEATHERED_FRONT_DECORATION_2=8,
    BEAST_BIPEDAL_DINOSAUR_WINGS_FEATHERED_FRONT_DECORATION_3=9,
    BEAST_HUMANOID_WINGS_FEATHERED_FRONT_DECORATION_1=7,
    BEAST_HUMANOID_WINGS_FEATHERED_FRONT_DECORATION_2=8,
    BEAST_HUMANOID_WINGS_FEATHERED_FRONT_DECORATION_3=9,
    BEAST_FRONT_GRASP_WINGS_FEATHERED_FRONT_DECORATION_1=7,
    BEAST_FRONT_GRASP_WINGS_FEATHERED_FRONT_DECORATION_2=8,
    BEAST_FRONT_GRASP_WINGS_FEATHERED_FRONT_DECORATION_3=9,
    BEAST_QUADRUPED_BULKY_WINGS_FEATHERED_FRONT_DECORATION_1=7,
    BEAST_QUADRUPED_BULKY_WINGS_FEATHERED_FRONT_DECORATION_2=8,
    BEAST_QUADRUPED_BULKY_WINGS_FEATHERED_FRONT_DECORATION_3=9,
    BEAST_QUADRUPED_SLINKY_WINGS_FEATHERED_FRONT_DECORATION_1=7,
    BEAST_QUADRUPED_SLINKY_WINGS_FEATHERED_FRONT_DECORATION_2=8,
    BEAST_QUADRUPED_SLINKY_WINGS_FEATHERED_FRONT_DECORATION_3=9,
    BEAST_WALRUS_WINGS_FEATHERED_FRONT_DECORATION_1=7,
    BEAST_WALRUS_WINGS_FEATHERED_FRONT_DECORATION_2=8,
    BEAST_WALRUS_WINGS_FEATHERED_FRONT_DECORATION_3=9,
}

--[[
Missing for pal_selection (they were missing in C++ too):

BEAST_ORGANIC_SNAKE_WINGS_LACY_BACK
BEAST_ORGANIC_SNAKE_WINGS_FEATHERED_BACK
BEAST_ORGANIC_SNAKE_WINGS_BAT_BACK
BEAST_ORGANIC_WORM_LONG_WINGS_LACY_BACK
BEAST_ORGANIC_WORM_LONG_WINGS_FEATHERED_BACK
BEAST_ORGANIC_WORM_LONG_WINGS_BAT_BACK
BEAST_ORGANIC_WORM_SHORT_WINGS_LACY_BACK
BEAST_ORGANIC_WORM_SHORT_WINGS_FEATHERED_BACK
BEAST_ORGANIC_WORM_SHORT_WINGS_BAT_BACK
BEAST_ORGANIC_INSECT_WINGS_LACY_BACK
BEAST_ORGANIC_INSECT_WINGS_FEATHERED_BACK
BEAST_ORGANIC_INSECT_WINGS_BAT_BACK
BEAST_ORGANIC_SPIDER_WINGS_LACY_BACK
BEAST_ORGANIC_SPIDER_WINGS_FEATHERED_BACK
BEAST_ORGANIC_SPIDER_WINGS_BAT_BACK
BEAST_ORGANIC_SCORPION_WINGS_LACY_BACK
BEAST_ORGANIC_SCORPION_WINGS_FEATHERED_BACK
BEAST_ORGANIC_SCORPION_WINGS_BAT_BACK
BEAST_ORGANIC_BIPEDAL_DINOSAUR_WINGS_LACY_BACK
BEAST_ORGANIC_BIPEDAL_DINOSAUR_WINGS_FEATHERED_BACK
BEAST_ORGANIC_BIPEDAL_DINOSAUR_WINGS_BAT_BACK
BEAST_ORGANIC_HUMANOID_WINGS_LACY_BACK
BEAST_ORGANIC_HUMANOID_WINGS_FEATHERED_BACK
BEAST_ORGANIC_HUMANOID_WINGS_BAT_BACK
BEAST_ORGANIC_FRONT_GRASP_WINGS_LACY_BACK
BEAST_ORGANIC_FRONT_GRASP_WINGS_FEATHERED_BACK
BEAST_ORGANIC_FRONT_GRASP_WINGS_BAT_BACK
BEAST_ORGANIC_QUADRUPED_BULKY_WINGS_LACY_BACK
BEAST_ORGANIC_QUADRUPED_BULKY_WINGS_FEATHERED_BACK
BEAST_ORGANIC_QUADRUPED_BULKY_WINGS_BAT_BACK
BEAST_ORGANIC_QUADRUPED_SLINKY_WINGS_LACY_BACK
BEAST_ORGANIC_QUADRUPED_SLINKY_WINGS_FEATHERED_BACK
BEAST_ORGANIC_QUADRUPED_SLINKY_WINGS_BAT_BACK
BEAST_ORGANIC_WALRUS_WINGS_LACY_BACK
BEAST_ORGANIC_WALRUS_WINGS_FEATHERED_BACK
BEAST_ORGANIC_WALRUS_WINGS_BAT_BACK

BEAST_ORGANIC_SCORPION_TAIL_ONE
BEAST_ORGANIC_SCORPION_TAIL_TWO
BEAST_ORGANIC_SCORPION_TAIL_THREE
BEAST_ORGANIC_BIPEDAL_DINOSAUR_TAIL_ONE
BEAST_ORGANIC_BIPEDAL_DINOSAUR_TAIL_TWO
BEAST_ORGANIC_BIPEDAL_DINOSAUR_TAIL_THREE
BEAST_ORGANIC_HUMANOID_TAIL_ONE
BEAST_ORGANIC_HUMANOID_TAIL_TWO
BEAST_ORGANIC_HUMANOID_TAIL_THREE
BEAST_ORGANIC_FRONT_GRASP_TAIL_ONE
BEAST_ORGANIC_FRONT_GRASP_TAIL_TWO
BEAST_ORGANIC_FRONT_GRASP_TAIL_THREE
BEAST_ORGANIC_QUADRUPED_BULKY_TAIL_ONE
BEAST_ORGANIC_QUADRUPED_BULKY_TAIL_TWO
BEAST_ORGANIC_QUADRUPED_BULKY_TAIL_THREE
BEAST_ORGANIC_QUADRUPED_SLINKY_TAIL_ONE
BEAST_ORGANIC_QUADRUPED_SLINKY_TAIL_TWO
BEAST_ORGANIC_QUADRUPED_SLINKY_TAIL_THREE
BEAST_ORGANIC_WALRUS_TAIL_ONE
BEAST_ORGANIC_WALRUS_TAIL_TWO
BEAST_ORGANIC_WALRUS_TAIL_THREE

BEAST_ORGANIC_AMORPHOUS
BEAST_ORGANIC_SNAKE
BEAST_ORGANIC_WORM_LONG
BEAST_ORGANIC_WORM_SHORT
BEAST_ORGANIC_INSECT
BEAST_ORGANIC_SPIDER
BEAST_ORGANIC_SCORPION
BEAST_ORGANIC_BIPEDAL_DINOSAUR
BEAST_ORGANIC_HUMANOID
BEAST_ORGANIC_FRONT_GRASP
BEAST_ORGANIC_FRONT_GRASP_HEX
BEAST_ORGANIC_FRONT_GRASP_OCT
BEAST_ORGANIC_QUADRUPED_BULKY
BEAST_ORGANIC_QUADRUPED_BULKY_HEX
BEAST_ORGANIC_QUADRUPED_BULKY_OCT
BEAST_ORGANIC_QUADRUPED_SLINKY
BEAST_ORGANIC_QUADRUPED_SLINKY_HEX
BEAST_ORGANIC_QUADRUPED_SLINKY_OCT
BEAST_ORGANIC_WALRUS

BEAST_ORGANIC_SNAKE_TRUNK
BEAST_ORGANIC_WORM_LONG_TRUNK
BEAST_ORGANIC_WORM_SHORT_TRUNK
BEAST_ORGANIC_INSECT_PROBOSCIS
BEAST_ORGANIC_INSECT_TRUNK
BEAST_ORGANIC_SPIDER_TRUNK
BEAST_ORGANIC_SCORPION_TRUNK
BEAST_ORGANIC_BIPEDAL_DINOSAUR_TRUNK
BEAST_ORGANIC_HUMANOID_TRUNK
BEAST_ORGANIC_FRONT_GRASP_TRUNK
BEAST_ORGANIC_QUADRUPED_BULKY_TRUNK
BEAST_ORGANIC_QUADRUPED_SLINKY_TRUNK
BEAST_ORGANIC_WALRUS_TRUNK

BEAST_ORGANIC_SNAKE_ANTENNAE
BEAST_ORGANIC_WORM_LONG_ANTENNAE
BEAST_ORGANIC_WORM_SHORT_ANTENNAE
BEAST_ORGANIC_INSECT_ANTENNAE
BEAST_ORGANIC_SPIDER_ANTENNAE
BEAST_ORGANIC_SCORPION_ANTENNAE
BEAST_ORGANIC_BIPEDAL_DINOSAUR_ANTENNAE
BEAST_ORGANIC_HUMANOID_ANTENNAE
BEAST_ORGANIC_FRONT_GRASP_ANTENNAE
BEAST_ORGANIC_QUADRUPED_BULKY_ANTENNAE
BEAST_ORGANIC_QUADRUPED_SLINKY_ANTENNAE
BEAST_ORGANIC_WALRUS_ANTENNAE

BEAST_ORGANIC_SNAKE_HORNS
BEAST_ORGANIC_WORM_LONG_HORNS
BEAST_ORGANIC_WORM_SHORT_HORNS
BEAST_ORGANIC_INSECT_HORNS
BEAST_ORGANIC_SPIDER_HORNS
BEAST_ORGANIC_SCORPION_HORNS
BEAST_ORGANIC_BIPEDAL_DINOSAUR_HORNS
BEAST_ORGANIC_HUMANOID_HORNS
BEAST_ORGANIC_FRONT_GRASP_HORNS
BEAST_ORGANIC_QUADRUPED_BULKY_HORNS
BEAST_ORGANIC_QUADRUPED_SLINKY_HORNS
BEAST_ORGANIC_WALRUS_HORNS

BEAST_ORGANIC_SNAKE_MANDIBLES
BEAST_ORGANIC_WORM_LONG_MANDIBLES
BEAST_ORGANIC_WORM_SHORT_MANDIBLES
BEAST_ORGANIC_INSECT_MANDIBLES
BEAST_ORGANIC_SPIDER_MANDIBLES
BEAST_ORGANIC_SCORPION_MANDIBLES
BEAST_ORGANIC_BIPEDAL_DINOSAUR_MANDIBLES
BEAST_ORGANIC_HUMANOID_MANDIBLES
BEAST_ORGANIC_FRONT_GRASP_MANDIBLES
BEAST_ORGANIC_QUADRUPED_BULKY_MANDIBLES
BEAST_ORGANIC_QUADRUPED_SLINKY_MANDIBLES
BEAST_ORGANIC_WALRUS_MANDIBLES

BEAST_ORGANIC_SNAKE_EYE_ONE
BEAST_ORGANIC_SNAKE_EYE_TWO
BEAST_ORGANIC_SNAKE_EYE_THREE
BEAST_ORGANIC_WORM_LONG_EYE_ONE
BEAST_ORGANIC_WORM_LONG_EYE_TWO
BEAST_ORGANIC_WORM_LONG_EYE_THREE
BEAST_ORGANIC_WORM_SHORT_EYE_ONE
BEAST_ORGANIC_WORM_SHORT_EYE_TWO
BEAST_ORGANIC_WORM_SHORT_EYE_THREE
BEAST_ORGANIC_INSECT_EYE_ONE
BEAST_ORGANIC_INSECT_EYE_TWO
BEAST_ORGANIC_INSECT_EYE_THREE
BEAST_ORGANIC_SPIDER_EYE_ONE
BEAST_ORGANIC_SPIDER_EYE_TWO
BEAST_ORGANIC_SPIDER_EYE_THREE
BEAST_ORGANIC_SCORPION_EYE_ONE
BEAST_ORGANIC_SCORPION_EYE_TWO
BEAST_ORGANIC_SCORPION_EYE_THREE
BEAST_ORGANIC_BIPEDAL_DINOSAUR_EYE_ONE
BEAST_ORGANIC_BIPEDAL_DINOSAUR_EYE_TWO
BEAST_ORGANIC_BIPEDAL_DINOSAUR_EYE_THREE
BEAST_ORGANIC_HUMANOID_EYE_ONE
BEAST_ORGANIC_HUMANOID_EYE_TWO
BEAST_ORGANIC_HUMANOID_EYE_THREE
BEAST_ORGANIC_FRONT_GRASP_EYE_ONE
BEAST_ORGANIC_FRONT_GRASP_EYE_TWO
BEAST_ORGANIC_FRONT_GRASP_EYE_THREE
BEAST_ORGANIC_QUADRUPED_BULKY_EYE_ONE
BEAST_ORGANIC_QUADRUPED_BULKY_EYE_TWO
BEAST_ORGANIC_QUADRUPED_BULKY_EYE_THREE
BEAST_ORGANIC_QUADRUPED_SLINKY_EYE_ONE
BEAST_ORGANIC_QUADRUPED_SLINKY_EYE_TWO
BEAST_ORGANIC_QUADRUPED_SLINKY_EYE_THREE
BEAST_ORGANIC_WALRUS_EYE_ONE
BEAST_ORGANIC_WALRUS_EYE_TWO
BEAST_ORGANIC_WALRUS_EYE_THREE

BEAST_ORGANIC_SNAKE_WINGS_LACY_FRONT
BEAST_ORGANIC_SNAKE_WINGS_FEATHERED_FRONT
BEAST_ORGANIC_SNAKE_WINGS_BAT_FRONT
BEAST_ORGANIC_WORM_LONG_WINGS_LACY_FRONT
BEAST_ORGANIC_WORM_LONG_WINGS_FEATHERED_FRONT
BEAST_ORGANIC_WORM_LONG_WINGS_BAT_FRONT
BEAST_ORGANIC_WORM_SHORT_WINGS_LACY_FRONT
BEAST_ORGANIC_WORM_SHORT_WINGS_FEATHERED_FRONT
BEAST_ORGANIC_WORM_SHORT_WINGS_BAT_FRONT
BEAST_ORGANIC_INSECT_WINGS_LACY_FRONT
BEAST_ORGANIC_INSECT_WINGS_FEATHERED_FRONT
BEAST_ORGANIC_INSECT_WINGS_BAT_FRONT
BEAST_ORGANIC_SPIDER_WINGS_LACY_FRONT
BEAST_ORGANIC_SPIDER_WINGS_FEATHERED_FRONT
BEAST_ORGANIC_SPIDER_WINGS_BAT_FRONT
BEAST_ORGANIC_SCORPION_WINGS_LACY_FRONT
BEAST_ORGANIC_SCORPION_WINGS_FEATHERED_FRONT
BEAST_ORGANIC_SCORPION_WINGS_BAT_FRONT
BEAST_ORGANIC_BIPEDAL_DINOSAUR_WINGS_LACY_FRONT
BEAST_ORGANIC_BIPEDAL_DINOSAUR_WINGS_FEATHERED_FRONT
BEAST_ORGANIC_BIPEDAL_DINOSAUR_WINGS_BAT_FRONT
BEAST_ORGANIC_HUMANOID_WINGS_LACY_FRONT
BEAST_ORGANIC_HUMANOID_WINGS_FEATHERED_FRONT
BEAST_ORGANIC_HUMANOID_WINGS_BAT_FRONT
BEAST_ORGANIC_FRONT_GRASP_WINGS_LACY_FRONT
BEAST_ORGANIC_FRONT_GRASP_WINGS_FEATHERED_FRONT
BEAST_ORGANIC_FRONT_GRASP_WINGS_BAT_FRONT
BEAST_ORGANIC_QUADRUPED_BULKY_WINGS_LACY_FRONT
BEAST_ORGANIC_QUADRUPED_BULKY_WINGS_FEATHERED_FRONT
BEAST_ORGANIC_QUADRUPED_BULKY_WINGS_BAT_FRONT
BEAST_ORGANIC_QUADRUPED_SLINKY_WINGS_LACY_FRONT
BEAST_ORGANIC_QUADRUPED_SLINKY_WINGS_FEATHERED_FRONT
BEAST_ORGANIC_QUADRUPED_SLINKY_WINGS_BAT_FRONT
BEAST_ORGANIC_WALRUS_WINGS_LACY_FRONT
BEAST_ORGANIC_WALRUS_WINGS_FEATHERED_FRONT
BEAST_ORGANIC_WALRUS_WINGS_BAT_FRONT
]]

sphere_random_creature_materials={
    MUCK={
        MUD=true,
    },
    FIRE={
        ASH=true,
        FLAME=true,
    },
    DEPRAVITY={
        VOMIT=true,
    },
    DISEASE={
        VOMIT=true,
        GRIME=true,
    },
    BLIGHT={
        VOMIT=true,
        GRIME=true,
        },
    SALT={
        SALT_POWDER=true,
        SALT_SOLID=true,
        },
    ART={
        GLASS_GREEN=true,
        GLASS_CLEAR=true,
        GLASS_CRYSTAL=true,
    },
    BEAUTY={
        GLASS_GREEN=true,
        GLASS_CLEAR=true,
        GLASS_CRYSTAL=true,
    },
    RAINBOWS={
        GLASS_GREEN=true,
        GLASS_CLEAR=true,
        GLASS_CRYSTAL=true,
        },
    EARTH={
        ANY_SOIL=true,
        },
    CAVERNS={
        ANY_MINERAL=true,
    },
    MINERALS={
        ANY_MINERAL=true,
        },
    CHAOS={
        FLAME=true,
        STEAM=true,
        },
    DARKNESS={
        ASH=true,
        },
    DEATH={
        ASH=true,
        },
    COASTS={
        CORAL=true,
        },
    PLANTS={
        AMBER=true,
    },
    TREES={
        AMBER=true,
        },
    JEWELS={
        ANY_GEM=true,
        },
    METALS={
        ANY_METAL=true,
        },
    MIST={
        STEAM=true,
        },
    MOUNTAINS={
        SNOW=true,
        ICE=true,
        ANY_MINERAL=true,
        },
    NATURE={
        CORAL=true,
        AMBER=true,
        },
    OCEANS={
        WATER=true,
        SALT_SOLID=true,
        SALT_POWDER=true,
        },
    LAKES={
        WATER=true,
    },
    RAIN={
        WATER=true,
    },
    RIVERS={
        WATER=true,
    },
    STORMS={
        WATER=true,
        },
    VOLCANOS={
        FLAME=true,
        ANY_MINERAL=true,
        },
    WATER={
        SNOW=true,
        ICE=true,
        WATER=true,
        STEAM=true,
        },
    WEATHER={
        SNOW=true,
        ICE=true,
        WATER=true,
        },

}

function populate_sphere_info(tbl,options)
    if not options.spheres then return end
    options.pos_sphere_rcm={}
    for k,v in pairs(options.spheres) do
        if v then
            tbl[#tbl+1]="[SPHERE:"..k.."]"
            if options.do_sphere_rcm and sphere_random_creature_materials[k] then
                map_merge(options.pos_sphere_rcm,sphere_random_creature_materials[k])
            end
        end
    end
    if options.do_sphere_rcm and one_in(2) then -- angels only, in vanilla
        options.sphere_rcm=pick_random_pairs(options.pos_sphere_rcm)
    end
end

function add_wings_func(options)
    local desc=" It has " -- thus "has desc"
    if options.surface and tweaks[options.surface].add_wings then
        desc=desc..tweaks[options.surface].add_wings(options) -- oh no, it's recursive
    else
        desc=desc.."wings"
        if not (options.feathered_wings or options.lacy_wings or options.bat_wings) then options.feathered_wings=true end
    end
    return desc
end

tweaks={
    WINGS={
        body=function(body_str,options) add_unique(body_str,"RCP_TWO_WINGS") end,
        has_desc_func=add_wings_func,
        flavor_adj={"winged"}
    },
    WINGS_FLIGHTLESS={
        body=function(body_str,options) add_unique(body_str,"RCP_TWO_FLIGHTLESS_WINGS") end,
        has_desc_func=add_wings_func,
        flavor_adj={"winged"}
    },
    TAIL={
        body=function(body_str,options)
        --UPGRADE
            if find_in_array_part(body_str,"RCP_TAIL") then 
                remove_item(body_str,"RCP_TAIL")
                if one_in(2) then
                    body_str[#body_str+1]="RCP_2_TAILS"
                    options.tail_count=2
                else
                    body_str[#body_str+1]="RCP_3_TAILS"
                    options.tail_count=3
                end
            else
                pick_random({
                    function()
                        body_str[#body_str+1]="RCP_TAIL"
                        options.tail_count=1
                    end,
                    function()
                        body_str[#body_str+1]="RCP_2_TAILS"
                        options.tail_count=2
                    end,
                    function()
                        body_str[#body_str+1]="RCP_3_TAILS"
                        options.tail_count=3
                    end
                })()
            end
        end,
        has_desc_func=function(options)
            local tail_num,thick_tail=1,false
            --above is for graphics, not implemented yet
            local str=""
            if find_in_array_part(options.body_string,"RCP_2_TAILS") then
                str=str.." It has two "
                tail_num=2
            elseif find_in_array_part(options.body_string,"RCP_3_TAILS") then
                str=str.." It has three "
                tail_num=3
            else
                str=str.." It has a "
            end
            str=str..pick_random({
                "long, hanging",--thick_tail=true
                "long, straight",--thick_tail=true
                "long, curly",
                "short",--tail_num=0
                "stubby",--tail_num=0
                "narrow"
            })

            if tail_num>1 then str=str.." tails"
            else str=str.." tail" end
            --[[
            proc_graphics stuff that was commented out
            ]]
            return str
        end
    },
    PROBOSCIS={
        body=function(body_str,options) add_unique(body_str,"RCP_PROBOSCIS") end,
        has_desc_func=function(options) return " It has a proboscis" end
    },
    TRUNK={
        body=function(body_str,options) add_unique(body_str,"RCP_TRUNK") end,
        has_desc_func=function(options)
            return pick_random({
                function() options.pcg_layering_modifier.TRUNK="LONG" return " It has a long, swinging trunk" end,
                function() options.pcg_layering_modifier.TRUNK="SHORT" return " It has a short trunk" end,
                function() options.pcg_layering_modifier.TRUNK="FAT" return " It has a fat, bulging trunk" end,
                function() options.pcg_layering_modifier.TRUNK="TWISTING" return " It has a twisting, jointed trunk" end,
                function() options.pcg_layering_modifier.TRUNK="CURLING" return " It has a curling trunk" end,
                function() options.pcg_layering_modifier.TRUNK="KNOBBY" return " It has a knobby trunk" end,
            })()
        end
    
    },
    SHELL={
        body=function(body_str,options) add_unique(body_str,"RCP_SHELL") end,
        has_desc_func=function(options)
            return pick_random({
                " It has a round shell",
                " It has a spiral shell",
                " It has a square shell",
                " It has a knobby shell",
                " It has an enormous shell",
                " It has a broad shell",
            })
        end
    },
    ANTENNAE={
        body=function(body_str,options) add_unique(body_str,"RCP_ANTENNAE") end,
        has_desc_func=function(options)
            return pick_random({
                function() options.pcg_layering_modifier.ANTENNA="LONG" return " It has a pair of long antennae" end,
                function() options.pcg_layering_modifier.ANTENNA="FAN" return " It has a pair of fan-like antennae" end,
                function() options.pcg_layering_modifier.ANTENNA="SPINDLY" return " It has a pair of spindly antennae" end,
                function() options.pcg_layering_modifier.ANTENNA="SQUAT" return " It has a pair of squat antennae" end,
                function() options.pcg_layering_modifier.ANTENNA="BRANCHING" return " It has a pair of branching antennae" end,
                function() options.pcg_layering_modifier.ANTENNA="KNOBBING" return " It has a pair of knobby antennae" end,
            })()
        end
    },
    HEAD_HORNS={
        body=function(body_str,options)
            local amt=trandom(4)+1
            add_unique(body_str,"RCP_"..tostring(amt).."_HEAD_HORN"..((amt>1) and "S" or ""))
        end,
        has_desc_func=function(options)
            local horn_num=1
            local str=" It has "
            if find_in_array_part(options.body_string,"RCP_2_HEAD_HORNS") then
                str=str.."two "
                horn_num=2
            elseif find_in_array_part(options.body_string,"RCP_2_HEAD_HORNS") then
                str=str.."three "
                horn_num=3
            elseif find_in_array_part(options.body_string,"RCP_2_HEAD_HORNS") then
                str=str.."four "
                horn_num=4
            else
                str=str.."a "
            end
            str=str..pick_random({
                function() options.pcg_layering_modifier.HORN="LONG_SPIRAL" return "long, spiral" end,
                function() options.pcg_layering_modifier.HORN="LONG_CURVING" return " long, curving" end,
                function() options.pcg_layering_modifier.HORN="SHORT" return "short" end,
                function() options.pcg_layering_modifier.HORN="STUBBY" return "stubby" end,
                function() options.pcg_layering_modifier.HORN="BROAD" return "broad" end,
                function() options.pcg_layering_modifier.HORN="LONG_STRAIGHT" return "long, straight" end,
            })()
            if horn_num>1 then
                str=str.." horns"
            else
                str=str.." horn"
            end
            options.pcg_layering_modifier.horn_count=horn_num
            return str
        end,
        flavor_adj={"skinless"}
    },
    LARGE_MANDIBLES={
        body=function(body_str,options) add_unique(body_str,"RCP_LARGE_MANDIBLES") end,
        has_desc_func=function(options) return " It has large mandibles" end
    },
    NO_EYES={
        body=function(body_str,options) options.eyes=false end,
        adj="eyeless",
        flavor_adj={"eyeless","blind"}
    },
    ONE_EYE={
        body=function(body_str,options)
            if options.eyes then
                body_str[#body_str+1]="RCP_1_EYE"
                options.eye_count=1
                options.pcg_layering[options.pcg_layering_base.."_EYE_ONE"]=true
            end
        end,
        adj="one-eyed",
        flavor_adj={"one-eyed"}
    },
    TWO_EYES={
        body=function(body_str,options)
            if options.eyes then
                body_str[#body_str+1]="RCP_2_EYES"
                options.eye_count=2
                options.pcg_layering[options.pcg_layering_base.."_EYE_TWO"]=true
            end
        end
    },
    THREE_EYES={
        body=function(body_str,options)
            if options.eyes then
                body_str[#body_str+1]="RCP_3_EYES"
                options.eye_count=3
                options.pcg_layering[options.pcg_layering_base.."_EYE_THREE"]=true
            end
        end,
        adj="three-eyed",
        flavor_adj={"three-eyed"}
    },
    BEAK_MISSING={
        body=function(body_str,options) options.beak,options.mouth=false,false end,
        adj="beakless",
    },
    NOSE_MISSING={
        body=function(body_str,options) options.nose=false end,
        adj="noseless",
    },
    LIDLESS_EYES={
        body=function(body_str,options) options.eyelids=false end,
        with_desc="with lidless eyes",
    },
    SKINLESS={body=function(body_str,options) options.eyelids,options.cheeks,options.throat=false,false,false end,
        surface=function(lines,options)
            options.pcg_layering_modifier.SURFACE_SKINLESS=true
            lines[#lines+1]="[BODY_DETAIL_PLAN:STANDARD_MATERIALS]"
            lines[#lines+1]="[REMOVE_MATERIAL:HAIR]"
            lines[#lines+1]="[REMOVE_MATERIAL:SKIN]"
            lines[#lines+1]="[BODY_DETAIL_PLAN:STANDARD_TISSUES]"
            lines[#lines+1]="[REMOVE_TISSUE:HAIR]"
            lines[#lines+1]="[REMOVE_TISSUE:SKIN]"
        end,
        adj="skinless",
    },
    HAIR={
        surface=function(lines,options)
            options.pcg_layering_modifier.SURFACE_FUR=true
            lines[#lines+1]="[BODY_DETAIL_PLAN:STANDARD_MATERIALS]"
            if random_creature_class[options.r_class].material_template then
                lines[#lines+1]="[USE_MATERIAL_TEMPLATE:"..random_creature_class[options.r_class].material_template.."]"
            end
            lines[#lines+1]="[BODY_DETAIL_PLAN:STANDARD_TISSUES]"
            if random_creature_class[options.r_class].tissue_template then
                lines[#lines+1]="[USE_TISSUE_TEMPLATE:"..random_creature_class[options.r_class].tissue_template.."]"
            end
        end,
        color_surf="HAIR",
        adj="hairy",
        add_wings=function(options)
            options.bat_wings=true
            options.lacy_wings=false
            options.feathered_wings=false
            return "thin wings of stretched skin"
        end,
        color_desc=function(options)
            return ". Its "..world.descriptor.color[options.clp.color[1]].name.." hair is "..pick_random({
                "long and shaggy",
                "very curly",
                "short and even",
                "patchy",
                "unkempt",
                "long and straight",
                "long and wavy"
            })
        end
    },
    FEATHERS={surface=function(lines,options)
            options.pcg_layering_modifier.SURFACE_FEATHERS=true
            lines[#lines+1]="[BODY_DETAIL_PLAN:STANDARD_MATERIALS]"
            lines[#lines+1]="[REMOVE_MATERIAL:HAIR]"
            lines[#lines+1]="[USE_MATERIAL_TEMPLATE:FEATHER:FEATHER_TEMPLATE]"
            if random_creature_class[options.r_class].material_template then
                lines[#lines+1]="[USE_MATERIAL_TEMPLATE:"..random_creature_class[options.r_class].material_template.."]"
            end
            lines[#lines+1]="[BODY_DETAIL_PLAN:STANDARD_TISSUES]"
            lines[#lines+1]="[REMOVE_TISSUE:HAIR]"
            lines[#lines+1]="[USE_TISSUE_TEMPLATE:FEATHER:FEATHER_TEMPLATE]"
            if random_creature_class[options.r_class].tissue_template then
                lines[#lines+1]="[USE_TISSUE_TEMPLATE:"..random_creature_class[options.r_class].tissue_template.."]"
            end
        end,
        color_surf="FEATHER",
        adj="feathered",
        add_wings=function(options)
            options.bat_wings=false
            options.lacy_wings=false
            options.feathered_wings=true
            return options.btc2=="FEATHERS" and "wings" or "feathered wings"
        end,
        color_desc=function(options)
            return ". Its "..world.descriptor.color[options.clp.color[1]].name.." feathers are "..pick_random({
                "fluffed-out",
                "downy",
                "long and broad",
                "long and sparse",
                "patchy",
                "long and narrow",
            })
        end
    },
    SCALES={surface=function(lines,options)
            options.pcg_layering_modifier.SURFACE_SCALES=true
            lines[#lines+1]="[BODY_DETAIL_PLAN:STANDARD_MATERIALS]"
            if options.r_class~="FLESHY" then lines[#lines+1]="[REMOVE_MATERIAL:SKIN]" end
            lines[#lines+1]="[REMOVE_MATERIAL:HAIR]"
            lines[#lines+1]="[USE_MATERIAL_TEMPLATE:SCALE:SCALE_TEMPLATE]"
            if random_creature_class[options.r_class].material_template then
                lines[#lines+1]="[USE_MATERIAL_TEMPLATE:"..random_creature_class[options.r_class].material_template.."]"
            end
            lines[#lines+1]="[BODY_DETAIL_PLAN:STANDARD_TISSUES]"
            if options.r_class~="FLESHY" then lines[#lines+1]="[REMOVE_TISSUE:SKIN]" end
            lines[#lines+1]="[REMOVE_TISSUE:HAIR]"
            lines[#lines+1]="[USE_TISSUE_TEMPLATE:SCALE:SCALE_TEMPLATE]"
            if random_creature_class[options.r_class].tissue_template then
                lines[#lines+1]="[USE_TISSUE_TEMPLATE:"..random_creature_class[options.r_class].tissue_template.."]"
            end
        end,
        color_surf="SCALE",
        adj="scaly",
        add_wings=function(options)
            options.bat_wings=true
            options.lacy_wings=false
            options.feathered_wings=false
            return "thin wings of stretched skin"
        end,
        color_desc=function(options)
            return ". Its "..world.descriptor.color[options.clp.color[1]].name.." scales are "..pick_random({
                "small",
                "large",
                "round",
                "blocky",
                "jagged",
                "oval-shaped",
            }).." and "..pick_random({
                "overlapping",
                "set far apart",
                "close-set"
            })
        end
    },
    SKIN_BONES={surface=function(lines,options)
            options.pcg_layering_modifier.SURFACE_SKIN=true
            lines[#lines+1]="[BODY_DETAIL_PLAN:STANDARD_MATERIALS]"
            lines[#lines+1]="[REMOVE_MATERIAL:HAIR]"
            lines[#lines+1]="[BODY_DETAIL_PLAN:STANDARD_TISSUES]"
            lines[#lines+1]="[REMOVE_TISSUE:HAIR]"
        end,
        color_surf="SKIN",
        adj="fleshy",
        add_wings=function(options)
            options.bat_wings=true
            options.lacy_wings=false
            options.feathered_wings=false
            return "thin wings of stretched skin"
        end,
        color_desc=function(options)
            return ". Its "..world.descriptor.color[options.clp.color[1]].name.." skin is "..pick_random({
                "waxy",
                "leathery",
                "warty",
                "sleek and smooth",
                "rough and cracked",
                "wrinkled",
            })
        end
    },
    SKIN={surface=function(lines,options)
        options.pcg_layering_modifier.SURFACE_SKIN=true
            lines[#lines+1]="[BODY_DETAIL_PLAN:STANDARD_MATERIALS]"
            lines[#lines+1]="[REMOVE_MATERIAL:HAIR]"
            lines[#lines+1]="[REMOVE_MATERIAL:BONE]"
            lines[#lines+1]="[BODY_DETAIL_PLAN:STANDARD_TISSUES]"
            lines[#lines+1]="[REMOVE_TISSUE:HAIR]"
            lines[#lines+1]="[REMOVE_TISSUE:BONE]"
        end,
        color_surf="SKIN",
        adj="fleshy",
        add_wings=function(options)
            options.bat_wings=true
            options.lacy_wings=false
            options.feathered_wings=false
            return "thin wings of stretched skin"
        end,
        color_desc=function(options)
            return ". Its "..world.descriptor.color[options.clp.color[1]].name.." skin is "..pick_random({
                "waxy",
                "leathery",
                "warty",
                "sleek and smooth",
                "rough and cracked",
                "wrinkled",
            })
        end
    },
    EXOSKELETON={surface=function(lines,options)
            options.pcg_layering_modifier.SURFACE_SKIN=true
            lines[#lines+1]="[BODY_DETAIL_PLAN:STANDARD_MATERIALS]"
            lines[#lines+1]="[REMOVE_MATERIAL:HAIR]"
            lines[#lines+1]="[REMOVE_MATERIAL:SKIN]"
            lines[#lines+1]="[USE_MATERIAL_TEMPLATE:CHITIN:CHITIN_TEMPLATE]"
            lines[#lines+1]="[BODY_DETAIL_PLAN:STANDARD_TISSUES]"
            lines[#lines+1]="[REMOVE_TISSUE:HAIR]"
            lines[#lines+1]="[REMOVE_TISSUE:BONE]"
            lines[#lines+1]="[USE_TISSUE_TEMPLATE:CHITIN:CHITIN_TEMPLATE]"
        end,
        color_surf="CHITIN",
        adj="armored",
        add_wings=function(options)
            options.bat_wings=false
            options.lacy_wings=true
            options.feathered_wings=false
            return "lacy wings"
        end,
        color_desc=function(options)
            return ". Its "..world.descriptor.color[options.clp.color[1]].name.." exoskeleton is "..pick_random({
                "waxy",
                "leathery",
                "warty",
                "sleek and smooth",
                "rough and cracked",
                "wrinkled",
            })
        end
    },
    SIX_LEGGED={
        adj="six-legged",
    },
    EIGHT_LEGGED={
        adj="eight-legged",
    },
    MAKE_HUMANOID={
        form_desc="in humanoid form",
        twisted_desc="twisted into humanoid form"
    },
    RIBS_EXTERNAL={
        body=function(body_string,options)
            options.pcg_layering_modifier.EXTERNAL_RIBS=true
        end,
        with_desc="with external ribs"
    }
}

secreting_surfaces={
    HAIR="SKIN",
    FEATHERS="SKIN",
    SCALES="SCALE",
    EXOSKELETON="CHITIN",
    SKIN="SKIN",
    SKIN_BONES="SKIN",
}

local function inorganic_option_fill(options)
    options.name_mat=options.name_mat or {}
    options.tok1="INORGANIC"
    options.tok2=options.matgloss
    local inorg=world.inorganic.inorganic[options.matgloss]
    options.post_mat_adj="composed of "
    if inorg.flags.SOIL then
        options.st_tok="SOLID_POWDER"
    else
        options.st_tok="SOLID"
    end
    options.name_mat[#options.name_mat+1]=inorg.material.name[options.st_tok]
    options.post_mat_adj=options.post_mat_adj..inorg.material.adj[options.st_tok]
    options.color_f=inorg.material.color_f
    options.color_b=0
    options.color_br=inorg.material.color_br
end

random_creature_material={
    ANY_MINERAL={
        matgloss=function(options)
            return world.inorganic.get_random_inorganic(nil,"IS_STONE","SPECIAL")
        end,
        option_sets=inorganic_option_fill,
    },
    ANY_SOIL={
        matgloss=function(options)
            return world.inorganic.get_random_inorganic("SOIL",nil,"SPECIAL")
        end,
        option_sets=function(options) 
            inorganic_option_fill(options)
            options.odor_string="soil"
            options.odor_level=90
        end,
    },
    ANY_GEM={
        matgloss=function(options)
            return world.inorganic.get_random_inorganic(nil,"IS_GEM","SPECIAL")
        end,
        option_sets=inorganic_option_fill,
    },
    ANY_METAL={
        matgloss=function(options)
            return world.inorganic.get_random_inorganic(nil,"IS_METAL","SPECIAL")
        end,
        option_sets=inorganic_option_fill,
    },
    ASH={
        option_sets=function(options)
            options.name_mat=options.name_mat or {}
            options.tok1="ASH"
            options.st_tok="SOLID_POWDER"
            options.name_mat[#options.name_mat+1]="ash"
            options.name_mat[#options.name_mat+1]="shadow"
            options.name_mat[#options.name_mat+1]="soot"
            options.name_mat[#options.name_mat+1]="embers"
            options.name_mat[#options.name_mat+1]="cinders"
            options.post_mat_adj="composed of ash"
            options.intangible=true
            options.flavor_adj=options.flavor_adj or {}
            options.flavor_adj[#options.flavor_adj+1]="gray"
            options.flavor_adj[#options.flavor_adj+1]="shade"
            options.color_f=0
            options.color_b=0
            options.color_br=1
            options.odor_string="soot"
            options.odor_level=90
        end
    },
    MUD={
        option_sets=function(options)
            options.name_mat=options.name_mat or {}
            options.tok1="MUD"
            options.st_tok="SOLID"
            options.name_mat[#options.name_mat+1]="mud"
            options.name_mat[#options.name_mat+1]="sludge"
            options.name_mat[#options.name_mat+1]="muck"
            options.post_mat_adj="composed of mud"
            options.flavor_adj=options.flavor_adj or {}
            options.flavor_adj[#options.flavor_adj+1]="brown"
            options.flavor_adj[#options.flavor_adj+1]="slick"
            options.flavor_adj[#options.flavor_adj+1]="quagmire"
            options.color_f=6
            options.color_b=0
            options.color_br=0
            options.odor_string="mud"
            options.odor_level=90
        end
    },
    VOMIT={
        option_sets=function(options)
            options.name_mat=options.name_mat or {}
            options.tok1="VOMIT"
            options.st_tok="SOLID"
            options.name_mat[#options.name_mat+1]="vomit"
            options.post_mat_adj="composed of vomit"
            options.flavor_adj=options.flavor_adj or {}
            options.flavor_adj[#options.flavor_adj+1]="green"
            options.color_f=2
            options.color_b=0
            options.color_br=0
            options.pref_str = options.pref_str or {}
            options.pref_str[#options.pref_str+1]="disgusting appearance"
            options.odor_string="vomit"
            options.odor_level=90
        end
    },
    SALT_POWDER={
        option_sets=function(options)
            options.name_mat=options.name_mat or {}
            options.tok1="SALT"
            options.st_tok="SOLID_POWDER"
            options.name_mat[#options.name_mat+1]="salt"
            options.name_mat[#options.name_mat+1]="brine"
            options.post_mat_adj="composed of salt"
            options.intangible=true
            options.flavor_adj=options.flavor_adj or {}
            options.flavor_adj[#options.flavor_adj+1]="gray"
            options.flavor_adj[#options.flavor_adj+1]="white"
            options.color_f=7
            options.color_b=0
            options.color_br=1
        end
    },
    GRIME={
        option_sets=function(options)
            options.name_mat=options.name_mat or {}
            options.tok1="GRIME"
            options.st_tok="SOLID"
            options.name_mat[#options.name_mat+1]="filth"
            options.name_mat[#options.name_mat+1]="grime"
            options.post_mat_adj="composed of grime and filth"
            options.flavor_adj=options.flavor_adj or {}
            options.flavor_adj[#options.flavor_adj+1]="waste"
            options.color_f=6
            options.color_b=0
            options.color_br=0
            options.odor_string="filth"
            options.odor_level=90
        end
    },
    SNOW={
        option_sets=function(options)
            options.name_mat=options.name_mat or {}
            options.tok1="WATER"
            options.st_tok="SOLID_POWDER"
            options.fixed_temp=9990
            options.name_mat[#options.name_mat+1]="snow"
            options.post_mat_adj="composed of snow"
            options.intangible=true
            options.flavor_adj=options.flavor_adj or {}
            options.flavor_adj[#options.flavor_adj+1]="white"
            options.flavor_adj[#options.flavor_adj+1]="blizzard"
            options.flavor_adj[#options.flavor_adj+1]="slush"
            options.flavor_adj[#options.flavor_adj+1]="sleet"
            options.potential_end_phrase=options.potential_end_phrase or {}
            options.potential_end_phrase[#options.potential_end_phrase+1]=" of tears"
            options.color_f=7
            options.color_b=0
            options.color_br=1
        end
    },
    WATER={
        option_sets=function(options)
            options.name_mat=options.name_mat or {}
            options.tok1="WATER"
            options.st_tok="LIQUID"
            options.name_mat[#options.name_mat+1]="water"
            options.name_mat[#options.name_mat+1]="rain"
            options.post_mat_adj="composed of water"
            options.flavor_adj=options.flavor_adj or {}
            options.flavor_adj[#options.flavor_adj+1]="flood"
            options.flavor_adj[#options.flavor_adj+1]="tear"
            options.flavor_adj[#options.flavor_adj+1]="of tears"
            options.color_f=1
            options.color_b=0
            options.color_br=1
        end
    },
    STEAM={
        option_sets=function(options)
            options.name_mat=options.name_mat or {}
            options.tok1="WATER"
            options.st_tok="GAS"
            options.fixed_temp=10200
            options.name_mat[#options.name_mat+1]="steam"
            options.post_mat_adj="composed of steam"
            options.intangible=true
            options.flavor_adj=options.flavor_adj or {}
            options.flavor_adj[#options.flavor_adj+1]="boiling"
            options.color_f=7
            options.color_b=0
            options.color_br=1
        end
    },
    FLAME={
        option_sets=function(options)
            options.name_mat=options.name_mat or {}
            options.mat_temp1="FLAME"
            options.mat_temp2="FLAME_TEMPLATE"
            options.tok1="LOCAL_CREATURE_MAT"
            options.tok2="FLAME"
            options.st_tok="SOLID_POWDER"
            options.fixed_temp=25000
            options.name_mat[#options.name_mat+1]="flame"
            options.name_mat[#options.name_mat+1]="fire"
            options.post_mat_adj="composed of flame"
            options.intangible=true
            options.fire_mat=true
            options.flavor_adj=options.flavor_adj or {}
            options.flavor_adj[#options.flavor_adj+1]="red"
            options.flavor_adj[#options.flavor_adj+1]="inferno"
            options.flavor_adj[#options.flavor_adj+1]="flare"
            options.flavor_adj[#options.flavor_adj+1]="flash"
            options.flavor_adj[#options.flavor_adj+1]="flaming"
            options.flavor_adj[#options.flavor_adj+1]="burning"
            options.flavor_adj[#options.flavor_adj+1]="scorching"
            options.color_f=4
            options.color_b=0
            options.color_br=1
            options.odor_string="smoke"
            options.odor_level=90
        end
    },
    AMBER={
        option_sets=function(options)
            options.name_mat=options.name_mat or {}
            options.tok1="AMBER"
            options.st_tok="SOLID"
            options.name_mat[#options.name_mat+1]="amber"
            options.post_mat_adj="composed of amber"
            options.color_f=6
            options.color_b=0
            options.color_br=1
        end
    },
    CORAL={
        option_sets=function(options)
            options.name_mat=options.name_mat or {}
            options.tok1="CORAL"
            options.st_tok="SOLID"
            options.name_mat[#options.name_mat+1]="amber"
            options.post_mat_adj="composed of coral"
            options.color_f=7
            options.color_b=0
            options.color_br=1
        end
    },
    GLASS_GREEN={
        option_sets=function(options)
            options.name_mat=options.name_mat or {}
            options.tok1="GLASS_GREEN"
            options.st_tok="SOLID"
            options.name_mat[#options.name_mat+1]="glass"
            options.post_mat_adj="composed of green glass"
            options.color_f=2
            options.color_b=0
            options.color_br=0
        end
    },
    GLASS_CLEAR={
        option_sets=function(options)
            options.name_mat=options.name_mat or {}
            options.tok1="GLASS_CLEAR"
            options.st_tok="SOLID"
            options.name_mat[#options.name_mat+1]="glass"
            options.post_mat_adj="composed of clear glass"
            options.color_f=3
            options.color_b=0
            options.color_br=0
        end
    },
    GLASS_CRYSTAL={
        option_sets=function(options)
            options.name_mat=options.name_mat or {}
            options.tok1="GLASS_CRYSTAL"
            options.st_tok="SOLID"
            options.name_mat[#options.name_mat+1]="glass"
            options.post_mat_adj="composed of crystal glass"
            options.color_f=7
            options.color_b=0
            options.color_br=1
        end
    },
    CHARCOAL={
        option_sets=function(options)
            options.name_mat=options.name_mat or {}
            options.tok1="COAL"
            options.tok2="CHARCOAL"
            options.st_tok="SOLID"
            options.name_mat[#options.name_mat+1]="coal"
            options.post_mat_adj="composed of charcoal"
            options.flavor_adj=options.flavor_adj or {}
            options.flavor_adj[#options.flavor_adj+1]="black"
            options.color_f=0
            options.color_b=0
            options.color_br=1
            options.odor_string="soot"
            options.odor_level=90
        end
    },
    COKE={
        option_sets=function(options)
            options.name_mat=options.name_mat or {}
            options.tok1="COAL"
            options.tok2="COKE"
            options.st_tok="SOLID"
            options.name_mat[#options.name_mat+1]="coal"
            options.post_mat_adj="composed of coke"
            options.flavor_adj=options.flavor_adj or {}
            options.flavor_adj[#options.flavor_adj+1]="black"
            options.color_f=0
            options.color_b=0
            options.color_br=1
            options.odor_string="soot"
            options.odor_level=90
        end
    },
    SALT_SOLID={
        option_sets=function(options)
            options.name_mat=options.name_mat or {}
            options.tok1="SALT"
            options.st_tok="SOLID"
            options.name_mat[#options.name_mat+1]="salt"
            options.name_mat[#options.name_mat+1]="brine"
            options.post_mat_adj="composed of solid salt"
            options.flavor_adj=options.flavor_adj or {}
            options.flavor_adj[#options.flavor_adj+1]="white"
            options.color_f=7
            options.color_b=0
            options.color_br=1
        end
    },
    ICE={
        option_sets=function(options)
            options.name_mat=options.name_mat or {}
            options.tok1="WATER"
            options.st_tok="SOLID"
            options.fixed_temp=9990
            options.name_mat[#options.name_mat+1]="ice"
            options.post_mat_adj="composed of ice"
            options.flavor_adj=options.flavor_adj or {}
            options.flavor_adj[#options.flavor_adj+1]="white"
            options.color_f=7
            options.color_b=0
            options.color_br=1
        end
    },

}

insubstantial_materials={
    ASH=true,
    SALT_POWDER=true,
    SNOW=true,
    STEAM=true,
    FLAME=true
}

random_creature_class={
    MAMMAL={
        features={
            eyes=true,
            nose=true,
            cheeks=true,
            lungs=true,
            heart=true,
            guts=true,
            throat=true,
            spine=true,
            neck=true,
            brain=true,
            skull=true,
            mouth=true,
            teeth=true,
            ribs=true,
            eyelids=true,
            tongue=true,
            blood=true
        },
        tweaks={
            "FEATHERS",
            "SCALES",
        },
        evil_tweaks={
            "SKINLESS",
        },
        good_tweaks={},
        surface="HAIR",
        body_plan=function(lines,options)
        if options.btc2=="SKINLESS" then
            lines[#lines+1]="[BODY_DETAIL_PLAN:VERTEBRATE_TISSUE_LAYERS:NONE:FAT:MUSCLE:BONE:CARTILAGE]"
        elseif options.btc2=="SCALES" then
            lines[#lines+1]="[BODY_DETAIL_PLAN:VERTEBRATE_TISSUE_LAYERS:SCALE:FAT:MUSCLE:BONE:CARTILAGE]"
        else lines[#lines+1]="[BODY_DETAIL_PLAN:VERTEBRATE_TISSUE_LAYERS:SKIN:FAT:MUSCLE:BONE:CARTILAGE]" end
        lines[#lines+1]="[BODY_DETAIL_PLAN:STANDARD_HEAD_POSITIONS]"
        lines[#lines+1]="[BODY_DETAIL_PLAN:HUMANOID_HEAD_POSITIONS]"
        lines[#lines+1]="[BODY_DETAIL_PLAN:HUMANOID_RIBCAGE_POSITIONS]"
        lines[#lines+1]="[BODY_DETAIL_PLAN:HUMANOID_RELSIZES]"
        lines[#lines+1]="[USE_MATERIAL_TEMPLATE:SINEW:SINEW_TEMPLATE]"
        lines[#lines+1]="[TENDONS:LOCAL_CREATURE_MAT:SINEW:200]"
        lines[#lines+1]="[LIGAMENTS:LOCAL_CREATURE_MAT:SINEW:200]"
        lines[#lines+1]="[HAS_NERVES]"
        end
        },
    CHITIN_EXO={
        features={
            eyes=true,
            heart=true,
            guts=true,
            brain=true,
            mouth=true,
            ichor=true
        },
        tweaks={
            "HAIR",
            "FEATHERS",
            "SCALES",
        },
        evil_tweaks={},
        good_tweaks={},
        surface="EXOSKELETON",
        material_template="CHITIN:CHITIN_TEMPLATE", -- while these are identical for all vanilla RCCs, it need not be so
        tissue_template="CHITIN:CHITIN_TEMPLATE",
        body_plan=function(lines,options)
            lines[#lines+1]="[BODY_DETAIL_PLAN:EXOSKELETON_TISSUE_LAYERS:CHITIN:FAT:MUSCLE]"
            lines[#lines+1]="[BODY_DETAIL_PLAN:STANDARD_HEAD_POSITIONS]"
            lines[#lines+1]="[BODY_DETAIL_PLAN:HUMANOID_HEAD_POSITIONS]"
            lines[#lines+1]="[BODY_DETAIL_PLAN:HUMANOID_RELSIZES]"
            lines[#lines+1]="[USE_MATERIAL_TEMPLATE:SINEW:SINEW_TEMPLATE]"
            lines[#lines+1]="[TENDONS:LOCAL_CREATURE_MAT:SINEW:200]"
            lines[#lines+1]="[LIGAMENTS:LOCAL_CREATURE_MAT:SINEW:200]"
            lines[#lines+1]="[HAS_NERVES]"
        end
        },
    FLESHY={
        features={
            heart=true,
            guts=true,
            brain=true,
            mouth=true,
            ichor=true
        },
        tweaks={
            "HAIR",
            "FEATHERS",
            "SCALES",
        },
        evil_tweaks={
        },
        good_tweaks={},
        surface="SKIN",
        body_plan=function(lines,options)
            lines[#lines+1]="[BODY_DETAIL_PLAN:EXOSKELETON_TISSUE_LAYERS:SKIN:FAT:MUSCLE]"
            lines[#lines+1]="[HAS_NERVES]"
        end,
        },
    AMPHIBIAN={
        features={
            eyes=true,
            lungs=true,
            heart=true,
            guts=true,
            throat=true,
            spine=true,
            neck=true,
            brain=true,
            skull=true,
            mouth=true,
            ribs=true,
            eyelids=true,
            tongue=true,
            blood=true
        },
        tweaks={
            "HAIR",
            "FEATHERS",
            "SCALES",
        },
        evil_tweaks={
            "SKINLESS",
        },
        good_tweaks={},
        surface="SKIN_BONES",
        body_plan=function(lines,options)
            if options.btc2=="SKINLESS" then
                lines[#lines+1]="[BODY_DETAIL_PLAN:VERTEBRATE_TISSUE_LAYERS:NONE:FAT:MUSCLE:BONE:CARTILAGE]"
            elseif options.btc2=="SCALES" then
                lines[#lines+1]="[BODY_DETAIL_PLAN:VERTEBRATE_TISSUE_LAYERS:SCALE:FAT:MUSCLE:BONE:CARTILAGE]"
            else lines[#lines+1]="[BODY_DETAIL_PLAN:VERTEBRATE_TISSUE_LAYERS:SKIN:FAT:MUSCLE:BONE:CARTILAGE]" end
            lines[#lines+1]="[BODY_DETAIL_PLAN:STANDARD_HEAD_POSITIONS]"
            lines[#lines+1]="[BODY_DETAIL_PLAN:HUMANOID_HEAD_POSITIONS]"
            lines[#lines+1]="[BODY_DETAIL_PLAN:HUMANOID_RIBCAGE_POSITIONS]"
            lines[#lines+1]="[BODY_DETAIL_PLAN:HUMANOID_RELSIZES]"
            lines[#lines+1]="[USE_MATERIAL_TEMPLATE:SINEW:SINEW_TEMPLATE]"
            lines[#lines+1]="[TENDONS:LOCAL_CREATURE_MAT:SINEW:200]"
            lines[#lines+1]="[LIGAMENTS:LOCAL_CREATURE_MAT:SINEW:200]"
            lines[#lines+1]="[HAS_NERVES]"
        end,
        },
    REPTILE={
        features={
            eyes=true,
            lungs=true,
            heart=true,
            guts=true,
            throat=true,
            spine=true,
            neck=true,
            brain=true,
            skull=true,
            mouth=true,
            teeth=true,
            ribs=true,
            eyelids=true,
            tongue=true,
            blood=true
        },
        tweaks={
            "HAIR",
            "FEATHERS",
        },
        evil_tweaks={
            "SKINLESS",
        },
        good_tweaks={},
        surface="SCALES",
        material_template="SCALE:SCALE_TEMPLATE",
        tissue_template="SCALE:SCALE_TEMPLATE",
        body_plan=function(lines,options)
        if options.btc2=="SKINLESS" then
            lines[#lines+1]="[BODY_DETAIL_PLAN:VERTEBRATE_TISSUE_LAYERS:NONE:FAT:MUSCLE:BONE:CARTILAGE]"
        else 
            lines[#lines+1]="[BODY_DETAIL_PLAN:VERTEBRATE_TISSUE_LAYERS:SCALE:FAT:MUSCLE:BONE:CARTILAGE]" 
        end
        lines[#lines+1]="[BODY_DETAIL_PLAN:STANDARD_HEAD_POSITIONS]"
        lines[#lines+1]="[BODY_DETAIL_PLAN:HUMANOID_HEAD_POSITIONS]"
        lines[#lines+1]="[BODY_DETAIL_PLAN:HUMANOID_RIBCAGE_POSITIONS]"
        lines[#lines+1]="[BODY_DETAIL_PLAN:HUMANOID_RELSIZES]"
        lines[#lines+1]="[USE_MATERIAL_TEMPLATE:SINEW:SINEW_TEMPLATE]"
        lines[#lines+1]="[TENDONS:LOCAL_CREATURE_MAT:SINEW:200]"
        lines[#lines+1]="[LIGAMENTS:LOCAL_CREATURE_MAT:SINEW:200]"
        lines[#lines+1]="[HAS_NERVES]"
        end
    },
    REPTILE_FEATHERED={
        features={
            eyes=true,
            lungs=true,
            heart=true,
            guts=true,
            throat=true,
            spine=true,
            neck=true,
            brain=true,
            skull=true,
            mouth=true,
            teeth=true,
            ribs=true,
            eyelids=true,
            tongue=true,
            blood=true
        },
        tweaks={
            "HAIR",
            "FEATHERS",
        },
        evil_tweaks={
            "SKINLESS",
        },
        good_tweaks={},
        surface="FEATHERS",
        body_plan=function(lines,options)
        if options.btc2=="SKINLESS" then
            lines[#lines+1]="[BODY_DETAIL_PLAN:VERTEBRATE_TISSUE_LAYERS:NONE:FAT:MUSCLE:BONE:CARTILAGE]"
        elseif options.btc2=="SCALES" then
            lines[#lines+1]="[BODY_DETAIL_PLAN:VERTEBRATE_TISSUE_LAYERS:SCALE:FAT:MUSCLE:BONE:CARTILAGE]"
        else lines[#lines+1]="[BODY_DETAIL_PLAN:VERTEBRATE_TISSUE_LAYERS:SKIN:FAT:MUSCLE:BONE:CARTILAGE]" end
        lines[#lines+1]="[BODY_DETAIL_PLAN:STANDARD_HEAD_POSITIONS]"
        lines[#lines+1]="[BODY_DETAIL_PLAN:HUMANOID_HEAD_POSITIONS]"
        lines[#lines+1]="[BODY_DETAIL_PLAN:HUMANOID_RIBCAGE_POSITIONS]"
        lines[#lines+1]="[BODY_DETAIL_PLAN:HUMANOID_RELSIZES]"
        lines[#lines+1]="[USE_MATERIAL_TEMPLATE:SINEW:SINEW_TEMPLATE]"
        lines[#lines+1]="[TENDONS:LOCAL_CREATURE_MAT:SINEW:200]"
        lines[#lines+1]="[LIGAMENTS:LOCAL_CREATURE_MAT:SINEW:200]"
        lines[#lines+1]="[HAS_NERVES]"
        end
    },
    AVIAN={
            features={
            eyes=true,
            beak=true,
            lungs=true,
            heart=true,
            guts=true,
            throat=true,
            spine=true,
            neck=true,
            brain=true,
            skull=true,
            ribs=true,
            eyelids=true,
            tongue=true,
            blood=true
        },
        tweaks={}, -- FOR NOW, BECAUSE OF FLIGHT AND SPECIES RECOGNITION
        evil_tweaks={},
        good_tweaks={},
        surface="FEATHERS",
        body_plan=function(lines,options)
            if options.btc2=="SKINLESS" then
                lines[#lines+1]="[BODY_DETAIL_PLAN:VERTEBRATE_TISSUE_LAYERS:NONE:FAT:MUSCLE:BONE:CARTILAGE]"
            elseif options.btc2=="SCALES" then
                lines[#lines+1]="[BODY_DETAIL_PLAN:VERTEBRATE_TISSUE_LAYERS:SCALE:FAT:MUSCLE:BONE:CARTILAGE]"
            else lines[#lines+1]="[BODY_DETAIL_PLAN:VERTEBRATE_TISSUE_LAYERS:SKIN:FAT:MUSCLE:BONE:CARTILAGE]" end
            lines[#lines+1]="[BODY_DETAIL_PLAN:STANDARD_HEAD_POSITIONS]"
            lines[#lines+1]="[BODY_DETAIL_PLAN:HUMANOID_HEAD_POSITIONS]"
            lines[#lines+1]="[BODY_DETAIL_PLAN:HUMANOID_RIBCAGE_POSITIONS]"
            lines[#lines+1]="[BODY_DETAIL_PLAN:HUMANOID_RELSIZES]"
            lines[#lines+1]="[USE_MATERIAL_TEMPLATE:SINEW:SINEW_TEMPLATE]"
            lines[#lines+1]="[TENDONS:LOCAL_CREATURE_MAT:SINEW:200]"
            lines[#lines+1]="[LIGAMENTS:LOCAL_CREATURE_MAT:SINEW:200]"
            lines[#lines+1]="[HAS_NERVES]"
        end
    },
    UNIFORM={
        features={},
        tweaks={},
        evil_tweaks={},
        good_tweaks={},
        surface=nil,
        body_plan=function(lines,options)
            options.matgloss="NONE"
            options.rcm=options.sphere_rcm or "NONE"
            if random_creature_material[rcm] and random_creature_material[rcm].matgloss then
                options.matgloss=random_creature_material[rcm].matgloss(options)
            else
                options.matgloss=world.inorganic.get_random_inorganic(nil,nil,"SPECIAL")
            end
            while options.rcm=="NONE" do
                -- titans, demons, angels
                if options.pick_sphere_rcm and #options.pos_sphere_rcm>0 and one_in(2) then
                    options.rcm=pick_random(pick_sphere_rcm)
                elseif options.rcp.requires_flexible_material or one_in(2) then
                    pick_random({
                        function() if options.is_evil then options.rcm="ASH" end end,
                        function() if not options.is_good then options.rcm="MUD" end end,
                        function() if options.is_evil then options.rcm="VOMIT" end end,
                        function() if not options.is_good then options.rcm="SALT_POWDER" end end,
                        function() if options.is_evil then options.rcm="GRIME" end end,
                        function() options.rcm="SNOW" end,
                        function() options.rcm="WATER" end,
                        function() options.rcm="STEAM" end,
                        function() options.rcm="FLAME" end,
                    })()
                elseif one_in(2) or options.matgloss=="NONE" then
                    pick_random({
                        function() options.rcm="AMBER" end,
                        function() options.rcm="CORAL" end,
                        function() options.rcm="GLASS_GREEN" end,
                        function() options.rcm="GLASS_CLEAR" end,
                        function() options.rcm="GLASS_CRYSTAL" end,
                        function() if options.is_evil then options.rcm=pick_random({"CHARCOAL","COKE"}) end end,
                        function() if not options.is_good then options.rcm="SALT_SOLID" end end,
                        function() options.rcm="ICE" end,
                    })()
                else
                    options.rcm="ANY_MINERAL"
                end
                -- for flying spirit demons, at least in vanilla
                if options.always_insubstantial and not insubstantial_materials[rcm] then
                    options.rcm=pick_random_pairs(insubstantial_materials)
                end
            end
            random_creature_material[options.rcm].option_sets(options)
            if options.mat_temp1 then
                lines[#lines+1]="[USE_MATERIAL_TEMPLATE:"..options.mat_temp1..":"..options.mat_temp2.."]"
                if options.fixed_temp then
                    lines[#lines+1]="[MAT_FIXED_TEMP:"..tostring(options.fixed_temp).."]"
                end
            end
            lines[#lines+1]="[TISSUE:UNIFORM_TIS]"
            lines[#lines+1]="[TISSUE_NAME:tissue:NP]"
            lines[#lines+1]="[TISSUE_MATERIAL:"..options.tok1..(options.tok2 and (":"..options.tok2) or "").."]"
            lines[#lines+1]="[TISSUE_MAT_STATE:"..options.st_tok.."]"
            lines=split_to_lines(lines,[[
    [MUSCULAR]
    [FUNCTIONAL]
    [STRUCTURAL]
    [RELATIVE_THICKNESS:1]
    [CONNECTS]
    [TISSUE_SHAPE:LAYER]
[TISSUE_LAYER:BY_CATEGORY:ALL:UNIFORM_TIS]
[BODY_DETAIL_PLAN:STANDARD_HEAD_POSITIONS]
[BODY_DETAIL_PLAN:HUMANOID_HEAD_POSITIONS]
[BODY_DETAIL_PLAN:HUMANOID_RELSIZES]
[NOT_LIVING]
[NOT_BUTCHERABLE]
            ]])
            if options.fire_mat then
                local amt_of_targets=trandom(4)+1
                lines=split_to_lines(lines,[[
[CAN_DO_INTERACTION:RCP_MATERIAL_EMISSION]
    [CDI:ADV_NAME:Hurl fireball]
    [CDI:USAGE_HINT:ATTACK]
    [CDI:FLOW:FIREBALL]
    [CDI:TARGET:C:LINE_OF_SIGHT]
    [CDI:TARGET_RANGE:C:15]
]]..(amt_of_targets<4 and ("[CDI:MAX_TARGET_NUMBER:C:"..amt_of_targets.."]") or "")..[[
    [CDI:WAIT_PERIOD:30]
    [CDI:DEFAULT_ICON:ADVENTURE_INTERACTION_ICON_SPRAY_FIRE_JET]
[CAN_DO_INTERACTION:RCP_MATERIAL_EMISSION]
    [CDI:ADV_NAME:Spray jet of fire]
    [CDI:USAGE_HINT:ATTACK]
    [CDI:FLOW:FIREJET]
    [CDI:TARGET:C:LINE_OF_SIGHT]
    [CDI:TARGET_RANGE:C:5]
    [CDI:MAX_TARGET_NUMBER:C:1]
    [CDI:WAIT_PERIOD:30]
    [CDI:DEFAULT_ICON:ADVENTURE_INTERACTION_ICON_HURL_FIREBALL]
[FIREIMMUNE_SUPER]
]])
            end
            if options.odor_string then
                lines[#lines+1]="[ODOR_STRING:"..options.odor_string.."]"
                lines[#lines+1]="[ODOR_LEVEL:"..tostring(options.odor_level).."]"
            end
            options.color_f = options.color_f or 0
            options.color_b = options.color_b or 0
            options.color_br = options.color_br or 0
            if options.color_f==0 and options.color_b==0 and options.color_br==0 then options.color_br=1 end
            lines[#lines+1]="[COLOR:"..tostring(options.color_f)..":"..tostring(options.color_b)..":"..tostring(options.color_br).."]"
            if options.tok1 and options.tok1~="LOCAL_CREATURE_MAT" then
                local rmd
                if options.tok1=="INORGANIC" then
                    rmd=world.inorganic.inorganic[options.tok2].material
                else
                    rmd=world.convert_string_to_mat(options.tok1)
                end
                if rmd then -- This had a bounds check in C++, but the bounds check is built in in Lua
                    options.pcg_clp=world.descriptor.color_pattern[rmd.color_pattern.SOLID]
                end
            end
        end,
        no_extra_materials=true
    },
}

btc1_tweaks={}

color_picker_functions={
    death_misery={
        cond=function(options)
            return options.spheres.DEATH or options.spheres.MISERY
        end,
        color=function(color)
            -- GRAY TO BLACK/BLUEISH GREEN THAT ARE SOMEWHAT GRAYISH AND MORE BLUE
            return (color.v<=0.75 and color.s<=0.001) or (color.v==color.b and color.s<=0.25)
        end
    },
    darkness_night={
        cond=function(options)
            return options.spheres.DARKNESS or options.spheres.NIGHT
        end,
        color=function(color)
            -- GRAY TO BLACK OR DARK BLUISH
            return color.v<=0.4 and (color.s < 0.001 or (color.h>180 and color.h<=240))
        end
    },
    werebeast={
        cond=function(options)
            -- werebeasts only, in vanilla
            return options.animal_coloring_allowed
        end,
        color=function(color)
            --BROWN OKAY TOO
            return color.h>=30 and color.h<=48 and color.b<=0.15 and color.v<=0.75 and color.v > 0
        end
    }
}

function add_poison_bits(lines, options)
    options.poison_state=options.poison_state or "LIQUID"
    if options.poison_state=="GAS" then
        lines[#lines+1]="\t[MELTING_POINT:9800]"
        lines[#lines+1]="\t[BOILING_POINT:9900]"
    end
    if string.sub(options.poison_state,1,5)=="SOLID" then
        lines[#lines+1]="\t[MELTING_POINT:10200]"
        lines[#lines+1]="\t[BOILING_POINT:10400]"
    end
    lines[#lines+1]="\t[ENTERS_BLOOD]"

    lines[#lines+1]="\t[SYNDROME]"
    if options.sickness_name then
        lines[#lines+1]="\t\t[SYN_NAME:"..options.sickness_name.."]"
    end
    lines[#lines+1]="\t\t[SYN_AFFECTED_CLASS:GENERAL_POISON]"
    lines[#lines+1]="\t\t[SYN_IMMUNE_CREATURE:"..options.token.."]"
    lines[#lines+1]="\t\t[SYN_INJECTED][SYN_CONTACT][SYN_INHALED][SYN_INGESTED]"
    add_base_poison_effects(lines,{
        "CE_PAIN",
        "CE_SWELLING",
        "CE_OOZING",
        "CE_BRUISING",
        "CE_BLISTERS",
        "CE_NUMBNESS",
        "CE_PARALYSIS",
        "CE_FEVER",
        "CE_BLEEDING",
        "CE_COUGH_BLOOD",
        "CE_VOMIT_BLOOD",
        "CE_NAUSEA",
        "CE_UNCONSCIOUSNESS",
        "CE_NECROSIS",
        "CE_IMPAIR_FUNCTION",
        "CE_DROWSINESS",
        "CE_DIZZINESS"
    },100,5,0,1200,200,1200,1200,2400,30,2,2,2)
end

attack_tweaks={
    TAIL_STINGER={
        cond=function() return false end, -- applied earlier
        apply=function(lines,options)
            lines[#lines+1]="[USE_MATERIAL_TEMPLATE:POISON:CREATURE_EXTRACT_TEMPLATE]"
            options.poison_state="LIQUID"
            add_poison_bits(lines,options)
            -- handled later, when it's adding all the special BP attacks
        end,
        desc=function(options)
            return "Beware its poisonous sting!"
        end
    },
    INSECT_STINGER={
        cond=function() return false end, -- applied earlier
        apply=function(lines,options)
            lines[#lines+1]="[USE_MATERIAL_TEMPLATE:POISON:CREATURE_EXTRACT_TEMPLATE]"
            add_poison_bits(lines,options)
            -- handled later, when it's adding all the special BP attacks
        end,
        desc=function(options)
            return "Beware its poisonous sting!"
        end
   },
    FIRE={
        cond=function(options)
            return (options.mouth or options.beak) and not options.fire_mat and not options.experiment_attack_tweak
        end,
        apply=function(lines,options)
            local fire_type=trandom(3)
            options.fire_immune=true
            -- 0 = both, 1 = jet, 2 = ball
            if fire_type%2==0 then
                lines[#lines+1]="[CAN_DO_INTERACTION:RCP_MATERIAL_EMISSION]"
                lines[#lines+1]="[CDI:ADV_NAME:Hurl fireball]"
                lines[#lines+1]="[CDI:USAGE_HINT:ATTACK]"
                lines[#lines+1]="[CDI:FLOW:FIREBALL]"
                lines[#lines+1]="[CDI:TARGET:C:LINE_OF_SIGHT]"
                lines[#lines+1]="[CDI:TARGET_RANGE:C:15]"
                if not one_in(10) then
                    lines[#lines+1]="[CDI:MAX_TARGET_NUMBER:C:"..tostring(trandom(4)+1).."]"
                end
                lines[#lines+1]="[CDI:WAIT_PERIOD:30]"
                lines[#lines+1]="[CDI:DEFAULT_ICON:ADVENTURE_INTERACTION_ICON_HURL_FIREBALL]"
            end
            if fire_type/2 < 1 then
                lines[#lines+1]="[CAN_DO_INTERACTION:RCP_MATERIAL_EMISSION]"
                lines[#lines+1]="[CDI:ADV_NAME:Spray jet of fire]"
                lines[#lines+1]="[CDI:USAGE_HINT:ATTACK]"
                lines[#lines+1]="[CDI:FLOW:FIREJET]"
                lines[#lines+1]="[CDI:TARGET:C:LINE_OF_SIGHT]"
                lines[#lines+1]="[CDI:TARGET_RANGE:C:5]"
                lines[#lines+1]="[CDI:MAX_TARGET_NUMBER:C:1]"
                lines[#lines+1]="[CDI:WAIT_PERIOD:30]"
                lines[#lines+1]="[CDI:DEFAULT_ICON:ADVENTURE_INTERACTION_ICON_SPRAY_FIRE_JET]"
            end
        end,
        desc=function(options)
            return "Beware its fire!"
        end
    },
    WEBS={
        cond=function(options) return not options.experiment_attack_tweak end,
        apply=function(lines,options) options.do_webs=true end,
        desc=function(options)
            return "Beware its webs!"
        end
    },
    BREATHE_TRAILING_FLOW={
        cond=function(options) return options.is_evil and not options.experiment_attack_tweak end,
        apply=function(lines,options)
            lines[#lines+1]="[USE_MATERIAL_TEMPLATE:POISON:CREATURE_EXTRACT_TEMPLATE]"
            options.poison_state=pick_random({"LIQUID","GAS","SOLID_POWDER"})
            add_poison_bits(lines,options)
            lines[#lines+1]="[CAN_DO_INTERACTION:RCP_MATERIAL_EMISSION]"
            lines[#lines+1]="[CDI:USAGE_HINT:ATTACK]"
            lines[#lines+1]="[CDI:TARGET:C:LINE_OF_SIGHT]"
            lines[#lines+1]="[CDI:TARGET_RANGE:C:15]"
            lines[#lines+1]="[CDI:MAX_TARGET_NUMBER:C:1]"
            local name,caps="dust","DUST"
            if options.poison_state=="LIQUID" then name,caps="vapor","VAPOR"
            elseif options.poison_state=="GAS" then name,caps="gas","GAS"
            end
            lines[#lines+1]="[CDI:ADV_NAME:Spray "..name.."]"
            lines[#lines+1]="[CDI:MATERIAL:LOCAL_CREATURE_MAT:POISON:TRAILING_"..caps.."_FLOW]"
            lines[#lines+1]="[CDI:DEFAULT_ICON:ADVENTURE_INTERACTION_ICON_SPRAY_"..caps.."]"
        end,
        desc=function(options)
            if options.poison_state=="LIQUID" then return "Beware its poisonous vapors"
            elseif options.poison_state=="GAS" then return "Beware its poisonous gas!"
            else return "Beware its deadly dust!"
            end
        end
    },
    BREATHE_GLOB={
        cond=function(options) return true end,
        apply=function(lines,options)
            lines[#lines+1]="[CAN_DO_INTERACTION:RCP_MATERIAL_EMISSION]"
            lines[#lines+1]="[CDI:USAGE_HINT:ATTACK]"
            lines[#lines+1]="[CDI:TARGET:C:LINE_OF_SIGHT]"
            lines[#lines+1]="[CDI:TARGET_RANGE:C:15]"
            lines[#lines+1]="[CDI:MAX_TARGET_NUMBER:C:1]"
            options.poison_state=pick_random({"LIQUID","SOLID_POWDER"})
            local name=options.poison_state
            if name~="LIQUID" then name=string.sub(name,1,5) end
            lines[#lines+1]="[CDI:ADV_NAME:Spit glob]"
            lines[#lines+1]="[CDI:MATERIAL:LOCAL_CREATURE_MAT:POISON:"..name.."_GLOB]"
            lines[#lines+1]="[CDI:DEFAULT_ICON:ADVENTURE_INTERACTION_ICON_SPIT_"..name.."_GLOB]"
        end,
        desc=function(options)
            return "Beware its deadly spittle!"
        end
    },
    BREATHE_UNDIRECTED={
        cond=function(options) return options.is_evil and not options.experiment_attack_tweak end,
        apply=function(lines,options)
            lines[#lines+1]="[USE_MATERIAL_TEMPLATE:POISON:CREATURE_EXTRACT_TEMPLATE]"
            options.poison_state=pick_random({"LIQUID","GAS","SOLID_POWDER"})
            add_poison_bits(lines,options)
            lines[#lines+1]="[CAN_DO_INTERACTION:RCP_MATERIAL_EMISSION]"
            lines[#lines+1]="[CDI:USAGE_HINT:ATTACK]"
            lines[#lines+1]="[CDI:TARGET:C:LINE_OF_SIGHT]"
            lines[#lines+1]="[CDI:TARGET_RANGE:C:15]"
            lines[#lines+1]="[CDI:MAX_TARGET_NUMBER:C:1]"
            local name,caps="dust","DUST"
            if options.poison_state=="LIQUID" then name,caps="vapor","VAPOR"
            elseif options.poison_state=="GAS" then name,caps="gas","GAS"
            end
            lines[#lines+1]="[CDI:ADV_NAME:Spray "..name.."]"
            lines[#lines+1]="[CDI:MATERIAL:LOCAL_CREATURE_MAT:POISON:UNDIRECTED_"..caps.."]"
            lines[#lines+1]="[CDI:DEFAULT_ICON:ADVENTURE_INTERACTION_ICON_EMIT_"..caps.."]"
        end,
        desc=function(options)
            if options.poison_state=="LIQUID" then return "Beware its poisonous vapors"
            elseif options.poison_state=="GAS" then return "Beware its poisonous gas!"
            else return "Beware its deadly dust!"
            end
        end
    },
    SECRETION={
        cond=function(options)
            return (options.experiment_attack_tweak or options.is_evil) and not options.intangible and secreting_surfaces[options.surface]
        end,
        apply=function(lines,options)
            lines[#lines+1]="[USE_MATERIAL_TEMPLATE:POISON:CREATURE_EXTRACT_TEMPLATE]"
            options.poison_state=pick_random({"LIQUID","GAS","SOLID_POWDER"})
            add_poison_bits(lines,options)
            lines[#lines+1]="[SECRETION:LOCAL_CREATURE_MAT:POISON:"..options.poison_state..":BY_CATEGORY:ALL:"..secreting_surfaces[options.surface].."]"
        end,
        desc=function(options)
            return "Beware its noxious secretions!"
        end
    },
    POISON_BLOOD={
        cond=function(options)
            return (options.experiment_attack_tweak or options.is_evil) and (options.ichor or options.goo or options.blood)
        end,
        apply=function(lines,options)
            -- this segment is why the poison template can't be in add_poison_bits
            if options.blood then
                lines[#lines+1]="[SELECT_MATERIAL:BLOOD]"
            elseif options.ichor then
                lines[#lines+1]="[SELECT_MATERIAL:ICHOR]"
            elseif options.goo then
                lines[#lines+1]="[SELECT_MATERIAL:GOO]"
            else 
                lines[#lines+1]="[USE_MATERIAL_TEMPLATE:POISON:CREATURE_EXTRACT_TEMPLATE]"
            end
            options.poison_state="LIQUID" -- default, but should be explicit here, really
            add_poison_bits(lines,options)
        end,
        desc=function(options)
            return "Beware its deadly blood!"
        end
    },
    POISON_BITE={
        cond=function(options)
            return (options.mouth or options.beak) and not options.intangible
        end,
        apply=function(lines,options)
            lines[#lines+1]="[USE_MATERIAL_TEMPLATE:POISON:CREATURE_EXTRACT_TEMPLATE]"
            options.poison_state="LIQUID"
            add_poison_bits(lines,options)
            -- the rest later
        end,
        desc=function(options)
            return "Beware its poisonous bite!"
        end
    },
    PROBOSCIS_BLOOD={
        cond=function(options)
            return false -- applied inline
        end,
        apply=function(lines,options)
            -- also applied inline
        end,
        desc=function(options)
            return "Beware its hunger for warm blood!"
        end
    }
}

default_desc_adds={
    {
        cond=function(options)
            return true
        end,
        add=function(options)
            return "it has a regal bearing"
        end
    },
    {
        cond=function(options)
            return true
        end,
        add=function(options)
            return "it has an austere look about it"
        end
    },
    {
        cond=function(options)
            return true
        end,
        add=function(options)
            return "it moves deliberately"
        end
    },
    {
        cond=function(options)
            return true
        end,
        add=function(options)
            return "it moves about carelessly"
        end
    },
}

good_desc_adds={
    {
        cond=function(options)
            return options.spheres.PEACE or options.spheres.WISDOM or options.spheres.HAPPINESS
        end,
        add=function(options)
            options.pref_str[#options.pref_str+1]="peaceful nature"
            return "it bears a look of unbelievable peace"
        end
    },
    {
        cond=function(options)
            return options.spheres.CHARITY or options.spheres.CONSOLATION or
            options.spheres.FORGIVENESS or options.spheres.GENEROSITY or
            options.spheres.HOSPITALITY or options.spheres.LOVE or
            options.spheres.MERCY or options.spheres.SACRIFICE or options.spheres.HEALING
        end,
        add=function(options)
            options.pref_str[#options.pref_str+1]="kind nature"
            return "it emanates an aura of giving and kindness"
        end
    },
    {
        cond=function(options)
            return options.spheres.FREEDOM or options.spheres.REVELRY
        end,
        add=function(options)
            options.pref_str[#options.pref_str+1]="joyful nature"
            return "joy marks its every movement"
        end
    },
    {
        cond=function(options)
            return options.spheres.TRUTH
        end,
        add=function(options)
            return "it moves its will in accordance with the truth of things"
        end
    }
}

evil_desc_adds={
    {
        cond=function(options) 
            return options.mouth or options.beak or find_in_array_part(options.body_string,"RCP_PROBOSCIS")
        end,
        add=function(options)
            return pick_random({
                "it is ravening",
                "it is slavering",
                "it belches and croaks"
            })
        end
    },
    {
        cond=function(options) return true end,
        add=function(options)
            options.pref_str[#options.pref_str+1]="rhythmic undulations"
            return "it undulates rhythmically"
        end
    },
    {
        cond=function(options) return true end,
        add=function(options)
            return "it squirms and fidgets"
        end
    },
    {
        cond=function(options) return true end,
        add=function(options)
            options.pref_str[#options.pref_str+1]="bloated appearance"
            return "it has a bloated body"
        end
    },
    {
        cond=function(options) return true end,
        add=function(options)
            return pick_random({
                "it has a gaunt appearance",
                "it appears to be emaciated"
            })
        end
    },
    {
        cond=function(options)
            return (options.mouth or options.beak) and options.can_learn
        end,
        add=function(options)
            local candidates={
                "it chants ceaselessly",
                "it murmurs horrible curses",
                "it spouts gibberish periodically",
                "it knows and intones the names of all it encounters"
            }
            if options.spheres.TORTURE then candidates[#candidates+1]="it repeatedly makes threats of torture and death" end
            return pick_random(candidates)
        end
    }
}

surface_color_raw_rows={
    BLACK=1,
    CHARCOAL=2,
    MIDNIGHT_BLUE=3,
    ASH_GRAY=4,
    ECRU=5,
    IVORY=6,
    TAUPE_PURPLE=7,
    PALE_PINK=8,
    DARK_OLIVE=9,
    OLIVE=10,
}


climbing_parts={
    "RCP_SIMPLE_FRONT_LEGS_GRASP",
    "RCP_FIRST_SIMPLE_LEGS_GRASP",
    "RCP_TWO_PART_ARMS",
    "RCP_PINCERS",
    "RCP_CLAW_ARMS"
}

feature_tweaks={

}

post_attack_tweaks={
    PUNCH=function(lines,options,is_in_body)
        if is_in_body("RCP_TWO_PART_ARMS") then
            lines[#lines+1]="[ATTACK:PUNCH:BODYPART:BY_TYPE:GRASP]"
            lines[#lines+1]="\t[ATTACK_SKILL:GRASP_STRIKE]"
            lines[#lines+1]="\t[ATTACK_VERB:punch:punches]"
            lines[#lines+1]="\t[ATTACK_CONTACT_PERC:100]"
            lines[#lines+1]="\t[ATTACK_PREPARE_AND_RECOVER:2:2]"
            lines[#lines+1]="\t[ATTACK_FLAG_WITH]"
            lines[#lines+1]="\t[ATTACK_PRIORITY:"..(options.prioritize_bite and "SECOND" or "MAIN").."]"
        end
    end,
    SNATCH=function(lines,options,is_in_body)
        if is_in_body("RCP_PINCERS") or is_in_body("RCP_CLAW_ARMS") then
            lines[#lines+1]="[ATTACK:PINCER:BODYPART:BY_CATEGORY:PINCER]"
            lines[#lines+1]="\t[ATTACK_SKILL:GRASP_STRIKE]"
            lines[#lines+1]="\t[ATTACK_VERB:snatch:snatches]"
            lines[#lines+1]="\t[ATTACK_CONTACT_PERC:100]"
            lines[#lines+1]="\t[ATTACK_PENETRATION_PERC:100]"
            lines[#lines+1]="\t[ATTACK_PREPARE_AND_RECOVER:2:2]"
            lines[#lines+1]="\t[ATTACK_FLAG_EDGE]"
            lines[#lines+1]="\t[ATTACK_PRIORITY:"..(options.prioritize_bite and "SECOND" or "MAIN").."]"
            lines[#lines+1]="\t[ATTACK_FLAG_CANLATCH]"
            lines[#lines+1]="\t[ATTACK_FLAG_WITH]"
        end
    end,
    KICK=function(lines,options,is_in_body)
        if is_in_body("RCP_FIRST_SIMPLE_LEGS") or is_in_body("RCP_SIMPLE_FRONT_LEGS") or
           is_in_body("RCP_TWO_PART_LEGS") or is_in_body("RCP_SIMPLE_REAR_LEGS") or
           is_in_body("RCP_SECOND_SIMPLE_LEGS") or is_in_body("RCP_THIRD_SIMPLE_LEGS") or 
           is_in_body("RCP_FOURTH_SIMPLE_LEGS") or is_in_body("RCP_FIFTH_SIMPLE_LEGS") then
            lines[#lines+1]="[ATTACK:KICK:BODYPART:BY_TYPE:STANCE]"
            lines[#lines+1]="\t[ATTACK_SKILL:STANCE_STRIKE]"
            lines[#lines+1]="\t[ATTACK_VERB:kick:kicks]"
            lines[#lines+1]="\t[ATTACK_CONTACT_PERC:100]"
            lines[#lines+1]="\t[ATTACK_PREPARE_AND_RECOVER:2:2]"
            lines[#lines+1]="\t[ATTACK_FLAG_WITH]"
            lines[#lines+1]="\t[ATTACK_PRIORITY:"..(options.prioritize_bite and "SECOND" or "MAIN").."]"
            lines[#lines+1]="\t[ATTACK_FLAG_BAD_MULTIATTACK]"
        end
    end,
    STING=function(lines,options,is_in_body)
        if is_in_body("RCP_TAIL_STINGER") or is_in_body("RCP_LOWER_BODY_STINGER") then
            lines[#lines+1]="[ATTACK:STING:BODYPART:BY_CATEGORY:STINGER]"
            lines[#lines+1]="\t[ATTACK_SKILL:STANCE_STRIKE]"
            lines[#lines+1]="\t[ATTACK_VERB:sting:stings]"
            lines[#lines+1]="\t[ATTACK_CONTACT_PERC:5]"
            lines[#lines+1]="\t[ATTACK_PENETRATION_PERC:100]"
            lines[#lines+1]="\t[ATTACK_PREPARE_AND_RECOVER:2:2]"
            lines[#lines+1]="\t[ATTACK_FLAG_EDGE]"
            lines[#lines+1]="\t[ATTACK_PRIORITY:"..(options.prioritize_bite and "SECOND" or "MAIN").."]"
            lines[#lines+1]="\t[SPECIALATTACK_INJECT_EXTRACT:LOCAL_CREATURE_MAT:POISON:LIQUID:100:100]"
        end
    end,
    PROBOSCIS_STAB=function(lines,options,is_in_body)
        if is_in_body("RCP_PROBOSCIS") then
            lines[#lines+1]="[ATTACK:SUCK:BODYPART:BY_CATEGORY:PROBOSCIS]"
            lines[#lines+1]="\t[ATTACK_SKILL:BITE]"
            lines[#lines+1]="\t[ATTACK_VERB:stab:stabs]"
            lines[#lines+1]="\t[ATTACK_CONTACT_PERC:5]"
            lines[#lines+1]="\t[ATTACK_PENETRATION_PERC:100]"
            lines[#lines+1]="\t[ATTACK_PREPARE_AND_RECOVER:2:2]"
            lines[#lines+1]="\t[ATTACK_FLAG_EDGE]"
            lines[#lines+1]="\t[ATTACK_PRIORITY:MAIN]"
            lines[#lines+1]="\t[SPECIALATTACK_SUCK_BLOOD:50:100]"
            if options.bite_interaction then
                lines[#lines+1]="\t[SPECIALATTACK_INTERACTION:"..options.bite_interaction.."]"
            end
        end
    end,
    GORE=function(lines,options,is_in_body)
        if is_in_body("RCP_1_HEAD_HORN") or is_in_body("RCP_2_HEAD_HORNS") or
           is_in_body("RCP_3_HEAD_HORNS") or is_in_body("RCP_4_HEAD_HORNS") then
            lines[#lines+1]="[ATTACK:HORN:BODYPART:BY_CATEGORY:HORN]"
            lines[#lines+1]="\t[ATTACK_SKILL:BITE]"
            lines[#lines+1]="\t[ATTACK_VERB:gore:gores]"
            lines[#lines+1]="\t[ATTACK_CONTACT_PERC:5]"
            lines[#lines+1]="\t[ATTACK_PENETRATION_PERC:100]"
            lines[#lines+1]="\t[ATTACK_PREPARE_AND_RECOVER:2:2]"
            lines[#lines+1]="\t[ATTACK_FLAG_EDGE]"
            lines[#lines+1]="\t[ATTACK_PRIORITY:"..(options.prioritize_bite and "SECOND" or "MAIN").."]"
        end
    end,
    BITE=function(lines,options,is_in_body)
        if is_in_body("RCP_LARGE_MANDIBLES") then
            lines[#lines+1]="[ATTACK:BITE:BODYPART:BY_CATEGORY:MANDIBLE]"
            lines[#lines+1]="\t[ATTACK_SKILL:BITE]"
            lines[#lines+1]="\t[ATTACK_VERB:stab:stabs]"
            lines[#lines+1]="\t[ATTACK_CONTACT_PERC:100]"
            lines[#lines+1]="\t[ATTACK_PENETRATION_PERC:100]"
            lines[#lines+1]="\t[ATTACK_PREPARE_AND_RECOVER:2:2]"
            lines[#lines+1]="\t[ATTACK_FLAG_EDGE]"
            lines[#lines+1]="\t[ATTACK_PRIORITY:MAIN]"
            if options.bite_interaction then
                lines[#lines+1]="\t[SPECIALATTACK_INTERACTION:"..options.bite_interaction.."]"
            end
        elseif is_in_body("RCP_BEAK") then
            lines[#lines+1]="[ATTACK:BITE:BODYPART:BY_CATEGORY:BEAK]"
            lines[#lines+1]="\t[ATTACK_SKILL:BITE]"
            lines[#lines+1]="\t[ATTACK_VERB:bite:bites]"
            lines[#lines+1]="\t[ATTACK_CONTACT_PERC:100]"
            lines[#lines+1]="\t[ATTACK_PREPARE_AND_RECOVER:2:2]"
            lines[#lines+1]="\t[ATTACK_PRIORITY:MAIN]"
            lines[#lines+1]="\t[ATTACK_FLAG_CANLATCH]"
            if options.rcp.must_suck_blood_through_mouth then
                lines[#lines+1]="\t[SPECIALATTACK_SUCK_BLOOD:50:100]"
            end
            if options.attack_tweak=="POISON_BITE" then
                lines[#lines+1]="\t[SPECIALATTACK_INJECT_EXTRACT:LOCAL_CREATURE_MAT:POISON:LIQUID:100:100]"
            end
            if options.bite_interaction then
                lines[#lines+1]="\t[SPECIALATTACK_INTERACTION:"..options.bite_interaction.."]"
            end
        elseif is_in_body("RCP_TEETH") then
            lines[#lines+1]="[ATTACK:BITE:CHILD_BODYPART_GROUP:BY_CATEGORY:HEAD:BY_CATEGORY:TOOTH]"
            lines[#lines+1]="\t[ATTACK_SKILL:BITE]"
            lines[#lines+1]="\t[ATTACK_VERB:bite:bites]"
            lines[#lines+1]="\t[ATTACK_CONTACT_PERC:100]"
            lines[#lines+1]="\t[ATTACK_PENETRATION_PERC:100]"
            lines[#lines+1]="\t[ATTACK_PREPARE_AND_RECOVER:2:2]"
            lines[#lines+1]="\t[ATTACK_FLAG_EDGE]"
            lines[#lines+1]="\t[ATTACK_PRIORITY:MAIN]"
            lines[#lines+1]="\t[ATTACK_FLAG_CANLATCH]"
            if options.rcp.must_suck_blood_through_mouth then
                lines[#lines+1]="\t[SPECIALATTACK_SUCK_BLOOD:50:100]"
            end
            if options.attack_tweak=="POISON_BITE" then
                lines[#lines+1]="\t[SPECIALATTACK_INJECT_EXTRACT:LOCAL_CREATURE_MAT:POISON:LIQUID:100:100]"
            end
            if options.bite_interaction then
                lines[#lines+1]="\t[SPECIALATTACK_INTERACTION:"..options.bite_interaction.."]"
            end
        elseif is_in_body("RCP_MOUTH") then
            lines[#lines+1]="[ATTACK:BITE:BODYPART:BY_CATEGORY:MOUTH]"
            lines[#lines+1]="\t[ATTACK_SKILL:BITE]"
            lines[#lines+1]="\t[ATTACK_VERB:bite:bites]"
            lines[#lines+1]="\t[ATTACK_CONTACT_PERC:100]"
            lines[#lines+1]="\t[ATTACK_PREPARE_AND_RECOVER:2:2]"
            lines[#lines+1]="\t[ATTACK_PRIORITY:MAIN]"
            lines[#lines+1]="\t[ATTACK_FLAG_CANLATCH]"
            if options.rcp.must_suck_blood_through_mouth then
                lines[#lines+1]="\t[SPECIALATTACK_SUCK_BLOOD:50:100]"
            end
            if options.attack_tweak=="POISON_BITE" then
                lines[#lines+1]="\t[SPECIALATTACK_INJECT_EXTRACT:LOCAL_CREATURE_MAT:POISON:LIQUID:100:100]"
            end
            if options.bite_interaction then
                lines[#lines+1]="\t[SPECIALATTACK_INTERACTION:"..options.bite_interaction.."]"
            end
        end
    end,
    finger_claws=function(lines,options,is_in_body)
        if options.finger_claws then
            lines[#lines+1]="[ATTACK:FSCRATCH:CHILD_TISSUE_LAYER_GROUP:BY_TYPE:GRASP:BY_CATEGORY:ALL:CLAW]"
            lines[#lines+1]="\t[ATTACK_SKILL:GRASP_STRIKE]"
            lines[#lines+1]="\t[ATTACK_VERB:scratch:scratches]"
            lines[#lines+1]="\t[ATTACK_CONTACT_PERC:100]"
            lines[#lines+1]="\t[ATTACK_PENETRATION_PERC:100]"
            lines[#lines+1]="\t[ATTACK_PREPARE_AND_RECOVER:2:2]"
            lines[#lines+1]="\t[ATTACK_FLAG_EDGE]"
            lines[#lines+1]="\t[ATTACK_PRIORITY:"..(options.prioritize_bite and "SECOND" or "MAIN").."]"
        end
    end,
    toe_claws=function(lines,options,is_in_body)
        if options.toe_claws then
            lines[#lines+1]="[ATTACK:TSCRATCH:CHILD_TISSUE_LAYER_GROUP:BY_TYPE:STANCE:BY_CATEGORY:ALL:CLAW]"
            lines[#lines+1]="\t[ATTACK_SKILL:STANCE_STRIKE]"
            lines[#lines+1]="\t[ATTACK_VERB:scratch:scratches]"
            lines[#lines+1]="\t[ATTACK_CONTACT_PERC:100]"
            lines[#lines+1]="\t[ATTACK_PENETRATION_PERC:100]"
            lines[#lines+1]="\t[ATTACK_PREPARE_AND_RECOVER:2:2]"
            lines[#lines+1]="\t[ATTACK_FLAG_EDGE]"
            lines[#lines+1]="\t[ATTACK_PRIORITY:"..(options.prioritize_bite and "SECOND" or "MAIN").."]"
            lines[#lines+1]="\t[ATTACK_FLAG_BAD_MULTIATTACK]"
        end
    end,
    finger_nails=function(lines,options,is_in_body)
        if options.finger_nails then
            lines[#lines+1]="[ATTACK:FSCRATCH:CHILD_TISSUE_LAYER_GROUP:BY_TYPE:GRASP:BY_CATEGORY:ALL:NAIL]"
            lines[#lines+1]="\t[ATTACK_SKILL:GRASP_STRIKE]"
            lines[#lines+1]="\t[ATTACK_VERB:scratch:scratches]"
            lines[#lines+1]="\t[ATTACK_CONTACT_PERC:100]"
            lines[#lines+1]="\t[ATTACK_PENETRATION_PERC:100]"
            lines[#lines+1]="\t[ATTACK_PREPARE_AND_RECOVER:2:2]"
            lines[#lines+1]="\t[ATTACK_FLAG_EDGE]"
            lines[#lines+1]="\t[ATTACK_PRIORITY:SECOND]"
        end
    end,
    toe_nails=function(lines,options,is_in_body)
        if options.toe_nails then
            lines[#lines+1]="[ATTACK:TSCRATCH:CHILD_TISSUE_LAYER_GROUP:BY_TYPE:STANCE:BY_CATEGORY:ALL:NAIL]"
            lines[#lines+1]="\t[ATTACK_SKILL:STANCE_STRIKE]"
            lines[#lines+1]="\t[ATTACK_VERB:scratch:scratches]"
            lines[#lines+1]="\t[ATTACK_CONTACT_PERC:100]"
            lines[#lines+1]="\t[ATTACK_PENETRATION_PERC:100]"
            lines[#lines+1]="\t[ATTACK_PREPARE_AND_RECOVER:2:2]"
            lines[#lines+1]="\t[ATTACK_FLAG_EDGE]"
            lines[#lines+1]="\t[ATTACK_PRIORITY:SECOND]"
            lines[#lines+1]="\t[ATTACK_FLAG_BAD_MULTIATTACK]"
        end
    end,
    finger_talons=function(lines,options,is_in_body)
        if options.finger_talons then
            lines[#lines+1]="[ATTACK:FSCRATCH:CHILD_TISSUE_LAYER_GROUP:BY_TYPE:GRASP:BY_CATEGORY:ALL:TALON]"
            lines[#lines+1]="\t[ATTACK_SKILL:GRASP_STRIKE]"
            lines[#lines+1]="\t[ATTACK_VERB:scratch:scratches]"
            lines[#lines+1]="\t[ATTACK_CONTACT_PERC:100]"
            lines[#lines+1]="\t[ATTACK_PENETRATION_PERC:100]"
            lines[#lines+1]="\t[ATTACK_PREPARE_AND_RECOVER:2:2]"
            lines[#lines+1]="\t[ATTACK_FLAG_EDGE]"
            lines[#lines+1]="\t[ATTACK_PRIORITY:"..(options.prioritize_bite and "SECOND" or "MAIN").."]"
        end
    end,
    toe_talons=function(lines,options,is_in_body)
        if options.toe_talons then
            lines[#lines+1]="[ATTACK:TSCRATCH:CHILD_TISSUE_LAYER_GROUP:BY_TYPE:STANCE:BY_CATEGORY:ALL:TALON]"
            lines[#lines+1]="\t[ATTACK_SKILL:STANCE_STRIKE]"
            lines[#lines+1]="\t[ATTACK_VERB:scratch:scratches]"
            lines[#lines+1]="\t[ATTACK_CONTACT_PERC:100]"
            lines[#lines+1]="\t[ATTACK_PENETRATION_PERC:100]"
            lines[#lines+1]="\t[ATTACK_PREPARE_AND_RECOVER:2:2]"
            lines[#lines+1]="\t[ATTACK_FLAG_EDGE]"
            lines[#lines+1]="\t[ATTACK_PRIORITY:"..(options.prioritize_bite and "SECOND" or "MAIN").."]"
            lines[#lines+1]="\t[ATTACK_FLAG_BAD_MULTIATTACK]"
        end
    end,
    }

post_gait_tweaks={
    bogey_polymorph=function(lines,options) 
        if options.can_bogey_polymorph then
            lines[#lines+1]="[CAN_DO_INTERACTION:"..random_object_parameters.token_prefix.."BOGEYMAN_POLYMORPH]"
            lines[#lines+1]="[CDI:ADV_NAME:Transform]"
            lines[#lines+1]="[CDI:TARGET:A:SELF_ONLY]"
            lines[#lines+1]="[CDI:USAGE_HINT:DEFEND]"
            lines[#lines+1]="[CDI:WAIT_PERIOD:100]"
            lines[#lines+1]="[CDI:DEFAULT_ICON:ADVENTURE_INTERACTION_ICON_TRANSFORM]"
        end
    end,
}

function build_body_from_rcp(rcp,lines,options)
    local l1=get_debug_logger()
    local l2=get_debug_logger(2)
    l1("Building body for "..options.token)
    options=options or {}
    options.rcp=rcp
    options.pcg_layering={}
    options.pcg_layering_modifier={}
    options.pref_str=options.pref_str or {}
    local body_base=rcp.body_base
    --[[**************************************** BOGEY
        //main thing is to switch over to a system where any two non-conflicting tweaks are allowed
            //it'll have to handle that in the descriptions

        //amplified ears
        //amplified nose
        //tusks
        //describe fangs
        //describe claws
        //long spindly fingers
        //no neck/long neck
        //giant feet
        //long power arms
        //long spindly arms/legs
        //arms made of bare bones
        //webbed feet and fingers
        //movement -- loping, knucklewalking

        //two heads
        //fish eyes
        //beak
        //four tentacles in place of arms]]
                
    if options.humanoid_only or (rcp.humanoidable and one_in(20)) then
        body_base="HUMANOID"
        options.btc="MAKE_HUMANOID"
    end
    options.body_string={}
    options.body_tweak_candidate={}
    options.body_string=body_base_fun[body_base](rcp,options)
    local add_to_body_unique=partial_function(add_unique,options.body_string)
    local function add_to_body(str) options.body_string[#options.body_string+1]=str end
    local is_in_body=partial_function(find_in_array_part,options.body_string)
    local function add_tweak_candidate(str) if not options.no_tweak then options.body_tweak_candidate[#options.body_tweak_candidate+1]=str end end
    local checked_head=false
    local had_head_when_checked=false
    if rcp.must_have_walrus_flippers then
        add_to_body_unique("RCP_FRONT_FLIPPER")
        add_to_body_unique("RCP_REAR_FLIPPER")
        pcg_layering_base="BEAST_WALRUS"
    end

    local pcg_layering_tbl={
        BEAST_AMORPHOUS=1,
        BEAST_SNAKE=1,
        BEAST_WORM_LONG=1,
        BEAST_WORM_SHORT=1,
        BEAST_INSECT=1,
        BEAST_SPIDER=1,
        BEAST_SCORPION=1,
        BEAST_BIPEDAL_DINOSAUR=1,
        BEAST_HUMANOID=1,
        BEAST_FRONT_GRASP=2,
        BEAST_QUADRUPED_BULKY=2,
        BEAST_QUADRUPED_SLINKY=2,
        BEAST_WALRUS=1,
    }

    if pcg_layering_tbl[options.pcg_layering_base] then
        local t=pcg_layering_tbl[options.pcg_layering_base]
        if t==1 then
            for i=1,5 do
                if one_in(2) then
                    options.pcg_layering[options.pcg_layering_base.."_DECORATION_"..i]=true
                end
            end
            options.pcg_layering[options.pcg_layering_base]=true
        elseif t==2 then
            for i=1,2 do
                if one_in(2) then
                    options.pcg_layering[options.pcg_layering_base.."_DECORATION_"..i]=true
                end
            end
            local legs_str="QUAD"
            if options.btc=="EIGHT_LEGGED" then 
                legs_str="OCT"
            elseif options.btc=="SIX_LEGGED" then 
                legs_str="HEX"
            else
                legs_str="QUAD" 
            end
            if one_in(2) then
                options.pcg_layering[options.pcg_layering_base.."_"..legs_str.."_DECORATION_1"]=true
            end
            if legs_str~="QUAD" then
                options.pcg_layering[options.pcg_layering_base.."_"..legs_str]=true
            else
                options.pcg_layering[options.pcg_layering_base]=true
            end
        end
    end

    if rcp.must_have_mantis_arms then add_to_body_unique("RCP_TWO_PART_ARMS") end
    if rcp.must_have_pincers then add_to_body_unique("RCP_PINCERS") end
    if rcp.must_have_grabbing_claws then add_to_body_unique("RCP_CLAW_ARMS") end
    if rcp.must_have_insect_wings or rcp.must_have_skin_wings or rcp.must_have_feather_wings then
        if rcp.always_flightless then
            add_to_body_unique("RCP_TWO_FLIGHTLESS_WINGS")
        else
            add_to_body_unique("RCP_TWO_WINGS")
        end
    elseif not options.no_tweak then
        if rcp.always_flightless and one_in(2) then
            if not is_in_body("RCP_TWO_FLIGHTLESS_WINGS") then
                add_tweak_candidate("WINGS_FLIGHTLESS")
            end
        elseif not is_in_body("RCP_TWO_WINGS") then
            add_tweak_candidate("WINGS")
        end
    end
    if rcp.must_have_tail or rcp.have_feather_tail or rcp.have_scorpion_tail then
        if not is_in_body("RCP_TAIL") then
            add_to_body("RCP_TAIL")
            add_tweak_candidate("TAIL")
        end
        options.tail_count=1
    elseif not rcp.cannot_have_tail then
        if not is_in_body("RCP_TAIL") then
            add_tweak_candidate("TAIL")
        else
            options.tail_count=1
        end
    end    
    if rcp.must_have_shell then
        add_to_body_unique("RCP_SHELL")
    elseif not options.no_tweak and not rcp.cannot_have_shell and not is_in_body("RCP_SHELL") then
        add_tweak_candidate("SHELL")
    end

    if is_in_body("RCP_HEAD") or is_in_body("RCP_CEPHALOTHORAX") then
        if rcp.must_have_elephant_trunk then
            add_to_body_unique("RCP_TRUNK")
        elseif not options.no_tweak then
            if not is_in_body("RCP_TRUNK") then
                add_tweak_candidate("TRUNK")
            end
        end
        if rcp.must_have_antennae and not is_in_body("RCP_ANTENNAE") then
            add_to_body("RCP_ANTENNAE")
        elseif not (options.no_tweak or options.cannot_have_antennae) and not is_in_body("RCP_ANTENNAE") then
            add_tweak_candidate("ANTENNAE")
        end
        local has_horns=is_in_body("RCP_1_HEAD_HORN") or is_in_body("RCP_2_HEAD_HORNS") or is_in_body("RCP_3_HEAD_HORNS") or is_in_body("RCP_4_HEAD_HORNS")
        if not has_horns then
            if rcp.must_have_one_head_horn then
                add_to_body("RCP_1_HEAD_HORN")
            else
                add_tweak_candidate("HEAD_HORNS")
            end
        end
        if rcp.must_have_giant_mandibles and not is_in_body("RCP_LARGE_MANDIBLES") then
            add_to_body("RCP_LARGE_MANDIBLES")
        elseif options.cannot_have_mandibles then
            add_tweak_candidate("LARGE_MANDIBLES")
        end
    end

    for k,v in pairs(btc1_tweaks) do 
        v(lines,options,add_to_body,add_to_body_unique,add_tweak_candidate)
    end
    if not options.btc and #options.body_tweak_candidate>0 then
        options.btc=pick_random(options.body_tweak_candidate)
        tweaks[options.btc].body(options.body_string,options)
    end
    local hooves = not not rcp.default_hoof_gloss
    if rcp.front_digits and rcp.front_digits>1 then
        if is_in_body("RCP_TWO_PART_ARMS") then
            add_to_body("RCP_"..tostring(rcp.front_digits).."_FINGERS")
            options.fingers=true
        end
        if not hooves then
            if is_in_body("RCP_FIRST_SIMPLE_LEGS") or is_in_body("RCP_SIMPLE_FRONT_LEGS") then
                add_to_body("RCP_"..tostring(rcp.front_digits).."_FRONT_TOES")
                l2("Adding toes")
                if debug_level>=2 then
                    print_table(options.body_string)
                end
                options.toes=true
            elseif is_in_body("RCP_FIRST_SIMPLE_LEGS_GRASP") or is_in_body("RCP_SIMPLE_FRONT_LEGS_GRASP") then
                add_to_body("RCP_"..tostring(rcp.front_digits).."_FRONT_FINGERS")
                options.fingers=true
            end
        end
    end
    if rcp.rear_digits and not hooves then
        if is_in_body("RCP_TWO_PART_LEGS") then
            l2("Adding toes")
            add_to_body("RCP_"..rcp.rear_digits.."_TOES")
            options.toes=true
            l2(options.toes)
            if debug_level>=2 then
                print_table(options.body_string)
            end
        elseif is_in_body("RCP_SECOND_SIMPLE_LEGS") or
         is_in_body("RCP_THIRD_SIMPLE_LEGS") or
         is_in_body("RCP_FOURTH_SIMPLE_LEGS") or
         is_in_body("RCP_FIFTH_SIMPLE_LEGS") or
         is_in_body("RCP_SIMPLE_FRONT_LEGS") or
         is_in_body("RCP_SIMPLE_REAR_LEGS") then
            add_to_body("RCP_"..rcp.rear_digits.."_REAR_TOES")
            l2("Adding toes")
            if debug_level>=2 then
                print_table(options.body_string)
            end
            options.toes=true
        end
    end
    local body_gloss_string={}
    if rcp.default_hoof_gloss then
        -- conditional checking if they have legs at all is probably not necessary, considering
        -- how glosses work
        body_gloss_string[#body_gloss_string+1]="RCP_GLOSS_HOOF"
    elseif rcp.default_paw_gloss then
        body_gloss_string[#body_gloss_string+1]="RCP_GLOSS_PAW"
    end
    options.r_class=rcp.c_class
    if options.never_uniform and options.r_class=="UNIFORM" then
        options.r_class="FLESHY"
    end
    -- do_not_make_uniform is night creatures, experiments in vanilla; always_make_uniform is flying spirit demons
    if options.sphere_rcm or (options.r_class~="UNIFORM" and not options.do_not_make_uniform and (options.always_make_uniform or one_in(20))) then
        options.r_class="UNIFORM"
    end
    if options.r_class~="UNIFORM" then
        if rcp.default_claws then
            if options.fingers then options.finger_claws=true end
            if options.toes then options.toe_claws=true end
        end
        if rcp.default_talons then
            if options.fingers then options.finger_talons=true end
            if options.toes then options.toe_talons=true end
        end
        if rcp.default_nails then
            if options.fingers then options.finger_nails=true end
            if options.toes then options.toe_nails=true end
        end
    end
    local r_class_table=random_creature_class[options.r_class]
    map_merge(options,r_class_table.features)
    if rcp.must_suck_blood_through_mouth then options.mouth=true end
    if is_in_body("RCP_TRUNK") then options.nose=false end
    body_tweak_candidate={}
    if not options.no_tweak then
        table_merge(body_tweak_candidate,r_class_table.tweaks)
        if options.is_evil then
            table_merge(body_tweak_candidate,r_class_table.evil_tweaks)
            if options.beak then add_tweak_candidate("BEAK_MISSING") end
            if options.nose then add_tweak_candidate("NOSE_MISSING") end
            if options.ribs then add_tweak_candidate("RIBS_EXTERNAL") end
            if options.eyelids then add_tweak_candidate("LIDLESS_EYES") end
        end
        if options.is_good then
            table_merge(body_tweak_candidate,r_class_table.good_tweaks)
        end
        if options.eyes then
            add_tweak_candidate("NO_EYES")
            add_tweak_candidate("ONE_EYE")
            add_tweak_candidate("THREE_EYES")
        end
    end
    if #body_tweak_candidate>0 then
        options.btc2=pick_random(body_tweak_candidate)
        if tweaks[options.btc2] and tweaks[options.btc2].body then tweaks[options.btc2].body(options.body_string,options) end
    end
    if options.eyes and (not options.btc2 or (options.btc2~="ONE_EYE" and options.btc2~="THREE_EYES")) then
        tweaks["TWO_EYES"].body(options.body_string,options)
    end
    options.eye_count = options.eye_count or 2
    -- no_glowing_eyes is only bogeymen/nightmares by default, always_glowing_eyes is werebeasts
    if options.eyes and not options.no_glowing_eyes and (options.always_glowing_eyes or one_in(10)) then
        options.glowing_eyes=true
    end
    if options.beak then add_to_body("RCP_BEAK") end
    if options.nose then add_to_body("RCP_NOSE") end
    if options.cheeks then add_to_body("RCP_CHEEKS") end
    if options.lungs then add_to_body("RCP_LUNGS") end
    if options.heart then add_to_body("RCP_HEART") end
    if options.guts then add_to_body("RCP_GUTS") end
    if options.throat then add_to_body("RCP_THROAT") end
    if options.spine then add_to_body("RCP_SPINE") end
    if options.neck then add_to_body("RCP_UPPER_SPINE") end
    if options.brain then add_to_body("RCP_BRAIN") else lines[#lines+1]="[NO_THOUGHT_CENTER_FOR_MOVEMENT]" end
    if options.skull then add_to_body("RCP_SKULL") end
    if options.mouth then add_to_body("RCP_MOUTH") end
    if options.tongue then add_to_body("RCP_TONGUE") end
    if options.teeth then add_to_body("RCP_TEETH") end
    if options.ribs then add_to_body("RCP_RIBS"..(btc2=="RIBS_EXTERNAL" and "_EXTERNAL" or "")) end
    if options.lips then add_to_body("RCP_LIPS") end
    if options.eyelids then add_to_body("RCP_"..options.eye_count.."_EYELID"..((options.eye_count>1) and "S" or "")) end
    for k,v in pairs(feature_tweaks) do
        v(rcp,options,add_to_body,add_to_body_unique,add_tweak_candidate)
    end
    options.attack_tweak=nil
    local has_tail=is_in_body("RCP_TAIL") or is_in_body("RCP_2_TAILS") or is_in_body("RCP_3_TAILS")

    local has_head=is_in_body("RCP_HEAD") or is_in_body("RCP_CEPHALOTHORAX")
    if rcp.must_have_scorpion_tail then
        if has_tail then
            add_to_body_unique("RCP_TAIL_STINGER")
            options.attack_tweak="TAIL_STINGER"
        end
    elseif rcp.must_have_insect_stinger then
        add_to_body("RCP_LOWER_BODY_STINGER")
        options.attack_tweak="INSECT_STINGER"
    elseif rcp.must_suck_blood_through_proboscis then
        if not is_in_body("RCP_PROBOSCIS") then
            if has_head then
                add_to_body("RCP_PROBOSCIS")
                options.attack_tweak="PROBOSCIS_BLOOD"
                options.has_proboscis=true
            end
        else 
            options.has_proboscis=true
        end
    end
    -- originally, no_random_attack_tweak was an implication of is_night_creature
    if not options.attack_tweak and not options.is_good and not options.no_tweak and not options.no_random_attack_tweak then
        if has_tail and not is_in_body("RCP_TAIL_STINGER") and one_in(20) then
            add_to_body("RCP_TAIL_STINGER")
            options.attack_tweak="TAIL_STINGER"
        end
    end
    if not options.attack_tweak and not options.is_good and not options.no_tweak and not options.no_random_attack_tweak then
        if not is_in_body("RCP_LOWER_BODY_STINGER") and one_in(20) then
            add_to_body("RCP_LOWER_BODY_STINGER")
            options.attack_tweak="INSECT_STINGER"
        end
    end
    if not options.attack_tweak and not options.is_good and not options.no_tweak and not options.no_random_attack_tweak then
        if not is_in_body("RCP_PROBOSCIS") and one_in(20) then
            if has_head then
                add_to_body("RCP_PROBOSCIS")
                options.attack_tweak="PROBOSCIS_BLOOD"
                options.has_proboscis=true
            end
        else 
            options.has_proboscis=true
        end
    end
    if options.pcg_layering_base~="BEAST_AMORPHOUS" then
        if is_in_body("RCP_PROBOSCIS") and options.pcg_layering_base=="BEAST_INSECT" then options.pcg_layering["BEAST_INSECT_PROBOSCIS"]=true end
        if is_in_body("RCP_TRUNK") then
            options.pcg_layering[options.pcg_layering_base.."_TRUNK"]=true
        end
        if has_horns then
            options.pcg_layering[options.pcg_layering_base.."_HORNS"]=true
        end
        if is_in_body("RCP_ANTENNAE") then
            options.pcg_layering[options.pcg_layering_base.."_ANTENNAE"]=true
        end
        if pcg_layering_base_info[options.pcg_layering_base].has_tail and options.tail_count then
            local num="THREE"
            if options.tail_count==2 then num="TWO"
            elseif options.tail_count==1 then num="ONE"
            end
            options.pcg_layering(options.pcg_layering_base.."_TAIL_"..num)
        end
        if is_in_body("RCP_LARGE_MANDIBLES") then
            options.pcg_layering[options.pcg_layering_base.."_MANDIBLES"]=true
        end
    end
    if is_in_body("RCP_SHELL") then
        options.pcg_layering[options.pcg_layering_base.."_SHELL_"..pcg_layering_base_info[options.pcg_layering_base].shell_pos]=true
    end

    local body_token="[BODY"
    for k,v in ipairs(options.body_string) do
        body_token=body_token..":"..v
    end
    l2("Final body:"..body_token)
    lines[#lines+1]=body_token.."]"
    if #body_gloss_string>0 then
        local body_gloss_token="[BODYGLOSS:"
        for k,v in ipairs(body_gloss_string) do
            body_gloss_token=body_gloss_token..":"..v
        end
        lines[#lines+1]=body_gloss_token.."]"
    end
    if is_in_body("RCP_TWO_WINGS") then
        options.add_fly_gaits=true
    end
    if is_in_body("RCP_TWO_PART_ARMS") then
        lines[#lines+1]="[CANOPENDOORS]"
        lines[#lines+1]="[EQUIPS]"
    end
    options.surface=r_class_table.surface
    if options.btc2 and tweaks[options.btc2] and tweaks[options.btc2].surface then options.surface=options.btc2 end
    l2("Surface: ",options.surface)
    if options.surface then tweaks[options.surface].surface(lines,options) end
    if not r_class_table.no_extra_materials then
        if is_in_body("RCP_1_HEAD_HORN") or is_in_body("RCP_2_HEAD_HORNS") or is_in_body("RCP_3_HEAD_HORNS") or is_in_body("RCP_4_HEAD_HORNS") then
            lines[#lines+1]="[USE_MATERIAL_TEMPLATE:HORN:HORN_TEMPLATE]"
            lines[#lines+1]="[USE_TISSUE_TEMPLATE:HORN:HORN_TEMPLATE]"
        end
        if is_in_body("RCP_SHELL") then
            lines[#lines+1]="[USE_MATERIAL_TEMPLATE:SHELL:SHELL_TEMPLATE]"
            lines[#lines+1]="[USE_TISSUE_TEMPLATE:SHELL:SHELL_TEMPLATE]"
        end
    end
    options.name_mat=options.name_mat or {}
    random_creature_class[options.r_class].body_plan(lines,options)

    -- demons, night creatures
    if options.r_class=="UNIFORM" or options.always_nobreathe then lines[#lines+1]="[NOBREATHE]" end
    if options.r_class=="UNIFORM" or options.btc2=="NO_EYES" or not options.eyes then lines[#lines+1]="[EXTRAVISION]" end
    if not is_in_body("RCP_TWO_WINGS") and options.intangible_flier and options.intangible then
        options.add_fly_gaits=true
    end
    if options.fixed_temp then
        lines[#lines+1]="[FIXED_TEMP:"..tostring(options.fixed_temp).."]"
    else
        lines[#lines+1]="[HOMEOTHERM:10040]"
    end
    if surface=="HAIR" then
        lines[#lines+1]="[BODY_DETAIL_PLAN:BODY_HAIR_TISSUE_LAYERS:HAIR]"
    elseif surface=="FEATHERS" then
        lines[#lines+1]="[BODY_DETAIL_PLAN:BODY_FEATHER_TISSUE_LAYERS:FEATHER]"
    elseif surface=="SCALES" then
        --NOTE: THESE CAN'T REPLACE THEIR SKIN/EXO WITH SCALES, SO THEY ARE EXTRA
        if options.r_class=="FLESHY" or options.r_class=="CHITIN_EXO" then
            lines[#lines+1]="[BODY_DETAIL_PLAN:BODY_HAIR_TISSUE_LAYERS:SCALE]"
        end
    end
   
    -- I assume this is a thing for portrait graphics
    local allowed_exp_colors={
        BLACK=true,
        CHARCOAL=true,
        MIDNIGHT_BLUE=true,
        ASH_GRAY=true,
        ECRU=true,
        IVORY=true,
        TAUPE_PURPLE=true,
        PALE_PINK=true,
        DARK_OLIVE=true,
        OLIVE=true,
    }
    -- experiment_colors is experiments only, in vanilla
    if options.r_class~="UNIFORM" and not rcp.cannot_have_color then
        if options.experiment_colors then
            if options.surface ~= "SKINLESS" then
                local candidates={}
                for k,color_pattern in ipairs(world.descriptor.color_pattern) do
                    if color_pattern.pattern == "MONOTONE" then
                        local cl = world.descriptor.color[color_pattern.color[1]]
                        if allowed_exp_colors[cl.token] then
                            candidates[color_pattern]=true
                        end
                    end
                end
                if #candidates>0 then
                    options.clp=pick_random_pairs(candidates)
                    options.exp_proc_surface_color=world.descriptor.color[options.clp.color[1]].token
                end
            end
        else
            local candidates={}
            local relevant_colors={}
            for k,v in pairs(color_picker_functions) do
                if v.cond(options) then relevant_colors[#relevant_colors+1]=v.color end
            end
            for k,color_pattern in ipairs(world.descriptor.color_pattern) do 
                if color_pattern.pattern == "MONOTONE" then 
                    local cl = world.descriptor.color[color_pattern.color[1]]
                    for k,v in pairs(relevant_colors) do
                        if v(cl) then candidates[color_pattern]=true end
                    end
                end
            end
            options.clp = pick_random_pairs(candidates)
        end
    end
    l2("Colors")
    if not options.clp then
        local num=5
        while not options.clp and num > 0 do
            local rand_color = pick_random(world.descriptor.color_pattern)
            if rand_color.pattern=="MONOTONE" then
                options.clp=rand_color
            end
            num = num - 1
        end
    end
    if options.clp then
        options.color_f=world.descriptor.color[options.clp.color[1]].col_f
        options.color_br=world.descriptor.color[options.clp.color[1]].col_br
        if options.surface and tweaks[options.surface] and tweaks[options.surface].color_surf then
            lines[#lines+1]="[SELECT_MATERIAL:"..tweaks[options.surface].color_surf.."]"
            lines[#lines+1]="[STATE_COLOR:ALL_SOLID:"..options.clp.token.."]"
        end
        options.pcg_clp=options.clp
    end
    if options.forced_color then
        options.color_f=options.forced_color.f
        options.color_b=options.forced_color.b
        options.color_br=options.forced_color.br
        lines[#lines+1]="[NO_UNIT_TYPE_COLOR]"
    end
    options.color_f=options.color_f or 0
    options.color_b=options.color_b or 0
    options.color_br=options.color_br or 0
    if options.color_f==0 and options.color_b==0 and options.color_br==0 then options.color_br=1 end
    lines[#lines+1]="[COLOR:"..tostring(options.color_f)..":"..tostring(options.color_b)..":"..tostring(options.color_br).."]"
    if options.glowing_eyes then
        local candidates={}
        for k,color_pattern in ipairs(world.descriptor.color_pattern) do
            if color_pattern.pattern == "MONOTONE" then
                local cl = world.descriptor.color[color_pattern.color[1]]
                -- very bright, saturated colors (original logic was one color <=0.05, at least one other >=0.75; this is near-equivalent)
                if cl.v >= 0.75 and cl.s > 0.93333 then
                    candidates[color_pattern]=true
                end
            end
        end
        options.eye_clp = pick_random_pairs(candidates)
        if not options.eye_clp then
            local num=5
            while not options.eye_clp and num > 0 do
                local rand_color = pick_random(world.descriptor.color_pattern)
                if rand_color.pattern=="MONOTONE" then
                    options.eye_clp=rand_color
                end
                num = num - 1
            end
        end
        local eye_f,eye_b,eye_br=6,0,1
        if options.eye_clp then
            local cl=world.descriptor.color[options.eye_clp.color[1]]
            lines[#lines+1]="[SELECT_MATERIAL:EYE]"
            lines[#lines+1]="[STATE_COLOR:ALL_SOLID:"..options.eye_clp.token.."]"
            eye_f=cl.col_f
            eye_br=cl.col_br
        end
        if eye_f==0 and eye_b==0 and eye_br==0 then eye_br=1 end
        options.eye_count=options.eye_count or 2
        lines[#lines+1]="[GLOWTILE:"..(options.eye_count >= 2 and [['"']] or "249").."]"
        lines[#lines+1]="[GLOWCOLOR:"..tostring(eye_f)..":"..tostring(eye_b)..":"..tostring(eye_br).."]"
    end
    if options.r_class~="UNIFORM" then
        if options.force_goo then options.goo=true options.ichor=false options.blood=false -- demons only, in vanilla
        elseif options.force_ichor then options.ichor=true options.goo=false options.blood=false -- angels only, in vanilla
        end
    end
    l2("Blood")
    if options.blood then
        lines[#lines+1]="[SELECT_TISSUE_LAYER:HEART:BY_CATEGORY:HEART]"
        lines[#lines+1]="  [PLUS_TISSUE_LAYER:SCALE:BY_CATEGORY:THROAT]"
        lines[#lines+1]="    [TL_MAJOR_ARTERIES]"
        lines[#lines+1]="[USE_MATERIAL_TEMPLATE:BLOOD:BLOOD_TEMPLATE]"
        --[[
        In vanilla, this was exclusively for night creature nightmares/bogeymen,
        and just checks for magenta colors; this is generalized 'cause
        I think end-users ought to be able to have whatever blood
        colors they want. options.blood_color is a function; default
        looks for darker magenta
        ]]
        if options.blood_color then
            local candidates={}
            for k,color_pattern in ipairs(world.descriptor.color_pattern) do
                if color_pattern.pattern == "MONOTONE" then
                    local cl = world.descriptor.color[color_pattern.color[1]]
                    if options.blood_color(cl) then
                        candidates[color_pattern]=true
                    end
                end
            end
            local blood_clp = pick_random_pairs(candidates)
            if blood_clp then
                lines[#lines+1]="\t[STATE_COLOR:ALL:"..blood_clp.token.."]"
            end
        end
        lines[#lines+1]="[BLOOD:LOCAL_CREATURE_MAT:BLOOD:LIQUID]"
        if not options.no_general_poison then lines[#lines+1]="[CREATURE_CLASS:GENERAL_POISON]" end -- bogeymen, nightmares
    elseif options.ichor then
        lines[#lines+1]="[SELECT_TISSUE_LAYER:HEART:BY_CATEGORY:HEART]"
          lines[#lines+1]=" [PLUS_TISSUE_LAYER:SCALE:BY_CATEGORY:THROAT]"
            lines[#lines+1]="\t[TL_MAJOR_ARTERIES]"
        lines[#lines+1]="[USE_MATERIAL_TEMPLATE:ICHOR:ICHOR_TEMPLATE]"
        lines[#lines+1]="[BLOOD:LOCAL_CREATURE_MAT:ICHOR:LIQUID]"
        if not options.no_general_poison then lines[#lines+1]="[CREATURE_CLASS:GENERAL_POISON]" end -- bogeymen, nightmares
    elseif options.goo then
        lines[#lines+1]="[SELECT_TISSUE_LAYER:HEART:BY_CATEGORY:HEART]"
          lines[#lines+1]=" [PLUS_TISSUE_LAYER:SCALE:BY_CATEGORY:THROAT]"
           lines[#lines+1]="\t[TL_MAJOR_ARTERIES]"
        lines[#lines+1]="[USE_MATERIAL_TEMPLATE:GOO:GOO_TEMPLATE]"
        lines[#lines+1]="[BLOOD:LOCAL_CREATURE_MAT:GOO:LIQUID]"
    end
    if options.finger_claws or options.toe_claws then
        lines[#lines+1]="[USE_MATERIAL_TEMPLATE:CLAW:NAIL_TEMPLATE]"
        lines[#lines+1]="[USE_TISSUE_TEMPLATE:CLAW:CLAW_TEMPLATE]"
        if options.finger_claws then lines[#lines+1]="[TISSUE_LAYER:BY_CATEGORY:FINGER:CLAW:FRONT]" end
        if options.toe_claws then lines[#lines+1]="[TISSUE_LAYER:BY_CATEGORY:TOE:CLAW:FRONT]" end
    end
    if options.finger_nails or options.toe_nails then
        lines[#lines+1]="[USE_MATERIAL_TEMPLATE:NAIL:NAIL_TEMPLATE]"
        lines[#lines+1]="[USE_TISSUE_TEMPLATE:NAIL:NAIL_TEMPLATE]"
        if options.finger_nails then lines[#lines+1]="[TISSUE_LAYER:BY_CATEGORY:FINGER:NAIL:FRONT]" end
        if options.toe_nails then lines[#lines+1]="[TISSUE_LAYER:BY_CATEGORY:TOE:NAIL:FRONT]" end
    end
    if options.finger_talons or options.toe_talons then
        lines[#lines+1]="[USE_MATERIAL_TEMPLATE:TALON:NAIL_TEMPLATE]"
        lines[#lines+1]="[USE_TISSUE_TEMPLATE:TALON:TALON_TEMPLATE]"
        if options.finger_talons then lines[#lines+1]="[TISSUE_LAYER:BY_CATEGORY:FINGER:TALON:FRONT]" end
        if options.toe_talons then lines[#lines+1]="[TISSUE_LAYER:BY_CATEGORY:TOE:TALON:FRONT]" end
    end
    if rcp.must_have_poison_bite then
        options.attack_tweak="POISON_BITE"
    end
    if rcp.must_have_webs then
        if not options.attack_tweak then
            options.attack_tweak="WEBS"
        end
        options.do_webs=true
    end
    l2("Tweaks")
    if not options.attack_tweak then
        if not options.is_good and not options.no_tweak and ((options.experiment_attack_tweak and one_in(4)) or options.strong_attack_tweak) and (not options.intangible or one_in(10)) then
            options.attack_tweak=pick_random_conditional_pairs(attack_tweaks,"cond",options)
        end
    end
    if options.attack_tweak then
        if not (attack_tweaks[options.attack_tweak] and attack_tweaks[options.attack_tweak].apply) then
            log(options.attack_tweak,"has no code associated! Did someone forget to add it?")
            print_table(options.attack_tweak)
        else
            attack_tweaks[options.attack_tweak].apply(lines,options)
        end
    end
    -- USE THIS VAR BECAUSE CAN BE OVERWRITTEN BY WEBS IN SPIDERS
    if options.do_webs then
        lines[#lines+1]="[THICKWEB][WEBIMMUNE]"
        lines[#lines+1]="[USE_MATERIAL_TEMPLATE:SILK:SILK_TEMPLATE]"
        lines[#lines+1]="[WEBBER:LOCAL_CREATURE_MAT:SILK]"
        lines[#lines+1]="[CAN_DO_INTERACTION:RCP_MATERIAL_EMISSION]"
            lines[#lines+1]="[CDI:ADV_NAME:Spray web]"
            lines[#lines+1]="[CDI:USAGE_HINT:ATTACK]"
            lines[#lines+1]="[CDI:MATERIAL:LOCAL_CREATURE_MAT:SILK:WEB_SPRAY]"
            lines[#lines+1]="[CDI:TARGET:C:LINE_OF_SIGHT]"
            lines[#lines+1]="[CDI:TARGET_RANGE:C:5]"
            lines[#lines+1]="[CDI:MAX_TARGET_NUMBER:C:1]"
            lines[#lines+1]="[CDI:WAIT_PERIOD:30]"
            lines[#lines+1]="[CDI:DEFAULT_ICON:ADVENTURE_INTERACTION_ICON_SPRAY_WEB]"
    end
    if options.fire_immune then lines[#lines+1]="[FIREIMMUNE]" end
    for k,v in pairs(post_attack_tweaks) do
        v(lines,options,is_in_body)
    end
    if options.fixed_temp and options.r_class~="UNIFORM" then
        lines[#lines+1]="[SELECT_MATERIAL:ALL]"
        lines[#lines+1]="\t[MAT_FIXED_TEMP:"..tostring(options.fixed_temp).."]"
        lines[#lines+1]="\t[HEATDAM_POINT:NONE]"
        lines[#lines+1]="\t[COLDDAM_POINT:NONE]"
        lines[#lines+1]="\t[IGNITE_POINT:NONE]"
    end
    l2("Gaits")
    -- i *think* that in vanilla this is only experiments
    if not options.cannot_swim then
        lines[#lines+1]="[APPLY_CREATURE_VARIATION:STANDARD_SWIMMING_GAITS:2900:2175:1450:725:3900:5900]"
    end
    if options.add_fly_gaits then
        lines[#lines+1]="[FLIER]"
        lines[#lines+1]="[APPLY_CREATURE_VARIATION:STANDARD_FLYING_GAITS:900:675:450:225:1900:2900]"
    end
    local walk_speed=options.special_walk_speed or options.walk_speed
    if options.walk_var then
        local speeds={walk_speed,walk_speed*0.75,walk_speed/2,walk_speed/4,walk_speed*2+100,walk_speed*3+200}
        local str="[APPLY_CREATURE_VARIATION:"..options.walk_var
        for k,v in ipairs(speeds) do
            str=str..":"..tostring(math.floor(v))
        end
        lines[#lines+1]=str.."]"
    end
    lines[#lines+1]="[APPLY_CREATURE_VARIATION:STANDARD_CRAWLING_GAITS:900:675:450:225:1900:2900]"
    for k,v in ipairs(climbing_parts) do
        if is_in_body(v) then
            lines[#lines+1]="[APPLY_CREATURE_VARIATION:STANDARD_CLIMBING_GAITS:900:675:450:225:1900:2900]"
            break
        end
    end
    for k,v in pairs(post_gait_tweaks) do
        v(lines,options)
    end
    l2("Done")
end

function build_description(lines,options)
    local l2=get_debug_logger(2)
    l2("Making description")
    local desc="[DESCRIPTION:A"
    if options.body_size>=6000000 then
        desc=desc..pick_random({" great"," gigantic"," towering", "n enormous"," huge"})
    elseif options.body_size>=400000 then desc=desc.." very large"
    elseif options.body_size>=80000 then desc=desc.." large"
    elseif options.body_size<=60000 then 
        -- technically a bug fix
        if options.body_size<=30000 then 
            desc=desc.." very small"
        else
            desc=desc.." small"
        end
    end
    desc=desc.." "
    if options.btc2 and tweaks[options.btc2] and tweaks[options.btc2].adj then
        desc=desc..tweaks[options.btc2].adj.." "
    end
    if options.btc and tweaks[options.btc] and tweaks[options.btc].adj then
        desc=desc..tweaks[options.btc].adj.." "
    end
    l2("Adjective done")
    desc=desc..options.rcp.name_string
    if options.btc and tweaks[options.btc] and tweaks[options.btc].form_desc then
        local t=tweaks[options.btc]
        desc=desc.." "..(options.is_evil and t.twisted_desc or t.form_desc)
    end
    if options.btc2 and tweaks[options.btc2] and tweaks[options.btc2].with_desc then
        desc=desc.." "..tweaks[options.btc2].with_desc
    end
    if options.post_mat_adj then
        desc=desc.." "..options.post_mat_adj
    end
    desc=desc.."."
    options.and_add=true
    options.lacy_wings,options.feathered_wings,options.bat_wings=false,false,false
    if options.rcp.must_have_insect_wings then options.lacy_wings=true
    elseif options.rcp.must_have_skin_wings then options.bat_wings=true
    elseif options.rcp.must_have_feather_wings then options.feathered_wings=true
    end
    if options.btc and tweaks[options.btc] and tweaks[options.btc].has_desc_func then
        desc=desc..tweaks[options.btc].has_desc_func(options)
    else
        options.and_add=false
    end

    local add=nil
    if not options.no_extra_description then

        if options.and_add then desc=desc.." and " else desc=desc.." " end
        -- Angels, experiments and night creatures all have this in vanilla!
        if options.custom_desc_func then
            add=options.custom_desc_func(options)
        else
            local add_tbl=default_desc_adds
            if options.is_good then
                add_tbl=good_desc_adds
            elseif options.is_evil then
                add_tbl=evil_desc_adds
            end
            local cand={}
            for k,v in pairs(add_tbl) do
                if not v.cond or v.cond(options) then cand[#cand+1]=v end
            end
            add=pick_random(cand).add(options)
        end

        if add then
            if not options.and_add then add=capitalize_string_first_word(add) end
            desc=desc..add
        end
    end

    l2("Extra done")

    if options.forced_odor_string and (options.always_odor or options.r_class ~= "UNIFORM") then
        if one_in(options.forced_odor_chance) then
            lines[#lines+1]="[ODOR_STRING:"..options.forced_odor_string.."]"
            lines[#lines+1]="[ODOR_LEVEL:"..tostring(options.forced_odor_level or 90).."]"
        end
    end

    if options.eye_clp then
        desc=desc..". Its "..(options.eye_count>1 and "eyes glow" or "eye glows").." "..world.descriptor.color[options.eye_clp.color[1]].name
    end
    if options.clp then
        if options.surface and tweaks[options.surface] and tweaks[options.surface].color_desc then
            desc=desc..tweaks[options.surface].color_desc(options)
        end
    end
    l2("Colors done")
    desc=desc.."."
    --EXPERIMENTS, ANGELS, NIGHT CREATURES
    if options.end_phrase then
        desc=desc.." "..options.end_phrase
    elseif options.attack_tweak and attack_tweaks[options.attack_tweak] and attack_tweaks[options.attack_tweak].desc then
        desc=desc.." "..attack_tweaks[options.attack_tweak].desc(options)
    end
    lines[#lines+1]=desc.."]"
    if #options.pref_str == 0 and options.fallback_pref_str then options.pref_str[1]=options.fallback_pref_str end
    for k,v in ipairs(options.pref_str) do
        lines[#lines+1]="[PREFSTRING:"..v.."]"
    end
    l2("Prefstring done")
    if options.feature_flavor_adj then
        options.flavor_adj=options.flavor_adj or {}
        local function add_flavor(str) options.flavor_adj[#options.flavor_adj+1]=str end
        if options.clp then
            add_flavor(world.descriptor.color[options.clp.color[1]].name)
        end
        if options.btc and tweaks[options.btc] and tweaks[options.btc].flavor_adj then
            table_merge(options.flavor_adj,tweaks[options.btc].flavor_adj)
        end
        if options.btc2 and tweaks[options.btc2] and tweaks[options.btc2].flavor_adj then
            table_merge(options.flavor_adj,tweaks[options.btc2].flavor_adj)
        end
        if options.attack_tweak and tweaks[options.attack_tweak] and tweaks[options.attack_tweak].flavor_adj then
            table_merge(options.flavor_adj,tweaks[options.attack_tweak].flavor_adj)
        end
    end
    l2("Flavor adj done, description done")
end

function build_pcg_graphics(lines,options)
    local l2=get_debug_logger(2)
    l2("Doing pcg graphics")
    if options.lacy_wings then
        if pcg_layering_base_info[options.pcg_layering_base].lacy_wings then
            for k,v in ipairs(pcg_layering_base_info[options.pcg_layering_base].lacy_wings) do
                options.pcg_layering[options.pcg_layering_base.."_WINGS_LACY_"..v]=true
            end
        end
    end
    if options.feathered_wings then
        if pcg_layering_base_info[options.pcg_layering_base].feathered_wings then
            for k,v in ipairs(pcg_layering_base_info[options.pcg_layering_base].feathered_wings) do
                options.pcg_layering[options.pcg_layering_base.."_WINGS_FEATHERED_"..v]=true
            end
        end
    end
    if options.bat_wings then
        if pcg_layering_base_info[options.pcg_layering_base].bat_wings then
            for k,v in ipairs(pcg_layering_base_info[options.pcg_layering_base].bat_wings) do
                options.pcg_layering[options.pcg_layering_base.."_WINGS_BAT_"..v]=true
            end
        end
    end
    l2("Wings done")
    local do_colors=false
    for k,v in ipairs {"SURFACE_FUR","SURFACE_FEATHERS","SURFACE_SCALES","SURFACE_SKIN","SURFACE_SKINLESS"} do
        if options.pcg_layering_modifier[v] then 
            do_color=true
            break
        end
    end
    if do_color then
      for k,v in ipairs {
        "MANDIBLES","HORNS","WINGS_LACY_BACK",
        "WINGS_FEATHERED_BACK","WINGS_FEATHERED_FRONT",
        "WINGS_BAT_BACK","WINGS_BAT_FRONT",
        "EYE_ONE","EYE_TWO","EYE_THREE","SHELL_BACK",
        "SHELL_FRONT","TRUNK","ANTENNAE"
      } do
        if options.pcg_layering[options.pcg_layering_base.."_"..v] then
            options.pcg_layering[options.pcg_layering_base.."_ORGANIC_"..v]=true
        end
      end
    end
    -- this is just werebeasts in vanilla
    if options.use_werebeast_pcg then
        local s = string.gsub(options.rcp.type,"MAMMAL_","WEREBEAST_")
        s=string.gsub(s,"REPTILE_","WEREBEAST_")
        options.pcg_layering[s]=true
    end
    local have_pcg_layer=false
    for k,v in pairs(options.pcg_layering) do
        have_pcg_layer=true -- yes, this is the best way to do this
        break
    end
    if have_pcg_layer then
        l2("Doing pcg layer")
        lines[#lines+1]="[PROCEDURAL_CREATURE_GRAPHICS:DEFAULT]"
        local did_werebeast_layer=false
        for k,v in pairs(options.pcg_layering) do
            if string.sub(k,1,9)=="WEREBEAST" then
                did_werebeast_layer=true
                lines[#lines+1]="[PCG_LAYERING:"..k.."]"
            end
        end
        l2("Doing pcg layer")
        -- humanoid experiments only
        if options.experiment_layering then
            l2("Doing pcg layer")
            local row=surface_color_raw_rows[options.exp_proc_surface_color] or 10
            l2("Doing pcg layer")
            if options.surface=="SKINLESS" then row=11 end
            local color_str="[USE_STANDARD_NEX_BODY_PALETTE:"..tostring(row).."]"
            lines[#lines+1]="[PCG_LAYERING:EXPERIMENT_HUMANOID_SHADOW]"
            l2("Doing pcg layer")
            local function add_layer(str) 
                lines[#lines+1]="[PCG_LAYERING:EXPERIMENT_HUMANOID_"..str.."]"
                lines[#lines+1]=color_str
            end
            l2("Doing pcg layer")
            if options.pcg_layering.BEAST_HUMANOID_WINGS_LACY_BACK then add_layer("WINGS_LACY") end
            if options.pcg_layering.BEAST_HUMANOID_WINGS_FEATHERED_BACK then add_layer("WINGS_FEATHERED") end
            if options.pcg_layering.BEAST_HUMANOID_WINGS_BAT_BACK then add_layer("WINGS_BAT") end
            l2("Doing pcg layer")
            for k,v in ipairs({"SKINLESS","SKIN","SCALES","FEATHERS","FUR"}) do
                if options.pcg_layering_modifier["SURFACE_"..v] then add_layer("TORSO_"..v) end
            end
            l2("Doing pcg layer")
            if options.pcg_layering_modifier.EXTERNAL_RIBS then add_layer("EXTERNAL_RIBS") end
            -- i don't know if i'm not supposed to do lua this way
            l2("Doing pcg layer")
            for k,v in ipairs({"LEG","FOOT","ARM","HAND"}) do
                add_layer(v.."_LEFT")
                add_layer(v.."_RIGHT")
            end
            l2("Doing pcg layer")
            for k,v in ipairs({"SKIN","SCALES","FEATHERS","FUR"}) do
                if options.pcg_layering_modifier["SURFACE_"..v] then add_layer("HEAD_"..v) end
            end
            l2("Doing pcg layer")
            if options.pcg_layering_modifier["SURFACE_SKINLESS"] then add_layer("HEAD_SKIN") end -- skinless counts as skin
            local function add_if_layer(str)
                if options.pcg_layering_modifier["BEAST_HUMANOID_"..str] then add_layer(str) return true else return false end
            end
            l2("Doing pcg layer")
            add_if_layer("EYE_ONE")
            add_if_layer("EYE_TWO")
            add_if_layer("EYE_THREE")
            if not add_if_layer("MANDIBLES") then add_layer("MOUTH") end
            l2("Doing pcg layer")
            local horn_sets={
                {"3"},
                {"2","4"},
                {"1","3","5"},
                {"1","2","4","5"}
            }
            l2("Doing pcg layer")
            if options.pcg_layering_modifier.horn_count then
                for k,v in ipairs(horn_sets[options.pcg_layering_modifier.horn_count]) do
                    add_layer("HORN_"..options.pcg_layering_modifier.HORN..v)
                end
            end
            lines[#lines+1]="[PROCEDURAL_CREATURE_GRAPHICS:PORTRAIT]"
            l2("Doing pcg layer")
            local function add_portrait_layer(str)
                lines[#lines+1]="[PCG_LAYERING:EXPERIMENT_HUMANOID_PORTRAIT_"..str.."]"
                lines[#lines+1]=color_str
            end
            l2("Doing pcg layer")
            if options.pcg_layering.BEAST_HUMANOID_WINGS_LACY_BACK then 
                add_portrait_layer("WING_LEFT_LACY")
                add_portrait_layer("WING_RIGHT_LACY")
            end
            l2("Doing pcg layer")
            if options.pcg_layering.BEAST_HUMANOID_WINGS_FEATHERED_BACK then 
                add_portrait_layer("WING_LEFT_FEATHERED")
                add_portrait_layer("WING_RIGHT_FEATHERED")
            end
            l2("Doing pcg layer")
            if options.pcg_layering.BEAST_HUMANOID_WINGS_BAT_BACK then 
                add_portrait_layer("WING_LEFT_BAT")
                add_portrait_layer("WING_RIGHT_BAT")
            end
            l2("Doing pcg layer")
            for k,v in ipairs({"SKIN","SKINLESS","SCALES","FEATHERS","FUR"}) do
                if options.pcg_layering_modifier["SURFACE_"..v] then
                    add_portrait_layer("TORSO_"..v)
                    add_portrait_layer("ARM_LEFT_"..v)
                    add_portrait_layer("ARM_RIGHT_"..v)
                    add_portrait_layer("HEAD_"..v)
                end
            end
            l2("Doing pcg layer")
            if options.pcg_layering_modifier.EXTERNAL_RIBS then add_portrait_layer("EXTERNAL_RIBS") end
            local function add_maybe_skinless_portrait(str)
                if options.pcg_layering_modifier.SURFACE_SKINLESS then add_portrait_layer(str.."_SKINLESS")
                else add_portrait_layer(str)
                end
            end
            l2("Doing pcg layer")
            for k,v in ipairs({"ONE","TWO","THREE"}) do
                if options.pcg_layering[options.pcg_layering_base.."_EYE_"..v] then
                    add_maybe_skinless_portrait("HEAD_EYE_"..v)
                end
            end
            l2("Doing pcg layer")
            if options.pcg_layering.HUMANOID_MANDIBLES then
                add_maybe_skinless_portrait("HEAD_MANDIBLES")
            else
                add_maybe_skinless_portrait("HEAD_MOUTH")
            end
            l2("Doing pcg layer")
            if options.pcg_layering.BEAST_HUMANOID_TRUNK and options.pcg_layering_modifier.TRUNK then
                add_portrait_layer("TRUNK_"..options.pcg_layering_modifier.TRUNK)
            end
            l2("Doing pcg layer")
            if options.pcg_layering.BEAST_HUMANOID_ANTENNAE and options.pcg_layering_modifier.ANTENNAE then
                add_portrait_layer("ANTENNA_"..options.pcg_layering_modifier.ANTENNA)
            end
            l2("Doing pcg layer")
            if options.pcg_layering_modifier.horn_count then
                for k,v in ipairs(horn_sets[options.pcg_layering_modifier.horn_count]) do
                    add_portrait_layer("HORN_"..options.pcg_layering_modifier.HORN..v)
                end
            end
            l2("Doing pcg layer")
        elseif not did_werebeast_layer then 
            local is_small=options.body_size<=500000
            l2("Doing pcg layer")
            if is_small then
                for k,v in pairs(options.pcg_layering) do
                    local str=string.gsub(k,"BEAST_","BEAST_SMALL_")
                    lines[#lines+1]="[PCG_LAYERING:"..str.."]"
                end
            else
                local pal_strs={}
                if options.surface=="SKINLESS" then
                    pal_strs={
                        "CRIMSON","RED","RED","RED","RED","RED","RED","RED","RED"
                    }
                    pal_strs.shell="RED"
                elseif options.pcg_clp then
                    pal_strs[1]=world.descriptor.color[options.pcg_clp.color[1]].token
                    for i=2,9 do
                        pal_strs[i]=pick_random(world.descriptor.color).token
                    end
                    pal_strs.shell=pick_random(world.descriptor.color).token
                elseif options.fire_mat then
                    pal_strs={
                        "YELLOW","RED","ORANGE","RED","ORANGE","RED","ORANGE","RED","ORANGE"
                    }
                    pal_strs.shell=pick_random({"YELLOW","RED","ORANGE"})
                else
                    pal_strs={
                        "WHITE","GRAY","ASH_GRAY","SLATE_GRAY","GRAY","ASH_GRAY","SLATE_GRAY","GRAY","ASH_GRAY"
                    }
                    pal_strs.shell=pick_random({"WHITE","SLATE_GRAY","GRAY","ASH_GRAY"})
                end
                for k,v in pairs(options.pcg_layering) do
                    lines[#lines+1]="[PCG_LAYERING:"..k.."]"
                    if pal_selection[k] then
                        lines[#lines+1]="[USE_COLOR_PALETTE:"..pal_strs[pal_selection[k]].."]"
                    end
                end
            end
            l2("Doing pcg layer")
        end
    end
    l2("Description done")
end

function build_procgen_creature(rcp,lines,options)
    build_body_from_rcp(rcp,lines,options)
    build_description(lines,options)
    build_pcg_graphics(lines,options)
end