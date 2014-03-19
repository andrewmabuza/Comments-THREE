local transitionTimer = 1000
local requestedNumber = 0
local windowLightsOff = { .1, .1, .1 }
local windowLightsOn = { .9, .7, .2 }
local buildingBeige = { .515, .395, .355 }
local windowObject = {}
local glyph = {}
local bldgCounter = 0
glyph[0] = { 1, 2, 3, 4, 6, 7, 9, 10, 12, 13, 14, 15 }
glyph[1] = { 3, 6, 9, 12, 15 }
glyph[2] = { 1, 2, 3, 6, 7, 8, 9, 10, 13, 14, 15 }
glyph[3] = { 1, 2, 3, 6, 7, 8, 9, 12, 13, 14, 15 }
glyph[4] = { 1, 3, 4, 6, 7, 8, 9, 12, 15 }
glyph[5] = { 1, 2, 3, 4, 7, 8, 9, 12, 13, 14, 15 }
glyph[6] = { 1, 2, 3, 4, 7, 8, 9, 10, 12, 13, 14, 15 }
glyph[7] = { 1, 2, 3, 6, 9, 12, 15 }
glyph[8] = { 1, 2, 3, 4, 6, 7, 8, 9, 10, 12, 13, 14, 15 }
glyph[9] = { 1, 2, 3, 4, 6, 7, 8, 9, 12, 13, 14, 15 }
local bldgWidth = display.contentWidth * 0.333
local bldgHeight = display.contentHeight * 0.333
local winHoriz = 3
local winVert = 5
local unitWide = bldgWidth / winHoriz
local unitHigh = bldgHeight / winVert
local function linearize( tempX, tempY )
	local myXY = (( tempY - 1 ) * winHoriz ) + tempX
	return myXY
end
local function initializeWindows()
	for i = 1, (winHoriz * winVert) do 
		windowObject[i] = display.newRect(0,0,unitWide * .6 ,unitHigh * .6 )
		windowObject[i].fill = windowLightsOff
	end
end
local function buildingDraw(bldgX,bldgY)
	local tempBldg = display.newRect(0, 0, bldgWidth, bldgHeight)
	tempBldg.x = bldgX
	tempBldg.y = bldgY
	tempBldg.fill = buildingBeige
	return tempBldg
end
local function lightsOutAll()
	for x = 1, winHoriz do
		for y = 1, winVert do
			local xyValue = linearize( x, y )
			windowObject[xyValue].fill = windowLightsOff
		end
	end
end
local function lightsRandomize()
	for x = 1, winHoriz do
		for y = 1, winVert do
			local xyValue = linearize( x, y )
			if math.random() > 0.5 then
				windowObject[xyValue].fill = windowLightsOff
			else
				windowObject[xyValue].fill = windowLightsOn
			end
		end
	end
end
local function lightByNumbers( displayNumber )
	lightsOutAll()
	local qtyEntries = #glyph[ displayNumber ]
	for i = 1, qtyEntries do 
		local tempGlyph = glyph[displayNumber][i]
		windowObject[tempGlyph].fill = windowLightsOn
	end
end
local function windowPlotter(bldgX, bldgY)
	local xLeft = bldgX - (bldgWidth * 0.5)
	local yTop = bldgY - (bldgHeight * 0.5)
	for x = 1, winHoriz do
		for y = 1, winVert do
			locX = (x * unitWide) - (unitWide * 0.5)
			locY = (y * unitHigh) - (unitHigh * 0.5)
			locX = locX + xLeft
			locY = locY + yTop
			local myXY = linearize( x, y )
			windowObject[myXY].x = locX
			windowObject[myXY].y = locY
		end
	end
end
local function lampsOn (event)
	lightByNumbers ( requestedNumber )
	requestedNumber = ( requestedNumber + 1) % 10
end
local myBldgX = display.contentWidth / 2
local myBldgY = display.contentHeight / 2
local myBuilding = buildingDraw( myBldgX, myBldgY ) 
initializeWindows()
windowPlotter( myBldgX, myBldgY )
local startTime = math.floor( system.getTimer())
requestedNumber = startTime%10
local timerid = timer.performWithDelay(1000, lampsOn, 0)