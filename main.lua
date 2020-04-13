-----------------------------------------------------------------------------------------
--
-- main.lua
-- THis program will be an air hockey application
-----------------------------------------------------------------------------------------

--Hide Status Bar
display.setStatusBar(display.HiddenStatusBar)

local widget = require("widget")

--Get the physics engine running
local physics = require("physics") --Create variable
physics.start() -- start the physics engine

--Setup our Gravity for the app
physics.setGravity(0,0) --applies gravity top-down

--Set the drawing mode for the objects
-- "normal", "hybrid", "debug"
physics.setDrawMode("normal")

--VARIABLES

local tableBG = display.newImageRect("images/table.jpg", display.contentWidth/1.2, display.contentHeight/1.2)
	tableBG.x = display.contentCenterX
	tableBG.y = display.contentCenterY

local greenScore = 0
local lblGreenScore = display.newText("Team Green: " .. greenScore, 120, 55, native.systemFont, 30)

local blueScore = 0
local lblBlueScore = display.newText("Team Blue: " .. blueScore, 680, 1355, native.systemFont, 30)

local group = display.newGroup()

-- I found this on the Corona API and thought I would try it
local walls = display.newLine(85, 140, 85, 1280)
	walls:append(244, 1280, 244, 1375, 560, 1375, 560, 1280, 715, 1280, 715, 140, 558, 140, 558, 45, 243, 45, 243, 140, 80, 140)
	walls:setStrokeColor(0)
	walls.strokeWidth = 1
	physics.addBody(walls, "static", {bounce = 0.75})

local topGoalLine = display.newRect(display.contentCenterX + 1, display.contentCenterY - 570, 311, 1)
	physics.addBody(topGoalLine, "static", {bounce = 0, filter = {groupIndex = -1}})

local bottomGoalLine = display.newRect(display.contentCenterX + 1, display.contentCenterY + 570, 311, 1)
	physics.addBody(bottomGoalLine, "static", {bounce = 0, filter = {groupIndex = -1}})

local topGoal = display.newImageRect("images/Goal_Top.png", 311, 70)
	topGoal.x = display.contentCenterX + 1
	topGoal.y = display.contentCenterY - 628
	physics.addBody(topGoal, "static")
	topGoal.myName = "top goal"
	topGoal.isSensor = true

local bottomGoal = display.newImageRect("images/Goal_Bottom.png", 311, 70)
	bottomGoal.x = display.contentCenterX + 1
	bottomGoal.y = display.contentCenterY + 628
	physics.addBody(bottomGoal, "static")
	bottomGoal.myName = "bottom goal"
	bottomGoal.isSensor = true

local puck = display.newImageRect("images/puck.png", 90, 90)
	puck.x = display.contentCenterX
	puck.y = display.contentCenterY
	physics.addBody(puck, "dynamic", {radius = 45, bounce = 0.3, friction = 0.3, filter = {groupIndex = -1}})
	puck.myName = "puck"
	group:insert(puck)

local greenPaddle = display.newImageRect("images/greenPaddle.png", 120, 120)
	greenPaddle.x = display.contentCenterX
	greenPaddle.y = display.contentCenterY - 450
	physics.addBody(greenPaddle, "static", {radius = 60, bounce = 0.0, friction = 0.0})
	greenPaddle.myName = "green paddle"
	group:insert(greenPaddle)

local bluePaddle = display.newImageRect("images/bluePaddle.png", 120, 120)
	bluePaddle.x = display.contentCenterX
	bluePaddle.y = display.contentCenterY + 425
	physics.addBody(bluePaddle, "dynamic", {radius = 60, bounce = 0.0, friction = 0.0})
	bluePaddle.myName = "blue paddle"
	group:insert(bluePaddle)

--FUNCTIONS

local function movePaddle(event)
	display.getCurrentStage():setFocus(event.target)
	local touchJoint = physics.newJoint("touch", event.target, event.target.x, event.target.y)
		touchJoint:setTarget(event.x, event.y)
		touchJoint:removeSelf()
		--event.target:setLinearVelocity(0,0)
	if event.phase == "ended" or event.phase == "cancelled" then
		display.getCurrentStage():setFocus(nil)
	end
end

--This code will move an object named greenPaddle form left to right
--You will still need to add the object as a physics object to the library
local function leftStart()
	local function right()
		local function left()
			--transition the greenPaddle to the right, then when complete call the right() function
			transition.to(greenPaddle,{time=2500, x=greenPaddle.x-500, onComplete=right})
			greenPaddle.xScale=-1
		end
		--transition the greenPaddle to the left, then when complete call the left() function
		transition.to(greenPaddle,{time=2500, x=greenPaddle.x+500, onComplete=left , tag = "animationBlock"})
		greenPaddle.xScale=1
	end
	transition.to(greenPaddle,{time=1250, x=greenPaddle.x-250, onComplete=right})
	greenPaddle.xScale=-1
end

