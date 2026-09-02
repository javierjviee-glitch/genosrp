--[[
VJ Grey Addon Optimizer v1.0
Corrects Lua syntax errors and optimizes code
--]]

local function fix_file(filepath)
    local file = io.open(filepath, "r")
    if not file then return false end
    
    local content = file:read("*a")
    file:close()
    
    -- Fix comment syntax: /* */ -> --[[ ]]
    content = string.gsub(content, "/\\*", "--[[")
    content = string.gsub(content, "\\*/", "]]")
    
    -- Fix C-style comments
    content = string.gsub(content, "//", "--")
    
    -- Fix operators: && -> and
    content = string.gsub(content, "&&", " and ")
    
    -- Fix operators: || -> or  
    content = string.gsub(content, "||", " or ")
    
    -- Fix operators: != -> ~=
    content = string.gsub(content, "!=", "~=")
    
    -- Fix operators: ! -> not
    content = string.gsub(content, "!([%a_])", "not %1")
    
    file = io.open(filepath, "w")
    if file then
        file:write(content)
        file:close()
        return true
    end
    return false
end

-- Get all Lua files
local function get_lua_files(dir)
    local files = {}
    local function scan_dir(path)
        local handle = io.popen('dir "' .. path .. '" /b /s')
        for line in handle:lines() do
            if line:match("%.lua$") then
                table.insert(files, line)
            end
        end
        handle:close()
    end
    scan_dir(dir)
    return files
end

print("Starting VJ Grey Addon Optimization...")
local addon_dir = "lua"
local files = get_lua_files(addon_dir)
local fixed = 0

for _, filepath in ipairs(files) do
    if fix_file(filepath) then
        fixed = fixed + 1
        print("Fixed: " .. filepath)
    end
end

print("\nOptimization complete! Fixed " .. fixed .. " files.")

