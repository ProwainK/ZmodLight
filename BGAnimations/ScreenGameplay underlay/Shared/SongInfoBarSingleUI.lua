local t = Def.ActorFrame{};

local w = SL_WideScale(310, 417)
local h = 22

-- var for new song meter
local SongMeterW = 136
local SongMeterH = 3
--local SongMeterX = _screen.cx + (player==PLAYER_1 and -1 or 1) * SL_WideScale(238, 288)
local SongMeterX = _screen.cx + (1) * SL_WideScale(238, 288)

-- var for hide song title
--local player = ...
--local mods = SL[ToEnumShortString(player)].ActiveModifiers

-- Song Completion Meter
t[#t+1] = Def.ActorFrame{
	Name="SongMeter",
	InitCommand=function(self) self:y(_screen.cy+36) end,

	-- border
	Def.Quad{ InitCommand=function(self) self:xy(SongMeterX, 12):zoomto(SongMeterW+4, SongMeterH+4) end },
	Def.Quad{ InitCommand=function(self) self:xy(SongMeterX, 12):zoomto(SongMeterW, SongMeterH):diffuse(0,0,0,1) end },

  -- Song Meter
	Def.SongMeterDisplay{
		StreamWidth=SongMeterW,
		Stream=Def.Quad({
      InitCommand=function(self)
        self:x(SongMeterX-68):horizalign("left"); -- 76 - 4 * 2 = 68?
        self:y(12):zoomy(3):diffuse(GetCurrentColor(true));
      end
    })
	},

	-- Song Title
	LoadFont("Common Normal")..{
		Name="SongTitle",
		InitCommand=function(self) self:xy(SongMeterX, 32):zoom(0.8):shadowlength(0.6):maxwidth(_screen.w/2.5 - 10) end,
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
		InitCommand=function(self) self:xy(SongMeterX, _screen.cy+88):zoom(0.8):shadowlength(0.6):maxwidth(_screen.w/2.5 - 10) end,
		CurrentSongChangedMessageCommand=function(self)
			local song = GAMESTATE:GetCurrentSong()
			self:settext( song:GetDisplayArtist() or "" )
		end
}

-- Song Jacket
t[#t+1] = Def.ActorFrame{
		Name="SongJacket",
		InitCommand=function(self) self:xy(SongMeterX, _screen.cy-24):shadowlength(0.6) end,

	-- border
	Def.Quad{ InitCommand=function(self) self:zoomto(SongMeterW+4, SongMeterW+4) end },
	--Def.Quad{ InitCommand=function(self) self:zoomto(SongMeterW, SongMeterW):diffuse(0,0,0,1) end },

	Def.Sprite {
		OnCommand=function (self)
      local jacket_size = SongMeterW;
			local course = GAMESTATE:GetCurrentCourse();
			if GAMESTATE:IsCourseMode() then
				if course:GetBackgroundPath() then
					self:Load(course:GetBackgroundPath())
					self:setsize(jacket_size, jacket_size);
				else
					self:Load(THEME:GetPathG("", "Common fallback jacket"));
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
						self:Load(THEME:GetPathG("","Common fallback jacket"));
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