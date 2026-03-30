-- KekWare V2 - Menu
-- Reads shared state from getgenv()._kw, creates WindUI

-- Restore any previously hooked metamethods (from prior executions)
pcall(function() restoremetamethod(game, "__index") end)
pcall(function() restoremetamethod(game, "__namecall") end)

-- Try to switch to serial (main thread) execution if on an actor
pcall(task.synchronize)

repeat task.wait(0.1) until getgenv()._kw_ready
local _kw = getgenv()._kw

local kekware        = _kw.kekware
local callbackList   = _kw.callbackList
local connectionList = _kw.connectionList
local folderName     = _kw.folderName
local soundFileList  = _kw.soundFileList
local unloadMain     = _kw.unloadMain
local getCallback    = _kw.getCallback
local getConfigNames = _kw.getConfigNames
local saveConfig     = _kw.saveConfig
local getConfig      = _kw.getConfig
local stopScanning   = _kw.stopScanning

local httpService = game:GetService("HttpService")
local windElements = {}

local function val(key)
    return kekware._values[key]
end

-- =============================================
-- Load WindUI (patched for actor thread compatibility)
-- game.Players etc. fail on actor threads, but game:GetService works
-- =============================================
local windSource = game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua")
windSource = string.gsub(windSource, "game%.Players", 'game:GetService("Players")')
windSource = string.gsub(windSource, "game%.Workspace", 'game:GetService("Workspace")')
windSource = string.gsub(windSource, "game%.CoreGui", 'game:GetService("CoreGui")')
windSource = string.gsub(windSource, "game%.StarterGui", 'game:GetService("StarterGui")')
windSource = string.gsub(windSource, "game%.UserInputService", 'game:GetService("UserInputService")')
windSource = string.gsub(windSource, "game%.RunService", 'game:GetService("RunService")')
windSource = string.gsub(windSource, "game%.TweenService", 'game:GetService("TweenService")')
windSource = string.gsub(windSource, "game%.TextService", 'game:GetService("TextService")')
windSource = string.gsub(windSource, "game%.ContentProvider", 'game:GetService("ContentProvider")')
windSource = string.gsub(windSource, "game%.Lighting", 'game:GetService("Lighting")')
local WindUI = loadstring(windSource)()

