local assets = {

	Asset("ANIM", "anim/roulettesword1.zip"),
	Asset("ANIM", "anim/swap_roulettesword1.zip"),
	Asset("ATLAS", "images/inventoryimages/roulettesword.xml"),
	Asset("IMAGE", "images/inventoryimages/roulettesword.tex"),
}

--sum = 99.84
local LOOT = {

	{item = "cutgrass",	 			chance = 30},
	{item = "twigs",	 			chance = 30},
	{item = "flint",	 			chance = 10},
	{item = "silk",				 	chance = 1},
	{item = "rope",		 			chance = 1},
	{item = "seeds", 				chance = 5},
	{item = "redgem", 				chance = .04},
	{item = "bluegem", 				chance = .04},
	{item = "purplegem", 			chance = .02},
	{item = "orangegem", 			chance = .01},
	{item = "yellowgem", 			chance = .01},
	{item = "greengem", 			chance = .01},
	{item = "goldnugget", 			chance = 1},
	{item = "gears", 				chance = .5},
	{item = "nightmarefuel",		chance = 1},
	{item = "houndstooth", 			chance = 1},
	{item = "trinket_3", 			chance = .5},
	{item = "trinket_4", 			chance = .5},
	{item = "trinket_6", 			chance = .5},
	{item = "trinket_8", 			chance = .5},
	{item = "butterflywings", 		chance = 1},
	{item = "butter", 				chance = .1},
	{item = "petals",				chance = 1},
	{item = "petals_evil",			chance = 1},
	{item = "foliage",				chance = 1},
	{item = "stinger", 				chance = 1},
	{item = "dragonpie", 			chance = 1},
	{item = "perogies", 			chance = 1},
	{item = "butterflymuffin", 		chance = 1},
	{item = "taffy", 				chance = 1},
	{item = "bonestew", 			chance = 1},
	{item = "monsterlasagna", 		chance = 1},
	{item = "mandrake", 			chance = .1},
	{item = "boneshard",			chance = .1},
	{item = "feather_crow",			chance = .25},
	{item = "feather_canary",		chance = .25},
	{item = "feather_robin",		chance = .25},
	{item = "feather_robin_winter",	chance = .25},
	{item = "hound",				chance = 1, 	aggro = true},
	{item = "spider", 				chance = 1, 	aggro = true},
	{item = "frog", 				chance = 1, 	aggro = true},
	{item = "bee", 					chance = 1, 	aggro = true},
	{item = "mosquito", 			chance = 1, 	aggro = true},
	{item = "stalker", 				chance = .01, 	aggro = true},
}

local function OnEquip(inst, owner)

	owner.AnimState:OverrideSymbol("swap_object", "swap_roulettesword1", "roulettesword1")
	owner.AnimState:Show("ARM_carry")
	owner.AnimState:Hide("ARM_normal")
end

local function OnUnequip(inst, owner)

	owner.AnimState:Show("ARM_normal")
	owner.AnimState:Hide("ARM_carry")
end

local function OnAttack(inst, owner, target)

	if owner and owner.components.sanity then owner.components.sanity:DoDelta(-1) end
	
	if not (target:HasTag("summoned") or target:HasTag("wall")) then
	
		if math.random(2) > 1 then
		
			local rand = math.random(9984)
			local sum = 0
			local i = 0
			while sum < rand do
				i = i + 1
				sum = sum + (LOOT[i].chance * 100)
			end
	
			local item = SpawnPrefab(LOOT[i].item)
			local item_pos = target:GetPosition()
			item.Transform:SetPosition(item_pos.x, item_pos.y, item_pos.z)
			local angle = math.random() * 2 * PI
			local speed = math.random() * 2
			item.Physics:SetVel(speed * math.cos(angle), GetRandomWithVariance(8, 4), speed * math.sin(angle))
		
			if LOOT[i].aggro then
				item:AddTag("summoned")
				if item.components.lootdropper.loot or item.components.lootdropper.chanceloot or item.components.lootdropper.randomloot then item.components.lootdropper:SetLoot({}) end
				if item.components.lootdropper.chanceloottable then item.components.lootdropper:SetChanceLootTable(nil) end
				if item.components.combat ~= nil and owner ~= nil then
					if not (item:HasTag("spider") and (owner:HasTag("spiderwhisperer") or owner:HasTag("monster"))) then
						item.components.combat:SuggestTarget(owner)
					end
				end
			end
		end
	end
end

local function init()

	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.AnimState:SetBank("roulettesword1")
	inst.AnimState:SetBuild("roulettesword1")
	inst.AnimState:PlayAnimation("idle", false)
	
	inst:AddTag("sharp")
	
	MakeInventoryPhysics(inst)
		
	if not TheWorld.ismastersim then
		return inst
	end	
	
	inst.entity:SetPristine()
	
	inst:AddComponent("weapon")
	inst.components.weapon:SetDamage(15)
	inst.components.weapon:SetOnAttack(OnAttack)
	
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "roulettesword"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/roulettesword.xml"
	
	inst:AddComponent("equippable")
	inst.components.equippable:SetOnEquip(OnEquip)
	inst.components.equippable:SetOnUnequip(OnUnequip)
	
	inst:AddComponent("inspectable")

	return inst
end

return Prefab("common/inventory/roulettesword1", init, assets, prefabs)