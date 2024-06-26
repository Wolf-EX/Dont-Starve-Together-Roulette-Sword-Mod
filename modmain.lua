local Ingredient = GLOBAL.Ingredient
local RECIPETABS = GLOBAL.RECIPETABS
local TECH = GLOBAL.TECH
local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS

PrefabFiles = {

	"roulettesword1",
	"roulettesword2",
}

--strings
STRINGS.NAMES.ROULETTESWORD1 = "Loot Sword"
--STRINGS.CHARACTERS.GENERIC.DESCRIBE.ROULETTESWORD1 = ""

STRINGS.NAMES.ROULETTESWORD2 = "Roulette Sword"
--STRINGS.CHARACTERS.GENERIC.DESCRIBE.ROULETTESWORD2 = ""

--recipe
if GetModConfigData("easycraft") then
	AddRecipe2("roulettesword2", {Ingredient("bluegem", 1), Ingredient("redgem", 1), Ingredient("purplegem", 1),  Ingredient("orangegem", 1),  Ingredient("yellowgem", 1),  Ingredient("greengem", 1)},TECH.MAGIC_TWO,{atlas = "images/inventoryimages/roulettesword.xml",image = "roulettesword.tex"},{"WEAPONS"})
else
	AddRecipe2("roulettesword2", {Ingredient("bluegem", 1), Ingredient("redgem", 1), Ingredient("purplegem", 1),  Ingredient("orangegem", 1),  Ingredient("yellowgem", 1),  Ingredient("greengem", 1), Ingredient("thulecite", 8), Ingredient("nightmarefuel", 10)},TECH.ANCIENT_FOUR,{atlas = "images/inventoryimages/roulettesword.xml",image = "roulettesword.tex"},{"WEAPONS"})
end

--postinits
function deerclopspostinit(inst)
	
	function NewOnSave(inst, data)
	
		data.structuresDestroyed = inst.structuresDestroyed
		data.summoned = inst:HasTag("summoned")
	end
	
	function NewOnLoad(inst, data)

		if data then
			inst.structuresDestroyed = data.structuresDestroyed or inst.structuresDestroyed
			if data.summoned then
				inst:AddTag("summoned")
				if inst.components.lootdropper.loot then inst.components.lootdropper:SetLoot({}) end
			end
		end	
	end
	
	inst.OnSave = NewOnSave
	inst.OnLoad = NewOnLoad
end

function beargerpostinit(inst)

	function NewOnSave(inst, data)
	
		data.seenbase = inst.seenbase or nil-- from brain
		data.cangroundpound = inst.cangroundpound
		data.num_food_cherrypicked = inst.num_food_cherrypicked
		data.num_good_food_eaten = inst.num_good_food_eaten
		data.killedplayer = inst.killedplayer
		data.shouldgoaway = inst.shouldgoaway
		data.summoned = inst:HasTag("summoned")
	end

	function NewOnLoad(inst, data)
	
		if data ~= nil then
			inst.seenbase = data.seenbase or nil-- for brain
			inst.cangroundpound = data.cangroundpound
			inst.num_food_cherrypicked = data.num_food_cherrypicked or 0
			inst.num_good_food_eaten = data.num_good_food_eaten or 0
			inst.killedplayer = data.killedplayer or false
			inst.shouldgoaway = data.shouldgoaway or false
			
			if data.summoned then
				inst:AddTag("summoned")
				if inst.components.lootdropper.chanceloottable then inst.components.lootdropper:SetChanceLootTable(nil) end
			end
		end
	end
	
	inst.OnSave = NewOnSave
	inst.OnLoad = NewOnLoad

end

