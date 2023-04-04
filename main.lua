
local plr = owner
--plr.Character.Humanoid.WalkSpeed = 0; plr.Character.Humanoid.JumpPower = 0

local res = Vector2.new(768, 576) / 1.5
local studdiv = 70/1.5

local screen = Instance.new("Part", script)
screen.Anchored = true
screen.Size = Vector3.new(res.x, res.y) / studdiv
screen.CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.new(0, 4, 4) * CFrame.Angles(0, math.rad(180), 0)
screen.CanCollide = false
screen.Transparency = 1

local surface = Instance.new("SurfaceGui", screen)
surface.LightInfluence = 0
surface.ClipsDescendants = true
surface.CanvasSize = res

local realbg = Instance.new("ImageLabel", surface)
realbg.BackgroundColor3 = Color3.new(0, 0, 0)
realbg.BorderSizePixel = 0
realbg.Size = UDim2.new(1, 0, 1, 0)
realbg.ZIndex = -1

local bg = Instance.new("ImageLabel", surface)
bg.BackgroundColor3 = Color3.fromRGB(92, 148, 252)
bg.BorderSizePixel = 0
bg.Size = UDim2.new(1, 0, 1, 0)
bg.ZIndex = 0
bg.ScaleType = "Fit"

local TweenS = game:service("TweenService")
--------------------------------------------------------------------
-- Utils
local Utils = {}
function Utils:Create(InstData, Props)
	local Obj = Instance.new(InstData[1], InstData[2])
	for k, v in pairs (Props) do
		Obj[k] = v
	end; if Obj:IsA("ImageLabel") or Obj:IsA("ImageButton") then
		Obj.ResampleMode = "Pixelated"
	end
	return Obj
end
--------------------------------------------------------------------

local tween = {
	LINEAR = Enum.EasingStyle.Linear,
}
local display = {
	bg = bg,
	canvas = surface,
	part = screen,
	
	colorlist = {
		defaultblue = Color3.fromRGB(65, 111, 166)
	},
	text = {
		size = {
			title1 = 20,
		},
		shadow = .5 -- shadow transparency
	},
	-- funcs --
	fade = function(text) -- simple fade. not to be used as a transition
		TweenS:Create(text, TweenInfo.new(.5, tween.LINEAR), {TextTransparency = 1}):Play()
		TweenS:Create(text.shadow, TweenInfo.new(.5, tween.LINEAR), {TextTransparency = 1}):Play()
		game.Debris:AddItem(text, .55)
	end,
	-----------
	transitions = {
		title1 = { -- 1 line title
			ZoomIn = function(self, duration, text)
				text.TextTransparency = 1
				text.Size = UDim2.new(0, 0, 0, 0)
				text.shadow.TextTransparency = 1
				local newsize = game:GetService("TextService"):GetTextSize(text.Text, 1000, text.Font, res)
				--print(newsize)
				TweenS:Create(text, TweenInfo.new(1, tween.LINEAR), {TextTransparency = 0}):Play() --  + (duration - .75)
				TweenS:Create(text.shadow, TweenInfo.new(1, tween.LINEAR), {TextTransparency = self.text.shadow}):Play()
				TweenS:Create(text, TweenInfo.new(3, tween.LINEAR), {Size = UDim2.new(.75, 0, .75, 0)}):Play()
				task.wait(duration-1) -- used to be -.5
				self.fade(text)
			end,
			SpinIn = function(self, duration, text)
				text.Rotation = 360*2
				text.Size = UDim2.new(0, 0, 0, 0)
				--print(newsize)
				TweenS:Create(text, TweenInfo.new(1, tween.LINEAR), {Rotation = 0}):Play()
				TweenS:Create(text, TweenInfo.new(2, tween.LINEAR), {Size = UDim2.new(.75, 0, .75, 0)}):Play()
				task.wait(duration-1)
				self.fade(text)
			end,
			FlyInTopLeft = function(self, duration, text)
				text.Position = UDim2.new(-.5, 0, -.5, 0)
				text.TextTransparency = 1
				text.shadow.TextTransparency = 1
				TweenS:Create(text, TweenInfo.new(1, tween.LINEAR), {TextTransparency = 0}):Play()
				TweenS:Create(text.shadow, TweenInfo.new(1, tween.LINEAR), {TextTransparency = self.text.shadow}):Play()
				TweenS:Create(text, TweenInfo.new(1, tween.LINEAR), {Position = UDim2.new(.5, 0, .5, 0)}):Play()
				task.wait(duration-1)
				TweenS:Create(text, TweenInfo.new(1, tween.LINEAR), {Position = UDim2.new(1.5, 0, 1.5, 0)}):Play()
				TweenS:Create(text, TweenInfo.new(1, tween.LINEAR), {TextTransparency = 1}):Play()
				TweenS:Create(text.shadow, TweenInfo.new(1, tween.LINEAR), {TextTransparency = 1}):Play()
				game.Debris:AddItem(text, 1)
			end,
		},
		title2 = { -- 2 line title
			FadeInAndOut = function(self, text1, text2)
				
			end,
		},
		noshadow = {
			title1 = {}, title2 = {}
		}
	}
}

