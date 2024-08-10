local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local ContentProvider = game:GetService("ContentProvider")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()

ContentProvider:PreloadAsync({"rbxassetid://3570695787", "rbxassetid://2708891598", "rbxassetid://4155801252", "rbxassetid://4695575676", "rbxassetid://4155801252"})

local Library = {
    Theme = {
        MainColor = Color3.fromRGB(255, 75, 75),
        BackgroundColor = Color3.fromRGB(37, 150, 190),
        UIToggleKey = Enum.KeyCode.RightControl,
        TextFont = Enum.Font.SourceSansBold,
        EasingStyle = Enum.EasingStyle.Quart
    },
    LibraryColorTable = {},
    TabCount = 0,
    FirstTab = nil,
    CurrentlyBinding = false,
    RainbowColorValue = 0,
    HueSelectionPosition = 0
}

local function DarkenObjectColor(object, amount)
    local ColorR = (object.r * 255) - amount
    local ColorG = (object.g * 255) - amount
    local ColorB = (object.b * 255) - amount
   
    return Color3.fromRGB(ColorR, ColorG, ColorB)
end

local function SetUIAccent(color)
    for i, v in pairs(Library.LibraryColorTable) do
        if HasProperty(v, "ImageColor3") then
            if v ~= "CheckboxOutline" and v.ImageColor3 ~= Color3.fromRGB(65, 65, 65) then
                v.ImageColor3 = color
            end
        end

        if HasProperty(v, "TextColor3") then
            if v.TextColor3 ~= Color3.fromRGB(255, 255, 255) then
                v.TextColor3 = color
            end
        end
    end
end

local function RippleEffect(object)
    spawn(function()
        local Ripple = Instance.new("ImageLabel")

        Ripple.Name = "Ripple"
        Ripple.Parent = object
        Ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Ripple.BackgroundTransparency = 1.000
        Ripple.ZIndex = 8
        Ripple.Image = "rbxassetid://2708891598"
        Ripple.ImageTransparency = 0.800
        Ripple.ScaleType = Enum.ScaleType.Fit

        Ripple.Position = UDim2.new((Mouse.X - Ripple.AbsolutePosition.X) / object.AbsoluteSize.X, 0, (Mouse.Y - Ripple.AbsolutePosition.Y) / object.AbsoluteSize.Y, 0)
        TweenService:Create(Ripple, TweenInfo.new(1, Library.Theme.EasingStyle, Enum.EasingDirection.Out), {Position = UDim2.new(-5.5, 0, -5.5, 0), Size = UDim2.new(12, 0, 12, 0)}):Play()

        wait(0.5)
        TweenService:Create(Ripple, TweenInfo.new(1, Library.Theme.EasingStyle, Enum.EasingDirection.Out), {ImageTransparency = 1}):Play()

        wait(1)
        Ripple:Destroy()
    end)
end

local function MakeDraggable(topbarobject, object)
    local Dragging = nil
    local DragInput = nil
    local DragStart = nil
    local StartPosition = nil
    
    local function Update(input)
        local Delta = input.Position - DragStart
        object.Position = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
    end
    
    topbarobject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPosition = object.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)
    
    topbarobject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            DragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            Update(input)
        end
    end)
end

local UILibrary = Instance.new("ScreenGui")
local Main = Instance.new("ImageLabel")
local Border = Instance.new("ImageLabel")
local Topbar = Instance.new("Frame")
local UITabs = Instance.new("Frame")
local Tabs = Instance.new("Frame")
local TabButtons = Instance.new("ImageLabel")
local TabButtonLayout = Instance.new("UIListLayout")

UILibrary.Name = HttpService:GenerateGUID(false)
UILibrary.Parent = CoreGui
UILibrary.DisplayOrder = 1
UILibrary.ZIndexBehavior = Enum.ZIndexBehavior.Global

Main.Name = "Main"
Main.Parent = UILibrary
Main.BackgroundColor3 = Library.Theme.BackgroundColor
Main.BackgroundTransparency = 1.000
Main.Position = UDim2.new(0.590086579, 0, 0.563882053, 0)
Main.Size = UDim2.new(0, 450, 0, 0)
Main.ZIndex = 2
Main.Image = "rbxassetid://3570695787"
Main.ImageColor3 = Library.Theme.BackgroundColor
Main.ScaleType = Enum.ScaleType.Slice
Main.SliceCenter = Rect.new(100, 100, 100, 100)
Main.SliceScale = 0.050