local function reset(event)
	physics.pause()
	if event.phase == "ended" then
		display.remove(group)
		group = display.newGroup()
		local puck = display.newImageRect("images/puck.png", 90, 90)
			puck.x = display.contentCenterX
			puck.y = display.contentCenterY
			physics.addBody(puck, "dynamic", {radius = 45, bounce = 0.3, friction = 0.3, filter = {groupIndex = -1}})
			puck.myName = "puck"
			group:insert(puck)
			puck:setLinearVelocity(0,0)
		local greenPaddle = display.newImageRect("images/greenPaddle.png", 120, 120)
			greenPaddle.x = display.contentCenterX
			greenPaddle.y = display.contentCenterY - 450
			physics.addBody(greenPaddle, "static", {radius = 60, bounce = 0.0, friction = 0.0})
			greenPaddle.myName = "green paddle"
			group:insert(greenPaddle)
		local bluePaddle = display.newImageRect("images/bluePaddle.png", 120, 120)
			bluePaddle.x = display.contentCenterX
			bluePaddle.y = display.contentCenterY + 425
			physics.addBody(bluePaddle, "dynamic", {radius = 60, bounce = 0.0, friction = 0.0})
			bluePaddle.myName = "blue paddle"
			group:insert(bluePaddle)
			bluePaddle:addEventListener("touch", movePaddle)
			bluePaddle:addEventListener("tap", function() return true; end)
			bluePaddle:setLinearVelocity(0,0)
		local function leftStart()
			local function right()
				local function left()
					--transition the greenPaddle to the right, then when complete call the right() function
					transition.to(greenPaddle,{time=2500, x=greenPaddle.x-500, onComplete=right})
					greenPaddle.xScale=-1
				end
				--transition the greenPaddle to the left, then when complete call the left() function
				transition.to(greenPaddle,{time=2500, x=greenPaddle.x+500, onComplete=left , tag = "animationBlock"})
				greenPaddle.xScale=1
			end
			transition.to(greenPaddle,{time=1250, x=greenPaddle.x-250, onComplete=right})
			greenPaddle.xScale=-1
		end
		leftStart()
		greenScore = 0
		lblGreenScore.text = "Team Green: " .. greenScore
		blueScore = 0
		lblBlueScore.text = "Team Blue: " .. blueScore
		-- Load the audio stream (found on corona API)
		local arcadeBG = audio.loadStream("audio/arcade.wav")
		-- Play the audio on any available channel (also found on Corona API)
		local arcadeChannel = audio.play(arcadeBG)

	end
	physics.start()
end

local resetButton = display.newImageRect("images/button.png", 90, 90)
	resetButton.x = 100
	resetButton.y = 1350

function playScoreSound()
	-- Load the audio stream
	local celebration = audio.loadSound("audio/celebration.wav")

	-- Play the audio on any available channel
	local celebrationChannel = audio.play(celebration)
end 

function playSmackSound()
	-- Load the audio stream
	local smack = audio.loadSound("audio/air-hockey-smack.wav")

	-- Play the audio on any available channel
	local smackChannel = audio.play(smack)
	-- I think my audio smack is distorted? its weird
end 

-- Load the audio stream (found on corona API)
local arcadeBG = audio.loadStream("audio/arcade.wav")

-- Play the audio on any available channel (also found on Corona API)
local arcadeChannel = audio.play(arcadeBG)

-- Set up the sheet options
local sheetOptions =
{
    width = 284,
    height = 250,
    numFrames = 3
}


local function onCollision(event)
	if (event.phase == "began") then
		--test to see what objects are colliding
		if (event.object1.myName == "bottom goal" and event.object2.myName == "puck") then
			--Call the method that will play the audio sound
			playScoreSound()
			if (greenScore < 10) then
				greenScore = greenScore + 1
				lblGreenScore.text = "Team Green: " .. greenScore
			elseif (greenScore >= 10) then
				lblGreenScore.text = "Team Green\n       Wins!"
				lblBlueScore.text = "Team Blue\n     Loses"
				physics.pause()
			end
		elseif (event.object1.myName == "top goal" and event.object2.myName == "puck") then
			--Call the method that will play the audio sound
			playScoreSound()
			if (blueScore < 10) then
				blueScore = blueScore + 1
				lblBlueScore.text = "Team Blue: " .. blueScore
			elseif (blueScore >= 10) then
				lblBlueScore.text = "Team Blue\n       Wins!"
				lblGreenScore.text = "Team Green\n    Loses"
				physics.pause()
			end
		elseif ((event.object1.myName == "bluePaddle" or event.object1.myName == "greenPaddle") and event.object2.myName == "puck") then
			playSmackSound()
		elseif (event.object1.myName == "puck" and event.object2.myName == "walls") then
			playSmackSound()
		end
	end
end

-- Listeners

resetButton:addEventListener("touch", reset)
resetButton:addEventListener("tap", function() return true; end)

bluePaddle:addEventListener("touch", movePaddle)
bluePaddle:addEventListener("tap", function() return true; end)

Runtime:addEventListener("collision", onCollision)

leftStart()