-- ========================================================================
-- IMPULSE REMASTER V2 (GREEN CARBON EDITION)
-- ========================================================================

ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ImpulseMenu"
local okCg, cg = pcall(function() return game:GetService("CoreGui") end)
local guiParent = (okCg and cg) or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
for _, old in ipairs(guiParent:GetChildren()) do
    if old:IsA("ScreenGui") and old.Name == "ImpulseMenu" then pcall(function() old:Destroy() end) end
end
ScreenGui.Parent = guiParent
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

ClickSound = Instance.new("Sound")
ClickSound.SoundId = "rbxassetid://6895079853"
ClickSound.Volume = 0.18
ClickSound.Parent = game:GetService("SoundService")

local function PlayClick()
    pcall(function()
        local s = ClickSound:Clone()
        s.Parent = game:GetService("SoundService")
        s:Play()
        game:GetService("Debris"):AddItem(s, 1)
    end)
    if _G.triggerMenuPulse then pcall(_G.triggerMenuPulse) end
end

currentLanguage = "RU"
Lighting = game:GetService("Lighting")
TweenService = game:GetService("TweenService")
RunService = game:GetService("RunService")
HttpService = game:GetService("HttpService")
Players = game:GetService("Players")
LocalPlayer = Players.LocalPlayer
Camera = workspace.CurrentCamera
UserInputService = game:GetService("UserInputService")
VirtualUser = game:GetService("VirtualUser")
Mouse = LocalPlayer:GetMouse()
VirtualInputManager = game:GetService("VirtualInputManager")

MenuBlur = Instance.new("BlurEffect")
MenuBlur.Size = 0
MenuBlur.Enabled = false
MenuBlur.Parent = Lighting

Theme = {
    BgDark      = Color3.fromRGB(8, 10, 8),
    BgPanel     = Color3.fromRGB(12, 16, 12),
    BgRow       = Color3.fromRGB(18, 24, 18),
    BgRowHover  = Color3.fromRGB(30, 42, 30),
    Green       = Color3.fromRGB(0, 255, 100),
    GreenBright = Color3.fromRGB(80, 255, 140),
    GreenDim    = Color3.fromRGB(0, 130, 50),
    TextMain    = Color3.fromRGB(220, 240, 220),
    TextDim     = Color3.fromRGB(130, 160, 130),
    Border      = Color3.fromRGB(40, 70, 45),
}

-- === Общие «ощущения» кнопок: увеличение при наведении + зум-пульс при клике ===
function ensureUIScale(gui)
    local us = gui:FindFirstChildOfClass("UIScale")
    if not us then us = Instance.new("UIScale"); us.Parent = gui end
    return us
end
function attachFeel(gui, clickTarget)
    if not gui then return end
    local us = ensureUIScale(gui)
    local base = us.Scale
    local hovered = false
    gui.MouseEnter:Connect(function()
        hovered = true
        TweenService:Create(us, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = base * 1.03}):Play()
    end)
    gui.MouseLeave:Connect(function()
        hovered = false
        TweenService:Create(us, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = base}):Play()
    end)
    local target = clickTarget or gui
    if target and target:IsA("GuiButton") then
        target.MouseButton1Click:Connect(function()
            us.Scale = base * 0.95
            TweenService:Create(us, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = base * (hovered and 1.03 or 1)}):Play()
        end)
    end
end

localization = {
    RU = {
        title = " IMPULSE REMASTER V2",
        aimbot = "Аимбот", visuals = "Визуалы", combat = "Сражение",
        killaura = "Килл-аура", movement = "Движение", other = "Другое",
        esp = "ESP", world = "МИР", configs = "Конфиги",
        pillMain = "АИМБОТ", pillLegit = "ЛЕГИТ", pillTrigger = "ТРИГГЕР",
        aimbotEnabled = "Включить Аимбот",
        
        fovVisible = "Показывать FOV круг", fovRadius = "Радиус FOV",
        dynamicFovEnabled = "Динамический FOV (близкие)", dynamicFovStart = "Старт с дистанции (м)",
        dynamicFovMax = "Макс. увеличение (x)",
        ignoreFriends = "Игнорировать друзей", ignoreBehindWalls = "Проверка стен",
        aimSmoothingStrength = "Скорость Аима (0 = Снап)",
    aimSmoothing = "Сглаживание",
        aimTuning = "Наведение",
       
       
        aimJitterEnabled = "Дрожание прицела (Jitter)",
        aimJitterStrength = "Сила дрожания",
        aimMaxTurnEnabled = "Лимит поворота камеры",
        aimMaxTurnDegPerSec = "Макс. градусов/сек",
        aimMissEnabled = "Шанс промаха",
        aimMissChance = "Шанс промаха (%)",
        aimMissOffset = "Смещение промаха",
        aimAutoStopEnabled = "Автостоп при наведении",
        aimAutoStopStrength = "Сила автостопа (%)",
        espBoxes = "Включить боксы", currentBoxType = "Тип боксов",
        espTextSize = "Размер текста", boxCornerSize = "Размер уголков",
       
        arrowSize = "Размер", arrowGlowSize = "Размер свечения", arrowGlowStrength = "Сила свечения",
        espNames = "Показывать ники", espHpText = "Полоска здоровья",
        espDistance = "Показывать дистанцию",
        antiRecoil = "Анти-Отдача", antiRecoilVertical = "Верт. сила", antiRecoilHorizontal = "Гориз. сила",
        invisibleEnabled = "Невидимость (Invisible)",
        killauraEnabled = "Включить Килл-Ауру", killauraRange = "Радиус атаки",
        killauraDelay = "Задержка удара (мс)", killauraFov = "Угол атаки (FOV)",
        killauraTeamCheck = "Игнорировать союзников", killauraWallCheck = "Проверка стен (только в зоне видимости)",
        killauraRotate = "Поворот к цели", SpeedHackEnabled = "Спидхак (Toggle)", SpeedValue = "Скорость",
        wallPassEnabled = "Ходить сквозь стены", infJumpEnabled = "Бесконечный прыжок",
        bhopEnabled = "Баннихоп", spiderEnabled = "Паук (Лестница)",
        autoStrafeEnabled = "Автострейф", autoStrafeStrength = "Сила автострейфа",
        noFallDamage = "Отключить урон от падения", tpMouseEnabled = "Телепорт к мыши (клавиша T)",
        espSkeletons = "Скелетоны", espChams = "Заливка Chams", chamsFillTransparency = "Прозрачность Chams",
        chamsOutlineColor = "Цвет контура", viewDirection = "Линия взгляда", viewDirLength = "Длина взгляда",
        weaponEsp = "Показывать оружие", animations = "Анимации", unload = "Выгрузить чит",
        legitConfig = "ЛЕГИТ-КОНФИГ",
        antiAfkEnabled = "Включить Анти-АФК", resetAll = "↺ Сбросить всё (двойной клик)",
        hvhAimbotEnabled = "Включить HVH Аимбот", hvhIgnoreFriends = "Игнорировать друзей",
        hvhThroughWalls = "Игнорировать за стеной", hvhAntiAim = "Anti-Aim (HVH)",
        triggerbotEnabled = "Включить Триггербот (Авто)",
        triggerbotWallCheck = "Проверка стен",
        triggerbotDistanceEnabled = "Проверка дистанции",
        triggerbotMaxDist = "Макс. дистанция (studs)",
        triggerbotDelay = "Задержка выстрела (мс)",
        triggerbotFireRateEnabled = "Скорострельность",
        triggerbotFireRate = "Скорострельность (клик/с)",
        debugCamEnabled = "Debug-камера (Freecam) [F4]",
        debugCamSpeed = "Скорость полёта", debugCamSensitivity = "Чувствительность мыши",
        espTracers = "Линии к игрокам (Tracers)", tracerThickness = "Толщина линий",
        radarEnabled = "Радар", radarSize = "Размер радара", radarRange = "Дальность радара",
        radarDotSize = "Размер точек", radarShowNames = "Ники на радаре",
        radarShowViewDir = "Линия взгляда", radarViewDirLength = "Длина линии взгляда",
        radarFireHighlight = "Жёлтая при стрельбе", radarFireDuration = "Длительность подсветки (сек)",
        fullbrightEnabled = "Fullbright (Освещение)",
        worldThirdPerson = "Третье лицо (камера)", worldThirdPersonDist = "Дистанция камеры",
        skyboxEnabled = "Скайбокс", skyboxTitle = "Небо (скайбокс)",
        skyboxDefault = "Как в игре", skyboxSpace = "Космос", skyboxSpace2 = "Космос 2", skyboxVibe = "Вайб", skyboxVibe2 = "Вайб 2", skyboxWhite = "Белое счастье", skyboxNeon = "Породный неон", skyboxNeon2 = "Усмиряюще неон", skyboxTale = "Древняя мудрость", skyboxTale2 = "Древняя мудрость 2",
        fogEnabled = "Туман", fogDensity = "Плотность тумана",
        pinkSkyEnabled = "Розовое небо", particlesEnabled = "Частицы",
        particleDensity = "Плотность частиц", particleSize = "Размер частиц",
        autoAimRMB = "Авто-прицел (ПКМ)",
        hvhTargetLock = "Захват цели (3 сек)",
        mode = "РЕЖИМ", legit = "ЛЕГИТ", hvh = "HVH",
        pillHvh = "HVH", pillAntiAim = "АНТИ-АИМ",
        aaYawHeader = "Yaw (Поворот тела)", aaPitchHeader = "Pitch (Наклон головы)", aaMainHeader = "Main (Спин/Джиттер)",
        aaYawDir = "Направление Yaw", aaPitchDir = "Направление Pitch",
        aaSpin = "Spinbot (Спин)", aaSpinSpeed = "Скорость Spin",
        aaJitter = "Jitter (Дрожание)", aaJitterSpeed = "Скорость Jitter (Гц)", aaJitterStrength = "Угол Jitter (°)",
        aaBypass = "Bypass (ЛКМ)",
        antiAimMenu = "Анти-Аим", antiAimWarning = "АНТИ-АИМ ВКЛЮЧЕН",
        off = "Off", back = "Назад", left = "Влево", right = "Вправо", down = "Вниз", up = "Вверх",
        hitboxTitle = "НАСТРОЙКА ХИТБОКСОВ", hitboxSub = "ЛКМ — добавить/убрать | ★ — где вес больше",
    },
    EN = {
        title = " IMPULSE REMASTER V2",
        aimbot = "Aimbot", visuals = "Visuals", combat = "Combat",
        killaura = "Killaura", movement = "Movement", other = "Other",
        esp = "ESP", world = "WORLD", configs = "Configs",
        pillMain = "AIMBOT", pillLegit = "LEGIT", pillTrigger = "TRIGGER",
        aimbotEnabled = "Enable Aimbot",
        
        fovVisible = "Show FOV Circle", fovRadius = "FOV Radius",
        dynamicFovEnabled = "Dynamic FOV (close)", dynamicFovStart = "Start Distance (m)",
        dynamicFovMax = "Max Multiplier (x)",
        ignoreFriends = "Ignore Friends", ignoreBehindWalls = "Ignore Behind Walls",
        aimSmoothingStrength = "Aim Speed (0 = Snap)",
    aimSmoothing = "Smoothing",
        aimTuning = "Aim Tuning",
       
       
        aimJitterEnabled = "Aim Jitter",
        aimJitterStrength = "Jitter Strength",
        aimMaxTurnEnabled = "Max Turn Speed",
        aimMaxTurnDegPerSec = "Max Degrees/Sec",
        aimMissEnabled = "Miss Chance",
        aimMissChance = "Miss Chance (%)",
        aimMissOffset = "Miss Offset",
        aimAutoStopEnabled = "Auto-Stop on Aim",
        aimAutoStopStrength = "Auto-Stop Strength (%)",
        espBoxes = "Enable Boxes", currentBoxType = "Box Type",
        espTextSize = "Text Size", boxCornerSize = "Corner Size",
       
        arrowSize = "Size", arrowGlowSize = "Glow Size", arrowGlowStrength = "Glow Strength",
        espNames = "Show Names", espHpText = "Health Bar",
        espDistance = "Show Distance",
        antiRecoil = "Anti Recoil", antiRecoilVertical = "Vertical Force", antiRecoilHorizontal = "Horizontal Force",
        invisibleEnabled = "Invisibility",
        killauraEnabled = "Enable Killaura", killauraRange = "Attack Range",
        killauraDelay = "Attack Delay (ms)", killauraFov = "Attack FOV",
        killauraTeamCheck = "Ignore Teammates", killauraWallCheck = "Wall Check (line of sight only)",
        killauraRotate = "Rotate to Target", SpeedHackEnabled = "Speed Hack (Toggle)", SpeedValue = "Speed",
        wallPassEnabled = "Walk Through Walls", infJumpEnabled = "Infinite Jump",
        bhopEnabled = "Bunnyhop", spiderEnabled = "Spider (Ladder)",
        autoStrafeEnabled = "Auto Strafe", autoStrafeStrength = "Auto Strafe Strength",
        noFallDamage = "Disable Fall Damage", tpMouseEnabled = "Teleport to Mouse (key T)",
        espSkeletons = "Skeleton ESP", espChams = "Chams ESP", chamsFillTransparency = "Chams Transparency",
        chamsOutlineColor = "Chams Outline", viewDirection = "View Direction", viewDirLength = "View Length",
        weaponEsp = "Show Weapon", animations = "Animations", unload = "Unload Script",
        legitConfig = "LEGIT-CONFIG",
        antiAfkEnabled = "Enable Anti-AFK", resetAll = "↺ Reset All (double click)",
        hvhAimbotEnabled = "Enable HVH Aimbot", hvhIgnoreFriends = "Ignore Friends",
        hvhThroughWalls = "Ignore Behind Walls", hvhAntiAim = "Anti-Aim (HVH)",
        triggerbotEnabled = "Enable Triggerbot (Auto)",
        triggerbotWallCheck = "Wall Check",
        triggerbotDistanceEnabled = "Distance Check",
        triggerbotMaxDist = "Max Distance (studs)",
        triggerbotDelay = "Fire Delay (ms)",
        triggerbotFireRateEnabled = "Fire Rate",
        triggerbotFireRate = "Fire Rate (cps)",
        debugCamEnabled = "Debug Camera (Freecam) [F4]",
        debugCamSpeed = "Flight Speed", debugCamSensitivity = "Mouse Sensitivity",
        espTracers = "Tracer Lines", tracerThickness = "Tracer Thickness",
        radarEnabled = "Radar", radarSize = "Radar Size", radarRange = "Radar Range",
        radarDotSize = "Dot Size", radarShowNames = "Names on Radar",
        radarShowViewDir = "View Direction Line", radarViewDirLength = "View Line Length",
        radarFireHighlight = "Yellow When Shooting", radarFireDuration = "Highlight Duration (sec)",
        fullbrightEnabled = "Fullbright (Lighting)",
        worldThirdPerson = "Third Person (Camera)", worldThirdPersonDist = "Camera Distance",
        skyboxEnabled = "Skybox", skyboxTitle = "Sky",
        skyboxDefault = "Default (game)", skyboxSpace = "Space", skyboxSpace2 = "Space 2", skyboxVibe = "Vibe", skyboxVibe2 = "Vibe 2", skyboxWhite = "White Bliss", skyboxNeon = "Neon", skyboxNeon2 = "Calm Neon", skyboxTale = "Ancient Wisdom", skyboxTale2 = "Ancient Wisdom 2",
        fogEnabled = "Fog", fogDensity = "Fog Density",
        pinkSkyEnabled = "Pink Sky", particlesEnabled = "Particles",
        particleDensity = "Particle Density", particleSize = "Particle Size",
        autoAimRMB = "Auto-Aim (RMB)",
        hvhTargetLock = "Target Lock (3 sec)",
        mode = "MODE", legit = "LEGIT", hvh = "HVH",
        pillHvh = "HVH", pillAntiAim = "ANTI-AIM",
        aaYawHeader = "Yaw (Body Spin)", aaPitchHeader = "Pitch (Head Tilt)", aaMainHeader = "Main (Spin/Jitter)",
        aaYawDir = "Yaw Direction", aaPitchDir = "Pitch Direction",
        aaSpin = "Spinbot", aaSpinSpeed = "Spin Speed",
        aaJitter = "Jitter", aaJitterSpeed = "Jitter Speed (Hz)", aaJitterStrength = "Jitter Angle (°)",
        aaBypass = "Bypass (LMB)",
        antiAimMenu = "Anti-Aim", antiAimWarning = "ANTI-AIM ENABLED",
        off = "Off", back = "Back", left = "Left", right = "Right", down = "Down", up = "Up",
        hitboxTitle = "HITBOX CONFIG", hitboxSub = "LMB — add/remove | ★ — highest weight",
    }
}

-- === ГЛОБАЛЬНЫЕ КОНФИГИ ===
_G.aimbotEnabled = false
_G.aimSmoothing = 20
_G.fovRadius = 150
_G.dynamicFovEnabled = false
_G.dynamicFovStart = 30
_G.dynamicFovMax = 5
_G.__dynFovMult = 1
_G.__dynFovTarget = 1
_G.__dynFovNext = 0
_G.fovVisible = false
_G.ignoreFriends = false
_G.ignoreBehindWalls = false

-- Режим наведения: "Полный" (наводит и держит на цели сам, делает всё за тебя),
-- "Доводка" (мягко подтягивает к цели, но курсор можно двигать свободно).

_G.aimJitterEnabled = true
_G.aimJitterStrength = 15
_G.aimMaxTurnEnabled = false
_G.aimMaxTurnDegPerSec = 360
_G.aimMissEnabled = true
_G.aimMissChance = 10
_G.aimMissOffset = 6
_G.aimAutoStopEnabled = false
_G.aimAutoStopStrength = 100

_G.espColor = Color3.fromRGB(0, 255, 100)
_G.espTextSize = 11
_G.boxCornerSize = 25
_G.arrowDistance = 90
_G.arrowSize = 12
_G.arrowGlowSize = 6
_G.arrowGlowStrength = 50
_G.espBoxes = false
_G.boxTypes = {"Full", "Corners"}
_G.currentBoxType = "Full"
_G.espNames = false
_G.espHpText = false
_G.espDistance = false
_G.espTracers = false
_G.tracerThickness = 2.5
_G.antiRecoil = false
_G.antiRecoilVertical = 100
_G.antiRecoilHorizontal = 100

_G.wallPassEnabled = false
_G.infJumpEnabled = false
_G.bhopEnabled = false
_G.autoStrafeEnabled = false
_G.autoStrafeStrength = 50
_G.antiAfkEnabled = false
_G.espSkeletons = false
_G.espChams = false
_G.chamsFillTransparency = 50
_G.chamsOutlineStyles = {"Default", "Match"}
_G.currentChamsStyle = "Default"
_G.viewDirection = false
_G.viewDirLength = 15
_G.weaponEsp = false

_G.SpeedHackEnabled = false
_G.SpeedValue = 16
_G.spiderEnabled = false
_G.noFallDamage = false
_G.invisibleEnabled = false

_G.killauraEnabled = false
_G.killauraRange = 10
_G.killauraDelay = 100
_G.killauraFov = 180
_G.killauraTeamCheck = false
_G.killauraWallCheck = false
_G.killauraRotate = false

_G.tpMouseEnabled = false

_G.triggerbotEnabled = false
_G.triggerbotWallCheck = true
_G.triggerbotDistanceEnabled = true
_G.triggerbotMaxDist = 5000
_G.triggerbotDelay = 80
_G.triggerbotFireRateEnabled = true
_G.triggerbotFireRate = 30

local triggerAcquiring = false
local triggerAcquiredPlayer = nil
local triggerAcquireTime = 0
local triggerNextFire = 0

local function nowMs()
    return os.clock() * 1000
end

_G.autoAimRMB = false

_G.debugCamEnabled = false
_G.debugCamSpeed = 2
_G.debugCamSensitivity = 30

_G.radarEnabled = false
_G.radarSize = 180
_G.radarRange = 150
_G.radarDotSize = 6
_G.radarShowNames = false
_G.radarShowViewDir = true
_G.radarViewDirLength = 18
_G.radarFireHighlight = true
_G.radarFireDuration = 1

_G.fullbrightEnabled = false
_G.worldThirdPerson = false
_G.worldThirdPersonDist = 12
_G.skyboxEnabled = false
_G.skyboxIndex = 2
_G.fogEnabled = false
_G.fogDensity = 50
_G.pinkSkyEnabled = false
_G.particlesEnabled = false
_G.particleDensity = 50
_G.particleSize = 50

_G.hitboxPriorityZone = nil

_G.aimbotMode = "Legit"
_G.hvhAimbotEnabled = false
_G.hvhThroughWalls = false
_G.hvhIgnoreFriends = true
_G.hvhTargetLockEnabled = true

_G.hvhAntiAimEnabled = false
_G.aaUiYaw = false
_G.aaUiPitch = false
_G.aaUiMain = false
_G.aaPitch = "Off"
_G.aaYaw = "Off"
_G.aaJitterEnabled = false
_G.aaJitterStrength = 30
_G.aaJitterSpeed = 8
_G.aaDesyncEnabled = false
_G.aaFakeRun = false
_G.aaDesyncStrength = 60
_G.aaSpinEnabled = false
_G.aaSpinSpeed = 60
_G.aaBypassEnabled = false

_G.AimbotWeights = { Head = 100, Chest = 0, Waist = 0, Legs = 0 }
_G.activeHitboxZones = { Head = true, Chest = false, Waist = false, Legs = false }
-- Принудительное наведение в приоритетную зону (кнопка-стрелка у манекена).
_G.forcePriorityAim = false
_G.priorityAimSpeed = 100
_G.HitboxZoneMap = {
    Head  = {"Head"},
    Chest = {"UpperTorso", "Torso"},
    Waist = {"LowerTorso", "Torso"},
    Legs  = {"LeftUpperLeg", "RightUpperLeg", "LeftLeg", "RightLeg"},
}

_G.friendPlayers = {}
_G.brushMode = nil
_G.focusedPlayer = nil

function isPlayerIgnored(plr)
    return plr ~= nil and _G.friendPlayers ~= nil and _G.friendPlayers[plr.Name] == true
end

local lockedTargetPart = nil
local lastTargetPlayer = nil
local currentAimPoint = nil
local currentMissOffset = Vector3.zero
local missRerollTime = 0
local priorityPlayer = nil
local priorityTargetPart = nil
local priorityProgress = 0
local priorityAnchor = nil

EspContainer = Instance.new("Folder", ScreenGui)
ChamsContainer = Instance.new("Folder", ScreenGui)

GuiFovCircle = Instance.new("Frame", ScreenGui)
GuiFovCircle.BackgroundTransparency = 1
GuiFovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
GuiFovCircle.Size = UDim2.new(0, _G.fovRadius * 2, 0, _G.fovRadius * 2)
GuiFovCircle.Visible = false
Instance.new("UICorner", GuiFovCircle).CornerRadius = UDim.new(1, 0)
FovStroke = Instance.new("UIStroke", GuiFovCircle)
FovStroke.Color = Theme.Green
FovStroke.Thickness = 1.5

-- === ЛОГОТИП ===
local function CreateGreenLogo(parent)
    local logoFrame = Instance.new("Frame", parent)
    logoFrame.Name = "CustomLogo"
    logoFrame.Size = UDim2.new(0, 28, 0, 28)
    logoFrame.Position = UDim2.new(0, 15, 0.5, -14)
    logoFrame.BackgroundTransparency = 1
    logoFrame.ZIndex = 3
    logoFrame.ClipsDescendants = true

    local circle = Instance.new("Frame", logoFrame)
    circle.Size = UDim2.new(1, 0, 1, 0)
    circle.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
    circle.BackgroundTransparency = 0
    circle.BorderSizePixel = 0
    circle.ZIndex = 3
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

    local line1 = Instance.new("Frame", logoFrame)
    line1.Size = UDim2.new(0, 2, 1, 0)
    line1.Position = UDim2.new(0.25, 0, 0, 0)
    line1.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    line1.BorderSizePixel = 0
    line1.ZIndex = 4

    local line2 = Instance.new("Frame", logoFrame)
    line2.Size = UDim2.new(1, 0, 0, 2)
    line2.Position = UDim2.new(0, 0, 0.65, 0)
    line2.Rotation = 25
    line2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    line2.BorderSizePixel = 0
    line2.ZIndex = 4

    local line3 = Instance.new("Frame", logoFrame)
    line3.Size = UDim2.new(0, 2, 0.7, 0)
    line3.Position = UDim2.new(0.75, 0, 0.15, 0)
    line3.Rotation = -35
    line3.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    line3.BorderSizePixel = 0
    line3.ZIndex = 4

    return logoFrame
end

-- === ЧАСТИЦЫ ===
ParticleContainer = Instance.new("Frame", ScreenGui)
ParticleContainer.Size = UDim2.new(1, 0, 1, 0)
ParticleContainer.BackgroundTransparency = 1
ParticleContainer.ClipsDescendants = false
ParticleContainer.ZIndex = 0
ParticleContainer.Visible = true

for i = 1, 40 do
    local shape = Instance.new("Frame", ParticleContainer)
    local size = math.random(10, 22)
    shape.Size = UDim2.new(0, size, 0, size)
    
    local form = math.random(1, 4)
    if form == 1 then
        Instance.new("UICorner", shape).CornerRadius = UDim.new(0, 2)
    elseif form == 2 then
        Instance.new("UICorner", shape).CornerRadius = UDim.new(1, 0)
    elseif form == 3 then
        shape.Rotation = 45
        Instance.new("UICorner", shape).CornerRadius = UDim.new(0, 2)
    elseif form == 4 then
        shape.Rotation = math.random(0, 90)
        local line1 = Instance.new("Frame", shape)
        line1.Size = UDim2.new(0, size, 0, 2)
        line1.Position = UDim2.new(0, 0, 0.5, -1)
        line1.BackgroundColor3 = Theme.Green
        line1.ZIndex = 0
        line1.BorderSizePixel = 0
        
        local line2 = Instance.new("Frame", shape)
        line2.Size = UDim2.new(0, 2, 1, 0)
        line2.Position = UDim2.new(0.5, -1, 0, 0)
        line2.BackgroundColor3 = Theme.Green
        line2.ZIndex = 0
        line2.BorderSizePixel = 0
        
        shape.BackgroundTransparency = 1
    end
    
    shape.BackgroundColor3 = Theme.Green
    shape.BackgroundTransparency = math.random(75, 90) / 100 
    shape.Position = UDim2.new(math.random(), 0, math.random(), 0)
    shape.ZIndex = 0
    shape.BorderSizePixel = 0
    
    local floatTime = math.random(10, 25)
    TweenService:Create(shape, TweenInfo.new(floatTime, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
        Position = UDim2.new(math.random(), 0, math.random(), 0),
        Rotation = shape.Rotation + math.random(90, 360)
    }):Play()
end

MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name = "MainFrame"
MainFrame.BackgroundColor3 = Theme.BgDark
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.Size = UDim2.new(0, 520, 0, 400)
MainFrame.Active = true
MainFrame.ClipsDescendants = false
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

-- === ПАНЕЛЬ ИГРОКОВ ПОД МЕНЮ (4 КОЛОНКИ, ПОИСК, КЛЕТКА) ===
PlayerPanel = Instance.new("Frame", MainFrame)
PlayerPanel.Name = "PlayerPanel"
PlayerPanel.Position = UDim2.new(0, 0, 1, 6)
PlayerPanel.Size = UDim2.new(1, 0, 0, 204)
PlayerPanel.BackgroundColor3 = Theme.BgPanel
PlayerPanel.BackgroundTransparency = 0.05
PlayerPanel.BorderSizePixel = 0
PlayerPanel.ZIndex = 50
PlayerPanel.Visible = false
Instance.new("UICorner", PlayerPanel).CornerRadius = UDim.new(0, 12)

-- Стрелка под меню: открывает/закрывает панель игроков.
PlayerArrow = Instance.new("TextButton", MainFrame)
PlayerArrow.Name = "PlayerArrow"
PlayerArrow.AnchorPoint = Vector2.new(0.5, 0)
PlayerArrow.Position = UDim2.new(0.5, 0, 1, 2)
PlayerArrow.Size = UDim2.new(0, 34, 0, 16)
PlayerArrow.BackgroundColor3 = Theme.BgRow
PlayerArrow.Text = "▼"
PlayerArrow.TextColor3 = Theme.GreenBright
PlayerArrow.TextSize = 12
PlayerArrow.Font = Enum.Font.GothamBold
PlayerArrow.AutoButtonColor = false
PlayerArrow.ZIndex = 55
PlayerArrow.Visible = false
Instance.new("UICorner", PlayerArrow).CornerRadius = UDim.new(0, 6)
local playerPanelStroke = Instance.new("UIStroke", PlayerPanel)
playerPanelStroke.Color = Theme.Green
playerPanelStroke.Thickness = 1
playerPanelStroke.Transparency = 0.4

local playerGridBg = Instance.new("Frame", PlayerPanel)
playerGridBg.Size = UDim2.new(1, 0, 1, 0)
playerGridBg.BackgroundTransparency = 1
playerGridBg.ClipsDescendants = true
playerGridBg.ZIndex = 51
for i = 0, 60 do
    local v = Instance.new("Frame", playerGridBg)
    v.Size = UDim2.new(0, 1, 1, 0)
    v.Position = UDim2.new(0, i * 12, 0, 0)
    v.BackgroundColor3 = Theme.Green
    v.BackgroundTransparency = 0.92
    v.BorderSizePixel = 0
    v.ZIndex = 51
end
for i = 0, 16 do
    local h = Instance.new("Frame", playerGridBg)
    h.Size = UDim2.new(1, 0, 0, 1)
    h.Position = UDim2.new(0, 0, 0, i * 12)
    h.BackgroundColor3 = Theme.Green
    h.BackgroundTransparency = 0.92
    h.BorderSizePixel = 0
    h.ZIndex = 51
end

local playerTitle = Instance.new("TextLabel", PlayerPanel)
playerTitle.Size = UDim2.new(0, 200, 0, 24)
playerTitle.Position = UDim2.new(0, 12, 0, 8)
playerTitle.BackgroundTransparency = 1
playerTitle.Text = "ИГРОКИ  •  Исключить"
playerTitle.TextColor3 = Theme.GreenBright
playerTitle.TextSize = 12
playerTitle.Font = Enum.Font.GothamBold
playerTitle.TextXAlignment = Enum.TextXAlignment.Left
playerTitle.ZIndex = 53

PlayerSearch = Instance.new("TextBox", PlayerPanel)
PlayerSearch.Size = UDim2.new(0, 220, 0, 24)
PlayerSearch.Position = UDim2.new(1, -232, 0, 8)
PlayerSearch.BackgroundColor3 = Theme.BgRow
PlayerSearch.PlaceholderText = "Поиск игрока..."
PlayerSearch.Text = ""
PlayerSearch.TextColor3 = Theme.TextMain
PlayerSearch.PlaceholderColor3 = Theme.TextDim
PlayerSearch.TextSize = 11
PlayerSearch.Font = Enum.Font.Gotham
PlayerSearch.ClearTextOnFocus = false
PlayerSearch.ZIndex = 53
Instance.new("UICorner", PlayerSearch).CornerRadius = UDim.new(0, 6)

PlayerScroll = Instance.new("ScrollingFrame", PlayerPanel)
PlayerScroll.Position = UDim2.new(0, 8, 0, 38)
PlayerScroll.Size = UDim2.new(1, -16, 1, -80)
PlayerScroll.BackgroundTransparency = 1
PlayerScroll.BorderSizePixel = 0
PlayerScroll.ScrollBarThickness = 3
PlayerScroll.ScrollBarImageColor3 = Theme.Green
PlayerScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
PlayerScroll.ZIndex = 52

local playerGrid = Instance.new("UIGridLayout", PlayerScroll)
playerGrid.CellSize = UDim2.new(0.25, -8, 0, 26)
playerGrid.CellPadding = UDim2.new(0, 6, 0, 4)
playerGrid.SortOrder = Enum.SortOrder.LayoutOrder
playerGrid.FillDirection = Enum.FillDirection.Horizontal
playerGrid.FillDirectionMaxCells = 4

-- === НАСТРОЙКИ ПОД СПИСКОМ: КИСТИ «ИГНОРИРОВАТЬ» И «ФОКУС» ===
local playerSettings = Instance.new("Frame", PlayerPanel)
playerSettings.Position = UDim2.new(0, 8, 1, -34)
playerSettings.Size = UDim2.new(1, -16, 0, 28)
playerSettings.BackgroundTransparency = 1
playerSettings.ZIndex = 53

IgnoreBrushBtn = Instance.new("TextButton", playerSettings)
IgnoreBrushBtn.Size = UDim2.new(0.5, -18, 1, 0)
IgnoreBrushBtn.Position = UDim2.new(0, 0, 0, 0)
IgnoreBrushBtn.BackgroundColor3 = Theme.Green
IgnoreBrushBtn.Text = "Игнорировать"
IgnoreBrushBtn.TextColor3 = Color3.fromRGB(170, 30, 30)
IgnoreBrushBtn.TextSize = 11
IgnoreBrushBtn.Font = Enum.Font.GothamBold
IgnoreBrushBtn.AutoButtonColor = false
IgnoreBrushBtn.ZIndex = 54
Instance.new("UICorner", IgnoreBrushBtn).CornerRadius = UDim.new(1, 0)

FocusBrushBtn = Instance.new("TextButton", playerSettings)
FocusBrushBtn.Size = UDim2.new(0.5, -34, 1, 0)
FocusBrushBtn.Position = UDim2.new(0.5, 6, 0, 0)
FocusBrushBtn.BackgroundColor3 = Theme.Green
FocusBrushBtn.Text = "Фокус"
FocusBrushBtn.TextColor3 = Color3.fromRGB(70, 150, 230)
FocusBrushBtn.TextSize = 11
FocusBrushBtn.Font = Enum.Font.GothamBold
FocusBrushBtn.AutoButtonColor = false
FocusBrushBtn.ZIndex = 54
Instance.new("UICorner", FocusBrushBtn).CornerRadius = UDim.new(1, 0)

local ignoreBrushScale = Instance.new("UIScale", IgnoreBrushBtn)
ignoreBrushScale.Scale = 1.06
local focusBrushScale = Instance.new("UIScale", FocusBrushBtn)
focusBrushScale.Scale = 1.06

local function updateBrushVisuals()
    local ig = (_G.brushMode == "ignore")
    local fo = (_G.brushMode == "focus")
    IgnoreBrushBtn.BackgroundColor3 = ig and Color3.fromRGB(0, 150, 70) or Theme.Green
    IgnoreBrushBtn.TextColor3 = ig and Color3.fromRGB(255, 90, 90) or Color3.fromRGB(170, 30, 30)
    FocusBrushBtn.BackgroundColor3 = fo and Color3.fromRGB(0, 110, 190) or Theme.Green
    FocusBrushBtn.TextColor3 = fo and Color3.fromRGB(150, 210, 255) or Color3.fromRGB(70, 150, 230)
    ignoreBrushScale.Scale = ig and 1 or 1.06
    focusBrushScale.Scale = fo and 1 or 1.06
end
IgnoreBrushBtn.MouseButton1Click:Connect(function()
    PlayClick()
    if _G.brushMode == "ignore" then _G.brushMode = nil else _G.brushMode = "ignore" end
    updateBrushVisuals()
end)
FocusBrushBtn.MouseButton1Click:Connect(function()
    PlayClick()
    if _G.brushMode == "focus" then _G.brushMode = nil else _G.brushMode = "focus" end
    updateBrushVisuals()
end)
updateBrushVisuals()

