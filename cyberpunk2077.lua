--cyberpunk 2077 ui
--working on aimware 2023/5/2
--created by qi https://aimwhere.net/user/366789
--updated by nn https://aimwhere.net/user/151010
local math_sin = math.sin
local math_cos = math.cos
local math_rad = math.rad
local math_abs = math.abs
local math_modf = math.modf
local math_floor = math.floor
local math_pi = 3.1415926535898

local tostring = tostring
local string_len = string.len
local string_sub = string.sub
local string_gsub = string.gsub
local string_match = string.match
local string_format = string.format

local ipairs = ipairs
local table_insert = table.insert
local setmetatable = setmetatable
local tonumber = tonumber
local type = type

draw_Line = draw.Line
draw_OutlinedRect = draw.OutlinedRect
draw_RoundedRectFill = draw.RoundedRectFill
draw_ShadowRect = draw.ShadowRect
draw_GetScreenSize = draw.GetScreenSize
draw_SetFont = draw.SetFont
draw_GetTextSize = draw.GetTextSize
draw_FilledCircle = draw.FilledCircle
draw_OutlinedCircle = draw.OutlinedCircle
draw_SetScissorRect = draw.SetScissorRect
draw_FilledRect = draw.FilledRect
draw_SetTexture = draw.SetTexture
draw_UpdateTexture = draw.UpdateTexture
draw_TextShadow = draw.TextShadow
draw_CreateTexture = draw.CreateTexture
draw_Triangle = draw.Triangle
draw_AddFontResource = draw.AddFontResource
draw_Color = draw.Color
draw_RoundedRect = draw.RoundedRect
draw_CreateFont = draw.CreateFont
draw_Text = draw.Text

common_DecodePNG = common.DecodePNG
common_DecodeJPEG = common.DecodeJPEG
common_RasterizeSVG = common.RasterizeSVG
--region local variable
local globals_FrameCount = globals.FrameCount
local math_max = math.max
local math_min = math.min
local table_insert = table.insert
local math_modf = math.modf
--region end

--region mouse drag
local menu = gui.Reference("menu")
local function dragging(parent, varname, base_x, base_y)
    return (function()
        local a = {}
        local b, c, d, e, f, g, h, i, j, k, l, m, n, o
        local p = {
            __index = {
                drag = function(self, ...)
                    local q, r = self:get()
                    local s, t = a.drag(q, r, ...)
                    if q ~= s or r ~= t then
                        self:set(s, t)
                    end
                    return s, t
                end,
                set = function(self, q, r)
                    local j, k = draw.GetScreenSize()
                    self.parent_x:SetValue(q / j * self.res)
                    self.parent_y:SetValue(r / k * self.res)
                end,
                get = function(self)
                    local j, k = draw.GetScreenSize()
                    return self.parent_x:GetValue() / self.res * j, self.parent_y:GetValue() / self.res * k
                end
            }
        }
        function a.new(r, u, v, w, x)
            x = x or 10000
            local j, k = draw.GetScreenSize()
            local y = gui.Slider(r, u .. "x", " position x", v / j * x, 0, x)
            local z = gui.Slider(r, u .. "y", " position y", w / k * x, 0, x)
            y:SetInvisible(true)
            z:SetInvisible(true)
            return setmetatable({parent = r, varname = u, parent_x = y, parent_y = z, res = x}, p)
        end
        function a.drag(q, r, A, B, C, D, E)
            if globals_FrameCount() ~= b then
                c = menu:IsActive()
                f, g = d, e
                d, e = input.GetMousePos()
                i = h
                h = input.IsButtonDown(0x01) == true
                m = l
                l = {}
                o = n
                n = false
                j, k = draw.GetScreenSize()
            end
            if c and i ~= nil then
                if (not i or o) and h and f > q and g > r and f < q + A and g < r + B then
                    n = true
                    q, r = q + d - f, r + e - g
                    if not D then
                        q = math_max(0, math_min(j - A, q))
                        r = math_max(0, math_min(k - B, r))
                    end
                end
            end
            table_insert(l, {q, r, A, B})
            return q, r, A, B
        end
        return a
    end)().new(parent, varname, base_x, base_y)
end