-- =============================================
-- Theme (Dark + Pink Accent #f9b4f6)
-- =============================================
local ACCENT = Color3.fromHex("#f9b4f6")
local KW_LOGO = "rbxassetid://75164163437824"

WindUI:AddTheme({
    Name             = "KekWare",
    Accent           = ACCENT,
    Primary          = ACCENT,
    Background       = Color3.fromRGB(18, 18, 22),
    Text             = Color3.fromRGB(240, 240, 245),
    Placeholder      = Color3.fromRGB(120, 120, 130),
    Outline          = Color3.fromRGB(40, 40, 48),
    Icon             = Color3.fromRGB(220, 220, 230),
    Button           = Color3.fromRGB(35, 35, 42),
    Hover            = Color3.fromRGB(45, 45, 55),
    WindowBackground = Color3.fromRGB(14, 14, 18),
    WindowShadow     = Color3.fromRGB(0, 0, 0),
    WindowTopbarTitle  = Color3.fromRGB(240, 240, 245),
    WindowTopbarAuthor = Color3.fromRGB(180, 160, 190),
    WindowTopbarIcon   = ACCENT,
    TabBackground                  = Color3.fromRGB(22, 22, 28),
    TabBackgroundHover             = Color3.fromRGB(35, 35, 42),
    TabBackgroundActive            = ACCENT,
    TabBackgroundActiveTransparency = 0.85,
    TabText                        = Color3.fromRGB(180, 180, 190),
    TabTitle                       = Color3.fromRGB(240, 240, 245),
    TabIcon                        = Color3.fromRGB(180, 180, 190),
    ElementBackground = Color3.fromRGB(25, 25, 30),
    ElementTitle      = Color3.fromRGB(230, 230, 240),
    ElementDesc       = Color3.fromRGB(140, 140, 150),
    ElementIcon       = ACCENT,
    PanelBackground              = Color3.fromRGB(20, 20, 25),
    PanelBackgroundTransparency  = 0,
    Toggle        = ACCENT,
    ToggleBar     = Color3.fromRGB(50, 50, 60),
    Slider        = ACCENT,
    SliderThumb   = Color3.fromRGB(255, 255, 255),
    SliderIcon    = ACCENT,
    Checkbox      = ACCENT,
    CheckboxIcon  = Color3.fromRGB(255, 255, 255),
    SectionIcon         = ACCENT,
    SectionExpandIcon   = Color3.fromRGB(180, 180, 190),
    SectionBox          = Color3.fromRGB(25, 25, 32),
    SectionBoxBorder    = Color3.fromRGB(40, 40, 48),
    Notification        = Color3.fromRGB(22, 22, 28),
    NotificationTitle   = Color3.fromRGB(240, 240, 245),
    NotificationContent = Color3.fromRGB(180, 180, 190),
    NotificationDuration = ACCENT,
    NotificationBorder  = Color3.fromRGB(40, 40, 48),
    Dialog               = Color3.fromRGB(22, 22, 28),
    DialogBackground     = Color3.fromRGB(0, 0, 0),
    DialogTitle          = Color3.fromRGB(240, 240, 245),
    DialogContent        = Color3.fromRGB(180, 180, 190),
    PopupBackground      = Color3.fromRGB(0, 0, 0),
    PopupTitle           = Color3.fromRGB(240, 240, 245),
    PopupContent         = Color3.fromRGB(180, 180, 190),
    White                   = Color3.fromRGB(255, 255, 255),
    Black                   = Color3.fromRGB(0, 0, 0),
    BackgroundTransparency  = 0,
})

-- =============================================
-- Window
-- =============================================
local Window = WindUI:CreateWindow({
    Title       = "KekWare",
    Icon        = KW_LOGO,
    IconSize    = 56,
    IconThemed  = false,
    Author      = "v1.0.0 ALPHA",
    Folder      = "KekWareUI",
    Size        = UDim2.new(0, 620, 0, 480),
    Theme       = "KekWare",
    Transparent = false,
    SideBarWidth = 180,
})
Window:SetToggleKey(Enum.KeyCode.RightShift)

-- =============================================
-- Tabs
-- =============================================
local legit       = Window:Tab({ Title = "Legit",    Icon = "crosshair",  IconColor = ACCENT })
local rage        = Window:Tab({ Title = "Rage",     Icon = "swords",     IconColor = ACCENT })
local visuals     = Window:Tab({ Title = "Visuals",  Icon = "eye",        IconColor = ACCENT })
local misc        = Window:Tab({ Title = "Misc",     Icon = "settings-2", IconColor = ACCENT })
Window:Divider()
local settingsTab = Window:Tab({ Title = "Settings", Icon = "wrench",     IconColor = ACCENT })

-- ============= LEGIT TAB =============
local aimbot = legit:Section({ Title = "Aim Bot", Opened = true })
windElements["Aim Bot%%Enabled"] = aimbot:Toggle({ Title = "Enabled", Value = val("Aim Bot%%Enabled"), Callback = getCallback("Aim Bot%%Enabled") })
aimbot:Keybind({ Title = "Key Bind", Value = "None" })
windElements["Aim Bot%%Visible Check"] = aimbot:Toggle({ Title = "Visible Check", Value = val("Aim Bot%%Visible Check"), Callback = getCallback("Aim Bot%%Visible Check") })
windElements["Aim Bot%%Smoothness"] = aimbot:Slider({ Title = "Smoothness", Value = { Min = 0, Max = 0.99, Default = val("Aim Bot%%Smoothness") or 0 }, Step = 0.01, Callback = getCallback("Aim Bot%%Smoothness") })
windElements["Aim Bot%%Target Part"] = aimbot:Dropdown({ Title = "Target Part", Values = {"Head", "Torso"}, Value = val("Aim Bot%%Target Part") or "Head", Callback = getCallback("Aim Bot%%Target Part") })
windElements["Aim Bot%%Use FOV"] = aimbot:Toggle({ Title = "Use FOV", Value = val("Aim Bot%%Use FOV"), Callback = getCallback("Aim Bot%%Use FOV") })
windElements["Aim Bot%%FOV Radius"] = aimbot:Slider({ Title = "FOV Radius", Value = { Min = 2, Max = 1000, Default = val("Aim Bot%%FOV Radius") or 300 }, Step = 1, Callback = getCallback("Aim Bot%%FOV Radius") })
windElements["Aim Bot%%Show FOV Circle"] = aimbot:Toggle({ Title = "Show FOV Circle", Value = val("Aim Bot%%Show FOV Circle"), Callback = getCallback("Aim Bot%%Show FOV Circle") })
aimbot:Keybind({ Title = "FOV Key Bind", Value = "None" })
windElements["Aim Bot%%FOV Circle Color"] = aimbot:Colorpicker({ Title = "FOV Circle Color", Default = val("Aim Bot%%FOV Circle Color") or Color3.new(1,1,1), Callback = getCallback("Aim Bot%%FOV Circle Color") })
windElements["Aim Bot%%Use Dead FOV"] = aimbot:Toggle({ Title = "Use Dead FOV", Value = val("Aim Bot%%Use Dead FOV"), Callback = getCallback("Aim Bot%%Use Dead FOV") })
windElements["Aim Bot%%Dead FOV Radius"] = aimbot:Slider({ Title = "Dead FOV Radius", Value = { Min = 1, Max = 1000, Default = val("Aim Bot%%Dead FOV Radius") or 100 }, Step = 1, Callback = getCallback("Aim Bot%%Dead FOV Radius") })
windElements["Aim Bot%%Show Dead FOV Circle"] = aimbot:Toggle({ Title = "Show Dead FOV Circle", Value = val("Aim Bot%%Show Dead FOV Circle"), Callback = getCallback("Aim Bot%%Show Dead FOV Circle") })
aimbot:Keybind({ Title = "Dead FOV Key Bind", Value = "None" })
windElements["Aim Bot%%Dead FOV Circle Color"] = aimbot:Colorpicker({ Title = "Dead FOV Circle Color", Default = val("Aim Bot%%Dead FOV Circle Color") or Color3.new(1,1,1), Callback = getCallback("Aim Bot%%Dead FOV Circle Color") })

local fovsettings = legit:Section({ Title = "FOV Settings", Opened = false })
windElements["FOV Settings%%FOV Follows Recoil"] = fovsettings:Toggle({ Title = "FOV Follows Recoil", Value = val("FOV Settings%%FOV Follows Recoil"), Callback = getCallback("FOV Settings%%FOV Follows Recoil") })
windElements["FOV Settings%%Dynamic FOV"] = fovsettings:Toggle({ Title = "Dynamic FOV", Value = val("FOV Settings%%Dynamic FOV"), Callback = getCallback("FOV Settings%%Dynamic FOV") })
windElements["FOV Settings%%Circle Opacity"] = fovsettings:Slider({ Title = "Circle Opacity", Value = { Min = 1, Max = 100, Default = val("FOV Settings%%Circle Opacity") or 100 }, Step = 1, Callback = getCallback("FOV Settings%%Circle Opacity") })
windElements["FOV Settings%%Fill Circles"] = fovsettings:Toggle({ Title = "Fill Circles", Value = val("FOV Settings%%Fill Circles"), Callback = getCallback("FOV Settings%%Fill Circles") })

local silentaim = legit:Section({ Title = "Silent Aim", Opened = false })
windElements["Silent Aim%%Enabled"] = silentaim:Toggle({ Title = "Enabled", Value = val("Silent Aim%%Enabled"), Callback = getCallback("Silent Aim%%Enabled") })
silentaim:Keybind({ Title = "Key Bind", Value = "None" })
windElements["Silent Aim%%Visible Check"] = silentaim:Toggle({ Title = "Visible Check", Value = val("Silent Aim%%Visible Check"), Callback = getCallback("Silent Aim%%Visible Check") })
windElements["Silent Aim%%Hit Chance"] = silentaim:Slider({ Title = "Hit Chance", Value = { Min = 1, Max = 100, Default = val("Silent Aim%%Hit Chance") or 100 }, Step = 1, Callback = getCallback("Silent Aim%%Hit Chance") })
windElements["Silent Aim%%Head Shot Chance"] = silentaim:Slider({ Title = "Head Shot Chance", Value = { Min = 0, Max = 100, Default = val("Silent Aim%%Head Shot Chance") or 100 }, Step = 1, Callback = getCallback("Silent Aim%%Head Shot Chance") })
windElements["Silent Aim%%Use FOV"] = silentaim:Toggle({ Title = "Use FOV", Value = val("Silent Aim%%Use FOV"), Callback = getCallback("Silent Aim%%Use FOV") })
windElements["Silent Aim%%FOV Radius"] = silentaim:Slider({ Title = "FOV Radius", Value = { Min = 2, Max = 1000, Default = val("Silent Aim%%FOV Radius") or 300 }, Step = 1, Callback = getCallback("Silent Aim%%FOV Radius") })
windElements["Silent Aim%%Show FOV Circle"] = silentaim:Toggle({ Title = "Show FOV Circle", Value = val("Silent Aim%%Show FOV Circle"), Callback = getCallback("Silent Aim%%Show FOV Circle") })
silentaim:Keybind({ Title = "FOV Key Bind", Value = "None" })
windElements["Silent Aim%%FOV Circle Color"] = silentaim:Colorpicker({ Title = "FOV Circle Color", Default = val("Silent Aim%%FOV Circle Color") or Color3.new(1,1,1), Callback = getCallback("Silent Aim%%FOV Circle Color") })
windElements["Silent Aim%%Use Dead FOV"] = silentaim:Toggle({ Title = "Use Dead FOV", Value = val("Silent Aim%%Use Dead FOV"), Callback = getCallback("Silent Aim%%Use Dead FOV") })
windElements["Silent Aim%%Dead FOV Radius"] = silentaim:Slider({ Title = "Dead FOV Radius", Value = { Min = 1, Max = 1000, Default = val("Silent Aim%%Dead FOV Radius") or 100 }, Step = 1, Callback = getCallback("Silent Aim%%Dead FOV Radius") })
windElements["Silent Aim%%Show Dead FOV Circle"] = silentaim:Toggle({ Title = "Show Dead FOV Circle", Value = val("Silent Aim%%Show Dead FOV Circle"), Callback = getCallback("Silent Aim%%Show Dead FOV Circle") })
silentaim:Keybind({ Title = "Dead FOV Key Bind", Value = "None" })
windElements["Silent Aim%%Dead FOV Circle Color"] = silentaim:Colorpicker({ Title = "Dead FOV Circle Color", Default = val("Silent Aim%%Dead FOV Circle Color") or Color3.new(1,1,1), Callback = getCallback("Silent Aim%%Dead FOV Circle Color") })

local backtrack = legit:Section({ Title = "Backtracking", Opened = false })
windElements["Backtracking%%Enabled"] = backtrack:Toggle({ Title = "Enabled", Value = val("Backtracking%%Enabled"), Callback = getCallback("Backtracking%%Enabled") })
backtrack:Keybind({ Title = "Key Bind", Value = "None" })
windElements["Backtracking%%Characters Color"] = backtrack:Colorpicker({ Title = "Characters Color", Default = val("Backtracking%%Characters Color") or Color3.new(0.1,0.1,1), Callback = getCallback("Backtracking%%Characters Color") })
windElements["Backtracking%%Refresh Rate"] = backtrack:Slider({ Title = "Refresh Rate", Value = { Min = 1, Max = 10, Default = val("Backtracking%%Refresh Rate") or 2 }, Step = 1, Callback = getCallback("Backtracking%%Refresh Rate") })
windElements["Backtracking%%Character Duration"] = backtrack:Slider({ Title = "Character Duration", Value = { Min = 0.1, Max = 1, Default = val("Backtracking%%Character Duration") or 1 }, Step = 0.1, Callback = getCallback("Backtracking%%Character Duration") })
windElements["Backtracking%%Character Transparency"] = backtrack:Slider({ Title = "Character Transparency", Value = { Min = 0, Max = 100, Default = val("Backtracking%%Character Transparency") or 50 }, Step = 1, Callback = getCallback("Backtracking%%Character Transparency") })
windElements["Backtracking%%Character Material"] = backtrack:Dropdown({ Title = "Character Material", Values = {"ForceField", "SmoothPlastic", "Glass"}, Value = val("Backtracking%%Character Material") or "ForceField", Callback = getCallback("Backtracking%%Character Material") })
windElements["Backtracking%%Clone Character"] = backtrack:Toggle({ Title = "Clone Character", Value = val("Backtracking%%Clone Character"), Callback = getCallback("Backtracking%%Clone Character") })

local hitboxes = legit:Section({ Title = "Hit Boxes", Opened = false })
windElements["Hit Boxes%%Enabled"] = hitboxes:Toggle({ Title = "Enabled", Value = val("Hit Boxes%%Enabled"), Callback = getCallback("Hit Boxes%%Enabled") })
hitboxes:Keybind({ Title = "Key Bind", Value = "None" })
windElements["Hit Boxes%%Color"] = hitboxes:Colorpicker({ Title = "Color", Default = val("Hit Boxes%%Color") or Color3.new(0.1,0.1,1), Callback = getCallback("Hit Boxes%%Color") })
windElements["Hit Boxes%%Hit Part"] = hitboxes:Dropdown({ Title = "Hit Part", Values = {"Head", "Torso"}, Value = val("Hit Boxes%%Hit Part") or "Head", Callback = getCallback("Hit Boxes%%Hit Part") })
windElements["Hit Boxes%%Size"] = hitboxes:Slider({ Title = "Size", Value = { Min = 1, Max = 20, Default = val("Hit Boxes%%Size") or 20 }, Step = 1, Callback = getCallback("Hit Boxes%%Size") })
windElements["Hit Boxes%%Transparency"] = hitboxes:Slider({ Title = "Transparency", Value = { Min = 0, Max = 100, Default = val("Hit Boxes%%Transparency") or 50 }, Step = 1, Callback = getCallback("Hit Boxes%%Transparency") })
windElements["Hit Boxes%%Material"] = hitboxes:Dropdown({ Title = "Material", Values = {"ForceField", "SmoothPlastic", "Glass"}, Value = val("Hit Boxes%%Material") or "SmoothPlastic", Callback = getCallback("Hit Boxes%%Material") })

local gunmods = legit:Section({ Title = "Gun Mods", Opened = false })
windElements["Gun Mods%%No Recoil"] = gunmods:Toggle({ Title = "No Recoil", Value = val("Gun Mods%%No Recoil"), Callback = getCallback("Gun Mods%%No Recoil") })
windElements["Gun Mods%%No Spread"] = gunmods:Toggle({ Title = "No Spread", Value = val("Gun Mods%%No Spread"), Callback = getCallback("Gun Mods%%No Spread") })
windElements["Gun Mods%%Small Crosshair"] = gunmods:Toggle({ Title = "Small Crosshair", Value = val("Gun Mods%%Small Crosshair"), Callback = getCallback("Gun Mods%%Small Crosshair") })
windElements["Gun Mods%%No Crosshair"] = gunmods:Toggle({ Title = "No Crosshair", Value = val("Gun Mods%%No Crosshair"), Callback = getCallback("Gun Mods%%No Crosshair") })
windElements["Gun Mods%%No Sniper Scope"] = gunmods:Toggle({ Title = "No Sniper Scope", Value = val("Gun Mods%%No Sniper Scope"), Callback = getCallback("Gun Mods%%No Sniper Scope") })
windElements["Gun Mods%%No Camera Sway"] = gunmods:Toggle({ Title = "No Camera Sway", Value = val("Gun Mods%%No Camera Sway"), Callback = getCallback("Gun Mods%%No Camera Sway") })
windElements["Gun Mods%%No Camera Bob"] = gunmods:Toggle({ Title = "No Camera Bob", Value = val("Gun Mods%%No Camera Bob"), Callback = getCallback("Gun Mods%%No Camera Bob") })
windElements["Gun Mods%%No Walk Sway"] = gunmods:Toggle({ Title = "No Walk Sway", Value = val("Gun Mods%%No Walk Sway"), Callback = getCallback("Gun Mods%%No Walk Sway") })
windElements["Gun Mods%%No Gun Sway"] = gunmods:Toggle({ Title = "No Gun Sway", Value = val("Gun Mods%%No Gun Sway"), Callback = getCallback("Gun Mods%%No Gun Sway") })
windElements["Gun Mods%%Instant Reload"] = gunmods:Toggle({ Title = "Instant Reload", Value = val("Gun Mods%%Instant Reload"), Callback = getCallback("Gun Mods%%Instant Reload") })

-- ============= RAGE TAB =============
local ragebot = rage:Section({ Title = "Rage Bot", Opened = true })
windElements["Rage Bot%%Enabled"] = ragebot:Toggle({ Title = "Enabled", Value = val("Rage Bot%%Enabled"), Callback = getCallback("Rage Bot%%Enabled") })
ragebot:Keybind({ Title = "Key Bind", Value = "None" })
windElements["Rage Bot%%Shoot Effects"] = ragebot:Toggle({ Title = "Shoot Effects", Value = val("Rage Bot%%Shoot Effects"), Callback = getCallback("Rage Bot%%Shoot Effects") })
windElements["Rage Bot%%Fire Position Scanning"] = ragebot:Toggle({ Title = "Fire Position Scanning", Value = val("Rage Bot%%Fire Position Scanning"), Callback = getCallback("Rage Bot%%Fire Position Scanning") })
windElements["Rage Bot%%Fire Position Offset"] = ragebot:Slider({ Title = "Fire Position Offset", Value = { Min = 1, Max = 15.9, Default = val("Rage Bot%%Fire Position Offset") or 9 }, Step = 0.1, Callback = getCallback("Rage Bot%%Fire Position Offset") })
windElements["Rage Bot%%Hit Position Scanning"] = ragebot:Toggle({ Title = "Hit Position Scanning", Value = val("Rage Bot%%Hit Position Scanning"), Callback = getCallback("Rage Bot%%Hit Position Scanning") })
windElements["Rage Bot%%Hit Position Offset"] = ragebot:Slider({ Title = "Hit Position Offset", Value = { Min = 1, Max = 10, Default = val("Rage Bot%%Hit Position Offset") or 6 }, Step = 0.1, Callback = getCallback("Rage Bot%%Hit Position Offset") })
windElements["Rage Bot%%Only Shoot Target Status"] = ragebot:Toggle({ Title = "Only Shoot Target Status", Value = val("Rage Bot%%Only Shoot Target Status"), Callback = getCallback("Rage Bot%%Only Shoot Target Status") })
ragebot:Keybind({ Title = "Target Key Bind", Value = "None" })
windElements["Rage Bot%%Whitelist Friendly Status"] = ragebot:Toggle({ Title = "Whitelist Friendly Status", Value = val("Rage Bot%%Whitelist Friendly Status"), Callback = getCallback("Rage Bot%%Whitelist Friendly Status") })
ragebot:Keybind({ Title = "Friendly Key Bind", Value = "None" })

local knifebot = rage:Section({ Title = "Knife Bot", Opened = false })
windElements["Knife Bot%%Kill All (May Despawn)"] = knifebot:Toggle({ Title = "Kill All (May Despawn)", Value = val("Knife Bot%%Kill All (May Despawn)"), Callback = getCallback("Knife Bot%%Kill All (May Despawn)") })
knifebot:Keybind({ Title = "Key Bind", Value = "None" })
windElements["Knife Bot%%Only When Holding Knife"] = knifebot:Toggle({ Title = "Only When Holding Knife", Value = val("Knife Bot%%Only When Holding Knife"), Callback = getCallback("Knife Bot%%Only When Holding Knife") })
windElements["Knife Bot%%Only Kill Target Status"] = knifebot:Toggle({ Title = "Only Kill Target Status", Value = val("Knife Bot%%Only Kill Target Status"), Callback = getCallback("Knife Bot%%Only Kill Target Status") })
knifebot:Keybind({ Title = "Target Key Bind", Value = "None" })
windElements["Knife Bot%%Whitelist Friendly Status"] = knifebot:Toggle({ Title = "Whitelist Friendly Status", Value = val("Knife Bot%%Whitelist Friendly Status"), Callback = getCallback("Knife Bot%%Whitelist Friendly Status") })
knifebot:Keybind({ Title = "Friendly Key Bind", Value = "None" })

local antiaim = rage:Section({ Title = "Anti Aim", Opened = false })
windElements["Anti Aim%%Enabled (May Cause Despawning)"] = antiaim:Toggle({ Title = "Enabled (May Cause Despawning)", Value = val("Anti Aim%%Enabled (May Cause Despawning)"), Callback = getCallback("Anti Aim%%Enabled (May Cause Despawning)") })
windElements["Anti Aim%%Yaw"] = antiaim:Toggle({ Title = "Yaw", Value = val("Anti Aim%%Yaw"), Callback = getCallback("Anti Aim%%Yaw") })
windElements["Anti Aim%%Yaw Amount"] = antiaim:Slider({ Title = "Yaw Amount", Value = { Min = 0, Max = 360, Default = val("Anti Aim%%Yaw Amount") or 180 }, Step = 1, Callback = getCallback("Anti Aim%%Yaw Amount") })
windElements["Anti Aim%%Yaw Mode"] = antiaim:Dropdown({ Title = "Yaw Mode", Values = {"Relative", "Absolute"}, Value = val("Anti Aim%%Yaw Mode") or "Relative", Callback = getCallback("Anti Aim%%Yaw Mode") })
windElements["Anti Aim%%Pitch"] = antiaim:Toggle({ Title = "Pitch", Value = val("Anti Aim%%Pitch"), Callback = getCallback("Anti Aim%%Pitch") })
windElements["Anti Aim%%Pitch Amount"] = antiaim:Slider({ Title = "Pitch Amount", Value = { Min = 0, Max = 180, Default = val("Anti Aim%%Pitch Amount") or 0 }, Step = 1, Callback = getCallback("Anti Aim%%Pitch Amount") })
windElements["Anti Aim%%Pitch Mode"] = antiaim:Dropdown({ Title = "Pitch Mode", Values = {"Relative", "Absolute"}, Value = val("Anti Aim%%Pitch Mode") or "Relative", Callback = getCallback("Anti Aim%%Pitch Mode") })
windElements["Anti Aim%%Spin Bot"] = antiaim:Toggle({ Title = "Spin Bot", Value = val("Anti Aim%%Spin Bot"), Callback = getCallback("Anti Aim%%Spin Bot") })
windElements["Anti Aim%%Spin Speed"] = antiaim:Slider({ Title = "Spin Speed", Value = { Min = 0, Max = 1800, Default = val("Anti Aim%%Spin Speed") or 180 }, Step = 1, Callback = getCallback("Anti Aim%%Spin Speed") })
windElements["Anti Aim%%Spin Direction"] = antiaim:Dropdown({ Title = "Spin Direction", Values = {"Left", "Right"}, Value = val("Anti Aim%%Spin Direction") or "Right", Callback = getCallback("Anti Aim%%Spin Direction") })
windElements["Anti Aim%%Jitter"] = antiaim:Toggle({ Title = "Jitter", Value = val("Anti Aim%%Jitter"), Callback = getCallback("Anti Aim%%Jitter") })
windElements["Anti Aim%%Jitter Speed"] = antiaim:Slider({ Title = "Jitter Speed", Value = { Min = 0, Max = 12, Default = val("Anti Aim%%Jitter Speed") or 6 }, Step = 1, Callback = getCallback("Anti Aim%%Jitter Speed") })
windElements["Anti Aim%%Force Stance"] = antiaim:Toggle({ Title = "Force Stance", Value = val("Anti Aim%%Force Stance"), Callback = getCallback("Anti Aim%%Force Stance") })
windElements["Anti Aim%%Set Stance"] = antiaim:Dropdown({ Title = "Set Stance", Values = {"Stand", "Crouch", "Prone"}, Value = val("Anti Aim%%Set Stance") or "Prone", Callback = getCallback("Anti Aim%%Set Stance") })

local fakelag = rage:Section({ Title = "Fake Lag", Opened = false })
windElements["Fake Lag%%Enabled"] = fakelag:Toggle({ Title = "Fake Lag", Value = val("Fake Lag%%Enabled"), Callback = getCallback("Fake Lag%%Enabled") })
fakelag:Keybind({ Title = "Key Bind", Value = "None" })
windElements["Fake Lag%%Randomize Position"] = fakelag:Toggle({ Title = "Randomize Position", Value = val("Fake Lag%%Randomize Position"), Callback = getCallback("Fake Lag%%Randomize Position") })
windElements["Fake Lag%%X-Axis Factor"] = fakelag:Slider({ Title = "X-Axis Factor", Value = { Min = 0, Max = 8.9, Default = val("Fake Lag%%X-Axis Factor") or 0 }, Step = 1, Callback = getCallback("Fake Lag%%X-Axis Factor") })
windElements["Fake Lag%%Z-Axis Factor"] = fakelag:Slider({ Title = "Z-Axis Factor", Value = { Min = 0, Max = 8.9, Default = val("Fake Lag%%Z-Axis Factor") or 0 }, Step = 1, Callback = getCallback("Fake Lag%%Z-Axis Factor") })
windElements["Fake Lag%%Refresh Distance"] = fakelag:Slider({ Title = "Refresh Distance", Value = { Min = 0, Max = 8.9, Default = val("Fake Lag%%Refresh Distance") or 5 }, Step = 0.1, Callback = getCallback("Fake Lag%%Refresh Distance") })
windElements["Fake Lag%%Refresh Rate"] = fakelag:Slider({ Title = "Refresh Rate", Value = { Min = 0, Max = 10, Default = val("Fake Lag%%Refresh Rate") or 1 }, Step = 1, Callback = getCallback("Fake Lag%%Refresh Rate") })

-- ============= VISUALS TAB =============
local enemyesp = visuals:Section({ Title = "Enemy ESP", Opened = true })
windElements["Enemy ESP%%Enabled"] = enemyesp:Toggle({ Title = "Enabled", Value = val("Enemy ESP%%Enabled"), Callback = getCallback("Enemy ESP%%Enabled") })
windElements["Enemy ESP%%Boxes"] = enemyesp:Toggle({ Title = "Boxes", Value = val("Enemy ESP%%Boxes"), Callback = getCallback("Enemy ESP%%Boxes") })
windElements["Enemy ESP%%Box Color"] = enemyesp:Colorpicker({ Title = "Box Color", Default = val("Enemy ESP%%Box Color") or Color3.fromRGB(0,255,255), Callback = getCallback("Enemy ESP%%Box Color") })
windElements["Enemy ESP%%Box Opacity"] = enemyesp:Slider({ Title = "Box Opacity", Value = { Min = 1, Max = 100, Default = val("Enemy ESP%%Box Opacity") or 100 }, Step = 1, Callback = getCallback("Enemy ESP%%Box Opacity") })
windElements["Enemy ESP%%Box Outlines"] = enemyesp:Toggle({ Title = "Box Outlines", Value = val("Enemy ESP%%Box Outlines"), Callback = getCallback("Enemy ESP%%Box Outlines") })
windElements["Enemy ESP%%Box Outline Color"] = enemyesp:Colorpicker({ Title = "Box Outline Color", Default = val("Enemy ESP%%Box Outline Color") or Color3.fromRGB(0,0,0), Callback = getCallback("Enemy ESP%%Box Outline Color") })
windElements["Enemy ESP%%Box Outline Opacity"] = enemyesp:Slider({ Title = "Box Outline Opacity", Value = { Min = 1, Max = 100, Default = val("Enemy ESP%%Box Outline Opacity") or 100 }, Step = 1, Callback = getCallback("Enemy ESP%%Box Outline Opacity") })
windElements["Enemy ESP%%Fill Boxes"] = enemyesp:Toggle({ Title = "Fill Boxes", Value = val("Enemy ESP%%Fill Boxes"), Callback = getCallback("Enemy ESP%%Fill Boxes") })
windElements["Enemy ESP%%Box Inside Color"] = enemyesp:Colorpicker({ Title = "Box Inside Color", Default = val("Enemy ESP%%Box Inside Color") or Color3.fromRGB(0,255,255), Callback = getCallback("Enemy ESP%%Box Inside Color") })
windElements["Enemy ESP%%Box Inside Opacity"] = enemyesp:Slider({ Title = "Box Inside Opacity", Value = { Min = 1, Max = 100, Default = val("Enemy ESP%%Box Inside Opacity") or 100 }, Step = 1, Callback = getCallback("Enemy ESP%%Box Inside Opacity") })
windElements["Enemy ESP%%Health Bar"] = enemyesp:Toggle({ Title = "Health Bar", Value = val("Enemy ESP%%Health Bar"), Callback = getCallback("Enemy ESP%%Health Bar") })
windElements["Enemy ESP%%Damage Color"] = enemyesp:Colorpicker({ Title = "Damage Color", Default = val("Enemy ESP%%Damage Color") or Color3.fromRGB(255,0,0), Callback = getCallback("Enemy ESP%%Damage Color") })
windElements["Enemy ESP%%Health Color"] = enemyesp:Colorpicker({ Title = "Health Color", Default = val("Enemy ESP%%Health Color") or Color3.fromRGB(0,255,0), Callback = getCallback("Enemy ESP%%Health Color") })
windElements["Enemy ESP%%Health Bar Outline"] = enemyesp:Toggle({ Title = "Health Bar Outline", Value = val("Enemy ESP%%Health Bar Outline"), Callback = getCallback("Enemy ESP%%Health Bar Outline") })
windElements["Enemy ESP%%Health Outline Color"] = enemyesp:Colorpicker({ Title = "Health Outline Color", Default = val("Enemy ESP%%Health Outline Color") or Color3.fromRGB(0,0,0), Callback = getCallback("Enemy ESP%%Health Outline Color") })
windElements["Enemy ESP%%Tracers"] = enemyesp:Toggle({ Title = "Tracers", Value = val("Enemy ESP%%Tracers"), Callback = getCallback("Enemy ESP%%Tracers") })
windElements["Enemy ESP%%Tracer Color"] = enemyesp:Colorpicker({ Title = "Tracer Color", Default = val("Enemy ESP%%Tracer Color") or Color3.fromRGB(0,255,255), Callback = getCallback("Enemy ESP%%Tracer Color") })
windElements["Enemy ESP%%Tracer Opacity"] = enemyesp:Slider({ Title = "Tracer Opacity", Value = { Min = 1, Max = 100, Default = val("Enemy ESP%%Tracer Opacity") or 100 }, Step = 1, Callback = getCallback("Enemy ESP%%Tracer Opacity") })
windElements["Enemy ESP%%Tracer Outlines"] = enemyesp:Toggle({ Title = "Tracer Outlines", Value = val("Enemy ESP%%Tracer Outlines"), Callback = getCallback("Enemy ESP%%Tracer Outlines") })
windElements["Enemy ESP%%Tracer Outline Color"] = enemyesp:Colorpicker({ Title = "Tracer Outline Color", Default = val("Enemy ESP%%Tracer Outline Color") or Color3.fromRGB(0,0,0), Callback = getCallback("Enemy ESP%%Tracer Outline Color") })
windElements["Enemy ESP%%Tracer Outlines Opacity"] = enemyesp:Slider({ Title = "Tracer Outlines Opacity", Value = { Min = 1, Max = 100, Default = val("Enemy ESP%%Tracer Outlines Opacity") or 100 }, Step = 1, Callback = getCallback("Enemy ESP%%Tracer Outlines Opacity") })
windElements["Enemy ESP%%Tracer Origin"] = enemyesp:Dropdown({ Title = "Tracer Origin", Values = {"Middle", "Top", "Bottom"}, Value = val("Enemy ESP%%Tracer Origin") or "Bottom", Callback = getCallback("Enemy ESP%%Tracer Origin") })
windElements["Enemy ESP%%Names"] = enemyesp:Toggle({ Title = "Names", Value = val("Enemy ESP%%Names"), Callback = getCallback("Enemy ESP%%Names") })
windElements["Enemy ESP%%Names Color"] = enemyesp:Colorpicker({ Title = "Names Color", Default = val("Enemy ESP%%Names Color") or Color3.fromRGB(255,255,255), Callback = getCallback("Enemy ESP%%Names Color") })
windElements["Enemy ESP%%Weapons"] = enemyesp:Toggle({ Title = "Weapons", Value = val("Enemy ESP%%Weapons"), Callback = getCallback("Enemy ESP%%Weapons") })
windElements["Enemy ESP%%Weapons Color"] = enemyesp:Colorpicker({ Title = "Weapons Color", Default = val("Enemy ESP%%Weapons Color") or Color3.fromRGB(255,255,255), Callback = getCallback("Enemy ESP%%Weapons Color") })
windElements["Enemy ESP%%Distances"] = enemyesp:Toggle({ Title = "Distances", Value = val("Enemy ESP%%Distances"), Callback = getCallback("Enemy ESP%%Distances") })
windElements["Enemy ESP%%Distances Color"] = enemyesp:Colorpicker({ Title = "Distances Color", Default = val("Enemy ESP%%Distances Color") or Color3.fromRGB(255,255,255), Callback = getCallback("Enemy ESP%%Distances Color") })
windElements["Enemy ESP%%Health Percents"] = enemyesp:Toggle({ Title = "Health Percents", Value = val("Enemy ESP%%Health Percents"), Callback = getCallback("Enemy ESP%%Health Percents") })
windElements["Enemy ESP%%Health Number Color"] = enemyesp:Colorpicker({ Title = "Health Number Color", Default = val("Enemy ESP%%Health Number Color") or Color3.fromRGB(255,255,255), Callback = getCallback("Enemy ESP%%Health Number Color") })
windElements["Enemy ESP%%Text Outlines"] = enemyesp:Toggle({ Title = "Text Outlines", Value = val("Enemy ESP%%Text Outlines"), Callback = getCallback("Enemy ESP%%Text Outlines") })
windElements["Enemy ESP%%Text Outline Color"] = enemyesp:Colorpicker({ Title = "Text Outline Color", Default = val("Enemy ESP%%Text Outline Color") or Color3.fromRGB(0,0,0), Callback = getCallback("Enemy ESP%%Text Outline Color") })
windElements["Enemy ESP%%Highlight Chams"] = enemyesp:Toggle({ Title = "Highlight Chams", Value = val("Enemy ESP%%Highlight Chams"), Callback = getCallback("Enemy ESP%%Highlight Chams") })
windElements["Enemy ESP%%Highlight Outline Color"] = enemyesp:Colorpicker({ Title = "Highlight Outline Color", Default = val("Enemy ESP%%Highlight Outline Color") or Color3.fromRGB(0,0,0), Callback = getCallback("Enemy ESP%%Highlight Outline Color") })
windElements["Enemy ESP%%Highlight Fill Color"] = enemyesp:Colorpicker({ Title = "Highlight Fill Color", Default = val("Enemy ESP%%Highlight Fill Color") or Color3.fromRGB(0,0,255), Callback = getCallback("Enemy ESP%%Highlight Fill Color") })
windElements["Enemy ESP%%Highlight Fill Opacity"] = enemyesp:Slider({ Title = "Highlight Fill Transparency", Value = { Min = 0, Max = 100, Default = val("Enemy ESP%%Highlight Fill Opacity") or 50 }, Step = 1, Callback = getCallback("Enemy ESP%%Highlight Fill Opacity") })
windElements["Enemy ESP%%Highlight Outline Opacity"] = enemyesp:Slider({ Title = "Highlight Outline Transparency", Value = { Min = 0, Max = 100, Default = val("Enemy ESP%%Highlight Outline Opacity") or 0 }, Step = 1, Callback = getCallback("Enemy ESP%%Highlight Outline Opacity") })
windElements["Enemy ESP%%Highlight Visible Check"] = enemyesp:Toggle({ Title = "Highlight Visible Check", Value = val("Enemy ESP%%Highlight Visible Check"), Callback = getCallback("Enemy ESP%%Highlight Visible Check") })

local chams_sec = visuals:Section({ Title = "Chams", Opened = false })
windElements["Chams%%Arm Chams"] = chams_sec:Toggle({ Title = "Arm Chams", Value = val("Chams%%Arm Chams"), Callback = getCallback("Chams%%Arm Chams") })
windElements["Chams%%Arm Color"] = chams_sec:Colorpicker({ Title = "Arm Color", Default = val("Chams%%Arm Color") or Color3.new(0.1,0.1,1), Callback = getCallback("Chams%%Arm Color") })
windElements["Chams%%Arm Transparency"] = chams_sec:Slider({ Title = "Arm Transparency", Value = { Min = 0, Max = 100, Default = val("Chams%%Arm Transparency") or 50 }, Step = 1, Callback = getCallback("Chams%%Arm Transparency") })
windElements["Chams%%Arm Material"] = chams_sec:Dropdown({ Title = "Arm Material", Values = {"ForceField", "SmoothPlastic", "Glass"}, Value = val("Chams%%Arm Material") or "ForceField", Callback = getCallback("Chams%%Arm Material") })
windElements["Chams%%Gun Chams"] = chams_sec:Toggle({ Title = "Gun Chams", Value = val("Chams%%Gun Chams"), Callback = getCallback("Chams%%Gun Chams") })
windElements["Chams%%Gun Color"] = chams_sec:Colorpicker({ Title = "Gun Color", Default = val("Chams%%Gun Color") or Color3.new(0.1,0.1,1), Callback = getCallback("Chams%%Gun Color") })
windElements["Chams%%Gun Transparency"] = chams_sec:Slider({ Title = "Gun Transparency", Value = { Min = 0, Max = 100, Default = val("Chams%%Gun Transparency") or 50 }, Step = 1, Callback = getCallback("Chams%%Gun Transparency") })
windElements["Chams%%Gun Material"] = chams_sec:Dropdown({ Title = "Gun Material", Values = {"ForceField", "SmoothPlastic", "Glass"}, Value = val("Chams%%Gun Material") or "ForceField", Callback = getCallback("Chams%%Gun Material") })

local morechams = visuals:Section({ Title = "More Chams", Opened = false })
windElements["More Chams%%Third Person Character Chams"] = morechams:Toggle({ Title = "Third Person Character Chams", Value = val("More Chams%%Third Person Character Chams"), Callback = getCallback("More Chams%%Third Person Character Chams") })
windElements["More Chams%%Character Color"] = morechams:Colorpicker({ Title = "Character Color", Default = val("More Chams%%Character Color") or Color3.new(0.1,0.1,1), Callback = getCallback("More Chams%%Character Color") })
windElements["More Chams%%Character Transparency"] = morechams:Slider({ Title = "Character Transparency", Value = { Min = 0, Max = 100, Default = val("More Chams%%Character Transparency") or 50 }, Step = 1, Callback = getCallback("More Chams%%Character Transparency") })
windElements["More Chams%%Character Material"] = morechams:Dropdown({ Title = "Character Material", Values = {"ForceField", "SmoothPlastic", "Glass"}, Value = val("More Chams%%Character Material") or "ForceField", Callback = getCallback("More Chams%%Character Material") })

local worldvisuals = visuals:Section({ Title = "World Visuals", Opened = false })
windElements["World Visuals%%Ambient"] = worldvisuals:Toggle({ Title = "Ambient", Value = val("World Visuals%%Ambient"), Callback = getCallback("World Visuals%%Ambient") })
worldvisuals:Keybind({ Title = "Ambient Key Bind", Value = "None" })
windElements["World Visuals%%Ambient Color"] = worldvisuals:Colorpicker({ Title = "Ambient Color", Default = val("World Visuals%%Ambient Color") or Color3.new(0.1,0.1,1), Callback = getCallback("World Visuals%%Ambient Color") })
windElements["World Visuals%%Bullet Tracers"] = worldvisuals:Toggle({ Title = "Bullet Tracers", Value = val("World Visuals%%Bullet Tracers"), Callback = getCallback("World Visuals%%Bullet Tracers") })
worldvisuals:Keybind({ Title = "Tracers Key Bind", Value = "None" })
windElements["World Visuals%%Color One"] = worldvisuals:Colorpicker({ Title = "Color One", Default = val("World Visuals%%Color One") or Color3.new(0.1,0.1,1), Callback = getCallback("World Visuals%%Color One") })
windElements["World Visuals%%Color Two"] = worldvisuals:Colorpicker({ Title = "Color Two", Default = val("World Visuals%%Color Two") or Color3.new(1,0.9,0.9), Callback = getCallback("World Visuals%%Color Two") })
windElements["World Visuals%%Tracers Size"] = worldvisuals:Slider({ Title = "Tracers Size", Value = { Min = 0.05, Max = 3, Default = val("World Visuals%%Tracers Size") or 0.1 }, Step = 0.05, Callback = getCallback("World Visuals%%Tracers Size") })
windElements["World Visuals%%Tracers Transparency"] = worldvisuals:Slider({ Title = "Tracers Transparency", Value = { Min = 0, Max = 100, Default = val("World Visuals%%Tracers Transparency") or 50 }, Step = 1, Callback = getCallback("World Visuals%%Tracers Transparency") })
windElements["World Visuals%%Tracers Material"] = worldvisuals:Dropdown({ Title = "Tracers Material", Values = {"ForceField", "SmoothPlastic", "Glass"}, Value = val("World Visuals%%Tracers Material") or "ForceField", Callback = getCallback("World Visuals%%Tracers Material") })
windElements["World Visuals%%Impact Points"] = worldvisuals:Toggle({ Title = "Impact Points", Value = val("World Visuals%%Impact Points"), Callback = getCallback("World Visuals%%Impact Points") })
worldvisuals:Keybind({ Title = "Points Key Bind", Value = "None" })
windElements["World Visuals%%Points Color"] = worldvisuals:Colorpicker({ Title = "Points Color", Default = val("World Visuals%%Points Color") or Color3.new(0.1,0.1,1), Callback = getCallback("World Visuals%%Points Color") })
windElements["World Visuals%%Points Transparency"] = worldvisuals:Slider({ Title = "Points Transparency", Value = { Min = 0, Max = 100, Default = val("World Visuals%%Points Transparency") or 50 }, Step = 1, Callback = getCallback("World Visuals%%Points Transparency") })
windElements["World Visuals%%Points Material"] = worldvisuals:Dropdown({ Title = "Points Material", Values = {"ForceField", "SmoothPlastic", "Glass"}, Value = val("World Visuals%%Points Material") or "ForceField", Callback = getCallback("World Visuals%%Points Material") })
windElements["World Visuals%%Duration"] = worldvisuals:Slider({ Title = "Duration", Value = { Min = 1, Max = 5, Default = val("World Visuals%%Duration") or 4 }, Step = 0.5, Callback = getCallback("World Visuals%%Duration") })

local thirdperson = visuals:Section({ Title = "Third Person", Opened = false })
windElements["Third Person%%Enabled"] = thirdperson:Toggle({ Title = "Enabled", Value = val("Third Person%%Enabled"), Callback = getCallback("Third Person%%Enabled") })
thirdperson:Keybind({ Title = "Key Bind", Value = "None" })
windElements["Third Person%%Show Character"] = thirdperson:Toggle({ Title = "Show Character", Value = val("Third Person%%Show Character"), Callback = getCallback("Third Person%%Show Character") })
windElements["Third Person%%Show Character While Aiming"] = thirdperson:Toggle({ Title = "Show Character While Aiming", Value = val("Third Person%%Show Character While Aiming"), Callback = getCallback("Third Person%%Show Character While Aiming") })
windElements["Third Person%%Camera Offset X"] = thirdperson:Slider({ Title = "Camera Offset X", Value = { Min = -20, Max = 20, Default = val("Third Person%%Camera Offset X") or 0 }, Step = 1, Callback = getCallback("Third Person%%Camera Offset X") })
windElements["Third Person%%Camera Offset Y"] = thirdperson:Slider({ Title = "Camera Offset Y", Value = { Min = -20, Max = 20, Default = val("Third Person%%Camera Offset Y") or 0 }, Step = 1, Callback = getCallback("Third Person%%Camera Offset Y") })
windElements["Third Person%%Camera Offset Z"] = thirdperson:Slider({ Title = "Camera Offset Z", Value = { Min = -20, Max = 20, Default = val("Third Person%%Camera Offset Z") or 7 }, Step = 1, Callback = getCallback("Third Person%%Camera Offset Z") })
windElements["Third Person%%Camera Offset Always Visible"] = thirdperson:Toggle({ Title = "Camera Offset Always Visible", Value = val("Third Person%%Camera Offset Always Visible"), Callback = getCallback("Third Person%%Camera Offset Always Visible") })
windElements["Third Person%%Apply Anti Aim To Character"] = thirdperson:Toggle({ Title = "Apply Anti Aim To Character", Value = val("Third Person%%Apply Anti Aim To Character"), Callback = getCallback("Third Person%%Apply Anti Aim To Character") })

local crosshair_sec = visuals:Section({ Title = "Crosshair", Opened = false })
windElements["Crosshair%%Enabled"] = crosshair_sec:Toggle({ Title = "Enabled", Value = val("Crosshair%%Enabled"), Callback = getCallback("Crosshair%%Enabled") })
crosshair_sec:Keybind({ Title = "Key Bind", Value = "None" })
windElements["Crosshair%%Crosshair Color"] = crosshair_sec:Colorpicker({ Title = "Crosshair Color", Default = val("Crosshair%%Crosshair Color") or Color3.new(0.1,0.1,1), Callback = getCallback("Crosshair%%Crosshair Color") })
windElements["Crosshair%%Show Dot"] = crosshair_sec:Toggle({ Title = "Show Dot", Value = val("Crosshair%%Show Dot"), Callback = getCallback("Crosshair%%Show Dot") })
windElements["Crosshair%%Follow Recoil"] = crosshair_sec:Toggle({ Title = "Follow Recoil", Value = val("Crosshair%%Follow Recoil"), Callback = getCallback("Crosshair%%Follow Recoil") })
windElements["Crosshair%%X Size"] = crosshair_sec:Slider({ Title = "X Size", Value = { Min = 1, Max = 50, Default = val("Crosshair%%X Size") or 10 }, Step = 1, Callback = getCallback("Crosshair%%X Size") })
windElements["Crosshair%%Y Size"] = crosshair_sec:Slider({ Title = "Y Size", Value = { Min = 1, Max = 50, Default = val("Crosshair%%Y Size") or 10 }, Step = 1, Callback = getCallback("Crosshair%%Y Size") })
windElements["Crosshair%%X Space"] = crosshair_sec:Slider({ Title = "X Space", Value = { Min = 1, Max = 50, Default = val("Crosshair%%X Space") or 10 }, Step = 1, Callback = getCallback("Crosshair%%X Space") })
windElements["Crosshair%%Y Space"] = crosshair_sec:Slider({ Title = "Y Space", Value = { Min = 1, Max = 50, Default = val("Crosshair%%Y Space") or 10 }, Step = 1, Callback = getCallback("Crosshair%%Y Space") })
windElements["Crosshair%%Spin Speed"] = crosshair_sec:Slider({ Title = "Spin Speed", Value = { Min = 0, Max = 3, Default = val("Crosshair%%Spin Speed") or 0 }, Step = 0.05, Callback = getCallback("Crosshair%%Spin Speed") })
windElements["Crosshair%%Rainbow Crosshair"] = crosshair_sec:Toggle({ Title = "Rainbow Crosshair", Value = val("Crosshair%%Rainbow Crosshair"), Callback = getCallback("Crosshair%%Rainbow Crosshair") })
windElements["Crosshair%%Rainbow Speed"] = crosshair_sec:Slider({ Title = "Rainbow Speed", Value = { Min = 0, Max = 3, Default = val("Crosshair%%Rainbow Speed") or 0.5 }, Step = 0.05, Callback = getCallback("Crosshair%%Rainbow Speed") })

-- ============= MISC TAB =============
local movement = misc:Section({ Title = "Movement", Opened = true })
windElements["Movement%%Walk Speed"] = movement:Toggle({ Title = "Walk Speed", Value = val("Movement%%Walk Speed"), Callback = getCallback("Movement%%Walk Speed") })
movement:Keybind({ Title = "Walk Bind", Value = "None" })
windElements["Movement%%Set Speed"] = movement:Slider({ Title = "Set Speed", Value = { Min = 10, Max = 250, Default = val("Movement%%Set Speed") or 50 }, Step = 1, Callback = getCallback("Movement%%Set Speed") })
windElements["Movement%%Jump Power"] = movement:Toggle({ Title = "Jump Power", Value = val("Movement%%Jump Power"), Callback = getCallback("Movement%%Jump Power") })
movement:Keybind({ Title = "Jump Bind", Value = "None" })
windElements["Movement%%Height Addition"] = movement:Slider({ Title = "Height Addition", Value = { Min = 1, Max = 15, Default = val("Movement%%Height Addition") or 10 }, Step = 1, Callback = getCallback("Movement%%Height Addition") })
windElements["Movement%%No Fall Damage"] = movement:Toggle({ Title = "No Fall Damage", Value = val("Movement%%No Fall Damage"), Callback = getCallback("Movement%%No Fall Damage") })
windElements["Movement%%Bunny Hop"] = movement:Toggle({ Title = "Bunny Hop", Value = val("Movement%%Bunny Hop"), Callback = getCallback("Movement%%Bunny Hop") })
movement:Keybind({ Title = "BHop Bind", Value = "None" })
windElements["Movement%%Only While Jumping"] = movement:Toggle({ Title = "Only While Jumping", Value = val("Movement%%Only While Jumping"), Callback = getCallback("Movement%%Only While Jumping") })

local sounds_sec = misc:Section({ Title = "Sounds", Opened = false })
windElements["Sounds%%Shoot Sound"] = sounds_sec:Dropdown({ Title = "Shoot Sound", Values = soundFileList, Value = val("Sounds%%Shoot Sound") or "None", Callback = getCallback("Sounds%%Shoot Sound") })
windElements["Sounds%%Hit Sound"] = sounds_sec:Dropdown({ Title = "Hit Sound", Values = soundFileList, Value = val("Sounds%%Hit Sound") or "None", Callback = getCallback("Sounds%%Hit Sound") })
windElements["Sounds%%Kill Sound"] = sounds_sec:Dropdown({ Title = "Kill Sound", Values = soundFileList, Value = val("Sounds%%Kill Sound") or "None", Callback = getCallback("Sounds%%Kill Sound") })
windElements["Sounds%%Got Hit Sound"] = sounds_sec:Dropdown({ Title = "Got Hit Sound", Values = soundFileList, Value = val("Sounds%%Got Hit Sound") or "None", Callback = getCallback("Sounds%%Got Hit Sound") })
windElements["Sounds%%Glass Breaking Sound"] = sounds_sec:Dropdown({ Title = "Glass Breaking Sound", Values = soundFileList, Value = val("Sounds%%Glass Breaking Sound") or "None", Callback = getCallback("Sounds%%Glass Breaking Sound") })
windElements["Sounds%%Footstep Sound"] = sounds_sec:Dropdown({ Title = "Footstep Sound", Values = soundFileList, Value = val("Sounds%%Footstep Sound") or "None", Callback = getCallback("Sounds%%Footstep Sound") })

local hopper = misc:Section({ Title = "Server Hopper", Opened = false })
hopper:Button({ Title = "Server Hop", Callback = getCallback("Server Hopper%%Server Hop") })
hopper:Button({ Title = "Rejoin", Callback = getCallback("Server Hopper%%Rejoin") })
hopper:Button({ Title = "Copy Join Script", Callback = getCallback("Server Hopper%%Copy Join Script") })
hopper:Button({ Title = "Clear Cached Servers", Callback = getCallback("Server Hopper%%Clear Cached Servers") })

-- ============= SETTINGS TAB =============
local cheatSettings = settingsTab:Section({ Title = "Cheat Settings", Opened = true })
windElements["Cheat Settings%%Save Last Config"] = cheatSettings:Toggle({ Title = "Save Last Config", Value = val("Cheat Settings%%Save Last Config"), Callback = getCallback("Cheat Settings%%Save Last Config") })
cheatSettings:Button({ Title = "Copy Discord Invite", Callback = function()
    pcall(setclipboard, "")
end })
cheatSettings:Button({ Title = "Unload", Callback = function()
    pcall(function()
        if unloadMain then unloadMain() end
    end)
    stopScanning()
    pcall(function()
        for _, drawingFolder in game:GetService("CoreGui"):GetChildren() do
            if drawingFolder.Name == "KekWare Drawing" then
                drawingFolder:Destroy()
            end
        end
    end)
    for _, connection in pairs(connectionList) do
        pcall(function() connection:Disconnect() end)
    end
    Window:Close()
end })

local configuration = settingsTab:Section({ Title = "Configuration", Opened = false })
windElements["Configuration%%Config List"] = configuration:Dropdown({ Title = "Config List", Values = getConfigNames(), Value = val("Configuration%%Config List") or "", Callback = getCallback("Configuration%%Config List") })
configuration:Button({ Title = "Load Config", Callback = function()
    local cfgName = kekware:GetValue("Configuration", "Config List")
    if cfgName and isfile(folderName .. "/configs/" .. cfgName .. ".json") then
        local config = httpService:JSONDecode(readfile(folderName .. "/configs/" .. cfgName .. ".json"))
        for key, value in pairs(config) do
            if key ~= "Keybinds" then
                if type(value) == "table" then
                    value = Color3.new(table.unpack(value))
                end
                kekware._values[key] = value
                local elem = windElements[key]
                if elem then
                    pcall(function() elem:Set(value) end)
                end
            end
        end
        local nameElem = windElements["Configuration%%Config Name"]
        if nameElem then
            pcall(function() nameElem:Set(cfgName) end)
        end
        kekware._values["Configuration%%Config Name"] = cfgName
    end
end })
configuration:Button({ Title = "Update Config List", Callback = function()
    local elem = windElements["Configuration%%Config List"]
    if elem then
        pcall(function() elem:Set(getConfigNames()) end)
    end
end })
windElements["Configuration%%Config Name"] = configuration:Input({ Title = "Config Name", Placeholder = "New Config", Callback = getCallback("Configuration%%Config Name") })
configuration:Button({ Title = "Save Config", Callback = function()
    local cfgName = kekware:GetValue("Configuration", "Config Name")
    if cfgName and cfgName ~= "" then
        saveConfig(folderName .. "/configs/" .. cfgName .. ".json", getConfig())
        WindUI:Notify({
            Title = "KekWare",
            Content = "Config '" .. cfgName .. "' saved!",
            Duration = 3,
            Icon = "check",
        })
    end
end })

-- =============================================
-- Callback overrides (Settings)
-- =============================================
callbackList["Server Hopper%%Server Hop"] = function()
    pcall(function()
        local servers = httpService:JSONDecode(readfile(folderName .. "/cache/servers.json"))
        local placeId = game.PlaceId
        local url = "https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100"
        local response = httpService:JSONDecode(game:HttpGet(url))
        if response and response.data then
            for _, server in pairs(response.data) do
                if server.playing < server.maxPlayers and server.id ~= game.JobId and not table.find(servers, server.id) then
                    table.insert(servers, server.id)
                    writefile(folderName .. "/cache/servers.json", httpService:JSONEncode(servers))
                    game:GetService("TeleportService"):TeleportToPlaceInstance(placeId, server.id)
                    return
                end
            end
        end
    end)
end

callbackList["Server Hopper%%Rejoin"] = function()
    pcall(function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId)
    end)
end

callbackList["Server Hopper%%Copy Join Script"] = function()
    pcall(function()
        setclipboard('game:GetService("TeleportService"):TeleportToPlaceInstance(' .. game.PlaceId .. ', "' .. game.JobId .. '")')
    end)
end

callbackList["Server Hopper%%Clear Cached Servers"] = function()
    pcall(function()
        writefile(folderName .. "/cache/servers.json", httpService:JSONEncode({}))
    end)
end

-- =============================================
-- Done
-- =============================================
warn("[KekWare] Menu created successfully!")

WindUI:Notify({
    Title   = "KekWare",
    Content = "v1.0.0 ALPHA loaded successfully!",
    Duration = 3,
    Icon    = "check",
})
