-- PrisonX v1.25 by TS2021
-- OPEN-SOURCE (so you can edit this script and add stuff, rather than starting from scratch)
-- Discontinued

--[[
Features: All implemented in a UI as well!
Gun Obtainer (-gun (GUN NAME))
TP to Locations (-lc (LOCATION))
Kill Feed (-killfeed / -unkillfeed)
Trespassing/Hostile Player Detector (-htdetect / -unhtdetect)
Anti Arrest (-antiar / -unantiar)
Anti Tase (-antitase / -unantitase)

Kill Aura (-killaura / -unkillaura)
Kill Aura Radius (-karadius (NUMBER))
Kill Aura Team Check + Options
Kill Aura Whitelist (-kawl / -unkawl)
Kill Aura Visibility (-kasphere / -unkasphere)

Arrest Aura (-araura/-unaraura)
Arrest Aura Radius (-aaradius)
Arrest Aura Team Check + Options
Arrest Aura Whitelist (-aawl / -unaawl)

Auto Respawn (spawn in the same place upon death) (-autore / -unautore)
Quick Respawn (does a neat trick to spawn you faster for inmates/guards when possible, part of auto respawn)

Fast Guns (you can also change the rate, default is 0) (-fastguns / -unfastguns / -firerate)
Auto guns (automatically pick up all guns you can when you respawn) (-autoguns / -unautoguns)

Remove doors (-nodoors) / Add doors (-adddoors) - CLIENT-SIDE!
Destroy doors (-ddoors) - CLIENT-SIDE!
Spam open doors (must be a guard/have a keycard) (-sodoors / -unsodoors) - Patched

Toilet Breaker (must have hammer) (-btoilets)
Auto Toilet Breaker (-abtoilets / -unabtoilets)

Remove jump cooldown (anti-jump removal) (-rjc)
Auto anti-jump removal (-aajr/-unajr)

Unkillable Fence (if you step on top of it, you won't die) (-nkfence)
Hide/Show Trees (-htrees / -strees)
Remove Team Indicators

Destroy Prison Fences (-dfences) - CLIENT-SIDE!
Destroy Prison Gates (-dgates) - CLIENT-SIDE!

ESP (distance from you + health + team colour) (+ teams allowed) (-esp/-unesp)
Aimbot/Aimlock (+ teams allowed + torso/head targetting + guns allowed)
Noclip / Snack Noclip
FOV Changer
Spin
Infinite Jump
Auto Sprint / Speed Changer

Auto Keycard

Credits to github.com/tomatotxt for some stuff
Credits to github.com/NewMatheusDC for some of the GUI
]]

--[[
MISSING FEATURES:
-> More Silent Aim/Aimlock Features
   (use https://scriptblox.com/script/Prison-Life-Silent-Aim-And-ESP-With-UI-SRC-78055)
-> Invisibility 
   (use https://scriptblox.com/script/Prison-Life-Keyless-72569 or https://scriptblox.com/script/MP5-Prison-Life-PLH-75263 or https://scriptblox.com/script/Prison-Life-Best-PL-Script-UNDETECTED-SILENT-AIM-INSTANT-KILL-AND-MORE-72300)
-> C4 ESP [coming not very soon]
   (use https://scriptblox.com/script/Prison-Life-Silent-Aim-And-ESP-With-UI-SRC-78055)
]]

-- Infinite yield for speed, jump power
loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()

if getgenv().plx_executed then
	warn("PrisonX is already executed.") 
	return 
end

getgenv().plx_executed = true

local prefix = "-"

-- Settings
local settings = {
	-- When a player dies, it tells you
    killfeed = true,

	-- Respawn in the same place upon arrest, and make you a criminal if you were one
    antiarrest = false,

	-- Remove tased effects
    antitase = true,

	-- Respawn in your previous position if you die (sucks because of tp update)
    autorespawn = false,

	-- Auto guns
	autoguns = false,
	autoguns_list = {},
	
	-- Auto-Mod all guns to shoot really fast (fg = fast gun)
	auto_fg = false,
	auto_fgrate = 0, -- if you want to make it slower...

	-- Remove doors (CAUSES 1 SEC OF LAG WHENEVER YOU RESPAWN)
	nodoors = false,

	-- Transparent doors
	tdoors = false,

	-- Spam open doors (must be guard / have a keycard)
--	sodoors = false,

	-- Kill aura
	killaura = false,
	killaura_radius = 10,
	killaura_sphere = false, -- visual sphere
	
	katc = false, -- team check
	katype = "All", -- target types
	katype_allowed = {}, -- table for allowed teams

	-- Arrest aura
	arrestaura = false,
	arrestaura_radius = 15,
	aatc = false, -- arrest aura team check
	aatype = "Both", -- what players it can arrest

	-- Stop tases from disabling the reset button
	enablere = true,

	-- Auto anti-jump removal
	aajr = true,
	
	-- Auto break toilets when you have a hammer
	abtoilets = false,

	-- Auto keycard
	akeycard = true,

	-- Trespassing/Hostile Inmate detector
	htdetect = true,
	
	-- Old gun sounds (neat ig)
	oldsounds = true,
	oldsoundsmeonly = false, -- if you want it to just be you
	
	-- Hide trees
	htrees = false,

	-- Auto sprint
	autosprint = false,

	-- Speed changer
	speedc = false,

	-- Speed changer value
	sval = 25,
	
	-- Infinite jump
	ijump = false,

	-- Noclip
	noclip = false,

	-- Temp Noclip ONLY when jumping with the Snack item equipped
	ncglitch = false,
	
	-- Keep PrisonX after serverhop/rejoin
	KeepPX = true
}

getgenv().espsettings = false -- ESP toggle
getgenv().aimlock = false -- Aimlock toggle

-- arrest aura wl
aa_wl = {"ScriptingProgrammer", "kohlslitedev"}

-- kill aura wl
ka_wl = {"ScriptingProgrammer", "kohlslitedev"}

-- Notifications
local StarterGui = game:GetService("StarterGui")
local function Notify(text, time)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "PrisonX";
            Text = text;
            Duration = time or 2;
        })
    end)
end

local version = "v1.25"

-- GUI Setup
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "PrisonX",
    Icon = nil,
    LoadingTitle = "PrisonX v1.25",
    LoadingSubtitle = "Created by TS2021",
    ConfigurationSaving = {
        Enabled = false,
    },
    Discord = {
        Enabled = false,
    },
    KeySystem = false,
})

-- Tabs
local MainTab = Window:CreateTab("Main Features", nil)
local CombatTab = Window:CreateTab("Combat", nil)
local TeleportTab = Window:CreateTab("Teleport", nil)
local AutoTab = Window:CreateTab("Automation", nil)
local ProtectTab = Window:CreateTab("Protection", nil)
local PlayerTab = Window:CreateTab("Player", nil)
local ESPTab = Window:CreateTab("ESP", nil)
local AimbotTab = Window:CreateTab("Aimlock", nil)
local LCTab = Window:CreateTab("Lists + Checks", nil)
local OtherTab = Window:CreateTab("Other", nil)

-- Variables
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local hbeat = RunService.Heartbeat
local rstepped = RunService.RenderStepped
local stepped = RunService.Stepped

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Killfeed = ReplicatedStorage:WaitForChild("Killfeed")
local CharacterCollision = ReplicatedStorage.Scripts:FindFirstChild("CharacterCollision")

local PlayerGui = LocalPlayer.PlayerGui
local HomeGUI = PlayerGui:WaitForChild("Home")

local Camera = workspace.Camera

local Teams = game:GetService("Teams")
--local TeamEvent = ReplicatedStorage.Remotes:WaitForChild("RequestTeamChange")

local meleeEvent = ReplicatedStorage.meleeEvent

local TeamList = {"Criminals", "Inmates", "Guards"}

-- Pass checks
function checkRIOT()	
	if game:GetService("MarketplaceService"):UserOwnsGamePassAsync(LocalPlayer.UserId, 643697197) then
		return true, "NEW"
	end

	if game:GetService("MarketplaceService"):UserOwnsGamePassAsync(LocalPlayer.UserId, 96651) then
		return true, "LEGACY"
	end

	return false, "N/A"
end

function checkMAFIA()	
	if game:GetService("MarketplaceService"):UserOwnsGamePassAsync(LocalPlayer.UserId, 1443271) then
		return true
	end

	return false
end

function checkSniper()	
	if game:GetService("MarketplaceService"):UserOwnsGamePassAsync(LocalPlayer.UserId, 699360089) then
		return true
	end

	return false
end

riot_pass, type = checkRIOT()
mafia_pass = checkMAFIA()
sniper_pass = checkSniper()

-- Teleport Locations
local Teleports = {
	neutral_spawn = {
		name = "Neutral Spawn", 
		cframe = CFrame.new(879.2, 36.09, 2349.8)
	},
	
	cell_block = {
		name = "(P) Cell Block",
		cframe = CFrame.new(918.9735107421875, 99.98998260498047, 2451.423583984375)
	},

	nexus = {
		name = "(P) Nexus",
		cframe = CFrame.new(877.929688, 99.9899826, 2373.57031, 0.989495575, 1.64841456e-08, 0.144563332, -3.13438235e-08, 1, 1.00512544e-07, -0.144563332, -1.0398788e-07, 0.989495575)
	},

	armory = {
		name = "(P) Armory",
		cframe = CFrame.new(836.130432, 99.9899826, 2284.55908, 0.999849498, 5.64007507e-08, -0.0173475463, -5.636889e-08, 1, 2.3254485e-09, 0.0173475463, -1.34723666e-09, 0.999849498)
	},
		
	yard = {
		name = "(P) Yard",
		cframe = CFrame.new(787.560425, 97.9999237, 2468.32056, -0.999741256, -7.32754017e-08, -0.0227459427, -7.49895506e-08, 1, 7.45077955e-08, 0.0227459427, 7.6194226e-08, -0.999741256)
	},
	
	criminal_base = {
		name = "Criminal Base / Warehouse",
		cframe = CFrame.new(-864.760071, 94.4760284, 2085.87671, 0.999284029, 1.78674284e-08, 0.0378339142, -1.85715123e-08, 1, 1.82584365e-08, -0.0378339142, -1.89479969e-08, 0.999284029)
	},
	
	cafeteria = {
		name = "(P) Cafeteria",
		cframe = CFrame.new(884.492798, 99.9899368, 2293.54907, -0.0628612712, -2.14097344e-08, -0.998022258, -9.52544568e-08, 1, -1.54524784e-08, 0.998022258, 9.40947018e-08, -0.0628612712)
	},
	
	kitchen = {
		name = "(P) Kitchen",
		cframe = CFrame.new(936.633118, 99.9899368, 2224.77148, -0.00265917974, -9.30829671e-08, 0.999996483, -3.28682326e-08, 1, 9.29958901e-08, -0.999996483, -3.26208252e-08, -0.00265917974)
	},
	
	prison_roof = {
		name = "(P) Roof",
		cframe = CFrame.new(918.694092, 139.709427, 2266.60986, -0.998788536, -7.55880691e-08, -0.0492084064, -7.8453354e-08, 1, 5.62961198e-08, 0.0492084064, 6.00884817e-08, -0.998788536)
	},

	vents = {
		name = "(P) Vents",
		cframe = CFrame.new(933.55376574342, 121.534234671875, 2232.7952174975)
	},

	secret_room = {
		name = "(P) Secret Room / Office",
		cframe = CFrame.new(706.1928465, 103.14982749, 2344.3957382525)
	},

	yard_tower = {
		name = "(P) Yard Tower",
		cframe = CFrame.new(786.731873, 125.039917, 2587.79834, -0.0578307845, 8.82393678e-08, 0.998326421, 6.09781523e-08, 1, -8.48549675e-08, -0.998326421, 5.59688687e-08, -0.0578307845)
	},

	prison_wall = { 
		name = "(P) Left Front Wall", 
		cframe = CFrame.new(505.551605, 125.039917, 2127.41138, -0.99910152, 5.44945458e-08, 0.0423811078, 5.36830491e-08, 1, -2.02856469e-08, -0.0423811078, -1.79922726e-08, -0.99910152)
	},
	
	garage = {
		name = "(P) Garage",
		cframe = CFrame.new(618.705566, 98.039917, 2469.14136, 0.997341573, 1.85835844e-08, -0.0728682056, -1.79448154e-08, 1, 9.42077172e-09, 0.0728682056, -8.0881204e-09, 0.997341573)
	},
	
	sewers = {
		name = "(P) Sewers",
		cframe = CFrame.new(917.123657, 78.6990509, 2297.05298, -0.999281704, -9.98203404e-08, -0.0378962979, -1.01324503e-07, 1, 3.77708638e-08, 0.0378962979, 4.15835579e-08, -0.999281704)
	},

	neighborhood = { 
		name = "Neighbourhood",
		cframe = CFrame.new(-281.254669, 54.1751289, 2484.75513, 0.0408788249, 3.26279768e-08, 0.999164104, -3.88249717e-08, 1, -3.10668256e-08, -0.999164104, -3.75225433e-08, 0.0408788249)
	},
	
	gas_station = { 
		name = "Gas Station",
		cframe = CFrame.new(-497.284821, 54.3937759, 1686.3175, 0.585129559, -4.33374865e-08, -0.810939848, 5.33533938e-13, 1, -5.34406759e-08, 0.810939848, 3.12692876e-08, 0.585129559)
	},
	
	roadend_by_warehouse = { 
		name = "Roadend by Warehouse",
		cframe = CFrame.new(-979.852478, 54.1750259, 1382.78967, 0.0152699631, 8.88235174e-09, 0.999883413, 6.75286884e-08, 1, -9.9146682e-09, -0.999883413, 6.76722109e-08, 0.0152699631)
	},
	
	lakeside_grocer = { 
		name = "Lakeside Grocer / Armory+",
		cframe =CFrame.new(455.089508, 11.4253607, 1222.89746, 0.99995482, -3.92535604e-09, 0.00950394664, 2.84450263e-09, 1, 1.1374032e-07, -0.00950394664, -1.13708147e-07, 0.99995482)
	},
	
	roadend_by_prison = { 
		name = "Roadend by Prison",
		cframe = CFrame.new(1060.81995, 67.5668106, 1847.08923, 0.0752086118, -1.01192255e-08, -0.997167826, 4.30985886e-10, 1, -1.01154605e-08, 0.997167826, 3.31004502e-10, 0.0752086118)
	},
	
	big_building_trap = { 
		name = "Inside Big Building (Trap)",
		cframe = CFrame.new(-306.715485, 84.2401199, 1984.13367, -0.802221119, 5.70582088e-08, -0.597027004, 4.81801123e-08, 1, 3.08312771e-08, 0.597027004, -4.0313255e-09, -0.802221119)
	},
	
	trapped_in_shops = { 
		name = "Inside Top of Shops (Trap)",
		cframe = CFrame.new(-315.790436, 64.5724411, 1840.83521, 0.80697298, -4.47871713e-08, 0.590588331, 1.14004006e-08, 1, 6.02574701e-08, -0.590588331, -4.18932053e-08, 0.80697298)
	},
	
	warehouse_trap = { 
		name = "Inside Other Warehouse (Trap)",
		cframe = CFrame.new(-943.973145, 94.1287613, 1919.73694, 0.025614135, -1.48015129e-08, 0.999671876, 1.00375175e-07, 1, 1.22345032e-08, -0.999671876, 1.00028863e-07, 0.025614135)
	},
	
	big_building_roof = { 
		name = "Top of Big Building",
		cframe = CFrame.new(-317.689331, 118.838821, 2009.28186, 0.749499857, 2.48145682e-09, 0.662004471, 3.51757373e-10, 1, -4.14664703e-09, -0.662004471, 3.34077632e-09, 0.749499857)
	}
	
}