local screen_sizex, screen_sizey = draw.GetScreenSize()
local reference = gui.Reference("visuals", "other", "extra")
local ui_health_armor_dragging = dragging(reference, "cyberpunk_ui.health_armor.", screen_sizex * 0.25, screen_sizey * 0.2)
local ui_weapon_dragging = dragging(reference, "cyberpunk_ui.weapon.", screen_sizex * 0.25, screen_sizey * 0.25)
--region end

--region font
local draw_CreateFont = draw.CreateFont
local font = {
    draw_CreateFont("bahnschrift", 25, 800),
    draw_CreateFont("bahnschrift", 19, 800),
    draw_CreateFont("bahnschrift", 17, 800),
    draw_CreateFont("bahnschrift", 33, 800),
    draw_CreateFont("bahnschrift", 29, 800),
    draw_CreateFont("bahnschrift", 16, 800)
}
--regionend

--region event kill count
local kills = {}
local exp_alpha = 0

local function kill_count(event)
    local local_player = client.GetLocalPlayerIndex()
    local attacker_index = client.GetPlayerIndexByUserID(event:GetInt("attacker"))
    local event_name = event:GetName()

    if (event_name == "client_disconnect") or (event_name == "begin_new_match") then
        kills = {}
    end
    if event_name == "player_death" then
        if attacker_index == local_player then
            kills[#kills + 1] = {}
            exp_alpha = 255
        end
    end
end
--regionend
function rcolor(...)
    local arg = {...}
    local color_list = {}

    if type(arg[1]) == "number" then
        for i, v in ipairs(arg) do
            table_insert(color_list, v)
        end
    elseif type(arg[1]) == "string" then
        local hex = string_gsub(..., "#", "")
        local index = 1
        while index < string_len(hex) do
            local hex_sub = string_sub(hex, index, index + 1)
            table_insert(color_list, tonumber(hex_sub, 16) or error("parameter of error", 2))
            index = index + 2
        end
    end

    local r = color_list[1] or 255
    local g = color_list[2] or 255
    local b = color_list[3] or 255
    local a = color_list[4] or 255

    draw_Color(r, g, b, a)
    return r, g, b, a
end

local function bad_argument(expression, name, expected)
    assert(type(expression) == expected, " bad argument #1 to '%s' (%s expected, got %s)", 4, name, expected, tostring(type(expression)))
end
function rrectangle(x, y, w, h, r, g, b, a, flags, radius)
    bad_argument(x and y and w and h, "rectangle", "number")
    bad_argument(flags, "rectangle", "string")

    rcolor(r, g, b, a)

    local w = (w < 0) and (x - math_abs(w)) or x + w
    local h = (h < 0) and (y - math_abs(h)) or y + h

    if flags:find("f") then
        draw_FilledRect(x, y, w, h)
    elseif flags:find("o") then
        draw_OutlinedRect(x, y, w, h)
    elseif flags:find("s") then
        draw_ShadowRect(x, y, w, h, radius or 0)
    end

    rcolor()
end
local renderer_rectangle = rrectangle
--region health armor
function rline(xa, ya, xb, yb, r, g, b, a)
    bad_argument(xa and ya and xb and yb, "line", "number")
    rcolor(r, g, b, a)
    draw_Line(xa, ya, xb, yb)
    rcolor()
end
local function health_armor()
    local lp = entities.GetLocalPlayer()

    if not lp then
        return
    end

    local x, y = ui_health_armor_dragging:get()
    local x, y = math_modf(x), math_modf(y)
    ui_health_armor_dragging:drag(223, 35)

    local health = math_min(100, lp:GetHealth())
    local armor = math_min(100, lp:GetProp("m_ArmorValue"))

    local fade = ((1.0 / 0.15) * globals.FrameTime()) * 250

    if exp_alpha > 1 then
        exp_alpha = exp_alpha - 1
    end

    renderer_rectangle(x + 40, y + 12, 223, 10, 155, 51, 47, 102, "f")
    renderer_rectangle(x + 40, y + 12, (health * 2.23), 10, 234, 89, 82, 102, "f")

    renderer_rectangle(x + 40, y + 6, 223, 3, 47, 81, 79, 102, "f")
    renderer_rectangle(x + 40, y + 6, (armor * 2.23), 3, 139, 200, 191, 102, "f")

    draw.SetFont(font[1])
    draw.Color(222, 79, 70, 102)
    draw.Text(x + 280, y + 13, health)

    draw.SetFont(font[2])
    draw.Color(139, 200, 191, 102)
    draw.Text(x + 320, y + 9, armor)

    renderer_rectangle(x + 4, y + 6, 2, 20, 59, 153, 163, 102, "f")
    renderer_rectangle(x + 32, y + 6, 2, 27, 59, 153, 163, 102, "f")
    renderer_rectangle(x + 6, y + 6, 26, 2, 59, 153, 163, 102, "f")
    renderer_rectangle(x + 16, y + 33, 18, 3, 59, 153, 163, 102, "f")
    rline(x + 4, y + 25, x + 16, y + 34, 59, 153, 163, 102)
    rline(x + 5, y + 26, x + 16, y + 35, 59, 153, 163, 102)

    renderer_rectangle(x + 34, y + 6, (health * 2.23), 10, 234, 89, 82, 255, "f")

    renderer_rectangle(x + 34, y, 223, 3, 47, 81, 79, 255, "f")
    renderer_rectangle(x + 34, y, (armor * 2.23), 3, 139, 200, 191, 255, "f")

    draw.SetFont(font[1])
    draw.Color(222, 79, 70, 255)
    draw.Text(x + 274, y + 7, health)

    draw.SetFont(font[2])
    draw.Color(139, 200, 191, 255)
    draw.Text(x + 314, y + 3, armor)

    renderer_rectangle(x, y, 2, 21, 59, 153, 163, 255, "f")
    renderer_rectangle(x + 26, y, 2, 27, 59, 153, 163, 255, "f")
    renderer_rectangle(x, y, 27, 2, 59, 153, 163, 255, "f")
    renderer_rectangle(x + 10, y + 27, 18, 2, 59, 153, 163, 255, "f")
    rline(x, y + 20, x + 9, y + 28, 59, 153, 163, 255)
    rline(x + 1, y + 20, x + 10, y + 28, 559, 153, 163, 255)

    draw.SetFont(font[3])
    local w = draw.GetTextSize(#kills)
    draw.Color(139, 200, 191, 255)
    draw.Text(x + 14 - math_modf(w * 0.5), y + 5, #kills)

    draw.Color(139, 200, 191, exp_alpha)
    draw.Text(x + 34, y + 21, "You Kill Player! You get Exp!")
end
--regionend

--region weapon
local function weapon()
    local lp = entities.GetLocalPlayer()

    if not (lp and lp:IsAlive()) then
        return
    end

    local x, y = ui_weapon_dragging:get()
    local x, y = math_modf(x), math_modf(y)
    ui_weapon_dragging:drag(300, 60)

    local wid = lp:GetWeaponID()
    local m_hActiveWeap = lp:GetPropEntity("m_hActiveWeapon")
    local weapon_namex = string.match(m_hActiveWeap:GetName(), [[weapon_(.+)]])

    local ammo = m_hActiveWeap:GetProp("m_iClip1") or -1
    local ammo = ammo > 0 and ammo or 0
    local reserve = m_hActiveWeap:GetProp("m_iPrimaryReserveAmmoCount") or 0

    draw.SetFont(font[4])
    draw.Color(85, 226, 236, 102)
    draw.Text(x + 6, y + 4, 00 .. ammo)

    draw.SetFont(font[5])
    draw.Color(240, 91, 82, 102)
    draw.Text(x + 64, y + 4, 00 .. reserve)

    draw.SetFont(font[6])
    draw.Color(240, 91, 82, 102)
    draw.Text(x + 127, y, weapon_namex)

    draw.SetFont(font[4])
    draw.Color(85, 226, 236, 255)
    draw.Text(x, y + 10, 00 .. ammo)

    draw.SetFont(font[5])
    draw.Color(240, 91, 82, 255)
    draw.Text(x + 59, y + 10, 00 .. reserve)

    draw.SetFont(font[6])
    draw.Color(240, 91, 82, 255)
    draw.Text(x + 121, y + 4, weapon_namex)
end
--regionend

--region event
client.AllowListener("player_death")
client.AllowListener("client_disconnect")
client.AllowListener("begin_new_match")
--regionend

--region callbacks
callbacks.Register("FireGameEvent", kill_count)
callbacks.Register(
    "Draw",
    function()
        health_armor()
        weapon()
    end
)
--regionend
