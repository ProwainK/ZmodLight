local w = SL_WideScale(310, 417)
local h = 22

-- var for new song meter
local SongMeterW = 136
local SongMeterH = 2
--local SongMeterX = _screen.cx + (player==PLAYER_1 and -1 or 1) * SL_WideScale(238, 288)
local SongMeterX = _screen.cx + (-1) * SL_WideScale(238, 288)

-- var for hide song title
--local player = ...
--local mods = SL[ToEnumShortString(player)].ActiveModifiers

-- Song Completion Meter
return Def.ActorFrame{
	Name="SongMeter",
	InitCommand=function(self) self:y(20) end,

	-- border
	Def.Quad{ InitCommand=function(self) self:xy(SongMeterX, 12):zoomto(SongMeterW+4, SongMeterH+4) end },
	Def.Quad{ InitCommand=function(self) self:xy(SongMeterX, 12):zoomto(SongMeterW, SongMeterH):diffuse(0,0,0,1) end },

  -- Song Meter
	Def.SongMeterDisplay{
		StreamWidth=SongMeterW,
		Stream=Def.Quad({
      InitCommand=function(self)
        self:x(SongMeterX-68):horizalign("left"); -- 76 - 4 * 2 = 68?
        self:y(12):zoomy(2):diffuse(GetCurrentColor(true));
      end
    })
	},

	-- Song Title
	LoadFont(ThemePrefs.Get("ThemeFont") .. " Normal")..{
		Name="SongTitle",
		InitCommand=function(self) self:x(_screen.cx):zoom(0.8):shadowlength(0.6):maxwidth(_screen.w/2.5 - 10) end,
		CurrentSongChangedMessageCommand=function(self)

        --if P2_mods.NoteFieldOffsetY < -35 then
          --self:y(_screen.cy * 2 - 40)
        --end

			local song = GAMESTATE:GetCurrentSong()
			self:settext( song and song:GetDisplayFullTitle() or "" )
		end
	}
}