local function rebuildPlayerPanel()
    for _, c in ipairs(PlayerScroll:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    end
    local query = (PlayerSearch.Text or ""):lower()
    local list = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and (query == "" or plr.Name:lower():find(query, 1, true)) then
            list[#list + 1] = plr
        end
    end
    table.sort(list, function(a, b) return a.Name:lower() < b.Name:lower() end)
    for i, plr in ipairs(list) do
        local ignored = _G.friendPlayers[plr.Name] == true
        local focused = (_G.focusedPlayer == plr.Name)
        local isTeam = (plr.Team ~= nil and LocalPlayer.Team ~= nil and plr.Team == LocalPlayer.Team)
        local isFriend = false
        pcall(function() isFriend = LocalPlayer:IsFriendsWith(plr.UserId) end)
        local textColor
        if focused then
            textColor = Color3.fromRGB(255, 255, 255)
        elseif ignored then
            textColor = Color3.fromRGB(255, 70, 70)
        elseif isTeam or isFriend then
            textColor = Theme.GreenBright
        else
            textColor = Color3.fromRGB(255, 255, 255)
        end
        local cell = Instance.new("TextButton", PlayerScroll)
        cell.LayoutOrder = i
        cell.BackgroundColor3 = focused and Color3.fromRGB(18, 30, 60) or (ignored and Color3.fromRGB(58, 12, 12) or Theme.BgDark)
        cell.BackgroundTransparency = 0.35
        cell.Text = plr.Name
        cell.TextColor3 = textColor
        cell.TextSize = 11
        cell.Font = Enum.Font.Gotham
        cell.TextXAlignment = Enum.TextXAlignment.Left
        cell.AutoButtonColor = false
        cell.ZIndex = 54
        Instance.new("UICorner", cell).CornerRadius = UDim.new(0, 5)
        cell.MouseButton1Click:Connect(function()
            if _G.brushMode == "ignore" then
                _G.friendPlayers[plr.Name] = not (_G.friendPlayers[plr.Name] == true)
            elseif _G.brushMode == "focus" then
                if _G.focusedPlayer == plr.Name then _G.focusedPlayer = nil else _G.focusedPlayer = plr.Name end
            else
                _G.friendPlayers[plr.Name] = not (_G.friendPlayers[plr.Name] == true)
            end
            rebuildPlayerPanel()
        end)
    end
end

PlayerSearch:GetPropertyChangedSignal("Text"):Connect(rebuildPlayerPanel)
Players.PlayerAdded:Connect(function() rebuildPlayerPanel() end)
Players.PlayerRemoving:Connect(function() rebuildPlayerPanel() end)
rebuildPlayerPanel()

-- Маленькая квадратная кнопка сброса игроков (↻).
ResetPlayersBtn = Instance.new("TextButton", playerSettings)
ResetPlayersBtn.Size = UDim2.new(0, 26, 0, 26)
ResetPlayersBtn.Position = UDim2.new(1, -26, 0, 1)
ResetPlayersBtn.BackgroundColor3 = Theme.BgRow
ResetPlayersBtn.Text = "↻"
ResetPlayersBtn.TextColor3 = Theme.GreenBright
ResetPlayersBtn.TextSize = 15
ResetPlayersBtn.Font = Enum.Font.GothamBold
ResetPlayersBtn.AutoButtonColor = false
ResetPlayersBtn.ZIndex = 55
Instance.new("UICorner", ResetPlayersBtn).CornerRadius = UDim.new(0, 6)
ResetPlayersBtn.MouseButton1Click:Connect(function()
    PlayClick()
    _G.friendPlayers = {}
    _G.focusedPlayer = nil
    _G.brushMode = nil
    updateBrushVisuals()
    rebuildPlayerPanel()
end)

-- Стрелка открывает/закрывает панель; при включении аимбота она открывается сама.
local playerPanelOpen = false
local playerPanelTween = nil
local function setPlayerPanelOpen(open)
    playerPanelOpen = open
    if playerPanelTween then playerPanelTween:Cancel() end
    if open then
        PlayerPanel.Visible = true
        PlayerPanel.Position = UDim2.new(0, 0, 1, 200)
        playerPanelTween = TweenService:Create(PlayerPanel, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 1, 24)})
        playerPanelTween:Play()
        PlayerArrow.Text = "▲"
    else
        playerPanelTween = TweenService:Create(PlayerPanel, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(0, 0, 1, 200)})
        playerPanelTween:Play()
        PlayerArrow.Text = "▼"
        task.delay(0.22, function()
            if not playerPanelOpen and PlayerPanel then PlayerPanel.Visible = false end
        end)
    end
end

PlayerArrow.MouseButton1Click:Connect(function()
    PlayClick()
    setPlayerPanelOpen(not playerPanelOpen)
end)

local wasAimbotActive = false
task.spawn(function()
    while true do
        task.wait(0.2)
        local active = MainFrame.Visible and tabs and tabs.Aimbot and tabs.Aimbot.Visible and (
            (_G.aimbotMode == "Legit" and _G.aimbotEnabled)
            or (_G.aimbotMode == "HVH" and _G.hvhAimbotEnabled)
        )
        if PlayerArrow then PlayerArrow.Visible = active end
        if active and not wasAimbotActive then
            setPlayerPanelOpen(true)
        elseif not active and wasAimbotActive then
            setPlayerPanelOpen(false)
        end
        wasAimbotActive = active
    end
end)

BgGradient = Instance.new("UIGradient", MainFrame)
BgGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 16, 10)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(4, 8, 4))
}
BgGradient.Rotation = 135

CarbonOverlay = Instance.new("Frame", MainFrame)
CarbonOverlay.Size = UDim2.new(1, 0, 1, 0)
CarbonOverlay.BackgroundTransparency = 1
CarbonOverlay.ZIndex = 1
CarbonOverlay.ClipsDescendants = true
gridLines = {}
for i = 0, 40 do
    local line = Instance.new("Frame", CarbonOverlay)
    line.Size = UDim2.new(0, 1, 1, 0)
    line.Position = UDim2.new(0, i * 14, 0, 0)
    line.BackgroundColor3 = Theme.Green
    line.BackgroundTransparency = 0.88
    line.BorderSizePixel = 0
    line.ZIndex = 1
    gridLines[#gridLines + 1] = line
end
for i = 0, 30 do
    local line = Instance.new("Frame", CarbonOverlay)
    line.Size = UDim2.new(1, 0, 0, 1)
    line.Position = UDim2.new(0, 0, 0, i * 14)
    line.BackgroundColor3 = Theme.Green
    line.BackgroundTransparency = 0.88
    line.BorderSizePixel = 0
    line.ZIndex = 1
    gridLines[#gridLines + 1] = line
end

VanityOutline = Instance.new("UIStroke", MainFrame)
VanityOutline.Color = Theme.Green
VanityOutline.Thickness = 2
VanityOutline.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
VanityOutline.ZIndex = 10

Glow1 = Instance.new("UIStroke", MainFrame)
Glow1.Color = Theme.Green
Glow1.Thickness = 5
Glow1.Transparency = 0.75
Glow1.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
Glow1.ZIndex = 9

Glow2 = Instance.new("UIStroke", MainFrame)
Glow2.Color = Theme.GreenBright
Glow2.Thickness = 10
Glow2.Transparency = 0.87
Glow2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
Glow2.ZIndex = 8

-- Реакция фона на действия (выстрел/активация): усиление пульса краёв,
-- вспышка сетки и подсветка логотипа.
menuPulseBoost = 0
actionFlash = Instance.new("Frame", MainFrame)
actionFlash.Name = "ActionFlash"
actionFlash.Size = UDim2.new(1, 0, 1, 0)
actionFlash.BackgroundTransparency = 1
actionFlash.ZIndex = 20
Instance.new("UICorner", actionFlash).CornerRadius = UDim.new(0, 12)
actionFlashStroke = Instance.new("UIStroke", actionFlash)
actionFlashStroke.Color = Theme.GreenBright
actionFlashStroke.Thickness = 3
actionFlashStroke.Transparency = 1
actionFlashStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
actionFlashStroke.ZIndex = 20

task.spawn(function()
    while task.wait(0.05) do
        if MainFrame and VanityOutline then
            local t = tick()
            local pulse = (math.sin(t * 2) + 1) / 2
            pulse = math.clamp(pulse + menuPulseBoost, 0, 1)
            VanityOutline.Transparency = 0.1 + pulse * 0.2
            Glow1.Transparency = 0.65 + pulse * 0.15
            Glow2.Transparency = 0.82 + pulse * 0.08
        end
        if menuPulseBoost > 0 then
            menuPulseBoost = math.max(0, menuPulseBoost - 0.08)
        end
    end
end)

TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 50)
TopBar.BackgroundColor3 = Theme.BgPanel
TopBar.ZIndex = 2
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 12)
TopBarFix = Instance.new("Frame", TopBar)
TopBarFix.Size = UDim2.new(1, 0, 0, 10)
TopBarFix.Position = UDim2.new(0, 0, 1, -10)
TopBarFix.BackgroundColor3 = Theme.BgPanel
TopBarFix.BorderSizePixel = 0

TopBarLine = Instance.new("Frame", TopBar)
TopBarLine.Size = UDim2.new(1, -20, 0, 1)
TopBarLine.Position = UDim2.new(0, 10, 1, -1)
TopBarLine.BackgroundColor3 = Theme.Green
TopBarLine.BackgroundTransparency = 0.4
TopBarLine.BorderSizePixel = 0
TopBarLine.ZIndex = 3

LogoFrame = CreateGreenLogo(TopBar)

-- Реакция меню на действие: усиление пульса краёв + вспышка сетки + подсветка логотипа.
function PulseMenu()
    pcall(function()
        menuPulseBoost = 0.45
        for _, ln in ipairs(gridLines) do
            if ln and ln.Parent then
                -- Мягкая, приглушённая (чуть серо-зелёная) вспышка клеток при клике.
                ln.BackgroundColor3 = Color3.fromRGB(70, 120, 90)
                ln.BackgroundTransparency = 0.74
                TweenService:Create(ln, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.88, BackgroundColor3 = Theme.Green}):Play()
            end
        end
        if actionFlashStroke then
            actionFlashStroke.Transparency = 0.6
            TweenService:Create(actionFlashStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 1}):Play()
        end
    end)
end
_G.triggerMenuPulse = PulseMenu

Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(0.6, 0, 1, 0)
Title.Position = UDim2.new(0, 52, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = localization[currentLanguage].title
Title.TextColor3 = Theme.GreenBright
Title.TextSize = 14
Title.Font = Enum.Font.Jura
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 3

LangBtn = Instance.new("TextButton", TopBar)
LangBtn.Size = UDim2.new(0, 50, 0, 24)
LangBtn.Position = UDim2.new(1, -70, 0.5, -12)
LangBtn.BackgroundColor3 = Theme.BgRow
LangBtn.Text = "RU"
LangBtn.TextColor3 = Theme.Green
LangBtn.Font = Enum.Font.GothamBold
LangBtn.TextSize = 12
LangBtn.ZIndex = 3
Instance.new("UICorner", LangBtn).CornerRadius = UDim.new(0, 6)
langStroke = Instance.new("UIStroke", LangBtn)
langStroke.Color = Theme.GreenDim
langStroke.Thickness = 1
langStroke.Transparency = 0.5

TabPanel = Instance.new("Frame", MainFrame)
TabPanel.Position = UDim2.new(0, 0, 0, 50)
TabPanel.Size = UDim2.new(0, 150, 1, -50)
TabPanel.BackgroundColor3 = Theme.BgPanel
TabPanel.ZIndex = 2
Instance.new("UICorner", TabPanel).CornerRadius = UDim.new(0, 12)
TabPanel.ClipsDescendants = true

ContentPanel = Instance.new("Frame", MainFrame)
ContentPanel.Position = UDim2.new(0, 155, 0, 55)
ContentPanel.Size = UDim2.new(0, 350, 0, 330)
ContentPanel.BackgroundTransparency = 1
ContentPanel.ClipsDescendants = true
ContentPanel.ZIndex = 2

tabScale = Instance.new("UIScale", ContentPanel)
tabScale.Scale = 1

local function createTabFrame()
    local sc = Instance.new("ScrollingFrame", ContentPanel)
    sc.Size = UDim2.new(1, 0, 1, 0)
    sc.BackgroundTransparency = 1
    sc.Visible = false
    sc.CanvasSize = UDim2.new(0, 0, 0, 0)
    sc.AutomaticCanvasSize = Enum.AutomaticSize.Y
    sc.ScrollBarThickness = 4
    sc.ScrollBarImageColor3 = Theme.GreenBright
    sc.ZIndex = 2
    local layout = Instance.new("UIListLayout", sc)
    layout.Padding = UDim.new(0, 6)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    return sc
end

tabs = {
    Aimbot = createTabFrame(),
    Visuals = createTabFrame(),
    Combat = createTabFrame(),
    Killaura = createTabFrame(),
    Movement = createTabFrame(),
    Other = createTabFrame(),
    Configs = createTabFrame()
}

registeredLabels = {}
tabButtons = {}
tabOrder = {"Aimbot", "Visuals", "Combat", "Killaura", "Movement", "Other", "Configs"}

menuVisible = true
local updateHitboxPanelVisibility
AnimPanel = nil -- пред-объявление панели анимаций

lastTabIndex = 1
local function switchTab(name)
    local targetTab = tabs[name]
    if not targetTab then return end
    -- При смене вкладки («вид переходишь») панель анимаций убирается.
    if AnimPanel then AnimPanel.Visible = false end
    -- Определяем направление слайда по порядку вкладок.
    local newIndex = 1
    for i, n in ipairs(tabOrder) do
        if n == name then newIndex = i break end
    end
    local dir = (newIndex >= lastTabIndex) and 1 or -1
    lastTabIndex = newIndex
    for k, v in pairs(tabs) do
        if k ~= name then
            v.Visible = false
            v.Position = UDim2.new(0, 0, 0, 0)
        end
    end
    targetTab.Visible = true
    -- Слайд: вкладка въезжает сбоку и плавно становится на место.
    targetTab.Position = UDim2.new(dir * 0.06, 0, 0, 0)
    TweenService:Create(targetTab, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)}):Play()
    tabScale.Scale = 0.92
    targetTab.ScrollBarImageTransparency = 1
    TweenService:Create(tabScale, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = 1}):Play()
    TweenService:Create(targetTab, TweenInfo.new(0.25), {ScrollBarImageTransparency = 0}):Play()
    if updateHitboxPanelVisibility then updateHitboxPanelVisibility() end
end

for idx, name in ipairs(tabOrder) do
    local btn = Instance.new("TextButton", TabPanel)
    btn.Size = UDim2.new(1, -16, 0, 28)
    btn.Position = UDim2.new(0, 8, 0, 8 + ((idx - 1) * 32))
    btn.BackgroundColor3 = Theme.BgRow
    btn.Text = "  " .. (localization[currentLanguage][name:lower()] or name)
    btn.TextColor3 = Theme.TextDim
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamSemibold
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.AutoButtonColor = false
    btn.ZIndex = 3
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    attachFeel(btn)

    -- Анимированная иконка-точка (пульсирует/увеличивается при наведении).
    local tabIcon = Instance.new("Frame", btn)
    tabIcon.Name = "TabIcon"
    tabIcon.Size = UDim2.new(0, 6, 0, 6)
    tabIcon.Position = UDim2.new(1, -16, 0.5, -3)
    tabIcon.BackgroundColor3 = Theme.Green
    tabIcon.BackgroundTransparency = 0.4
    tabIcon.ZIndex = 4
    Instance.new("UICorner", tabIcon).CornerRadius = UDim.new(1, 0)
    local tabIconScale = Instance.new("UIScale", tabIcon)
    btn.MouseEnter:Connect(function()
        TweenService:Create(tabIconScale, TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1.8}):Play()
        TweenService:Create(tabIcon, TweenInfo.new(0.15), {BackgroundTransparency = 0}):Play()
    end)
    btn.MouseLeave:Connect(function()
        if btn.TextColor3 ~= Theme.GreenBright then
            TweenService:Create(tabIconScale, TweenInfo.new(0.15), {Scale = 1}):Play()
            TweenService:Create(tabIcon, TweenInfo.new(0.15), {BackgroundTransparency = 0.4}):Play()
        end
    end)

    local btnStroke = Instance.new("UIStroke", btn)
    btnStroke.Color = Theme.Border
    btnStroke.Thickness = 1
    btnStroke.Transparency = 0.5

    btn.MouseEnter:Connect(function()
        if btn.TextColor3 ~= Theme.GreenBright then
            TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = Theme.BgRowHover}):Play()
        end
    end)
    btn.MouseLeave:Connect(function()
        if btn.TextColor3 ~= Theme.GreenBright then
            TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = Theme.BgRow}):Play()
        end
    end)

    table.insert(registeredLabels, {element = btn, key = name:lower(), prefix = "  "})

    btn.MouseButton1Click:Connect(function()
        PlayClick()
        switchTab(name)
        for _, b in pairs(tabButtons) do
            b.BackgroundColor3 = Theme.BgRow
            b.TextColor3 = Theme.TextDim
            local s = b:FindFirstChildOfClass("UIStroke")
            if s then s.Color = Theme.Border end
        end
        btn.BackgroundColor3 = Theme.BgRowHover
        btn.TextColor3 = Theme.GreenBright
        btnStroke.Color = Theme.Green
    end)
    tabButtons[name] = btn
end

-- === КОНФИГИ ===
-- Сохранение в файлы экзекьютора: writefile / readfile / listfiles / delfile.
-- Папка: IMPULSE/configs, формат — JSON.
local CONFIG_DIR = "IMPULSE/configs"
local CONFIG_KEYS = {
    -- аимбот
    "aimbotEnabled", "hvhAimbotEnabled", "hvhTargetLockEnabled", "fovRadius", "aimSmoothing",
    "ignoreFriends", "ignoreBehindWalls", "autoAimRMB", "dynamicFovEnabled", "dynamicFovStart",
    "dynamicFovMax", "aimJitterEnabled", "aimJitterStrength", "aimMissEnabled",
    "aimMissChance", "aimMissOffset", "aimAutoStopEnabled", "aimAutoStopStrength",
    "forcePriorityAim", "priorityAimSpeed",
    -- анти-аим
    "hvhAntiAimEnabled", "aaUiYaw", "aaUiPitch", "aaUiMain", "aaYaw", "aaPitch",
    "aaSpinEnabled", "aaSpinSpeed", "aaJitterEnabled", "aaJitterSpeed", "aaJitterStrength",
    "aaBypassEnabled", "aaDesyncEnabled", "aaFakeRun", "aaPitchDir",
    -- бой и движение
    "triggerbotEnabled", "killauraEnabled", "antiRecoil", "invisibleEnabled",
    "SpeedHackEnabled", "SpeedValue", "autoStrafeEnabled", "autoStrafeStrength",
    "wallPassEnabled", "infJumpEnabled", "bhopEnabled", "spiderEnabled", "noFallDamage",
    "antiAfkEnabled", "tpMouseEnabled",
    -- визуалы
    "espBoxes", "espNames", "espHpText", "espDistance", "espSkeletons", "espChams",
    "espTracers", "viewDirection", "weaponEsp", "espTextSize", "fullbrightEnabled",
    "worldThirdPerson", "worldThirdPersonDist", "skyboxEnabled", "skyboxIndex",
    "chamsFillTransparency", "currentChamsStyle", "espColor",
}

local configStatusLabel
local configListFrame

-- JSON через HttpService, а если он недоступен — свой простой формат.
local function cfgJsonEncode(data)
    if HttpService then
        local ok, res = pcall(function() return HttpService:JSONEncode(data) end)
        if ok and type(res) == "string" then return res end
    end
    local parts = {}
    for k, v in pairs(data) do
        local tv = type(v)
        local val
        if tv == "number" then
            val = tostring(v)
        elseif tv == "boolean" then
            val = tostring(v)
        elseif tv == "string" then
            val = '"' .. v:gsub('[%c"\\]', function(c)
                local map = {['"'] = '\\"', ['\\'] = '\\\\', ['\n'] = '\\n', ['\r'] = '\\r', ['\t'] = '\\t'}
                return map[c] or ""
            end) .. '"'
        end
        if val then parts[#parts + 1] = '"' .. tostring(k) .. '":' .. val end
    end
    return "{" .. table.concat(parts, ",") .. "}"
end

local function cfgJsonDecode(raw)
    if HttpService then
        local ok, res = pcall(function() return HttpService:JSONDecode(raw) end)
        if ok and type(res) == "table" then return res end
    end
    local out = {}
    for key, value in tostring(raw):gmatch('"([%w_]+)"%s*:%s*([^,}]+)') do
        local v = value:gsub("^%s+", ""):gsub("%s+$", "")
        if v == "true" then
            out[key] = true
        elseif v == "false" then
            out[key] = false
        elseif v:sub(1, 1) == '"' then
            out[key] = v:sub(2, -2):gsub('\\"', '"')
        else
            out[key] = tonumber(v)
        end
    end
    return out
end

local function cfgCall(fn, ...)
    local ok, res = pcall(fn, ...)
    if ok then return res end
    return nil
end

local function cfgEnsure()
    if type(makefolder) ~= "function" then return false end
    -- Некоторые экзекьюторы не создают вложенные папки одной командой.
    cfgCall(makefolder, "IMPULSE")
    cfgCall(makefolder, CONFIG_DIR)
    return true
end

local function cfgFiles()
    local out = {}
    if type(listfiles) ~= "function" then return out end
    local files = cfgCall(listfiles, CONFIG_DIR) or {}
    for _, path in ipairs(files) do
        local name = tostring(path):match("([^/\\]+)%.json$")
        if name then table.insert(out, name) end
    end
    table.sort(out)
    return out
end

local function cfgPath(name)
    return CONFIG_DIR .. "/" .. name .. ".json"
end

local function cfgSave(name)
    if type(writefile) ~= "function" then return false, "экзекьютор не умеет writefile" end
    if not cfgEnsure() then return false, "нет доступа к файлам" end
    local data = {}
    for _, key in ipairs(CONFIG_KEYS) do
        local v = _G[key]
        local tv = type(v)
        if tv == "boolean" or tv == "number" or tv == "string" then data[key] = v end
    end
    data.__weightHead = _G.AimbotWeights and _G.AimbotWeights.Head
    data.__weightChest = _G.AimbotWeights and _G.AimbotWeights.Chest
    data.__weightWaist = _G.AimbotWeights and _G.AimbotWeights.Waist
    data.__weightLegs = _G.AimbotWeights and _G.AimbotWeights.Legs
    local encoded = cfgJsonEncode(data)
    if type(encoded) ~= "string" or encoded == "" then return false, "не удалось собрать JSON" end
    local path = cfgPath(name)
    local okWrite, res = pcall(writefile, path, encoded)
    if not okWrite then return false, "запись не удалась" end
    -- Часть экзекьюторов ничего не возвращает, поэтому считаем nil успехом
    -- и проверяем файл через isfile, если такая функция есть.
    if type(isfile) == "function" then
        if cfgCall(isfile, path) == false then return false, "файл не создался" end
    elseif res == false then
        return false, "запись не удалась"
    end
    return true
end

local function cfgLoad(name)
    if type(readfile) ~= "function" then return false, "экзекьютор не умеет readfile" end
    local raw = cfgCall(readfile, cfgPath(name))
    if not raw then return false, "файл не найден" end
    local data = cfgJsonDecode(raw)
    if type(data) ~= "table" or next(data) == nil then return false, "файл повреждён" end
    for key, v in pairs(data) do
        if key:sub(1, 8) ~= "__weight" and _G[key] ~= nil and type(_G[key]) == type(v) then
            _G[key] = v
        end
    end
    if _G.AimbotWeights then
        _G.AimbotWeights.Head = data.__weightHead or _G.AimbotWeights.Head
        _G.AimbotWeights.Chest = data.__weightChest or _G.AimbotWeights.Chest
        _G.AimbotWeights.Waist = data.__weightWaist or _G.AimbotWeights.Waist
        _G.AimbotWeights.Legs = data.__weightLegs or _G.AimbotWeights.Legs
    end
    -- Обновляем тумблеры, чтобы интерфейс совпал с загруженным конфигом.
    if setToggleVisual then
        for _, key in ipairs(CONFIG_KEYS) do
            if type(_G[key]) == "boolean" then cfgCall(setToggleVisual, key, _G[key]) end
        end
    end
    -- Ползунки тоже должны встать на загруженные значения.
    if refreshSliderVisual then
        for _, key in ipairs(CONFIG_KEYS) do
            if type(_G[key]) == "number" then cfgCall(refreshSliderVisual, key) end
        end
    end
    return true
end

local function cfgDelete(name)
    if type(delfile) ~= "function" then return false, "экзекьютор не умеет delfile" end
    cfgCall(delfile, cfgPath(name))
    return true
end

local function cfgMakeButton(parent, text, order, primary)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, -16, 0, 30)
    btn.LayoutOrder = order
    btn.BackgroundColor3 = primary and Theme.Green or Theme.BgRow
    btn.Text = text
    btn.TextColor3 = primary and Color3.fromRGB(10, 16, 11) or Theme.TextMain
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    btn.ZIndex = 3
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 7)
    if attachFeel then cfgCall(attachFeel, btn) end
    return btn
end

local configNameBox
local function cfgRefresh()
    if not configListFrame then return end
    for _, ch in ipairs(configListFrame:GetChildren()) do
        if ch:IsA("TextButton") or ch:IsA("Frame") then ch:Destroy() end
    end
    local files = cfgFiles()
    if #files == 0 then
        local empty = Instance.new("TextLabel", configListFrame)
        empty.Size = UDim2.new(1, -16, 0, 26)
        empty.BackgroundTransparency = 1
        empty.Text = "Конфигов пока нет"
        empty.TextColor3 = Theme.TextDim
        empty.TextSize = 11
        empty.Font = Enum.Font.Gotham
        return
    end
    for idx, name in ipairs(files) do
        local row = Instance.new("Frame", configListFrame)
        row.Size = UDim2.new(1, -16, 0, 30)
        row.LayoutOrder = idx
        row.BackgroundColor3 = Theme.BgRow
        row.BackgroundTransparency = 0.35
        row.BorderSizePixel = 0
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 7)

        local label = Instance.new("TextLabel", row)
        label.Size = UDim2.new(1, -110, 1, 0)
        label.Position = UDim2.new(0, 10, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = name
        label.TextColor3 = Theme.TextMain
        label.TextSize = 12
        label.Font = Enum.Font.GothamSemibold
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextTruncate = Enum.TextTruncate.AtEnd

        local loadBtn = Instance.new("TextButton", row)
        loadBtn.Size = UDim2.new(0, 52, 0, 22)
        loadBtn.Position = UDim2.new(1, -102, 0.5, -11)
        loadBtn.BackgroundColor3 = Theme.Green
        loadBtn.Text = "Взять"
        loadBtn.TextColor3 = Color3.fromRGB(10, 16, 11)
        loadBtn.TextSize = 11
        loadBtn.Font = Enum.Font.GothamBold
        loadBtn.AutoButtonColor = false
        Instance.new("UICorner", loadBtn).CornerRadius = UDim.new(0, 6)

        local delBtn = Instance.new("TextButton", row)
        delBtn.Size = UDim2.new(0, 36, 0, 22)
        delBtn.Position = UDim2.new(1, -44, 0.5, -11)
        delBtn.BackgroundColor3 = Color3.fromRGB(70, 20, 20)
        delBtn.Text = "×"
        delBtn.TextColor3 = Color3.fromRGB(255, 140, 140)
        delBtn.TextSize = 13
        delBtn.Font = Enum.Font.GothamBold
        delBtn.AutoButtonColor = false
        Instance.new("UICorner", delBtn).CornerRadius = UDim.new(0, 6)

        loadBtn.MouseButton1Click:Connect(function()
            if PlayClick then cfgCall(PlayClick) end
            local ok, err = cfgLoad(name)
            if configStatusLabel then
                configStatusLabel.Text = ok and ("Загружено: " .. name) or ("Ошибка: " .. tostring(err))
                configStatusLabel.TextColor3 = ok and Theme.GreenBright or Color3.fromRGB(255, 120, 120)
            end
        end)
        delBtn.MouseButton1Click:Connect(function()
            if PlayClick then cfgCall(PlayClick) end
            cfgDelete(name)
            cfgRefresh()
            if configStatusLabel then
                configStatusLabel.Text = "Удалено: " .. name
                configStatusLabel.TextColor3 = Theme.TextDim
            end
        end)
        configListFrame.CanvasSize = UDim2.new(0, 0, 0, #files * 36)
    end
end

local function buildConfigTab()
    local tab = tabs.Configs
    if not tab then return end
    local header = Instance.new("Frame", tab)
    header.Size = UDim2.new(1, -16, 0, 30)
    header.LayoutOrder = 0
    header.BackgroundTransparency = 1
    local hText = Instance.new("TextLabel", header)
    hText.Size = UDim2.new(1, 0, 1, 0)
    hText.BackgroundTransparency = 1
    hText.Text = "Конфиги меню"
    hText.TextColor3 = Theme.TextMain
    hText.TextSize = 13
    hText.Font = Enum.Font.GothamBold
    hText.TextXAlignment = Enum.TextXAlignment.Left

    configNameBox = Instance.new("TextBox", tab)
    configNameBox.Size = UDim2.new(1, -16, 0, 30)
    configNameBox.LayoutOrder = 1
    configNameBox.BackgroundColor3 = Theme.BgRow
    configNameBox.Text = "мой конфиг"
    configNameBox.PlaceholderText = "Название конфига"
    configNameBox.TextColor3 = Theme.TextMain
    configNameBox.PlaceholderColor3 = Theme.TextDim
    configNameBox.TextSize = 12
    configNameBox.Font = Enum.Font.Gotham
    configNameBox.ClearTextOnFocus = false
    configNameBox.ZIndex = 3
    Instance.new("UICorner", configNameBox).CornerRadius = UDim.new(0, 7)

    local saveBtn = cfgMakeButton(tab, "Сохранить конфиг", 2, true)
    local refreshBtn = cfgMakeButton(tab, "Обновить список", 3, false)

    configStatusLabel = Instance.new("TextLabel", tab)
    configStatusLabel.Size = UDim2.new(1, -16, 0, 18)
    configStatusLabel.LayoutOrder = 4
    configStatusLabel.BackgroundTransparency = 1
    configStatusLabel.Text = ""
    configStatusLabel.TextColor3 = Theme.TextDim
    configStatusLabel.TextSize = 11
    configStatusLabel.Font = Enum.Font.Gotham
    configStatusLabel.TextXAlignment = Enum.TextXAlignment.Left

    configListFrame = Instance.new("ScrollingFrame", tab)
    configListFrame.Size = UDim2.new(1, -16, 0, 210)
    configListFrame.LayoutOrder = 5
    configListFrame.BackgroundTransparency = 1
    configListFrame.BorderSizePixel = 0
    configListFrame.ScrollBarThickness = 2
    configListFrame.ScrollBarImageColor3 = Theme.Green
    configListFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    local listLayout = Instance.new("UIListLayout", configListFrame)
    listLayout.Padding = UDim.new(0, 6)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder

    saveBtn.MouseButton1Click:Connect(function()
        if PlayClick then cfgCall(PlayClick) end
        local name = (configNameBox.Text or ""):gsub("^%s+", ""):gsub("%s+$", "")
        if name == "" then name = "config" end
        name = name:gsub("[\\/:*?\"<>|]", "_")
        local ok, err = cfgSave(name)
        if configStatusLabel then
            configStatusLabel.Text = ok and ("Сохранено: " .. name) or ("Ошибка: " .. tostring(err))
            configStatusLabel.TextColor3 = ok and Theme.GreenBright or Color3.fromRGB(255, 120, 120)
        end
        if ok then cfgRefresh() end
    end)

    refreshBtn.MouseButton1Click:Connect(function()
        if PlayClick then cfgCall(PlayClick) end
        cfgRefresh()
        if configStatusLabel then
            configStatusLabel.Text = ("Файлы: " .. CONFIG_DIR)
            configStatusLabel.TextColor3 = Theme.TextDim
        end
    end)

    cfgRefresh()
end

cfgCall(buildConfigTab)

-- === ПАНЕЛЬ АНИМАЦИЙ (справа, как у манекена) ===
function buildAnimPanel()
AnimPanel = Instance.new("Frame", MainFrame)
AnimPanel.Name = "AnimationsPanel"
AnimPanel.AnchorPoint = Vector2.new(0, 0.5)
AnimPanel.Position = UDim2.new(1, -10, 0.5, 0)
AnimPanel.Size = UDim2.new(0, 250, 0, 400)
AnimPanel.BackgroundColor3 = Theme.BgDark
AnimPanel.BackgroundTransparency = 0.03
AnimPanel.Visible = false
AnimPanel.ZIndex = 100
Instance.new("UICorner", AnimPanel).CornerRadius = UDim.new(0, 12)
local animPanelStroke = Instance.new("UIStroke", AnimPanel)
animPanelStroke.Color = Theme.Green
animPanelStroke.Thickness = 1
animPanelStroke.Transparency = 0.4

-- Мягкое свечение рамки
local animGlow = Instance.new("UIStroke", AnimPanel)
animGlow.Color = Theme.GreenBright
animGlow.Thickness = 4
animGlow.Transparency = 0.82
animGlow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- Фон-клетка (в стиле «часов»)
local animGrid = Instance.new("Frame", AnimPanel)
animGrid.Size = UDim2.new(1, 0, 1, 0)
animGrid.BackgroundTransparency = 1
animGrid.ClipsDescendants = true
animGrid.ZIndex = 100
Instance.new("UICorner", animGrid).CornerRadius = UDim.new(0, 12)
for i = 0, 18 do
    local vline = Instance.new("Frame", animGrid)
    vline.Size = UDim2.new(0, 1, 1, 0)
    vline.Position = UDim2.new(0, i * 14, 0, 0)
    vline.BackgroundColor3 = Theme.Green
    vline.BackgroundTransparency = 0.9
    vline.BorderSizePixel = 0
    vline.ZIndex = 100
end
for i = 0, 28 do
    local hline = Instance.new("Frame", animGrid)
    hline.Size = UDim2.new(1, 0, 0, 1)
    hline.Position = UDim2.new(0, 0, 0, i * 14)
    hline.BackgroundColor3 = Theme.Green
    hline.BackgroundTransparency = 0.9
    hline.BorderSizePixel = 0
    hline.ZIndex = 100
end

local animTitle = Instance.new("TextLabel", AnimPanel)
animTitle.Size = UDim2.new(1, -50, 0, 40)
animTitle.Position = UDim2.new(0, 14, 0, 6)
animTitle.BackgroundTransparency = 1
animTitle.Text = "АНИМАЦИИ"
animTitle.TextColor3 = Theme.GreenBright
animTitle.TextSize = 15
animTitle.Font = Enum.Font.Jura
animTitle.TextXAlignment = Enum.TextXAlignment.Left
animTitle.ZIndex = 102

local animClose = Instance.new("TextButton", AnimPanel)
animClose.Size = UDim2.new(0, 26, 0, 26)
animClose.Position = UDim2.new(1, -34, 0, 12)
animClose.BackgroundColor3 = Theme.BgRow
animClose.Text = "✕"
animClose.TextColor3 = Theme.TextDim
animClose.Font = Enum.Font.GothamBold
animClose.TextSize = 13
animClose.AutoButtonColor = false
animClose.ZIndex = 102
Instance.new("UICorner", animClose).CornerRadius = UDim.new(0, 6)
animClose.MouseButton1Click:Connect(function()
    PlayClick()
    AnimPanel.Visible = false
end)

local animScroll = Instance.new("ScrollingFrame", AnimPanel)
animScroll.Size = UDim2.new(1, -16, 1, -52)
animScroll.Position = UDim2.new(0, 8, 0, 46)
animScroll.BackgroundTransparency = 1
animScroll.BorderSizePixel = 0
animScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
animScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
animScroll.ScrollBarThickness = 4
animScroll.ScrollBarImageColor3 = Theme.GreenBright
animScroll.ZIndex = 101
local animLayout = Instance.new("UIListLayout", animScroll)
animLayout.Padding = UDim.new(0, 5)
animLayout.SortOrder = Enum.SortOrder.LayoutOrder

local animOrder = 0
local function animOrderNext()
    animOrder = animOrder + 1
    return animOrder
end

-- Применение анимации к персонажу
local currentAnimTrack = nil
local function stopCustomAnimation(restoreAnimate)
    if currentAnimTrack then pcall(function() currentAnimTrack:Stop() end) end
    currentAnimTrack = nil
    if restoreAnimate ~= false then
        local char = LocalPlayer.Character
        local animate = char and char:FindFirstChild("Animate")
        if animate then pcall(function() animate.Disabled = false end) end
    end
end

-- Таблица паков: ВНУТРЕННИЕ id анимаций (idle/walk/run/jump/fall/climb/swim).
-- (id пака — это bundle; играть надо эти отдельные анимации.)
local ANIM_PACKS = {
    {name = "67", idle = 131615763118869, walk = 73305802913801, run = 71492775028835, jump = 80252381525544, fall = 102746074461880, climb = 86051297640177, swim = 103791932450882},
    {name = "Анти-аим (CSGO)", idle = 99022838755345, walk = 123133084737812, run = 121048618200276, jump = 116998869045102, fall = 130780690853448, climb = 128230983521290, swim = 135590333135192},
    {name = "Мини-чел (Mini Chibi)", idle = 120334563069076, walk = 102772460432563, run = 108433935463014, jump = 75204372096605, fall = 100526605114235, climb = 132739582723847, swim = 116174839992761},
    {name = "Аура (Endless Floating)", idle = 75638427965557, walk = 131290152729043, run = 77610456891399, jump = 74451563346167, fall = 74203422263286, climb = 116293937663140, swim = 110044773049875},
    {name = "На голове (Headless)", idle = 118314720917722, walk = 87609396024598, run = 82338987464047, jump = 85894771026784, fall = 115632952355852, climb = 107558689118119, swim = 97130232121269},
}

local origAnimIds = nil
local function animIdStr(id)
    if type(id) == "number" then return string.format("%.0f", id) end
    return tostring(id)
end
local function captureOrigAnims(animate)
    if origAnimIds then return end
    origAnimIds = {}
    for _, a in ipairs(animate:GetDescendants()) do
        if a:IsA("Animation") then
            origAnimIds[a] = a.AnimationId
        end
    end
end
local function setAnimId(animate, name, id)
    if not id then return end
    local a = animate:FindFirstChild(name, true)
    if a and a:IsA("Animation") then
        a.AnimationId = "rbxassetid://" .. animIdStr(id)
    end
end
local function restartAnimate(animate)
    pcall(function()
        animate.Disabled = true
        task.wait()
        animate.Disabled = false
    end)
end
local function applyAnimationPack(pack)
    local char = LocalPlayer.Character
    if not char then return end
    local animate = char:FindFirstChild("Animate")
    if not animate then return end
    stopCustomAnimation(false)
    captureOrigAnims(animate)
    animate.Disabled = false
    setAnimId(animate, "idle", pack.idle)
    setAnimId(animate, "walk", pack.walk)
    setAnimId(animate, "run", pack.run)
    setAnimId(animate, "jump", pack.jump)
    setAnimId(animate, "fall", pack.fall)
    setAnimId(animate, "climb", pack.climb)
    setAnimId(animate, "swim", pack.swim)
    setAnimId(animate, "swimidle", pack.swim)
    restartAnimate(animate)
end
local function restoreDefaultAnimations()
    local char = LocalPlayer.Character
    if not char then return end
    local animate = char:FindFirstChild("Animate")
    stopCustomAnimation(true)
    if animate and origAnimIds then
        for a, id in pairs(origAnimIds) do
            if a and a.Parent then pcall(function() a.AnimationId = id end) end
        end
        restartAnimate(animate)
    end
    origAnimIds = nil
end

local function addAnimSection(text)
    local lbl = Instance.new("TextLabel", animScroll)
    lbl.Size = UDim2.new(1, -8, 0, 20)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Theme.Green
    lbl.TextSize = 12
    lbl.Font = Enum.Font.Jura
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.LayoutOrder = animOrderNext()
    lbl.ZIndex = 102
end

local function addAnimButton(text, pack)
    local btn = Instance.new("TextButton", animScroll)
    btn.Size = UDim2.new(1, -8, 0, 26)
    btn.BackgroundColor3 = Theme.BgRow
    btn.Text = "  " .. text
    btn.TextColor3 = Theme.TextMain
    btn.TextSize = 12
    btn.Font = Enum.Font.Gotham
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.AutoButtonColor = false
    btn.LayoutOrder = animOrderNext()
    btn.ZIndex = 102
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    attachFeel(btn)
    btn.MouseButton1Click:Connect(function()
        PlayClick()
        applyAnimationPack(pack)
    end)
end

addAnimSection("Анимации")
for _, pack in ipairs(ANIM_PACKS) do
    addAnimButton(pack.name, pack)
end

local animStopBtn = Instance.new("TextButton", animScroll)
animStopBtn.Size = UDim2.new(1, -8, 0, 26)
animStopBtn.BackgroundColor3 = Color3.fromRGB(60, 30, 30)
animStopBtn.Text = "ВЕРНУТЬ ОБЫЧНЫЕ"
animStopBtn.TextColor3 = Theme.TextMain
animStopBtn.TextSize = 12
animStopBtn.Font = Enum.Font.Jura
animStopBtn.AutoButtonColor = false
animStopBtn.LayoutOrder = animOrderNext()
animStopBtn.ZIndex = 102
Instance.new("UICorner", animStopBtn).CornerRadius = UDim.new(0, 6)
attachFeel(animStopBtn)
animStopBtn.MouseButton1Click:Connect(function()
    PlayClick()
    restoreDefaultAnimations()
end)
end
-- (встроенная панель анимаций отключена; вместо неё — отдельная галерея AnimGallery)

-- === КНОПКИ АНИМАЦИЙ И ВЫГРУЗКИ ===
local AnimationsBtn = Instance.new("TextButton", TabPanel)
AnimationsBtn.Size = UDim2.new(1, -16, 0, 28)
AnimationsBtn.Position = UDim2.new(0, 8, 1, -70)
AnimationsBtn.BackgroundColor3 = Theme.Green
AnimationsBtn.Text = localization[currentLanguage].legitConfig or "LEGIT-CONFIG"
AnimationsBtn.TextColor3 = Color3.fromRGB(10, 15, 10)
AnimationsBtn.TextSize = 11
AnimationsBtn.Font = Enum.Font.GothamBold
AnimationsBtn.AutoButtonColor = false
AnimationsBtn.ZIndex = 3
table.insert(registeredLabels, {element = AnimationsBtn, key = "legitConfig"})
Instance.new("UICorner", AnimationsBtn).CornerRadius = UDim.new(0, 8)
AnimationsBtn.MouseEnter:Connect(function()
    TweenService:Create(AnimationsBtn, TweenInfo.new(0.12), {BackgroundColor3 = Theme.GreenBright}):Play()
end)
AnimationsBtn.MouseLeave:Connect(function()
    TweenService:Create(AnimationsBtn, TweenInfo.new(0.12), {BackgroundColor3 = Theme.Green}):Play()
end)
AnimationsBtn.MouseButton1Click:Connect(function()
    PlayClick()
    if applyLegitConfig then
        pcall(applyLegitConfig)
        AnimationsBtn.Text = (currentLanguage == "RU" and "КОНФИГ ПРИМЕНЁН" or "CONFIG APPLIED")
        task.delay(0.9, function()
            if AnimationsBtn and AnimationsBtn.Parent then
                AnimationsBtn.Text = localization[currentLanguage].legitConfig or "LEGIT-CONFIG"
            end
        end)
    end
end)

local UnloadBtn = Instance.new("TextButton", TabPanel)
UnloadBtn.Size = UDim2.new(1, -16, 0, 28)
UnloadBtn.Position = UDim2.new(0, 8, 1, -36)
UnloadBtn.BackgroundColor3 = Color3.fromRGB(120, 30, 30)
UnloadBtn.Text = localization[currentLanguage].unload
UnloadBtn.TextColor3 = Theme.TextMain
UnloadBtn.TextSize = 11
UnloadBtn.Font = Enum.Font.GothamBold
UnloadBtn.AutoButtonColor = false
UnloadBtn.ZIndex = 3
table.insert(registeredLabels, {element = UnloadBtn, key = "unload"})
Instance.new("UICorner", UnloadBtn).CornerRadius = UDim.new(0, 8)
UnloadBtn.MouseEnter:Connect(function()
    TweenService:Create(UnloadBtn, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(160, 40, 40)}):Play()
end)
UnloadBtn.MouseLeave:Connect(function()
    TweenService:Create(UnloadBtn, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(120, 30, 30)}):Play()
end)
UnloadBtn.MouseButton1Click:Connect(function()
    PlayClick()
    if fullUnload then
        pcall(fullUnload)
    else
        pcall(function()
            MenuBlur:Destroy()
            ScreenGui:Destroy()
        end)
    end
end)

