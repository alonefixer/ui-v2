local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- Глобальное хранилище состояний и функций
_G.ElixirMenu = {
    ActiveFunctions = {},  -- Активные функции
    IsMenuOpen = true,     -- Статус меню
    CloseAllFunctions = function()
        -- Функция для выключения всех активных функций
        for funcName, funcData in pairs(_G.ElixirMenu.ActiveFunctions) do
            if funcData.Type == "toggle" and funcData.State then
                -- Если это включенный тоггл, вызываем его callback с false
                if funcData.Callback then
                    funcData.Callback(false)
                end
            end
        end
        -- Очищаем хранилище
        _G.ElixirMenu.ActiveFunctions = {}
    end
}

-- Создание GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ElixirMenu"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Главный контейнер
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 600, 0, 400)
mainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

-- ЗАКРУГЛЕННЫЕ КРАЯ
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

-- Тень
local dropShadow = Instance.new("ImageLabel")
dropShadow.Name = "DropShadow"
dropShadow.Size = UDim2.new(1, 24, 1, 24)
dropShadow.Position = UDim2.new(0, -12, 0, -12)
dropShadow.BackgroundTransparency = 1
dropShadow.Image = "rbxassetid://5554236805"
dropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
dropShadow.ImageTransparency = 0.8
dropShadow.ScaleType = Enum.ScaleType.Slice
dropShadow.SliceCenter = Rect.new(23, 23, 277, 277)
dropShadow.Parent = mainFrame

-- Шапка
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 50)
header.Position = UDim2.new(0, 0, 0, 0)
header.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
header.BorderSizePixel = 0
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 12)
headerCorner.Parent = header

-- Название Elixir
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(0, 200, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "ELIXIR"
title.TextColor3 = Color3.fromRGB(100, 200, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

-- Статус
local status = Instance.new("TextLabel")
status.Name = "Status"
status.Size = UDim2.new(0, 100, 1, 0)
status.Position = UDim2.new(0.5, -50, 0, 0)
status.BackgroundTransparency = 1
status.Text = "✓ READY"
status.TextColor3 = Color3.fromRGB(100, 255, 150)
status.Font = Enum.Font.GothamBold
status.TextSize = 14
status.Parent = header

-- Кнопка закрытия
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseButton"
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -40, 0.5, -15)
closeBtn.BackgroundColor3 = Color3.fromRGB(220, 80, 80)
closeBtn.Text = "×"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 20
closeBtn.Parent = header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeBtn

-- Разделитель
local divider = Instance.new("Frame")
divider.Name = "Divider"
divider.Size = UDim2.new(1, 0, 0, 1)
divider.Position = UDim2.new(0, 0, 0, 50)
divider.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
divider.BorderSizePixel = 0
divider.Parent = mainFrame

-- Основное содержимое
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, 0, 1, -50)
contentFrame.Position = UDim2.new(0, 0, 0, 50)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Боковое меню
local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, 160, 1, 0)
sidebar.Position = UDim2.new(0, 0, 0, 0)
sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
sidebar.BorderSizePixel = 0
sidebar.Parent = contentFrame

local sidebarCorner = Instance.new("UICorner")
sidebarCorner.CornerRadius = UDim.new(0, 12)
sidebarCorner.Parent = sidebar

local sidebarList = Instance.new("UIListLayout")
sidebarList.Padding = UDim.new(0, 8)
sidebarList.Parent = sidebar

local sidebarPadding = Instance.new("UIPadding")
sidebarPadding.PaddingTop = UDim.new(0, 15)
sidebarPadding.PaddingLeft = UDim.new(0, 15)
sidebarPadding.PaddingRight = UDim.new(0, 15)
sidebarPadding.Parent = sidebar

-- Контейнер для контента
local rightPanel = Instance.new("Frame")
rightPanel.Name = "RightPanel"
rightPanel.Size = UDim2.new(1, -160, 1, 0)
rightPanel.Position = UDim2.new(0, 160, 0, 0)
rightPanel.BackgroundTransparency = 1
rightPanel.ClipsDescendants = true
rightPanel.Parent = contentFrame

-- Перетаскивание окна
local dragging = false
local dragInput, dragStart, startPos

local function updateInput(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateInput(input)
    end
end)

-- ВКЛАДКИ: Movement, Visual, Combat
local tabs = {
    {
        Name = "MOVEMENT",
        Icon = "⚡",
        Color = Color3.fromRGB(100, 255, 150),
        Elements = {}
    },
    {
        Name = "VISUAL",
        Icon = "👁",
        Color = Color3.fromRGB(100, 200, 255),
        Elements = {}
    },
    {
        Name = "COMBAT",
        Icon = "🎯",
        Color = Color3.fromRGB(255, 100, 100),
        Elements = {}
    }
}