function dragonflypostinit(inst)

	local function ToggleDespawnOffscreen(inst)
		if inst:IsAsleep() then
			if inst.sleeptask == nil then
				inst.sleeptask = inst:DoTaskInTime(10, ForceDespawn)
			end
		elseif inst.sleeptask ~= nil then
			inst.sleeptask:Cancel()
			inst.sleeptask = nil
		end
	end

	local function PushMusic(inst)
		if ThePlayer == nil or inst:HasTag("flight") then
			inst._playingmusic = false
		elseif ThePlayer:IsNear(inst, inst._playingmusic and 60 or 20) then
			inst._playingmusic = true
			ThePlayer:PushEvent("triggeredevent", { name = "dragonfly", duration = 15 })
		elseif inst._playingmusic and not ThePlayer:IsNear(inst, 64) then
			inst._playingmusic = false
		end
	end

	local function OnIsEngagedDirty(inst)
		--Dedicated server does not need to trigger music
		if not GLOBAL.TheNet:IsDedicated() then
			if not inst._isengaged:value() then
				if inst._musictask ~= nil then
					inst._musictask:Cancel()
					inst._musictask = nil
				end
				inst._playingmusic = false
			elseif inst._musictask == nil then
				inst._musictask = inst:DoPeriodicTask(1, PushMusic)
				PushMusic(inst)
			end
		end
	end

	function SetEngaged(inst, engaged)
		if inst._isengaged:value() ~= engaged then
			inst._isengaged:set(engaged)
			OnIsEngagedDirty(inst)
			ToggleDespawnOffscreen(inst)

			local home = inst.components.homeseeker ~= nil and inst.components.homeseeker.home or nil
			if home ~= nil then
            home:PushEvent("dragonflyengaged", { engaged = engaged, dragonfly = inst })
			end
		end
	end

	function NewOnSave(inst, data)
	
		data.playercombat = inst._isengaged:value() or nil
		data.summoned = inst:HasTag("summoned")
	end
	
	function NewOnLoad(inst, data)
	
		if data.playercombat then
        SetEngaged(inst, true)
        inst:DoTaskInTime(0, OnInitEngaged)
        inst:DoTaskInTime(1, Reset)
		end
		
		if data and data.summoned then
			inst:AddTag("summoned")
			if inst.components.lootdropper.chanceloottable then inst.components.lootdropper:SetChanceLootTable(nil) end
		end
	end
	
	inst.OnSave = NewOnSave
	inst.OnLoad = NewOnLoad
end

function moosepostinit(inst)

	function NewOnSave(inst, data)
	
	data.WantsToLayEgg = inst.WantsToLayEgg
    data.CanDisarm = inst.CanDisarm
    data.shouldGoAway = inst.shouldGoAway
	data.summoned = inst:HasTag("summoned")
	end
	
	function NewOnLoad(inst, data)
	
		if data.WantsToLayEgg then
			inst.WantsToLayEgg = data.WantsToLayEgg
		end
		if data.CanDisarm then
			inst.CanDisarm = data.CanDisarm
		end
		inst.shouldGoAway = data.shouldGoAway or false
		
		if data and data.summoned then
			inst:AddTag("summoned")
			if inst.components.lootdropper.chanceloottable then inst.components.lootdropper:SetChanceLootTable(nil) end
		end
	end
	
	inst.OnSave = NewOnSave
	inst.OnLoad = NewOnLoad
end

function spiderpostinit(inst)

	function NewOnSave(inst, data)
		
		data.summoned = inst:HasTag("summoned")
	end
	
	function NewOnLoad(inst, data)
	
		if data and data.summoned then
			inst:AddTag("summoned")
			if inst.components.lootdropper.randomloot then inst.components.lootdropper.randomloot = {} end
		end
	end
	
	inst.OnSave = NewOnSave
	inst.OnLoad = NewOnLoad
end

function frogpostinit(inst)

	function NewOnSave(inst, data)
		
		data.summoned = inst:HasTag("summoned")
	end
	
	function NewOnLoad(inst, data)
	
		if data and data.summoned then
			inst:AddTag("summoned")
			if inst.components.lootdropper.loot then inst.components.lootdropper:SetLoot({}) end
		end
	end
	
	inst.OnSave = NewOnSave
	inst.OnLoad = NewOnLoad
end

function mosquitopostinit(inst)

	function NewOnSave(inst, data)
		
		data.summoned = inst:HasTag("summoned")
	end
	
	function NewOnLoad(inst, data)
	
		if data and data.summoned then
			inst:AddTag("summoned")
			if inst.components.lootdropper.chanceloottable then inst.components.lootdropper:SetChanceLootTable(nil) end
		end
	end
	
	inst.OnSave = NewOnSave
	inst.OnLoad = NewOnLoad
end

function stalkerpostinit(inst)

	function NewOnSave(inst, data)
	
		data.summoned = inst:HasTag("summoned")
	end
	
	function NewOnLoad(inst, data)
	
		if data and data.summoned then
			inst:AddTag("summoned")
			if inst.components.lootdropper.chanceloot then inst.components.lootdropper:SetLoot({}) end
		end
	end
	
	inst.OnSave = NewOnSave
	inst.OnLoad = NewOnLoad	
end

AddPrefabPostInit("deerclops", deerclopspostinit)
AddPrefabPostInit("bearger", beargerpostinit)
AddPrefabPostInit("dragonfly", dragonflypostinit)
AddPrefabPostInit("moose", moosepostinit)
AddPrefabPostInit("spider", spiderpostinit)
AddPrefabPostInit("bee", spiderpostinit)--same as spiders
AddPrefabPostInit("frog", frogpostinit)
AddPrefabPostInit("mosquito", mosquitopostinit)
AddPrefabPostInit("stalker", stalkerpostinit)