Border.Name = "Border"
Border.Parent = Main
Border.BackgroundColor3 = Library.Theme.MainColor
Border.BackgroundTransparency = 1.000
Border.Position = UDim2.new(0, -1, 0, -1)
Border.Size = UDim2.new(1, 2, 1, 2)
Border.Image = "rbxassetid://3570695787"
Border.ImageColor3 = Library.Theme.MainColor
Border.ScaleType = Enum.ScaleType.Slice
Border.SliceCenter = Rect.new(100, 100, 100, 100)
Border.SliceScale = 0.050
Border.ImageTransparency = 1

Topbar.Name = "Topbar"
Topbar.Parent = Main
Topbar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Topbar.BackgroundTransparency = 1.000
Topbar.Size = UDim2.new(0, 450, 0, 15)
Topbar.ZIndex = 2

UITabs.Name = "UITabs"
UITabs.Parent = Main
UITabs.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UITabs.BackgroundTransparency = 1.000
UITabs.ClipsDescendants = true
UITabs.Size = UDim2.new(1, 0, 1, 0)

Tabs.Name = "Tabs"
Tabs.Parent = UITabs
Tabs.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Tabs.BackgroundTransparency = 1.000
Tabs.Position = UDim2.new(0, 13, 0, 41)
Tabs.Size = UDim2.new(0, 421, 0, 209)
Tabs.ZIndex = 2

TabButtons.Name = "TabButtons"
TabButtons.Parent = UITabs
TabButtons.BackgroundColor3 = Library.Theme.MainColor
TabButtons.BackgroundTransparency = 1.000
TabButtons.Position = UDim2.new(0, 14, 0, 16)
TabButtons.Size = UDim2.new(0, 419, 0, 25)
TabButtons.ZIndex = 2
TabButtons.Image = "rbxassetid://3570695787"
TabButtons.ImageColor3 = Library.Theme.MainColor
TabButtons.ScaleType = Enum.ScaleType.Slice
TabButtons.SliceCenter = Rect.new(100, 100, 100, 100)
TabButtons.SliceScale = 0.050
TabButtons.ClipsDescendants = true

TabButtonLayout.Name = "TabButtonLayout"
TabButtonLayout.Parent = TabButtons
TabButtonLayout.FillDirection = Enum.FillDirection.Horizontal
TabButtonLayout.SortOrder = Enum.SortOrder.LayoutOrder

TweenService:Create(Main, TweenInfo.new(0.5, Library.Theme.EasingStyle, Enum.EasingDirection.Out), {Size = UDim2.new(0, 450, 0, 250)}):Play()
TweenService:Create(Border, TweenInfo.new(0.5, Library.Theme.EasingStyle, Enum.EasingDirection.Out), {ImageTransparency = 0}):Play()

table.insert(Library.LibraryColorTable, Border)
table.insert(Library.LibraryColorTable, TabButtons)
MakeDraggable(Topbar, Main)

local function CloseAllTabs()
    for i, v in pairs(Tabs:GetChildren()) do
        if v:IsA("Frame") then
            v.Visible = false
        end
    end
end

local function ResetAllTabButtons()
    for i, v in pairs(TabButtons:GetChildren()) do
        if v:IsA("ImageButton") then
            TweenService:Create(v, TweenInfo.new(0.3, Library.Theme.EasingStyle, Enum.EasingDirection.Out), {ImageColor3 = Library.Theme.MainColor}):Play()
        end
    end
end