local tabButtons = {}
local tabFrames = {}
local activeTab = 1

-- Функция создания элемента меню
local function createMenuElement(parent, elementData, tabColor)
    local elementFrame = Instance.new("Frame")
    elementFrame.Name = elementData.Name .. "Element"
    elementFrame.Size = UDim2.new(1, 0, 0, 50)
    elementFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    elementFrame.BorderSizePixel = 0
    elementFrame.Parent = parent
    
    local elementCorner = Instance.new("UICorner")
    elementCorner.CornerRadius = UDim.new(0, 8)
    elementCorner.Parent = elementFrame
    
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 15)
    padding.PaddingRight = UDim.new(0, 15)
    padding.PaddingTop = UDim.new(0, 10)
    padding.PaddingBottom = UDim.new(0, 10)
    padding.Parent = elementFrame
    
    -- Название элемента
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -80, 0, 30)
    title.BackgroundTransparency = 1
    title.Text = elementData.Name
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = elementFrame
    
    if elementData.Type == "toggle" then
        -- Тоггл
        local toggleFrame = Instance.new("TextButton")
        toggleFrame.Name = "ToggleFrame"
        toggleFrame.Size = UDim2.new(0, 50, 0, 25)
        toggleFrame.Position = UDim2.new(1, -60, 0.5, -12.5)
        toggleFrame.BackgroundColor3 = elementData.Default and tabColor or Color3.fromRGB(60, 60, 75)
        toggleFrame.Text = ""
        toggleFrame.Parent = elementFrame
        
        local toggleCorner = Instance.new("UICorner")
        toggleCorner.CornerRadius = UDim.new(1, 0)
        toggleCorner.Parent = toggleFrame
        
        local toggleDot = Instance.new("Frame")
        toggleDot.Name = "ToggleDot"
        toggleDot.Size = UDim2.new(0, 21, 0, 21)
        toggleDot.Position = elementData.Default and UDim2.new(1, -23, 0, 2) or UDim2.new(0, 2, 0, 2)
        toggleDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        toggleDot.Parent = toggleFrame
        
        local dotCorner = Instance.new("UICorner")
        dotCorner.CornerRadius = UDim.new(1, 0)
        dotCorner.Parent = toggleDot
        
        local isToggled = elementData.Default
        
        -- Сохраняем начальное состояние
        if isToggled then
            _G.ElixirMenu.ActiveFunctions[elementData.Name] = {
                Type = "toggle",
                State = isToggled,
                Callback = elementData.Callback
            }
        end
        
        toggleFrame.MouseButton1Click:Connect(function()
            isToggled = not isToggled
            
            -- Обновляем глобальное хранилище
            if isToggled then
                _G.ElixirMenu.ActiveFunctions[elementData.Name] = {
                    Type = "toggle",
                    State = isToggled,
                    Callback = elementData.Callback
                }
            else
                _G.ElixirMenu.ActiveFunctions[elementData.Name] = nil
            end
            
            if isToggled then
                TweenService:Create(toggleFrame, TweenInfo.new(0.2), {
                    BackgroundColor3 = tabColor
                }):Play()
                TweenService:Create(toggleDot, TweenInfo.new(0.2), {
                    Position = UDim2.new(1, -23, 0, 2)
                }):Play()
            else
                TweenService:Create(toggleFrame, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(60, 60, 75)
                }):Play()
                TweenService:Create(toggleDot, TweenInfo.new(0.2), {
                    Position = UDim2.new(0, 2, 0, 2)
                }):Play()
            end
            
            if elementData.Callback then
                elementData.Callback(isToggled)
            end
        end)
        
    elseif elementData.Type == "slider" then
        -- Слайдер
        local sliderFrame = Instance.new("Frame")
        sliderFrame.Name = "SliderFrame"
        sliderFrame.Size = UDim2.new(0, 100, 0, 20)
        sliderFrame.Position = UDim2.new(1, -110, 0.5, -10)
        sliderFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
        sliderFrame.Parent = elementFrame
        
        local sliderCorner = Instance.new("UICorner")
        sliderCorner.CornerRadius = UDim.new(1, 0)
        sliderCorner.Parent = sliderFrame
        
        local fill = Instance.new("Frame")
        fill.Name = "Fill"
        fill.Size = UDim2.new((elementData.Default - elementData.Min) / (elementData.Max - elementData.Min), 0, 1, 0)
        fill.BackgroundColor3 = tabColor
        fill.Parent = sliderFrame
        
        local fillCorner = Instance.new("UICorner")
        fillCorner.CornerRadius = UDim.new(1, 0)
        fillCorner.Parent = fill
        
        local valueText = Instance.new("TextLabel")
        valueText.Name = "Value"
        valueText.Size = UDim2.new(1, 0, 1, 0)
        valueText.BackgroundTransparency = 1
        valueText.Text = tostring(elementData.Default)
        valueText.TextColor3 = Color3.fromRGB(255, 255, 255)
        valueText.Font = Enum.Font.GothamBold
        valueText.TextSize = 12
        valueText.Parent = sliderFrame
        
        -- Сохраняем начальное значение слайдера
        _G.ElixirMenu.ActiveFunctions[elementData.Name] = {
            Type = "slider",
            Value = elementData.Default,
            Callback = elementData.Callback
        }
        
        local isDragging = false
        
        local function updateSlider(input)
            local pos = (input.Position.X - sliderFrame.AbsolutePosition.X) / sliderFrame.AbsoluteSize.X
            pos = math.clamp(pos, 0, 1)
            
            fill.Size = UDim2.new(pos, 0, 1, 0)
            local value = math.floor(elementData.Min + pos * (elementData.Max - elementData.Min))
            valueText.Text = tostring(value)
            
            -- Обновляем глобальное хранилище
            _G.ElixirMenu.ActiveFunctions[elementData.Name] = {
                Type = "slider",
                Value = value,
                Callback = elementData.Callback
            }
            
            if elementData.Callback then
                elementData.Callback(value)
            end
        end
        
        sliderFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                isDragging = true
                updateSlider(input)
            end
        end)
        
        sliderFrame.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                isDragging = false
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                updateSlider(input)
            end
        end)
        
    elseif elementData.Type == "button" then
        -- Кнопка
        local actionButton = Instance.new("TextButton")
        actionButton.Name = "ActionButton"
        actionButton.Size = UDim2.new(0, 80, 0, 30)
        actionButton.Position = UDim2.new(1, -85, 0.5, -15)
        actionButton.BackgroundColor3 = tabColor
        actionButton.Text = "EXECUTE"
        actionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        actionButton.Font = Enum.Font.GothamBold
        actionButton.TextSize = 11
        actionButton.Parent = elementFrame
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 6)
        buttonCorner.Parent = actionButton
        
        -- Сохраняем кнопку
        _G.ElixirMenu.ActiveFunctions[elementData.Name] = {
            Type = "button",
            Callback = elementData.Callback
        }
        
        actionButton.MouseButton1Click:Connect(function()
            TweenService:Create(actionButton, TweenInfo.new(0.1), {
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                TextColor3 = tabColor
            }):Play()
            
            wait(0.1)
            
            TweenService:Create(actionButton, TweenInfo.new(0.1), {
                BackgroundColor3 = tabColor,
                TextColor3 = Color3.fromRGB(255, 255, 255)
            }):Play()
            
            if elementData.Callback then
                elementData.Callback()
            end
        end)
    end
    
    -- Эффект наведения
    elementFrame.MouseEnter:Connect(function()
        TweenService:Create(elementFrame, TweenInfo.new(0.1), {
            BackgroundColor3 = Color3.fromRGB(40, 40, 55)
        }):Play()
    end)
    
    elementFrame.MouseLeave:Connect(function()
        TweenService:Create(elementFrame, TweenInfo.new(0.1), {
            BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        }):Play()
    end)
    
    return elementFrame