local TeleportAliases = {
    ["neutral spawn"] = "neutral_spawn",
    ["spawn"] = "neutral_spawn",
    ["nspawn"] = "neutral_spawn",

    ["cell block"] = "cell_block",
    ["cells"] = "cell_block",

    ["nexus"] = "nexus",

	["armory"] = "armory",
	["armoury"] = "armory",

	["yard"] = "yard",
	["courtyard"] = "yard",

	["cbase"] = "criminal_base",
	["crimbase"] = "criminal_base",
	["crim base"] = "criminal_base",
	["crim spawn"] = "criminal_base",
	["criminal base"] = "criminal_base",
	["warehouse"] = "criminal_base",

	["cafe"] = "cafeteria",
	["cafeteria"] = "cafeteria",
	["canteen"] = "cafeteria",

	["kitchen"] = "kitchen",

	["prison roof"] = "prison_roof",
	["proof"] = "prison_roof",
	["roof"] = "prison_roof",

	["vent"] = "vents",
	["vents"] = "vents",

	["secret room"] = "secret_room",
	["secret"] = "secret_room",
	["glitch room"] = "secret_room",
	["area 52"] = "secret_room",
	["office"] = "secret_room",

	["ytower"] = "yard_tower",
	["yard tower"] = "yard_tower",
	["tower"] = "yard_tower",

	["prison wall"] = "prison_wall",
	["prison front"] = "prison_wall",
	["pwall"] = "prison_wall",
	["wall"] = "prison_wall",
	["pfront"] = "prison_wall",
	["front"] = "prison_wall",

	["garage"] = "garage",
	["garage"] = "garages",

	["sewer"] = "sewers",
	["sewers"] = "sewers",

	["housing"] = "neighborhood",
	["houses"] = "neighborhood",
	["homes"] = "neighborhood",
	["neighborhood"] = "neighborhood",
	["neighbourhood"] = "neighborhood",

	["gas"] = "gas_station",
	["petrol"] = "gas_station",
	["gas station"] = "gas_station",
	["petrol station"] = "gas_station",

	["wroadend"] = "roadend_by_warehouse",
	["wdeadend"] = "roadend_by_warehouse",
	["deadend"] = "roadend_by_warehouse",

	["armory+"] = "lakeside_grocer",
	["armory plus"] = "lakeside_grocer",
	["lakeside"] = "lakeside_grocer",
	["lakeside grocer"] = "lakeside_grocer",
	["grocer"] = "lakeside_grocer",

	["proadend"] = "roadend_by_prison",
	["pdeadend"] = "roadend_by_prison",
	["roadend"] = "roadend_by_prison",
	
	["bbt"] = "big_building_trap",
	["bigtrap"] = "big_building_trap",
	["buildtrap"] = "big_building_trap",
	["bbtrap"] = "big_building_trap",

	["shop trap"] = "trapped_in_shops",
	["shops trap"] = "trapped_in_shops",
	["shoptrap"] = "trapped_in_shops",
	["shopstrap"] = "trapped_in_shops",

	["warehouse trap"] = "warehouse_trap",
	["wtrap"] = "warehouse_trap",
	["whtrap"] = "warehouse_trap",

	["bbroof"] = "big_building_roof",
	["broof"] = "big_building_roof",
	["bigroof"] = "big_building_roof",
}

local TeleportDisplayNames = {}
local DisplayToId = {}

for id, data in pairs(Teleports) do
    table.insert(TeleportDisplayNames, data.name)
    DisplayToId[data.name] = id
end

table.sort(TeleportDisplayNames)


-- Teleport to location
local function teleportTo(id)
    local data = Teleports[id]
    if not data then
        warn("Teleport ID not found:", id)
        return
    end

    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    hrp.CFrame = data.cframe
    Notify("Teleported to: " .. data.name)
end

local gunAliases = {
   -- ["m9"] = "M9",
    ["ak-47"] = "AK-47",
	["mp5"] = "MP5",
    ["ak"] = "AK-47",
    ["ak47"] = "AK-47",
    ["remington"] = "Remington 870",
    ["rem"] = "Remington 870",
    ["shotgun"] = "Remington 870",
    ["m4"] = "M4A1",
    ["m4a1"] = "M4A1",
	["fal"] = "FAL"
}

local allGuns
-- Guns in the game

allGuns = {"AK-47", "Remington 870", "MP5"}

if riot_pass then
	table.insert(allGuns, "M4A1")
end

if mafia_pass then
	table.insert(allGuns, "FAL")
end

if sniper_pass then
	table.insert(allGuns, "M700")
	--table.insert(allGuns, "Revolver")
end

local allGuns2 = {}
for _, gun in ipairs(allGuns) do
    table.insert(allGuns2, gun)
end
table.insert(allGuns2, "Taser")
table.insert(allGuns2, "M9")
table.insert(allGuns2, "Revolver")

local AlreadyFound = {}
local function FindGunSpawner(GunName)
    if AlreadyFound[GunName] then
        return AlreadyFound[GunName], true
    end

    for _, v in ipairs(workspace:GetDescendants()) do
        if v.Name == "TouchGiver" then
            -- get the "actual" giver
            local ActualGiver = v:FindFirstChild("TouchGiver") or v

            -- check attribute on v (normal guns)
            if v:GetAttribute("ToolName") == GunName then
				--print("A CHECK")
                AlreadyFound[GunName] = ActualGiver
                return ActualGiver, false
            end

			-- check attribute on parent (FAL case)
            if v.Parent and v.Parent:GetAttribute("ToolName") == GunName then
				--print("B CHECK")
                AlreadyFound[GunName] = ActualGiver
                return ActualGiver, false
            end
        end
    end

    warn("Can't find", GunName)
    return nil, nil
end

local function GetTool(ToolName)
    return LocalPlayer:FindFirstChild("Backpack") and LocalPlayer.Backpack:FindFirstChild(ToolName) or LocalPlayer.Character and LocalPlayer.Character:FindFirstChild(ToolName)
end

local function GetGun(GunName)
    local Giver, Found = FindGunSpawner(GunName)
	if not Giver then return end
    if not Found then
        local CloneGiver = Giver:Clone()
        CloneGiver.Parent = Giver.Parent
        Giver.Parent = workspace.Folder
        Giver.CanCollide = false
        Giver.Transparency = 1
    end
	local hrp = LocalPlayer.Character:WaitForChild("HumanoidRootPart")
	hrp.CFrame = Giver.CFrame * CFrame.new(math.random(-2, 2),0,0)
    repeat task.wait()
       
    until GetTool(GunName)
end

-- Fix camera
local function fixcam()
	HomeGUI.hud.Visible = true
--	HomeGUI.intro.Visible = false
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, true)
	Camera.CameraType = Enum.CameraType.Custom
	if LocalPlayer.Character then
		Camera.CameraSubject = LocalPlayer.Character:WaitForChild("Humanoid")
	end
end

-- Check if you already have the gun
local function hasGun(name)
    local backpack = LocalPlayer:WaitForChild("Backpack")
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    return backpack:FindFirstChild(name) or char:FindFirstChild(name)
end

local fugging = false
local function SwitchToCriminalAndReturn(dih, ocf)
	fugging = true
    local crimPad = workspace["Criminals Spawn"].SpawnLocation
    local char = LocalPlayer.Character
    if not char then return end
    hrp = char:WaitForChild("HumanoidRootPart")

	oldCFrame = nil
	if dih == true then
    	oldCFrame = hrp.CFrame  -- store original position
		--print(oldCFrame)
	else
		oldCFrame = ocf
		--print(oldCFrame)
	end

    -- teleport to crim spawn pad
    hrp.CFrame = crimPad.CFrame
    Notify("Teleported to Criminal Spawn...")

    -- wait until team actually changes
    repeat task.wait() until LocalPlayer.Team == Teams.Criminals
    Notify("Now a Criminal!")

    -- return to original position
    hrp.CFrame = oldCFrame
    Notify("Teleported back to original position.")
	fugging = false
end

-- Grab All Guns
function GrabGuns(gunsToGrab)
    local obtained = {}
    for _, gun in ipairs(gunsToGrab) do
        if not hasGun(gun) then
            if GetGun(gun) then
                table.insert(obtained, gun)
            end
            task.wait(0.35)
        end
    end

    if #obtained == 0 then
        Notify("All guns already in inventory!")
    elseif #obtained == 1 then
        Notify("Obtained " .. obtained[1])
    else
        Notify("Obtained all guns!")
    end
end

function unequip()
    LocalPlayer.Character:FindFirstChild("Humanoid"):UnequipTools()
end

function equip(tool)
    LocalPlayer.Character:FindFirstChild("Humanoid"):EquipTool(tool)
end

-- PLAYER CHECK
function PLAYERCHECK(plr, rt)
    plr = plr:lower()
    for _, v in pairs(game.Players:GetPlayers()) do
        if string.sub(v.Name:lower(), 1, #plr) == plr or string.sub(v.DisplayName:lower(), 1, #plr) == plr then
            Notify("Found "..v.Name)
            if rt then
                return v -- only return Player instance
            else
                return v, v.Name -- return both
            end
        end
    end
    return nil, nil
end

----------------------------------------------------------------------------------------

-- Hook __namecall
local namecall
if hookmetamethod then
namecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    
    if method == "GetAttributes" then
        local result = namecall(self, ...)

        if settings.auto_fg then
            result.AutoFire = true
            result.FireRate = auto_fgrate
        end

       -- print(self, "modded")
        return result
    end

    return namecall(self, ...)
end)     
else
	warn("Executor does not support hookmetamethod; gun mods unavailable.")
end

----------------------------------------------------------------------------------------

TeleportService = game:GetService("TeleportService")
PlaceId, JobId = game.PlaceId, game.JobId

-- rejoin server
function rj()
	if #Players:GetPlayers() <= 1 then
		LocalPlayer:Kick("\nRejoining...")
		wait()
		TeleportService:Teleport(PlaceId, Players.LocalPlayer)
	else
		TeleportService:TeleportToPlaceInstance(PlaceId, JobId, Players.LocalPlayer)
	end
end

