local _, ns = ...
local B, C, L, DB = unpack(ns)
local S = B:GetModule("Skins")

function S:BigWigsSkin()
	if not NDuiDB["Skins"]["Bigwigs"] or not IsAddOnLoaded("BigWigs") then return end
	if not BigWigs3DB then return end

	local function removeStyle(bar)
		bar.candyBarBackdrop:Hide()
		local height = bar:Get("bigwigs:restoreheight")
		if height then
			bar:SetHeight(height)
		end

		local tex = bar:Get("bigwigs:restoreicon")
		if tex then
			bar:SetIcon(tex)
			bar:Set("bigwigs:restoreicon", nil)
			bar.candyBarIconFrameBackdrop:Hide()
		end

		bar.candyBarDuration:ClearAllPoints()
		bar.candyBarDuration:SetPoint("TOPLEFT", bar.candyBarBar, "TOPLEFT", 2, 0)
		bar.candyBarDuration:SetPoint("BOTTOMRIGHT", bar.candyBarBar, "BOTTOMRIGHT", -2, 0)
		bar.candyBarLabel:ClearAllPoints()
		bar.candyBarLabel:SetPoint("TOPLEFT", bar.candyBarBar, "TOPLEFT", 2, 0)
		bar.candyBarLabel:SetPoint("BOTTOMRIGHT", bar.candyBarBar, "BOTTOMRIGHT", -2, 0)
	end

	local function styleBar(bar)
		local height = bar:GetHeight()
		bar:Set("bigwigs:restoreheight", height)
		bar:SetHeight(height/2)
		bar.candyBarBackdrop:Hide()
		if not bar.styled then
			B.StripTextures(bar.candyBarBar, true)
			B.SetBD(bar.candyBarBar)
			bar.styled = true
		end
		bar:SetTexture(DB.normTex)

		local tex = bar:GetIcon()
		if tex then
			local icon = bar.candyBarIconFrame
			bar:SetIcon(nil)
			icon:SetTexture(tex)
			icon:Show()
			if bar.iconPosition == "RIGHT" then
				icon:SetPoint("BOTTOMLEFT", bar, "BOTTOMRIGHT", 5, 0)
			else
				icon:SetPoint("BOTTOMRIGHT", bar, "BOTTOMLEFT", -5, 0)
			end
			icon:SetSize(height, height)
			bar:Set("bigwigs:restoreicon", tex)
			bar.candyBarIconFrameBackdrop:Hide()

			if not icon.styled then
				B.SetBD(icon)
				icon.styled = true
			end
		end

		bar.candyBarLabel:ClearAllPoints()
		bar.candyBarLabel:SetPoint("LEFT", bar.candyBarBar, "LEFT", 2, 8)
		bar.candyBarLabel:SetPoint("RIGHT", bar.candyBarBar, "RIGHT", -2, 8)
		bar.candyBarLabel:SetFont(DB.Font[1], 13, DB.Font[3])
		bar.candyBarLabel.SetFont = B.Dummy
		bar.candyBarDuration:ClearAllPoints()
		bar.candyBarDuration:SetPoint("RIGHT", bar.candyBarBar, "RIGHT", -2, 8)
		bar.candyBarDuration:SetPoint("LEFT", bar.candyBarBar, "LEFT", 2, 8)
		bar.candyBarDuration:SetFont(DB.Font[1], 13, DB.Font[3])
		bar.candyBarDuration.SetFont = B.Dummy
	end

	local function registerStyle()
		local bars = BigWigs:GetPlugin("Bars", true)
		bars:RegisterBarStyle("NDui", {
			apiVersion = 1,
			version = 2,
			GetSpacing = function(bar) return bar:GetHeight()+5 end,
			ApplyStyle = styleBar,
			BarStopped = removeStyle,
			GetStyleName = function() return "NDui" end,
		})
		hooksecurefunc(bars, "SetBarStyle", function(self, style)
			if style ~= "NDui" then
				self:SetBarStyle("NDui")
			end
		end)
	end

	if IsAddOnLoaded("BigWigs_Plugins") then
		registerStyle()
	else
		local function loadStyle(event, addon)
			if addon == "BigWigs_Plugins" then
				registerStyle()
				B:UnregisterEvent(event, loadStyle)
			end
		end
		B:RegisterEvent("ADDON_LOADED", loadStyle)
	end
end