end

-- Функция создания вкладки
local function createTab(tabData, index)
    local tabButton = Instance.new("TextButton")
    tabButton.Name = tabData.Name .. "Tab"
    tabButton.Size = UDim2.new(1, 0, 0, 45)
    tabButton.BackgroundColor3 = (index == 1) and tabData.Color or Color3.fromRGB(35, 35, 45)
    tabButton.Text = tabData.Icon .. "  " .. tabData.Name
    tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabButton.Font = Enum.Font.GothamBold
    tabButton.TextSize = 13
    tabButton.TextXAlignment = Enum.TextXAlignment.Left
    tabButton.Parent = sidebar
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = tabButton
    
    -- Контейнер для вкладки
    local tabFrame = Instance.new("ScrollingFrame")
    tabFrame.Name = tabData.Name .. "Frame"
    tabFrame.Size = UDim2.new(1, -20, 1, -20)
    tabFrame.Position = UDim2.new(0, 10, 0, 10)
    tabFrame.BackgroundTransparency = 1
    tabFrame.ScrollBarThickness = 4
    tabFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 100)
    tabFrame.Visible = (index == 1)
    tabFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    tabFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabFrame.Parent = rightPanel
    
    local tabContent = Instance.new("Frame")
    tabContent.Name = "Content"
    tabContent.Size = UDim2.new(1, 0, 0, 0)
    tabContent.BackgroundTransparency = 1
    tabContent.Parent = tabFrame
    
    local tabList = Instance.new("UIListLayout")
    tabList.Padding = UDim.new(0, 12)
    tabList.Parent = tabContent
    tabList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabContent.Size = UDim2.new(1, 0, 0, tabList.AbsoluteContentSize.Y)
    end)
    
    tabButtons[index] = tabButton
    tabFrames[index] = tabFrame
    
    -- Обработчик клика
    tabButton.MouseButton1Click:Connect(function()
        if activeTab == index then return end
        
        for i, frame in pairs(tabFrames) do
            frame.Visible = (i == index)
        end
        
        for i, btn in pairs(tabButtons) do
            if i == index then
                TweenService:Create(btn, TweenInfo.new(0.2), {
                    BackgroundColor3 = tabData.Color
                }):Play()
            else
                TweenService:Create(btn, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(35, 35, 45)
                }):Play()
            end
        end
        
        activeTab = index
    end)
    
    -- Эффекты наведения
    tabButton.MouseEnter:Connect(function()
        if activeTab ~= index then
            TweenService:Create(tabButton, TweenInfo.new(0.1), {
                BackgroundColor3 = Color3.fromRGB(50, 50, 60)
            }):Play()
        end
    end)
    
    tabButton.MouseLeave:Connect(function()
        if activeTab ~= index then
            TweenService:Create(tabButton, TweenInfo.new(0.1), {
                BackgroundColor3 = Color3.fromRGB(35, 35, 45)
            }):Play()
        end
    end)
    
    return tabContent
