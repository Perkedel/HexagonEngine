print("Start parsing...")

local file_solid_js = "solid.js"
local file_regular_js = "regular.js"
local file_brands_js = "brands.js"

local file_Cheatsheet_gd = "Cheatsheet.gd"

local lut_dict_solid = {}
local lut_dict_regular = {}
local lut_dict_brands = {}


local function lut_parse(file_in)
    local dict = {}
    local key = ""
    local value = ""
    local index = 1

    local f = assert(io.open(file_in,'r'))

    local dummy = f:read()
    while dummy do
        if string.match(dummy, "var icons = {") then
            break
        end
        dummy = f:read()
    end
    local line = f:read()
    while line do
        if string.match(line, "};") then
            f:close()
            return dict
        end
        key, value = string.match(line, '"(.+)":.+"(%x+)"')
        dict[index] = {key, value}
        line = f:read()
        index = index + 1
    end

    f:close()
    return dict
end

local function gen_cheatsheet(file_cheatsheet)
    local f = assert(io.open(file_cheatsheet, 'w+'))

    f:write("const cheatsheet_lut: Dictionary = {\n")

    -- fa-solid cheatsheet
    f:write('\t"solid": {\n')
    for i, item in ipairs(lut_dict_solid) do
        f:write('\t\t"'..item[1]..'": '..'"\\u'..item[2]..'",\n')
    end
    f:write('\t},\n')

    -- fa-regular cheatsheet
    f:write('\t"regular": {\n')
    for i, item in ipairs(lut_dict_regular) do
        f:write('\t\t"'..item[1]..'": '..'"\\u'..item[2]..'",\n')
    end
    f:write('\t},\n')

    -- fa-brands cheatsheet
    f:write('\t"brands": {\n')
    for i, item in ipairs(lut_dict_brands) do
        f:write('\t\t"'..item[1]..'": '..'"\\u'..item[2]..'",\n')
    end
    f:write('\t}\n')

    f:write("}\n")

    f:close();
end

local t1 = os.clock()

lut_dict_solid = lut_parse(file_solid_js)
lut_dict_regular = lut_parse(file_regular_js)
lut_dict_brands = lut_parse(file_brands_js)

gen_cheatsheet(file_Cheatsheet_gd)

local f = assert(io.open(file_Cheatsheet_gd, "r"))
local cheatsheet = f:read("*all")
print(cheatsheet)

local t2 = os.clock()

print("Finished.")
print("Time used: " .. (t2 - t1) * 1000 .. "ms")