-- serverhop (iy)
function shop()
	local servers = {}
    local req = game:HttpGet("https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true")
    local body = HttpService:JSONDecode(req)

    if body and body.data then
        for i, v in next, body.data do
            if type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing < v.maxPlayers and v.id ~= JobId then
                table.insert(servers, 1, v.id)
            end
        end
    end

    if #servers > 0 then
        TeleportService:TeleportToPlaceInstance(PlaceId, servers[math.random(1, #servers)], Players.LocalPlayer)
    else
        Notify("No servers could be found.")
    end
end

----------------------------------------------------------------------------------------

-- kill aura whitelist
function kill_aura_wl(lcplayer, lcplayerN)
        if not lcplayer then
            warn("No player selected")
            return
        end

        local playerName = lcplayerN
        local index = table.find(ka_wl, playerName)

        if index then
            table.remove(ka_wl, index)
            print(playerName .. " unwhitelisted from kill aura.")
			Notify(playerName .. " unwhitelisted from kill aura.")
        else
            table.insert(ka_wl, playerName)
            print(playerName .. " whitelisted from kill aura.")
			Notify(playerName .. " whitelisted from kill aura.")
        end
end

-- arrest aura whitelist
function arrest_aura_wl(lcplayer, lcplayerN)
        if not lcplayer then
            warn("No player selected")
            return
        end

        local playerName = lcplayerN
        local index = table.find(aa_wl, playerName)

        if index then
            table.remove(aa_wl, index)
            print(playerName .. " unwhitelisted from arrest aura.")
			Notify(playerName .. " unwhitelisted from arrest aura.")
        else
            table.insert(aa_wl, playerName)
            print(playerName .. " whitelisted from arrest aura.")
			Notify(playerName .. " whitelisted from arrest aura.")
        end
end

----------------------------------------------------------------------------------------

-- Kill aura (PATCHED)
katypes = {
	"All",
	"Criminals",
	"Inmates",
	"Guards",
	"Criminals + Inmates",
	"Criminals + Guards",
	"Inmates + Guards",
	"Other Teams"
}

local function UpdateKillableTeams(v)
  --  print("UpdateKillableTeams called with:", v)
    local lteam = LocalPlayer.Team.Name
    settings.katype = v

    local allowed = {}

    if settings.katype == "All" then
        allowed = {"Criminals", "Inmates", "Guards"}
    elseif settings.katype == "Criminals" then
        allowed = {"Criminals"}
    elseif settings.katype == "Inmates" then
        allowed = {"Inmates"}
    elseif settings.katype == "Guards" then
        allowed = {"Guards"}
    elseif settings.katype == "Criminals + Inmates" then
        allowed = {"Criminals", "Inmates"}
    elseif settings.katype == "Criminals + Guards" then
        allowed = {"Criminals", "Guards"}
    elseif settings.katype == "Inmates + Guards" then
        allowed = {"Inmates", "Guards"}
    elseif settings.katype == "Other Teams" then
        if lteam == "Inmates" then allowed = {"Criminals", "Guards"}
        elseif lteam == "Criminals" then allowed = {"Inmates", "Guards"}
        elseif lteam == "Guards" then allowed = {"Criminals", "Inmates"}
        end
  --  else
  --      print("ERROR: Unknown katype!", settings.katype)
    end

    settings.katype_allowed = allowed
end

local function IsKillable(plr)
	local char = plr.Character
	
    -- Can't kill yourself
    if plr == LocalPlayer then
        return false
    end

	-- do not kill innocent inmates as a guard
    if LocalPlayer.Team.Name == "Guards" and plr.Team.Name == "Inmates" then
		if not char:GetAttribute("Hostile") then
			return false
		end
	end

    -- If team check is disabled, anyone else is killable
    if not settings.katc then
		-- print("Team check is disabled, killing")
        return true
    end

    -- Target's team
    local ttname = plr.Team.Name
	-- print("Target team is".. ttname)
    for _, teamName in ipairs(settings.katype_allowed) do
		-- print("Finding " .. teamName)
        if ttname == teamName then
			-- print("Return it")
            return true
        end
    end
end

settings.katype = settings.katype or "All"
UpdateKillableTeams(settings.katype)

-- Sphere visual
local sphere = Instance.new("Part")
sphere.Shape = Enum.PartType.Ball
sphere.Size = Vector3.new(settings.killaura_radius * 2, settings.killaura_radius * 2, settings.killaura_radius * 2)
sphere.Anchored = true
sphere.CanCollide = false
sphere.Material = Enum.Material.ForceField
sphere.Color = Color3.fromRGB(255, 0, 50)
sphere.Transparency = settings.killaura_sphere and 0.6 or 1
sphere.Parent = workspace

RunService.Heartbeat:Connect(function()
    if not settings.killaura then
        sphere.Transparency = 1
        return
    end

    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- Update sphere visuals
    sphere.Size = Vector3.new(settings.killaura_radius * 2, settings.killaura_radius * 2, settings.killaura_radius * 2)
    sphere.Transparency = settings.killaura_sphere and 0.6 or 1
    sphere.Position = hrp.Position

    -- Get targets in radius
    local touching = workspace:GetPartBoundsInRadius(hrp.Position, settings.killaura_radius)
    local hitList = {}

    for _, part in ipairs(touching) do
        local model = part.Parent
        local hum = model and model:FindFirstChild("Humanoid")
        if hum then
            local targetPlayer = Players:GetPlayerFromCharacter(model)
            if targetPlayer and targetPlayer ~= player and not hitList[targetPlayer] then
				if table.find(ka_wl, targetPlayer.Name) then
					--
				else
					if not IsKillable(targetPlayer) then
						--
					else
						hitList[targetPlayer] = true
                		meleeEvent:FireServer(targetPlayer)
					end
            	end
			end
        end
    end
end)

----------------------------------------------------------------------------------------

-- Arrest Aura (PATCHED)
aatypes = {
	"Criminals",
	"Inmates",
	"Both"
}

local function IsArrestable(plr)
	local char = plr.Character
	
    -- Can't arrest yourself
    if plr == LocalPlayer then
        return false
    end

    -- Must be a Guard to arrest
    if LocalPlayer.Team.Name ~= "Guards" then
        return false
    end

    -- Can't arrest other Guards
    if plr.Team.Name == "Guards" then
        return false
    end

	-- Can't arrest innocent Inmates
    if plr.Team.Name == "Inmates" and not char:GetAttribute("Trespassing") then
        return false
    end
	
    -- If team check is disabled, anyone else is arrestable
    if not settings.aatc then
        return true
    end

    -- Check based on aatype setting
    local ttname = plr.Team.Name
    if settings.aatype == "Criminals" then
        if ttname ~= "Criminals" then
            return false
        end
    elseif settings.aatype == "Inmates" then
        if ttname ~= "Inmates" then
            return false
        end
    elseif settings.aatype == "Both" then
        --
    else
        return false
    end
	
    return true
end

local aremote = ReplicatedStorage.Remotes.ArrestPlayer

RunService.Heartbeat:Connect(function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    if not settings.arrestaura  then return end
		
    for _, plr in Players:GetPlayers() do
        if plr == LocalPlayer then
			--
		else
        	local char = plr.Character
        	if not char then
				--
			else
				if table.find(aa_wl, plr.Name) then
					--
				else 
					if not IsArrestable(plr) then
						--
					else
						local hrp = char:FindFirstChild("HumanoidRootPart")
        				local hum = char:FindFirstChild("Humanoid")
        				if not hrp or not hum or hum.Health <= 0 then 
							--
						else
        					if (root.Position - hrp.Position).Magnitude <= settings.arrestaura_radius then
            					task.spawn(function()
                					pcall(aremote.InvokeServer, aremote, plr)
            					end)
							end
						end
					end
				end
        	end
		end
    end
end)

----------------------------------------------------------------------------------------

function tpto(args)
    LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = args
end

function tptop(player)
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame
    else
        warn(player.Name.." has no character or HumanoidRootPart")
    end
end

----------------------------------------------------------------------------------------

-- Kill Feed
Killfeed.ChildAdded:Connect(function(newChild)
    if settings.killfeed then
	    print("New killfeed entry:", newChild.Name)
	    Notify(newChild.name, 1)
    end
end)

----------------------------------------------------------------------------------------

-- Anti tase fix
local normalWS = 25
local normalJP = 50

antivoid = true
task.spawn(function()
	while hbeat:Wait() do
		local char = LocalPlayer.Character
		if char and settings.antitase then
			local hum = char:FindFirstChildOfClass("Humanoid")
			if hum then
				if hum.WalkSpeed == 0 then
					hum.WalkSpeed = normalWS
				else
					normalWS = hum.WalkSpeed
				end
					
				if hum.JumpPower == 0 then
					hum.JumpPower = normalJP
				else
					normalJP = hum.JumpPower
				end
			end
		end

		-- sometimes you can fall under the map, and you can't escape bc of autorespawn unless you turn it off
		if antivoid then
			pcall(function()
        		if LocalPlayer.Character then
					if LocalPlayer.Character.HumanoidRootPart then
						if LocalPlayer.Character.HumanoidRootPart.Position.Y < -7 then
                    		LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(LocalPlayer.Character.HumanoidRootPart.Position.X,100,LocalPlayer.Character.HumanoidRootPart.Position.Z)
                    		LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(LocalPlayer.Character.HumanoidRootPart.Velocity.X,0,LocalPlayer.Character.HumanoidRootPart.Velocity.Z)
                		end
					end
            	end
			end)
        end

		if settings.speedc and settings.autosprint then settings.autosprint = false end

		if settings.autosprint then
			if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                if LocalPlayer.Character.Humanoid.WalkSpeed ~= 25 then
                	LocalPlayer.Character.Humanoid.WalkSpeed = 25
                end
            end
		end

		if settings.speedc then
			if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                if LocalPlayer.Character.Humanoid.WalkSpeed ~= settings.sval then
                	LocalPlayer.Character.Humanoid.WalkSpeed = settings.sval
                end
            end
		end
			
	end
end)

----------------------------------------------------------------------------------------

-- Hide trees
function htrees(ht)
	local trees = workspace:WaitForChild("Trees")
	local kids = trees:GetChildren()
	local preserve = kids[39] -- this is that tree that's used to get into the prison

	for i = #kids, 1, -1 do
    	local c = kids[i]
    	if c ~= preserve then
        	for _, descendant in ipairs(c:GetDescendants()) do
            	if descendant:IsA("BasePart") then
                	descendant.Transparency = ht and 1 or 0
                	descendant.CanCollide = not ht
                	descendant.CanQuery = not ht
                	descendant.CanTouch = not ht
            	end
        	end
    	end
	end
end

----------------------------------------------------------------------------------------

-- Enable reset button at all times
local function forceEnableReset()
    local success, err = pcall(function()
        StarterGui:SetCore("ResetButtonCallback", true)
    end)
    if not success then
        warn("Failed to enable reset button:", err)
    end
end

task.spawn(function()
    while task.wait(0) do
		if settings.enablere then
        	forceEnableReset()
		end
    end
end)

----------------------------------------------------------------------------------------

-- Toilet breaker
local hhe = false
function BreakAllToilets()
	local foundToilets = false
    
	for _, toilet in pairs(workspace:GetDescendants()) do
        if toilet.Name == "Toilet" and toilet:IsA("Model") then
            foundToilets = true
            for i = 1, 15 do
                meleeEvent:FireServer(toilet, 1)
            end
        end
	end
    
	return foundToilets
end

local function hammer_check_t()
    if not LocalPlayer.Character then return end
    
    local hrn = LocalPlayer.Character:FindFirstChild("Hammer") ~= nil
    
    if hrn and not hhe then
        BreakAllToilets()
    end
    
    hhe = hrn
end

----------------------------------------------------------------------------------------

-- Backpack checker
function CheckBackpack(cplr, player)
		if not cplr then
            warn("No player selected")
            return
        end
		Notify("Check /console!")
        print(player.." has the following items:")
              for _, tool in pairs(cplr.Backpack:GetChildren()) do
                print(tool.Name)
        end
end

----------------------------------------------------------------------------------------

gamepasses = {
	riots = {},
	mafias = {},
	snipers = {}
}

-- Gamepass checker
-- CHECK FOR RIOT
function CheckForRiot(gcplr, gcplrn)
	if not gcplr then
    	warn("No player selected")
    	return
    end
	local they_have_riot = false
    if string.match(game:HttpGet("https://inventory.roproxy.com/v1/users/" .. gcplr.UserId .. "/items/GamePass/" .. 643697197), 643697197) then
    	Notify(gcplrn.." has Riot Police Access (New)!")
		print(gcplrn .. " has Riot Police Access (New)!")
		if they_have_riot == false then
			they_have_riot = true
            if not table.find(gamepasses.riots, gcplrn) then
                table.insert(gamepasses.riots, gcplrn)
        	end
		end
	end

    if string.match(game:HttpGet("https://inventory.roproxy.com/v1/users/" .. gcplr.UserId .. "/items/GamePass/" .. 96651), 96651) then
        Notify(gcplrn.." has Riot Police Access (Legacy)!")
		print(gcplrn .. " has Riot Police Access (Legacy)!")
		if they_have_riot == false then
			they_have_riot = true
			if not table.find(gamepasses.riots, gcplrn) then
                table.insert(gamepasses.riots, gcplrn)
            end
		end
	end

	if they_have_riot == false then
        Notify(gcplrn..' does not have Riot Police Access!')
		print(gcplrn .. " does not have Riot Police Access!")
    end
end

-- CHECK FOR MAFIA
function CheckForMafia(gcplr, gcplrn)
	if not gcplr then
    	warn("No player selected")
    	return
    end
	local they_have_mafia = false
    if string.match(game:HttpGet("https://inventory.roproxy.com/v1/users/" .. gcplr.UserId .. "/items/GamePass/" .. 1443271), 1443271) then
    	Notify(gcplrn.." has the Mafia Pass!")
		print(gcplrn .. " has the Mafia Pass!")
		if they_have_mafia == false then
			they_have_mafia = true
            if not table.find(gamepasses.mafias, gcplrn) then
                table.insert(gamepasses.mafias, gcplrn)
        	end
		end
	end

	if they_have_mafia == false then
        Notify(gcplrn..' does not have the Mafia Pass!')
		print(gcplrn .. " does not have the Mafia Pass!")
    end
end

-- CHECK FOR SNIPER
function CheckForSniper(gcplr, gcplrn)
	if not gcplr then
    	warn("No player selected")
    	return
    end
	local they_have_sniper = false
    if string.match(game:HttpGet("https://inventory.roproxy.com/v1/users/" .. gcplr.UserId .. "/items/GamePass/" .. 699360089), 699360089) then
    	Notify(gcplrn.." has the Sniper Pass!")
		print(gcplrn .. " has the Sniper Pass!")
		if they_have_sniper == false then
			they_have_sniper = true
            if not table.find(gamepasses.snipers, gcplrn) then
                table.insert(gamepasses.snipers, gcplrn)
        	end
		end
	end

	if they_have_sniper == false then
        Notify(gcplrn..' does not have the Sniper Pass!')
		print(gcplrn .. " does not have the Sniper Pass!")
    end
end

local lcplayer = nil
local playerNames = {} -- store globally so builder() and Refresh can use it

-- Function to build the player name list
local function builder()
    playerNames = {} -- clear old list
    for _, plr in pairs(Players:GetPlayers()) do
        table.insert(playerNames, plr.Name)
    end
end

-- Build the initial list
builder()

local function fixTools()
    local char = LocalPlayer.Character
    if not char then return end

    local hum = char:FindFirstChild("Humanoid")
    if not hum then return end

    -- force unequip everything
    hum:UnequipTools()

    -- refresh backpack UI
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                tool.Enabled = true
            end
        end
    end

    -- re-enable client input properly
    local inputHandler = char:FindFirstChild("ClientInputHandler")
    if inputHandler then
        inputHandler.Disabled = false
    end
end

----------------------------------------------------------------------------------------

function die()
	Humanoid:ChangeState(Enum.HumanoidStateType.Dead)
end

function piss(wspeed, jpower)
	task.wait(3)
	LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed = wspeed -- W SPEED? :O
	LocalPlayer.Character:WaitForChild("Humanoid").JumpPower = jpower
end

fat = true
gwak = false

-- Anti Arrest and Anti Tase
LocalPlayer.CharacterAdded:Connect(function(char)
	local humanoid = char:WaitForChild("Humanoid")
	local animator = humanoid:WaitForChild("Animator")

	animator.AnimationPlayed:Connect(function(des)
		-- Anti Arrest
		if settings.antiarrest and des.Animation.AnimationId == "rbxassetid://287112271" then
			fat = false
		--	des:Stop()
		--	des:Destroy()
        --  StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true)

        --  local wspeed = normalWS
		--	local jpower = normalJP
			local Humanoid = LocalPlayer.Character:WaitForChild("Humanoid")
			Humanoid:ChangeState(Enum.HumanoidStateType.Dead)
				
			local cpos = char:WaitForChild("HumanoidRootPart").CFrame
			local wascriminal = (LocalPlayer.TeamColor.Name == "Really red")
				
			LocalPlayer.CharacterAdded:Wait()
			repeat task.wait() until LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
			task.wait(0.1)
			fat = true

			if wascriminal then
				if settings.autoguns then
					repeat task.wait() until gwak
				end
				SwitchToCriminalAndReturn(false, cpos) -- really slow
			elseif settings.autorespawn == false then
               -- tpto(cpos)
			end


			--task.delay(0, function()
			--	humanoid.WalkSpeed = wspeed
			--	humanoid.JumpPower = jpower
			-- end) ]]
		end

		-- Anti Tase
		if settings.antitase and des.Animation.AnimationId == "rbxassetid://279227693" then
			local nbgui = LocalPlayer.PlayerGui.Home.hud.BackpackUI
			des:Stop()
			des:Destroy()
			LocalPlayer.Character.Humanoid.PlatformStand = false
            LocalPlayer.Character.Humanoid.Sit = false
            nbgui.Visible = true
			local wspeed = normalWS
			local jpower = normalJP
			hbeat:Wait()
			humanoid.WalkSpeed = wspeed
			humanoid.JumpPower = jpower
			fixTools()
			piss(wspeed, jpower)
			task.delay(0.2, fixTools)
		end
	end)
end)