_G.expandedAccordions = {}

_G.toggleRefs = {}
_G.sliderUiRefs = {}
_G.dropdownRefs = {}

function refreshToggleVisual(gVar)
    local r = _G.toggleRefs and _G.toggleRefs[gVar]
    if not r or not r.switch or not r.switch.Parent then return end
    local on = _G[gVar] and true or false
    r.switch.BackgroundColor3 = on and Theme.Green or Color3.fromRGB(40, 45, 40)
    if r.circle and r.circle.Parent then
        r.circle.Position = on and UDim2.new(0, 24, 0.5, -7) or UDim2.new(0, 4, 0.5, -7)
    end
end

function setToggleVisual(gVar, state)
    if state ~= nil then _G[gVar] = state end
    refreshToggleVisual(gVar)
end

function refreshSliderVisual(gVar)
    local r = _G.sliderUiRefs and _G.sliderUiRefs[gVar]
    if not r or not r.fill or not r.fill.Parent then return end
    local v = tonumber(_G[gVar]) or 0
    local pct = math.clamp((v - r.min) / math.max(r.max - r.min, 0.0001), 0, 1)
    r.fill.Size = UDim2.new(pct, 0, 1, 0)
    r.knob.Position = UDim2.new(pct, 0, 0.5, 0)
    r.pctLabel.Text = r.formatVal(v)
end

function refreshDropdownVisual(gVar)
    local r = _G.dropdownRefs and _G.dropdownRefs[gVar]
    if r and r.btn and r.btn.Parent then
        r.btn.Text = (localization[currentLanguage][r.textKey] or r.textKey) .. ": " .. tostring(_G[gVar])
    end
end

local function createAdvancedToggle(parent, textKey, globalVar, order, creationCallback)
    local baseContainer = Instance.new("Frame", parent)
    baseContainer.Size = UDim2.new(1, -10, 0, 38)
    baseContainer.BackgroundTransparency = 1
    baseContainer.LayoutOrder = order
    baseContainer.ClipsDescendants = true
    baseContainer.ZIndex = 2

    local mainRow = Instance.new("Frame", baseContainer)
    mainRow.Size = UDim2.new(1, 0, 0, 38)
    mainRow.BackgroundColor3 = Theme.BgRow
    mainRow.ZIndex = 2
    Instance.new("UICorner", mainRow).CornerRadius = UDim.new(0, 8)
    local mainStroke = Instance.new("UIStroke", mainRow)
    mainStroke.Color = Theme.Border
    mainStroke.Thickness = 1
    mainStroke.Transparency = 0.5
    local pad = Instance.new("UIPadding", mainRow)
    pad.PaddingLeft, pad.PaddingRight = UDim.new(0, 12), UDim.new(0, 12)

    local triangle = Instance.new("TextButton", mainRow)
    triangle.Size = UDim2.new(0, 20, 0, 20)
    triangle.Position = UDim2.new(0, 0, 0.5, -10)
    triangle.BackgroundTransparency = 1
    triangle.Text = "►"
    triangle.TextColor3 = Theme.Green
    triangle.TextSize = 14
    triangle.Font = Enum.Font.GothamBold
    triangle.AutoButtonColor = false
    triangle.ZIndex = 3
    attachFeel(baseContainer, triangle)

    local label = Instance.new("TextLabel", mainRow)
    label.Size = UDim2.new(0, 220, 1, 0)
    label.Position = UDim2.new(0, 25, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = localization[currentLanguage][textKey] or textKey
    label.TextColor3 = Theme.TextMain
    label.TextSize = 13
    label.Font = Enum.Font.Jura
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 3
    table.insert(registeredLabels, {element = label, key = textKey})

    local switch = Instance.new("TextButton", mainRow)
    switch.Size = UDim2.new(0, 42, 0, 20)
    switch.Position = UDim2.new(1, -42, 0.5, -10)
    switch.BackgroundColor3 = _G[globalVar] and Theme.Green or Color3.fromRGB(40, 45, 40)
    switch.Text = ""
    switch.AutoButtonColor = false
    switch.ZIndex = 3
    Instance.new("UICorner", switch).CornerRadius = UDim.new(1, 0)
    local circle = Instance.new("Frame", switch)
    circle.Size = UDim2.new(0, 14, 0, 14)
    circle.Position = _G[globalVar] and UDim2.new(0, 24, 0.5, -7) or UDim2.new(0, 4, 0.5, -7)
    circle.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    circle.ZIndex = 4
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

    _G.toggleRefs[globalVar] = { switch = switch, circle = circle }

    local subContent = Instance.new("Frame", baseContainer)
    subContent.Name = "SubContent"
    subContent.Size = UDim2.new(1, 0, 0, 0)
    subContent.Position = UDim2.new(0, 0, 0, 42)
    subContent.BackgroundColor3 = Theme.BgDark
    subContent.BackgroundTransparency = 0.2
    subContent.ClipsDescendants = true
    subContent.ZIndex = 2
    Instance.new("UICorner", subContent).CornerRadius = UDim.new(0, 8)
    local subList = Instance.new("UIListLayout", subContent)
    subList.Padding = UDim.new(0, 6)
    subList.SortOrder = Enum.SortOrder.LayoutOrder

    switch.MouseButton1Click:Connect(function()
        PlayClick()
        _G[globalVar] = not _G[globalVar]
        TweenService:Create(switch, TweenInfo.new(0.15), {BackgroundColor3 = _G[globalVar] and Theme.Green or Color3.fromRGB(40, 45, 40)}):Play()
        TweenService:Create(circle, TweenInfo.new(0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = _G[globalVar] and UDim2.new(0, 24, 0.5, -7) or UDim2.new(0, 4, 0.5, -7)}):Play()
        -- Main выключен — гасим Spin/Jitter, чтобы «Main» реально выключал функцию.
        if globalVar == "aaUiMain" and not _G[globalVar] then
            _G.aaSpinEnabled = false
            _G.aaJitterEnabled = false
            pcall(function() setToggleVisual("aaSpinEnabled", false) end)
            pcall(function() setToggleVisual("aaJitterEnabled", false) end)
        end
        if globalVar == "aimbotEnabled" and updateHitboxPanelVisibility then
            updateHitboxPanelVisibility()
        end
    end)

    local function measureSubHeight()
        -- силы рендер вложенного содержимого: подождём кадр, чтобы AbsoluteContentSize
        -- учитывал раскрытые внутренние аккордеоны
        task.wait()
        return subList.AbsoluteContentSize.Y + 10
    end

    -- Пересчитывает высоту всех ПРЕДКОВ этого аккордеона после того, как
    -- изменился (раскрылся) любой вложенный аккордеон. Вложенная структура:
    -- внешний baseContainer -> SubContent -> внутренние baseContainer'ы.
    local function cascadeUp(contLayer)
        local guard = 0
        local outer = contLayer
        while outer and guard < 20 do
            guard = guard + 1
            local host = outer.Parent -- SubContent, содержащий наш аккордеон
            if host and host.Name == "SubContent" and host.Parent then
                local upper = host.Parent -- родительский baseContainer
                local upperSub = upper:FindFirstChild("SubContent")
                local upperList = upperSub and upperSub:FindFirstChild("UIListLayout")
                if upperSub and upperList then
                    local h = upperList.AbsoluteContentSize.Y + 10
                    upperSub.Size = UDim2.new(1, 0, 0, math.max(h, 0))
                    upper.Size = UDim2.new(1, -10, 0, 44 + math.max(h, 0))
                end
                outer = upper
            else
                break
            end
        end
        -- Обновляем скроллер (контейнер содержимого), чтобы раскрытое меню было видно.
        local sc = contLayer
        while sc and not sc:IsA("ScrollingFrame") do sc = sc.Parent end
        if sc and sc:FindFirstChild("UIListLayout") then
            sc.CanvasSize = UDim2.new(0, 0, 0, sc.UIListLayout.AbsoluteContentSize.Y + 20)
        end
    end

    -- При любом изменении (раскрытии/сворачивании) поднимаем высоты предков
    -- и пересчитываем несколько раз, чтобы вложенное содержимое успело отрисоваться.
    local function refreshHierarchy(start)
        task.wait(0.02)
        cascadeUp(start)
        task.delay(0.15, function()
            if start and start.Parent then cascadeUp(start) end
        end)
        task.delay(0.35, function()
            if start and start.Parent then cascadeUp(start) end
        end)
    end

    local isExpanded = _G.expandedAccordions[textKey] or false
    local function setExpanded(expand, skipMeasure)
        PlayClick()
        isExpanded = expand
        _G.expandedAccordions[textKey] = expand

        local neededHeight = 0
        if isExpanded and not skipMeasure then
            neededHeight = measureSubHeight()
        end

        local function applySize(h)
            TweenService:Create(triangle, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Rotation = isExpanded and 90 or 0}):Play()
            TweenService:Create(baseContainer, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = UDim2.new(1, -10, 0, isExpanded and (44 + math.max(h, 0)) or 38)}):Play()
            TweenService:Create(subContent, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = UDim2.new(1, 0, 0, math.max(h, 0))}):Play()
        end

        if isExpanded then
            baseContainer.AutomaticSize = Enum.AutomaticSize.None
            subContent.AutomaticSize = Enum.AutomaticSize.None
            applySize(neededHeight)
            -- Пересчитываем ПОСЛЕ анимации раскрытия: вложенные аккордеоны могли
            -- раскрыться, поэтому высота родительских контейнеров должна подрасти
            -- (иначе нижняя часть меню обрезается).
            refreshHierarchy(baseContainer)
            task.delay(0.22, function()
                if subContent and subContent.Parent then
                    applySize(measureSubHeight())
                    cascadeUp(baseContainer)
                end
            end)
            task.delay(0.45, function()
                if subContent and subContent.Parent then
                    applySize(measureSubHeight())
                    cascadeUp(baseContainer)
                end
            end)
        else
            baseContainer.AutomaticSize = Enum.AutomaticSize.None
            subContent.AutomaticSize = Enum.AutomaticSize.None
            applySize(0)
            refreshHierarchy(baseContainer)
        end

        -- Обновляем скролл по фактическому контенту
        local scroller = parent
        while scroller and not scroller:IsA("ScrollingFrame") do
            scroller = scroller.Parent
        end
        if scroller then
            task.delay(0.35, function()
                if scroller and scroller:FindFirstChild("UIListLayout") then
                    scroller.CanvasSize = UDim2.new(0, 0, 0, scroller.UIListLayout.AbsoluteContentSize.Y + 20)
                end
            end)
        end
    end

    triangle.MouseButton1Click:Connect(function()
        setExpanded(not isExpanded, true)
    end)

    if creationCallback then creationCallback(subContent) end

    task.defer(function()
        if isExpanded then setExpanded(true, true) end
    end)
end

local function createInnerToggle(parent, textKey, globalVar, order)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, -16, 0, 32)
    frame.BackgroundColor3 = Theme.BgRow
    frame.LayoutOrder = order
    frame.ZIndex = 3
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    local pad = Instance.new("UIPadding", frame)
    pad.PaddingLeft, pad.PaddingRight = UDim.new(0, 12), UDim.new(0, 12)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0, 240, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = localization[currentLanguage][textKey] or textKey
    label.TextColor3 = Theme.TextMain
    label.TextSize = 13
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 4
    table.insert(registeredLabels, {element = label, key = textKey})

    local switch = Instance.new("TextButton", frame)
    switch.Size = UDim2.new(0, 42, 0, 20)
    switch.Position = UDim2.new(1, -42, 0.5, -10)
    switch.BackgroundColor3 = _G[globalVar] and Theme.Green or Color3.fromRGB(40, 45, 40)
    switch.Text = ""
    switch.AutoButtonColor = false
    switch.ZIndex = 4
    Instance.new("UICorner", switch).CornerRadius = UDim.new(1, 0)
    
    local circle = Instance.new("Frame", switch)
    circle.Size = UDim2.new(0, 14, 0, 14)
    circle.Position = _G[globalVar] and UDim2.new(0, 24, 0.5, -7) or UDim2.new(0, 4, 0.5, -7)
    circle.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    circle.ZIndex = 5
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

    _G.toggleRefs[globalVar] = { switch = switch, circle = circle }

    attachFeel(frame, switch)

    switch.MouseButton1Click:Connect(function()
        PlayClick()
        _G[globalVar] = not _G[globalVar]
        local origSize = switch.Size
        TweenService:Create(switch, TweenInfo.new(0.05), {Size = UDim2.new(0, 38, 0, 20)}):Play()
        task.delay(0.05, function()
            TweenService:Create(switch, TweenInfo.new(0.1), {Size = origSize}):Play()
        end)
        TweenService:Create(switch, TweenInfo.new(0.15), {BackgroundColor3 = _G[globalVar] and Theme.Green or Color3.fromRGB(40, 45, 40)}):Play()
        TweenService:Create(circle, TweenInfo.new(0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = _G[globalVar] and UDim2.new(0, 24, 0.5, -7) or UDim2.new(0, 4, 0.5, -7)}):Play()
        -- Включил Spin/Jitter — Main включается сам, иначе функция молчит.
        if _G[globalVar] and (globalVar == "aaSpinEnabled" or globalVar == "aaJitterEnabled") then
            _G.aaUiMain = true
            pcall(function() setToggleVisual("aaUiMain", true) end)
        end
    end)
end

local function createInnerSlider(parent, textKey, min, max, globalVar, order, callback, isFloat)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, -16, 0, 40)
    frame.BackgroundColor3 = Theme.BgRow
    frame.LayoutOrder = order
    frame.ZIndex = 3
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    attachFeel(frame)
    local pad = Instance.new("UIPadding", frame)
    pad.PaddingLeft, pad.PaddingRight = UDim.new(0, 8), UDim.new(0, 8)

    local function formatVal(v)
        if isFloat then return string.format("%.2f", v) end
        return tostring(v)
    end

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, 0, 0, 18)
    label.Position = UDim2.new(0, 0, 0, 2)
    label.BackgroundTransparency = 1
    label.Text = localization[currentLanguage][textKey] or textKey
    label.TextColor3 = Theme.TextMain
    label.TextSize = 12
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 4
    table.insert(registeredLabels, {element = label, key = textKey, isSlider = true, gVar = globalVar, isFloat = isFloat})

    -- Процентное заполнение (индикатор справа от названия).
    local initPercent = math.clamp((_G[globalVar] - min) / (max - min), 0, 1)
    local pctLabel = Instance.new("TextLabel", frame)
    pctLabel.Size = UDim2.new(0, 60, 0, 18)
    pctLabel.Position = UDim2.new(1, -60, 0, 2)
    pctLabel.BackgroundTransparency = 1
    pctLabel.Text = formatVal(_G[globalVar])
    pctLabel.TextColor3 = Theme.GreenBright
    pctLabel.TextSize = 12
    pctLabel.Font = Enum.Font.Jura
    pctLabel.TextXAlignment = Enum.TextXAlignment.Right
    pctLabel.ZIndex = 5

    local container = Instance.new("Frame", frame)
    container.Size = UDim2.new(1, 0, 0, 4)
    container.Position = UDim2.new(0, 0, 0, 26)
    container.BackgroundColor3 = Color3.fromRGB(40, 55, 45)
    container.ZIndex = 4
    Instance.new("UICorner", container)

    local fill = Instance.new("Frame", container)
    fill.Size = UDim2.new(math.clamp((_G[globalVar] - min) / (max - min), 0, 1), 0, 1, 0)
    fill.BackgroundColor3 = Theme.Green
    fill.ZIndex = 5
    Instance.new("UICorner", fill)
    local gradient = Instance.new("UIGradient", fill)
    gradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Theme.GreenDim), ColorSequenceKeypoint.new(1, Theme.GreenBright)}

    local knob = Instance.new("Frame", container)
    knob.Size = UDim2.new(0, 10, 0, 10)
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new(math.clamp((_G[globalVar] - min) / (max - min), 0, 1), 0, 0.5, 0)
    knob.BackgroundColor3 = Theme.GreenBright
    knob.ZIndex = 6
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    _G.sliderUiRefs[globalVar] = { fill = fill, knob = knob, pctLabel = pctLabel, min = min, max = max, formatVal = formatVal }

    local knobScale = Instance.new("UIScale", knob)
    knobScale.Scale = 1
    knob.MouseEnter:Connect(function() TweenService:Create(knobScale, TweenInfo.new(0.1), {Scale = 1.4}):Play() end)
    knob.MouseLeave:Connect(function() TweenService:Create(knobScale, TweenInfo.new(0.1), {Scale = 1}):Play() end)

    local trigger = Instance.new("TextButton", container)
    trigger.Size = UDim2.new(1, 0, 1, 0)
    trigger.BackgroundTransparency = 1
    trigger.Text = ""
    trigger.ZIndex = 7

    local function updateValue()
        local mousePos = UserInputService:GetMouseLocation().X
        local percentage = math.clamp((mousePos - container.AbsolutePosition.X) / container.AbsoluteSize.X, 0, 1)
        local rawValue = min + (percentage * (max - min))
        local newValue
        if isFloat then
            newValue = math.floor(rawValue * 100 + 0.5) / 100
        else
            newValue = math.round(rawValue)
        end
        _G[globalVar] = newValue
        label.Text = localization[currentLanguage][textKey] or textKey
        pctLabel.Text = formatVal(newValue)
        fill.Size = UDim2.new(percentage, 0, 1, 0)
        knob.Position = UDim2.new(percentage, 0, 0.5, 0)
        if callback then callback(newValue) end
    end

    local connection, endConnection
    trigger.MouseButton1Down:Connect(function()
        updateValue()
        connection = UserInputService.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then updateValue() end
        end)
        endConnection = UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                if connection then connection:Disconnect() end
                if endConnection then endConnection:Disconnect() end
            end
        end)
    end)
end

local function createInnerDropdown(parent, textKey, items, globalVar, order)
    local currentIdx = 1
    for i, v in ipairs(items) do
        if v == _G[globalVar] then currentIdx = i break end
    end

    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, -16, 0, 32)
    frame.BackgroundColor3 = Theme.BgRow
    frame.LayoutOrder = order
    frame.ZIndex = 3
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    local pad = Instance.new("UIPadding", frame)
    pad.PaddingLeft, pad.PaddingRight = UDim.new(0, 8), UDim.new(0, 8)

    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = (localization[currentLanguage][textKey] or textKey) .. ": " .. tostring(_G[globalVar])
    btn.TextColor3 = Theme.TextMain
    btn.TextSize = 12
    btn.Font = Enum.Font.Gotham
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.AutoButtonColor = false
    btn.ZIndex = 4
    table.insert(registeredLabels, {element = btn, key = textKey, isDropdown = true, gVar = globalVar})
    _G.dropdownRefs[globalVar] = { btn = btn, textKey = textKey }

    btn.MouseButton1Click:Connect(function()
        PlayClick()
        currentIdx = currentIdx + 1
        if currentIdx > #items then currentIdx = 1 end
        _G[globalVar] = items[currentIdx]
        btn.Text = (localization[currentLanguage][textKey] or textKey) .. ": " .. tostring(_G[globalVar])
    end)
end

-- === РЕЖИМЫ АИМБОТА (Большая плашка + Пилюли) ===
aimbotModeBar = Instance.new("Frame", tabs.Aimbot)
aimbotModeBar.Size = UDim2.new(1, -10, 0, 40)
aimbotModeBar.BackgroundColor3 = Theme.BgRow
aimbotModeBar.LayoutOrder = 0
aimbotModeBar.ZIndex = 5
Instance.new("UICorner", aimbotModeBar).CornerRadius = UDim.new(0, 8)
modeStroke = Instance.new("UIStroke", aimbotModeBar)
modeStroke.Color = Theme.Green
modeStroke.Thickness = 1
modeStroke.Transparency = 0.3

modeLabel = Instance.new("TextLabel", aimbotModeBar)
modeLabel.Size = UDim2.new(0, 70, 1, 0)
modeLabel.Position = UDim2.new(0, 12, 0, 0)
modeLabel.BackgroundTransparency = 1
modeLabel.Text = localization[currentLanguage].mode
modeLabel.TextColor3 = Theme.TextDim
modeLabel.TextSize = 11
modeLabel.Font = Enum.Font.GothamBold
modeLabel.TextXAlignment = Enum.TextXAlignment.Left
modeLabel.ZIndex = 6

legitBtn = Instance.new("TextButton", aimbotModeBar)
legitBtn.Size = UDim2.new(0, 90, 0, 28)
legitBtn.Position = UDim2.new(0, 72, 0.5, -14)
legitBtn.BackgroundColor3 = Theme.Green
legitBtn.Text = localization[currentLanguage].legit
legitBtn.TextColor3 = Color3.fromRGB(10, 15, 10)
legitBtn.TextSize = 12
legitBtn.Font = Enum.Font.GothamBold
legitBtn.AutoButtonColor = false
legitBtn.ZIndex = 6
Instance.new("UICorner", legitBtn).CornerRadius = UDim.new(1, 0)
legitStroke = Instance.new("UIStroke", legitBtn)
legitStroke.Color = Theme.GreenBright
legitStroke.Thickness = 2

hvhBtn = Instance.new("TextButton", aimbotModeBar)
hvhBtn.Size = UDim2.new(0, 90, 0, 28)
hvhBtn.Position = UDim2.new(0, 168, 0.5, -14)
hvhBtn.BackgroundColor3 = Theme.BgDark
hvhBtn.Text = localization[currentLanguage].hvh
hvhBtn.TextColor3 = Theme.TextDim
hvhBtn.TextSize = 12
hvhBtn.Font = Enum.Font.GothamBold
hvhBtn.AutoButtonColor = false
hvhBtn.ZIndex = 6
Instance.new("UICorner", hvhBtn).CornerRadius = UDim.new(1, 0)

modeIndicator = Instance.new("TextLabel", aimbotModeBar)
modeIndicator.Size = UDim2.new(0, 100, 1, 0)
modeIndicator.Position = UDim2.new(1, -110, 0, 0)
modeIndicator.BackgroundTransparency = 1
modeIndicator.Text = localization[currentLanguage].legit
modeIndicator.TextColor3 = Theme.GreenBright
modeIndicator.TextSize = 12
modeIndicator.Font = Enum.Font.GothamBold
modeIndicator.TextXAlignment = Enum.TextXAlignment.Right
modeIndicator.ZIndex = 6

-- Панель для пилюль
pillBar = Instance.new("Frame", tabs.Aimbot)
pillBar.Size = UDim2.new(1, -10, 0, 28)
pillBar.BackgroundTransparency = 1
pillBar.LayoutOrder = 1

pill1 = Instance.new("TextButton", pillBar)
pill1.BackgroundColor3 = Theme.Green
pill1.TextColor3 = Color3.fromRGB(10, 15, 10)
pill1.Font = Enum.Font.GothamBold
pill1.TextSize = 11
pill1.AutoButtonColor = false
Instance.new("UICorner", pill1).CornerRadius = UDim.new(1, 0)
attachFeel(pill1)

pill2 = Instance.new("TextButton", pillBar)
pill2.BackgroundColor3 = Theme.BgRow
pill2.TextColor3 = Theme.TextDim
pill2.Font = Enum.Font.GothamBold
pill2.TextSize = 11
pill2.AutoButtonColor = false
Instance.new("UICorner", pill2).CornerRadius = UDim.new(1, 0)
attachFeel(pill2)

pill3 = Instance.new("TextButton", pillBar)
pill3.BackgroundColor3 = Theme.BgRow
pill3.TextColor3 = Theme.TextDim
pill3.Font = Enum.Font.GothamBold
pill3.TextSize = 11
pill3.AutoButtonColor = false
Instance.new("UICorner", pill3).CornerRadius = UDim.new(1, 0)
attachFeel(pill3)

pill4 = Instance.new("TextButton", pillBar)
pill4.BackgroundColor3 = Theme.BgRow
pill4.TextColor3 = Theme.TextDim
pill4.Font = Enum.Font.GothamBold
pill4.TextSize = 11
pill4.AutoButtonColor = false
Instance.new("UICorner", pill4).CornerRadius = UDim.new(1, 0)
attachFeel(pill4)

aimbotDynamic = Instance.new("Frame", tabs.Aimbot)
aimbotDynamic.Size = UDim2.new(1, -10, 0, 38)
aimbotDynamic.BackgroundTransparency = 1
aimbotDynamic.LayoutOrder = 2
aimbotDynamic.AutomaticSize = Enum.AutomaticSize.Y
aimbotDynamic.ZIndex = 2
dynLayout = Instance.new("UIListLayout", aimbotDynamic)
dynLayout.Padding = UDim.new(0, 6)
dynLayout.SortOrder = Enum.SortOrder.LayoutOrder

currentPillIndex = 1

local function updatePillVisuals()
    local pills = {pill1, pill2, pill3, pill4}
    for i, p in ipairs(pills) do
        if p.Visible then
            if i == currentPillIndex then
                p.BackgroundColor3 = Theme.Green
                p.TextColor3 = Color3.fromRGB(10, 15, 10)
            else
                p.BackgroundColor3 = Theme.BgRow
                p.TextColor3 = Theme.TextDim
            end
        end
    end
end

