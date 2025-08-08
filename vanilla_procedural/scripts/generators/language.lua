languages.GEN_DIVINE=function()

    local letters={}
    letters.vowel={}
    letters.cons={}
    letters.vowel.COMMON_NUM=5
    letters.vowel.NUM=35
    letters.cons.COMMON_NUM=12
    letters.cons.NUM=22
    letters.vowel.lookup={
        "a","e","i","o","u",
        "ae","ai","ao","au","ea","ei","eo","eu","ia","ie","io","iu","oa","oe","oi","ou","ua","ue","ui","uo","ah","eh","ih","oh","uh","ay","ey","iy","oy","uy"
    }
    letters.cons.lookup={
        "b","p","g","k","c","z","s","d","t","m","n","ng",
        "v","f","w","h","j","l","r","q","x","y"
    }

    for k,v in pairs(letters) do
        v.common={}
        v.rare={}
        for i=1,5 do
            if one_in(5) then v.common[i]=v.lookup[trandom(v.COMMON_NUM)+1] else v.common[i]=v.lookup[trandom(v.NUM)+1] end
        end
        for i=1,15 do 
            v.rare[i]=v.lookup[trandom(v.NUM)+1]
        end
    end

    local function letter(t)
        if one_in(5) then
            return pick_random(t.common)
        else
            return pick_random(t.rare)
        end
    end
    local gen_divine={}
    for k,v in ipairs(world.language.word) do
        local str=""
        if trandom(2)~=0 then
            str=str..letter(letters.cons)
            str=str..letter(letters.vowel)
        else
            str=str..letter(letters.vowel)
        end
        local num_letters=trandom(3)
        str=str..letter(letters.cons)
        if num_letters>0 then str=str..letter(letters.vowel) end
        if num_letters>1 then str=str..letter(letters.cons) end
        gen_divine[v.token]=str
    end

    return gen_divine
end

languages.GEN_IDENTITY=function()
    -- just to demonstrate the absolute most basic method of generating one of these
    -- also so that you can just mod stuff to use GEN_IDENTITY
    local tbl={}
    local unempty = function(str1, str2) 
        return str1=='' and str2 or str1
    end
    for k,v in ipairs(world.language.word) do
        local str=''
        str=unempty(str,v.NOUN_SING)
        str=unempty(str,v.ADJ)
        str=unempty(str,v.VERB_FIRST_PRES)
        str=unempty(str,string.lower(v.token))
        tbl[v.token]=str
    end
    return tbl
end