local function KeepFirstTabOpen()
    for i, v in pairs(Tabs:GetChildren()) do
        if v:IsA("Frame") then
            if v.Name == (Library.FirstTab .. "Tab") then
                v.Visible = true
            else
                v.Visible = false
            end
        end
    end

    for i, v in pairs(TabButtons:GetChildren()) do
        if v:IsA("ImageButton") then
            if v.Name:find(Library.FirstTab .. "TabButton") then
                TweenService:Create(v, TweenInfo.new(0.3, Library.Theme.EasingStyle, Enum.EasingDirection.Out), {ImageColor3 = DarkenObjectColor(Library.Theme.MainColor, 15)}):Play()
            else
                TweenService:Create(v, TweenInfo.new(0.3, Library.Theme.EasingStyle, Enum.EasingDirection.Out), {ImageColor3 = Library.Theme.MainColor}):Play()
            end
        end
    end
end

local function ToggleUI()
    Library.UIOpen = not Library.UIOpen
            
    if Library.UIOpen then
        TweenService:Create(Main, TweenInfo.new(0.5, Library.Theme.EasingStyle, Enum.EasingDirection.Out), {Size = UDim2.new(0, 450, 0, 0)}):Play()
        TweenService:Create(Border, TweenInfo.new(0.5, Library.Theme.EasingStyle, Enum.EasingDirection.Out), {ImageTransparency = 1}):Play()
    elseif not Library.UIOpen then
        TweenService:Create(Main, TweenInfo.new(0.5, Library.Theme.EasingStyle, Enum.EasingDirection.Out), {Size = UDim2.new(0, 450, 0, 250)}):Play()
        TweenService:Create(Border, TweenInfo.new(0.5, Library.Theme.EasingStyle, Enum.EasingDirection.Out), {ImageTransparency = 0}):Play()
    end
end

coroutine.wrap(function()
    while wait() do
        Library.RainbowColorValue = Library.RainbowColorValue + 1/255
        Library.HueSelectionPosition = Library.HueSelectionPosition + 1

        if Library.RainbowColorValue >= 1 then
            Library.RainbowColorValue = 0
        end

        if Library.HueSelectionPosition == 105 then
            Library.HueSelectionPosition = 0
        end
    end
end)()