local function rebuildAimbotTab()
    for _, child in ipairs(aimbotDynamic:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextLabel") or child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    if _G.aimbotMode == "Legit" then
        pill1.Text = localization[currentLanguage].pillMain
        pill1.Visible = true
        pill1.Size = UDim2.new(0.33, -4, 1, 0)
        pill1.Position = UDim2.new(0, 0, 0, 0)
        
        pill2.Text = localization[currentLanguage].pillLegit
        pill2.Visible = true
        pill2.Size = UDim2.new(0.33, -4, 1, 0)
        pill2.Position = UDim2.new(0.33, 2, 0, 0)
        
        pill3.Text = localization[currentLanguage].pillTrigger
        pill3.Visible = true
        pill3.Size = UDim2.new(0.33, -4, 1, 0)
        pill3.Position = UDim2.new(0.66, 4, 0, 0)
        
        pill4.Visible = false
        
        if currentPillIndex == 1 then
            createAdvancedToggle(aimbotDynamic, "aimbotEnabled", "aimbotEnabled", 1, function(sub)
                createInnerSlider(sub, "fovRadius", 30, 500, "fovRadius", 1)
                createInnerSlider(sub, "aimSmoothing", 0, 100, "aimSmoothing", 2)
                createInnerToggle(sub, "ignoreFriends", "ignoreFriends", 5)
                createInnerToggle(sub, "ignoreBehindWalls", "ignoreBehindWalls", 6)
                createInnerToggle(sub, "autoAimRMB", "autoAimRMB", 7)
                createInnerToggle(sub, "dynamicFovEnabled", "dynamicFovEnabled", 8)
                createInnerSlider(sub, "dynamicFovStart", 3, 60, "dynamicFovStart", 9)
                createInnerSlider(sub, "dynamicFovMax", 1, 5, "dynamicFovMax", 10, nil, true)
            end)
        elseif currentPillIndex == 2 then
            createAdvancedToggle(aimbotDynamic, "aimTuning", "aimbotEnabled", 1, function(sub)
                createInnerToggle(sub, "aimJitterEnabled", "aimJitterEnabled", 2)
                createInnerSlider(sub, "aimJitterStrength", 1, 100, "aimJitterStrength", 3)
                createInnerToggle(sub, "aimMaxTurnEnabled", "aimMaxTurnEnabled", 4)
                createInnerSlider(sub, "aimMaxTurnDegPerSec", 90, 1080, "aimMaxTurnDegPerSec", 5)
                createInnerToggle(sub, "aimMissEnabled", "aimMissEnabled", 6)
                createInnerSlider(sub, "aimMissChance", 0, 50, "aimMissChance", 7)
                createInnerSlider(sub, "aimMissOffset", 2, 20, "aimMissOffset", 8)
                createInnerToggle(sub, "aimAutoStopEnabled", "aimAutoStopEnabled", 9)
                createInnerSlider(sub, "aimAutoStopStrength", 0, 100, "aimAutoStopStrength", 10)
            end)
        elseif currentPillIndex == 3 then
            createAdvancedToggle(aimbotDynamic, "triggerbotEnabled", "triggerbotEnabled", 1, function(sub)
                createInnerToggle(sub, "triggerbotWallCheck", "triggerbotWallCheck", 1)
                createInnerToggle(sub, "triggerbotDistanceEnabled", "triggerbotDistanceEnabled", 2)
                createInnerSlider(sub, "triggerbotMaxDist", 50, 5000, "triggerbotMaxDist", 3)
                createInnerSlider(sub, "triggerbotDelay", 0, 1000, "triggerbotDelay", 4)
                createInnerToggle(sub, "triggerbotFireRateEnabled", "triggerbotFireRateEnabled", 5)
                createInnerSlider(sub, "triggerbotFireRate", 1, 100, "triggerbotFireRate", 6)
            end)
        end
    else
        pill1.Text = localization[currentLanguage].pillHvh
        pill1.Visible = true
        pill1.Size = UDim2.new(0.5, -3, 1, 0)
        pill1.Position = UDim2.new(0, 0, 0, 0)
        
        pill2.Text = localization[currentLanguage].pillAntiAim
        pill2.Visible = true
        pill2.Size = UDim2.new(0.5, -3, 1, 0)
        pill2.Position = UDim2.new(0.5, 3, 0, 0)
        
        pill3.Visible = false 
        pill4.Visible = false
        
        if currentPillIndex == 1 then
            createAdvancedToggle(aimbotDynamic, "hvhAimbotEnabled", "hvhAimbotEnabled", 1, function(sub)
                createInnerToggle(sub, "triggerbotEnabled", "triggerbotEnabled", 1)
                createInnerToggle(sub, "hvhIgnoreFriends", "hvhIgnoreFriends", 2)
                createInnerToggle(sub, "hvhThroughWalls", "hvhThroughWalls", 3)
                createInnerToggle(sub, "hvhTargetLock", "hvhTargetLockEnabled", 4) 
            end)
        elseif currentPillIndex == 2 then
            createAdvancedToggle(aimbotDynamic, "hvhAntiAimEnabled", "hvhAntiAimEnabled", 1, function(sub)
                createAdvancedToggle(sub, "aaYawHeader", "aaUiYaw", 1, function(subSub)
                    createInnerDropdown(subSub, "aaYawDir", {"Off", "Back", "Left", "Right"}, "aaYaw", 1)
                end)
                createAdvancedToggle(sub, "aaPitchHeader", "aaUiPitch", 2, function(subSub)
                    createInnerDropdown(subSub, "aaPitchDir", {"Off", "Down", "Up"}, "aaPitch", 1)
                end)
                createAdvancedToggle(sub, "aaMainHeader", "aaUiMain", 3, function(subSub)
                    createInnerToggle(subSub, "aaSpin", "aaSpinEnabled", 1)
                    createInnerSlider(subSub, "aaSpinSpeed", 1, 200, "aaSpinSpeed", 2)
                    createInnerToggle(subSub, "aaJitter", "aaJitterEnabled", 3)
                    createInnerSlider(subSub, "aaJitterSpeed", 1, 15, "aaJitterSpeed", 4)
                    createInnerSlider(subSub, "aaJitterStrength", 1, 90, "aaJitterStrength", 5)
                    createInnerToggle(subSub, "aaBypass", "aaBypassEnabled", 6)
                end)
                createInnerToggle(sub, "aaFakeRun", "aaFakeRun", 4)
            end)
        end
    end
    updatePillVisuals()
end

pill1.MouseButton1Click:Connect(function() PlayClick() currentPillIndex = 1 rebuildAimbotTab() end)
pill2.MouseButton1Click:Connect(function() PlayClick() currentPillIndex = 2 rebuildAimbotTab() end)
pill3.MouseButton1Click:Connect(function() PlayClick() currentPillIndex = 3 rebuildAimbotTab() end)
pill4.MouseButton1Click:Connect(function() PlayClick() currentPillIndex = 4 rebuildAimbotTab() end)

local function setAimbotMode(mode)
    PlayClick()
    _G.aimbotMode = mode
    if mode == "Legit" then
        legitBtn.BackgroundColor3 = Theme.Green
        legitBtn.TextColor3 = Color3.fromRGB(10, 15, 10)
        legitStroke.Color = Theme.GreenBright
        hvhBtn.BackgroundColor3 = Theme.BgDark
        hvhBtn.TextColor3 = Theme.TextDim
        modeIndicator.Text = localization[currentLanguage].legit
        modeIndicator.TextColor3 = Theme.GreenBright
        modeStroke.Color = Theme.Green
        _G.fovRadius = _G.fovRadius or 150
    else
        hvhBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
        hvhBtn.TextColor3 = Color3.fromRGB(15, 5, 5)
        legitBtn.BackgroundColor3 = Theme.BgDark
        legitBtn.TextColor3 = Theme.TextDim
        modeIndicator.Text = localization[currentLanguage].hvh
        modeIndicator.TextColor3 = Color3.fromRGB(255, 80, 80)
        modeStroke.Color = Color3.fromRGB(255, 60, 60)
        _G.ignoreFriends = _G.hvhIgnoreFriends
    end
    currentPillIndex = 1 
    rebuildAimbotTab()
    if updateHitboxPanelVisibility then updateHitboxPanelVisibility() end
end

legitBtn.MouseButton1Click:Connect(function() setAimbotMode("Legit") end)
hvhBtn.MouseButton1Click:Connect(function() setAimbotMode("HVH") end)
rebuildAimbotTab()

-- === ВИЗУАЛЫ (2 ПИЛЮЛИ: ESP и МИР) ===
visualSubBar = Instance.new("Frame", tabs.Visuals)
visualSubBar.Size = UDim2.new(1, -10, 0, 28)
visualSubBar.BackgroundTransparency = 1
visualSubBar.LayoutOrder = 0

espPill = Instance.new("TextButton", visualSubBar)
espPill.Size = UDim2.new(0.5, -5, 1, 0)
espPill.Position = UDim2.new(0, 0, 0, 0)
espPill.Text = localization[currentLanguage].esp
espPill.BackgroundColor3 = Theme.Green
espPill.TextColor3 = Color3.fromRGB(10, 15, 10)
espPill.Font = Enum.Font.GothamBold
espPill.TextSize = 11
espPill.AutoButtonColor = false
Instance.new("UICorner", espPill).CornerRadius = UDim.new(1, 0)
table.insert(registeredLabels, {element = espPill, key = "esp"})

worldPill = Instance.new("TextButton", visualSubBar)
worldPill.Size = UDim2.new(0.5, -5, 1, 0)
worldPill.Position = UDim2.new(0.5, 5, 0, 0)
worldPill.Text = localization[currentLanguage].world
worldPill.BackgroundColor3 = Theme.BgRow
worldPill.TextColor3 = Theme.TextDim
worldPill.Font = Enum.Font.GothamBold
worldPill.TextSize = 11
worldPill.AutoButtonColor = false
Instance.new("UICorner", worldPill).CornerRadius = UDim.new(1, 0)
table.insert(registeredLabels, {element = worldPill, key = "world"})

espContent = Instance.new("Frame", tabs.Visuals)
espContent.Size = UDim2.new(1, 0, 0, 0)
espContent.AutomaticSize = Enum.AutomaticSize.Y
espContent.BackgroundTransparency = 1
espContent.LayoutOrder = 1
espLayout = Instance.new("UIListLayout", espContent)
espLayout.Padding = UDim.new(0, 6)
espLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- === СКАЙБОКС ===
-- Шесть текстур неба (Sky). Формат ссылок как в рабочем небе: asset/?id=...
-- Исходные текстуры, звёзды и светила запоминаются и возвращаются при выключении.
-- Короткие имена свойств Sky: SkyboxBack/Front/... не существуют, из-за этого
-- записывалась только верхняя грань (SkyboxUp), остальные вызовы молча падали.
local SKYBOX_FACES = { "SkyboxBk", "SkyboxDn", "SkyboxFt", "SkyboxLf", "SkyboxRt", "SkyboxUp" }
local SKYBOX_PRESETS = {
    { labelKey = "skyboxDefault" },
    { labelKey = "skyboxSpace", starCount = 3000, celestial = true, faces = {
        SkyboxBk  = "rbxassetid://14543264135",
        SkyboxDn  = "rbxassetid://14543358958",
        SkyboxFt = "rbxassetid://14543257810",
        SkyboxLf  = "rbxassetid://14543275895",
        SkyboxRt = "rbxassetid://14543280890",
        SkyboxUp    = "rbxassetid://14543371676",
    } },
    { labelKey = "skyboxSpace2", starCount = 0, celestial = true, faces = {
        SkyboxBk = "rbxassetid://166574023",
        SkyboxDn = "rbxassetid://166574122",
        SkyboxFt = "rbxassetid://166574061",
        SkyboxLf = "rbxassetid://166574084",
        SkyboxRt = "rbxassetid://166574092",
        SkyboxUp = "rbxassetid://166574066",
    } },
    { labelKey = "skyboxVibe", starCount = 3000, celestial = false, faces = {
        SkyboxBk = "rbxassetid://8991308822",
        SkyboxDn = "rbxassetid://8991308505",
        SkyboxFt = "rbxassetid://8991308320",
        SkyboxLf = "rbxassetid://8991308038",
        SkyboxRt = "rbxassetid://8991307660",
        SkyboxUp = "rbxassetid://8991307329",
    } },
    { labelKey = "skyboxVibe2", starCount = 3000, celestial = true, faces = {
        SkyboxBk = "rbxassetid://11555017034",
        SkyboxDn = "rbxassetid://11555013415",
        SkyboxFt = "rbxassetid://11555010145",
        SkyboxLf = "rbxassetid://11555006545",
        SkyboxRt = "rbxassetid://11555000712",
        SkyboxUp = "rbxassetid://11554996247",
    } },
    { labelKey = "skyboxWhite", starCount = 3000, celestial = false, faces = {
        SkyboxBk = "rbxassetid://155657655",
        SkyboxDn = "rbxassetid://155674246",
        SkyboxFt = "rbxassetid://155657609",
        SkyboxLf = "rbxassetid://155657671",
        SkyboxRt = "rbxassetid://155657619",
        SkyboxUp = "rbxassetid://155674931",
    } },
    { labelKey = "skyboxNeon", starCount = 3000, celestial = false, faces = {
        SkyboxBk = "rbxassetid://16739288043",
        SkyboxDn = "rbxassetid://16739289858",
        SkyboxFt = "rbxassetid://16739291971",
        SkyboxLf = "rbxassetid://16739293487",
        SkyboxRt = "rbxassetid://16739295035",
        SkyboxUp = "rbxassetid://16739296788",
    } },
    { labelKey = "skyboxNeon2", starCount = 3000, celestial = false, faces = {
        SkyboxBk = "rbxassetid://16642371727",
        SkyboxDn = "rbxassetid://16642373510",
        SkyboxFt = "rbxassetid://16642374596",
        SkyboxLf = "rbxassetid://16642375956",
        SkyboxRt = "rbxassetid://16642377351",
        SkyboxUp = "rbxassetid://16642379025",
    } },
    { labelKey = "skyboxTale", starCount = 3000, celestial = true,
      sunAngular = 0, moonAngular = 0, faces = {
        SkyboxBk = "rbxassetid://116125630991600",
        SkyboxDn = "rbxassetid://129095827049856",
        SkyboxFt = "rbxassetid://102861865671030",
        SkyboxLf = "rbxassetid://101856865035667",
        SkyboxRt = "rbxassetid://91813273790778",
        SkyboxUp = "rbxassetid://72828282060364",
    } },
    { labelKey = "skyboxTale2", starCount = 3000, celestial = true,
      sunAngular = 0, moonAngular = 0, faces = {
        SkyboxBk = "rbxassetid://11430898903188",
        SkyboxDn = "rbxassetid://125503357666535",
        SkyboxFt = "rbxassetid://13573855050668",
        SkyboxLf = "rbxassetid://88201165269205",
        SkyboxRt = "rbxassetid://112992927355564",
        SkyboxUp = "rbxassetid://125384519749099",
    } },
}

local skyboxSaved = nil
local skyboxSavedFor = nil
local skyboxOwned = nil

local function skyboxSave(sky)
    if skyboxSavedFor == sky then return end
    skyboxSavedFor = sky
    skyboxSaved = { faces = {} }
    for _, face in ipairs(SKYBOX_FACES) do
        local ok, value = pcall(function() return sky[face] end)
        skyboxSaved.faces[face] = ok and value or ""
    end
    local okStars, stars = pcall(function() return sky.StarCount end)
    skyboxSaved.starCount = okStars and stars or nil
    local okCel, cel = pcall(function() return sky.CelestialBodiesShown end)
    skyboxSaved.celestial = okCel and cel or nil
    local okSun, sunTex = pcall(function() return sky.SunTextureId end)
    skyboxSaved.sunTexture = okSun and sunTex or nil
    local okMoon, moonTex = pcall(function() return sky.MoonTextureId end)
    skyboxSaved.moonTexture = okMoon and moonTex or nil
    local okSunAng, sunAng = pcall(function() return sky.SunAngularSize end)
    skyboxSaved.sunAngular = okSunAng and sunAng or nil
    local okMoonAng, moonAng = pcall(function() return sky.MoonAngularSize end)
    skyboxSaved.moonAngular = okMoonAng and moonAng or nil

    -- Атмосфера места перекрывает небо плотной дымкой: из-за неё текстуры
    -- выглядят как ровный цвет. Пока небо наше, гасим её и запоминаем значения.
    skyboxSaved.atmosphere = nil
    for _, child in ipairs(Lighting:GetChildren()) do
        if child:IsA("Atmosphere") then
            skyboxSaved.atmosphere = {
                obj = child,
                density = child.Density,
                haze = child.Haze,
                offset = child.Offset,
            }
            break
        end
    end
end

local function skyboxRestore(sky)
    if not skyboxSaved then return end
    for face, value in pairs(skyboxSaved.faces or {}) do
        pcall(function() sky[face] = value end)
    end
    if skyboxSaved.starCount then
        pcall(function() sky.StarCount = skyboxSaved.starCount end)
    end
    if skyboxSaved.celestial ~= nil then
        pcall(function() sky.CelestialBodiesShown = skyboxSaved.celestial end)
    end
    if skyboxSaved.sunTexture then
        pcall(function() sky.SunTextureId = skyboxSaved.sunTexture end)
    end
    if skyboxSaved.moonTexture then
        pcall(function() sky.MoonTextureId = skyboxSaved.moonTexture end)
    end
    if skyboxSaved.sunAngular then
        pcall(function() sky.SunAngularSize = skyboxSaved.sunAngular end)
    end
    if skyboxSaved.moonAngular then
        pcall(function() sky.MoonAngularSize = skyboxSaved.moonAngular end)
    end
    local atm = skyboxSaved.atmosphere
    if atm and atm.obj and atm.obj.Parent then
        pcall(function()
            atm.obj.Density = atm.density
            atm.obj.Haze = atm.haze
            atm.obj.Offset = atm.offset
        end)
    end
end

local function skyboxApply(forceDefault)
    local index = 1
    if not forceDefault then
        index = math.clamp(tonumber(_G.skyboxIndex) or 1, 1, #SKYBOX_PRESETS)
    end
    local preset = SKYBOX_PRESETS[index]
    local sky = Lighting:FindFirstChildOfClass("Sky")

    if not preset.faces then
        if not sky then
            skyboxSaved, skyboxSavedFor = nil, nil
            return
        end
        if skyboxOwned and sky == skyboxOwned then
            skyboxOwned:Destroy()
            skyboxOwned = nil
            skyboxSaved, skyboxSavedFor = nil, nil
            return
        end
        skyboxRestore(sky)
        return
    end

    if not sky then
        sky = Instance.new("Sky")
        sky.Name = "ImpulseSkybox"
        sky.Parent = Lighting
        skyboxOwned = sky
    end

    skyboxSave(sky)

    for face, id in pairs(preset.faces) do
        sky[face] = id
    end
    if preset.starCount then
        sky.StarCount = preset.starCount
    end
    if preset.celestial ~= nil then
        sky.CelestialBodiesShown = preset.celestial
    end
    if preset.sunTexture then
        pcall(function() sky.SunTextureId = preset.sunTexture end)
    end
    if preset.moonTexture then
        pcall(function() sky.MoonTextureId = preset.moonTexture end)
    end
    if preset.sunAngular then
        pcall(function() sky.SunAngularSize = preset.sunAngular end)
    end
    if preset.moonAngular then
        pcall(function() sky.MoonAngularSize = preset.moonAngular end)
    end

    if skyboxSaved.atmosphere then
        local atm = skyboxSaved.atmosphere.obj
        atm.Density = 0
        atm.Haze = 0
        atm.Offset = 0
    end
end

-- Выпадающий список неба: плавно раскрывается, пункты проявляются по очереди.
local function createSkyboxDropdown(parent, order)
    local wrapper = Instance.new("Frame", parent)
    wrapper.Name = "SkyboxDropdown"
    wrapper.Size = UDim2.new(1, -16, 0, 46)
    wrapper.BackgroundColor3 = Theme.BgRow
    wrapper.LayoutOrder = order
    wrapper.ZIndex = 3
    wrapper.ClipsDescendants = true
    Instance.new("UICorner", wrapper).CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke", wrapper)
    stroke.Color = Theme.Border
    stroke.Thickness = 1
    stroke.Transparency = 0.55
    attachFeel(wrapper)

    local header = Instance.new("TextButton", wrapper)
    header.Size = UDim2.new(1, 0, 0, 46)
    header.BackgroundTransparency = 1
    header.Text = ""
    header.AutoButtonColor = false
    header.ZIndex = 4

    local caption = Instance.new("TextLabel", header)
    caption.Size = UDim2.new(1, -64, 0, 12)
    caption.Position = UDim2.new(0, 12, 0, 8)
    caption.BackgroundTransparency = 1
    caption.Text = localization[currentLanguage].skyboxTitle or "Небо"
    caption.TextColor3 = Theme.TextDim
    caption.TextSize = 9
    caption.Font = Enum.Font.Gotham
    caption.TextXAlignment = Enum.TextXAlignment.Left
    caption.ZIndex = 5
    table.insert(registeredLabels, {element = caption, key = "skyboxTitle"})

    local value = Instance.new("TextLabel", header)
    value.Size = UDim2.new(1, -64, 0, 18)
    value.Position = UDim2.new(0, 12, 0, 22)
    value.BackgroundTransparency = 1
    value.Text = ""
    value.TextColor3 = Theme.TextMain
    value.TextSize = 13
    value.Font = Enum.Font.GothamSemibold
    value.TextXAlignment = Enum.TextXAlignment.Left
    value.TextTruncate = Enum.TextTruncate.AtEnd
    value.ZIndex = 5

    local chevron = Instance.new("TextLabel", header)
    chevron.Size = UDim2.new(0, 18, 0, 18)
    chevron.AnchorPoint = Vector2.new(1, 0.5)
    chevron.Position = UDim2.new(1, -12, 0.5, 0)
    chevron.BackgroundTransparency = 1
    chevron.Text = "►"
    chevron.TextColor3 = Theme.Green
    chevron.TextSize = 15
    chevron.Font = Enum.Font.GothamBold
    chevron.ZIndex = 5

    local list = Instance.new("ScrollingFrame", wrapper)
    list.Size = UDim2.new(1, -16, 0, 0)
    list.Position = UDim2.new(0, 8, 0, 46)
    list.BackgroundColor3 = Theme.BgDark
    list.BorderSizePixel = 0
    list.ScrollBarThickness = 2
    list.ScrollBarImageColor3 = Theme.Green
    list.CanvasSize = UDim2.new(0, 0, 0, 0)
    list.AutomaticCanvasSize = Enum.AutomaticSize.Y
    list.ZIndex = 4
    Instance.new("UICorner", list).CornerRadius = UDim.new(0, 7)
    local listPad = Instance.new("UIPadding", list)
    listPad.PaddingTop = UDim.new(0, 5)
    listPad.PaddingBottom = UDim.new(0, 5)
    listPad.PaddingLeft = UDim.new(0, 5)
    listPad.PaddingRight = UDim.new(0, 5)
    local listLayout = Instance.new("UIListLayout", list)
    listLayout.Padding = UDim.new(0, 4)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local refresh, setOpen
    local rows = {}

    for i, preset in ipairs(SKYBOX_PRESETS) do
        local row = Instance.new("TextButton", list)
        row.Size = UDim2.new(1, 0, 0, 30)
        row.LayoutOrder = i
        row.BackgroundColor3 = Theme.BgRow
        row.BackgroundTransparency = 0.25
        row.Text = ""
        row.AutoButtonColor = false
        row.ZIndex = 5
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)
        attachFeel(row)

        local mark = Instance.new("Frame", row)
        mark.Size = UDim2.new(0, 3, 1, -12)
        mark.Position = UDim2.new(0, 4, 0, 6)
        mark.BackgroundColor3 = Theme.Green
        mark.BackgroundTransparency = 1
        mark.BorderSizePixel = 0
        mark.ZIndex = 6
        Instance.new("UICorner", mark).CornerRadius = UDim.new(1, 0)

        local label = Instance.new("TextLabel", row)
        label.Size = UDim2.new(1, -26, 1, 0)
        label.Position = UDim2.new(0, 16, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = localization[currentLanguage][preset.labelKey] or preset.labelKey
        label.TextColor3 = Theme.TextMain
        label.TextSize = 12
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextTransparency = 1
        label.ZIndex = 6

        row.MouseButton1Click:Connect(function()
            PlayClick()
            _G.skyboxIndex = i
            if i > 1 and not _G.skyboxEnabled then
                _G.skyboxEnabled = true
                if setToggleVisual then pcall(setToggleVisual, "skyboxEnabled", true) end
            end
            pcall(skyboxApply)
            refresh()
            setOpen(false)
        end)

        rows[i] = { row = row, label = label, mark = mark }
    end

    local listHeight = math.min(#SKYBOX_PRESETS * 34 + 10, 192)

    refresh = function()
        local index = math.clamp(tonumber(_G.skyboxIndex) or 1, 1, #SKYBOX_PRESETS)
        local preset = SKYBOX_PRESETS[index]
        value.Text = localization[currentLanguage][preset.labelKey] or preset.labelKey
        value.TextTransparency = _G.skyboxEnabled and 0 or 0.35
        chevron.TextColor3 = _G.skyboxEnabled and Theme.Green or Theme.TextDim
        for i, item in ipairs(rows) do
            local rowPreset = SKYBOX_PRESETS[i]
            item.label.Text = localization[currentLanguage][rowPreset.labelKey] or rowPreset.labelKey
            item.mark.BackgroundTransparency = (i == index) and 0 or 1
            item.label.TextColor3 = (i == index) and Theme.GreenBright or Theme.TextMain
        end
    end

    local isOpen = false
    setOpen = function(open, instant)
        isOpen = open
        local targetList = open and listHeight or 0
        local targetTotal = 46 + (open and (listHeight + 8) or 0)
        if instant then
            wrapper.Size = UDim2.new(1, -16, 0, targetTotal)
            list.Size = UDim2.new(1, -16, 0, targetList)
            chevron.Rotation = open and 90 or 0
        else
            TweenService:Create(wrapper, TweenInfo.new(0.24, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, -16, 0, targetTotal)}):Play()
            TweenService:Create(list, TweenInfo.new(0.24, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, -16, 0, targetList)}):Play()
            TweenService:Create(chevron, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation = open and 90 or 0}):Play()
        end
        for i, item in ipairs(rows) do
            local target = open and 0 or 1
            if instant then
                item.label.TextTransparency = target
            else
                local delay = open and (i * 0.025) or 0
                TweenService:Create(item.label, TweenInfo.new(open and 0.15 or 0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, delay), {TextTransparency = target}):Play()
            end
        end
    end

    header.MouseButton1Click:Connect(function()
        PlayClick()
        setOpen(not isOpen)
    end)

    refresh()
    setOpen(false, true)
    return refresh
end

local skyboxRefreshVisuals = nil

worldContent = Instance.new("Frame", tabs.Visuals)
worldContent.Size = UDim2.new(1, 0, 0, 0)
worldContent.AutomaticSize = Enum.AutomaticSize.Y
worldContent.BackgroundTransparency = 1
worldContent.LayoutOrder = 1
worldContent.Visible = false
worldLayout = Instance.new("UIListLayout", worldContent)
worldLayout.Padding = UDim.new(0, 6)
worldLayout.SortOrder = Enum.SortOrder.LayoutOrder

espPill.MouseButton1Click:Connect(function()
    PlayClick()
    espPill.BackgroundColor3 = Theme.Green
    espPill.TextColor3 = Color3.fromRGB(10, 15, 10)
    worldPill.BackgroundColor3 = Theme.BgRow
    worldPill.TextColor3 = Theme.TextDim
    espContent.Visible = true
    worldContent.Visible = false
end)

worldPill.MouseButton1Click:Connect(function()
    PlayClick()
    worldPill.BackgroundColor3 = Theme.Green
    worldPill.TextColor3 = Color3.fromRGB(10, 15, 10)
    espPill.BackgroundColor3 = Theme.BgRow
    espPill.TextColor3 = Theme.TextDim
    espContent.Visible = false
    worldContent.Visible = true
end)

-- ESP Content
createAdvancedToggle(espContent, "espBoxes", "espBoxes", 1, function(sub)
    createInnerDropdown(sub, "currentBoxType", _G.boxTypes, "currentBoxType", 1)
    createInnerSlider(sub, "boxCornerSize", 5, 50, "boxCornerSize", 2)
end)
createInnerToggle(espContent, "espNames", "espNames", 2)
createInnerToggle(espContent, "espHpText", "espHpText", 3)
createInnerToggle(espContent, "espDistance", "espDistance", 4)
createInnerToggle(espContent, "espSkeletons", "espSkeletons", 5)
createAdvancedToggle(espContent, "espChams", "espChams", 6, function(sub)
    createInnerSlider(sub, "chamsFillTransparency", 0, 100, "chamsFillTransparency", 1)
    createInnerDropdown(sub, "chamsOutlineColor", _G.chamsOutlineStyles, "currentChamsStyle", 2)
end)
createAdvancedToggle(espContent, "espTracers", "espTracers", 7, function(sub)
    createInnerSlider(sub, "tracerThickness", 0.1, 10, "tracerThickness", 1, nil, true)
end)
createAdvancedToggle(espContent, "viewDirection", "viewDirection", 8, function(sub)
    createInnerSlider(sub, "viewDirLength", 5, 50, "viewDirLength", 1)
end)
createInnerToggle(espContent, "weaponEsp", "weaponEsp", 9)
createInnerSlider(espContent, "espTextSize", 8, 24, "espTextSize", 10)

-- WORLD Content
createInnerToggle(worldContent, "fullbrightEnabled", "fullbrightEnabled", 1)
createAdvancedToggle(worldContent, "worldThirdPerson", "worldThirdPerson", 2, function(sub)
    createInnerSlider(sub, "worldThirdPersonDist", 4, 40, "worldThirdPersonDist", 1)
end)
createInnerToggle(worldContent, "skyboxEnabled", "skyboxEnabled", 3)
skyboxRefreshVisuals = createSkyboxDropdown(worldContent, 4)

-- === ОСТАЛЬНЫЕ ВКЛАДКИ ===
createAdvancedToggle(tabs.Combat, "antiRecoil", "antiRecoil", 1, function(sub)
    createInnerSlider(sub, "antiRecoilVertical", 0, 100, "antiRecoilVertical", 1)
    createInnerSlider(sub, "antiRecoilHorizontal", 0, 100, "antiRecoilHorizontal", 2)
end)
createInnerToggle(tabs.Combat, "invisibleEnabled", "invisibleEnabled", 2)

createAdvancedToggle(tabs.Killaura, "killauraEnabled", "killauraEnabled", 1, function(sub)
    createInnerSlider(sub, "killauraRange", 3, 50, "killauraRange", 1)
    createInnerSlider(sub, "killauraDelay", 0, 1000, "killauraDelay", 2)
    createInnerSlider(sub, "killauraFov", 30, 360, "killauraFov", 3)
    createInnerToggle(sub, "killauraTeamCheck", "killauraTeamCheck", 4)
    createInnerToggle(sub, "killauraWallCheck", "killauraWallCheck", 5)
    createInnerToggle(sub, "killauraRotate", "killauraRotate", 6)
end)

createInnerToggle(tabs.Movement, "SpeedHackEnabled", "SpeedHackEnabled", 1)
createInnerSlider(tabs.Movement, "SpeedValue", 16, 200, "SpeedValue", 2)
createInnerToggle(tabs.Movement, "autoStrafeEnabled", "autoStrafeEnabled", 3)
createInnerSlider(tabs.Movement, "autoStrafeStrength", 0, 100, "autoStrafeStrength", 4)

createInnerToggle(tabs.Movement, "wallPassEnabled", "wallPassEnabled", 5)
createInnerToggle(tabs.Movement, "infJumpEnabled", "infJumpEnabled", 6)
createInnerToggle(tabs.Movement, "bhopEnabled", "bhopEnabled", 7)
createInnerToggle(tabs.Movement, "spiderEnabled", "spiderEnabled", 8)
createInnerToggle(tabs.Movement, "noFallDamage", "noFallDamage", 9)


createInnerToggle(tabs.Other, "antiAfkEnabled", "antiAfkEnabled", 1)
createInnerToggle(tabs.Other, "tpMouseEnabled", "tpMouseEnabled", 2)

LangBtn.MouseButton1Click:Connect(function()
    PlayClick()
    currentLanguage = (currentLanguage == "RU") and "EN" or "RU"
    LangBtn.Text = currentLanguage
    Title.Text = localization[currentLanguage].title
    
    if AnimationsBtn and AnimationsBtn.Parent then
        AnimationsBtn.Text = localization[currentLanguage].legitConfig or "LEGIT-CONFIG"
    end
    if UnloadBtn and UnloadBtn.Parent then
        UnloadBtn.Text = localization[currentLanguage].unload or "Unload"
    end
    if ResetBtn and ResetBtn.Parent then 
        ResetBtn.Text = localization[currentLanguage].resetAll 
    end
    if espPill and espPill.Parent then
        espPill.Text = localization[currentLanguage].esp
        worldPill.Text = localization[currentLanguage].world
    end

    for _, item in pairs(registeredLabels) do
        local prefix = item.prefix or ""
        if item.isSlider then
            local val = item.isFloat and string.format("%.2f", _G[item.gVar]) or tostring(_G[item.gVar])
            item.element.Text = (localization[currentLanguage][item.key] or item.key) .. ": " .. val
        elseif item.isDropdown then
            item.element.Text = (localization[currentLanguage][item.key] or item.key) .. ": " .. tostring(_G[item.gVar])
        else
            item.element.Text = prefix .. (localization[currentLanguage][item.key] or item.key)
        end
    end
    if modeLabel and modeLabel.Parent then modeLabel.Text = localization[currentLanguage].mode end
    if legitBtn and legitBtn.Parent then legitBtn.Text = localization[currentLanguage].legit end
    if hvhBtn and hvhBtn.Parent then hvhBtn.Text = localization[currentLanguage].hvh end
    pcall(function()
        if sideTitle and sideTitle.Parent then sideTitle.Text = localization[currentLanguage].hitboxTitle end
        if sideSub and sideSub.Parent then sideSub.Text = localization[currentLanguage].hitboxSub end
        if pill1 and pill1.Parent then rebuildAimbotTab() end
        if modeIndicator and modeIndicator.Parent then
            modeIndicator.Text = (_G.aimbotMode == "Legit") and localization[currentLanguage].legit or localization[currentLanguage].hvh
        end
    end)
end)
switchTab("Aimbot")
tabButtons.Aimbot.BackgroundColor3 = Theme.BgRowHover
tabButtons.Aimbot.TextColor3 = Theme.GreenBright

-- ========================================================================
-- SIDE PANEL — HITBOX CONFIGURATOR
-- ========================================================================
SidePanel = Instance.new("Frame", MainFrame)
SidePanel.Name = "HitboxSidePanel"
SidePanel.BackgroundColor3 = Theme.BgDark
SidePanel.BackgroundTransparency = 1
SidePanel.AnchorPoint = Vector2.new(0, 0.5)
SidePanel.Position = UDim2.new(0, 528, 0.5, 0)
SidePanel.Size = UDim2.new(0, 240, 0, 540)
SidePanel.Visible = false
SidePanel.ClipsDescendants = true
SidePanel.ZIndex = 100
Instance.new("UICorner", SidePanel).CornerRadius = UDim.new(0, 12)

sideStroke = Instance.new("UIStroke", SidePanel)
sideStroke.Color = Theme.Green
sideStroke.Thickness = 1.5
sideStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
sideStroke.Transparency = 1
sideStroke.ZIndex = 101

GridOverlay = Instance.new("Frame", SidePanel)
GridOverlay.Size = UDim2.new(1, 0, 1, 0)
GridOverlay.BackgroundTransparency = 1
GridOverlay.ClipsDescendants = true
GridOverlay.ZIndex = 101
for i = 0, 30 do
    local v = Instance.new("Frame", GridOverlay)
    v.Size, v.Position = UDim2.new(0, 1, 1, 0), UDim2.new(0, i * 10, 0, 0)
    v.BackgroundColor3 = Theme.Green
    v.BackgroundTransparency = 0.88
    v.BorderSizePixel = 0
    v.ZIndex = 101
end
for i = 0, 40 do
    local h = Instance.new("Frame", GridOverlay)
    h.Size, h.Position = UDim2.new(1, 0, 0, 1), UDim2.new(0, 0, 0, i * 10)
    h.BackgroundColor3 = Theme.Green
    h.BackgroundTransparency = 0.88
    h.BorderSizePixel = 0
    h.ZIndex = 101
end

sideTitle = Instance.new("TextLabel", SidePanel)
sideTitle.Size = UDim2.new(1, -20, 0, 22)
sideTitle.Position = UDim2.new(0, 10, 0, 8)
sideTitle.BackgroundTransparency = 1
sideTitle.Text = localization[currentLanguage].hitboxTitle
sideTitle.TextColor3 = Theme.GreenBright
sideTitle.TextSize = 13
sideTitle.Font = Enum.Font.GothamBold
sideTitle.TextXAlignment = Enum.TextXAlignment.Left
sideTitle.ZIndex = 105

sideSub = Instance.new("TextLabel", SidePanel)
sideSub.Size = UDim2.new(1, -20, 0, 14)
sideSub.Position = UDim2.new(0, 10, 0, 28)
sideSub.BackgroundTransparency = 1
sideSub.Text = localization[currentLanguage].hitboxSub
sideSub.TextColor3 = Theme.TextDim
sideSub.TextSize = 9
sideSub.Font = Enum.Font.Gotham
sideSub.TextXAlignment = Enum.TextXAlignment.Left
sideSub.ZIndex = 105

-- ==========================================
-- МАНЕКЕН
-- ==========================================
DummyContainer = Instance.new("Frame", SidePanel)
DummyContainer.Size = UDim2.new(0, 220, 0, 260)
DummyContainer.Position = UDim2.new(0.5, -110, 0, 44)
DummyContainer.BackgroundTransparency = 1
DummyContainer.ZIndex = 106

local function makeBodyPart(name, size, pos, isCircle)
    local p = Instance.new("Frame", DummyContainer)
    p.Name = "Visual_" .. name
    p.Size = size
    p.Position = pos
    p.BackgroundColor3 = Color3.fromRGB(22, 34, 26)
    p.BackgroundTransparency = 0.15
    p.BorderSizePixel = 0
    p.ZIndex = 106
    if isCircle then
        Instance.new("UICorner", p).CornerRadius = UDim.new(1, 0)
    else
        Instance.new("UICorner", p).CornerRadius = UDim.new(0, 7)
    end
    -- Чёткая обводка + мягкое свечение — выглядит аккуратнее и «дороже».
    local s = Instance.new("UIStroke", p)
    s.Color = Theme.Green
    s.Thickness = 1.6
    s.Transparency = 0.25
    local glow = Instance.new("UIStroke", p)
    glow.Color = Theme.Green
    glow.Thickness = 4
    glow.Transparency = 0.85
    local innerGlow = Instance.new("Frame", p)
    innerGlow.Size = UDim2.new(1, -2, 1, -2)
    innerGlow.Position = UDim2.new(0, 1, 0, 1)
    innerGlow.BackgroundColor3 = Theme.Green
    innerGlow.BackgroundTransparency = 0.92
    innerGlow.BorderSizePixel = 0
    innerGlow.ZIndex = 106
    Instance.new("UICorner", innerGlow).CornerRadius = UDim.new(0, 6)
    return p
end

makeBodyPart("Head",     UDim2.new(0, 52, 0, 52), UDim2.new(0.5, -26, 0, 0),   true)
makeBodyPart("Torso",    UDim2.new(0, 76, 0, 92), UDim2.new(0.5, -38, 0, 56),  false)
makeBodyPart("LeftArm",  UDim2.new(0, 18, 0, 80), UDim2.new(0.5, -58, 0, 58),  false)
makeBodyPart("RightArm", UDim2.new(0, 18, 0, 80), UDim2.new(0.5,  40, 0, 58),  false)
makeBodyPart("LeftLeg",  UDim2.new(0, 28, 0, 90), UDim2.new(0.5, -32, 0, 150), false)
makeBodyPart("RightLeg", UDim2.new(0, 28, 0, 90), UDim2.new(0.5,   4, 0, 150), false)

-- Суставы (плечи, локти, бёдра, колени, шея) — аккуратный силуэт, без «скелета».
local function makeJoint(cx, cy, r)
    local j = Instance.new("Frame", DummyContainer)
    j.Size = UDim2.new(0, r * 2, 0, r * 2)
    j.Position = UDim2.new(0, cx - r, 0, cy - r)
    j.BackgroundColor3 = Color3.fromRGB(18, 30, 22)
    j.BackgroundTransparency = 0.15
    j.BorderSizePixel = 0
    j.ZIndex = 108
    Instance.new("UICorner", j).CornerRadius = UDim.new(1, 0)
    local st = Instance.new("UIStroke", j)
    st.Color = Theme.GreenBright
    st.Thickness = 1.5
    st.Transparency = 0.05
    local glow = Instance.new("UIStroke", j)
    glow.Color = Theme.Green
    glow.Thickness = 4
    glow.Transparency = 0.85
    return j
end

makeJoint(61, 62, 7);   makeJoint(159, 62, 7)    -- плечи
makeJoint(61, 136, 6);  makeJoint(159, 136, 6)   -- локти
makeJoint(92, 152, 7);  makeJoint(128, 152, 7)   -- бёдра
makeJoint(92, 196, 8);  makeJoint(128, 196, 8)   -- колени
makeJoint(110, 54, 6)                             -- шея

local zoneParts = {}
local zonePulseConns = {}

local function createZone(name, size, pos, isCircle)
    local zone = Instance.new("Frame", DummyContainer)
    zone.Name = "Zone_" .. name
    zone.Size = size
    zone.Position = pos
    zone.BackgroundColor3 = Theme.GreenBright
    zone.BackgroundTransparency = 1
    zone.BorderSizePixel = 0
    zone.ZIndex = 109
    if isCircle then
        Instance.new("UICorner", zone).CornerRadius = UDim.new(1, 0)
    else
        Instance.new("UICorner", zone).CornerRadius = UDim.new(0, 6)
    end
    
    local stroke = Instance.new("UIStroke", zone)
    stroke.Color = Theme.Green
    stroke.Thickness = 1.5
    stroke.Transparency = 1
    
    local btn = Instance.new("TextButton", zone)
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.ZIndex = 110

    btn.MouseEnter:Connect(function()
        if not _G.activeHitboxZones[name] then
            TweenService:Create(stroke, TweenInfo.new(0.15), {Transparency = 0.2}):Play()
        end
    end)
    btn.MouseLeave:Connect(function()
        if not _G.activeHitboxZones[name] then
            TweenService:Create(stroke, TweenInfo.new(0.15), {Transparency = 1}):Play()
        end
    end)

    local lbl = Instance.new("TextLabel", zone)
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = name
    lbl.TextColor3 = Theme.TextDim
    lbl.TextSize = 12
    lbl.Font = Enum.Font.GothamBold
    lbl.ZIndex = 110

    -- Золотая звёздочка приоритета (видна только у выбранной зоны).
    local star = Instance.new("TextLabel", zone)
    star.Name = "PriorityStar"
    star.Size = UDim2.new(0, 16, 0, 16)
    star.Position = UDim2.new(1, -18, 0, 2)
    star.BackgroundTransparency = 1
    star.Text = "★"
    star.TextColor3 = Color3.fromRGB(255, 200, 0)
    star.TextSize = 13
    star.Font = Enum.Font.GothamBold
    star.ZIndex = 111
    star.Visible = false

    zoneParts[name] = {frame = zone, stroke = stroke, button = btn, label = lbl, star = star}
    return btn
end

createZone("Head",  UDim2.new(0, 52, 0, 52), UDim2.new(0.5, -26, 0, 0),   true)
createZone("Chest", UDim2.new(0, 76, 0, 46), UDim2.new(0.5, -38, 0, 56),  false)
createZone("Waist", UDim2.new(0, 76, 0, 40), UDim2.new(0.5, -38, 0, 104), false)
createZone("Legs",  UDim2.new(0, 76, 0, 88), UDim2.new(0.5, -38, 0, 152), false)

local function hLine(y, w)
    local d = Instance.new("Frame", DummyContainer)
    d.Size = UDim2.new(0, w or 76, 0, 1)
    d.Position = UDim2.new(0.5, -(w or 76)/2, 0, y)
    d.BackgroundColor3 = Theme.Green
    d.BackgroundTransparency = 0.7
    d.BorderSizePixel = 0
    d.ZIndex = 108
end
hLine(56); hLine(104); hLine(148)

-- Кнопка-стрелка справа от манекена: вести аим в приоритетную зону (★).
HeadForceBtn = Instance.new("TextButton", SidePanel)
HeadForceBtn.Name = "HeadForceBtn"
HeadForceBtn.Size = UDim2.new(0, 18, 0, 44)
HeadForceBtn.Position = UDim2.new(0, 216, 0, 150)
HeadForceBtn.BackgroundColor3 = Theme.BgRow
HeadForceBtn.Text = "▲"
HeadForceBtn.TextColor3 = Theme.TextDim
HeadForceBtn.TextSize = 12
HeadForceBtn.Font = Enum.Font.GothamBold
HeadForceBtn.AutoButtonColor = false
HeadForceBtn.ZIndex = 111
Instance.new("UICorner", HeadForceBtn).CornerRadius = UDim.new(0, 5)
local headForceStroke = Instance.new("UIStroke", HeadForceBtn)
headForceStroke.Color = Theme.Border
headForceStroke.Thickness = 1
headForceStroke.Transparency = 0.5

HeadForceBtn.MouseButton1Click:Connect(function()
    PlayClick()
    _G.forcePriorityAim = not _G.forcePriorityAim
    HeadForceBtn.BackgroundColor3 = _G.forcePriorityAim and Theme.Green or Theme.BgRow
    HeadForceBtn.TextColor3 = _G.forcePriorityAim and Color3.fromRGB(10, 15, 10) or Theme.TextDim
    headForceStroke.Color = _G.forcePriorityAim and Theme.GreenBright or Theme.Border
    if updatePrioritySpeedVisibility then updatePrioritySpeedVisibility() end
end)

-- Вертикальный слайдер скорости перехода по хитбоксам (справа от стрелки).
PrioritySpeedBox = Instance.new("Frame", SidePanel)
PrioritySpeedBox.Name = "PrioritySpeedBox"
PrioritySpeedBox.Size = UDim2.new(0, 36, 0, 190)
PrioritySpeedBox.Position = UDim2.new(0, 310, 0, 46)
PrioritySpeedBox.BackgroundTransparency = 1
PrioritySpeedBox.Visible = false
PrioritySpeedBox.ZIndex = 112

local speedValLbl = Instance.new("TextLabel", PrioritySpeedBox)
speedValLbl.Size = UDim2.new(1, 0, 0, 16)
speedValLbl.Position = UDim2.new(0, 0, 0, 0)
speedValLbl.BackgroundTransparency = 1
speedValLbl.Text = tostring(_G.priorityAimSpeed or 100)
speedValLbl.TextColor3 = Theme.GreenBright
speedValLbl.TextSize = 11
speedValLbl.Font = Enum.Font.GothamBold
speedValLbl.TextXAlignment = Enum.TextXAlignment.Center
speedValLbl.ZIndex = 113

local speedTrack = Instance.new("Frame", PrioritySpeedBox)
speedTrack.Size = UDim2.new(0, 8, 1, -24)
speedTrack.Position = UDim2.new(0.5, -4, 0, 20)
speedTrack.BackgroundColor3 = Color3.fromRGB(40, 55, 45)
speedTrack.BorderSizePixel = 0
speedTrack.ZIndex = 113
Instance.new("UICorner", speedTrack).CornerRadius = UDim.new(1, 0)

local initPct = math.clamp(((_G.priorityAimSpeed or 100) - 1) / 99, 0, 1)
local speedFill = Instance.new("Frame", speedTrack)
speedFill.Size = UDim2.new(1, 0, initPct, 0)
speedFill.Position = UDim2.new(0, 0, 1 - initPct, 0)
speedFill.BackgroundColor3 = Theme.Green
speedFill.ZIndex = 114
Instance.new("UICorner", speedFill).CornerRadius = UDim.new(1, 0)

local speedKnob = Instance.new("Frame", speedTrack)
speedKnob.Size = UDim2.new(0, 10, 0, 10)
speedKnob.AnchorPoint = Vector2.new(0.5, 0.5)
speedKnob.Position = UDim2.new(0.5, 0, 1 - initPct, 0)
speedKnob.BackgroundColor3 = Theme.GreenBright
speedKnob.ZIndex = 115
Instance.new("UICorner", speedKnob).CornerRadius = UDim.new(1, 0)

local speedTrigger = Instance.new("TextButton", speedTrack)
speedTrigger.Size = UDim2.new(2, 0, 1, 0)
speedTrigger.Position = UDim2.new(-0.5, 0, 0, 0)
speedTrigger.BackgroundTransparency = 1
speedTrigger.Text = ""
speedTrigger.ZIndex = 116

local function setPrioritySpeedFromMouse()
    local my = UserInputService:GetMouseLocation().Y
    local pct = 1 - math.clamp((my - speedTrack.AbsolutePosition.Y) / speedTrack.AbsoluteSize.Y, 0, 1)
    local v = math.round(1 + pct * 99)
    _G.priorityAimSpeed = v
    speedValLbl.Text = tostring(v)
    speedFill.Size = UDim2.new(1, 0, pct, 0)
    speedFill.Position = UDim2.new(0, 0, 1 - pct, 0)
    speedKnob.Position = UDim2.new(0.5, 0, 1 - pct, 0)
end

local speedConn, speedEndConn
speedTrigger.MouseButton1Down:Connect(function()
    setPrioritySpeedFromMouse()
    speedConn = UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            setPrioritySpeedFromMouse()
        end
    end)
    speedEndConn = UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            if speedConn then speedConn:Disconnect() end
            if speedEndConn then speedEndConn:Disconnect() end
        end
    end)
