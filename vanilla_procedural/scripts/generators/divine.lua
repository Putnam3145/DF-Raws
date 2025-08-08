metal_by_sphere={ -- global on purpose so mods can adjust these
    LIGHT={
        name="shining metal",
        col="7:0:1",
        color="WHITE"
    },
    LIGHTNING={
        name="flashing metal",
        col="6:0:1",
        color="YELLOW"
    },
    BLIGHT={
        name="rusted metal",
        col="4:0:0",
        color="RUST"
    },
    CHAOS={
        name="twisting metal",
        col="4:0:1",    
        color="RED"
    },
    DARKNESS={
        name="dark metal",
        col="0:0:1",
        color="BLACK"
    },
    DAWN={
        name="glowing metal",
        col="6:0:1",
        color="YELLOW"
    },
    DAY={
        name="bright metal",
        col="7:0:1",
        color="WHITE"
    },
    DEATH={
        name="pale metal",
        col="3:0:1",
        color="PALE_BLUE"
    },
    DEFORMITY={
        name="pock-marked metal",
        col="0:0:1",
        color="BLACK"
    },
    DISEASE={
        name="blistered metal",
        col="0:0:1",
        color="BLACK"
    },
    EARTH={
        name="ruddy metal",
        col="6:0:0",
        color="BURNT_SIENNA"
    },
    FIRE={
        name="flickering metal",
        col="6:0:1",
        color="YELLOW"
    },
    JEWELS={
        name="faceted metal",
        col="2:0:1",
        color="GREEN"
    },
    MOON={
        name="translucent metal",
        col="3:0:1",
        color="CLEAR"
    },
    MOUNTAINS={
        name="frosty metal",
        col="7:0:1",
        color="WHITE"
    },
    MUCK={
        name="slick metal",
        col="6:0:0",
        color="BROWN"
    },
    MUSIC={
        name="singing metal",
        col="7:0:1",
        color="WHITE"
    },
    NIGHT={
        name="black metal",
        col="0:0:1",
        color="BLACK"
    },
    RAINBOWS={
        name="multicolored metal",
        col="2:0:1",
        color="CLEAR"
    },
    SKY={
        name="clear blue metal",
        col="3:0:1",
        color="SKY_BLUE"
    },
    STARS={
        name="twinkling metal",
        col="7:0:1",
        color="WHITE"
    },
    STORMS={
        name="crashing metal",
        col="7:0:0",
        color="GRAY"
    },
    SUN={
        name="blazing metal",
        col="7:0:1",
        color="WHITE"
    },
    THUNDER={
        name="booming metal",
        col="7:0:0",
        color="GRAY"
    },
    TORTURE={
        name="searing metal",
        col="0:0:1",
        color="BLACK"
    },
    VOLCANOS={
        name="flowing metal",
        col="4:0:1",
        color="RED"
    },
}