end

-- Создаем вкладки
local tabContents = {}
for i, tab in ipairs(tabs) do
    tabContents[tab.Name] = createTab(tab, i)
end

-- Функция для добавления элементов в реальном времени
function addElementToTab(tabName, elementType, elementName, ...)
    local tabContent = tabContents[tabName]
    if not tabContent then
        return false
    end
    
    local args = {...}
    
    if elementType == "toggle" then
        local defaultValue = args[1] or false
        local callback = args[2]
        
        local elementData = {
            Type = "toggle",
            Name = elementName,
            Default = defaultValue,
            Callback = callback
        }
        
        for _, tab in ipairs(tabs) do
            if tab.Name == tabName then
                table.insert(tab.Elements, elementData)
                break
            end
        end
        
        createMenuElement(tabContent, elementData, tabs[activeTab].Color)
        return true
        
    elseif elementType == "slider" then
        local minValue = args[1] or 0
        local maxValue = args[2] or 100
        local defaultValue = args[3] or 50
        local callback = args[4]
        
        local elementData = {
            Type = "slider",
            Name = elementName,
            Min = minValue,
            Max = maxValue,
            Default = defaultValue,
            Callback = callback
        }
        
        for _, tab in ipairs(tabs) do
            if tab.Name == tabName then
                table.insert(tab.Elements, elementData)
                break
            end
        end
        
        createMenuElement(tabContent, elementData, tabs[activeTab].Color)
        return true
        
    elseif elementType == "button" then
        local callback = args[1]
        
        local elementData = {
            Type = "button",
            Name = elementName,
            Callback = callback
        }
        
        for _, tab in ipairs(tabs) do
            if tab.Name == tabName then
                table.insert(tab.Elements, elementData)
                break
            end
        end
        
        createMenuElement(tabContent, elementData, tabs[activeTab].Color)
        return true
    end
    
    return false
end

-- Кнопка закрытия
closeBtn.MouseEnter:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    }):Play()
end)

closeBtn.MouseLeave:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(220, 80, 80)
    }):Play()
end)

closeBtn.MouseButton1Click:Connect(function()
    -- Выключаем все активные функции
    _G.ElixirMenu.CloseAllFunctions()
    
    -- Анимация закрытия
    TweenService:Create(mainFrame, TweenInfo.new(0.3), {
        Size = UDim2.new(0, 0, 0, 0)
    }):Play()
    
    TweenService:Create(mainFrame, TweenInfo.new(0.3), {
        BackgroundTransparency = 1
    }):Play()
    
    wait(0.3)
    
    -- Удаляем GUI
    screenGui:Destroy()
    _G.ElixirMenu.IsMenuOpen = false
end)

-- Горячая клавиша для переключения видимости
local isMenuVisible = true

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then
        isMenuVisible = not isMenuVisible
        
        if isMenuVisible then
            TweenService:Create(mainFrame, TweenInfo.new(0.3), {
                Position = UDim2.new(0.5, -300, 0.5, -200)
            }):Play()
        else
            TweenService:Create(mainFrame, TweenInfo.new(0.3), {
                Position = UDim2.new(-0.6, 0, 0.5, -200)
            }):Play()
        end
    end
end)

-- Эффект появления
mainFrame.Position = UDim2.new(-0.6, 0, 0.5, -200)
TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Position = UDim2.new(0.5, -300, 0.5, -200)
}):Play()





loadstring(game:HttpGet("https://raw.githubusercontent.com/alonefixer/ui-v2/refs/heads/main/speed%2Bjump.lua"))()