end)

function updatePrioritySpeedVisibility()
    if not PrioritySpeedBox then return end
    -- Без выезда: панель и слайдер встают сразу на место.
    local panelW = _G.forcePriorityAim and 300 or 240
    if SidePanel then
        SidePanel.Size = UDim2.new(0, panelW, 0, SidePanel.Size.Y.Offset)
    end

    if _G.forcePriorityAim then
        PrioritySpeedBox.Visible = true
        PrioritySpeedBox.Position = UDim2.new(0, 250, 0, 46)
    else
        PrioritySpeedBox.Visible = false
        PrioritySpeedBox.Position = UDim2.new(0, 300, 0, 46)
    end
end

ResetBtn = Instance.new("TextButton", SidePanel)
ResetBtn.Size = UDim2.new(1, -20, 0, 24)
ResetBtn.Position = UDim2.new(0, 10, 1, -30)
ResetBtn.BackgroundColor3 = Theme.GreenDim
ResetBtn.Text = localization[currentLanguage].resetAll
ResetBtn.TextColor3 = Theme.TextMain
ResetBtn.TextSize = 10
ResetBtn.Font = Enum.Font.GothamBold
ResetBtn.AutoButtonColor = false
ResetBtn.ZIndex = 105
Instance.new("UICorner", ResetBtn).CornerRadius = UDim.new(0, 6)
resetStroke = Instance.new("UIStroke", ResetBtn)
resetStroke.Color = Theme.Green
resetStroke.Thickness = 1
resetStroke.Transparency = 0.3
table.insert(registeredLabels, {element = ResetBtn, key = "resetAll"})

SlidersContainer = Instance.new("ScrollingFrame", SidePanel)
SlidersContainer.Size = UDim2.new(1, -16, 0, 185)
SlidersContainer.Position = UDim2.new(0, 8, 0, 312)
SlidersContainer.BackgroundTransparency = 1
SlidersContainer.BorderSizePixel = 0
SlidersContainer.ScrollBarThickness = 2
SlidersContainer.ScrollBarImageColor3 = Theme.Green
SlidersContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
SlidersContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
SlidersContainer.ZIndex = 106

slidersLayout = Instance.new("UIListLayout", SlidersContainer)
slidersLayout.Padding = UDim.new(0, 6)
slidersLayout.SortOrder = Enum.SortOrder.LayoutOrder

sliderRefs = {}

local function distributeWeights(changedZone, newValue)
    local activeZones = {}
    for z, active in pairs(_G.activeHitboxZones) do
        if active then table.insert(activeZones, z) end
    end
    table.sort(activeZones)

    if #activeZones == 1 then
        _G.AimbotWeights[activeZones[1]] = 100
        return
    end

    local changedIdx = table.find(activeZones, changedZone)
    if not changedIdx then return end

    local remaining = 100 - newValue
    local otherCount = #activeZones - 1

    local currentOthersSum = 0
    for i, z in ipairs(activeZones) do
        if z ~= changedZone then
            currentOthersSum = currentOthersSum + (_G.AimbotWeights[z] or 0)
        end
    end

    _G.AimbotWeights[changedZone] = newValue

    if currentOthersSum == 0 then
        local per = math.floor(remaining / otherCount)
        local rem = remaining - (per * otherCount)
        for i, z in ipairs(activeZones) do
            if z ~= changedZone then
                _G.AimbotWeights[z] = per + (rem > 0 and 1 or 0)
                if rem > 0 then rem = rem - 1 end
            end
        end
    else
        for i, z in ipairs(activeZones) do
            if z ~= changedZone then
                local ratio = (_G.AimbotWeights[z] or 0) / currentOthersSum
                _G.AimbotWeights[z] = math.floor(remaining * ratio)
            end
        end
        local sum = 0
        for i, z in ipairs(activeZones) do sum = sum + _G.AimbotWeights[z] end
        if sum < 100 then
            for i, z in ipairs(activeZones) do
                if z ~= changedZone then
                    _G.AimbotWeights[z] = _G.AimbotWeights[z] + (100 - sum)
                    break
                end
            end
        end
    end
end

local function syncSlider(ref, w)
    w = math.clamp(w or 0, 0, 100)
    ref.valueLabel.Text = w .. "%"
    ref.fill.Size = UDim2.new(w / 100, 0, 1, 0)
    ref.knob.Position = UDim2.new(w / 100, 0, 0.5, 0)
end

-- Приводит веса активных зон к сумме 100 (одна зона = 100, несколько = поровну).
local function normalizeWeights()
    local active = {}
    for _, z in ipairs({"Head", "Chest", "Waist", "Legs"}) do
        if _G.activeHitboxZones[z] then active[#active + 1] = z end
    end
    if #active == 0 then return end
    if #active == 1 then
        _G.AimbotWeights[active[1]] = 100
        return
    end
    local per = math.floor(100 / #active)
    local rem = 100 - per * #active
    for i, z in ipairs(active) do
        _G.AimbotWeights[z] = per + (i <= rem and 1 or 0)
    end
end

-- Авто-высота панели: растёт под количество активных ползунков.
local function layoutHitboxPanel()
    if not SidePanel or not SlidersContainer or not slidersLayout then return end
    local rowsH = slidersLayout.AbsoluteContentSize.Y
    if rowsH < 0 then rowsH = 0 end
    local slidersY = 312
    SlidersContainer.Size = UDim2.new(1, -16, 0, rowsH)
    SlidersContainer.Position = UDim2.new(0, 8, 0, slidersY)
    local resetY = slidersY + rowsH + 8
    ResetBtn.Position = UDim2.new(0, 10, 0, resetY)
    local mpY = resetY + 24 + 8
    local panelW = _G.forcePriorityAim and 300 or 240
    SidePanel.Size = UDim2.new(0, panelW, 0, mpY + 8)
end


function updateSlidersForZones()
    local order = 1
    local activeCount = 0
    for _, z in ipairs({"Head", "Chest", "Waist", "Legs"}) do
        if _G.activeHitboxZones[z] then activeCount = activeCount + 1 end
    end

    for _, zoneName in ipairs({"Head", "Chest", "Waist", "Legs"}) do
        local isActive = _G.activeHitboxZones[zoneName]
        local ref = sliderRefs[zoneName]

        if isActive then
            if not ref then
                createWeightSlider(zoneName, order)
                ref = sliderRefs[zoneName]
            end

            -- Одна активная зона всегда = 100%, и ползунок стоит на 100.
            if activeCount == 1 then
                _G.AimbotWeights[zoneName] = 100
            end

            ref.frame.Visible = true
            ref.frame.LayoutOrder = order
            order = order + 1
            ref.track.Visible = true
            ref.frame.Size = UDim2.new(1, -6, 0, 40)
            ref.lbl.Position = UDim2.new(0, 10, 0, 3)
            syncSlider(ref, _G.AimbotWeights[zoneName] or 0)
        else
            if ref and ref.frame.Visible then
                ref.frame.Visible = false
            end
        end
    end
    task.defer(layoutHitboxPanel)
    task.delay(0.2, layoutHitboxPanel)
end

function createWeightSlider(zoneName, order)
    local row = Instance.new("Frame", SlidersContainer)
    row.Name = "Slider_" .. zoneName
    row.Size = UDim2.new(1, -6, 0, 40)
    row.BackgroundColor3 = Theme.BgRow
    row.BackgroundTransparency = 0.35
    row.LayoutOrder = order
    row.ClipsDescendants = true
    row.ZIndex = 106
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 7)

    local lbl = Instance.new("TextLabel", row)
    lbl.Size, lbl.Position = UDim2.new(0.55, 0, 0, 17), UDim2.new(0, 10, 0, 3)
    lbl.BackgroundTransparency = 1
    lbl.Text = zoneName
    lbl.TextColor3 = Theme.TextMain
    lbl.TextSize = 12
    lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 107

    local valLbl = Instance.new("TextLabel", row)
    valLbl.Size, valLbl.Position = UDim2.new(0.4, 0, 0, 17), UDim2.new(0.55, 0, 0, 3)
    valLbl.BackgroundTransparency = 1
    valLbl.Text = tostring(_G.AimbotWeights[zoneName] or 0) .. "%"
    valLbl.TextColor3 = Theme.GreenBright
    valLbl.TextSize = 12
    valLbl.Font = Enum.Font.GothamBold
    valLbl.TextXAlignment = Enum.TextXAlignment.Right
    valLbl.ZIndex = 107

    local track = Instance.new("Frame", row)
    track.Size, track.Position = UDim2.new(1, -20, 0, 6), UDim2.new(0, 10, 0, 25)
    track.BackgroundColor3 = Color3.fromRGB(40, 55, 45)
    track.BorderSizePixel = 0
    track.ZIndex = 107
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame", track)
    fill.Size = UDim2.new((_G.AimbotWeights[zoneName] or 0) / 100, 0, 1, 0)
    fill.BackgroundColor3 = Theme.Green
    fill.ZIndex = 108
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame", track)
    knob.Size = UDim2.new(0, 11, 0, 11)
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new((_G.AimbotWeights[zoneName] or 0) / 100, 0, 0.5, 0)
    knob.BackgroundColor3 = Theme.GreenBright
    knob.ZIndex = 109
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local trigger = Instance.new("TextButton", track)
    trigger.Size = UDim2.new(1, 0, 3, 0)
    trigger.Position = UDim2.new(0, 0, -1, 0)
    trigger.BackgroundTransparency = 1
    trigger.Text = ""
    trigger.ZIndex = 110

    local function updateSliderValues()
        for z, r in pairs(sliderRefs) do
            if r and r.frame.Visible then
                local w = _G.AimbotWeights[z] or 0
                r.valueLabel.Text = w .. "%"
                r.fill.Size = UDim2.new(w / 100, 0, 1, 0)
                r.knob.Position = UDim2.new(w / 100, 0, 0.5, 0)
            end
        end
    end

    local function updateValue()
        local mouseX = UserInputService:GetMouseLocation().X
        local pct = math.clamp((mouseX - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        local newVal = math.round(pct * 100)
        distributeWeights(zoneName, newVal)
        updateSliderValues()
        if updatePriorityVisuals then updatePriorityVisuals() end
    end

    local conn, endConn
    trigger.MouseButton1Down:Connect(function()
        updateValue()
        conn = UserInputService.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then updateValue() end
        end)
        endConn = UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                if conn then conn:Disconnect() end
                if endConn then endConn:Disconnect() end
            end
        end)
    end)

    sliderRefs[zoneName] = {frame = row, fill = fill, knob = knob, valueLabel = valLbl, track = track, lbl = lbl}
    return row
end

function setZoneActive(zoneName, active)
    local data = zoneParts[zoneName]
    if not data then return end
    _G.activeHitboxZones[zoneName] = active

    if zonePulseConns[zoneName] then
        pcall(function() zonePulseConns[zoneName]:Disconnect() end)
        zonePulseConns[zoneName] = nil
    end

    local targetTransp       = active and 0.15 or 1
    local targetStrokeTransp = active and 0.0  or 1
    local targetStrokeColor  = active and Theme.GreenBright or Theme.Green
    local targetThickness    = active and 2 or 1.5

    TweenService:Create(data.frame, TweenInfo.new(0.25, Enum.EasingStyle.Quad),
        {BackgroundTransparency = targetTransp}):Play()
    TweenService:Create(data.stroke, TweenInfo.new(0.25),
        {Transparency = targetStrokeTransp, Color = targetStrokeColor, Thickness = targetThickness}):Play()

    data.label.TextColor3 = active and Theme.GreenBright or Theme.TextDim

    if active then
        local phase = 0
        zonePulseConns[zoneName] = RunService.RenderStepped:Connect(function(dt)
            if not _G.activeHitboxZones[zoneName] then return end
            phase = phase + dt * 3
            local a = (math.sin(phase) + 1) / 2
            data.frame.BackgroundTransparency = 0.05 + a * 0.2
            data.stroke.Transparency = 0.0 + (1 - a) * 0.25
        end)
    end

    normalizeWeights()
    updateSlidersForZones()
end

for zoneName, data in pairs(zoneParts) do
    data.button.MouseButton1Click:Connect(function()
        PlayClick()
        setZoneActive(zoneName, not _G.activeHitboxZones[zoneName])
        -- ★ декоративная: сама встаёт на зону с максимальным весом.
        if updatePriorityVisuals then updatePriorityVisuals() end
    end)
end

function updatePriorityVisuals()
    -- Декоративная ★ на активной зоне с максимальным весом.
    local topZone, topW = nil, -1
    for _, z in ipairs({"Head", "Chest", "Waist", "Legs"}) do
        if _G.activeHitboxZones[z] then
            local w = _G.AimbotWeights[z] or 0
            if w > topW then topW = w; topZone = z end
        end
    end

    for zoneName, data in pairs(zoneParts) do
        local isTop = (topZone == zoneName)
        if data.star then data.star.Visible = isTop end
        if isTop then
            data.stroke.Color = Color3.fromRGB(255, 200, 0)
            data.stroke.Thickness = 3
            data.stroke.Transparency = 0
            data.label.TextColor3 = Color3.fromRGB(255, 200, 0)
        else
            data.stroke.Color = _G.activeHitboxZones[zoneName] and Theme.GreenBright or Theme.Green
            data.stroke.Thickness = _G.activeHitboxZones[zoneName] and 2 or 1.5
            data.label.TextColor3 = _G.activeHitboxZones[zoneName] and Theme.GreenBright or Theme.TextDim
        end
        data.label.Text = zoneName
    end

    -- ★ в подписи ползунка зоны с максимальным весом.
    for zoneName, ref in pairs(sliderRefs or {}) do
        if ref and ref.lbl then
            local isTop = (topZone == zoneName)
            ref.lbl.Text = isTop and (zoneName .. " ★") or zoneName
            ref.lbl.TextColor3 = isTop and Color3.fromRGB(255, 200, 0) or Theme.TextMain
        end
    end
end

local resetArmed = false
local resetArmToken = 0

ResetBtn.MouseButton1Click:Connect(function()
    PlayClick()
    if not resetArmed then
        resetArmed = true
        resetArmToken = resetArmToken + 1
        local myTok = resetArmToken
        ResetBtn.Text = "↺  " .. (currentLanguage == "RU" and "Нажми ещё раз" or "Click again")
        ResetBtn.BackgroundColor3 = Color3.fromRGB(120, 60, 20)
        task.delay(2, function()
            if myTok == resetArmToken and resetArmed then
                resetArmed = false
                ResetBtn.Text = localization[currentLanguage].resetAll
                ResetBtn.BackgroundColor3 = Theme.GreenDim
            end
        end)
        return
    end

    resetArmed = false
    ResetBtn.Text = localization[currentLanguage].resetAll
    ResetBtn.BackgroundColor3 = Theme.GreenDim

    for _, z in pairs({"Head", "Chest", "Waist", "Legs"}) do
        _G.AimbotWeights[z] = 0
        _G.activeHitboxZones[z] = false
        if zonePulseConns[z] then
            pcall(function() zonePulseConns[z]:Disconnect() end)
            zonePulseConns[z] = nil
        end
        local data = zoneParts[z]
        if data then
            TweenService:Create(data.frame, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
            TweenService:Create(data.stroke, TweenInfo.new(0.2), {Transparency = 1, Color = Theme.Green, Thickness = 1.5}):Play()
            data.label.TextColor3 = Theme.TextDim
            data.label.Text = z
        end
    end
    _G.hitboxPriorityZone = nil
    if updatePriorityVisuals then updatePriorityVisuals() end
    updateSlidersForZones()
end)

-- Стартовое состояние: голова активна, её ползунок стоит на 100%.
if _G.activeHitboxZones.Head then
    setZoneActive("Head", true)
end
if updatePriorityVisuals then updatePriorityVisuals() end

-- === LEGIT-CONFIG ===
function applyLegitConfig()
    -- ESP
    _G.espNames = true
    _G.espHpText = true
    _G.espDistance = true
    _G.espChams = true
    _G.viewDirection = true
    _G.viewDirLength = 5
    _G.weaponEsp = true
    _G.espBoxes = true
    _G.currentBoxType = "Corners"

    -- Аимбот
    _G.fovRadius = 30
    _G.aimSmoothing = 20
    _G.triggerbotEnabled = true
    _G.triggerbotFireRateEnabled = false
    _G.triggerbotMaxDist = 1000
    _G.triggerbotDelay = 40

    -- Наведение
    _G.aimJitterEnabled = true
    _G.aimJitterStrength = 10
    _G.aimMaxTurnEnabled = false
    _G.aimMissChance = 5
    _G.aimMissOffset = 6
    _G.aimAutoStopEnabled = false

    -- Динамический FOV
    _G.dynamicFovEnabled = true
    _G.dynamicFovStart = 3
    _G.dynamicFovMax = 3

    -- Хитбоксы: голова, грудь, пояс
    setZoneActive("Head", true)
    setZoneActive("Chest", true)
    setZoneActive("Waist", true)
    setZoneActive("Legs", false)
    _G.AimbotWeights.Head = 45
    _G.AimbotWeights.Chest = 33
    _G.AimbotWeights.Waist = 22
    _G.AimbotWeights.Legs = 0
    _G.priorityAimSpeed = 90
    _G.forcePriorityAim = true
    if HeadForceBtn then
        HeadForceBtn.BackgroundColor3 = Theme.Green
        HeadForceBtn.TextColor3 = Color3.fromRGB(10, 15, 10)
    end
    if headForceStroke then headForceStroke.Color = Theme.GreenBright end
    if updatePrioritySpeedVisibility then pcall(updatePrioritySpeedVisibility) end

    -- Обновляем визуал
    for _, g in ipairs({"espNames", "espHpText", "espDistance", "espChams", "viewDirection", "weaponEsp", "espBoxes", "triggerbotEnabled", "triggerbotFireRateEnabled", "aimJitterEnabled", "aimMaxTurnEnabled", "aimAutoStopEnabled", "dynamicFovEnabled"}) do
        pcall(refreshToggleVisual, g)
    end
    for _, g in ipairs({"viewDirLength", "fovRadius", "aimSmoothing", "triggerbotMaxDist", "triggerbotDelay", "aimJitterStrength", "aimMissChance", "aimMissOffset", "dynamicFovStart", "dynamicFovMax"}) do
        pcall(refreshSliderVisual, g)
    end
    pcall(refreshDropdownVisual, "currentBoxType")
    pcall(updateSlidersForZones)
    pcall(updatePriorityVisuals)

    if speedValLbl then speedValLbl.Text = "90" end
    if speedFill and speedKnob then
        local pct = math.clamp((90 - 1) / 99, 0, 1)
        speedFill.Size = UDim2.new(1, 0, pct, 0)
        speedFill.Position = UDim2.new(0, 0, 1 - pct, 0)
        speedKnob.Position = UDim2.new(0.5, 0, 1 - pct, 0)
    end
end

sidePanelTween = nil

function updateHitboxPanelVisibility()
    if not SidePanel then return end
    local shouldShow = menuVisible
        and tabs.Aimbot.Visible
        and ((_G.aimbotMode == "Legit" and _G.aimbotEnabled) or _G.aimbotMode == "HVH")

    if sidePanelTween then pcall(function() sidePanelTween:Cancel() end) end

    if shouldShow then
        SidePanel.Visible = true
        SidePanel.BackgroundTransparency = 0
        SidePanel.Position = UDim2.new(0, 548, 0.5, 0)
        sideStroke.Transparency = 0.2
        sidePanelTween = TweenService:Create(
            SidePanel,
            TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            { BackgroundTransparency = 0, Position = UDim2.new(0, 528, 0.5, 0) }
        )
        sidePanelTween:Play()
        task.defer(layoutHitboxPanel)
    else
        sidePanelTween = TweenService:Create(
            SidePanel,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
            { BackgroundTransparency = 1, Position = UDim2.new(0, 548, 0.5, 0) }
        )
        sidePanelTween:Play()
        sidePanelTween.Completed:Connect(function()
            if not (menuVisible and _G.aimbotMode == "Legit" and _G.aimbotEnabled and tabs.Aimbot.Visible) then
                SidePanel.Visible = false
            end
        end)
    end
end

menuScale = Instance.new("UIScale", MainFrame)
menuScale.Scale = 1

activeTweens = {}
menuToken = 0

local function cancelAllTweens()
    for _, t in ipairs(activeTweens) do pcall(function() t:Cancel() end) end
    activeTweens = {}
end

local function toggleMenu()
    menuVisible = not menuVisible
    menuToken = menuToken + 1
    local myToken = menuToken
    cancelAllTweens()

    ParticleContainer.Visible = menuVisible

    local inInfo = TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    local outInfo = TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

    if menuVisible then
        MainFrame.Visible = true
        menuScale.Scale = 0.85
        MainFrame.BackgroundTransparency = 0
        MenuBlur.Enabled = true
        MenuBlur.Size = 0

        local bT = TweenService:Create(MenuBlur, inInfo, {Size = 6}); table.insert(activeTweens, bT); bT:Play()
        local sT = TweenService:Create(menuScale, inInfo, {Scale = 1}); table.insert(activeTweens, sT); sT:Play()

        if updateHitboxPanelVisibility then updateHitboxPanelVisibility() end
    else
        if AnimPanel then AnimPanel.Visible = false end
        local bT = TweenService:Create(MenuBlur, outInfo, {Size = 0}); table.insert(activeTweens, bT); bT:Play()
        bT.Completed:Connect(function()
            if myToken == menuToken and not menuVisible then MenuBlur.Enabled = false end
        end)
        local sT = TweenService:Create(menuScale, outInfo, {Scale = 0.85}); table.insert(activeTweens, sT); sT:Play()
        sT.Completed:Connect(function()
            if myToken ~= menuToken or menuVisible then return end
            MainFrame.Visible = false
        end)

        if updateHitboxPanelVisibility then updateHitboxPanelVisibility() end
    end
end

MenuBlur.Enabled = true
MenuBlur.Size = 6

UserInputService.InputBegan:Connect(function(input, processed)
    if _G.unloaded then return end
    if not processed and input.KeyCode == Enum.KeyCode.Insert then toggleMenu() end
    -- Быстрый тумблер debug-камеры (F4) — переключает флаг, дальше авто-цикл сам запускает/гасит.
    if not processed and input.KeyCode == Enum.KeyCode.F4 then
        _G.debugCamEnabled = not _G.debugCamEnabled
    end
end)

local dragging, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true dragStart = input.Position startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- ========================================================================
-- ФУНКЦИОНАЛЬНАЯ ЛОГИКА
-- ========================================================================
local boneConnections = {
    {"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"},
    {"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"}, {"LeftLowerArm", "LeftHand"},
    {"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"}, {"RightLowerArm", "RightHand"},
    {"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"}, {"LeftLowerLeg", "LeftFoot"},
    {"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}, {"RightLowerLeg", "RightFoot"},
    {"Head", "Torso"}, {"Torso", "Left Arm"}, {"Torso", "Right Arm"}, {"Torso", "Left Leg"}, {"Torso", "Right Leg"}
}

local skeletonLines = {}
local viewDirLines = {}
local tracerLines = {}

local function createDrawingLine(container)
    local line = Drawing.new("Line")
    line.Visible = false
    line.Color = Theme.Green
    line.Thickness = 1.5
    line.Transparency = 1
    table.insert(container, line)
    return line
end

local function createEspElements(player)
    local base = Instance.new("Folder", EspContainer)
    base.Name = player.Name

    local box = Instance.new("Frame", base)
    box.Name = "Box"
    box.BackgroundTransparency = 1
    box.BorderSizePixel = 0
    for _, lName in pairs({"TopLeftV", "TopLeftH", "TopRightV", "TopRightH", "BotLeftV", "BotLeftH", "BotRightV", "BotRightH"}) do
        local l = Instance.new("Frame", box)
        l.Name = lName
        l.BorderSizePixel = 0
    end

    local nameLabel = Instance.new("TextLabel", base)
    nameLabel.Name = "NameLabel"
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextSize = 11
    nameLabel.Font = Enum.Font.SourceSansBold

    local hpBarBG = Instance.new("Frame", base)
    hpBarBG.Name = "HpBarBG"
    hpBarBG.BackgroundColor3 = Color3.fromRGB(20, 30, 20)
    hpBarBG.BorderSizePixel = 0

    local hpBar = Instance.new("Frame", hpBarBG)
    hpBar.Name = "HpBar"
    hpBar.BorderSizePixel = 0
    hpBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

    local hpGradient = Instance.new("UIGradient", hpBar)
    hpGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(220, 30, 30)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 220, 60))
    }
    hpGradient.Rotation = 90

    local distLabel = Instance.new("TextLabel", base)
    distLabel.Name = "DistLabel"
    distLabel.BackgroundTransparency = 1
    distLabel.TextColor3 = Color3.fromRGB(200, 255, 200)
    distLabel.TextSize = 11
    distLabel.Font = Enum.Font.SourceSansBold
    distLabel.Text = ""
    distLabel.Visible = false

    local weaponLabel = Instance.new("TextLabel", base)
    weaponLabel.Name = "WeaponLabel"
    weaponLabel.BackgroundTransparency = 1
    weaponLabel.TextColor3 = Color3.fromRGB(255, 220, 100)
    weaponLabel.TextSize = 10
    weaponLabel.Font = Enum.Font.SourceSans
    weaponLabel.Text = ""
    weaponLabel.Visible = false
end

local function getZoneForPartName(partName, char)
    local isR15 = char:FindFirstChild("UpperTorso") ~= nil
    if isR15 then
        if partName == "Head" then return "Head" end
        if partName == "UpperTorso" then return "Chest" end
        if partName == "LowerTorso" then return "Waist" end
        if partName == "LeftUpperLeg" or partName == "RightUpperLeg"
           or partName == "LeftLowerLeg" or partName == "RightLowerLeg"
           or partName == "LeftFoot" or partName == "RightFoot" then
            return "Legs"
        end
    else
        if partName == "Head" then return "Head" end
        if partName == "Torso" then
            local wChest = _G.activeHitboxZones.Chest and (_G.AimbotWeights.Chest or 0) or 0
            local wWaist = _G.activeHitboxZones.Waist and (_G.AimbotWeights.Waist or 0) or 0
            if wWaist > wChest then return "Waist" end
            return "Chest"
        end
        if partName == "Left Leg" or partName == "Right Leg" then return "Legs" end
    end
    return nil
end

local function getAllTargetParts(character)
    local parts = {}
    local isR15 = character:FindFirstChild("UpperTorso") ~= nil
    if isR15 then
        local r15Parts = {
            "Head", "UpperTorso", "LowerTorso",
            "LeftUpperArm", "RightUpperArm", "LeftLowerArm", "RightLowerArm",
            "LeftUpperLeg", "RightUpperLeg", "LeftLowerLeg", "RightLowerLeg",
            "LeftFoot", "RightFoot",
        }
        for _, name in ipairs(r15Parts) do
            local p = character:FindFirstChild(name)
            if p and p:IsA("BasePart") then
                local zone = getZoneForPartName(name, character)
                if zone and _G.activeHitboxZones[zone] then
                    table.insert(parts, {part = p, zone = zone, partName = name})
                end
            end
        end
    else
        local r6Parts = {
            "Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg",
        }
        for _, name in ipairs(r6Parts) do
            local p = character:FindFirstChild(name)
            if p and p:IsA("BasePart") then
                local zone = getZoneForPartName(name, character)
                if zone and _G.activeHitboxZones[zone] then
                    table.insert(parts, {part = p, zone = zone, partName = name})
                end
            end
        end
    end
    return parts
end

-- Часть тела приоритетной зоны (★) — к ней ведём прицел.
local function getPriorityPartFor(char)
    if not char then return nil end
    local topZone, topW = nil, -1
    for _, z in ipairs({"Head", "Chest", "Waist", "Legs"}) do
        if _G.activeHitboxZones[z] then
            local w = _G.AimbotWeights[z] or 0
            if w > topW then topW = w; topZone = z end
        end
    end
    if not topZone then return nil end
    local isR15 = char:FindFirstChild("UpperTorso") ~= nil
    if topZone == "Head" then return char:FindFirstChild("Head") end
    if topZone == "Chest" then return char:FindFirstChild(isR15 and "UpperTorso" or "Torso") end
    if topZone == "Waist" then return char:FindFirstChild(isR15 and "LowerTorso" or "Torso") end
    if topZone == "Legs" then
        if isR15 then
            return char:FindFirstChild("LeftUpperLeg") or char:FindFirstChild("RightUpperLeg")
                or char:FindFirstChild("LeftLowerLeg") or char:FindFirstChild("RightLowerLeg")
        end
        return char:FindFirstChild("Left Leg") or char:FindFirstChild("Right Leg")
    end
    return nil