materials.divine.metal.default=function(sphere)
    local mat_info=metal_by_sphere[sphere]
    if mat_info then
        local m={weight=1,mat={}}
        m.mat[#m.mat+1]="[USE_MATERIAL_TEMPLATE:METAL_TEMPLATE]"
        m.mat[#m.mat+1]="[DISPLAY_COLOR:"..mat_info.col.."]"
        m.mat[#m.mat+1]="[BUILD_COLOR:"..mat_info.col.."]"
        m.mat[#m.mat+1]="[STATE_COLOR:ALL_SOLID:"..mat_info.color.."]"
        m.mat[#m.mat+1]="[STATE_NAME_ADJ:ALL_SOLID:"..mat_info.name.."]"
        m.mat[#m.mat+1]="[MATERIAL_VALUE:200]"
        m.mat[#m.mat+1]="[SPEC_HEAT:7500]"
        m.mat[#m.mat+1]="[MELTING_POINT:NONE]"
        m.mat[#m.mat+1]="[BOILING_POINT:NONE]"
        m.mat[#m.mat+1]="[ITEMS_WEAPON][ITEMS_WEAPON_RANGED][ITEMS_AMMO][ITEMS_DIGGER][ITEMS_ARMOR][ITEMS_ANVIL]"
        m.mat[#m.mat+1]="[ITEMS_HARD]"
        m.mat[#m.mat+1]="[ITEMS_METAL]"
        m.mat[#m.mat+1]="[ITEMS_BARRED]"
        m.mat[#m.mat+1]="[ITEMS_SCALED]"
        m.mat[#m.mat+1]="[SOLID_DENSITY:1000]"
        m.mat[#m.mat+1]="[LIQUID_DENSITY:1000]"
        m.mat[#m.mat+1]="[MOLAR_MASS:20000]"
        m.mat[#m.mat+1]="[IMPACT_YIELD:1000000]"
        m.mat[#m.mat+1]="[IMPACT_FRACTURE:2000000]"
        m.mat[#m.mat+1]="[IMPACT_STRAIN_AT_YIELD:0]"
        m.mat[#m.mat+1]="[COMPRESSIVE_YIELD:1000000]"
        m.mat[#m.mat+1]="[COMPRESSIVE_FRACTURE:2000000]"
        m.mat[#m.mat+1]="[COMPRESSIVE_STRAIN_AT_YIELD:0]"
        m.mat[#m.mat+1]="[TENSILE_YIELD:1000000]"
        m.mat[#m.mat+1]="[TENSILE_FRACTURE:2000000]"
        m.mat[#m.mat+1]="[TENSILE_STRAIN_AT_YIELD:0]"
        m.mat[#m.mat+1]="[TORSION_YIELD:1000000]"
        m.mat[#m.mat+1]="[TORSION_FRACTURE:2000000]"
        m.mat[#m.mat+1]="[TORSION_STRAIN_AT_YIELD:0]"
        m.mat[#m.mat+1]="[SHEAR_YIELD:1000000]"
        m.mat[#m.mat+1]="[SHEAR_FRACTURE:2000000]"
        m.mat[#m.mat+1]="[SHEAR_STRAIN_AT_YIELD:0]"
        m.mat[#m.mat+1]="[BENDING_YIELD:1000000]"
        m.mat[#m.mat+1]="[BENDING_FRACTURE:2000000]"
        m.mat[#m.mat+1]="[BENDING_STRAIN_AT_YIELD:0]"
        m.mat[#m.mat+1]="[MAX_EDGE:12000]"
        return m
    end
end

silk_by_sphere={
    LIGHT={
        name="glowing cloth",
        col="7:0:1",
        color="WHITE"
    },
    LIGHTNING={
        name="flashing sparks",
        col="6:0:1",
        color="YELLOW"
    },
    BEAUTY={
        name="dancing wisps",
        col="6:0:1",
        color="YELLOW"
    },
    BLIGHT={
        name="rotted fabric",
        col="0:0:1",
        color="BLACK"
    },
    CHAOS={
        name="never-still cloth",
        col="4:0:1",
        color="RED"
    },
    DARKNESS={
        name="liquid darkness",
        col="0:0:1",
        color="BLACK"
    },
    DAWN={
        name="shining cloth",
        col="6:0:1",
        color="ORANGE"
    },
    DAY={
        name="bright cloth",
        col="7:0:1",
        color="WHITE"
    },
    DEATH={
        name="pale fabric",
        col="3:0:1",
        color="PALE_BLUE"
    },
    DEFORMITY={
        name="twisted fabric",
        col="0:0:1",
        color="BLACK"
    },
    DISEASE={
        name="patchy cloth",
        col="7:0:0",
        color="GRAY"
    },
    DREAMS={
        name="wispy cloth",
        col="1:0:1",
        color="BLUE"
    },
    DUSK={
        name="translucent cloth",
        col="3:0:1",
        color="CLEAR"
    },
    FIRE={
        name="flickering cloth",
        col="6:0:1",
        color="YELLOW"
    },
    JEWELS={
        name="faceted cloth",
        col="2:0:1",
        color="GREEN"
    },
    LAKES={
        name="still blue fabric",
        col="1:0:1",
        color="BLUE"
    },
    LIES={
        name="heavy cloth",
        col="0:0:1",
        color="BLACK"
    },
    MIST={
        name="misty cloth",
        col="7:0:0",
        color="CLEAR"
    },
    MOON={
        name="white cloth",
        col="7:0:1",
        color="WHITE"
    },
    MUCK={
        name="dirty fabric",
        col="6:0:0",
        color="BROWN"
    },
    MUSIC={
        name="sonorous lines",
        col="0:0:1",
        color="BLACK"
    },
    NIGHT={
        name="pitch-black fabric",
        col="0:0:1",
        color="BLACK"
    },
    NIGHTMARES={
        name="screaming mouths",
        col="5:0:0",
        color="TAUPE_MEDIUM"
    },
    OCEANS={
        name="undulating cloth",
        col="3:0:0",
        color="SEA_GREEN"
    },
    RAIN={
        name="moist fabric",
        col="3:0:1",
        color="CLEAR"
    },
    RAINBOWS={
        name="multicolored cloth",
        col="2:0:1",
        color="CLEAR"
    },
    RIVERS={
        name="flowing fabric",
        col="1:0:1",
        color="BLUE"
    },
    SKY={
        name="clear blue cloth",
        col="3:0:1",
        color="SKY_BLUE"
    },
    STARS={
        name="motes of light",
        col="7:0:1",
        color="WHITE"
    },
    STORMS={
        name="flowing cloth",
        col="7:0:0",
        color="GRAY"
    },
    SUN={
        name="blazing cloth",
        col="7:0:1",
        color="WHITE"
    },
    THUNDER={
        name="shining cloth",
        col="7:0:1",
        color="WHITE"
    },
    TRICKERY={
        name="shimmering cloth",
        col="3:0:1",
        color="CLEAR"
    },
    TWILIGHT={
        name="shadow stuff",
        col="0:0:1",
        color="BLACK"
    },
    VOLCANOS={
        name="molten liquid",
        col="4:0:1",
        color="RED"
    },
    WATER={
        name="liquid cloth",
        col="1:0:1",
        color="BLUE"
    },
    WIND={
        name="rustling fabric",
        col="7:0:0",
        color="GRAY"
    },
}

materials.divine.silk.default=function(sphere)
    local m={weight=0,mat={}}
    local mat_info=silk_by_sphere[sphere]
    if mat_info then
        m.weight=1
        m.mat[#m.mat+1]="[USE_MATERIAL_TEMPLATE:SILK_TEMPLATE]"
        m.mat[#m.mat+1]="[DISPLAY_COLOR:"..mat_info.col.."]"
        m.mat[#m.mat+1]="[BUILD_COLOR:"..mat_info.col.."]"
        m.mat[#m.mat+1]="[STATE_COLOR:ALL_SOLID:"..mat_info.color.."]"
        m.mat[#m.mat+1]="[STATE_NAME_ADJ:ALL_SOLID:"..mat_info.name.."]"
        m.mat[#m.mat+1]="[MATERIAL_VALUE:300]"
        m.mat[#m.mat+1]="[IGNITE_POINT:NONE]"
        m.mat[#m.mat+1]="[SOLID_DENSITY:1]"
        m.mat[#m.mat+1]="[MOLAR_MASS:1]"
        m.mat[#m.mat+1]="[ITEMS_SOFT]"
        return m
    end
end