if SERVER then
    local TEAM_GHOST = 5
    local GHOST_COMMAND = "ghost"

    game.ConsoleCommand("mp_show_voice_icons 0")

    hook.Add("PlayerSay", "PlayerRequestGhostCheck", function(ply, text)
        text = string.lower(text)

        if text == "!" .. GHOST_COMMAND or text == "/" .. GHOST_COMMAND then
            if not ply:Alive() and ROUND:GetCurrent() == 5 then
                SetGhost(ply, true)
            elseif ply:IsGhost() then
                SetGhost(ply, false)
            else
                ply:ChatPrint(ply, "您现在不能这样做。")
                return
            end
        end
    end)

    function SetGhost(ply, stat)
        ply:SetNWBool("IsGhost", stat)
        ply:DrawShadow(not stat)
        ply:SetAvoidPlayers(stat)

        if stat then
            AddGhost(ply)
        else
            RemoveGhost(ply)
        end
    end

    function RemoveGhost(ply)
        ply:KillSilent()
        ply:SetBloodColor(0)
        ply:SetCollisionGroup(0)
        ply:SetTeam(TEAM_RUNNER)
        ply:BeginSpectate()
    end

    function AddGhost(ply)
        ply:SetTeam(TEAM_GHOST)
        ply:Spawn()
        ply:SetBloodColor(-1)
        ply:SetCollisionGroup(10)
        ply.SpawnSet = false
    end

    hook.Add("OnRoundSet", "RemoveAllGhosts", function()
        for _, v in ipairs(player.GetAll()) do
            if v:IsGhost() then
                SetGhost(v, false)
            end
        end
    end)
end