end


-- Выбранная зона для текущей цели (держим ~0.4с, чтобы прицел не дёргался).
local aimPickPlayer, aimPickZone, aimPickTime = nil, nil, 0

local aimVisCache = {}

local function getClosestPlayer()
    local myChar = LocalPlayer.Character
    local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHrp then return nil, nil end

    -- Эффективный FOV с учётом динамического буста.
    local fovLimit = _G.fovRadius * (_G.__dynFovMult or 1)

    local mouseLocation = UserInputService:GetMouseLocation()
    local visibleTargets = {}
    local wallTargets = {}

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local char = player.Character
            local hum = char:FindFirstChildOfClass("Humanoid")
            
            if hum and hum.Health > 0 then
                if isPlayerIgnored(player) or (_G.ignoreFriends and LocalPlayer:IsFriendsWith(player.UserId)) then
                    continue
                end

                local targetParts = getAllTargetParts(char)
                for _, tp in ipairs(targetParts) do
                    local screenPos, onScreen = Camera:WorldToViewportPoint(tp.part.Position)
                    if onScreen then
                        -- При активном бусте не цепляем дальних: только ближние.
                        if _G.dynamicFovEnabled and (_G.__dynFovMult or 1) > 1.05 then
                            local wd = (tp.part.Position - myHrp.Position).Magnitude
                            if wd > (_G.dynamicFovStart or 15) then continue end
                        end
                        local dist = (Vector2.new(screenPos.X, screenPos.Y) - mouseLocation).Magnitude
                        if dist <= fovLimit then
                            
                            -- Видимость считаем всегда (с кэшем 80 мс): цель за стеной
                            -- получает низкий приоритет, но не исчезает из выбора.
                            local behindWall = false
                            local vc = aimVisCache[tp.part]
                            local vnow = tick()
                            if vc and vnow < vc.t then
                                behindWall = vc.v
                            else
                                local rayDir = tp.part.Position - Camera.CFrame.Position
                                local ray = Ray.new(Camera.CFrame.Position, rayDir.Unit * (rayDir.Magnitude + 5))
                                local hit = workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character, char})
                                behindWall = hit ~= nil
                                aimVisCache[tp.part] = { t = vnow + 0.08, v = behindWall }
                            end

                            local targetLook = char:FindFirstChild("Head") and char.Head.CFrame.LookVector or char.HumanoidRootPart.CFrame.LookVector
                            local toMe = (myHrp.Position - tp.part.Position).Unit
                            local threat = targetLook:Dot(toMe)

                            local targetData = {player = player, part = tp.part, dist = dist, threat = threat, isVisible = not behindWall, behindWall = behindWall, zone = tp.zone}
                            
                            if behindWall then
                                -- Жёсткий фильтр «Проверка стен»: за стеной цель вообще не берём.
                                if not _G.ignoreBehindWalls then table.insert(wallTargets, targetData) end
                            else
                                table.insert(visibleTargets, targetData)
                            end
                        end
                    end
                end
            end
        end
    end

    local function findBestTarget(targets)
        if #targets == 0 then return nil end
        table.sort(targets, function(a, b) return a.dist < b.dist end)
        local closest = targets[1]

        local closeGroup = {}
        for _, t in ipairs(targets) do
            if math.abs(t.dist - closest.dist) <= 15 then
                table.insert(closeGroup, t)
            end
        end

        if #closeGroup == 1 then return closest end
        table.sort(closeGroup, function(a, b) return a.threat > b.threat end)
        return closeGroup[1]
    end

    -- Выбор части тела по весам: вероятность пропорциональна весу зоны.
    -- Одна зона 100 — всегда она; 50/50 — примерно поровну голова/тело.
    -- Выбор держим ~0.4с, чтобы прицел не дёргался между частями каждый кадр.
    local function refinePart(pool, bestT)
        if not bestT then return nil end

        local now = tick()

        local function pickZone()
            local total = 0
            for _, t in ipairs(pool) do
                if t.player == bestT.player then
                    local w = (_G.AimbotWeights and _G.AimbotWeights[t.zone]) or 0
                    if w > 0 then total = total + w end
                end
            end
            if total <= 0 then return nil end
            local r = math.random() * total
            local acc = 0
            for _, t in ipairs(pool) do
                if t.player == bestT.player then
                    local w = (_G.AimbotWeights and _G.AimbotWeights[t.zone]) or 0
                    if w > 0 then
                        acc = acc + w
                        if r <= acc then return t.zone end
                    end
                end
            end
            return nil
        end

        if aimPickPlayer ~= bestT.player or now - aimPickTime > 0.4
           or not aimPickZone or not _G.activeHitboxZones[aimPickZone] then
            aimPickPlayer = bestT.player
            aimPickZone = pickZone()
            aimPickTime = now
        end

        if aimPickZone then
            for _, t in ipairs(pool) do
                if t.player == bestT.player and t.zone == aimPickZone then
                    return t
                end
            end
        end
        return bestT
    end

    local best = findBestTarget(visibleTargets)
    if best then
        local chosen = refinePart(visibleTargets, best)
        return chosen.player, chosen.part
    end

    if not _G.ignoreBehindWalls then
        best = findBestTarget(wallTargets)
        if best then
            local chosen = refinePart(wallTargets, best)
            return chosen.player, chosen.part
        end
    end

    return nil, nil
end

-- Переменные для удержания цели
_G.lockedTargetPlayer = nil
_G.lockedTargetTime = 0

local hvhSnapPart, hvhSnapPick = nil, 0

local fakeRunTrack, fakeRunAnimId, fakeRunAnimator, fakeRunCharAnimator = nil, nil, nil, nil

local function getHvhTarget()
    local myChar = LocalPlayer.Character
    local myHrp  = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHrp then return nil end

    local camPos = Camera.CFrame.Position
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude

    local visibleTargets = {}
    local wallTargets = {}
    local currentTime = tick()

    -- 1. Собираем всех врагов
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local char = player.Character
            local hum  = char:FindFirstChildOfClass("Humanoid")
            local head = char:FindFirstChild("Head")

            if hum and hum.Health > 0 and head and hum:GetState() ~= Enum.HumanoidStateType.Dead then
                local skip = false
                if isPlayerIgnored(player) or (_G.hvhIgnoreFriends and LocalPlayer:IsFriendsWith(player.UserId)) then
                    skip = true
                end

                if not skip then
                    local aimPos = head.Position
                    local dist = (aimPos - myHrp.Position).Magnitude
                    
                    -- Проверяем видимость
                    rayParams.FilterDescendantsInstances = {char, myChar}
                    local hit = workspace:Raycast(camPos, aimPos - camPos, rayParams)
                    local isVisible = (hit == nil)

                    -- Проверяем, смотрит ли на нас
                    local targetLook = head.CFrame.LookVector
                    local toMe = (myHrp.Position - head.Position).Unit
                    local dot = targetLook:Dot(toMe)

                    local targetData = { 
                        player = player, 
                        part = {Position = aimPos, Parent = char}, 
                        dist = dist,
                        threat = dot,
                        isVisible = isVisible
                    }

                    if isVisible then
                        table.insert(visibleTargets, targetData)
                    else
                        table.insert(wallTargets, targetData)
                    end
                end
            end
        end
    end

    -- 2. Функция выбора лучшей цели
    local function findBestTarget(targets)
        if #targets == 0 then return nil end
        table.sort(targets, function(a, b) return a.dist < b.dist end)
        local closest = targets[1]

        local closeGroup = {}
        for _, t in ipairs(targets) do
            if math.abs(t.dist - closest.dist) <= 15 then
                table.insert(closeGroup, t)
            end
        end

        if #closeGroup == 1 then return closest end
        table.sort(closeGroup, function(a, b) return a.threat > b.threat end)
        return closeGroup[1]
    end

    -- 3. Логика захвата (Target Lock)
    if _G.hvhTargetLockEnabled and _G.lockedTargetPlayer and _G.lockedTargetPlayer.Character then
        local lockedChar = _G.lockedTargetPlayer.Character
        local lockedHum = lockedChar:FindFirstChildOfClass("Humanoid")
        local lockedHead = lockedChar:FindFirstChild("Head")
        
        if lockedHum and lockedHum.Health > 0 and lockedHead then
            local lockedPos = lockedHead.Position
            
            rayParams.FilterDescendantsInstances = {lockedChar, myChar}
            local lockedHit = workspace:Raycast(camPos, lockedPos - camPos, rayParams)
            local isLockedVisible = (lockedHit == nil)

            if not isLockedVisible and not _G.hvhThroughWalls then
                _G.lockedTargetPlayer = nil
            else
                if currentTime - _G.lockedTargetTime < 3.0 then
                    return { player = _G.lockedTargetPlayer, part = {Position = lockedPos, Parent = lockedChar} }
                end
            end
        else
            _G.lockedTargetPlayer = nil
        end
    end

    -- 4. Поиск новой цели
    local newBestTarget = nil
    if _G.hvhThroughWalls then
        newBestTarget = findBestTarget(visibleTargets) or findBestTarget(wallTargets)
    else
        newBestTarget = findBestTarget(visibleTargets)
    end

    if newBestTarget then
        if _G.hvhTargetLockEnabled then
            _G.lockedTargetPlayer = newBestTarget.player
            _G.lockedTargetTime = currentTime
        end
        return newBestTarget
    end

    return nil
end

local visCache = {}
local function isTargetVisible(obj, hrp)
    if not hrp then return false end
    local now = tick()
    local c = visCache[obj]
    if c and now < c.t then return c.v end
    local rp = RaycastParams.new()
    rp.FilterType = Enum.RaycastFilterType.Exclude
    rp.FilterDescendantsInstances = {LocalPlayer.Character, obj}
    local hit = workspace:Raycast(Camera.CFrame.Position, hrp.Position - Camera.CFrame.Position, rp)
    local v = (hit == nil)
    visCache[obj] = { t = now + 0.15, v = v }
    return v
end

local function updateEsp()
    local currentThemeColor = _G.espColor
    local currentActiveTargets = {}

    local skelIdx, viewIdx, tracerIdx = 1, 1, 1
    for _, l in pairs(skeletonLines) do l.Visible = false end
    for _, l in pairs(viewDirLines) do l.Visible = false end
    for _, l in pairs(tracerLines) do l.Visible = false end

    local myChar = LocalPlayer.Character
    local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")

    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("Model") and obj:FindFirstChild("HumanoidRootPart") and obj:FindFirstChild("Humanoid") and obj.Name ~= LocalPlayer.Name and Players:GetPlayerFromCharacter(obj) ~= LocalPlayer then
            local hrp, hum = obj.HumanoidRootPart, obj.Humanoid
            if hum.Health <= 0 then continue end
            if _G.focusedPlayer == obj.Name then
                currentThemeColor = Color3.fromRGB(255, 60, 60)
            elseif _G.friendPlayers[obj.Name] == true then
                currentThemeColor = Color3.fromRGB(80, 255, 140)
            else
                currentThemeColor = _G.espColor
            end
            currentActiveTargets[obj.Name] = true

            local base = EspContainer:FindFirstChild(obj.Name)
            if not base then
                createEspElements({Name = obj.Name, Character = obj})
                base = EspContainer:FindFirstChild(obj.Name)
            end
            if not base then continue end

            local box = base:FindFirstChild("Box")
            local nameLabel = base:FindFirstChild("NameLabel")
            local hpBarBG = base:FindFirstChild("HpBarBG")
            local distLabel = base:FindFirstChild("DistLabel")
            local weaponLabel = base:FindFirstChild("WeaponLabel")
            local ignoredTarget = _G.friendPlayers[obj.Name] == true
            if ignoredTarget then
                if box then box.Visible = false end
                if nameLabel then nameLabel.Visible = false end
                if hpBarBG then hpBarBG.Visible = false end
                if distLabel then distLabel.Visible = false end
                if weaponLabel then weaponLabel.Visible = false end
                local hl = ChamsContainer:FindFirstChild(obj.Name)
                if hl and (not hl:IsA("Highlight") or hl.Adornee ~= obj) then
                    hl:Destroy()
                    hl = nil
                end
                if not hl then
                    hl = Instance.new("Highlight", ChamsContainer)
                    hl.Name = obj.Name
                    hl.Adornee = obj
                end
                hl.FillColor = Color3.fromRGB(170, 80, 255)
                hl.FillTransparency = 0.25
                hl.OutlineColor = Color3.fromRGB(190, 120, 255)
                hl.OutlineTransparency = 0.4
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                hl.Enabled = true
                continue
            end
            local objVisible = isTargetVisible(obj, hrp)
            local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)

            if onScreen then
                local topPos = Camera:WorldToViewportPoint(hrp.Position + Vector3.new(0, 3, 0))
                local bottomPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3.5, 0))
                local boxHeight = math.abs(topPos.Y - bottomPos.Y)
                local boxWidth = boxHeight * 0.6
                local correctedX = math.floor(pos.X)
                local correctedY = math.floor(pos.Y)

                if boxHeight < 8 then boxHeight = 8 end
                if boxWidth < 6 then boxWidth = 6 end

                if _G.espBoxes and box then
                    box.Visible = true
                    box.Position = UDim2.new(0, correctedX - boxWidth/2, 0, correctedY - boxHeight/2)
                    box.Size = UDim2.new(0, boxWidth, 0, boxHeight)
                    for _, line in pairs(box:GetChildren()) do
                        line.BackgroundColor3 = currentThemeColor
                        line.BorderSizePixel = 0
                    end
                    local thick = 1
                    if _G.currentBoxType == "Full" then
                        box.TopLeftV.Size, box.TopLeftV.Position = UDim2.new(0, thick, 1, 0), UDim2.new(0, 0, 0, 0)
                        box.TopLeftH.Size, box.TopLeftH.Position = UDim2.new(1, 0, 0, thick), UDim2.new(0, 0, 0, 0)
                        box.TopRightV.Size, box.TopRightV.Position = UDim2.new(0, thick, 1, 0), UDim2.new(1, -thick, 0, 0)
                        box.BotLeftH.Size, box.BotLeftH.Position = UDim2.new(1, 0, 0, thick), UDim2.new(0, 0, 1, -thick)
                        box.TopRightH.Visible, box.BotLeftV.Visible, box.BotRightV.Visible, box.BotRightH.Visible = false, false, false, false
                    else
                        box.TopRightH.Visible, box.BotLeftV.Visible, box.BotRightV.Visible, box.BotRightH.Visible = true, true, true, true
                        local len = math.clamp(boxWidth * ((_G.boxCornerSize or 25) / 100), 2, 16)
                        box.TopLeftV.Size, box.TopLeftV.Position = UDim2.new(0, thick, 0, len), UDim2.new(0, 0, 0, 0)
                        box.TopLeftH.Size, box.TopLeftH.Position = UDim2.new(0, len, 0, thick), UDim2.new(0, 0, 0, 0)
                        box.TopRightV.Size, box.TopRightV.Position = UDim2.new(0, thick, 0, len), UDim2.new(1, -thick, 0, 0)
                        box.TopRightH.Size, box.TopRightH.Position = UDim2.new(0, len, 0, thick), UDim2.new(1, -len, 0, 0)
                        box.BotLeftV.Size, box.BotLeftV.Position = UDim2.new(0, thick, 0, len), UDim2.new(0, 0, 1, -len)
                        box.BotLeftH.Size, box.BotLeftH.Position = UDim2.new(0, len, 0, thick), UDim2.new(0, 0, 1, -thick)
                        box.BotRightV.Size, box.BotRightV.Position = UDim2.new(0, thick, 0, len), UDim2.new(1, -thick, 1, -len)
                        box.BotRightH.Size, box.BotRightH.Position = UDim2.new(0, len, 0, thick), UDim2.new(1, -len, 1, -thick)
                    end
                elseif box then
                    box.Visible = false
                end

                local labelY = correctedY - boxHeight/2 - 14

                if hpBarBG and _G.espHpText then
                    hpBarBG.Visible = true
                    hpBarBG.Position = UDim2.new(0, correctedX - boxWidth/2 - 6, 0, correctedY - boxHeight/2)
                    hpBarBG.Size = UDim2.new(0, 3, 0, boxHeight)
                    local hpBar = hpBarBG:FindFirstChild("HpBar")
                    if hpBar then
                        local hpPct = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                        hpBar.Position = UDim2.new(0, 0, 1 - hpPct, 0)
                        hpBar.Size = UDim2.new(1, 0, hpPct, 0)
                    end
                elseif hpBarBG then
                    hpBarBG.Visible = false
                end

                if nameLabel then
                    if _G.espNames then
                        nameLabel.Visible = true
                        nameLabel.Position = UDim2.new(0, correctedX - 100, 0, labelY)
                        nameLabel.Size = UDim2.new(0, 200, 0, 14)
                        nameLabel.Text = obj.Name
                nameLabel.TextSize = _G.espTextSize or 11
                        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                        labelY = labelY - 14
                    else
                        nameLabel.Visible = false
                    end
                end

                if distLabel then
                    if _G.espDistance and myHrp then
                        local dist = (hrp.Position - myHrp.Position).Magnitude
                        distLabel.Visible = true
                        distLabel.Position = UDim2.new(0, correctedX - 100, 0, labelY)
                        distLabel.Size = UDim2.new(0, 200, 0, 14)
                        distLabel.Text = string.format("%d m", math.floor(dist))
                    distLabel.TextSize = _G.espTextSize or 11
                        labelY = labelY - 14
                    else
                        distLabel.Visible = false
                    end
                end

                if weaponLabel then
                    if _G.weaponEsp then
                        local heldTool = obj:FindFirstChildOfClass("Tool")
                        weaponLabel.Visible = true
                        weaponLabel.Position = UDim2.new(0, correctedX - 100, 0, labelY)
                        weaponLabel.Size = UDim2.new(0, 200, 0, 12)
                        weaponLabel.Text = heldTool and heldTool.Name or "Fists"
                    weaponLabel.TextSize = math.max(8, (_G.espTextSize or 11) - 1)
                    else
                        weaponLabel.Visible = false
                    end
                end

                if _G.espTracers then
                    local startScreen = Vector2.new(Camera.ViewportSize.X * 0.5, Camera.ViewportSize.Y + 5)
                    local endScreen = Vector2.new(pos.X, pos.Y)
                    local tLine = tracerLines[tracerIdx] or createDrawingLine(tracerLines)
                    tLine.Visible = true
                    tLine.From = startScreen
                    tLine.To = endScreen
                    tLine.Color = currentThemeColor
                    tLine.Thickness = _G.tracerThickness
                    tLine.Transparency = 0.8
                    tracerIdx = tracerIdx + 1
                end

                if _G.espSkeletons then
                    for _, connection in pairs(boneConnections) do
                        local p1, p2 = obj:FindFirstChild(connection[1]), obj:FindFirstChild(connection[2])
                        if p1 and p2 then
                            local sPos1, o1 = Camera:WorldToViewportPoint(p1.Position)
                            local sPos2, o2 = Camera:WorldToViewportPoint(p2.Position)
                            if o1 and o2 then
                                local dLine = skeletonLines[skelIdx] or createDrawingLine(skeletonLines)
                                dLine.Visible = true
                                dLine.From = Vector2.new(sPos1.X, sPos1.Y)
                                dLine.To = Vector2.new(sPos2.X, sPos2.Y)
                                dLine.Color = currentThemeColor
                                dLine.Thickness = 2
                                skelIdx = skelIdx + 1
                            end
                        end
                    end
                end

                if _G.viewDirection and obj:FindFirstChild("Head") then
                    local head = obj.Head
                    local lookVector = head.CFrame.LookVector
                    local endWorldPos = head.Position + (lookVector * _G.viewDirLength)
                    local sStart, oStart = Camera:WorldToViewportPoint(head.Position)
                    local sEnd, oEnd = Camera:WorldToViewportPoint(endWorldPos)
                    if oStart and oEnd then
                        local vLine = viewDirLines[viewIdx] or createDrawingLine(viewDirLines)
                        vLine.Visible = true
                        vLine.From = Vector2.new(sStart.X, sStart.Y)
                        vLine.To = Vector2.new(sEnd.X, sEnd.Y)
                        vLine.Color = currentThemeColor
                        vLine.Thickness = 1.5
                        viewIdx = viewIdx + 1
                    end
                end
            else
                if box then box.Visible = false end
                if nameLabel then nameLabel.Visible = false end
                if hpBarBG then hpBarBG.Visible = false end
                if distLabel then distLabel.Visible = false end
                if weaponLabel then weaponLabel.Visible = false end
            end

            local highlight = ChamsContainer:FindFirstChild(obj.Name)
            if _G.espChams then
                if not highlight or highlight.Adornee ~= obj then
                    -- Создаём один Highlight, привязанный к РЕАЛЬНОЙ модели игрока (Character).
                    -- Не клонируем части и не создаём временные модели — это убирает тормоза.
                    if highlight then highlight:Destroy() end
                    highlight = Instance.new("Highlight", ChamsContainer)
                    highlight.Name = obj.Name
                    highlight.Adornee = obj
                    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                end
                local chamsColor = Color3.fromRGB(0, 255, 100)
                if _G.focusedPlayer == obj.Name then chamsColor = Color3.fromRGB(255, 60, 60) end
                highlight.FillColor = chamsColor
                highlight.FillTransparency = _G.chamsFillTransparency / 100
                highlight.OutlineColor = (_G.currentChamsStyle == "Match") and chamsColor or Color3.fromRGB(0, 255, 100)
                highlight.OutlineTransparency = 0
                highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                highlight.Enabled = true
            elseif highlight then
                highlight:Destroy()
            end
        end
    end
    for _, child in pairs(EspContainer:GetChildren()) do
        if not currentActiveTargets[child.Name] then child:Destroy() end
    end
    for _, child in pairs(ChamsContainer:GetChildren()) do
        if not currentActiveTargets[child.Name] then child:Destroy() end
    end
end

local function fireWeapon(aimPart)
    pcall(function()
        if aimPart and aimPart.Position then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, aimPart.Position)
            task.wait(0.016)
        end
        local mouseLoc = UserInputService:GetMouseLocation()
        VirtualInputManager:SendMouseButtonEvent(mouseLoc.X, mouseLoc.Y, 0, true, game, 1)
        task.wait(0.01)
        VirtualInputManager:SendMouseButtonEvent(mouseLoc.X, mouseLoc.Y, 0, false, game, 1)
    end)
    if _G.triggerMenuPulse then pcall(_G.triggerMenuPulse) end
end

RunService.RenderStepped:Connect(function(dt)
    -- Динамический FOV: плавно растёт, когда рядом враг (только ближний).
    if _G.dynamicFovEnabled then
        local nowT = tick()
        if nowT >= (_G.__dynFovNext or 0) then
            _G.__dynFovNext = nowT + 0.1
            local myChar = LocalPlayer.Character
            local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
            local nearest = nil
            if myHrp then
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= LocalPlayer and plr.Character then
                        local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                        local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                        if hum and hum.Health > 0 and hrp then
                            if not (isPlayerIgnored(plr) or (_G.ignoreFriends and LocalPlayer:IsFriendsWith(plr.UserId))) then
                                local d = (hrp.Position - myHrp.Position).Magnitude
                                if d <= _G.dynamicFovStart and (not nearest or d < nearest) then
                                    nearest = d
                                end
                            end
                        end
                    end
                end
            end
            local target = 1
            if nearest then
                local t = 1 - math.clamp(nearest / math.max(_G.dynamicFovStart or 15, 1), 0, 1)
                target = 1 + (math.max(_G.dynamicFovMax or 5, 1) - 1) * t
            end
            _G.__dynFovTarget = target
        end
        local cur = _G.__dynFovMult or 1
        _G.__dynFovMult = cur + ((_G.__dynFovTarget or 1) - cur) * math.clamp((dt or (1/60)) * 8, 0, 1)
    else
        _G.__dynFovMult = 1
        _G.__dynFovTarget = 1
    end

    if GuiFovCircle then
        -- Круг FOV виден, только когда включён аимбот (в текущем режиме).
        local showFov = (_G.aimbotMode == "Legit" and _G.aimbotEnabled)
            or (_G.aimbotMode == "HVH" and _G.hvhAimbotEnabled)
        GuiFovCircle.Visible = showFov
        if showFov then
            local mousePos = UserInputService:GetMouseLocation()
            GuiFovCircle.Position = UDim2.new(0, mousePos.X, 0, mousePos.Y)
            local fovNow = _G.fovRadius * (_G.__dynFovMult or 1)
            GuiFovCircle.Size = UDim2.new(0, fovNow * 2, 0, fovNow * 2)
        end
    end
    updateEsp()

    -- === LEGIT AIMBOT ===
    if _G.aimbotEnabled and _G.aimbotMode == "Legit" then
        local target, targetPart = getClosestPlayer()

        if target and targetPart and targetPart.Parent and target.Character then
            local char = target.Character

            local currentZone = nil
            for zone, mapParts in pairs(_G.HitboxZoneMap) do
                for _, pn in ipairs(mapParts) do
                    if targetPart.Name == pn then currentZone = zone break end
                end
                if currentZone then break end
            end

            local zoneChanged = (currentZone ~= _G.__lastAimZone)
            _G.__lastAimZone = currentZone

            if target ~= lastTargetPlayer or zoneChanged then
                lastTargetPlayer = target
                lockedTargetPart = targetPart
                currentAimPoint = Camera.CFrame.Position + Camera.CFrame.LookVector * 50

                if _G.aimMissEnabled and math.random(1, 100) <= _G.aimMissChance then
                    currentMissOffset = Vector3.new(
                        (math.random() - 0.5) * 2 * (_G.aimMissOffset / 100),
                        (math.random() - 0.5) * 2 * (_G.aimMissOffset / 100),
                        0
                    )
                else
                    currentMissOffset = Vector3.zero
                end
                missRerollTime = tick() + 0.5
            end

            if _G.aimMissEnabled and tick() > missRerollTime and math.random(1, 100) <= _G.aimMissChance then
                currentMissOffset = Vector3.new(
                    (math.random() - 0.5) * 2 * (_G.aimMissOffset / 100),
                    (math.random() - 0.5) * 2 * (_G.aimMissOffset / 100),
                    0
                )
                missRerollTime = tick() + 0.5
            end

            lockedTargetPart = targetPart

            if not currentAimPoint then
                currentAimPoint = Camera.CFrame.Position + Camera.CFrame.LookVector * 50
            end

            local finalTargetPos = targetPart.Position

            -- Перевод прицела между хитбоксами: только когда взгляд на хитбоксе.
            -- Тогда ведёт слайдер перевода; иначе — обычное сглаживание.
            local priorityActive = false
            local gazePart = nil
            if _G.forcePriorityAim then
                local camPosNow = Camera.CFrame.Position
                local lookNow = Camera.CFrame.LookVector
                local rp = RaycastParams.new()
                rp.FilterType = Enum.RaycastFilterType.Exclude
                rp.FilterDescendantsInstances = {LocalPlayer.Character}
                local gazeHit = workspace:Raycast(camPosNow, lookNow * 500, rp)
                if gazeHit and gazeHit.Instance and gazeHit.Instance:IsDescendantOf(char) then
                    for zone, mapParts in pairs(_G.HitboxZoneMap) do
                        for _, pn in ipairs(mapParts) do
                            if gazeHit.Instance.Name == pn then
                                gazePart = gazeHit.Instance
                                break
                            end
                        end
                        if gazePart then break end
                    end
                end

                local pp = getPriorityPartFor(char)
                if pp then
                    finalTargetPos = pp.Position
                    if gazePart then
                        if priorityPlayer ~= target or priorityTargetPart ~= pp or priorityAnchor ~= gazePart then
                            priorityPlayer = target
                            priorityTargetPart = pp
                            priorityAnchor = gazePart
                            priorityProgress = 0
                        end
                        local sp = math.clamp((_G.priorityAimSpeed or 100) / 100, 0, 1)
                        if sp >= 0.99 then
                            priorityProgress = 1
                        else
                            priorityProgress = math.min(1, priorityProgress + (dt or (1/60)) * (0.3 + sp * 9.7))
                        end
                        finalTargetPos = gazePart.Position:Lerp(pp.Position, priorityProgress)
                        priorityActive = true
                    end
                end
            end
            if _G.aimJitterEnabled then
                local amp = (_G.aimbotMode == "HVH") and 0.15 or 0.9
                local jitter = (_G.aimJitterStrength / 100) * amp
                finalTargetPos = finalTargetPos + Vector3.new(
                    (math.random() - 0.5) * 2 * jitter,
                    (math.random() - 0.5) * 2 * jitter,
                    (math.random() - 0.5) * 2 * jitter
                )
            end
            if _G.aimMissEnabled and currentMissOffset.Magnitude > 0 then
                finalTargetPos = finalTargetPos + currentMissOffset * 5
            end

            local camPos = Camera.CFrame.Position

            -- === ВСЕГДА ДОВОДКА ===
            -- Только доводка: аимбот подтягивает взгляд, но не захватывает цель.
            -- 0 = заметная помощь (0.6 за кадр), 100 = едва заметная (0.12).
            -- Курсор всегда можно увести — полного удержания нет.
            local s = math.clamp(_G.aimSmoothing / 100, 0, 1)

            -- Упреждение движения цели: при стрейфе прицел ведёт точку заранее,
            -- иначе доводка отстаёт и «не догоняет» на ходу.
            local leadPart = targetPart
            if leadPart and leadPart.AssemblyLinearVelocity then
                local lead = 0.05 + (1 - s) * 0.05
                finalTargetPos = finalTargetPos + leadPart.AssemblyLinearVelocity * lead
            end

            -- Доводка считается в углах, а не в мировой точке: скорость поворота
            -- ограничена, не зависит от дистанции и не дёргается при движении.
            -- 0 — без сглаживания (снап), 100 — очень медленное ведение.
            local curDir = Camera.CFrame.LookVector
            local wantDir = finalTargetPos - camPos
            if s <= 0.001 then
                -- Ползунок в нуле: наведение без сглаживания.
                Camera.CFrame = CFrame.new(camPos, finalTargetPos)
            elseif wantDir.Magnitude > 0.01 then
                -- 1% ≈ 610°/с, 20% ≈ 405°/с, 50% ≈ 163°/с, 100% ≈ 8°/с.
                local maxDegPerSec = 8 + ((1 - s) ^ 2) * 620
                if priorityActive then maxDegPerSec = maxDegPerSec * 1.3 end
                wantDir = wantDir.Unit
                local dot = math.clamp(curDir:Dot(wantDir), -1, 1)
                local ang = math.acos(dot)
                if ang > 0.0005 then
                    local stepRad = math.rad(maxDegPerSec) * (dt or (1 / 60))
                    local k = math.min(1, stepRad / ang)
                    local newDir = curDir:Lerp(wantDir, k)
                    if newDir.Magnitude > 0.01 then
                        Camera.CFrame = CFrame.new(camPos, camPos + newDir.Unit)
                    end
                end
            end
            currentAimPoint = finalTargetPos
        else
            lockedTargetPart = nil
            lastTargetPlayer = nil
            _G.__lastAimZone = nil
            currentAimPoint = Camera.CFrame.Position + Camera.CFrame.LookVector * 50
        end
    end

    -- === ФЕЙК-БЕГ ===
    -- Пока персонаж стоит на земле, проигрывается анимация бега.
    -- Анимация локальная: на экране видно, другим игрокам — нет,
    -- так как клиентская анимация не реплицируется на сервер.
    if _G.aaFakeRun ~= nil and fakeRunAnimator ~= fakeRunCharAnimator then
        fakeRunTrack = nil
        fakeRunAnimId = nil
        fakeRunCharAnimator = fakeRunAnimator
    end
    local fchar = LocalPlayer.Character
    local fhum = fchar and fchar:FindFirstChildOfClass("Humanoid")
    local fanim = fhum and fhum:FindFirstChildOfClass("Animator")
    fakeRunAnimator = fanim
    if fhum and fanim then
        -- Фейк-бег живёт только внутри анти-аима: выключили анти-аим — бег снимается.
        local wantRun = _G.aaFakeRun and _G.hvhAntiAimEnabled and fhum.Health > 0
            and fhum.MoveDirection.Magnitude < 0.15
            and fhum.FloorMaterial ~= Enum.Material.Air
            and not (fhum.SeatPart ~= nil or fhum.Sit)
        if wantRun then
            local id = (fhum.RigType == Enum.HumanoidRigType.R15)
                and "rbxassetid://507767714" or "rbxassetid://180426354"
            if not fakeRunTrack or fakeRunAnimId ~= id then
                if fakeRunTrack then pcall(function() fakeRunTrack:Stop() end) end
                local anim = Instance.new("Animation")
                anim.AnimationId = id
                fakeRunTrack = fanim:LoadAnimation(anim)
                fakeRunTrack.Looped = true
                fakeRunTrack.Priority = Enum.AnimationPriority.Movement
                fakeRunAnimId = id
            end
            if not fakeRunTrack.IsPlaying then
                pcall(function() fakeRunTrack:Play(0.15) end)
            end
        elseif fakeRunTrack and fakeRunTrack.IsPlaying then
            pcall(function() fakeRunTrack:Stop(0.2) end)
        end
    end

    -- === HVH AIMBOT (МГНОВЕННЫЙ СНАП) ===
    if _G.hvhAimbotEnabled and _G.aimbotMode == "HVH" then
        local target = getHvhTarget()
        if target and target.part then
            local aimPos = target.part.Position
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, aimPos)
            currentAimPoint = aimPos
            lockedTargetPart = target.part
        else
            lockedTargetPart = nil
        end
    end

    -- === HVH: МГНОВЕННЫЙ СНАП В ГОЛОВУ (приоритет камеры) ===
    -- Внутри RenderStepped камеру иногда перезаписывает контроллер Roblox,
    -- поэтому наведение продублировано отдельным биндингом с приоритетом камеры.
    if _G.hvhAimbotEnabled and _G.aimbotMode == "HVH" and not (_G.debugCam and _G.debugCam.active) then
        local hnow = tick()
        if hnow - (hvhSnapPick or 0) > 0.08 or not hvhSnapPart or not hvhSnapPart.Parent then
            local ht = getHvhTarget()
            hvhSnapPart = ht and ht.part or nil
            hvhSnapPick = hnow
        end
        if hvhSnapPart then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, hvhSnapPart.Position)
        end
    end

    -- === TRIGGERBOT (Стреляет по той же цели, что и аимбот) ===
    if _G.triggerbotEnabled then
        local tTarget, tPart = getClosestPlayer()

        if tTarget and tPart and not isPlayerIgnored(tTarget) then
            if not triggerAcquiring or tTarget ~= triggerAcquiredPlayer then
                triggerAcquiring = true
                triggerAcquiredPlayer = tTarget
                triggerAcquireTime = nowMs()
            end

            local tHum = tPart.Parent and tPart.Parent:FindFirstChildOfClass("Humanoid")
            if tHum and tHum.Health > 0 then
                local withinDist = true
                if _G.triggerbotDistanceEnabled then
                    local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    local targetHrp = tPart.Parent and tPart.Parent:FindFirstChild("HumanoidRootPart")
                    local origin = myHrp and myHrp.Position or Camera.CFrame.Position
                    local tPos = targetHrp and targetHrp.Position or tPart.Position
                    if (origin - tPos).Magnitude > _G.triggerbotMaxDist then
                        withinDist = false
                    end
                end

                local wallClear = true
                if _G.triggerbotWallCheck then
                    local myChar = LocalPlayer.Character
                    local tChar = tPart.Parent
                    if myChar and tChar then
                        local rayParams = RaycastParams.new()
                        rayParams.FilterType = Enum.RaycastFilterType.Exclude
                        rayParams.FilterDescendantsInstances = {myChar, tChar}
                        local hit = workspace:Raycast(Camera.CFrame.Position, tPart.Position - Camera.CFrame.Position, rayParams)
                        if hit then wallClear = false end
                    end
                end

                if withinDist and wallClear and (nowMs() - triggerAcquireTime) >= _G.triggerbotDelay then
                    local fireAllowed = true
                    if _G.triggerbotFireRateEnabled and _G.triggerbotFireRate > 0 then
                        if nowMs() < triggerNextFire then fireAllowed = false end
                    end

                    if fireAllowed then
                        fireWeapon(tPart)
                        if _G.triggerbotFireRateEnabled and _G.triggerbotFireRate > 0 then
                            triggerNextFire = nowMs() + (1000 / _G.triggerbotFireRate)
                        end
                    end
                end
            end
        else
            triggerAcquiring = false
            triggerAcquiredPlayer = nil
            triggerAcquireTime = 0
        end
    end

    if not (_G.debugCam and _G.debugCam.active) and _G.bhopEnabled and UserInputService:IsKeyDown(Enum.KeyCode.Space) and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        if LocalPlayer.Character.Humanoid.FloorMaterial ~= Enum.Material.Air then
            LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- === HVH: камера поверх движка ===
