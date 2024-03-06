print("Loaded pointshop support...")

local hasPointshop = false
local hasPointshop2 = false
local hadRedactedHub = false

if PS then
	hasPointshop = true 
end
if RS then
	hasRedactedHub = true 
end
if Pointshop2 then
	hasPointshop2 = true
end

local defaultFlags = FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED + FCVAR_NOTIFY + FCVAR_ARCHIVE

local PointshopFinishReward = CreateConVar("deathrun_pointshop_finish_reward", 10, defaultFlags, "How many points to award the player when he finishes the map." )
local PointshopKillReward = CreateConVar("deathrun_pointshop_kill_reward", 5, defaultFlags, "How many points to award the player when they kill another player." )
local PointshopWinReward = CreateConVar("deathrun_pointshop_win_reward", 3, defaultFlags, "How many points to award the player when their team wins." )
local PointshopRewardMessage = CreateConVar("deathrun_pointshop_notify", 1, defaultFlags, "Enable chat messages or notifications when rewards are received - does not work for PS2")

if SERVER then

	function DR:RewardPlayer( ply, amt, reason )
		amt = amt or 0
		if hasPointshop then
			ply:PS_GivePoints( amt )
			if PointshopRewardMessage:GetBool() then
				ply:PS_Notify("您被给予了 "..tostring( amt ).." 奖励点数，因为您 "..(reason or "正在游玩本服务器").."！")
			end
		end
		if hasRedactedHub then
			local storemoney = RS:GetStoreMoney() or 0
			if amt <= storemoney then
				ply:AddMoney( amt )
				RS:SubStoreMoney( amt )
				if PointshopRewardMessage:GetBool() then
					ply:DeathrunChatPrint("您被给予了 "..tostring( amt ).." 奖励点数，因为您 "..(reason or "正在游玩本服务器").."！")
				end
			else
				if PointshopRewardMessage:GetBool() then
					ply:DeathrunChatPrint("很抱歉，商店目前的点数不足以奖励您。")
				end
			end			
		end
		if hasPointshop2 then
			--if PointshopRewardMessage:GetBool() then
			ply:PS2_AddStandardPoints( amt, "您获得了"..tostring( amt ).."点数，因为您"..(reason or "正在游玩本服务器").."！", true)
		end
	end


	hook.Add("DeathrunPlayerFinishMap", "PointshopRewards", function( ply, zname, z, place )
		DR:RewardPlayer( ply, PointshopFinishReward:GetInt(), "通关了地图")
	end)

	hook.Add("PlayerDeath", "PointshopRewards", function( ply, inflictor, attacker )
		if attacker:IsPlayer() then
			if ply:Team() ~= attacker:Team() then
				DR:RewardPlayer( attacker, PointshopKillReward:GetInt(), "击杀了"..ply:Nick())
			end
		end
	end)

	hook.Add("DeathrunRoundWin", "PointshopRewards", function( winner )
		for k,v in ipairs( player.GetAllPlaying() ) do
			if v:Team() == winner then
				DR:RewardPlayer( v, PointshopWinReward:GetInt(), "赢得了回合")
			end
		end
	end)
end