local assets = {

	Asset("ANIM", "anim/roulettesword2.zip"),
	Asset("ANIM", "anim/swap_roulettesword2.zip"),
	Asset("ATLAS", "images/inventoryimages/roulettesword2.xml"),
	Asset("IMAGE", "images/inventoryimages/roulettesword2.tex"),
}

--43
local LOOT = {

	{item = "goldnugget", 				chance = 15},
	{item = "redgem", 					chance = 5},
	{item = "bluegem", 					chance = 5},
	{item = "purplegem", 				chance = 4},
	{item = "orangegem", 				chance = 1},
	{item = "yellowgem", 				chance = 1},
	{item = "greengem", 				chance = 1},
	{item = "thulecite", 				chance = 2},
	{item = "nightmarefuel", 			chance = 4},
	{item = "gears", 					chance = 2},
	{item = "deerclops", 				chance = .75, 	aggro = true},
	{item = "dragonfly", 				chance = .75, 	aggro = true},
	{item = "bearger", 					chance = .75, 	aggro = true},
	{item = "moose", 					chance = .75, 	aggro = true},
	{item = "stalker"},

}

local function OnEquip(inst, owner)

	owner.AnimState:OverrideSymbol("swap_object", "swap_roulettesword2", "roulettesword2")
	owner.AnimState:Show("ARM_carry")
	owner.AnimState:Hide("ARM_normal")
end

local function OnUnequip(inst, owner)

	owner.AnimState:Show("ARM_normal")
	owner.AnimState:Hide("ARM_carry")
end

local function OnAttack(inst, owner, target)

	if owner and owner.components.sanity then owner.components.sanity:DoDelta(-10) end
	
	if not (target:HasTag("summoned") or target:HasTag("wall")) then
		
		local rand = math.random(100)		
		if rand == 1 then
		
			for i = 1, 7 do
				for ii = 1, math.random(5) do
					local item = SpawnPrefab(LOOT[i].item)
					local item_pos = target:GetPosition()
					item.Transform:SetPosition(item_pos.x, item_pos.y, item_pos.z)
					local angle = math.random() * 2 * PI
					local speed = math.random() * 10
					item.Physics:SetVel(speed * math.cos(angle), GetRandomWithVariance(8, 4), speed * math.sin(angle))
				end
			end
		elseif rand == 2 then		
			for i = 11, 15 do
				local item = SpawnPrefab(LOOT[i].item)
				local item_pos = target:GetPosition()
				item.Transform:SetPosition(item_pos.x, item_pos.y, item_pos.z)
				if item.components.lootdropper.loot or item.components.lootdropper.chanceloot or item.components.lootdropper.randomloot then item.components.lootdropper:SetLoot({}) end
				if item.components.lootdropper.chanceloottable then item.components.lootdropper:SetChanceLootTable(nil) end
				item:AddTag("summoned")
				if item.components.combat ~= nil and owner ~= nil then
					item.components.combat:SuggestTarget(owner)
				end
			end
		else
			rand = math.random(4300)--4300
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
					item.components.combat:SuggestTarget(owner)
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
	
	inst.AnimState:SetBank("roulettesword2")
	inst.AnimState:SetBuild("roulettesword2")
	inst.AnimState:PlayAnimation("idle", false)
	
	inst:AddTag("sharp")
	
	MakeInventoryPhysics(inst)
		
	if not TheWorld.ismastersim then
		return inst
	end	
	
	inst.entity:SetPristine()
	
	inst:AddComponent("weapon")
	inst.components.weapon:SetDamage(65)
	inst.components.weapon:SetRange(1.5,1.5)
	inst.components.weapon:SetOnAttack(OnAttack)
	
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "roulettesword2"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/roulettesword2.xml"
	
	inst:AddComponent("equippable")
	inst.components.equippable:SetOnEquip(OnEquip)
	inst.components.equippable:SetOnUnequip(OnUnequip)
	
	inst:AddComponent("inspectable")

	return inst
end

return Prefab("common/inventory/roulettesword2", init, assets, prefabs)