-- Даже если Roblox перезапишет камеру в этом кадре, биндинг с приоритетом
-- камеры поставит взгляд на голову цели последним.
pcall(function()
    RunService:UnbindFromRenderStep("ImpulseHvhSnap")
end)
RunService:BindToRenderStep("ImpulseHvhSnap", Enum.RenderPriority.Camera.Value + 1, function()
    if not (_G.hvhAimbotEnabled and _G.aimbotMode == "HVH") then return end
    if _G.debugCam and _G.debugCam.active then return end
    if hvhSnapPart and hvhSnapPart.Parent then
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, hvhSnapPart.Position)
    end
end)

-- === AIM AUTOSTOP ===
local autoStopApplied = false
local autoStopOriginalSpeed = nil

RunService.Stepped:Connect(function()
    pcall(function()
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end

        local aimActive = (_G.aimbotEnabled and _G.aimbotMode == "Legit")
                      or (_G.hvhAimbotEnabled and _G.aimbotMode == "HVH")
        local hasTarget = aimActive and lockedTargetPart ~= nil
                              and (lockedTargetPart.Parent ~= nil or lockedTargetPart.Position ~= nil)

        if _G.aimAutoStopEnabled and hasTarget then
            if not autoStopApplied then
                autoStopOriginalSpeed = hum.WalkSpeed
                autoStopApplied = true
            end
            local base = (_G.SpeedHackEnabled and _G.SpeedValue) or (autoStopOriginalSpeed or 16)
            local factor = 1 - math.clamp(_G.aimAutoStopStrength / 100, 0, 1)
            hum.WalkSpeed = math.max(base * factor, 0.1)
        elseif autoStopApplied then
            local restore = (_G.SpeedHackEnabled and _G.SpeedValue) or (autoStopOriginalSpeed or 16)
            hum.WalkSpeed = restore
            autoStopApplied = false
            autoStopOriginalSpeed = nil
        end
    end)
end)

-- === HVH ANTI-AIM LOGIC (YAW/MAIN = ТЕЛО, PITCH = ГОЛОВА) ===
local hvhNeckJoint = nil
local originalAutoRotate = true
-- Спин-счётчик в радианах (накапливается только при Spin)
local hvhSpinAngle = 0
-- Сглаженный yaw тела без джиттера (чтобы дрожь не «зацикливалась»).
local aaSmoothYaw = nil
-- Краткий плавный возврат тела к камере после выключения анти-аима/под-функций,
-- чтобы тело не «застывало» повёрнутым в сторону.
aaReturning = false
aaReturnT = 0
aaWasActive = false
function aaReturnToCamera(hrp, dt)
    local lookV = hrp.CFrame.LookVector
    local curY = math.atan2(-lookV.X, -lookV.Z)
    local cLook = Camera.CFrame.LookVector
    local camY = math.atan2(-cLook.X, -cLook.Z)
    local dd = ((camY - curY) + math.pi) % (math.pi * 2) - math.pi
    local spd = math.clamp((dt or (1/60)) * (0.7 / 0.1), 0, 1)
    hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, curY + dd * spd, 0)
end
-- Одноразовый плавный возврат при переходе «анти-аим активен → выключен».
function aaInactiveReturn(hrp, dt)
    if aaWasActive then
        aaWasActive = false
        aaReturning = true
        aaReturnT = 0
    end
    if aaReturning then
        aaReturnT = aaReturnT + (dt or (1/60))
        if aaReturnT <= 0.45 then
            aaReturnToCamera(hrp, dt)
        else
            aaReturning = false
        end
    end
end
local function aaSign(x) return (x < 0 and -1) or (x > 0 and 1) or 0 end

local function getHvhNeck()
    local char = LocalPlayer.Character
    if not char then return nil end
    local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
    if torso then
        local neck = torso:FindFirstChild("Neck") or torso:FindFirstChild("NeckJoint")
        if neck and neck:IsA("Motor6D") then return neck end
    end
    return nil
end

-- Сустав, которым торс крепится к HumanoidRootPart.
-- R15: LowerTorso.Root; R6: HipJoint (на Torso). Нужен, чтобы при пиче
-- прижимать корпус к HRP — тогда физика не выпрямляет тело обратно.
local pitchRootJoint = nil
local function getPitchRoot()
    local char = LocalPlayer.Character
    if not char then return nil end
    local lower = char:FindFirstChild("LowerTorso")
    if lower then
        local r = lower:FindFirstChild("Root")
        if r and r:IsA("Motor6D") then return r end
    end
    local torso = char:FindFirstChild("Torso")
    if torso then
        local hj = torso:FindFirstChild("HipJoint")
        if hj and hj:IsA("Motor6D") then return hj end
    end
    return nil
end

-- База тела: горизонтальная проекция направления камеры (без наклона вверх/вниз),
-- чтобы тело всегда смотрело по взгляду игрока, а не "замерзало" в одной точке.
local function camBaseCFrame(hrp)
    local camLook = Camera.CFrame.LookVector
    local flat = Vector3.new(camLook.X, 0, camLook.Z)
    if flat.Magnitude < 0.001 then flat = Vector3.new(0, 0, -1) end
    return CFrame.lookAt(hrp.Position, hrp.Position + flat, Vector3.new(0, 1, 0))
end

-- Применяет только сдвиг yaw вокруг вертикали от данной базы.
local function yawedCFrame(camLookWorldUp, yawRad)
    local upright = CFrame.new(camLookWorldUp.Position, camLookWorldUp.Position + camLookWorldUp.LookVector, Vector3.new(0, 1, 0))
    return upright * CFrame.Angles(0, yawRad, 0)
end

-- Плашка-предупреждение: анти-аим включён (видна и в Legit).
AimWarning = Instance.new("TextLabel", ScreenGui)
AimWarning.Name = "AntiAimWarning"
AimWarning.AnchorPoint = Vector2.new(1, 0)
AimWarning.Position = UDim2.new(1, -12, 0, 48)
AimWarning.Size = UDim2.new(0, 230, 0, 28)
AimWarning.BackgroundColor3 = Color3.fromRGB(60, 10, 10)
AimWarning.BackgroundTransparency = 0.15
AimWarning.Text = localization[currentLanguage].antiAimWarning or "ANTI-AIM"
AimWarning.TextColor3 = Color3.fromRGB(255, 90, 90)
AimWarning.TextSize = 12
AimWarning.Font = Enum.Font.GothamBold
AimWarning.Visible = false
AimWarning.ZIndex = 900
Instance.new("UICorner", AimWarning).CornerRadius = UDim.new(0, 6)

-- Ватермарка справа: при включении анти-аима отъезжает и горит красным.
Watermark = Instance.new("TextLabel", ScreenGui)
Watermark.Name = "Watermark"
Watermark.AnchorPoint = Vector2.new(1, 0)
Watermark.Position = UDim2.new(1, -12, 0, 12)
Watermark.Size = UDim2.new(0, 220, 0, 28)
Watermark.BackgroundColor3 = Color3.fromRGB(10, 20, 12)
Watermark.BackgroundTransparency = 0.2
Watermark.Text = "IMPULSE V2"
Watermark.TextColor3 = Theme.GreenBright
Watermark.TextSize = 12
Watermark.Font = Enum.Font.GothamBold
Watermark.ZIndex = 899
Instance.new("UICorner", Watermark).CornerRadius = UDim.new(0, 6)

-- === СТРЕЛКИ ВОКРУГ ПРИЦЕЛА ===

RunService.RenderStepped:Connect(function(dt)
    pcall(function()
        if AimWarning then
            AimWarning.Visible = _G.hvhAntiAimEnabled and true or false
            AimWarning.Text = localization[currentLanguage].antiAimWarning or "ANTI-AIM"
        end
        if Watermark then
            -- Водяной знак всегда один и на своём месте; анти-аим показывается
            -- отдельной плашкой под ним, чтобы элементы не накладывались.
            Watermark.Text = "IMPULSE V2"
            Watermark.Position = UDim2.new(1, -12, 0, 12)
            Watermark.BackgroundColor3 = Color3.fromRGB(10, 20, 12)
            Watermark.TextColor3 = Theme.GreenBright
        end
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end

        local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
        if not hvhNeckJoint or hvhNeckJoint.Parent ~= torso then
            hvhNeckJoint = getHvhNeck()
            if hvhNeckJoint and not hvhNeckJoint:GetAttribute("OriginalC0") then
                hvhNeckJoint:SetAttribute("OriginalC0", hvhNeckJoint.C0)
            end
        end

        -- Корневой сустав торса — для пича корпуса целиком.
        if not pitchRootJoint or pitchRootJoint.Parent == nil then
            pitchRootJoint = getPitchRoot()
            if pitchRootJoint and not pitchRootJoint:GetAttribute("OrigC0") then
                pitchRootJoint:SetAttribute("OrigC0", pitchRootJoint.C0)
            end
        end

        -- Общий нейтральный вид (тело по камере, голова прямо)
        local neutralCF = camBaseCFrame(hrp)

        -- В транспорте (сиденье) тело НЕ трогаем — иначе вместе с камерой поворачивалась
        -- бы машина. Анти-аим в транспорте не применяем.
        if hum.SeatPart ~= nil or hum.Sit then
            if hum.AutoRotate == false and originalAutoRotate then
                hum.AutoRotate = true
            end
            hvhSpinAngle = 0
            aaSmoothYaw = nil
            _G.__aaCurTilt = 0
            _G.__aaCurPitch = 0
            if hvhNeckJoint and hvhNeckJoint:GetAttribute("OriginalC0") then
                hvhNeckJoint.C0 = hvhNeckJoint:GetAttribute("OriginalC0")
            end
            if pitchRootJoint and pitchRootJoint:GetAttribute("OrigC0") then
                pitchRootJoint.C0 = pitchRootJoint:GetAttribute("OrigC0")
            end
            return
        end

        if not _G.hvhAntiAimEnabled then
            -- Пока анти-аим выключен, тело и суставы не трогаем: возврат к камере
            -- делает сам Roblox через AutoRotate. Один раз восстанавливаем исходные
            -- суставы после выключения, и больше ничего не делаем.
            if aaWasActive then
                aaWasActive = false
                hvhSpinAngle = 0
                aaSmoothYaw = nil
                _G.__aaCurTilt = 0
                _G.__aaCurPitch = 0
                if hvhNeckJoint and hvhNeckJoint:GetAttribute("OriginalC0") then
                    hvhNeckJoint.C0 = hvhNeckJoint:GetAttribute("OriginalC0")
                end
                if pitchRootJoint and pitchRootJoint:GetAttribute("OrigC0") then
                    pitchRootJoint.C0 = pitchRootJoint:GetAttribute("OrigC0")
                end
                if hum.AutoRotate == false and originalAutoRotate then
                    hum.AutoRotate = true
                end
            end
            return
        end
        aaWasActive = true

        -- Жёсткая гарантия: Main выключен — Spin/Jitter не могут быть активны.
        if not _G.aaUiMain then
            if _G.aaSpinEnabled then
                _G.aaSpinEnabled = false
                pcall(function() setToggleVisual("aaSpinEnabled", false) end)
            end
            if _G.aaJitterEnabled then
                _G.aaJitterEnabled = false
                pcall(function() setToggleVisual("aaJitterEnabled", false) end)
            end
        end

        -- Тело трогаем только если включена Yaw- или Main-ось.
        local yawActive = _G.aaUiYaw or _G.aaUiMain
        local pitchActive = _G.aaUiPitch

        local isShooting = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
        local bypassShoot = _G.aaBypassEnabled and isShooting
        if bypassShoot then
            -- Bypass по ЛКМ: тело и голова по камере, взгляд в цель.
            hrp.CFrame = neutralCF
            if hvhNeckJoint and hvhNeckJoint:GetAttribute("OriginalC0") then
                hvhNeckJoint.C0 = hvhNeckJoint:GetAttribute("OriginalC0")
            end
            if lockedTargetPart and lockedTargetPart.Parent then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, lockedTargetPart.Position)
            end
            return
        end

        -- Если выключены ВСЕ три функции (Yaw, Pitch, Main) — антиаим не делает ничего.
        local anySubActive = _G.aaUiYaw or _G.aaUiPitch or _G.aaUiMain
        if not anySubActive then
            if hum.AutoRotate == false and originalAutoRotate then
                hum.AutoRotate = true
            end
            hvhSpinAngle = 0
            aaSmoothYaw = nil
            _G.__aaCurTilt = 0
            _G.__aaCurPitch = 0
            if hvhNeckJoint and hvhNeckJoint:GetAttribute("OriginalC0") then
                hvhNeckJoint.C0 = hvhNeckJoint:GetAttribute("OriginalC0")
            end
            if pitchRootJoint and pitchRootJoint:GetAttribute("OrigC0") then
                pitchRootJoint.C0 = pitchRootJoint:GetAttribute("OrigC0")
            end
            aaInactiveReturn(hrp, dt)
            return
        end

        -- AutoRotate выключаем только когда реально крутим тело (Yaw/Main).
        if yawActive then
            if hum.AutoRotate then
                originalAutoRotate = true
                hum.AutoRotate = false
            end
        else
            if hum.AutoRotate == false and originalAutoRotate then
                hum.AutoRotate = true
            end
            aaSmoothYaw = nil
            aaInactiveReturn(hrp, dt)
        end

        -- --- Общая ось Yaw (направление + Spin + Jitter) ---
        local totalYaw = 0
        if yawActive then
            if _G.aaUiYaw and _G.aaYaw ~= "Off" then
                if _G.aaYaw == "Back" then totalYaw = totalYaw + math.rad(180)
                elseif _G.aaYaw == "Left" then totalYaw = totalYaw + math.rad(90)
                elseif _G.aaYaw == "Right" then totalYaw = totalYaw - math.rad(90)
                end
            end

            if _G.aaUiMain then
                if _G.aaSpinEnabled then
                    hvhSpinAngle = hvhSpinAngle + math.rad((_G.aaSpinSpeed or 30) * dt * 12)
                else
                    -- Спин выключили — плавно гасим угол, чтобы тело не застыло.
                    local k = math.min(1, (dt or (1/60)) * 8)
                    hvhSpinAngle = hvhSpinAngle * (1 - k)
                    if math.abs(hvhSpinAngle) < 0.01 then hvhSpinAngle = 0 end
                end
                totalYaw = totalYaw + hvhSpinAngle
            else
                hvhSpinAngle = 0
            end
        else
            hvhSpinAngle = 0
        end

        -- Дрожь добавляем ПОСЛЕ сглаживания, иначе сглаживатель её «съедает».
        local jitterYaw = 0
        if yawActive and _G.aaUiMain and _G.aaJitterEnabled then
            jitterYaw = math.rad(math.sin(tick() * (_G.aaJitterSpeed or 8) * math.pi * 2) * (_G.aaJitterStrength or 0))
        end

        -- ---------- YAW: плавный поворот тела только вокруг вертикали ----------
        if yawActive then
            if aaSmoothYaw == nil then
                local look0 = hrp.CFrame.LookVector
                aaSmoothYaw = math.atan2(-look0.X, -look0.Z)
            end
            local camLook = Camera.CFrame.LookVector
            local camYaw = math.atan2(-camLook.X, -camLook.Z)
            local desiredYaw = camYaw + totalYaw

            local diff = desiredYaw - aaSmoothYaw
            diff = (diff + math.pi) % (math.pi * 2) - math.pi

            local turnSpeed = math.clamp((dt or (1/60)) * (0.7 / 0.1), 0, 1)
            aaSmoothYaw = aaSmoothYaw + diff * turnSpeed

            aaReturning = false
            aaWasActive = true
            hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, aaSmoothYaw + jitterYaw, 0)
        end

        -- ---------- PITCH: наклон ТОЛЬКО головы (через шею) ----------
        if _G.__aaCurPitch == nil then _G.__aaCurPitch = 0 end

        local desiredPitchRad = 0
        if pitchActive and _G.aaPitch ~= "Off" then
            if _G.aaPitch == "Down" then desiredPitchRad = math.rad(90)
            elseif _G.aaPitch == "Up" then desiredPitchRad = math.rad(-90)
            end
        end
        desiredPitchRad = math.clamp(desiredPitchRad, -math.rad(80), math.rad(80))

        local pitchSpeed = math.clamp((dt or (1/60)) * (0.7 / 0.1), 0, 1)
        _G.__aaCurPitch = _G.__aaCurPitch + (desiredPitchRad - _G.__aaCurPitch) * pitchSpeed

        if hvhNeckJoint and hvhNeckJoint:GetAttribute("OriginalC0") then
            local origC0 = hvhNeckJoint:GetAttribute("OriginalC0")
            -- У R6 Neck.C0 развёрнут на 180°, знак наклона инвертирован.
            local pitchSign = (origC0.RightVector.X >= 0) and -1 or 1
            hvhNeckJoint.C0 = origC0 * CFrame.Angles(pitchSign * _G.__aaCurPitch, 0, 0)
        end

        -- Корневой сустав торса всегда в исходном — тело не наклоняем.
        if pitchRootJoint and pitchRootJoint:GetAttribute("OrigC0") then
            pitchRootJoint.C0 = pitchRootJoint:GetAttribute("OrigC0")
        end
    end)
end)

-- === FULLBRIGHT (ИСПРАВЛЕНО) ===
local savedLighting = {}
local savedAtmosphere = {}
local fullbrightActive = false

local function saveLighting()
    if next(savedLighting) then return end
    savedLighting.Brightness = Lighting.Brightness
    savedLighting.ClockTime = Lighting.ClockTime
    savedLighting.Ambient = Lighting.Ambient
    savedLighting.OutdoorAmbient = Lighting.OutdoorAmbient
    savedLighting.GlobalShadows = Lighting.GlobalShadows
    savedLighting.ExposureCompensation = Lighting.ExposureCompensation
    
    for _, child in ipairs(Lighting:GetChildren()) do
        if child:IsA("Atmosphere") then
            savedAtmosphere[child] = {
                Density = child.Density,
                Haze = child.Haze,
                Offset = child.Offset,
                Color = child.Color,
                Decay = child.Decay
            }
        end
    end
end

-- Установка значений без сохранения: вызывается каждые 0.1 с, пока свет включён.
-- Игра и сторонние скрипты периодически возвращают свои значения Lighting,
-- поэтому одного применения при включении мало.
local function enforceFullbright()
    Lighting.Brightness = 2
    Lighting.ClockTime = 14
    Lighting.Ambient = Color3.fromRGB(150, 150, 150)
    Lighting.OutdoorAmbient = Color3.fromRGB(150, 150, 150)
    Lighting.GlobalShadows = false
    Lighting.ExposureCompensation = 0

    for _, child in ipairs(Lighting:GetChildren()) do
        if child:IsA("Atmosphere") then
            child.Density = 0
            child.Haze = 0
            child.Offset = 0
        end
    end
end

local function applyFullbright()
    saveLighting()
    enforceFullbright()
end

local function disableFullbright()
    for k, v in pairs(savedLighting) do
        pcall(function() Lighting[k] = v end)
    end
    savedLighting = {}
    
    for obj, data in pairs(savedAtmosphere) do
        if obj and obj.Parent then
            obj.Density = data.Density
            obj.Haze = data.Haze
            obj.Offset = data.Offset
            obj.Color = data.Color
            obj.Decay = data.Decay
        end
    end
    savedAtmosphere = {}
end

task.spawn(function()
    while task.wait(0.1) do
        if _G.fullbrightEnabled then
            if not fullbrightActive then
                fullbrightActive = true
                applyFullbright()
            else
                -- Держим свет всё время, пока функция включена.
                enforceFullbright()
            end
        elseif fullbrightActive then
            fullbrightActive = false
            disableFullbright()
        end
    end
end)

-- === ТРЕТЬЕ ЛИЦО ===
-- Собственное смещение камеры: работает и там, где игра разрешает только первый вид,
-- потому что мы не просим игру переключить вид, а сами отодвигаем камеру назад
-- вдоль её же направления взгляда (после обновления камеры игрой).
local tpActive = false
local tpRayParams = RaycastParams.new()
tpRayParams.FilterType = Enum.RaycastFilterType.Exclude

local function tpUpdate()
    if not _G.worldThirdPerson then
        if tpActive then
            tpActive = false
            local char = LocalPlayer and LocalPlayer.Character
            if char then
                for _, obj in ipairs(char:GetDescendants()) do
                    if obj:IsA("BasePart") and obj.LocalTransparencyModifier ~= 0 then
                        obj.LocalTransparencyModifier = 0
                    end
                end
            end
        end
        return
    end

    local cam = workspace.CurrentCamera
    local char = LocalPlayer and LocalPlayer.Character
    local head = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Head"))
    if not cam or not head then return end
    if head.Parent ~= char then head = char:FindFirstChild("HumanoidRootPart") or head end
    if not head or not head.Parent then return end

    tpActive = true
    local dist = tonumber(_G.worldThirdPersonDist) or 12
    local look = cam.CFrame.LookVector
    local origin = head.Position + Vector3.new(0, 1.2, 0)
    local back = -look

    tpRayParams.FilterDescendantsInstances = { char }
    local hit = workspace:Raycast(origin, back * (dist + 0.8), tpRayParams)
    local final = dist
    if hit then
        final = math.max(1.2, (hit.Position - origin).Magnitude - 0.4)
    end

    cam.CFrame = CFrame.lookAt(origin + back * final, origin)

    -- В играх с жёстким первым видом персонаж скрыт: показываем его обратно.
    for _, obj in ipairs(char:GetDescendants()) do
        if obj:IsA("BasePart") and obj.LocalTransparencyModifier ~= 0 then
            obj.LocalTransparencyModifier = 0
        end
    end
end

pcall(function()
    RunService:UnbindFromRenderStep("ImpulseThirdPerson")
    RunService:BindToRenderStep("ImpulseThirdPerson", Enum.RenderPriority.Last.Value - 1, tpUpdate)
end)