----------------------------------------------------------------------------------------

local TELEPORT_COOLDOWN = 6 -- shame
local TELEPORT_COOLDOWN2 = 12.5 -- shame
local lastTeleport = 0

-- teleport time check
local function canTeleport()
    local now = tick()
    local delta = now - lastTeleport
    if delta < TELEPORT_COOLDOWN then
        local remaining = TELEPORT_COOLDOWN - delta
        Notify("Wait " .. string.format("%.1f", remaining) .. "s before teleporting again.")
        return false
    end
    lastTeleport = now
    return true
end

-- Cooldown tracking
if not _G.TeamCooldown then
    _G.TeamCooldown = 0
end

-- Quick respawn tracking
if not _G.CanQuickRespawn then
    _G.CanQuickRespawn = true
end
local cd_dur = 10
local coolingdown = false

function _G.ResetCooldown()
	if not coolingdown then
		coolingdown = true
		_G.CanQuickRespawn = false
		task.wait(cd_dur)
		_G.CanQuickRespawn = true
		coolingdown = false
	end
end

-- Store last death position and camera
local lastDeathCFrame = nil
local lastCameraCFrame = nil

-- Helper to teleport player
local function Teleport(TargetCFrame, Character)
    if not Character then Character = LocalPlayer.Character end
    if not Character then return end
    local RootPart = Character:WaitForChild("HumanoidRootPart")
    RootPart.CFrame = TargetCFrame
    --print("Teleport Success!")
end

-- Check if team can be switched (cooldown)
local function CanSwitchTeam()
    local now = os.time()
    if now < _G.TeamCooldown then
        local remaining = _G.TeamCooldown - now
        Notify("You will be able to switch teams in " .. remaining .. " seconds!")
        return false
    end
    return true
end

-- Core team switch logic
local function SetTeam(targetTeam, skipCooldownCheck)
    -- Skip cooldown if switching to Criminals
    if targetTeam == Teams.Criminals then
        skipCooldownCheck = true
    end

    -- Only respect cooldown for manual switches
    if not skipCooldownCheck then
        if not CanSwitchTeam() then return end
    end

    local current = LocalPlayer.Team

	local function switch(team)
    	repeat
			if TeamEvent then
				TeamEvent:InvokeServer(team)
			end
        	task.wait(0.2)
    	until LocalPlayer.Team == team
	end

	local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:WaitForChild("HumanoidRootPart")
	local ocf = hrp.CFrame 
	
    if current == Teams.Inmates then
        if targetTeam == Teams.Guards then
            switch(Teams.Neutral)
            switch(Teams.Guards)
			tpto(ocf)
        elseif targetTeam == Teams.Criminals then
            SwitchToCriminalAndReturn(false, ocf)
        end
    elseif current == Teams.Guards then
        if targetTeam == Teams.Inmates then
            switch(Teams.Neutral)
            switch(Teams.Inmates)
			tpto(ocf)
        elseif targetTeam == Teams.Criminals then
            switch(Teams.Neutral)
            switch(Teams.Inmates)
			fixcam()
			SwitchToCriminalAndReturn(false, ocf)
        end
    elseif current == Teams.Criminals then
        if targetTeam == Teams.Inmates then
            switch(Teams.Neutral)
            switch(Teams.Inmates)
			tpto(ocf)
        elseif targetTeam == Teams.Guards then
            switch(Teams.Neutral)
            switch(Teams.Guards)
			tpto(ocf)
        end
    elseif current == Teams.Neutral then
        switch(targetTeam) -- ??
    end

    -- Apply cooldown for non-criminal switches
    if targetTeam ~= Teams.Criminals and (targetTeam == Teams.Inmates or targetTeam == Teams.Guards) then
        _G.TeamCooldown = os.time() + 10
        task.spawn(_G.ResetCooldown)
    end

    fixcam()
end

local function ChangeTeam(targetTeam)
    SetTeam(targetTeam)
    task.spawn(_G.ResetCooldown)
end

-- Auto respawn handling
LocalPlayer.CharacterAdded:Connect(function(char)
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")

    -- Teleport to last stored position if it exists
    if lastDeathCFrame then
		if settings.autoguns then
			-- print("nasser balls")
		else
			if settings.autorespawn then
				if fat or LocalPlayer.Team.Name == "Criminals" then 
					task.wait(TELEPORT_COOLDOWN2) 
				else 
					task.wait(TELEPORT_COOLDOWN)
				end
				hrp.CFrame = lastDeathCFrame
			end
		end
    end

    hum.Died:Connect(function()
        if settings.autorespawn == false then return end

        if hrp then
            lastDeathCFrame = hrp.CFrame
        end

		if TeamEvent then
        if _G.CanQuickRespawn and os.time() >= _G.TeamCooldown then
            _G.CanQuickRespawn = false
            task.spawn(function()
                local currentTeam = LocalPlayer.Team
                if currentTeam == Teams.Inmates then
                    repeat task.wait() 
                        TeamEvent:InvokeServer(Teams.Neutral)
                    until LocalPlayer.Team == Teams.Neutral

                    repeat task.wait() 
                        TeamEvent:InvokeServer(Teams.Inmates)
                    until LocalPlayer.Team == Teams.Inmates
                    fixcam()
                elseif currentTeam == Teams.Guards then
                    repeat task.wait() 
                        TeamEvent:InvokeServer(Teams.Neutral)
                    until LocalPlayer.Team == Teams.Neutral

                    repeat task.wait() 
                        TeamEvent:InvokeServer(Teams.Guards)
                    until LocalPlayer.Team == Teams.Guards
                    fixcam()
                elseif currentTeam == Teams.Criminals then
                    Notify("Quick respawn is not available for criminals!") -- the process would be too slow, faster to just wait
					tring = false
    				fugging = false
                end
                _G.CanQuickRespawn = true
            end)
        end

		if LocalPlayer.Team == Teams.Criminals then 
			tring = false 
			fugging = false
		end
		end
    end)
end)

----------------------------------------------------------------------------------------

local UIS = game:GetService("UserInputService")

UIS.InputBegan:Connect(function(input, gp)
    if gp then return end -- ignore typing in chat

    if input.KeyCode == Enum.KeyCode.P then
        if canTeleport() then
            teleportTo("nexus")
        end

    elseif input.KeyCode == Enum.KeyCode.L then
        if canTeleport() then
            teleportTo("criminal_base")
        end

    elseif input.KeyCode == Enum.KeyCode.RightShift then
        getgenv().aimlock.Aimbot = not getgenv().aimlock.Aimbot

    elseif input.KeyCode == Enum.KeyCode.RightControl then
        getgenv().espsettings.ESP = not getgenv().espsettings.ESP
    end
end)

----------------------------------------------------------------------------------------

local Doors = workspace:FindFirstChild("Doors")
local CellDoors = workspace:FindFirstChild("CellDoors")