function Library:CreateTab(name)
    local NameTab = Instance.new("Frame")
    local NameTabButton = Instance.new("ImageButton")
    local Title = Instance.new("TextLabel")
    local SectionLayout = Instance.new("UIListLayout")
    local SectionPadding = Instance.new("UIPadding")
    
    local TabElements = {}
    Library.TabCount = Library.TabCount + 1

    if Library.TabCount == 1 then
        Library.FirstTab = name
    end

    NameTab.Name = (name .. "Tab")
    NameTab.Parent = Tabs
    NameTab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NameTab.BackgroundTransparency = 1.000
    NameTab.Size = UDim2.new(1, 0, 1, 0)
    NameTab.ZIndex = 2

    NameTabButton.Name = (name .. "TabButton")
    NameTabButton.Parent = TabButtons
    NameTabButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NameTabButton.BackgroundTransparency = 1.000
    NameTabButton.Size = UDim2.new(0, 84, 0, 25)
    NameTabButton.ZIndex = 2
    NameTabButton.Image = "rbxassetid://3570695787"
    NameTabButton.ImageColor3 = Library.Theme.MainColor
    NameTabButton.ScaleType = Enum.ScaleType.Slice
    NameTabButton.SliceCenter = Rect.new(100, 100, 100, 100)
    NameTabButton.SliceScale = 0.050
    
    Title.Name = "Title"
    Title.Parent = NameTabButton
    Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundTransparency = 1.000
    Title.Size = UDim2.new(1, 0, 1, 0)
    Title.ZIndex = 2
    Title.Font = Library.Theme.TextFont
    Title.Text =  name
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 15.000

    SectionLayout.Name = "SectionLayout"
    SectionLayout.Parent = NameTab
    SectionLayout.FillDirection = Enum.FillDirection.Horizontal
    SectionLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SectionLayout.Padding = UDim.new(0, 25)

    SectionPadding.Name = "SectionPadding"
    SectionPadding.Parent = NameTab
    SectionPadding.PaddingTop = UDim.new(0, 12)

    NameTab.Visible = true

    table.insert(Library.LibraryColorTable, NameTabButton)
    CloseAllTabs()
    ResetAllTabButtons()
    TweenService:Create(NameTabButton, TweenInfo.new(0.3, Library.Theme.EasingStyle, Enum.EasingDirection.Out), {ImageColor3 = DarkenObjectColor(Library.Theme.MainColor, 15)}):Play()

    KeepFirstTabOpen()

    NameTabButton.MouseButton1Down:Connect(function()
        CloseAllTabs()
        ResetAllTabButtons()

        NameTab.Visible = true
        TweenService:Create(NameTabButton, TweenInfo.new(0.3, Library.Theme.EasingStyle, Enum.EasingDirection.Out), {ImageColor3 = DarkenObjectColor(Library.Theme.MainColor, 15)}):Play()
    end)

    function TabElements:CreateSection(name)
        local NameSection = Instance.new("ImageLabel")
        local SectionBorder = Instance.new("ImageLabel")
        local SectionTitle = Instance.new("TextLabel")
        local SectionContent = Instance.new("ScrollingFrame")
        local SectionContentLayout = Instance.new("UIListLayout")

        local SectionElements = {}

        NameSection.Name = (name .. "Section")
        NameSection.Parent = NameTab
        NameSection.BackgroundColor3 = Library.Theme.MainColor
        NameSection.BackgroundTransparency = 1.000
        NameSection.Position = UDim2.new(0, 0, 0.0574162677, 0)
        NameSection.Size = UDim2.new(0, 197, 0, 181)
        NameSection.ZIndex = 4
        NameSection.Image = "rbxassetid://3570695787"
        NameSection.ImageColor3 = Library.Theme.BackgroundColor
        NameSection.ScaleType = Enum.ScaleType.Slice
        NameSection.SliceCenter = Rect.new(100, 100, 100, 100)
        NameSection.SliceScale = 0.050
        
        SectionBorder.Name = "SectionBorder"
        SectionBorder.Parent = NameSection
        SectionBorder.BackgroundColor3 = Library.Theme.MainColor
        SectionBorder.BackgroundTransparency = 1.000
        SectionBorder.Position = UDim2.new(0, -1, 0, -1)
        SectionBorder.Size = UDim2.new(1, 2, 1, 2)
        SectionBorder.ZIndex = 3
        SectionBorder.Image = "rbxassetid://3570695787"
        SectionBorder.ImageColor3 = Library.Theme.MainColor
        SectionBorder.ScaleType = Enum.ScaleType.Slice
        SectionBorder.SliceCenter = Rect.new(100, 100, 100, 100)
        SectionBorder.SliceScale = 0.050
        
        SectionTitle.Name = "SectionTitle"
        SectionTitle.Parent = NameSection
        SectionTitle.BackgroundColor3 = Library.Theme.BackgroundColor
        SectionTitle.BorderSizePixel = 0
        SectionTitle.Text = name
        SectionTitle.Position = UDim2.new(0.5, (-SectionTitle.TextBounds.X - 5) / 2, 0, -12)
        SectionTitle.Size = UDim2.new(0, SectionTitle.TextBounds.X + 5, 0, 22)
        SectionTitle.ZIndex = 4
        SectionTitle.Font = Library.Theme.TextFont
        SectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        SectionTitle.TextSize = 14.000
        
        SectionContent.Name = "SectionContent"
        SectionContent.Parent = NameSection
        SectionContent.Active = true
        SectionContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        SectionContent.BackgroundTransparency = 1.000
        SectionContent.BorderColor3 = Color3.fromRGB(27, 42, 53)
        SectionContent.BorderSizePixel = 0
        SectionContent.Size = UDim2.new(1, 0, 1, 0)
        SectionContent.ZIndex = 4
        SectionContent.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
        SectionContent.ScrollBarImageColor3 = Color3.fromRGB(85, 85, 85)
        SectionContent.ScrollBarThickness = 4
        SectionContent.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"

        SectionContentLayout.Name = "SectionContentLayout"
        SectionContentLayout.Parent = SectionContent
        SectionContentLayout.SortOrder = Enum.SortOrder.LayoutOrder

        table.insert(Library.LibraryColorTable, SectionBorder)

        SectionContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            SectionContent.CanvasSize = UDim2.new(0, 0, 0, SectionContentLayout.AbsoluteContentSize.Y + 15)
        end)

        function SectionElements:CreateLabel(name, text)
            local NameLabel = Instance.new("TextLabel")

            NameLabel.Name = (name .. "Label")
            NameLabel.Parent = SectionContent
            NameLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            NameLabel.BackgroundTransparency = 1.000
            NameLabel.Text = text
            NameLabel.Size = UDim2.new(0, 197, 0, NameLabel.TextBounds.Y)
            NameLabel.ZIndex = 5
            NameLabel.Font = Library.Theme.TextFont
            NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            NameLabel.TextSize = 15.000

            local function ChangeText(newtext)
                NameLabel.Text = newtext
            end

            NameLabel:GetPropertyChangedSignal("TextBounds"):Connect(function()
                if NameLabel.Text ~= "" then
                    TweenService:Create(NameLabel, TweenInfo.new(0.5, Library.Theme.EasingStyle, Enum.EasingDirection.Out), {Size = UDim2.new(0, 197, 0, NameLabel.TextBounds.Y)}):Play()
                else
                    TweenService:Create(NameLabel, TweenInfo.new(0.5, Library.Theme.EasingStyle, Enum.EasingDirection.Out), {Size = UDim2.new(0, 197, 0, 0)}):Play()
                end
            end)

            return {
                ChangeText = ChangeText
            }
        end

        function SectionElements:CreateButton(name, callback)
            local NameButton = Instance.new("Frame")
            local Button = Instance.new("TextButton")
            local ButtonRounded = Instance.new("ImageLabel")

            NameButton.Name = (name .. "Button")
            NameButton.Parent = SectionContent
            NameButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            NameButton.BackgroundTransparency = 1.000
            NameButton.Size = UDim2.new(0, 197, 0, 35)
            NameButton.ZIndex = 5

            Button.Name = "Button"
            Button.Parent = NameButton
            Button.BackgroundColor3 = Library.Theme.MainColor
            Button.BackgroundTransparency = 1.000
            Button.BorderSizePixel = 0
            Button.Position = UDim2.new(0.454314709, -76, 0.528571427, -12)
            Button.Size = UDim2.new(0, 168, 0, 25)
            Button.ZIndex = 6
            Button.Font = Library.Theme.TextFont
            Button.Text = name
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            Button.TextSize = 15.000
            Button.ClipsDescendants = true

            ButtonRounded.Name = "ButtonRounded"
            ButtonRounded.Parent = Button
            ButtonRounded.Active = true
            ButtonRounded.AnchorPoint = Vector2.new(0.5, 0.5)
            ButtonRounded.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ButtonRounded.BackgroundTransparency = 1.000
            ButtonRounded.Position = UDim2.new(0.5, 0, 0.5, 0)
            ButtonRounded.Selectable = true
            ButtonRounded.Size = UDim2.new(1, 0, 1, 0)
            ButtonRounded.ZIndex = 5
            ButtonRounded.Image = "rbxassetid://3570695787"
            ButtonRounded.ImageColor3 = Library.Theme.MainColor
            ButtonRounded.ScaleType = Enum.ScaleType.Slice
            ButtonRounded.SliceCenter = Rect.new(100, 100, 100, 100)
            ButtonRounded.SliceScale = 0.050

            Button.MouseButton1Down:Connect(function()
                TweenService:Create(ButtonRounded, TweenInfo.new(0.25, Library.Theme.EasingStyle, Enum.EasingDirection.Out), {ImageColor3 = DarkenObjectColor(Library.Theme.MainColor, 20)}):Play()

                RippleEffect(Button)
                callback(Button)
            end)

            Button.MouseButton1Up:Connect(function()
                TweenService:Create(ButtonRounded, TweenInfo.new(0.25, Library.Theme.EasingStyle, Enum.EasingDirection.Out), {ImageColor3 = Library.Theme.MainColor}):Play()
            end)

            Button.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement then
                    TweenService:Create(ButtonRounded, TweenInfo.new(0.25, Library.Theme.EasingStyle, Enum.EasingDirection.Out), {ImageColor3 = Library.Theme.MainColor}):Play()
                end
            end)

            table.insert(Library.Librar