-- Небо ставится раз в 0.5 с: этого хватает, и загрузка текстур не сбивается.
task.spawn(function()
    local applied = false
    while task.wait(0.5) do
        local index = math.clamp(tonumber(_G.skyboxIndex) or 1, 1, #SKYBOX_PRESETS)
        local want = _G.skyboxEnabled and index > 1
        if want then
            pcall(skyboxApply)
            applied = true
        elseif applied then
            pcall(skyboxApply, true)
            applied = false
        end
        if skyboxRefreshVisuals then pcall(skyboxRefreshVisuals) end
    end
end)

-- === DEBUG-КАМЕРА (только камера, персонаж НЕ трогается) ===
-- Отделяет камеру от персонажа и позволяет свободно осматривать мир (мышь + WASD,
-- пробел вверх, Ctrl вниз). Тело остаётся полностью видимым и управляемым.
_G.debugCam = {
    active = false,
    yaw = 0, pitch = 0,
    camCFrame = nil,
    savedCameraMode = nil,
    savedCameraType = nil,
    savedCameraSubject = nil,
    savedMouseBehavior = nil,
    -- Для «заморозки» персонажа, пока камера активна (чтобы он не прыгал/не шёл).
    frozenHum = nil,
    savedHumProps = nil,
    -- Поворот тела, зафиксированный на момент включения (чтобы тело не крутилось).
    fixedBodyYaw = 0,
    -- Плавный возврат камеры к персонажу при выключении (чтобы античит не видел телепорт).
    returning = false,
    returnStart = nil,
    returnTarget = nil,
    returnT = 0,
    returnDuration = 0.7,
    -- Камера игры на момент включения — цель плавного возврата (нулевой скачок в конце).
    savedGameCamCFrame = nil,
}
local debugCam = _G.debugCam

-- «Замораживает» персонажа: отключает ходьбу и прыжок, он остаётся видимым на месте.
local function freezeCharacterForDebugCam()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    debugCam.frozenHum = hum
    debugCam.savedHumProps = {
        WalkSpeed = hum.WalkSpeed,
        JumpPower = hum.JumpPower,
        JumpHeight = hum.JumpHeight,
        AutoRotate = hum.AutoRotate,
    }
    hum.WalkSpeed = 0
    hum.JumpPower = 0
    hum.JumpHeight = 0
    -- Отключаем авто-поворот: тело не крутится за камерой/мышью, пока камера активна.
    hum.AutoRotate = false
end

local function unfreezeCharacterForDebugCam()
    local hum = debugCam.frozenHum
    if hum and hum.Parent then
        pcall(function()
            if debugCam.savedHumProps then
                hum.WalkSpeed = debugCam.savedHumProps.WalkSpeed or 16
                hum.JumpPower = debugCam.savedHumProps.JumpPower or 50
                hum.JumpHeight = debugCam.savedHumProps.JumpHeight or 7.2
                hum.AutoRotate = debugCam.savedHumProps.AutoRotate ~= false
            end
        end)
    end
    debugCam.frozenHum = nil
    debugCam.savedHumProps = nil
end

-- Финальное отключение: снять биндинг, вернуть камеру/курсор и разморозить персонажа.
-- Вызывается только ПОСЛЕ плавного возврата камеры (или принудительно — при респавне).
local function finalizeDebugCamStop()
    pcall(function() RunService:UnbindFromRenderStep("DebugCamOverride") end)

    pcall(function()
        if debugCam.savedCameraMode then LocalPlayer.CameraMode = debugCam.savedCameraMode end
        if debugCam.savedCameraSubject then Camera.CameraSubject = debugCam.savedCameraSubject end
        Camera.CameraType = debugCam.savedCameraType or Enum.CameraType.Custom
        if debugCam.savedMouseBehavior then
            UserInputService.MouseBehavior = debugCam.savedMouseBehavior
        end
    end)

    debugCam.camCFrame = nil
    debugCam.returnStart = nil
    debugCam.returnTarget = nil
    debugCam.returnT = 0
    debugCam.returning = false
    debugCam.savedGameCamCFrame = nil
    -- Возвращаем персонажу способность ходить и прыгать.
    unfreezeCharacterForDebugCam()
end

local function debugCamStart()
    if debugCam.active or debugCam.returning then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hrp0 = char:FindFirstChild("HumanoidRootPart")

    -- Замораживаем персонажа, чтобы клавиши не управляли телом (только камерой).
    freezeCharacterForDebugCam()

    -- Фиксируем поворот тела на момент включения (чтобы оно не крутилось за камерой).
    if hrp0 then
        local lv = hrp0.CFrame.LookVector
        debugCam.fixedBodyYaw = math.atan2(-lv.X, -lv.Z)
    else
        debugCam.fixedBodyYaw = 0
    end

    -- СОХРАНЯЕМ состояние до включения — персонажа не трогаем, только камеру.
    debugCam.savedCameraMode = LocalPlayer.CameraMode
    debugCam.savedCameraType = Camera.CameraType
    debugCam.savedCameraSubject = Camera.CameraSubject
    -- Мышь: без захвата GetMouseDelta() всегда возвращает (0,0), поэтому камера
    -- не вращается. Захватываем курсор в центр — так работает обзор мышью.
    debugCam.savedMouseBehavior = UserInputService.MouseBehavior
    UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter

    -- Стартовая позиция — текущая камера, выдергиваем из неё yaw/pitch.
    local startCF = Camera.CFrame
    debugCam.camCFrame = startCF
    -- Запоминаем «родную» камеру игры: к ней плавно вернёмся и в неё же передадим
    -- управление — поэтому в конце не будет скачка (персонаж заморожен, камера не едет).
    debugCam.savedGameCamCFrame = startCF
    local look = startCF.LookVector
    debugCam.yaw = math.atan2(-look.X, -look.Z)
    debugCam.pitch = math.asin(math.clamp(look.Y, -1, 1))

    Camera.CameraType = Enum.CameraType.Scriptable
    debugCam.active = true

    RunService:BindToRenderStep("DebugCamOverride", Enum.RenderPriority.Camera.Value, function(dt)
        local ok = pcall(function()
        -- Режим плавного возврата: камера мягко едет к персонажу, тело не двигается.
        if debugCam.returning then
            debugCam.returnT = debugCam.returnT + math.max(dt, 0)
            local a = math.clamp(debugCam.returnT / (debugCam.returnDuration or 0.7), 0, 1)
            -- smoothstep — плавный «доезд» без рывков.
            local alpha = a * a * (3 - 2 * a)
            if debugCam.returnStart and debugCam.returnTarget then
                Camera.CFrame = debugCam.returnStart:Lerp(debugCam.returnTarget, alpha)
            end
            -- Тело всё ещё держим на месте, пока камера едет обратно (без вращения).
            local curHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if curHrp then
                curHrp.CFrame = CFrame.new(curHrp.Position) * CFrame.Angles(0, debugCam.fixedBodyYaw, 0)
                curHrp.AssemblyLinearVelocity = Vector3.zero
                curHrp.AssemblyAngularVelocity = Vector3.zero
            end
            if a >= 1 or debugCam.returnT >= (debugCam.returnDuration or 0.7) + 1 then
                debugCam.returning = false
                finalizeDebugCamStop()
            end
            return
        end

        if not debugCam.active then return end

        -- Мышь — обзор (с захваченным курсором GetMouseDelta() возвращает реальное движение).
        local mouseDelta = UserInputService:GetMouseDelta()
        local sens = (_G.debugCamSensitivity or 30) / 100
        debugCam.yaw = debugCam.yaw - mouseDelta.X * sens * 0.01
        debugCam.pitch = math.clamp(
            debugCam.pitch - mouseDelta.Y * sens * 0.01,
            -math.pi / 2 + 0.05, math.pi / 2 - 0.05
        )

        -- WASD — движение, пробел вверх, Ctrl вниз.
        local speed = (_G.debugCamSpeed or 2) * 16
        local move = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + Vector3.new(0, 0, -1) end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move + Vector3.new(0, 0, 1) end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move + Vector3.new(-1, 0, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + Vector3.new(1, 0, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl) then move = move + Vector3.new(0, -1, 0) end

        local pos = debugCam.camCFrame.Position
        if move.Magnitude > 0 then
            local rot = CFrame.Angles(0, debugCam.yaw, 0) * CFrame.Angles(debugCam.pitch, 0, 0)
            pos = pos + rot:VectorToWorldSpace(move.Unit) * speed * dt
        end

        debugCam.camCFrame = CFrame.new(pos) * CFrame.Angles(0, debugCam.yaw, 0) * CFrame.Angles(debugCam.pitch, 0, 0)
        Camera.CFrame = debugCam.camCFrame

        -- Принудительно удерживаем тело на месте и без вращения (фиксируем поворот).
        local curHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if curHrp then
            curHrp.CFrame = CFrame.new(curHrp.Position) * CFrame.Angles(0, debugCam.fixedBodyYaw, 0)
            curHrp.AssemblyLinearVelocity = Vector3.zero
            curHrp.AssemblyAngularVelocity = Vector3.zero
        end
        end)
        -- Если кадр упал с ошибкой во время возврата — жёстко финализируем, чтобы не зависнуть.
        if not ok and debugCam.returning then
            debugCam.returning = false
            pcall(finalizeDebugCamStop)
        end
    end)
end

local function debugCamStop()
    -- Если уже идёт плавный возврат — просто доводим его до конца.
    if debugCam.returning then
        finalizeDebugCamStop()
        return
    end
    if not debugCam.active then return end

    -- НЕ выключаем мгновенно: запускаем плавный «доезд» камеры к персонажу.
    -- Цель — «родная» камера игры на момент включения: плавно возвращаемся ровно в тот
    -- же вид и наклон, что были у игрока, и только потом передаём управление обратно.
    local target
    if debugCam.savedGameCamCFrame then
        target = debugCam.savedGameCamCFrame
    else
        local char = LocalPlayer.Character
        local head = char and (char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart"))
        if head then
            target = CFrame.new(head.Position) * CFrame.Angles(0, debugCam.yaw, 0) * CFrame.Angles(debugCam.pitch, 0, 0)
        else
            target = debugCam.camCFrame or Camera.CFrame
        end
    end

    debugCam.active = false
    debugCam.returning = true
    debugCam.returnT = 0
    debugCam.returnStart = debugCam.camCFrame or Camera.CFrame
    debugCam.returnTarget = target
    -- Камеру оставляем Scriptable — плавный возврат делается в том же RenderStep.
end

local function debugCamToggle()
    if debugCam.active then debugCamStop() else debugCamStart() end
end

task.spawn(function()
    while true do
        task.wait(0.1)
        pcall(function()
            if _G.debugCamEnabled and not debugCam.active then debugCamStart()
            elseif not _G.debugCamEnabled and debugCam.active then debugCamStop() end
        end)
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    -- Респавн: жёстко отключаем камеру (плавный возврат бессмыслен — тело новое).
    if debugCam.active or debugCam.returning then
        finalizeDebugCamStop()
    end
end)

-- === INVISIBLE ===
local invisibleApplied = false
local selfSkeletonLines = {}
local drawingSupported = pcall(function() return Drawing.new("Line") end)
local hiddenAccessories = {}

local function applyInvisible()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
        hum.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
    end
    for _, acc in ipairs(char:GetChildren()) do
        if acc:IsA("Accessory") then
            hiddenAccessories[acc] = acc.Parent
            acc.Parent = nil
        end
    end
    for _, obj in ipairs(char:GetDescendants()) do
        if obj:IsA("BasePart") then
            obj.Transparency = 1
            obj.CanCollide = false
            obj.LocalTransparencyModifier = 0.5
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            obj.Transparency = 1
        end
    end
end

local function removeInvisible()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer
        hum.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOn
    end
    for acc, parent in pairs(hiddenAccessories) do
        if parent then acc.Parent = parent end
    end
    hiddenAccessories = {}
    for _, obj in ipairs(char:GetDescendants()) do
        if obj:IsA("BasePart") then
            obj.Transparency = 0
            obj.CanCollide = true
            obj.LocalTransparencyModifier = 0
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            obj.Transparency = 0
        end
    end
    for _, line in ipairs(selfSkeletonLines) do line.Visible = false end
end

RunService.RenderStepped:Connect(function()
    if not drawingSupported then return end
    pcall(function()
        if not _G.invisibleEnabled then
            for _, line in ipairs(selfSkeletonLines) do line.Visible = false end
            return
        end
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        local isR15 = char:FindFirstChild("UpperTorso") ~= nil
        local connections = isR15 and boneConnections or {
            {"Head", "Torso"}, {"Torso", "Left Arm"}, {"Torso", "Right Arm"},
            {"Torso", "Left Leg"}, {"Torso", "Right Leg"}, {"Torso", "HumanoidRootPart"}
        }
        local idx = 1
        for _, conn in ipairs(connections) do
            local p1, p2 = char:FindFirstChild(conn[1]), char:FindFirstChild(conn[2])
            if p1 and p2 then
                local s1, o1 = Camera:WorldToViewportPoint(p1.Position)
                local s2, o2 = Camera:WorldToViewportPoint(p2.Position)
                if o1 and o2 then
                    local line = selfSkeletonLines[idx]
                    if not line then line = Drawing.new("Line") selfSkeletonLines[idx] = line end
                    line.Visible = true
                    line.From = Vector2.new(s1.X, s1.Y)
                    line.To = Vector2.new(s2.X, s2.Y)
                    line.Color = Theme.GreenBright
                    line.Thickness = 2
                    idx = idx + 1
                end
            end
        end
        for i = idx, #selfSkeletonLines do selfSkeletonLines[i].Visible = false end
    end)
end)

RunService.Stepped:Connect(function()
    pcall(function()
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then return end
        if _G.invisibleEnabled then
            applyInvisible()
            invisibleApplied = true
        elseif invisibleApplied then
            removeInvisible()
            invisibleApplied = false
        end
    end)
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    if _G.invisibleEnabled then task.wait(0.3) applyInvisible() end
end)

-- === АНТИ-ОТДАЧА (ЗАМОРАЖИВАНИЕ ПРИЦЕЛА) ===
-- Пока ЛКМ зажата и мышь не двигается, прицел удерживается в точке первого
-- выстрела: рывки камеры (отдача) откатываются. Двигаешь мышь — антиотдача
-- не мешает и запоминает новое направление.
local recoil = {
    pinnedPitch = nil, pinnedYaw = nil, lmbHeld = false,
}

local function camYawOf(cf)
    local lv = cf.LookVector
    return math.atan2(-lv.X, -lv.Z)
end

RunService.RenderStepped:Connect(function(dt)
    pcall(function()
        if not _G.antiRecoil then
            recoil.pinnedPitch, recoil.pinnedYaw = nil, nil
            recoil.lmbHeld = false
            return
        end

        -- Аимбот сам ведёт камеру — антиотдачу не вмешиваем.
        local aimDriving = ((_G.aimbotEnabled and _G.aimbotMode == "Legit")
            or (_G.hvhAimbotEnabled and _G.aimbotMode == "HVH"))
            and lockedTargetPart ~= nil
        if aimDriving then
            recoil.pinnedPitch, recoil.pinnedYaw = nil, nil
            recoil.lmbHeld = false
            return
        end

        local steering = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
        if not steering then
            recoil.pinnedPitch, recoil.pinnedYaw = nil, nil
            recoil.lmbHeld = false
            return
        end

        local look = Camera.CFrame.LookVector
        local pitch = math.asin(math.clamp(look.Y, -1, 1))
        local yaw = camYawOf(Camera.CFrame)

        if not recoil.lmbHeld then
            recoil.lmbHeld = true
            recoil.pinnedPitch = pitch
            recoil.pinnedYaw = yaw
            return
        end

        -- Если игрок реально двигает мышь — это прицеливание, не отдача.
        local md = UserInputService:GetMouseDelta()
        local manual = md.Magnitude > 0.5
        if manual then
            recoil.pinnedPitch = pitch
            recoil.pinnedYaw = yaw
            return
        end

        -- Мышь стоит: фиксируем прицел (100% = полное гашение отдачи).
        local vFactor = math.clamp((_G.antiRecoilVertical or 100) / 100, 0, 1)
        local hFactor = math.clamp((_G.antiRecoilHorizontal or 100) / 100, 0, 1)
        local newPitch = pitch - (pitch - recoil.pinnedPitch) * vFactor
        local newYaw = yaw - (yaw - recoil.pinnedYaw) * hFactor
        Camera.CFrame = CFrame.new(Camera.CFrame.Position) * CFrame.fromEulerAnglesYXZ(newPitch, newYaw, 0)
    end)
end)

-- === KILLAURA (переработано) ===
lastKillaura = 0
killauraBusy = false

-- Выбирает ближайшую подходящую цель в радиусе (с учётом FOV/союзников/стен).
function kaGetTarget(char, hrp)
    local best, bestPart, bestDist = nil, nil, math.huge
    local camLook = Camera.CFrame.LookVector
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local tHum = plr.Character:FindFirstChildOfClass("Humanoid")
            local tHrp = plr.Character:FindFirstChild("HumanoidRootPart")
            local tHead = plr.Character:FindFirstChild("Head")
            if tHum and tHrp and tHum.Health > 0 then
                local dist = (tHrp.Position - hrp.Position).Magnitude
                if dist <= _G.killauraRange then
                    local pass = true
                    -- Союзники (только если у обоих есть команда)
                    if _G.killauraTeamCheck and plr.Team and LocalPlayer.Team and plr.Team == LocalPlayer.Team then
                        pass = false
                    end
                    -- Угол обзора относительно камеры
                    if pass and _G.killauraFov < 360 then
                        local toT = tHrp.Position - Camera.CFrame.Position
                        if toT.Magnitude > 0.001 then
                            local ang = math.deg(math.acos(math.clamp(camLook:Dot(toT.Unit), -1, 1)))
                            if ang > _G.killauraFov / 2 then pass = false end
                        end
                    end
                    -- Проверка стен: если включена — бить только при прямой видимости
                    if pass and _G.killauraWallCheck then
                        local params = RaycastParams.new()
                        params.FilterType = Enum.RaycastFilterType.Exclude
                        params.FilterDescendantsInstances = {char, plr.Character}
                        local hit = workspace:Raycast(Camera.CFrame.Position, tHrp.Position - Camera.CFrame.Position, params)
                        if hit then pass = false end
                    end
                    if pass and dist < bestDist then
                        bestDist = dist
                        best = plr
                        bestPart = tHead or tHrp
                    end
                end
            end
        end
    end
    return best, bestPart
end

RunService.Stepped:Connect(function()
    pcall(function()
        if not _G.killauraEnabled then return end
        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local myHum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not myHum or myHum.Health <= 0 then return end

        local now = tick() * 1000
        if now - lastKillaura < _G.killauraDelay then return end
        if killauraBusy then return end

        local target, targetPart = kaGetTarget(char, hrp)
        if target and targetPart then
            lastKillaura = now
            killauraBusy = true

            -- Опционально разворачиваем тело к цели
            if _G.killauraRotate then
                local p = targetPart.Position
                hrp.CFrame = CFrame.new(hrp.Position, Vector3.new(p.X, hrp.Position.Y, p.Z))
            end

            -- Атака: наводим камеру на цель и жмём ЛКМ (надёжно, как у аимбота).
            task.spawn(function()
                pcall(function() fireWeapon(targetPart) end)
                killauraBusy = false
            end)
        end
    end)
end)

-- === TELEPORT TO MOUSE ===
UserInputService.InputBegan:Connect(function(input, processed)
    if _G.unloaded then return end
    if processed then return end
    if input.KeyCode == Enum.KeyCode.T and _G.tpMouseEnabled then
        pcall(function()
            local char = LocalPlayer.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            local mousePos = UserInputService:GetMouseLocation()
            local ray = Camera:ViewportPointToRay(mousePos.X, mousePos.Y)
            local params = RaycastParams.new()
            params.FilterDescendantsInstances = {char}
            params.FilterType = Enum.RaycastFilterType.Exclude
            local result = workspace:Raycast(ray.Origin, ray.Direction * 1000, params)
            if result and result.Position.Y > -50 then
                hrp.CFrame = CFrame.new(result.Position + Vector3.new(0, 3, 0))
            end
        end)
    end
end)

-- === SPIDER (Лестница) ===
RunService.Stepped:Connect(function()
    pcall(function()
        if not _G.spiderEnabled then return end
        
        local char = LocalPlayer.Character
        if not char then return end
        
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end

        local isMovingForward = UserInputService:IsKeyDown(Enum.KeyCode.W)
        
        local rayParams = RaycastParams.new()
        rayParams.FilterDescendantsInstances = {char}
        rayParams.FilterType = Enum.RaycastFilterType.Exclude
        local result = workspace:Raycast(hrp.Position, hrp.CFrame.LookVector * 4, rayParams)

        if result and result.Normal and math.abs(result.Normal.Y) < 0.5 then
            if isMovingForward or UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                hrp.AssemblyLinearVelocity = Vector3.new(
                    hrp.AssemblyLinearVelocity.X * 0.1,
                    30,
                    hrp.AssemblyLinearVelocity.Z * 0.1
                )
            end
        end
    end)
end)

-- === NO FALL ===
-- Хук метатаблицы убран: он ставился всегда, даже при выключенной функции,
-- и такие хуки первыми замечают античиты. Работает только физический блок ниже.

RunService.Stepped:Connect(function()
    pcall(function()
        if not _G.noFallDamage then return end
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hum or not hrp then return end
        if hum:GetState() == Enum.HumanoidStateType.Freefall and hrp.AssemblyLinearVelocity.Y < -50 then
            hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, -50, hrp.AssemblyLinearVelocity.Z)
        end
    end)
end)

-- === SPEED / WALLPASS / JUMP ===
local wallPassApplied = false
local speedApplied = false

RunService.Stepped:Connect(function()
    pcall(function()
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end

        if _G.SpeedHackEnabled then
            hum.WalkSpeed = _G.SpeedValue
            speedApplied = true
        elseif speedApplied then
            hum.WalkSpeed = 16
            speedApplied = false
        end

        if _G.wallPassEnabled then
            -- Держим проход каждый кадр: невидимость/респавн/игра возвращают CanCollide,
            -- из-за чего проход «сам выключался».
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
            wallPassApplied = true
        elseif wallPassApplied then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.CanCollide = true
                end
            end
            wallPassApplied = false
        end

        if _G.autoStrafeEnabled and hum.FloorMaterial == Enum.Material.Air then
            local md = hum.MoveDirection
            local hrp2 = char:FindFirstChild("HumanoidRootPart")
            if hrp2 and md.Magnitude > 0.05 then
                local sp = 16 + ((_G.autoStrafeStrength or 50) / 100) * 40
                local v = hrp2.AssemblyLinearVelocity
                local t = md.Unit * sp
                hrp2.AssemblyLinearVelocity = Vector3.new(t.X, v.Y, t.Z)
            end
        end
    end)
end)

UserInputService.JumpRequest:Connect(function()
    if _G.infJumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

LocalPlayer.Idled:Connect(function()
    if _G.antiAfkEnabled then
        pcall(function()
            local rand = math.random(1, 3)
            if rand == 1 then
                VirtualUser:Button2Down(Vector2.new(0,0), Camera.CFrame)
                task.wait(0.2)
                VirtualUser:Button2Up(Vector2.new(0,0), Camera.CFrame)
            elseif rand == 2 then
                VirtualUser:Button1Down(Vector2.new(0,0), Camera.CFrame)
                task.wait(0.2)
                VirtualUser:Button1Up(Vector2.new(0,0), Camera.CFrame)
            else
                VirtualUser:Button2Down(Vector2.new(0,0), Camera.CFrame)
                task.wait(0.2)
                VirtualUser:Button2Up(Vector2.new(0,0), Camera.CFrame)
            end
        end)
    end
end)

-- ============================================================
-- RADAR HACK
-- ============================================================
local RadarGui = Instance.new("Frame", ScreenGui)
RadarGui.Name = "RadarGui"
RadarGui.AnchorPoint = Vector2.new(0, 1)
RadarGui.Position = UDim2.new(0, 15, 1, -15)
RadarGui.Size = UDim2.new(0, _G.radarSize, 0, _G.radarSize)
RadarGui.BackgroundColor3 = Color3.fromRGB(8, 12, 8)
RadarGui.BackgroundTransparency = 0.2
RadarGui.BorderSizePixel = 0
RadarGui.Visible = false
RadarGui.ZIndex = 800
Instance.new("UICorner", RadarGui).CornerRadius = UDim.new(1, 0)

local radarStroke = Instance.new("UIStroke", RadarGui)
radarStroke.Color = Theme.Green
radarStroke.Thickness = 2
radarStroke.Transparency = 0.3

local radarCircle = Instance.new("Frame", RadarGui)
radarCircle.Size = UDim2.new(1, -10, 1, -10)
radarCircle.Position = UDim2.new(0, 5, 0, 5)
radarCircle.BackgroundTransparency = 1
radarCircle.ZIndex = 801
Instance.new("UICorner", radarCircle).CornerRadius = UDim.new(1, 0)
local circleStroke = Instance.new("UIStroke", radarCircle)
circleStroke.Color = Theme.Green
circleStroke.Thickness = 1
circleStroke.Transparency = 0.6

local crossH = Instance.new("Frame", RadarGui)
crossH.Size = UDim2.new(1, -20, 0, 1)
crossH.Position = UDim2.new(0, 10, 0.5, 0)
crossH.BackgroundColor3 = Theme.Green
crossH.BackgroundTransparency = 0.8
crossH.BorderSizePixel = 0
crossH.ZIndex = 801

local crossV = Instance.new("Frame", RadarGui)
crossV.Size = UDim2.new(0, 1, 1, -20)
crossV.Position = UDim2.new(0.5, 0, 0, 10)
crossV.BackgroundColor3 = Theme.Green
crossV.BackgroundTransparency = 0.8
crossV.BorderSizePixel = 0
crossV.ZIndex = 801

local selfDot = Instance.new("Frame", RadarGui)
selfDot.Size = UDim2.new(0, 6, 0, 6)
selfDot.Position = UDim2.new(0.5, -3, 0.5, -3)
selfDot.BackgroundColor3 = Theme.GreenBright
selfDot.BorderSizePixel = 0
selfDot.ZIndex = 803
Instance.new("UICorner", selfDot).CornerRadius = UDim.new(1, 0)

local dotsContainer = Instance.new("Frame", RadarGui)
dotsContainer.Size = UDim2.new(1, 0, 1, 0)
dotsContainer.BackgroundTransparency = 1
dotsContainer.ClipsDescendants = true
dotsContainer.ZIndex = 802
Instance.new("UICorner", dotsContainer).CornerRadius = UDim.new(1, 0)

local radarDots = {}

local function createRadarEntry(playerName)
    local dot = Instance.new("Frame", dotsContainer)
    dot.Name = playerName .. "_dot"
    dot.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    dot.BorderSizePixel = 0
    dot.ZIndex = 803
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
    local nameLbl = Instance.new("TextLabel", dot)
    nameLbl.Name = "NameLbl"
    nameLbl.Size = UDim2.new(0, 80, 0, 10)
    nameLbl.Position = UDim2.new(0.5, -40, 0, -12)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = playerName
    nameLbl.TextColor3 = Color3.fromRGB(255, 200, 200)
    nameLbl.TextSize = 8
    nameLbl.Font = Enum.Font.GothamBold
    nameLbl.ZIndex = 804
    nameLbl.Visible = false
    local line = Instance.new("Frame", dotsContainer)
    line.Name = playerName .. "_line"
    line.AnchorPoint = Vector2.new(0, 0.5)
    line.BorderSizePixel = 0
    line.BackgroundColor3 = Color3.fromRGB(255, 150, 150)
    line.BackgroundTransparency = 0.2
    line.Size = UDim2.new(0, _G.radarViewDirLength, 0, 2)
    line.ZIndex = 802
    line.Visible = false
    return { dot = dot, line = line, nameLbl = nameLbl, fireUntil = 0 }
end

local function isPlayerShooting(plr, char)
    local tool = char:FindFirstChildOfClass("Tool")
    if not tool then return false end
    for _, name in ipairs({"Firing", "Shooting", "IsFiring", "Fired", "Attacking"}) do
        local bv = tool:FindFirstChild(name)
        if bv and bv:IsA("BoolValue") and bv.Value then return true end
        local attr = tool:GetAttribute(name)
        if attr == true then return true end
    end
    for _, desc in ipairs(tool:GetDescendants()) do
        if desc:IsA("Sound") then
            local nm = desc.Name:lower()
            if (nm:find("fire") or nm:find("shot") or nm:find("shoot") or nm:find("выстрел")) and desc.IsPlaying then
                return true
            end
        end
    end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        local animator = hum:FindFirstChildOfClass("Animator")
        if animator then
            for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                local animName = track.Animation and track.Animation.Name or ""
                local lower = animName:lower()
                if lower:find("fire") or lower:find("shoot") or lower:find("attack") then
                    return true
                end
            end
        end
    end
    return false
end

local function updateRadar()
    if not _G.radarEnabled then
        RadarGui.Visible = false
        return
    end
    RadarGui.Visible = true
    RadarGui.Size = UDim2.new(0, _G.radarSize, 0, _G.radarSize)

    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local camLook = Camera.CFrame.LookVector
    local camYaw = math.atan2(-camLook.X, -camLook.Z)
    local halfSize = _G.radarSize / 2
    local range = _G.radarRange
    local currentTargets = {}
    local now = tick()

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local targetHrp = plr.Character:FindFirstChild("HumanoidRootPart")
            local targetHum = plr.Character:FindFirstChildOfClass("Humanoid")
            if targetHrp and targetHum and targetHum.Health > 0 then
                currentTargets[plr.Name] = true
                local delta = targetHrp.Position - hrp.Position
                local dist = Vector2.new(delta.X, delta.Z).Magnitude
                local clamped = false
                if dist > range then
                    local dir = Vector2.new(delta.X, delta.Z).Unit
                    delta = Vector3.new(dir.X * range, 0, dir.Y * range)
                    dist = range
                    clamped = true
                end
                local rotX = delta.X * math.cos(-camYaw) - delta.Z * math.sin(-camYaw)
                local rotZ = delta.X * math.sin(-camYaw) + delta.Z * math.cos(-camYaw)
                local scale = (halfSize - 6) / range
                local px = rotX * scale
                local py = -rotZ * scale
                local screenDist = math.sqrt(px * px + py * py)
                local maxR = halfSize - 6
                if screenDist > maxR then
                    px = px / screenDist * maxR
                    py = py / screenDist * maxR
                end

                local entry = radarDots[plr.Name]
                if not entry then
                    entry = createRadarEntry(plr.Name)
                    radarDots[plr.Name] = entry
                end

                local isFiring = false
                if _G.radarFireHighlight and not clamped then
                    isFiring = isPlayerShooting(plr, plr.Character)
                    if isFiring then entry.fireUntil = now + _G.radarFireDuration end
                end
                local fireActive = now < entry.fireUntil

                entry.dot.Size = UDim2.new(0, _G.radarDotSize, 0, _G.radarDotSize)
                entry.dot.Position = UDim2.new(0.5, px - _G.radarDotSize / 2, 0.5, py - _G.radarDotSize / 2)
                entry.dot.Visible = true

                if fireActive then
                    entry.dot.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
                elseif isPlayerIgnored(plr) then
                    entry.dot.BackgroundColor3 = Color3.fromRGB(80, 255, 140)
                elseif LocalPlayer:IsFriendsWith(plr.UserId) then
                    entry.dot.BackgroundColor3 = Color3.fromRGB(80, 200, 255)
                elseif plr.Team == LocalPlayer.Team then
                    entry.dot.BackgroundColor3 = Color3.fromRGB(80, 255, 120)
                else
                    entry.dot.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
                end

                if _G.radarShowViewDir then
                    local targetLook = targetHrp.CFrame.LookVector
                    local lookX = targetLook.X * math.cos(-camYaw) - targetLook.Z * math.sin(-camYaw)
                    local lookZ = targetLook.X * math.sin(-camYaw) + targetLook.Z * math.cos(-camYaw)
                    local lookLen = math.sqrt(lookX * lookX + lookZ * lookZ)
                    if lookLen > 0.001 then
                        lookX = lookX / lookLen
                        lookZ = lookZ / lookLen
                    end
                    local angleDeg = math.deg(math.atan2(-lookZ, lookX))
                    entry.line.Visible = true
                    entry.line.BackgroundColor3 = fireActive and Color3.fromRGB(255, 255, 0) or Color3.fromRGB(255, 150, 150)
                    entry.line.Size = UDim2.new(0, _G.radarViewDirLength, 0, 2)
                    entry.line.Rotation = angleDeg
                    entry.line.Position = UDim2.new(0.5, px, 0.5, py)
                else
                    entry.line.Visible = false
                end

                if entry.nameLbl then
                    entry.nameLbl.Visible = _G.radarShowNames
                end
            end
        end
    end

    for name, entry in pairs(radarDots) do
        if not currentTargets[name] then
            if entry.dot then entry.dot:Destroy() end
            if entry.line then entry.line:Destroy() end
            radarDots[name] = nil
        end
    end
end

RunService.RenderStepped:Connect(function()
    pcall(updateRadar)
end)

-- ========================================================================
-- ГАЛЕРЕЯ АНИМАЦИЙ (отдельное окно, 3D-превью манекена, вкладки, копирование ID)
-- Изолирована в pcall — не ломает основное меню при ошибке.
-- ========================================================================
function buildAnimGallery()
    local PACKS = {
        {name = "67", items = {
            {"Idle", 131615763118869}, {"Walk", 73305802913801}, {"Run", 71492775028835},
            {"Jump", 80252381525544}, {"Fall", 102746074461880}, {"Climb", 86051297640177}, {"Swim", 103791932450882},
        }},
        {name = "Анти-аим", items = {
            {"Idle", 99022838755345}, {"Walk", 123133084737812}, {"Run", 121048618200276},
            {"Jump", 116998869045102}, {"Fall", 130780690853448}, {"Climb", 128230983521290}, {"Swim", 135590333135192},
        }},
        {name = "Мини-чел", items = {
            {"Idle", 120334563069076}, {"Walk", 102772460432563}, {"Run", 108433935463014},
            {"Jump", 75204372096605}, {"Fall", 100526605114235}, {"Climb", 132739582723847}, {"Swim", 116174839992761},
        }},
        {name = "Аура", items = {
            {"Idle", 75638427965557}, {"Walk", 131290152729043}, {"Run", 77610456891399},
            {"Jump", 74451563346167}, {"Fall", 74203422263286}, {"Climb", 116293937663140}, {"Swim", 110044773049875},
        }},
        {name = "На голове", items = {
            {"Idle", 118314720917722}, {"Walk", 87609396024598}, {"Run", 82338987464047},
            {"Jump", 85894771026784}, {"Fall", 115632952355852}, {"Climb", 107558689118119}, {"Swim", 97130232121269},
        }},
    }

    local function idStr(id) return string.format("%.0f", id) end
    local function copyText(t)
        pcall(function()
            if setclipboard then setclipboard(t)
            elseif toclipboard then toclipboard(t) end
        end)
    end

    AnimGallery = Instance.new("ScreenGui")
    AnimGallery.Name = "AnimGallery"
    AnimGallery.ResetOnSpawn = false
    AnimGallery.IgnoreGuiInset = true
    AnimGallery.DisplayOrder = 50
    AnimGallery.Parent = game.CoreGui or (LocalPlayer:WaitForChild("PlayerGui"))

    local win = Instance.new("Frame", AnimGallery)
    AnimGallery = win
    win.Name = "Window"
    win.AnchorPoint = Vector2.new(0.5, 0.5)
    win.Position = UDim2.new(0.5, 0, 0.5, 0)
    win.Size = UDim2.new(0, 640, 0, 450)
    win.BackgroundColor3 = Theme.BgDark
    win.BorderSizePixel = 0
    win.Visible = false
    Instance.new("UICorner", win).CornerRadius = UDim.new(0, 12)
    local wStroke = Instance.new("UIStroke", win)
    wStroke.Color = Theme.Green
    wStroke.Thickness = 2
    wStroke.Transparency = 0.3

    -- Фон-клетка под цвет меню
    local galGrid = Instance.new("Frame", win)
    galGrid.Size = UDim2.new(1, 0, 1, 0)
    galGrid.BackgroundTransparency = 1
    galGrid.ClipsDescendants = true
    galGrid.ZIndex = 1
    Instance.new("UICorner", galGrid).CornerRadius = UDim.new(0, 12)
    for i = 0, 46 do
        local vv = Instance.new("Frame", galGrid)
        vv.Size = UDim2.new(0, 1, 1, 0)
        vv.Position = UDim2.new(0, i * 14, 0, 0)
        vv.BackgroundColor3 = Theme.Green
        vv.BackgroundTransparency = 0.92
        vv.BorderSizePixel = 0
        vv.ZIndex = 1
    end
    for i = 0, 32 do
        local hh = Instance.new("Frame", galGrid)
        hh.Size = UDim2.new(1, 0, 0, 1)
        hh.Position = UDim2.new(0, 0, 0, i * 14)
        hh.BackgroundColor3 = Theme.Green
        hh.BackgroundTransparency = 0.92
        hh.BorderSizePixel = 0
        hh.ZIndex = 1
    end

    local header = Instance.new("Frame", win)
    header.Size = UDim2.new(1, 0, 0, 44)
    header.BackgroundColor3 = Theme.BgPanel
    header.BorderSizePixel = 0
    Instance.new("UICorner", header).CornerRadius = UDim.new(0, 12)

    local title = Instance.new("TextLabel", header)
    title.Size = UDim2.new(1, -60, 1, 0)
    title.Position = UDim2.new(0, 16, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "АНИМАЦИИ — 3D ПРЕВЬЮ"
    title.TextColor3 = Theme.GreenBright
    title.TextSize = 15
    title.Font = Enum.Font.Jura
    title.TextXAlignment = Enum.TextXAlignment.Left

    local closeBtn = Instance.new("TextButton", header)
    closeBtn.Size = UDim2.new(0, 28, 0, 28)
    closeBtn.Position = UDim2.new(1, -36, 0.5, -14)
    closeBtn.BackgroundColor3 = Theme.BgRow
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Theme.TextDim
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 13
    closeBtn.AutoButtonColor = false
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
    closeBtn.MouseButton1Click:Connect(function() win.Visible = false end)

    -- Перетаскивание окна за заголовок
    do
        local dragging, dragStart, startPos
        header.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = win.Position
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local d = input.Position - dragStart
                win.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
        end)
    end

    -- Вкладки паков
    local tabsRow = Instance.new("Frame", win)
    tabsRow.Size = UDim2.new(1, -24, 0, 28)
    tabsRow.Position = UDim2.new(0, 12, 0, 52)
    tabsRow.BackgroundTransparency = 1
    local tabsLayout = Instance.new("UIListLayout", tabsRow)
    tabsLayout.FillDirection = Enum.FillDirection.Horizontal
    tabsLayout.Padding = UDim.new(0, 6)

    -- Список анимаций (слева)
    local listScroll = Instance.new("ScrollingFrame", win)
    listScroll.Size = UDim2.new(0, 268, 1, -132)
    listScroll.Position = UDim2.new(0, 12, 0, 86)
    listScroll.BackgroundColor3 = Theme.BgPanel
    listScroll.BackgroundTransparency = 0.35
    listScroll.BorderSizePixel = 0
    listScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    listScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    listScroll.ScrollBarThickness = 4
    listScroll.ScrollBarImageColor3 = Theme.GreenBright
    Instance.new("UICorner", listScroll).CornerRadius = UDim.new(0, 8)
    local listPad = Instance.new("UIPadding", listScroll)
    listPad.PaddingLeft = UDim.new(0, 6)
    listPad.PaddingRight = UDim.new(0, 6)
    listPad.PaddingTop = UDim.new(0, 6)
    local listLayout = Instance.new("UIListLayout", listScroll)
    listLayout.Padding = UDim.new(0, 5)

    -- 3D превью (справа)
    local vp = Instance.new("ViewportFrame", win)
    vp.Size = UDim2.new(0, 336, 0, 300)
    vp.Position = UDim2.new(0, 292, 0, 86)
    vp.BackgroundColor3 = Color3.fromRGB(14, 20, 14)
    vp.Ambient = Color3.fromRGB(180, 200, 180)
    vp.LightColor = Color3.fromRGB(255, 255, 255)
    vp.LightDirection = Vector3.new(-0.5, -1, -0.5)
    vp.BorderSizePixel = 0
    Instance.new("UICorner", vp).CornerRadius = UDim.new(0, 8)

    local idLabel = Instance.new("TextLabel", win)
    idLabel.Size = UDim2.new(0, 336, 0, 24)
    idLabel.Position = UDim2.new(0, 292, 0, 392)
    idLabel.BackgroundTransparency = 1
    idLabel.Text = "Выбери анимацию слева"
    idLabel.TextColor3 = Theme.TextDim
    idLabel.TextSize = 12
    idLabel.Font = Enum.Font.Gotham
    idLabel.TextXAlignment = Enum.TextXAlignment.Left

    local function makeWinBtn(text, xoff, color)
        local b = Instance.new("TextButton", win)
        b.Size = UDim2.new(0, 160, 0, 28)
        b.Position = UDim2.new(0, xoff, 1, -36)
        b.BackgroundColor3 = color or Theme.BgRow
        b.Text = text
        b.TextColor3 = Theme.TextMain
        b.TextSize = 12
        b.Font = Enum.Font.Jura
        b.AutoButtonColor = false
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
        return b
    end
    local playBtn = makeWinBtn("ИГРАТЬ НА МНЕ", 292, Theme.Green)
    playBtn.TextColor3 = Color3.fromRGB(10, 15, 10)
    local resetBtn = makeWinBtn("ОБНУЛИТЬ", 460, Color3.fromRGB(70, 40, 40))

    local selectedId = nil
    local previewTrack = nil
    local playerTrack = nil

    local function stopPreview()
        if previewTrack then pcall(function() previewTrack:Stop() end) end
        previewTrack = nil
    end

    local function makeFallbackDummy(wm)
        local function mk(size, pos)
            local p = Instance.new("Part")
            p.Size = size
            p.Position = pos
            p.Anchored = true
            p.Color = Color3.fromRGB(80, 200, 120)
            p.Material = Enum.Material.SmoothPlastic
            p.Parent = wm
            return p
        end
        mk(Vector3.new(2, 2, 1), Vector3.new(0, 0, 0))
        mk(Vector3.new(1.2, 1.2, 1.2), Vector3.new(0, 1.7, 0))
        mk(Vector3.new(1, 2, 1), Vector3.new(-1.5, 0, 0))
        mk(Vector3.new(1, 2, 1), Vector3.new(1.5, 0, 0))
        mk(Vector3.new(1, 2, 1), Vector3.new(-0.5, -2, 0))
        mk(Vector3.new(1, 2, 1), Vector3.new(0.5, -2, 0))
    end

    local function showPreview(id)
        stopPreview()
        vp:ClearAllChildren()
        local wm = Instance.new("WorldModel", vp)
        local didClone = false
        local src = LocalPlayer.Character
        if src then
            pcall(function() src.Archivable = true end)
            local ok, clone = pcall(function() return src:Clone() end)
            if ok and clone then
                for _, d in ipairs(clone:GetDescendants()) do
                    if d:IsA("Script") or d:IsA("LocalScript") then
                        d:Destroy()
                    elseif d:IsA("BasePart") then
                        d.LocalTransparencyModifier = 0
                        d.Transparency = 0
                        d.CanCollide = false
                        d.Anchored = false
                    elseif d:IsA("Decal") or d:IsA("Texture") then
                        d.Transparency = 0
                    end
                end
                clone.Parent = wm
                pcall(function() clone:PivotTo(CFrame.new(0, 0, 0)) end)
                local hrp = clone:FindFirstChild("HumanoidRootPart")
                if hrp then hrp.Anchored = true end
                local hum = clone:FindFirstChildOfClass("Humanoid")
                local animator = hum and hum:FindFirstChildOfClass("Animator")
                if animator then
                    local anim = Instance.new("Animation")
                    anim.AnimationId = "rbxassetid://" .. tostring(id)
                    local okT, track = pcall(function() return animator:LoadAnimation(anim) end)
                    if okT and track then
                        track.Looped = true
                        track.Priority = Enum.AnimationPriority.Action
                        pcall(function() track:Play() end)
                        previewTrack = track
                    end
                end
                didClone = true
            end
        end
        if not didClone then
            makeFallbackDummy(wm)
        end
        local cam = Instance.new("Camera")
        cam.FieldOfView = 45
        cam.Parent = vp
        cam.CFrame = CFrame.new(Vector3.new(0, 2, -8), Vector3.new(0, 0, 0))
        vp.CurrentCamera = cam
    end

    AnimGallery_Refresh = function()
        pcall(function()
            if selectedId then showPreview(selectedId) end
        end)
    end

    local function playOnMe(id)
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local animator = hum and hum:FindFirstChildOfClass("Animator")
        if not animator then return end
        if playerTrack then pcall(function() playerTrack:Stop() end) end
        local anim = Instance.new("Animation")
        anim.AnimationId = "rbxassetid://" .. tostring(id)
        local okT, track = pcall(function() return animator:LoadAnimation(anim) end)
        if okT and track then
            track.Looped = true
            track.Priority = Enum.AnimationPriority.Action
            pcall(function() track:Play() end)
            playerTrack = track
        end
    end

    local function resetAll()
        stopPreview()
        if playerTrack then pcall(function() playerTrack:Stop() end) end
        playerTrack = nil
        local char = LocalPlayer.Character
        local animate = char and char:FindFirstChild("Animate")
        if animate then pcall(function() animate.Disabled = false end) end
        vp:ClearAllChildren()
        idLabel.Text = "Сброшено"
    end

    local function selectItem(name, id)
        selectedId = id
        idLabel.Text = name .. "   •   ID: " .. idStr(id)
        showPreview(id)
    end

    local tabs = {}
    local listRows = {}
    local function populate(packIndex)
        for _, r in ipairs(listRows) do r:Destroy() end
        listRows = {}
        for i, t in ipairs(tabs) do
            t.BackgroundColor3 = (i == packIndex) and Theme.Green or Theme.BgRow
            t.TextColor3 = (i == packIndex) and Color3.fromRGB(10, 15, 10) or Theme.TextDim
        end
        for _, item in ipairs(PACKS[packIndex].items) do
            local row = Instance.new("Frame", listScroll)
            row.Size = UDim2.new(1, -12, 0, 32)
            row.BackgroundColor3 = Theme.BgRow
            row.BorderSizePixel = 0
            Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)

            local btn = Instance.new("TextButton", row)
            btn.Size = UDim2.new(1, -40, 1, 0)
            btn.BackgroundTransparency = 1
            btn.Text = "  " .. item[1] .. "  (" .. idStr(item[2]) .. ")"
            btn.TextColor3 = Theme.TextMain
            btn.TextSize = 12
            btn.Font = Enum.Font.Gotham
            btn.TextXAlignment = Enum.TextXAlignment.Left
            btn.AutoButtonColor = false
            btn.MouseButton1Click:Connect(function() PlayClick(); selectItem(item[1], item[2]) end)

            local copy = Instance.new("TextButton", row)
            copy.Size = UDim2.new(0, 34, 1, 0)
            copy.Position = UDim2.new(1, -34, 0, 0)
            copy.BackgroundColor3 = Theme.BgPanel
            copy.Text = "⧉"
            copy.TextColor3 = Theme.GreenBright
            copy.TextSize = 14
            copy.Font = Enum.Font.GothamBold
            copy.AutoButtonColor = false
            Instance.new("UICorner", copy).CornerRadius = UDim.new(0, 6)
            copy.MouseButton1Click:Connect(function()
                PlayClick()
                copyText(idStr(item[2]))
                copy.Text = "✔"
                task.delay(0.6, function() if copy and copy.Parent then copy.Text = "⧉" end end)
            end)

            table.insert(listRows, row)
        end
    end

    for i, pack in ipairs(PACKS) do
        local t = Instance.new("TextButton", tabsRow)
        t.Size = UDim2.new(0, 112, 0, 26)
        t.BackgroundColor3 = Theme.BgRow
        t.Text = pack.name
        t.TextColor3 = Theme.TextDim
        t.TextSize = 12
        t.Font = Enum.Font.GothamSemibold
        t.AutoButtonColor = false
        Instance.new("UICorner", t).CornerRadius = UDim.new(0, 6)
        t.MouseButton1Click:Connect(function() PlayClick(); populate(i) end)
        table.insert(tabs, t)
    end

    playBtn.MouseButton1Click:Connect(function()
        PlayClick()
        if selectedId then playOnMe(selectedId) end
    end)
    resetBtn.MouseButton1Click:Connect(function()
        PlayClick()
        resetAll()
    end)

    populate(1)
    pcall(function() selectItem(PACKS[1].items[1][1], PACKS[1].items[1][2]) end)
end

pcall(buildAnimGallery)

-- === ПОЛНАЯ ВЫГРУЗКА ===
function fullUnload()
    _G.unloaded = true

    local killFlags = {
        "aimbotEnabled", "hvhAimbotEnabled", "hvhTargetLockEnabled",
        "hvhAntiAimEnabled", "aaSpinEnabled", "aaJitterEnabled", "aaBypassEnabled",
        "aaUiYaw", "aaUiPitch", "aaUiMain", "aaDesyncEnabled",
        "triggerbotEnabled", "killauraEnabled",
        "espBoxes", "espNames", "espHpText", "espDistance", "espSkeletons", "espChams",
        "espTracers", "viewDirection", "weaponEsp", "radarEnabled",
        "SpeedHackEnabled", "wallPassEnabled", "infJumpEnabled", "bhopEnabled",
        "spiderEnabled", "noFallDamage", "fullbrightEnabled", "antiAfkEnabled",
        "autoAimRMB", "dynamicFovEnabled", "aimJitterEnabled", "aimMaxTurnEnabled",
        "aimMissEnabled", "aimAutoStopEnabled", "invisibleEnabled", "tpMouseEnabled",
        "antiRecoil", "debugCamEnabled", "forcePriorityAim",
    }
    for _, k in ipairs(killFlags) do
        _G[k] = false
    end

    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        pcall(function()
            hum.WalkSpeed = 16
            hum.JumpPower = 50
            hum.JumpHeight = 7.2
            hum.AutoRotate = true
        end)
    end
    pcall(function() removeInvisible() end)
    pcall(function() disableFullbright() end)
    if _G.debugCam and _G.debugCam.active then
        _G.debugCam.active = false
        pcall(function() debugCamStop() end)
    end
    pcall(function()
        Camera.CameraType = Enum.CameraType.Custom
        if hum then Camera.CameraSubject = hum end
        Camera.FieldOfView = 70
    end)

    for _, obj in ipairs(workspace:GetChildren()) do
        if obj.Name == "LocalPlatform" or obj.Name == "LocalPushPlate"
            or obj.Name == "EspContainer" or obj.Name == "ChamsContainer" then
            pcall(function() obj:Destroy() end)
        end
    end
    pcall(function()
        for _, line in ipairs(selfSkeletonLines) do
            line.Visible = false
            pcall(function() line:Remove() end)
        end
    end)

    pcall(function() if particlePart then particlePart:Destroy() end end)
    pcall(function() if ClickSound then ClickSound:Destroy() end end)
    pcall(function() if MenuBlur then MenuBlur:Destroy() end end)
    pcall(function() if ScreenGui then ScreenGui:Destroy() end end)
end

-- Чистим оставшиеся от старых версий прозрачные плиты («кубик» вокруг игрока).
task.spawn(function()
    while true do
        for _, obj in ipairs(workspace:GetChildren()) do
            if obj.Name == "LocalPlatform" or obj.Name == "LocalPushPlate" then
                pcall(function() obj:Destroy() end)
            end
        end
        task.wait(1)
    end
end)
