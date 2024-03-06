DR.AnnouncerName = DR.AnnouncerName or "HELP" -- incase the file refreshes
DR.AnnouncerColor = DR.AnnouncerColor or DR.Colors.Text.Alizarin

function DR:SetAnnouncerName( name )
	DR.AnnouncerName = name
end

function DR:SetAnnouncerColor( col )
	DR.AnnouncerColor = col
end

function DR:SetAnnouncerTable( tbl )
	msgs = tbl
end

function DR:GetAnnouncerTable( )
	return msgs
end



local msgs = {}

msgs = {
	"如果有问题可以直接在聊天框中打出或善用搜索引擎。我们希望您有一个不错的体验。",
	"使用!rtv来投票换图，使用!nominate或!maps来指定地图（会在下次换图时以选项形式出现）。",
	"使用!crosshair来自定义准星。",
	"按F4打开商店，所有物品均可免费获得。",
	"使用F2或!settings来修改HUD位置等项目。",
	"使用F2或!settings来修改队友名字消失时间等项目。",
	"走近按钮可以占有该按钮。",
	"可以使用Tab并右键玩家以静音该玩家。",
	"可以使用F2来关闭这些[Help]开头的提示。",
	"使用F2可以自定义HUD并关闭自动连跳、调节队伍至观察者等。实用命令：!stuck - 可以在被卡住时使用；!spec - 切换到观察者队伍。实用快捷键：F2 - 设置；F8 - 切换人称。",
	"使用F2可以更改HUD主题。",
	"在作为死神时退出会受到惩罚，并会在下一回合中继续扮演死神。",
	"死亡后可以使用!ghost进入幽灵模式，再次使用以退出。在幽灵模式下，按左键存点，按右键回到存点，按V进入飞行模式。",
}

function DR:AddAnnouncement( ann )
	table.insert( msgs, ann or "Blank Announcement" )
end

local AnnouncementInterval = CreateClientConVar("deathrun_announcement_interval", 60, true, false)
local AnnouncementEnabled = CreateClientConVar("deathrun_enable_announcements", 1, true, false)

local idx = 1

local function DoAnnouncements()
	if AnnouncementEnabled:GetBool() == false then return end

	chat.AddText(DR.Colors.Text.Clouds, "[", DR.AnnouncerColor, DR.AnnouncerName, DR.Colors.Text.Clouds, "] "..(msgs[idx]))
	idx = idx + 1
	if idx > #msgs then idx = 1 end
end

cvars.AddChangeCallback( "deathrun_announcement_interval", function( name, old, new )
	timer.Destroy("DeathrunAnnouncementTimer")
	timer.Create("DeathrunAnnouncementTimer", new, 0, function()
		DoAnnouncements()
	end)
end, "DeathrunAnnouncementInterval")

timer.Create("DeathrunAnnouncementTimer", AnnouncementInterval:GetFloat(), 0, function()
	DoAnnouncements()
end)