-----------------------------------------------------------------------------------------
--
-- main.lua
-- This project will be an Air Hockey game
--
-----------------------------------------------------------------------------------------

--Setup

--Hide Status Bar
display.setStatusBar(display.HiddenStatusBar)

local widget = require("widget")

local physics = require("physics") --Create variable
physics.start() -- start the physics engine

--Setup our Gravity for the app
physics.setGravity(0,0) --applies gravity top-down

--Set the drawing mode for the objects
-- "normal", "hybrid", "debug"
physics.setDrawMode("hybrid")


-- VARIABLES

local width = display.contentWidth

local height = display.contentHeight

local blueScore = display.newText("Blue Score: ",165,50,native.systemFont,40)
local changeBlue = 0

local greenScore = display.newText("Green Score: ",600,1340,native.systemFont,40)
local changeGreen = 0

local table = display.newImageRect("images/table.jpg",width/1.25,height/1.25)
table.x = width/2
table.y = height/2

local puck = display.newImageRect("images/puck.png", 100,100)
puck.x = width/2
puck.y = height/2
physics.addBody(puck, "dynamic", {bounce = 2})

local wallRight = display.newRect( 810, 150, 1, 2400 )
wallRight.strokeWidth = 3
wallRight:setFillColor( 0.5 )
wallRight:setStrokeColor( 1, 0, 0 )
wallRight.myName = "wallRight"
physics.addBody(wallRight, "static", {bounce = 1.3})

local wallLeft = display.newRect(-10, 150, 1, 2400 )
wallLeft.strokeWidth = 3
wallLeft:setFillColor( 0.5 )
wallLeft:setStrokeColor( 1, 0, 0 )
wallLeft.myName = "wallLeft"
physics.addBody(wallLeft, "static", {bounce = 1.3})

local wallTopLeft = display.newRect( -10, -10, 1800, 1 )
wallTopLeft.strokeWidth = 3
wallTopLeft:setFillColor( 0.5 )
wallTopLeft:setStrokeColor( 1, 0, 0 )
wallTopLeft.myName = "wallTopLeft"
physics.addBody(wallTopLeft, "static", {bounce = 1.3})


local wallTopRight = display.newRect( -10, -10, 1800, 1 )
wallTopRight.strokeWidth = 3
wallTopRight:setFillColor( 0.5 )
wallTopRight:setStrokeColor( 1, 0, 0 )
wallTopRight.myName = "wallTopRight"
physics.addBody(wallTopRight, "static", {bounce = 1.3})

local wallBottomLeft = display.newRect ( 400, -10, width/1.25, 1)
wallBottomLeft.strokeWidth = 3
wallBottomLeft:setFillColor(0.5)
wallBottomLeft:setStrokeColor(1,0,0)
wallBottomLeft.myName = "wallBottomLeft"
physics.addBody(wallBottomLeft, "static", {bounce = 1.3})

local wallBottomRight = display.newRect( 400, -10, width/1.25, 1)
wallBottomRight.strokeWidth = 3
wallBottomRight:setFillColor(0.5)
wallBottomRight:setStrokeColor(1,0,0)
wallBottomRight.myName = "wallBottomRight"
physics.addBody(wallBottomRight, "static", {bounce = 1.3})

local wallGoalBottom = display.newRect( 400, -10, width/1.25, 1)
wallGoalBottom.strokeWidth = 3
wallGoalBottom:setFillColor(0.5)
wallGoalBottom:setStrokeColor(1,0,0)
wallGoalBottom.myName = "wallGoalBottom"
physics.addBody(wallGoalBottom, "static", {bounce = 1.3})

local wallGoalTop = display.newRect( 400, -10, width/1.25, 1)
wallGoalTop.strokeWidth = 3
wallGoalTop:setFillColor(0.5)
wallGoalTop:setStrokeColor(1,0,0)
wallGoalTop.myName = "wallGoalTop"
physics.addBody(wallGoalTop, "static", {bounce = 1.3})



--FUNCTIONS

function playSoundSmack()
	-- Load the audio stream
	local smack = audio.loadSound( "audio/air-hockey-smack.wav" )

	-- Play the audio on any available channel
	local smackChannel = audio.play( smack )
end

function playSoundCelebration()
	-- Load the audio stream
	local celebration = audio.loadSound( "audio/celebration.wav" )

	-- Play the audio on any available channel
	local celebrationChannel = audio.play( celebration )
end

function playSoundArcade()
	-- Load the audio stream
	local arcade = audio.loadSound( "audio/arcade.wav" )

	-- Play the audio on any available channel
	local arcadeChannel = audio.play( arcade )
end

local function onCollision(event)
	if (event.phase == "began") then
 
		--test to see what objects are colliding
		if ((event.object1.myName == "puck" or event.object1.myName == "wallGoalBottom") and (event.object2.myName == "puck" or event.object2.myName == "wallGoalBottom")) then
			print("collision detected")
			changeBlue = changeBlue + 1
			if(changeBlue > 10 ) then
				changeBlue = 0
			end
			blueScore.text = "Blue Score: " .. countScore
		end
		if (event.object1.myName == "") then
		end
	end
end

local function onTouch(event)
	if (event.phase == "began") then
		touchJoint = physics.newJoint("touch", touchBox1, event.x, event.y)
		return true
		elseif (event.phase == "moved") then
			--If the box is moved by the user, it re-adjusts the coordinates
			touchJoint:setTarget(event.x,event.y)
			return true -- leave the function after began has completed
		elseif(event.phase == "ended" or event.phase == "canceled") then
			-- occurs when the user lets go of the object
			touchJoint:removeSelf()
			touchJoint = nil
			return true

	end
end

Runtime:addEventListener("touch", onTouch )