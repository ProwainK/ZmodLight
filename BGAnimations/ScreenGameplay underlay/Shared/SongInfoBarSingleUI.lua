local t = Def.ActorFrame{};

local w = SL_WideScale(310, 417)
local h = 22

-- var for new song meter
local SongMeterW = 136
local SongMeterH = 12
--local SongMeterX = _screen.cx + (player==PLAYER_1 and -1 or 1) * SL_WideScale(238, 288)
local SongMeterX = _screen.cx + (1) * SL_WideScale(238, 288)

-- var for hide song title
local StepStatisticsNow = false
local Players = GAMESTATE:GetHumanPlayers()
for player in ivalues(Players) do
  if SL[ToEnumShortString(player)].ActiveModifiers.DataVisualizations == "Step Statistics" then
    StepStatisticsNow = true
    break
  end
end

local SongMeterFrameY = _screen.cy+38
local SongMeterY = 12
local SongTitleY = 38
local SongArtistY = _screen.cy+98
local SongJacketY = _screen.cy-22

if StepStatisticsNow == true then
  SongMeterFrameY = _screen.cy+38 -- _screen.cy+38
  SongMeterY = -68 -- 12
  SongTitleY = -42 -- 38
  SongArtistY = _screen.cy+18 -- _screen.cy+98
  SongJacketY = _screen.cy-102 -- _screen.cy-22
end

-- Song Completion Meter
t[#t+1] = Def.ActorFrame{
	Name="SongMeter",
	InitCommand=function(self) self:y(SongMeterFrameY) end,

	-- border
	Def.Quad{ InitCommand=function(self) self:xy(SongMeterX, SongMeterY):zoomto(SongMeterW+4, SongMeterH+4) end },
	Def.Quad{ InitCommand=function(self) self:xy(SongMeterX, SongMeterY):zoomto(SongMeterW, SongMeterH):diffuse(0,0,0,1) end },

  -- Song Meter
	Def.SongMeterDisplay{
		StreamWidth=SongMeterW,
		Stream=Def.Quad({
      InitCommand=function(self)
        self:x(SongMeterX-68):horizalign("left"); -- 76 - 4 * 2 = 68?
        self:y(SongMeterY):zoomy(SongMeterH):diffuse(GetCurrentColor(true));
      end
    })
	},

	-- Song Title
	LoadFont("Common Normal")..{
		Name="SongTitle",
		InitCommand=function(self) self:xy(SongMeterX, SongTitleY):zoom(0.8):shadowlength(0.6):maxwidth(_screen.w/2.5 - 10) end,
		CurrentSongChangedMessageCommand=function(self)

        --if P2_mods.NoteFieldOffsetY < -35 then
          --self:y(_screen.cy * 2 - 40)
        --end

			local song = GAMESTATE:GetCurrentSong()
			--self:settext( song and song:GetDisplayFullTitle() or "" )
			self:settext( song:GetDisplayFullTitle() and song:GetDisplayMainTitle() or "" )
		end
	}

}

-- Song Artist
t[#t+1] = LoadFont("Common Normal")..{
		Name="SongArtist",
		InitCommand=function(self) self:xy(SongMeterX, SongArtistY):zoom(0.8):shadowlength(0.6):maxwidth(_screen.w/2.5 - 10) end,
		CurrentSongChangedMessageCommand=function(self)
			local song = GAMESTATE:GetCurrentSong()
			self:settext( song:GetDisplayArtist() or "" )
		end
}

-- Song Jacket
t[#t+1] = Def.ActorFrame{
		Name="SongJacket",
		InitCommand=function(self) self:xy(SongMeterX, SongJacketY):shadowlength(0.6) end,

	-- border
	Def.Quad{ InitCommand=function(self) self:zoomto(SongMeterW+4, SongMeterW+4) end },
	Def.Quad{ InitCommand=function(self) self:zoomto(SongMeterW, SongMeterW):diffuse(0,0,0,1) end },

	Def.Sprite {
		OnCommand=function (self)
      local jacket_size = SongMeterW-6;
			local course = GAMESTATE:GetCurrentCourse();
			if GAMESTATE:IsCourseMode() then
				if course:GetBackgroundPath() then
					self:Load(course:GetBackgroundPath())
					self:setsize(jacket_size, jacket_size);
				else
						self:Load(THEME:GetPathG("", "_VisualStyles/Hearts/TitleMenu (doubleres).png"));
					self:setsize(jacket_size, jacket_size);
				end;
			else
			local song = GAMESTATE:GetCurrentSong();
				if song then
					if song:HasJacket() then
						self:LoadBackground(song:GetJacketPath());
						self:setsize(jacket_size, jacket_size);
					elseif song:HasBackground() then
						self:LoadFromSongBackground(GAMESTATE:GetCurrentSong());
						self:setsize(jacket_size, jacket_size);
					else
						self:Load(THEME:GetPathG("", "_VisualStyles/Hearts/TitleMenu (doubleres).png"));
						self:setsize(jacket_size, jacket_size);
					end;
				else
					self:diffusealpha(1);
			end;
		end;
		end;
	OffCommand=cmd();
	};


}

return t