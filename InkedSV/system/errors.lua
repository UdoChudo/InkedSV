--[[
##########################################################
Inked Shadow Vaults  By: keivamp
########################################################## 
LOCALIZED LUA FUNCTIONS
##########################################################
]]--
--[[ GLOBALS ]]--
local _G = _G;
local unpack        = _G.unpack;
local select        = _G.select;
local pairs         = _G.pairs;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SV = select(2, ...)
local InkedSVLib = Librarian("Registry");
local L = SV.L;
--[[ 
########################################################## 
LOCAL VARS
##########################################################
]]--
local UIErrorsFrame = _G.UIErrorsFrame;
local InkedSV_ErrorsFrame = CreateFrame("Frame", nil);
local ERR_FILTERS = {};
--[[ 
########################################################## 
EVENTS
##########################################################
]]--
local ErrorFrameHandler = function(self, event, msgType, msg)
	if(event == 'PLAYER_REGEN_DISABLED') then
		self:UnregisterEvent('UI_ERROR_MESSAGE')
	elseif(event == 'PLAYER_REGEN_ENABLED') then
		self:RegisterEvent('UI_ERROR_MESSAGE')
	elseif(msg and (not ERR_FILTERS[msg])) then
		UIErrorsFrame:AddMessage(msg, 1.0, 0.1, 0.1, 1.0);
	end
end

local function CacheFilters()
	for k, v in pairs(SV.db.general.errorFilters) do
		ERR_FILTERS[k] = v
	end
	if(ERR_FILTERS[INTERRUPTED]) then
		ERR_FILTERS[SPELL_FAILED_INTERRUPTED] = true
		ERR_FILTERS[SPELL_FAILED_INTERRUPTED_COMBAT] = true
	end
end

function SV:UpdateErrorFilters()
	if(SV.db.general.filterErrors) then
		CacheFilters()
		UIErrorsFrame:UnregisterEvent('UI_ERROR_MESSAGE')
		InkedSV_ErrorsFrame:RegisterEvent('UI_ERROR_MESSAGE')
		if(SV.db.general.hideErrorFrame) then
			InkedSV_ErrorsFrame:RegisterEvent('PLAYER_REGEN_DISABLED')
			InkedSV_ErrorsFrame:RegisterEvent('PLAYER_REGEN_ENABLED')
		end
	else
		UIErrorsFrame:RegisterEvent('UI_ERROR_MESSAGE')
		InkedSV_ErrorsFrame:UnregisterEvent('UI_ERROR_MESSAGE')
		InkedSV_ErrorsFrame:UnregisterEvent('PLAYER_REGEN_DISABLED')
		InkedSV_ErrorsFrame:UnregisterEvent('PLAYER_REGEN_ENABLED')
	end
end
--[[ 
########################################################## 
LOAD
##########################################################
]]--
local function SetErrorFilters()
	if(SV.db.general.filterErrors) then
		CacheFilters()
		UIErrorsFrame:UnregisterEvent('UI_ERROR_MESSAGE')
		InkedSV_ErrorsFrame:RegisterEvent('UI_ERROR_MESSAGE')
		if(SV.db.general.hideErrorFrame) then
			InkedSV_ErrorsFrame:RegisterEvent('PLAYER_REGEN_DISABLED')
			InkedSV_ErrorsFrame:RegisterEvent('PLAYER_REGEN_ENABLED')
		end
		InkedSV_ErrorsFrame:SetScript("OnEvent", ErrorFrameHandler)
	end
end

SV:NewScript(SetErrorFilters)