-- xd'ing around --
bg.BackgroundColor3 = display.colorlist.defaultblue
-------------------

function display:changeRes(to)
	res = to
	if self.part then
		self.part.Size = Vector3.new(to.x, to.y) / studdiv
	end
	if self.canvas then
		self.canvas.CanvasSize = to
	end
end
function display:setBgColor(rgb)
	
end
function display:newText(props, shadow)
	local text = Utils:Create({"TextLabel", self.bg}, {
		TextColor3 = props.textcolor or Color3.new(1, 1, 1),
		Font = props.font or Enum.Font.Kalam,
		Size = props.size or UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		TextWrapped = true,
		Text = props.text or "",
		TextScaled = true,
		AnchorPoint = Vector2.new(.5, .5),
		Position = props.pos or UDim2.new(.5, 0, .5, 0),
		ZIndex = 2
		--TextEditable = false,
	}); if shadow then
		Utils:Create({"TextLabel", text}, {
			TextColor3 = Color3.new(0, 0, 0),
			Font = text.Font,
			BackgroundTransparency = 1,
			TextTransparency = self.text.shadow,
			TextWrapped = true,
			Text = props.text or "",
			TextScaled = true,
			Position = UDim2.new(0, 4, 0, 4),
			Size = UDim2.new(1, 0, 1, 0),
			ZIndex = 1,
			Name = "shadow"
		});
	end
	return text
end
function display:newTitle(props, props2)
	local text = self:newText(props, true)
	if not props2 then
		self.transitions.title1[props.transition](self, props.duration or 2, text)
	end
	return text
end
function display:playVideo(vid)
	for i,v in vid do
		task.delay(v.time, function()
			self.bg.BackgroundColor3 = v.bgcolor3 or self.colorlist[v.bgcolor] or bg.BackgroundColor3
			if v.bgimage then
				self.bg.Image = v.bgimage
				self.bg.BackgroundTransparency = 1
				print("yes", self.bg.Image, self.bg.BackgroundTransparency)
				task.delay(v.ends, function()
					self.bg.BackgroundTransparency = 0
					self.bg.Image = ""
				end)
			end
			if v.display == "title1" then
				self:newTitle({
					transition = v.transition,
					text = v.content,
					duration = v.ends
				})
			end
		end)
	end
end

-- test

--[[display:newTitle({
	transition = "ZoomIn",
	text = "Aaa",
	duration = 3
})]]

display:playVideo({
	{
		time = 0,
		ends = 2, -- sec
		display = "title1",
		content = "test",
		transition = "ZoomIn"
	},
	{
		time = 2,
		ends = 3, -- sec
		display = "title1",
		content = "hi guys",
		transition = "SpinIn"
	},
	{
		time = 5,
		ends = 3, -- sec
		display = "title1",
		content = "tis is my first video", --"I think i need to give an update on my current situation guys",
		transition = "FlyInTopLeft"
	},
	{
		time = 10,
		ends = 3, -- sec
		display = "title1",
		content = "aaa",
		transition = "FlyInTopLeft"
	},
	{
		time = 13,
		ends = 3, -- sec
		display = "",
		bgimage = "rbxassetid://11673018605"
	},
})
