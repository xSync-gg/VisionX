--b
export type SliderConfig = {
	Min : number,
	Max : number,
	Default : number,
	VALUE : string,
}

local LocalPlayer = game:GetService('Players').LocalPlayer;
local TextService = game:GetService('TextService')
local TweenService = game:GetService('TweenService')
local UserInputService = game:GetService('UserInputService')
local HttpService = game:GetService('HttpService')

local ModernUI = {
	Config = {
		['UI Size'] = UDim2.new(0, 680, 0, 450),
		['MainColor'] = Color3.fromRGB(61, 207, 117),
		['DropColor'] = Color3.fromRGB(25, 102, 61),
		['BackgroundColor'] = Color3.fromRGB(20, 20, 20),
		['SecondaryColor'] = Color3.fromRGB(30, 30, 30),
		['TextColor'] = Color3.fromRGB(255, 255, 255)
	},
	CoreGui = game:FindFirstChild('CoreGui') or LocalPlayer.PlayerGui,
	Windows = {},
	Icons = (function()
		local Table;
		pcall(function()
			Table = game:HttpGet("https://raw.githubusercontent.com/Baconamassado/lucideblox-icons/refs/heads/main/icons.json")
		end)
		if not Table then
			Table = '{"icons":{}}'
		end
		local _,cal = pcall(HttpService.JSONDecode,HttpService,Table)
		return (_ and cal) or {['icons'] = {}}
	end)()
}

local ProtectGui = protectgui or (syn and syn.protect_gui) or (function() end);

local function createButton(parent)
	local button = Instance.new('TextButton')
	button.Size = UDim2.new(1,0,1,0)
	button.BackgroundTransparency = 1
	button.TextTransparency = 1
	button.Text = ""
	button.Parent = parent
	button.ZIndex = 5000
	return button
end

function ModernUI:GetTextSize(TextLabel:TextLabel)
	return TextService:GetTextSize(TextLabel.Text,TextLabel.TextSize,TextLabel.Font,Vector2.new(math.huge,math.huge))
end

function ModernUI:GetId(Original:string)
	if Original:find('rbxassetid://') or Original:find('=') then
		return Original
	end
	if ModernUI['Icons']['icons'][Original] then
		return ModernUI['Icons']['icons'][Original]
	end
	return "rbxassetid://"..Original
end

local function setupScrolling(scrollframe:ScrollingFrame)
	task.spawn(function()
		local UIListLayout:UIListLayout = scrollframe:WaitForChild('UIListLayout',9999999)
		scrollframe.CanvasSize = UDim2.new(0,0,0,UIListLayout.AbsoluteContentSize.Y+10)
		UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
			scrollframe.CanvasSize = UDim2.new(0,0,0,UIListLayout.AbsoluteContentSize.Y+10)
		end)
	end)
end