-- Transparent doors
function tdoors()
	for i,v in pairs(Doors:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Transparency = 0.6
        end
    end
	
    for i,v in pairs(CellDoors:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Transparency = 0.6 
        end
    end
end

-- Untransparent doors
function untdoors()
	for i,v in pairs(Doors:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Transparency = 0
        end
    end
	
    for i,v in pairs(CellDoors:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Transparency = 0
        end
    end
end

-- Remove collision of doors
function NoDoors()
    for i,v in pairs(Doors:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanCollide = false
        end
    end
	
    for i,v in pairs(CellDoors:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanCollide = false
        end
    end
end

-- Add collision of doors
function AddDoors()
    for i,v in pairs(Doors:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanCollide = true
        end
    end
	
    for i,v in pairs(CellDoors:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanCollide = true
        end
    end
end

-- DESTROY doors
function DestroyDoors()
    for i,v in pairs(Doors:GetDescendants()) do
        if v:IsA("BasePart") then
            v:Destroy()
        end
    end
	
    for i,v in pairs(CellDoors:GetDescendants()) do
        if v:IsA("BasePart") then
            v:Destroy()
        end
    end
end

----------------------------------------------------------------------------------------

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
	task.wait(0)
    if settings.ijump then
        game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass('Humanoid'):ChangeState("Jumping")
    end
end)

----------------------------------------------------------------------------------------

-- Noclip
local Noclipping = nil

function noclip()
	Clip = false; task.wait(0.1)
	local function NoclipLoop()
		CharacterCollision.Enabled = false
		if Clip == false and LocalPlayer.Character ~= nil then
			for _, child in pairs(LocalPlayer.Character:GetDescendants()) do
				if child:IsA("BasePart") and child.CanCollide == true and child.Name ~= floatName then
					child.CanCollide = false
				end
			end
		end
	end
	Noclipping = RunService.Stepped:Connect(NoclipLoop)
end

function clip()
	if Noclipping then
		Noclipping:Disconnect()
	end
	Clip = true
	CharacterCollision.Enabled = true
end

function getRoot(char)
	local rootPart = char:FindFirstChild('HumanoidRootPart') or char:FindFirstChild('Torso') or char:FindFirstChild('UpperTorso')
	return rootPart
end

----------------------------------------------------------------------------------------

-- Spin
function spin(spinSpeed)
		for i,v in pairs(getRoot(LocalPlayer.Character):GetChildren()) do
			if v.Name == "Spinning" then
				v:Destroy()
			end
		end
		local Spin = Instance.new("BodyAngularVelocity")
		Spin.Name = "Spinning"
		Spin.Parent = getRoot(LocalPlayer.Character)
		Spin.MaxTorque = Vector3.new(0, math.huge, 0)
		Spin.AngularVelocity = Vector3.new(0,spinSpeed,0)
end

----------------------------------------------------------------------------------------

-- Snack Noclip (based off hmza's)
local lastMoveTime = 0
local lastJumpTime = 0
local isOnCooldown = false
local gchr = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local ghum = gchr:WaitForChild("Humanoid")

local snacks = {"Chips", "Chocolate", "Soda"}
local function isHoldingSnack()
    local tool = gchr:FindFirstChildOfClass("Tool")
    return tool and table.find(snacks, tool.Name) ~= nil
end

local function temporaryNoClip(duration)
    for _, part in pairs(gchr:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
    task.wait(duration)
    for _, part in pairs(gchr:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = true
        end
    end
end

UserInputService.JumpRequest:Connect(function()
    lastJumpTime = tick()
end)

RunService.RenderStepped:Connect(function()
	if not settings.ncglitch then return end
    if not isHoldingSnack() then return end
    if isOnCooldown then return end
	if CharacterCollision.Enabled == true then CharacterCollision.Enabled = false end

    local moveMagnitude = ghum.MoveDirection.Magnitude
    if moveMagnitude > 0 then
        lastMoveTime = tick()
    end

    if tick() - lastMoveTime < 0.6 and tick() - lastJumpTime < 0.6 then
        isOnCooldown = true

        task.spawn(function()
            temporaryNoClip(1.6)
            task.wait(0.2)
            isOnCooldown = false
        end)
    end
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    gchr = char
    ghum = char:WaitForChild("Humanoid")
--    grp = char:WaitForChild("HumanoidRootPart")
end)

----------------------------------------------------------------------------------------

-- Spam Open Doors
local Keycard = Character:FindFirstChild("Key card")
local kcopener = Character["Right Arm"]

local function touch(hb)
    firetouchinterest(kcopener, hb, 0)
    firetouchinterest(kcopener, hb, 1)
end

game:GetService("RunService").Heartbeat:Connect(function()
	--[[ if settings.sodoors then
    	if Character.Humanoid.Health > 0 then
        	for i, v in pairs(Doors:GetDescendants()) do
            	if v.Name == "hitbox" then
                	task.spawn(touch, v)
            	end
        	end
		end
    end ]]

	if settings.abtoilets then
		hammer_check_t()
	end
end)

-- stop fence top killing you
function ukfence()
	for _, fence in pairs(workspace.Prison_Fences:GetDescendants()) do
    	local damagePart = fence:FindFirstChild("damagePart")
    	if damagePart then
        	for _, child in pairs(damagePart:GetChildren()) do
            	if child:IsA("TouchTransmitter") then
                	child:Destroy()
            	end
        	end
    	end
	end
end

----------------------------------------------------------------------------------------

-- Anti-jump removal (jump cooldown removal)
function ajr()
	local aj = LocalPlayer.Character:FindFirstChild("AntiJump")
	if aj and aj:IsA("LocalScript") then
   		pcall(function()
        	aj:Destroy()
    	end)
	end
end

local tring = false
local hrp = nil

-- When the character spawns
LocalPlayer.CharacterAdded:Connect(function(char)
    hrp = char:WaitForChild("HumanoidRootPart")
	--if LocalPlayer.Team ~= Teams.Neutral then
    	tring = false -- reset AutoGuns state
		gwak = false
	--end

	lst = os.clock()
	-- removal of anti-jump
	if settings.aajr then
		ajr()
	end
end)

----------------------------------------------------------------------------------------

-- no doors, auto gun
AUTOGUN_DELAY_AFTER_SPAWN = 10
RunService.Heartbeat:Connect(function()
    if not hrp then return end -- wait until HumanoidRootPart exists
    -- No doors
    if settings.nodoors then
        NoDoors()
    end

	if settings.tdoors then
		tdoors()
	end

	if os.clock() - lst < AUTOGUN_DELAY_AFTER_SPAWN then
        return
    end
		
    -- Auto guns
    if settings.autoguns and tring == false then
		--print("tell me this fixed it pluh")
		tring = true
		--task.wait(TELEPORT_COOLDOWN)

        local localOldHRP = hrp.CFrame
        local pickedGuns = 0

        for _, gunName in ipairs(settings.autoguns_list) do
            if (gunName == "M4A1" and not riot_pass) or (gunName == "FAL" and not mafia_pass) or (gunName == "M700" and not sniper_pass) or (gunName == "Revolver" and not sniper_pass) then
                -- skip guns you don't have access to
            else
                if not GetTool(gunName) then
                    GetGun(gunName)
                    pickedGuns = pickedGuns + 1
                end
            end
        end

        -- Teleport back once after picking up guns
		if settings.autorespawn == false then
        	if pickedGuns > 0 then
            	tpto(localOldHRP)
        	end
		else
			if pickedGuns > 0 then
            	hrp.CFrame = lastDeathCFrame
			end
		end

       gwak = true
    end
end)

----------------------------------------------------------------------------------------

-- fake keycard grabber
local RETRY_DELAY = 0.3
local running = false

local function getToolFromRS()
    local toolsFolder = ReplicatedStorage:FindFirstChild("Tools")
    if not toolsFolder then return end

    return toolsFolder:FindFirstChild("Key card", true)
end

local function getToolFromPlayers()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local backpack = player:FindFirstChild("Backpack")
            local tool = backpack and backpack:FindFirstChild("Key card")
            if tool then
                return tool
            end
        end
    end
end

local function tryGiveTool()
    local backpack = LocalPlayer:WaitForChild("Backpack")

    if backpack:FindFirstChild("Key card") then
        return true
    end

	if LocalPlayer.Team.Name == "Guards" then
		return true
	end
	
    local source = getToolFromRS() or getToolFromPlayers()
    if source then
        source:Clone().Parent = backpack
        return true
    end
end

local function start()
    if running then return end
    running = true

    task.spawn(function()
        while running do
            pcall(tryGiveTool)
            task.wait(RETRY_DELAY)
        end
    end)
end

LocalPlayer.CharacterAdded:Connect(function()
    running = false
    task.wait(0.5)
	if settings.akeycard then
    	start()
	end
end)

start()

----------------------------------------------------------------------------------------

-- old gun sounds
local player = Players.LocalPlayer
local hookedTools = {}

local tools = {
    ["M4A1"] = {
        ReloadSound = "rbxassetid://142491708",
        ShootSound   = "rbxassetid://150544849"
    },
    ["AK-47"] = {
        ReloadSound = "rbxassetid://142491708",
        ShootSound   = "rbxassetid://153230498"
    },
    ["M9"] = {
        ReloadSound = "rbxassetid://138084889",
        ShootSound   = "rbxassetid://134436500"
    },
    ["Remington 870"] = {
        ReloadSound = "rbxassetid://145081845",
        ShootSound   = "rbxassetid://138083993"
    },
    ["M700"] = {
        ReloadSound = "rbxassetid://97852355",
        ShootSound   = "rbxassetid://406722373"
    },
    ["MP5"] = {
        ReloadSound = "rbxassetid://142491708",
		ShootSound = "rbxassetid://10209859",
    },
    ["FAL"] = {
        ReloadSound = "rbxassetid://142491708",
    },
}

local function applySounds(tool)
	if not settings.oldsounds then return end
	if settings.oldsoundsmeonly and tool.Parent ~= LocalPlayer.Character then return end
	
	for soundName, id in pairs(tools[tool.Name] or {}) do
		for _, obj in ipairs(tool:GetDescendants()) do
			if obj:IsA("Sound") and obj.Name == soundName then
				obj.SoundId = id
			end
		end
	end
end

local function hookTool(tool)
	if not tools[tool.Name] then return end
	
	applySounds(tool)

	tool.DescendantAdded:Connect(function(obj)
		if obj:IsA("Sound") then
			local id = tools[tool.Name][obj.Name]
			if id then
				obj.SoundId = id
			end
		end
	end)
end

local function hookCharacter(char)
	char.ChildAdded:Connect(function(child)
		if child:IsA("Tool") then
			hookTool(child)
		end
	end)

	for _, child in ipairs(char:GetChildren()) do
		if child:IsA("Tool") then
			hookTool(child)
		end
	end
end

for _, plr in ipairs(Players:GetPlayers()) do
	if plr.Character then
		hookCharacter(plr.Character)
	end
	
	plr.CharacterAdded:Connect(hookCharacter)
end

Players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(hookCharacter)
end)

----------------------------------------------------------------------------------------

-- trespassing/hostile player printer
local lastState = {}

local function monitor(plr)
    local function track(char)
        lastState[plr] = {
            Trespassing = false,
            Hostile = false
        }

        while char.Parent do
            task.wait(0.2)

            local tres = char:GetAttribute("Trespassing")
            local hostile = char:GetAttribute("Hostile")

            if plr.Team and plr.Team.Name:lower():find("inmate") then
                if tres and not lastState[plr].Trespassing then
					if settings.htdetect then
                    	print(plr.Name .. " is TRESPASSING!")
				    	Notify(plr.Name .. " is TRESPASSING!")
					end
                end

                if hostile and not lastState[plr].Hostile then
					if settings.htdetect then
                    	print(plr.Name .. " is HOSTILE!")
						Notify(plr.Name .. " is HOSTILE!")
					end
                end
            end

            lastState[plr].Trespassing = tres
            lastState[plr].Hostile = hostile
        end
    end

    plr.CharacterAdded:Connect(track)

    if plr.Character then
        task.spawn(track, plr.Character)
    end
end

for _, plr in pairs(Players:GetPlayers()) do
    monitor(plr)
end

Players.PlayerAdded:Connect(monitor)

----------------------------------------------------------------------------------------

-- Command list
local function handleCommand(msg)
    local lowerMsg = msg:lower()
	
	if lowerMsg == prefix.."lc" or lowerMsg == prefix.."location" or lowerMsg == prefix.."pgoto" then
		local parts = lowerMsg:split(" ")
        local ln = table.concat(parts, " ", 2)
		if not ln then Notify("Enter a location.") return end

		cln = ln:lower():gsub("%s+", " "):gsub("^%s*(.-)%s*$", "%1")
        local teleportId = TeleportAliases[cln] or cln:gsub(" ", "_")
        if not Teleports[teleportId] then Notify("Invalid location: " .. ln) return end
		
    	if canTeleport() then
			teleportTo(teleportId)
		end
    end

	if lowerMsg:sub(1, #prefix + 3) == prefix.."gun" then
    	local parts = lowerMsg:split(" ")
    	local gun = parts[2]

   	 	if not gun then Notify("Enter a gun name.") return end

    	local ggun = gunAliases[input] or input:upper()
    	if not table.find(allGuns, ggun) then Notify("Invalid gun: " .. gun) return end

    	local char = LocalPlayer.Character; if not char then return end
		local hrp = char:WaitForChild("HumanoidRootPart"); local oldhrp = hrp.CFrame

    	GetGun(ggun)
		hrp.CFrame = oldhrp
	end

    if lowerMsg == prefix.."guns" or lowerMsg == prefix.."allguns" then
        GrabGuns(allGuns)
        return
    end

	if string.sub(lowerMsg, 1, #prefix + 4) == prefix.."aawl" then
    	local parts = lowerMsg:split(" ")
    	local targetName = parts[2]
    	if targetName then
        	local player = PLAYERCHECK(targetName, true)
        	if player then
            	if not table.find(aa_wl, player.Name) then
                	table.insert(aa_wl, player.Name)
                	Notify(player.Name.." added to Arrest Aura Whitelist.")
					print(player.Name.." added to Arrest Aura Whitelist.")
            	else
                	Notify(player.Name.." is already whitelisted.")
					print(player.Name.." is already whitelisted.")
            	end
        	else
            	Notify("Player not found:", targetName)
        	end
    	else
        	Notify("No player specified.")
   	 	end
	end

	if string.sub(lowerMsg, 1, #prefix + 6) == prefix.."unaawl" then
    	local parts = lowerMsg:split(" ")
    	local targetName = parts[2]
    	if targetName then
        	local player = PLAYERCHECK(targetName, true)
        	if player then
            	local index = table.find(aa_wl, player.Name)
            	if index then
                	table.remove(aa_wl, index)
                	Notify(player.Name.." removed from Arrest Aura whitelist.")
					print(player.Name.." removed from Arrest Aura whitelist.")
            	else
                	Notify(player.Name.." is not in the whitelist.")
					print(player.Name.." is not in the whitelist.")
            	end
        	else
            	Notify("Player not found:", targetName)
        	end
    	else
        	Notify("No player specified.")
   	 	end
	end


	if string.sub(lowerMsg, 1, #prefix + 4) == prefix.."kawl" then
    	local parts = lowerMsg:split(" ")
    	local targetName = parts[2]
    	if targetName then
        	local player = PLAYERCHECK(targetName, true)
        	if player then
            	if not table.find(ka_wl, player.Name) then
                	table.insert(ka_wl, player.Name)
                	Notify(player.Name.." added to Kill Aura Whitelist.")
					print(player.Name.." added to Kill Aura Whitelist.")
            	else
                	Notify(player.Name.." is already whitelisted.")
					print(player.Name.." is already whitelisted.")
            	end
        	else
            	Notify("Player not found:", targetName)
        	end
    	else
        	Notify("No player specified.")
   	 	end
	end

	if string.sub(lowerMsg, 1, #prefix + 6) == prefix.."unkawl" then
    	local parts = lowerMsg:split(" ")
    	local targetName = parts[2]
    	if targetName then
        	local player = PLAYERCHECK(targetName, true)
        	if player then
            	local index = table.find(ka_wl, player.Name)
            	if index then
                	table.remove(ka_wl, index)
                	Notify(player.Name.." removed from Kill Aura whitelist.")
					print(player.Name.." removed from Kill Aura Whitelist.")
            	else
                	Notify(player.Name.." is not in the whitelist.")
				    print(player.Name.." is not in the whitelist.")
            	end
        	else
            	Notify("Player not found:", targetName)
        	end
    	else
        	Notify("No player specified.")
   	 	end
	end
	
	if string.sub(lowerMsg, 1, #prefix + 4) == prefix.."team" then
    	local parts = lowerMsg:split(" ")
    	local teamArg = parts[2]
    	if not teamArg then return end

    	if teamArg == "criminals" or teamArg == "crims" or teamArg == "crim" or teamArg == "criminal" then
        	ChangeTeam(Teams.Criminals)
    	elseif teamArg == "inmates" or teamArg == "inmate" or teamArg == "prisoner" or teamArg == "prisoners" then
        	ChangeTeam(Teams.Inmates)
    	elseif teamArg == "guards" or teamArg == "guard" then
        	if #Teams.Guards:GetPlayers() > 7 then
            	Notify("The team is full, cannot join!")
        	else
            	ChangeTeam(Teams.Guards)
        	end
    	else
        	Notify("Unknown team:", teamArg)
    	end
	end

    if string.sub(lowerMsg, 1, #prefix + 2) == prefix.."iy" then
        loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
    end

    if string.sub(lowerMsg, 1, #prefix + 8) == prefix.."killfeed" then
        settings.killfeed = true
        Notify("Enabled Kill Feed.")
    end

    if string.sub(lowerMsg, 1, #prefix + 10) == prefix.."unkillfeed" then
        settings.killfeed = false
        Notify("Disabled Kill Feed.")
    end

	if string.sub(lowerMsg, 1, #prefix + 8) == prefix.."htdetect" then
        settings.htdetect = true
        Notify("Enabled Hostile/Trespassing Feed.")
    end

    if string.sub(lowerMsg, 1, #prefix + 10) == prefix.."unhtdetect" then
        settings.htdetect = false
        Notify("Disabled Hostile/Trespassing Feed.")
    end

    if string.sub(lowerMsg, 1, #prefix + 6) == prefix.."antiar" then
        settings.antiarrest = true
        Notify("Enabled anti-arrest.")
    end

    if string.sub(lowerMsg, 1, #prefix + 8) == prefix.."unantiar" then
        settings.antiarrest = false
        Notify("Disabled anti-arrest.")
    end

    if string.sub(lowerMsg, 1, #prefix + 8) == prefix.."antitase" then
        settings.antitase = true
        Notify("Enabled anti-tase.")
    end

    if string.sub(lowerMsg, 1, #prefix + 10) == prefix.."unantitase" then
        settings.antitase = false
        Notify("Disabled anti-tase.")
    end

	if string.sub(lowerMsg, 1, #prefix + 8) == prefix.."killaura" then
        settings.killaura = true
        Notify("Enabled killaura.")
    end

    if string.sub(lowerMsg, 1, #prefix + 10) == prefix.."unkillaura" then
        settings.killaura = false
        Notify("Disabled killaura.")
    end

	if string.sub(lowerMsg, 1, #prefix + 6) == prefix.."araura" then
        settings.arrestaura = true
        Notify("Enabled arrestaura - make sure you are on the Guards Team!")
    end

    if string.sub(lowerMsg, 1, #prefix + 8) == prefix.."unaraura" then
        settings.arrestaura = false
        Notify("Disabled arrestaura.")
    end

	if string.sub(lowerMsg, 1, #prefix + 8) == prefix.."kasphere" then
        settings.killaura_sphere = true
        Notify("Kill aura sphere visible.")
    end

    if string.sub(lowerMsg, 1, #prefix + 10) == prefix.."unkasphere" then
        settings.killaura_sphere = false
        Notify("Kill aura sphere invisible.")
    end

    if string.sub(lowerMsg, 1, #prefix + 6) == prefix.."autore" then
        settings.autorespawn = true
        Notify("Enabled auto-respawn.")
    end

    if string.sub(lowerMsg, 1, #prefix + 8) == prefix.."unautore" then
        settings.autorespawn = false
        Notify("Disabled auto-respawn.")
    end

	if string.sub(lowerMsg, 1, #prefix + 8) == prefix.."fastguns" then
        settings.auto_fg = true
		Notify("Your guns will now have fast fire-rate.")
    end

	if string.sub(lowerMsg, 1, #prefix + 10) == prefix.."unfastguns" then
        settings.auto_fg = false
		Notify("Your guns will no longer have fast fire-rate.")
    end

	if string.sub(lowerMsg, 1, #prefix + 8) == prefix.."firerate" then
		local parts = lowerMsg:split(" ")
		settings.auto_fgrate = tonumber(parts[2])
		Notify("Firerate of all your guns will now be "..settings.auto_fgrate..".")
	end

	if string.sub(lowerMsg, 1, #prefix + 8) == prefix.."karadius" then
		local parts = lowerMsg:split(" ")
		settings.killaura_radius = tonumber(parts[2])
		Notify("Kill aura will now have radius "..settings.killaura_radius..".")
	end

	if string.sub(lowerMsg, 1, #prefix + 8) == prefix.."aaradius" then
		local parts = lowerMsg:split(" ")
		settings.arrestaura_radius = tonumber(parts[2])
		Notify("Arrest aura will now have radius "..settings.arrestaura_radius..".")
	end

    if string.sub(lowerMsg, 1, #prefix + 3) == prefix.."pkf" then
        for i, v in ipairs(Killfeed:GetChildren()) do
	        print(v.Name)
        end
        Notify("Printed Kill Feed to /console.")
    end

    if string.sub(lowerMsg, 1, #prefix + 7) == prefix.."nodoors" then
    	settings.nodoors = true
		Notify("Removed collision of doors.")
	end

	if string.sub(lowerMsg, 1, #prefix + 8) == prefix.."adddoors" then
    	settings.nodoors = false
		Notify("Added collision of doors.")
		AddDoors()
	end

	if string.sub(lowerMsg, 1, #prefix + 5) == prefix.."ddoors" then
    	DestroyDoors()
		Notify("Destroyed doors.")
	end
	

--[[    if string.sub(lowerMsg, 1, #prefix + 7) == prefix.."sodoors" then
    	settings.sodoors = true
		Notify("Spam opening doors (MUST BE A GUARD/HAVE A KEYCARD).")
	end

	if string.sub(lowerMsg, 1, #prefix + 9) == prefix.."unsodoors" then
    	settings.sodoors = false
		Notify("No longer spam opening doors.")
	end ]]

	if string.sub(lowerMsg, 1, #prefix + 8) == prefix.."btoilets" then
		hammer_check_t()
		Notify("Toilets broken (assuming you had a hammer equipped).")
	end

	if string.sub(lowerMsg, 1, #prefix + 3) == prefix.."rjc" then
		ajr()
		Notify("Jump cooldown removed!")
	end

	if string.sub(lowerMsg, 1, #prefix + 4) == prefix.."aajr" then
		settings.aajr = true
		Notify("Jump cooldown will be removed every time you respawn!")
	end

	if string.sub(lowerMsg, 1, #prefix + 6) == prefix.."unaajr" then
		settings.aajr = false
		Notify("Disabled!")
	end

	if string.sub(lowerMsg, 1, #prefix + 7) == prefix.."nkfence" then
		ukfence()
		Notify("The top of fences will no longer kill you!")
	end

	if string.sub(lowerMsg, 1, #prefix + 7) == prefix.."dfences" then
	 	pcall(function()
       		for i, v in pairs(game.Workspace["Prison_Fences"]:GetChildren()) do
				if v.Name == "fence" then
					v:Destroy()
				end
			end
			Notify("Fences destroyed!")
		end)
	end

	if string.sub(lowerMsg, 1, #prefix + 7) == prefix.."dfences" then
	 	pcall(function()
			game.Workspace["Prison_Fences"]["Prison_Gate"]:Destroy()
			game.Workspace["Prison_Fences"]["gate"]:Destroy()
			Notify("Gates destroyed!")
		end)
	end

	if string.sub(lowerMsg, 1, #prefix + 9) == prefix.."abtoilets" then
    	settings.abtoilets = true
		Notify("Auto breaking toilets (have hammer equipped for this to work).")
	end

	if string.sub(lowerMsg, 1, #prefix + 11) == prefix.."unabtoilets" then
    	settings.abtoilets = false
		Notify("No longer auto breaking toilets.")
	end

	if string.sub(lowerMsg, 1, #prefix + 6) == prefix.."htrees" then
    	settings.htrees = true
		htrees(settings.htrees)
		Notify("Trees hidden.")
	end

	if string.sub(lowerMsg, 1, #prefix + 6) == prefix.."strees" then
    	settings.htrees = false
		htrees(settings.htrees)
		Notify("Trees unhidden.")
	end
	
	if string.sub(lowerMsg, 1, #prefix + 8) == prefix.."autoguns" then
    	settings.autoguns = true
		Notify("Guns auto given.")
	end

	if string.sub(lowerMsg, 1, #prefix + 10) == prefix.."unautoguns" then
    	settings.autoguns = false
		Notify("Guns no longer auto given.")
	end

	if string.sub(lowerMsg, 1, #prefix + 3) == prefix.."esp" then
		getgenv().esp = true
	end

	if string.sub(lowerMsg, 1, #prefix + 5) == prefix.."unesp" then
		getgenv().esp = false
	end
	
	if string.sub(lowerMsg, 1, #prefix + 8) == prefix.."enablere" then
    	settings.enablere = true
		Notify("The reset button will no longer get disabled when you get tased!")
	end

	if string.sub(lowerMsg, 1, #prefix + 9) == prefix.."disablere" then
    	settings.enablere = false
		Notify("Disabled!")
	end
	
end

game:GetService("TextChatService").MessageReceived:Connect(function(tbl)
    if not tbl.TextSource then return end
    local player = Players:GetPlayerByUserId(tbl.TextSource.UserId)
    if not player or player ~= LocalPlayer then return end

    handleCommand(tbl.Text)
end)

--local Humanoid = LocalPlayer.Character:WaitForChild("Humanoid")
--Humanoid:ChangeState(Enum.HumanoidStateType.Dead)

-- remove new backpack (unused)
--[[ game:GetService("Players").LocalPlayer.PlayerGui.Home.hud.BackpackUI:Destroy()
game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true) ]] 

-- remove old backpack
game:GetService("RunService").RenderStepped:Connect(function()
    game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
end)


-- GUI --
MainTab:CreateSection("Reminder: ONLY USE YOUR ALT TO EXPLOIT.")

-- Main Tab --
-- Team Management --
MainTab:CreateSection("Team Management")

MainTab:CreateButton({
    Name = "Switch to Inmates",
    Callback = function()
        ChangeTeam(Teams.Inmates)
        Notify("You will regret that.", 999)
    end,
})

MainTab:CreateButton({
    Name = "Switch to Guards",
    Callback = function()
        if #Teams.Guards:GetPlayers() > 7 then
            Notify("The team is full, cannot join!")
        else
            ChangeTeam(Teams.Guards)
            Notify("You will regret that.", 999)
        end
    end,
})

MainTab:CreateButton({
    Name = "Switch to Criminals",
    Callback = function()
        ChangeTeam(Teams.Criminals)
        Notify("You will regret that.", 999)
    end,
})

-- Weapon Management --
MainTab:CreateSection("Weapon Management")

ggun = nil
MainTab:CreateDropdown({
    Name = "Get Specific Gun",
    Options = allGuns,
    Flag = "GunDropdown",
    Callback = function(Option)
		ggun = Option[1]
    end,
})

MainTab:CreateButton({
    Name = "Go",
    Callback = function()
		local hrp = LocalPlayer.Character:WaitForChild("HumanoidRootPart")
		oldhrp = hrp.CFrame
        local gun = ggun
        --print(gun)
        GetGun(gun)
		hrp.CFrame = oldhrp
	end,
})

MainTab:CreateButton({
    Name = "Get All Guns",
    Callback = function()
		local hrp = LocalPlayer.Character:WaitForChild("HumanoidRootPart")
		oldhrp = hrp.CFrame
		for i, v in allGuns do
		--	print(v)
			if (v == "M4A1" and riot_pass == false) or (v == "FAL" and mafia_pass == false) or (v == "M700" and not sniper_pass) or (v == "Revolver" and not sniper_pass) then 
			else
				if not GetTool(v) then
        			GetGun(v)
    			end
			end
		end
		hrp.CFrame = oldhrp
    end,
})

-- Combat Tab --
-- Aura Settings --
CombatTab:CreateSection("Aura Settings")
CombatTab:CreateSection("Kill Aura")

CombatTab:CreateToggle({
    Name = "Kill Aura",
    CurrentValue = settings.killaura,
    Flag = "KillAuraToggle",
    Callback = function(Value)
        settings.killaura = Value
    end,
})

CombatTab:CreateToggle({
    Name = "Kill Aura Sphere",
    CurrentValue = settings.killaura_sphere,
    Flag = "KASphereToggle",
    Callback = function(Value)
        settings.killaura_sphere = Value
    end,
})

CombatTab:CreateSlider({
    Name = "Kill Aura Radius",
    Range = {1, 10},
    Increment = 1,
    Suffix = "studs",
    CurrentValue = settings.killaura_radius,
    Flag = "KARadiusSlider",
    Callback = function(Value)
        settings.killaura_radius = Value
    end,
})

CombatTab:CreateToggle({
    Name = "Team Check",
    CurrentValue = settings.katc,
    Flag = "KillAuraTCToggle",
    Callback = function(Value)
        settings.katc = Value
    end,
})

CombatTab:CreateDropdown({
    Name = "Teams Allowed",
    Options = katypes,
    CurrentValue = settings.katype,
    Flag = "KillAuraTeamDropdown",
    Callback = function(Option)
		opt = Option[1]
        UpdateKillableTeams(opt)
        --print("Updated")
    end,
})

CombatTab:CreateSection("Arrest Aura")
CombatTab:CreateToggle({
    Name = "Arrest Aura",
    CurrentValue = settings.arrestaura,
    Flag = "ArrestAuraToggle",
    Callback = function(Value)
        settings.arrestaura = Value
    end,
})

CombatTab:CreateSlider({
    Name = "Arrest Aura Radius",
    Range = {1,15},
    Increment = 1,
    Suffix = "studs",
    CurrentValue = settings.arrestaura_radius,
    Flag = "AARadiusSlider",
    Callback = function(Value)
        settings.arrestaura_radius = Value
    end,
})

CombatTab:CreateToggle({
    Name = "Team Check",
    CurrentValue = settings.aatc,
    Flag = "ArrestAuraTCToggle",
    Callback = function(Value)
        settings.aatc = Value
    end,
})

CombatTab:CreateDropdown({
    Name = "Teams Allowed",
    Options = aatypes,
    CurrentValue = settings.aatype,
    Flag = "ArrestAuraTeamDropdown",
    Callback = function(Option)
        settings.aatype = Option[1]
        --print("Updated")
    end,
})


-- Weapon Modifications --
CombatTab:CreateSection("Weapon Modifications")

CombatTab:CreateToggle({
    Name = "Fast Guns",
    CurrentValue = settings.auto_fg,
    Flag = "FastGunsToggle",
    Callback = function(Value)
        settings.auto_fg = Value
    end,
})

CombatTab:CreateSlider({
    Name = "Fire Rate",
    Range = {0, 100},
    Increment = 1,
    Suffix = "RPS",
    CurrentValue = settings.auto_fgrate,
    Flag = "FireRateSlider",
    Callback = function(Value)
        settings.auto_fgrate = Value
    end,
})

-- Teleport Tab --
-- Locations --
local selectedTeleport = nil
TeleportTab:CreateSection("Locations")

TeleportTab:CreateDropdown({
    Name = "Teleport To",
    Options = TeleportDisplayNames,
    Flag = "TPDropdown",
    Callback = function(option)
        local displayName = option[1] -- dropdown returns table
        selectedTeleport = DisplayToId[displayName] -- map to internal ID
        -- print("Selected teleport ID:", selectedTeleport)
    end,
})

TeleportTab:CreateButton({
    Name = "Go",
    Callback = function()
        if not selectedTeleport then
            Notify("Select a location first!")
            return
        end

        if canTeleport() then
            teleportTo(selectedTeleport)
        end
    end,
})

TeleportTab:CreateSection("Players")

-- Lists + Checks --
-- Lists + Checks: Setup --
local playerselector2 = TeleportTab:CreateDropdown({
    Name = "Players",
    Options = playerNames,
    CurrentValue = LocalPlayer.Name,
    Flag = "TCPlayerChecks",
    Callback = function(option)
        local selectedName = option[1]
        tcplayer = Players:FindFirstChild(selectedName)
        --print("Selected player:", lcplayer)
    end,
})

TeleportTab:CreateButton({
    Name = "Refresh List",
    Callback = function()
        builder()
        playerselector2:Refresh(playerNames)
        --print("Player list refreshed")
    end,
})

TeleportTab:CreateButton({
    Name = "Go",
    Callback = function()
		teleport_able = canTeleport()
		if teleport_able then
			tptop(tcplayer)
		end
    end,
})


-- Automation Tab --
-- Automation: Player Related --
AutoTab:CreateSection("Player Related")
AutoTab:CreateToggle({
    Name = "Auto Respawn (don't use this)",
    CurrentValue = settings.autorespawn,
    Flag = "AutoRespawnToggle",
    Callback = function(Value)
        settings.autorespawn = Value
    end,
})

AutoTab:CreateToggle({
    Name = "Auto Anti-Jump Removal",
    CurrentValue = settings.aajr,
    Flag = "AutoAntiJumpRemovalToggle",
    Callback = function(Value)
        settings.aajr = Value
    end,
})

-- Automation: Auto Guns --
AutoTab:CreateSection("Auto Guns")
AutoTab:CreateToggle({
    Name = "Auto Guns (don't use this)",
    CurrentValue = settings.autoguns,
    Flag = "AutoGunsToggle",
    Callback = function(Value)
        settings.autoguns = Value
    end,
})

-- selected gun from dropdown
local aggun = nil

AutoTab:CreateDropdown({
    Name = "Gun",
    Options = allGuns,
    Flag = "AGunDropdown",
    Callback = function(Option)
        aggun = Option[1]
    end,
})

AutoTab:CreateButton({
    Name = "Add/Remove Gun From Auto-Guns",
    Callback = function()
        if not aggun then
            return
        end

        local found = false
        for i, gun in ipairs(settings.autoguns_list) do
            if gun == aggun then
                table.remove(settings.autoguns_list, i)
                found = true
                print("Removed " .. aggun .. " from auto-guns list.")
				Notify("Removed " .. aggun .. " from auto-guns list.")
                break
            end
        end

        if not found then
            table.insert(settings.autoguns_list, aggun)
            print("Added " .. aggun .. " to auto-guns list.")
			Notify("Added " .. aggun .. " to auto-guns list.")
        end
    end,
})

-- Automation: Prison Related --
AutoTab:CreateSection("Prison Related")
AutoTab:CreateToggle({
    Name = "Auto Break Toilets",
    CurrentValue = settings.abtoilets,
    Flag = "AutoBreakToiletsToggle",
    Callback = function(Value)
        settings.abtoilets = Value
    end,
})

AutoTab:CreateToggle({
    Name = "No Doors",
    CurrentValue = settings.nodoors,
    Flag = "NoDoorsToggle",
    Callback = function(Value)
        settings.nodoors = Value
		task.wait(1)
        if not Value then
            AddDoors()
        end
    end,
})

AutoTab:CreateToggle({
    Name = "Transparent Doors",
    CurrentValue = settings.tdoors,
    Flag = "TDoorsToggle",
    Callback = function(Value)
        settings.tdoors = Value
		task.wait(1)
		if not Value then
			untdoors()
		end
    end,
})

AutoTab:CreateToggle({
    Name = "Keycard Grabber",
    CurrentValue = settings.akeycard,
    Flag = "KCGrabberToggle",
    Callback = function(Value)
        settings.akeycard = Value
    end,
})

--[[ AutoTab:CreateToggle({
    Name = "Spam Open Doors",
    CurrentValue = settings.sodoors,
    Flag = "SoDoorsToggle",
    Callback = function(Value)
        settings.sodoors = Value
    end,
}) ]]

-- Protection Tab --
-- Protection --
ProtectTab:CreateSection("Protection")

ProtectTab:CreateToggle({
    Name = "Anti Arrest",
    CurrentValue = settings.antiarrest,
    Flag = "AntiArrestToggle",
    Callback = function(Value)
        settings.antiarrest = Value
    end,
})

ProtectTab:CreateToggle({
    Name = "Anti Tase",
    CurrentValue = settings.antitase,
    Flag = "AntiTaseToggle",
    Callback = function(Value)
        settings.antitase = Value
    end,
})


-- Player Tab --
-- Actions --
PlayerTab:CreateSection("Actions")

PlayerTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = settings.ijump,
    Flag = "IJToggle",
    Callback = function(Value)
        settings.ijump = Value
    end,
})

PlayerTab:CreateToggle({
    Name = "Auto Sprint",
    CurrentValue = settings.ijump,
    Flag = "ASToggle",
    Callback = function(Value)
        settings.autosprint = Value
		settings.speedc = false
    end,
})

PlayerTab:CreateToggle({
    Name = "WalkSpeed Changer",
    CurrentValue = settings.speedc,
    Flag = "WSCToggle",
    Callback = function(Value)
        settings.speedc = Value
		settings.autosprint = false
    end,
})

PlayerTab:CreateSlider({
    Name = "WalkSpeed Value",
    Range = {0, 100},
    Increment = 1,
    Suffix = "",
    CurrentValue = 25,
    Flag = "SpeedCSlider",
    Callback = function(Value)
        settings.sval = Value
    end,
})

PlayerTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = settings.noclip,
    Flag = "NCToggle",
    Callback = function(Value)
        settings.noclip = Value
		if Value == true then
			noclip()
		else 
			clip() 
			CharacterCollision.Enabled = true
		end
    end,
})

PlayerTab:CreateToggle({
    Name = "Snack Noclip",
    CurrentValue = settings.ncglitch,
    Flag = "NCGToggle",
    Callback = function(Value)
        settings.ncglitch = Value
		if Value == false then
			CharacterCollision.Enabled = true
		end
    end,
})

if settings.ncglitch or settings.noclip then 
	if settings.noclip then noclip() end
else 
	if settings.noclip then clip() end
	CharacterCollision.Enabled = true
end

PlayerTab:CreateSlider({
    Name = "Field Of View",
    Range = {60, 120},
    Increment = 1,
    Suffix = "°",
    CurrentValue = 90,
    Flag = "FOVSlider",
    Callback = function(Value)
        workspace.Camera.FieldOfView = Value
    end,
})

PlayerTab:CreateSlider({
    Name = "Spin Speed",
    Range = {0, 10},
    Increment = 1,
    Suffix = "speed",
    CurrentValue = 0,
	Flag = "SpinSpeedSlider",
    Callback = function(Value)
        spinSpeed = Value
		if Value ~= 0 then -- lazy ahh
			spin(spinSpeed) 
		else 	
			for i,v in pairs(getRoot(LocalPlayer.Character):GetChildren()) do
				if v.Name == "Spinning" then
					v:Destroy()
				end
			end
		end
    end,
})

loadstring(game:HttpGet("https://kohlslite.pages.dev/uh/combo.lua", true))() -- load it cuz poo
function toggleesp() getgenv().espsettings.ESP = false; task.wait(0.1); getgenv().espsettings.ESP = true end

loadstring(game:HttpGet("https://kohlslite.pages.dev/uh/emotemodule.lua", true))()

-- ESP Tab --
ESPTab:CreateSection("ESP")
ESPTab:CreateToggle({
    Name = "ESP",
    CurrentValue = getgenv().espsettings,
    Flag = "ESPToggle",
    Callback = function(Value)
		getgenv().espsettings.ESP = Value
    end,
})

ESPTab:CreateSection("Teams Allowed")
ESPTab:CreateToggle({
    Name = "Guards Allowed",
    CurrentValue = getgenv().espsettings.ESPTeamCheck.Guards,
    Flag = "GuardsAllowedESP",
    Callback = function(Value)
		getgenv().espsettings.ESPTeamCheck.Guards = Value
		toggleesp()
    end,
})

ESPTab:CreateToggle({
    Name = "Criminals Allowed",
    CurrentValue = getgenv().espsettings.ESPTeamCheck.Criminals,
    Flag = "CriminalsAllowedESP",
    Callback = function(Value)
		getgenv().espsettings.ESPTeamCheck.Criminals = Value
		toggleesp()		
    end,
})

ESPTab:CreateToggle({
    Name = "Inmates Allowed",
    CurrentValue = getgenv().espsettings.ESPTeamCheck.Inmates,
    Flag = "InmatesAllowedESP",
    Callback = function(Value)
        getgenv().espsettings.ESPTeamCheck.Inmates = Value
		toggleesp()
    end,
})

ESPTab:CreateToggle({
    Name = "Show Team Mates",
    CurrentValue = getgenv().espsettings.ESPTeamMates,
    Flag = "TeamMatesESP",
    Callback = function(Value)
        getgenv().espsettings.ESPTeamMates = Value
		toggleesp()
    end,
})

ESPTab:CreateSection("Settings")
ESPTab:CreateToggle({
    Name = "Show Names",
    CurrentValue = getgenv().espsettings.names,
    Flag = "SNESP",
    Callback = function(Value)
        getgenv().espsettings.names = Value
		toggleesp()
    end,
})

ESPTab:CreateToggle({
    Name = "Show Health",
    CurrentValue = getgenv().espsettings.health,
    Flag = "SHESP",
    Callback = function(Value)
        getgenv().espsettings.health = Value
		toggleesp()
    end,
})

ESPTab:CreateToggle({
    Name = "Show Distance",
    CurrentValue = getgenv().espsettings.distance,
    Flag = "DISTESP",
    Callback = function(Value)
		getgenv().espsettings.distance = Value
		toggleesp()
    end,
})

ESPTab:CreateToggle({
    Name = "Show Boxes With Team Colors",
    CurrentValue = getgenv().espsettings.boxcolors,
    Flag = "BTCESP",
    Callback = function(Value)
        getgenv().espsettings.boxcolors = Value
		toggleesp()
    end,
})

ESPTab:CreateToggle({
    Name = "Show Info With Team Colors",
    CurrentValue = getgenv().espsettings.namecolors,
    Flag = "NTCESP",
    Callback = function(Value)
        getgenv().espsettings.namecolors = Value
		toggleesp()
    end,
})

-- Aimlock Tab --
AimbotTab:CreateSection("Aimlock")
AimbotTab:CreateToggle({
    Name = "Aimlock",
    CurrentValue = getgenv().aimlock.Aimbot,
    Flag = "AimlockToggle",
    Callback = function(Value)
		getgenv().aimlock.Aimbot = Value
    end,
})

AimbotTab:CreateSection("Teams Allowed")
AimbotTab:CreateToggle({
    Name = "Guards Allowed",
    CurrentValue = getgenv().aimlock.TeamCheck.Guards,
    Flag = "GuardsAllowedALT",
    Callback = function(Value)
		getgenv().aimlock.TeamCheck.Guards = Value
    end,
})

AimbotTab:CreateToggle({
    Name = "Criminals Allowed",
    CurrentValue = getgenv().aimlock.TeamCheck.Criminals,
    Flag = "CriminalsAllowedALT",
    Callback = function(Value)
		getgenv().aimlock.TeamCheck.Criminals = Value
	end,
})

AimbotTab:CreateToggle({
    Name = "Inmates Allowed",
    CurrentValue = getgenv().aimlock.TeamCheck.Inmates,
    Flag = "InmatesAllowedALT",
    Callback = function(Value)
		getgenv().aimlock.TeamCheck.Inmates = Value
    end,
})

AimbotTab:CreateToggle({
    Name = "Team Mates Allowed",
    CurrentValue = getgenv().aimlock.ALTeamMates,
    Flag = "TeamMatesAllowedALT",
    Callback = function(Value)
		getgenv().aimlock.ALTeamMates = Value
    end,
})


AimbotTab:CreateSection("FOV")
AimbotTab:CreateSlider({
	Name = "FOV",
	CurrentValue = getgenv().aimlock.FOV,
	Range = {100, 1000},
	Increment = 10,
	Suffix = "",
	Flag = "FOVABSlider",
	Callback = function(Value)
		getgenv().aimlock.FOV = Value
	end,
})

AimbotTab:CreateSection("Targets")
AimbotTab:CreateToggle({
    Name = "Target Torso",
    CurrentValue = getgenv().aimlock.Target.Torso,
    Flag = "TTALT",
    Callback = function(Value)
		getgenv().aimlock.Target.Torso = Value
    end,
})

AimbotTab:CreateToggle({
    Name = "Target Head",
    CurrentValue = getgenv().aimlock.Target.Head,
    Flag = "THALT",
    Callback = function(Value)
		getgenv().aimlock.Target.Head = Value
    end,
})

AimbotTab:CreateSection("Guns Allowed")
-- selected gun from dropdown
local abgun = nil

AimbotTab:CreateDropdown({
    Name = "Aimlock Gun List",
    Options = allGuns2,
    Flag = "ABGunDropdown",
    Callback = function(Option)
        abgun = Option[1]
    end,
})

AimbotTab:CreateButton({
    Name = "Add/Remove Gun From Aimlock",
    Callback = function()
        if not abgun then
            return
        end

        local allowedGuns = getgenv().aballowedguns
        if allowedGuns[abgun] then
            allowedGuns[abgun] = false; Notify(abgun .. " disabled in aimlock")
        else
            allowedGuns[abgun] = true; Notify(abgun .. " enabled in aimlock")
        end
    end,
})

-- Lists + Checks --
-- Lists + Checks: Setup --
LCTab:CreateSection("Player Selector")
local playerselector = LCTab:CreateDropdown({
    Name = "Players",
    Options = playerNames,
    CurrentValue = LocalPlayer.Name,
    Flag = "LCPlayerChecks",
    Callback = function(option)
        local selectedName = option[1]
        lcplayer = Players:FindFirstChild(selectedName)
        --print("Selected player:", lcplayer)
    end,
})

LCTab:CreateButton({
    Name = "Refresh List",
    Callback = function()
        builder()
        playerselector:Refresh(playerNames)
        --print("Player list refreshed")
    end,
})

Players.PlayerAdded:Connect(function(plr)
    builder()
    playerselector:Refresh(playerNames)
end)

-- Lists + Checks: Lists --
LCTab:CreateSection("Lists")
LCTab:CreateButton({
    Name = "Add/Remove from Kill Aura WL",
    Callback = function()
        kill_aura_wl(lcplayer, lcplayer.Name)
    end,
})

LCTab:CreateButton({
    Name = "Print KA WL List",
    Callback = function()
        for _, ka in ipairs(ka_wl) do
    		print(ka)
		end
    end,
})

LCTab:CreateButton({
    Name = "Add/Remove from Arrest Aura WL",
    Callback = function()
        arrest_aura_wl(lcplayer, lcplayer.Name)
    end,
})

LCTab:CreateButton({
    Name = "Print AA WL List",
    Callback = function()
        for _, aa in ipairs(aa_wl) do
    		print(aa)
		end
    end,
})

-- Lists + Checks: Checks --
LCTab:CreateSection("Checks")
LCTab:CreateButton({
    Name = "Check Inventory",
    Callback = function()
        CheckBackpack(lcplayer, lcplayer.Name)
    end,
})

LCTab:CreateButton({
    Name = "Check For Riot Police Access",
    Callback = function()
        CheckForRiot(lcplayer, lcplayer.Name)
    end,
})

LCTab:CreateButton({
    Name = "Print RPA List",
    Callback = function()
        for _, riot in ipairs(gamepasses.riots) do
    		print(riot)
		end
    end,
})

LCTab:CreateButton({
    Name = "Check For Mafia Pass",
    Callback = function()
        CheckForMafia(lcplayer, lcplayer.Name)
    end,
})

LCTab:CreateButton({
    Name = "Print MP List",
    Callback = function()
        for _, mafia in ipairs(gamepasses.mafias) do
    		print(mafia)
		end
    end,
})

LCTab:CreateButton({
    Name = "Check For Sniper Pass",
    Callback = function()
        CheckForSniper(lcplayer, lcplayer.Name)
    end,
})

LCTab:CreateButton({
    Name = "Print SP List",
    Callback = function()
        for _, sniper in ipairs(gamepasses.snipers) do
    		print(sniper)
		end
    end,
})

-- Other Tab --
-- Other: Prison Related --
OtherTab:CreateSection("Prison Related")
OtherTab:CreateButton({
    Name = "Break All Toilets",
    Callback = function()
        hammer_check_t()
    end,
})

OtherTab:CreateButton({
    Name = "Unkillable Fence",
    Callback = function()
        ukfence()
    end,
})

OtherTab:CreateButton({
    Name = "Destroy Doors",
    Callback = function()
		pcall(function()
        	DestroyDoors()
		end)
    end,
})

OtherTab:CreateButton({
    Name = "Destroy Prison Fences",
    Callback = function()
	 	pcall(function()
       		for i, v in pairs(game.Workspace["Prison_Fences"]:GetChildren()) do
				if v.Name == "fence" then
					v:Destroy()
				end
			end
		end)
    end,
})

OtherTab:CreateButton({
    Name = "Destroy Prison Gates",
    Callback = function()
        pcall(function()
			game.Workspace["Prison_Fences"]["Prison_Gate"]:Destroy()
			game.Workspace["Prison_Fences"]["gate"]:Destroy()
		end)
    end,
})

OtherTab:CreateButton({
    Name = "Destroy Team Indicators",
    Callback = function()
		pcall(function()
        	workspace.TeamIndicators:Destroy()
		end)
    end,
})

-- Other: Player Related --
OtherTab:CreateSection("Player Related")
OtherTab:CreateButton({
    Name = "Remove Jump Cooldown",
    Callback = function()
        ajr()
    end,
})

OtherTab:CreateToggle({
    Name = "Keep Reset Button Enabled",
    CurrentValue = settings.enablere,
    Flag = "ResetButtonToggle",
    Callback = function(Value)
        settings.enablere = Value
    end,
})

OtherTab:CreateToggle({
    Name = "Use Old Gun Sounds",
    CurrentValue = settings.oldsounds,
    Flag = "OldSoundsToggle",
    Callback = function(Value)
        settings.oldsounds = Value
    end,
})

OtherTab:CreateToggle({
    Name = "Apply OGS For Yourself Only",
    CurrentValue = settings.oldsoundsmeonly,
    Flag = "OldSoundsJMToggle",
    Callback = function(Value)
        settings.oldsoundsmeonly = Value
    end,
})

-- Other: Map Related --
OtherTab:CreateSection("Map Related")
OtherTab:CreateToggle({
    Name = "Hide Trees",
    CurrentValue = settings.htrees,
    Flag = "HideTreesToggle",
    Callback = function(Value)
        settings.htrees = Value
		htrees(settings.htrees)
    end,
})

-- Other: Server --
OtherTab:CreateSection("Server")

OtherTab:CreateButton({
    Name = "Rejoin",
    Callback = function()
        rj()
    end,
})

OtherTab:CreateButton({
    Name = "Serverhop",
    Callback = function()
        shop()
    end,
})

-- Other: UI --
OtherTab:CreateSection("UI")

OtherTab:CreateToggle({
    Name = "Kill Feed Notifications",
    CurrentValue = settings.killfeed,
    Flag = "KillFeedToggle",
    Callback = function(Value)
        settings.killfeed = Value
    end,
})

OtherTab:CreateToggle({
    Name = "Hostile/Trespassing Notifications",
    CurrentValue = settings.htdetect,
    Flag = "HTDetect",
    Callback = function(Value)
        settings.htdetect = Value
    end,
})

OtherTab:CreateToggle({
    Name = "Close Script",
    Callback = function(Value)
		settings.KeepPX = false; game.Players.LocalPlayer:Kick("PrisonX closed. Rejoinning...")
		rj()
    end,
})

OtherTab:CreateToggle({
    Name = "Keep PrisonX After Rejoin/Serverhop",
	CurrentValue = settings.KeepPX,
    Callback = function(Value)
		settings.KeepPX = Value
    end,
})

Rayfield:LoadConfiguration()

queueteleport = (syn and syn.queue_on_teleport) or queue_on_teleport or (fluxus and fluxus.queue_on_teleport)

local TeleportCheck = false
game.Players.LocalPlayer.OnTeleport:Connect(function(State)
	if settings.KeepPX and (not TeleportCheck) and queueteleport then
		TeleportCheck = true
		queueteleport("loadstring(game:HttpGet('https://kohlslite.pages.dev/PrisonX.lua'))()")
	end
end)

print("PrisonX executed! | Version: ".. version .." | Created by TS2021.")
Notify("PrisonX executed! | Version: ".. version); die()
Notify("This project is discontinued.", 10)