function ModernUI:NewWindow(WindowName:string, WindowDescription:string, WindowLogo:string)
	WindowName = WindowName or "Modern UI"
	WindowDescription = WindowDescription or "Redesigned Interface"
	WindowLogo = WindowLogo or '0'

	local WindowObj = {
		Toggle = Enum.KeyCode.LeftControl,
		Tabs = {},
		TabSelect = 1
	}

	-- Main UI Structure
	local ScreenGui = Instance.new("ScreenGui")
	local MainFrame = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local DropShadow = Instance.new("ImageLabel")
	
	-- Header
	local Header = Instance.new("Frame")
	local Logo = Instance.new("ImageLabel")
	local Title = Instance.new("TextLabel")
	local Description = Instance.new("TextLabel")
	
	-- Navigation
	local Navigation = Instance.new("Frame")
	local NavScroll = Instance.new("ScrollingFrame")
	local NavList = Instance.new("UIListLayout")
	
	-- Content Area
	local ContentArea = Instance.new("Frame")
	local ContentCorner = Instance.new("UICorner")

	-- Properties
	ScreenGui.Name = "ModernUI"
	ScreenGui.Parent = ModernUI.CoreGui
	ScreenGui.ResetOnSpawn = false
	ScreenGui.IgnoreGuiInset = true
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
	ProtectGui(ScreenGui)

	MainFrame.Parent = ScreenGui
	MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	MainFrame.BackgroundColor3 = ModernUI.Config.BackgroundColor
	MainFrame.BorderSizePixel = 0
	MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	MainFrame.Size = UDim2.fromScale(0,0)
	MainFrame.ClipsDescendants = true

	UICorner.CornerRadius = UDim.new(0, 8)
	UICorner.Parent = MainFrame

	DropShadow.Name = "DropShadow"
	DropShadow.Parent = MainFrame
	DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
	DropShadow.BackgroundTransparency = 1
	DropShadow.BorderSizePixel = 0
	DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
	DropShadow.Size = UDim2.new(1, 47, 1, 47)
	DropShadow.ZIndex = 0
	DropShadow.Image = "rbxassetid://6015897843"
	DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	DropShadow.ImageTransparency = 0.5
	DropShadow.ScaleType = Enum.ScaleType.Slice
	DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)

	-- Header Setup
	Header.Name = "Header"
	Header.Parent = MainFrame
	Header.BackgroundColor3 = ModernUI.Config.SecondaryColor
	Header.BorderSizePixel = 0
	Header.Size = UDim2.new(1, 0, 0, 60)
	Header.ZIndex = 2

	Logo.Name = "Logo"
	Logo.Parent = Header
	Logo.BackgroundTransparency = 1
	Logo.Position = UDim2.new(0, 15, 0.5, -20)
	Logo.Size = UDim2.new(0, 40, 0, 40)
	Logo.ZIndex = 3
	Logo.Image = ModernUI:GetId(WindowLogo)

	Title.Name = "Title"
	Title.Parent = Header
	Title.BackgroundTransparency = 1
	Title.Position = UDim2.new(0, 65, 0, 8)
	Title.Size = UDim2.new(0, 200, 0, 20)
	Title.ZIndex = 3
	Title.Font = Enum.Font.GothamBold
	Title.Text = WindowName
	Title.TextColor3 = ModernUI.Config.TextColor
	Title.TextSize = 18
	Title.TextXAlignment = Enum.TextXAlignment.Left

	Description.Name = "Description"
	Description.Parent = Header
	Description.BackgroundTransparency = 1
	Description.Position = UDim2.new(0, 65, 0, 32)
	Description.Size = UDim2.new(0, 200, 0, 16)
	Description.ZIndex = 3
	Description.Font = Enum.Font.Gotham
	Description.Text = WindowDescription
	Description.TextColor3 = Color3.fromRGB(180, 180, 180)
	Description.TextSize = 12
	Description.TextXAlignment = Enum.TextXAlignment.Left

	-- Navigation Setup
	Navigation.Name = "Navigation"
	Navigation.Parent = MainFrame
	Navigation.BackgroundColor3 = ModernUI.Config.SecondaryColor
	Navigation.BorderSizePixel = 0
	Navigation.Position = UDim2.new(0, 0, 0, 60)
	Navigation.Size = UDim2.new(0, 180, 1, -60)
	Navigation.ZIndex = 2

	NavScroll.Name = "NavScroll"
	NavScroll.Parent = Navigation
	NavScroll.Active = true
	NavScroll.BackgroundTransparency = 1
	NavScroll.BorderSizePixel = 0
	NavScroll.Position = UDim2.new(0, 0, 0, 10)
	NavScroll.Size = UDim2.new(1, 0, 1, -20)
	NavScroll.ZIndex = 3
	NavScroll.ScrollBarThickness = 0

	NavList.Parent = NavScroll
	NavList.SortOrder = Enum.SortOrder.LayoutOrder
	NavList.Padding = UDim.new(0, 5)

	setupScrolling(NavScroll)

	-- Content Area Setup
	ContentArea.Name = "ContentArea"
	ContentArea.Parent = MainFrame
	ContentArea.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	ContentArea.BorderSizePixel = 0
	ContentArea.Position = UDim2.new(0, 180, 0, 60)
	ContentArea.Size = UDim2.new(1, -180, 1, -60)
	ContentArea.ClipsDescendants = true
	ContentArea.ZIndex = 2

	ContentCorner.CornerRadius = UDim.new(0, 8)
	ContentCorner.Parent = ContentArea

	-- Animation
	TweenService:Create(MainFrame, TweenInfo.new(1, Enum.EasingStyle.Back), {Size = ModernUI.Config["UI Size"]}):Play()

	-- Toggle functionality
	local isVisible = true
	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		if input.KeyCode == WindowObj.Toggle then
			isVisible = not isVisible
			if isVisible then
				TweenService:Create(MainFrame, TweenInfo.new(0.5), {Size = ModernUI.Config["UI Size"]}):Play()
			else
				TweenService:Create(MainFrame, TweenInfo.new(0.5), {Size = UDim2.fromScale(0,0)}):Play()
			end
		end
	end)

	-- Dragging
	local dragToggle, dragStart, startPos = nil, nil, nil
	local function updateInput(input)
		local delta = input.Position - dragStart
		local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		TweenService:Create(MainFrame, TweenInfo.new(0.1), {Position = position}):Play()
	end

	Header.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragToggle = true
			dragStart = input.Position
			startPos = MainFrame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragToggle = false
				end
			end)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			if dragToggle then
				updateInput(input)
			end
		end
	end)

	function WindowObj:AddTab(tabName:string, tabIcon:string)
		local TabObj = {}
		local tabIndex = #WindowObj.Tabs + 1

		-- Create tab button
		local TabButton = Instance.new("Frame")
		local TabCorner = Instance.new("UICorner")
		local TabIcon = Instance.new("ImageLabel")
		local TabText = Instance.new("TextLabel")
		local TabClickArea = Instance.new("TextButton")

		TabButton.Name = "TabButton"
		TabButton.Parent = NavScroll
		TabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
		TabButton.BorderSizePixel = 0
		TabButton.Size = UDim2.new(1, -10, 0, 45)
		TabButton.ZIndex = 4

		TabCorner.CornerRadius = UDim.new(0, 6)
		TabCorner.Parent = TabButton

		TabIcon.Name = "TabIcon"
		TabIcon.Parent = TabButton
		TabIcon.BackgroundTransparency = 1
		TabIcon.Position = UDim2.new(0, 12, 0.5, -10)
		TabIcon.Size = UDim2.new(0, 20, 0, 20)
		TabIcon.ZIndex = 5
		TabIcon.Image = ModernUI:GetId(tabIcon or "hash")
		TabIcon.ImageColor3 = Color3.fromRGB(180, 180, 180)

		TabText.Name = "TabText"
		TabText.Parent = TabButton
		TabText.BackgroundTransparency = 1
		TabText.Position = UDim2.new(0, 40, 0, 0)
		TabText.Size = UDim2.new(1, -50, 1, 0)
		TabText.ZIndex = 5
		TabText.Font = Enum.Font.GothamMedium
		TabText.Text = tabName or "Tab"
		TabText.TextColor3 = Color3.fromRGB(180, 180, 180)
		TabText.TextSize = 14
		TabText.TextXAlignment = Enum.TextXAlignment.Left

		TabClickArea.Name = "ClickArea"
		TabClickArea.Parent = TabButton
		TabClickArea.BackgroundTransparency = 1
		TabClickArea.Size = UDim2.new(1, 0, 1, 0)
		TabClickArea.ZIndex = 6
		TabClickArea.Text = ""

		-- Create tab content
		local TabContent = Instance.new("ScrollingFrame")
		local ContentList = Instance.new("UIListLayout")

		TabContent.Name = "TabContent"
		TabContent.Parent = ContentArea
		TabContent.Active = true
		TabContent.BackgroundTransparency = 1
		TabContent.BorderSizePixel = 0
		TabContent.Position = UDim2.new(0, 15, 0, 15)
		TabContent.Size = UDim2.new(1, -30, 1, -30)
		TabContent.ZIndex = 3
		TabContent.ScrollBarThickness = 2
		TabContent.ScrollBarImageColor3 = ModernUI.Config.MainColor
		TabContent.Visible = false

		ContentList.Parent = TabContent
		ContentList.SortOrder = Enum.SortOrder.LayoutOrder
		ContentList.Padding = UDim.new(0, 8)

		setupScrolling(TabContent)

		-- Tab selection logic
		local function selectTab(isSelected)
			if isSelected then
				TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundColor3 = ModernUI.Config.MainColor}):Play()
				TweenService:Create(TabIcon, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(255, 255, 255)}):Play()
				TweenService:Create(TabText, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
				TabContent.Visible = true
			else
				TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
				TweenService:Create(TabIcon, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(180, 180, 180)}):Play()
				TweenService:Create(TabText, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(180, 180, 180)}):Play()
				TabContent.Visible = false
			end
		end

		if tabIndex == 1 then
			selectTab(true)
		end

		TabClickArea.MouseButton1Click:Connect(function()
			WindowObj.TabSelect = tabIndex
			for i, tab in ipairs(WindowObj.Tabs) do
				tab.SelectFunction(i == tabIndex)
			end
		end)

		table.insert(WindowObj.Tabs, {Button = TabButton, Content = TabContent, SelectFunction = selectTab})

		-- Tab methods
		function TabObj:AddSection(sectionName:string)
			local SectionObj = {}

			local SectionFrame = Instance.new("Frame")
			local SectionCorner = Instance.new("UICorner")
			local SectionHeader = Instance.new("TextLabel")
			local SectionContent = Instance.new("Frame")
			local SectionList = Instance.new("UIListLayout")

			SectionFrame.Name = "Section"
			SectionFrame.Parent = TabContent
			SectionFrame.BackgroundColor3 = ModernUI.Config.SecondaryColor
			SectionFrame.BorderSizePixel = 0
			SectionFrame.Size = UDim2.new(1, 0, 0, 100)
			SectionFrame.ZIndex = 4

			SectionCorner.CornerRadius = UDim.new(0, 6)
			SectionCorner.Parent = SectionFrame

			SectionHeader.Name = "Header"
			SectionHeader.Parent = SectionFrame
			SectionHeader.BackgroundTransparency = 1
			SectionHeader.Position = UDim2.new(0, 15, 0, 0)
			SectionHeader.Size = UDim2.new(1, -30, 0, 35)
			SectionHeader.ZIndex = 5
			SectionHeader.Font = Enum.Font.GothamBold
			SectionHeader.Text = sectionName or "Section"
			SectionHeader.TextColor3 = ModernUI.Config.TextColor
			SectionHeader.TextSize = 16
			SectionHeader.TextXAlignment = Enum.TextXAlignment.Left

			SectionContent.Name = "Content"
			SectionContent.Parent = SectionFrame
			SectionContent.BackgroundTransparency = 1
			SectionContent.Position = UDim2.new(0, 15, 0, 35)
			SectionContent.Size = UDim2.new(1, -30, 1, -45)
			SectionContent.ZIndex = 5

			SectionList.Parent = SectionContent
			SectionList.SortOrder = Enum.SortOrder.LayoutOrder
			SectionList.Padding = UDim.new(0, 8)

			local function updateSectionSize()
				local totalHeight = 45 + SectionList.AbsoluteContentSize.Y + 10
				SectionFrame.Size = UDim2.new(1, 0, 0, totalHeight)
			end

			SectionList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateSectionSize)
			updateSectionSize()

			function SectionObj:AddLabel(text:string)
				local Label = Instance.new("TextLabel")

				Label.Name = "Label"
				Label.Parent = SectionContent
				Label.BackgroundTransparency = 1
				Label.Size = UDim2.new(1, 0, 0, 25)
				Label.ZIndex = 6
				Label.Font = Enum.Font.Gotham
				Label.Text = text or "Label"
				Label.TextColor3 = Color3.fromRGB(200, 200, 200)
				Label.TextSize = 14
				Label.TextXAlignment = Enum.TextXAlignment.Left

				return {
					SetText = function(newText)
						Label.Text = newText
					end,
					Delete = function()
						Label:Destroy()
					end
				}
			end

			function SectionObj:AddToggle(name:string, default:boolean, callback)
				callback = callback or function() end
				local isToggled = default or false

				local ToggleFrame = Instance.new("Frame")
				local ToggleLabel = Instance.new("TextLabel")
				local ToggleButton = Instance.new("Frame")
				local ToggleCorner = Instance.new("UICorner")
				local ToggleCircle = Instance.new("Frame")
				local CircleCorner = Instance.new("UICorner")
				local ClickArea = Instance.new("TextButton")

				ToggleFrame.Name = "Toggle"
				ToggleFrame.Parent = SectionContent
				ToggleFrame.BackgroundTransparency = 1
				ToggleFrame.Size = UDim2.new(1, 0, 0, 35)
				ToggleFrame.ZIndex = 6

				ToggleLabel.Name = "Label"
				ToggleLabel.Parent = ToggleFrame
				ToggleLabel.BackgroundTransparency = 1
				ToggleLabel.Size = UDim2.new(1, -70, 1, 0)
				ToggleLabel.ZIndex = 7
				ToggleLabel.Font = Enum.Font.Gotham
				ToggleLabel.Text = name or "Toggle"
				ToggleLabel.TextColor3 = ModernUI.Config.TextColor
				ToggleLabel.TextSize = 14
				ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left

				ToggleButton.Name = "Button"
				ToggleButton.Parent = ToggleFrame
				ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
				ToggleButton.BorderSizePixel = 0
				ToggleButton.Position = UDim2.new(1, -55, 0.5, -12)
				ToggleButton.Size = UDim2.new(0, 50, 0, 24)
				ToggleButton.ZIndex = 7

				ToggleCorner.CornerRadius = UDim.new(0, 12)
				ToggleCorner.Parent = ToggleButton

				ToggleCircle.Name = "Circle"
				ToggleCircle.Parent = ToggleButton
				ToggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ToggleCircle.BorderSizePixel = 0
				ToggleCircle.Position = UDim2.new(0, 2, 0.5, -10)
				ToggleCircle.Size = UDim2.new(0, 20, 0, 20)
				ToggleCircle.ZIndex = 8

				CircleCorner.CornerRadius = UDim.new(0, 10)
				CircleCorner.Parent = ToggleCircle

				ClickArea.Name = "ClickArea"
				ClickArea.Parent = ToggleButton
				ClickArea.BackgroundTransparency = 1
				ClickArea.Size = UDim2.new(1, 0, 1, 0)
				ClickArea.ZIndex = 9
				ClickArea.Text = ""

				local function updateToggle()
					if isToggled then
						TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = ModernUI.Config.MainColor}):Play()
						TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {Position = UDim2.new(0, 28, 0.5, -10)}):Play()
					else
						TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
						TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -10)}):Play()
					end
				end

				updateToggle()

				ClickArea.MouseButton1Click:Connect(function()
					isToggled = not isToggled
					updateToggle()
					callback(isToggled)
				end)

				return {
					SetValue = function(value)
						isToggled = value
						updateToggle()
						callback(isToggled)
					end,
					SetText = function(newText)
						ToggleLabel.Text = newText
					end,
					Delete = function()
						ToggleFrame:Destroy()
					end
				}
			end

			function SectionObj:AddButton(name:string, callback)
				callback = callback or function() end

				local ButtonFrame = Instance.new("Frame")
				local Button = Instance.new("TextButton")
				local ButtonCorner = Instance.new("UICorner")
				local ButtonGradient = Instance.new("UIGradient")

				ButtonFrame.Name = "ButtonFrame"
				ButtonFrame.Parent = SectionContent
				ButtonFrame.BackgroundTransparency = 1
				ButtonFrame.Size = UDim2.new(1, 0, 0, 35)
				ButtonFrame.ZIndex = 6

				Button.Name = "Button"
				Button.Parent = ButtonFrame
				Button.BackgroundColor3 = ModernUI.Config.MainColor
				Button.BorderSizePixel = 0
				Button.Size = UDim2.new(1, 0, 1, 0)
				Button.ZIndex = 7
				Button.Font = Enum.Font.GothamMedium
				Button.Text = name or "Button"
				Button.TextColor3 = Color3.fromRGB(255, 255, 255)
				Button.TextSize = 14

				ButtonCorner.CornerRadius = UDim.new(0, 6)
				ButtonCorner.Parent = Button

				ButtonGradient.Color = ColorSequence.new{
					ColorSequenceKeypoint.new(0, ModernUI.Config.MainColor),
					ColorSequenceKeypoint.new(1, ModernUI.Config.DropColor)
				}
				ButtonGradient.Rotation = 90
				ButtonGradient.Parent = Button

				Button.MouseButton1Down:Connect(function()
					TweenService:Create(Button, TweenInfo.new(0.1), {Size = UDim2.new(0.98, 0, 0.9, 0)}):Play()
				end)

				Button.MouseButton1Up:Connect(function()
					TweenService:Create(Button, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 1, 0)}):Play()
				end)

				Button.MouseButton1Click:Connect(callback)

				return {
					SetText = function(newText)
						Button.Text = newText
					end,
					Fire = function()
						callback()
					end,
					Delete = function()
						ButtonFrame:Destroy()
					end
				}
			end

			function SectionObj:AddSlider(name:string, config:SliderConfig, callback)
				config = config or {}
				config.Min = config.Min or 0
				config.Max = config.Max or 100
				config.Default = config.Default or 50
				config.VALUE = config.VALUE or ""
				callback = callback or function() end

				local currentValue = config.Default

				local SliderFrame = Instance.new("Frame")
				local SliderLabel = Instance.new("TextLabel")
				local SliderValue = Instance.new("TextLabel")
				local SliderTrack = Instance.new("Frame")
				local TrackCorner = Instance.new("UICorner")
				local SliderFill = Instance.new("Frame")
				local FillCorner = Instance.new("UICorner")
				local SliderThumb = Instance.new("Frame")
				local ThumbCorner = Instance.new("UICorner")

				SliderFrame.Name = "Slider"
				SliderFrame.Parent = SectionContent
				SliderFrame.BackgroundTransparency = 1
				SliderFrame.Size = UDim2.new(1, 0, 0, 50)
				SliderFrame.ZIndex = 6

				SliderLabel.Name = "Label"
				SliderLabel.Parent = SliderFrame
				SliderLabel.BackgroundTransparency = 1
				SliderLabel.Position = UDim2.new(0, 0, 0, 0)
				SliderLabel.Size = UDim2.new(0.7, 0, 0, 20)
				SliderLabel.ZIndex = 7
				SliderLabel.Font = Enum.Font.Gotham
				SliderLabel.Text = name or "Slider"
				SliderLabel.TextColor3 = ModernUI.Config.TextColor
				SliderLabel.TextSize = 14
				SliderLabel.TextXAlignment = Enum.TextXAlignment.Left

				SliderValue.Name = "Value"
				SliderValue.Parent = SliderFrame
				SliderValue.BackgroundTransparency = 1
				SliderValue.Position = UDim2.new(0.7, 0, 0, 0)
				SliderValue.Size = UDim2.new(0.3, 0, 0, 20)
				SliderValue.ZIndex = 7
				SliderValue.Font = Enum.Font.GothamMedium
				SliderValue.Text = tostring(currentValue) .. config.VALUE
				SliderValue.TextColor3 = ModernUI.Config.MainColor
				SliderValue.TextSize = 14
				SliderValue.TextXAlignment = Enum.TextXAlignment.Right

				SliderTrack.Name = "Track"
				SliderTrack.Parent = SliderFrame
				SliderTrack.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
				SliderTrack.BorderSizePixel = 0
				SliderTrack.Position = UDim2.new(0, 0, 0, 25)
				SliderTrack.Size = UDim2.new(1, 0, 0, 6)
				SliderTrack.ZIndex = 7

				TrackCorner.CornerRadius = UDim.new(0, 3)
				TrackCorner.Parent = SliderTrack

				SliderFill.Name = "Fill"
				SliderFill.Parent = SliderTrack
				SliderFill.BackgroundColor3 = ModernUI.Config.MainColor
				SliderFill.BorderSizePixel = 0
				SliderFill.Size = UDim2.new((currentValue - config.Min) / (config.Max - config.Min), 0, 1, 0)
				SliderFill.ZIndex = 8

				FillCorner.CornerRadius = UDim.new(0, 3)
				FillCorner.Parent = SliderFill

				SliderThumb.Name = "Thumb"
				SliderThumb.Parent = SliderTrack
				SliderThumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				SliderThumb.BorderSizePixel = 0
				SliderThumb.Position = UDim2.new((currentValue - config.Min) / (config.Max - config.Min), -6, 0.5, -6)
				SliderThumb.Size = UDim2.new(0, 12, 0, 12)
				SliderThumb.ZIndex = 9

				ThumbCorner.CornerRadius = UDim.new(0, 6)
				ThumbCorner.Parent = SliderThumb

				local dragging = false

				local function updateSlider(input)
					local percentage = math.clamp((input.Position.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X, 0, 1)
					currentValue = math.floor(config.Min + (config.Max - config.Min) * percentage)
					
					SliderValue.Text = tostring(currentValue) .. config.VALUE
					TweenService:Create(SliderFill, TweenInfo.new(0.1), {Size = UDim2.new(percentage, 0, 1, 0)}):Play()
					TweenService:Create(SliderThumb, TweenInfo.new(0.1), {Position = UDim2.new(percentage, -6, 0.5, -6)}):Play()
					
					callback(currentValue)
				end

				SliderTrack.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						dragging = true
						updateSlider(input)
					end
				end)

				SliderTrack.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						dragging = false
					end
				end)

				UserInputService.InputChanged:Connect(function(input)
					if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
						updateSlider(input)
					end
				end)

				return {
					SetValue = function(value)
						currentValue = math.clamp(value, config.Min, config.Max)
						local percentage = (currentValue - config.Min) / (config.Max - config.Min)
						SliderValue.Text = tostring(currentValue) .. config.VALUE
						TweenService:Create(SliderFill, TweenInfo.new(0.1), {Size = UDim2.new(percentage, 0, 1, 0)}):Play()
						TweenService:Create(SliderThumb, TweenInfo.new(0.1), {Position = UDim2.new(percentage, -6, 0.5, -6)}):Play()
						callback(currentValue)
					end,
					SetText = function(newText)
						SliderLabel.Text = newText
					end,
					Delete = function()
						SliderFrame:Destroy()
					end
				}
			end

			function SectionObj:AddDropdown(name:string, options:{any}, default:any, maxSelect:number, callback)
				options = options or {"Option 1", "Option 2"}
				maxSelect = maxSelect or 1
				callback = callback or function() end
				
				local selectedItems = {}
				if default then
					if maxSelect == 1 then
						selectedItems = {default}
					else
						selectedItems = type(default) == "table" and default or {default}
					end
				end

				local DropdownFrame = Instance.new("Frame")
				local DropdownLabel = Instance.new("TextLabel")
				local DropdownButton = Instance.new("Frame")
				local ButtonCorner = Instance.new("UICorner")
				local DropdownText = Instance.new("TextLabel")
				local DropdownIcon = Instance.new("ImageLabel")
				local ClickArea = Instance.new("TextButton")
				
				-- Dropdown content
				local DropdownContent = Instance.new("Frame")
				local ContentCorner = Instance.new("UICorner")
				local SearchFrame = Instance.new("Frame")
				local SearchBox = Instance.new("TextBox")
				local SearchCorner = Instance.new("UICorner")
				local OptionsScroll = Instance.new("ScrollingFrame")
				local OptionsList = Instance.new("UIListLayout")

				DropdownFrame.Name = "Dropdown"
				DropdownFrame.Parent = SectionContent
				DropdownFrame.BackgroundTransparency = 1
				DropdownFrame.Size = UDim2.new(1, 0, 0, 35)
				DropdownFrame.ZIndex = 6
				DropdownFrame.ClipsDescendants = false

				DropdownLabel.Name = "Label"
				DropdownLabel.Parent = DropdownFrame
				DropdownLabel.BackgroundTransparency = 1
				DropdownLabel.Size = UDim2.new(1, 0, 0, 20)
				DropdownLabel.ZIndex = 7
				DropdownLabel.Font = Enum.Font.Gotham
				DropdownLabel.Text = name or "Dropdown"
				DropdownLabel.TextColor3 = ModernUI.Config.TextColor
				DropdownLabel.TextSize = 14
				DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left

				DropdownButton.Name = "Button"
				DropdownButton.Parent = DropdownFrame
				DropdownButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
				DropdownButton.BorderSizePixel = 0
				DropdownButton.Position = UDim2.new(0, 0, 0, 22)
				DropdownButton.Size = UDim2.new(1, 0, 0, 30)
				DropdownButton.ZIndex = 7

				ButtonCorner.CornerRadius = UDim.new(0, 6)
				ButtonCorner.Parent = DropdownButton

				DropdownText.Name = "Text"
				DropdownText.Parent = DropdownButton
				DropdownText.BackgroundTransparency = 1
				DropdownText.Position = UDim2.new(0, 10, 0, 0)
				DropdownText.Size = UDim2.new(1, -40, 1, 0)
				DropdownText.ZIndex = 8
				DropdownText.Font = Enum.Font.Gotham
				DropdownText.Text = #selectedItems > 0 and table.concat(selectedItems, ", ") or "Select..."
				DropdownText.TextColor3 = Color3.fromRGB(200, 200, 200)
				DropdownText.TextSize = 12
				DropdownText.TextXAlignment = Enum.TextXAlignment.Left
				DropdownText.TextTruncate = Enum.TextTruncate.AtEnd

				DropdownIcon.Name = "Icon"
				DropdownIcon.Parent = DropdownButton
				DropdownIcon.BackgroundTransparency = 1
				DropdownIcon.Position = UDim2.new(1, -25, 0.5, -8)
				DropdownIcon.Size = UDim2.new(0, 16, 0, 16)
				DropdownIcon.ZIndex = 8
				DropdownIcon.Image = "rbxassetid://7733717447"
				DropdownIcon.ImageColor3 = Color3.fromRGB(200, 200, 200)

				ClickArea.Name = "ClickArea"
				ClickArea.Parent = DropdownButton
				ClickArea.BackgroundTransparency = 1
				ClickArea.Size = UDim2.new(1, 0, 1, 0)
				ClickArea.ZIndex = 9
				ClickArea.Text = ""

				-- Dropdown content setup
				DropdownContent.Name = "Content"
				DropdownContent.Parent = DropdownFrame
				DropdownContent.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
				DropdownContent.BorderSizePixel = 0
				DropdownContent.Position = UDim2.new(0, 0, 0, 55)
				DropdownContent.Size = UDim2.new(1, 0, 0, 0)
				DropdownContent.Visible = false
				DropdownContent.ZIndex = 15
				DropdownContent.ClipsDescendants = true

				ContentCorner.CornerRadius = UDim.new(0, 6)
				ContentCorner.Parent = DropdownContent

				-- Search box
				SearchFrame.Name = "SearchFrame"
				SearchFrame.Parent = DropdownContent
				SearchFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
				SearchFrame.BorderSizePixel = 0
				SearchFrame.Position = UDim2.new(0, 8, 0, 8)
				SearchFrame.Size = UDim2.new(1, -16, 0, 25)
				SearchFrame.ZIndex = 16

				SearchCorner.CornerRadius = UDim.new(0, 4)
				SearchCorner.Parent = SearchFrame

				SearchBox.Name = "SearchBox"
				SearchBox.Parent = SearchFrame
				SearchBox.BackgroundTransparency = 1
				SearchBox.Position = UDim2.new(0, 8, 0, 0)
				SearchBox.Size = UDim2.new(1, -16, 1, 0)
				SearchBox.ZIndex = 17
				SearchBox.Font = Enum.Font.Gotham
				SearchBox.PlaceholderText = "Search options..."
				SearchBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
				SearchBox.Text = ""
				SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
				SearchBox.TextSize = 12
				SearchBox.TextXAlignment = Enum.TextXAlignment.Left

				-- Options scroll
				OptionsScroll.Name = "OptionsScroll"
				OptionsScroll.Parent = DropdownContent
				OptionsScroll.Active = true
				OptionsScroll.BackgroundTransparency = 1
				OptionsScroll.BorderSizePixel = 0
				OptionsScroll.Position = UDim2.new(0, 5, 0, 40)
				OptionsScroll.Size = UDim2.new(1, -10, 1, -45)
				OptionsScroll.ZIndex = 16
				OptionsScroll.ScrollBarThickness = 2
				OptionsScroll.ScrollBarImageColor3 = ModernUI.Config.MainColor

				OptionsList.Parent = OptionsScroll
				OptionsList.SortOrder = Enum.SortOrder.LayoutOrder
				OptionsList.Padding = UDim.new(0, 2)

				setupScrolling(OptionsScroll)

				local isOpen = false
				local optionButtons = {}

				local function updateDropdownText()
					if #selectedItems > 0 then
						DropdownText.Text = table.concat(selectedItems, ", ")
						DropdownText.TextColor3 = Color3.fromRGB(255, 255, 255)
					else
						DropdownText.Text = "Select..."
						DropdownText.TextColor3 = Color3.fromRGB(200, 200, 200)
					end
				end

				local function createOptionButton(option)
					local OptionFrame = Instance.new("Frame")
					local OptionButton = Instance.new("TextButton")
					local OptionCorner = Instance.new("UICorner")
					local OptionCheck = Instance.new("Frame")
					local CheckCorner = Instance.new("UICorner")
					local CheckIcon = Instance.new("ImageLabel")

					OptionFrame.Name = "OptionFrame"
					OptionFrame.Parent = OptionsScroll
					OptionFrame.BackgroundTransparency = 1
					OptionFrame.Size = UDim2.new(1, 0, 0, 25)
					OptionFrame.ZIndex = 17

					OptionButton.Name = "OptionButton"
					OptionButton.Parent = OptionFrame
					OptionButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
					OptionButton.BorderSizePixel = 0
					OptionButton.Size = UDim2.new(1, 0, 1, 0)
					OptionButton.ZIndex = 18
					OptionButton.Font = Enum.Font.Gotham
					OptionButton.Text = "  " .. tostring(option)
					OptionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
					OptionButton.TextSize = 12
					OptionButton.TextXAlignment = Enum.TextXAlignment.Left

					OptionCorner.CornerRadius = UDim.new(0, 4)
					OptionCorner.Parent = OptionButton

					if maxSelect > 1 then
						OptionCheck.Name = "Check"
						OptionCheck.Parent = OptionButton
						OptionCheck.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
						OptionCheck.BorderSizePixel = 0
						OptionCheck.Position = UDim2.new(1, -20, 0.5, -8)
						OptionCheck.Size = UDim2.new(0, 16, 0, 16)
						OptionCheck.ZIndex = 19

						CheckCorner.CornerRadius = UDim.new(0, 2)
						CheckCorner.Parent = OptionCheck

						CheckIcon.Name = "CheckIcon"
						CheckIcon.Parent = OptionCheck
						CheckIcon.BackgroundTransparency = 1
						CheckIcon.Size = UDim2.new(1, 0, 1, 0)
						CheckIcon.ZIndex = 20
						CheckIcon.Image = "rbxassetid://3944680095"
						CheckIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
						CheckIcon.ImageTransparency = 1
					end

					local isSelected = table.find(selectedItems, option) ~= nil

					local function updateOption()
						if isSelected then
							OptionButton.BackgroundColor3 = ModernUI.Config.MainColor
							if maxSelect > 1 then
								OptionCheck.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
								CheckIcon.ImageTransparency = 0
							end
						else
							OptionButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
							if maxSelect > 1 then
								OptionCheck.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
								CheckIcon.ImageTransparency = 1
							end
						end
					end

					updateOption()

					OptionButton.MouseButton1Click:Connect(function()
						if maxSelect == 1 then
							selectedItems = {option}
							for _, btn in pairs(optionButtons) do
								if btn.option ~= option then
									btn.isSelected = false
									btn.updateFunction()
								end
							end
							isSelected = true
							isOpen = false
							TweenService:Create(DropdownContent, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 0)}):Play()
							TweenService:Create(DropdownIcon, TweenInfo.new(0.2), {Rotation = 0}):Play()
							wait(0.2)
							DropdownContent.Visible = false
							DropdownFrame.Size = UDim2.new(1, 0, 0, 55)
						else
							isSelected = not isSelected
							if isSelected then
								if #selectedItems < maxSelect then
									table.insert(selectedItems, option)
								else
									isSelected = false
								end
							else
								local index = table.find(selectedItems, option)
								if index then
									table.remove(selectedItems, index)
								end
							end
						end

						updateOption()
						updateDropdownText()
						callback(selectedItems, option)
					end)

					optionButtons[option] = {
						frame = OptionFrame,
						button = OptionButton,
						option = option,
						isSelected = isSelected,
						updateFunction = updateOption
					}
				end

				local function refreshOptions(searchText)
					-- Clear existing options
					for _, btn in pairs(optionButtons) do
						btn.frame:Destroy()
					end
					optionButtons = {}

					-- Create filtered options
					for _, option in ipairs(options) do
						if not searchText or searchText == "" or string.lower(tostring(option)):find(string.lower(searchText)) then
							createOptionButton(option)
						end
					end
				end

				-- Search functionality
				SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
					refreshOptions(SearchBox.Text)
				end)

				-- Toggle dropdown
				ClickArea.MouseButton1Click:Connect(function()
					isOpen = not isOpen
					if isOpen then
						refreshOptions()
						DropdownContent.Visible = true
						DropdownFrame.Size = UDim2.new(1, 0, 0, 180)
						TweenService:Create(DropdownContent, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 125)}):Play()
						TweenService:Create(DropdownIcon, TweenInfo.new(0.2), {Rotation = 180}):Play()
					else
						TweenService:Create(DropdownContent, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 0)}):Play()
						TweenService:Create(DropdownIcon, TweenInfo.new(0.2), {Rotation = 0}):Play()
						wait(0.2)
						DropdownContent.Visible = false
						DropdownFrame.Size = UDim2.new(1, 0, 0, 55)
					end
				end)

				updateDropdownText()

				return {
					SetOptions = function(newOptions)
						options = newOptions
						if isOpen then
							refreshOptions(SearchBox.Text)
						end
					end,
					SetValue = function(value)
						selectedItems = type(value) == "table" and value or {value}
						updateDropdownText()
						if isOpen then
							refreshOptions(SearchBox.Text)
						end
						callback(selectedItems, value)
					end,
					SetText = function(newText)
						DropdownLabel.Text = newText
					end,
					Delete = function()
						DropdownFrame:Destroy()
					end
				}
			end

			return SectionObj
		end

		return TabObj
	end

	return WindowObj
end

return ModernUI
