-- NagiHub V3 | Team Zyvora
-- Roblox Studio LocalScript
-- Target: Feed Your Pet (PlaceId 131783066284968)
-- Place in StarterPlayer > StarterPlayerScripts
-- For experiences you own or are authorized to test.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

local player = Players.LocalPlayer
local pg = player:WaitForChild("PlayerGui")

local TARGET_PLACE_ID = 131783066284968
local TARGET_NAME = "Feed Your Pet"

local old = pg:FindFirstChild("NagiHubV3")
if old then old:Destroy() end

local C = {
    bg = Color3.fromRGB(7,9,15), panel = Color3.fromRGB(12,16,25), card = Color3.fromRGB(18,23,35),
    card2 = Color3.fromRGB(27,34,52), text = Color3.fromRGB(240,243,255), muted = Color3.fromRGB(137,149,176),
    accent = Color3.fromRGB(105,135,255), accent2 = Color3.fromRGB(160,105,255), good = Color3.fromRGB(85,220,155),
    warn = Color3.fromRGB(255,190,85), bad = Color3.fromRGB(255,95,115)
}

local gui = Instance.new("ScreenGui")
gui.Name = "NagiHubV3"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = pg

local function corner(x,r) local c=Instance.new("UICorner"); c.CornerRadius=UDim.new(0,r); c.Parent=x end
local function stroke(x,t) local s=Instance.new("UIStroke"); s.Color=C.accent; s.Transparency=t or .72; s.Thickness=1; s.Parent=x end
local function tween(x,p,d) TweenService:Create(x,TweenInfo.new(d or .18,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),p):Play() end
local function label(p,text,size,color)
    local x=Instance.new("TextLabel"); x.BackgroundTransparency=1; x.Text=text; x.TextSize=size or 14; x.TextColor3=color or C.text; x.Font=Enum.Font.Gotham; x.TextXAlignment=Enum.TextXAlignment.Left; x.Parent=p; return x
end
local function button(p,text,cb,h)
    local b=Instance.new("TextButton"); b.Size=UDim2.new(1,0,0,h or 42); b.BackgroundColor3=C.card; b.Text=text; b.TextColor3=C.text; b.TextSize=13; b.Font=Enum.Font.GothamMedium; b.TextXAlignment=Enum.TextXAlignment.Left; b.AutoButtonColor=false; b.Parent=p; corner(b,10); stroke(b,.84)
    b.MouseEnter:Connect(function() tween(b,{BackgroundColor3=C.card2}) end)
    b.MouseLeave:Connect(function() tween(b,{BackgroundColor3=C.card}) end)
    b.MouseButton1Click:Connect(cb)
    return b
end
local function notify(text, color)
    local n=Instance.new("TextLabel"); n.AnchorPoint=Vector2.new(.5,0); n.Position=UDim2.new(.5,0,0,-55); n.Size=UDim2.fromOffset(360,42); n.BackgroundColor3=C.panel; n.Text=text; n.TextColor3=color or C.text; n.TextSize=13; n.Font=Enum.Font.GothamMedium; n.Parent=gui; corner(n,10); stroke(n,.42); tween(n,{Position=UDim2.new(.5,0,0,18)},.22); task.delay(1.8,function() tween(n,{Position=UDim2.new(.5,0,0,-55)},.2); task.wait(.22); if n.Parent then n:Destroy() end end)
end

local main=Instance.new("Frame"); main.AnchorPoint=Vector2.new(.5,.5); main.Position=UDim2.fromScale(.5,.5); main.Size=UDim2.fromOffset(820,520); main.BackgroundColor3=C.bg; main.Parent=gui; corner(main,18); stroke(main,.2)
local top=Instance.new("Frame"); top.Size=UDim2.new(1,0,0,72); top.BackgroundColor3=C.panel; top.Parent=main; corner(top,18)
local title=label(top,"NAGI HUB",23); title.Position=UDim2.fromOffset(22,9); title.Size=UDim2.fromOffset(260,30); title.Font=Enum.Font.GothamBold
local sub=label(top,"V3  •  TEAM ZYVORA  •  FEED YOUR PET",10,C.muted); sub.Position=UDim2.fromOffset(24,41); sub.Size=UDim2.fromOffset(400,18)
local badge=label(top,"● READY",11,C.good); badge.AnchorPoint=Vector2.new(1,.5); badge.Position=UDim2.new(1,-62,.5,0); badge.Size=UDim2.fromOffset(100,20); badge.TextXAlignment=Enum.TextXAlignment.Right
local close=Instance.new("TextButton"); close.AnchorPoint=Vector2.new(1,.5); close.Position=UDim2.new(1,-15,.5,0); close.Size=UDim2.fromOffset(36,36); close.Text="×"; close.TextSize=24; close.TextColor3=C.text; close.BackgroundColor3=C.card2; close.Parent=top; corner(close,9)

local side=Instance.new("Frame"); side.Position=UDim2.fromOffset(12,84); side.Size=UDim2.fromOffset(165,420); side.BackgroundTransparency=1; side.Parent=main
local content=Instance.new("Frame"); content.Position=UDim2.fromOffset(190,84); content.Size=UDim2.new(1,-202,1,-98); content.BackgroundTransparency=1; content.Parent=main

local pages={}; local nav={}
local function page(name)
    local p=Instance.new("ScrollingFrame"); p.Name=name; p.Size=UDim2.fromScale(1,1); p.BackgroundTransparency=1; p.BorderSizePixel=0; p.ScrollBarThickness=3; p.Visible=false; p.Parent=content
    local l=Instance.new("UIListLayout"); l.Padding=UDim.new(0,10); l.Parent=p
    l:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() p.CanvasSize=UDim2.fromOffset(0,l.AbsoluteContentSize.Y+12) end)
    pages[name]=p; return p
end
local function card(p,h)
    local f=Instance.new("Frame"); f.Size=UDim2.new(1,-2,0,h or 72); f.BackgroundColor3=C.card; f.Parent=p; corner(f,12); stroke(f,.84); return f
end
local function navButton(name,icon)
    local b=button(side,icon.."   "..name,function() selectTab(name) end,42); nav[name]=b; return b
end

local home=page("Home"); local pet=page("Pet"); local playerPage=page("Player"); local session=page("Session"); local settings=page("Settings")

-- Home / game detection
local hero=card(home,125)
local h1=label(hero,"Feed Your Pet",23); h1.Position=UDim2.fromOffset(18,14); h1.Size=UDim2.new(1,-36,30,0); h1.Font=Enum.Font.GothamBold
local h2=label(hero,"NagiHub V3 is connected to this experience.",13,C.muted); h2.Position=UDim2.fromOffset(18,50); h2.Size=UDim2.new(1,-36,22,0)
local id=label(hero,"PLACE ID  "..tostring(game.PlaceId),11,C.good); id.Position=UDim2.fromOffset(18,84); id.Size=UDim2.new(1,-36,20,0)

local mode=card(home,92)
local mt=label(mode,"TARGET STATUS",11,C.muted); mt.Position=UDim2.fromOffset(18,12); mt.Size=UDim2.fromOffset(150,18)
local mv=label(mode,"Checking...",17); mv.Position=UDim2.fromOffset(18,37); mv.Size=UDim2.new(1,-36,24,0)
if game.PlaceId == TARGET_PLACE_ID then
    mv.Text="✓ Feed Your Pet detected"; mv.TextColor3=C.good
else
    mv.Text="⚠ Different experience detected"; mv.TextColor3=C.warn
end

local function humanoid() local ch=player.Character; return ch and ch:FindFirstChildOfClass("Humanoid") end
local function root() local ch=player.Character; return ch and ch:FindFirstChild("HumanoidRootPart") end

-- Pet page: safe diagnostics/interaction helpers; it does not guess or mutate unknown pet systems.
local pt=label(pet,"PET TOOLS",11,C.muted); pt.Size=UDim2.new(1,0,0,20); pt.Font=Enum.Font.GothamBold
local info=card(pet,104)
local it=label(info,"PET SYSTEM",12); it.Position=UDim2.fromOffset(16,12); it.Size=UDim2.new(1,-32,22,0); it.Font=Enum.Font.GothamBold
local iv=label(info,"Waiting for your experience's pet objects...",11,C.muted); iv.Position=UDim2.fromOffset(16,39); iv.Size=UDim2.new(1,-32,42,0); iv.TextWrapped=true
button(pet,"🔎  Scan local pet objects",function()
    local found={}
    for _,d in ipairs(player:GetDescendants()) do
        if d:IsA("Folder") or d:IsA("Model") or d:IsA("Tool") then
            local n=string.lower(d.Name)
            if string.find(n,"pet",1,true) or string.find(n,"egg",1,true) or string.find(n,"food",1,true) then table.insert(found,d:GetFullName()) end
        end
    end
    print("NagiHub V3 pet scan:",#found,"matching local objects")
    for i=1,math.min(#found,50) do print(found[i]) end
    iv.Text=(#found>0 and ("Found "..#found.." matching local objects. See Output for details.") or "No matching local pet/egg/food objects found locally.")
    notify("Pet scan complete: "..#found)
end)
button(pet,"📋  Print character objects",function()
    for _,d in ipairs(player.Character and player.Character:GetDescendants() or {}) do print("NagiHub Character:",d:GetFullName(),d.ClassName) end
    notify("Character objects printed to Output")
end)

-- Player page
local speed=16; local jump=50; local sprint=false
local function slider(p,name,min,max,default,cb)
    local f=card(p,84); local txt=label(f,name..": "..default,13); txt.Position=UDim2.fromOffset(15,9); txt.Size=UDim2.new(1,-30,22,0)
    local bar=Instance.new("Frame"); bar.Position=UDim2.fromOffset(15,48); bar.Size=UDim2.new(1,-30,0,7); bar.BackgroundColor3=Color3.fromRGB(38,45,62); bar.Parent=f; corner(bar,4)
    local fill=Instance.new("Frame"); fill.BackgroundColor3=C.accent; fill.Size=UDim2.new((default-min)/(max-min),0,1,0); fill.Parent=bar; corner(fill,4)
    local drag=false
    local function set(x) local q=math.clamp((x-bar.AbsolutePosition.X)/bar.AbsoluteSize.X,0,1); local v=math.floor(min+(max-min)*q+.5); fill.Size=UDim2.new(q,0,1,0); txt.Text=name..": "..v; cb(v) end
    bar.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drag=true; set(i.Position.X) end end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drag=false end end)
    UIS.InputChanged:Connect(function(i) if drag and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then set(i.Position.X) end end)
end
local ptitle=label(playerPage,"MOVEMENT",11,C.muted); ptitle.Size=UDim2.new(1,0,0,20); ptitle.Font=Enum.Font.GothamBold
slider(playerPage,"WalkSpeed",8,100,16,function(v) speed=v; local h=humanoid(); if h then h.WalkSpeed=v end end)
slider(playerPage,"JumpPower",25,150,50,function(v) jump=v; local h=humanoid(); if h then h.UseJumpPower=true; h.JumpPower=v end end)
button(playerPage,"⚡  Toggle sprint",function() sprint=not sprint; local h=humanoid(); if h then h.WalkSpeed=sprint and math.max(speed,28) or speed end; notify(sprint and "Sprint ON" or "Sprint OFF") end)
button(playerPage,"↺  Reset movement",function() speed=16; jump=50; sprint=false; local h=humanoid(); if h then h.WalkSpeed=16; h.UseJumpPower=true; h.JumpPower=50 end; notify("Movement reset") end)
button(playerPage,"♻  Respawn character",function() local h=humanoid(); if h then h.Health=0 end end)

-- Session dashboard
local stitle=label(session,"SESSION DASHBOARD",11,C.muted); stitle.Size=UDim2.new(1,0,0,20); stitle.Font=Enum.Font.GothamBold
local s1=card(session,94)
local sv=label(s1,"PLAYERS",11,C.muted); sv.Position=UDim2.fromOffset(16,12); sv.Size=UDim2.fromOffset(120,18)
local sn=label(s1,"",20); sn.Position=UDim2.fromOffset(16,35); sn.Size=UDim2.fromOffset(120,28); sn.Font=Enum.Font.GothamBold
local fps=label(s1,"FPS --",12,C.muted); fps.Position=UDim2.new(1,-160,0,35); fps.Size=UDim2.fromOffset(140,24); fps.TextXAlignment=Enum.TextXAlignment.Right
local ping=label(s1,"PING --",12,C.muted); ping.Position=UDim2.new(1,-160,0,58); ping.Size=UDim2.fromOffset(140,20); ping.TextXAlignment=Enum.TextXAlignment.Right
local function updateSession()
    sn.Text=tostring(#Players:GetPlayers())
    local ok, v = pcall(function() return Stats.Network.ServerStatsItem["Data Ping"]:GetValue() end)
    ping.Text=ok and ("PING "..math.floor(v).." ms") or "PING --"
end
updateSession(); Players.PlayerAdded:Connect(updateSession); Players.PlayerRemoving:Connect(updateSession)

local listCard=card(session,250)
local list=Instance.new("ScrollingFrame"); list.Position=UDim2.fromOffset(12,12); list.Size=UDim2.new(1,-24,1,-24); list.BackgroundTransparency=1; list.BorderSizePixel=0; list.ScrollBarThickness=2; list.Parent=listCard
local ll=Instance.new("UIListLayout"); ll.Padding=UDim.new(0,6); ll.Parent=list
local function refreshPlayers()
    for _,x in ipairs(list:GetChildren()) do if x:IsA("TextButton") then x:Destroy() end end
    for _,other in ipairs(Players:GetPlayers()) do
        button(list,"  "..other.DisplayName.."  ("..other.Name..")",function()
            local r=other.Character and other.Character:FindFirstChild("HumanoidRootPart")
            local me=root()
            if r and me then me.CFrame=r.CFrame+Vector3.new(3,0,0); notify("Moved near "..other.DisplayName) end
        end,34)
    end
end
refreshPlayers(); Players.PlayerAdded:Connect(refreshPlayers); Players.PlayerRemoving:Connect(refreshPlayers)

-- Settings
local q=label(settings,"INTERFACE",11,C.muted); q.Size=UDim2.new(1,0,0,20); q.Font=Enum.Font.GothamBold
button(settings,"👁  Hide NagiHub",function() main.Visible=false; reopen.Visible=true end)
button(settings,"🎯  Reset window position",function() main.Position=UDim2.fromScale(.5,.5); notify("Position reset") end)
button(settings,"▣  Compact mode",function() main.Size=UDim2.fromOffset(680,450); notify("Compact mode") end)
button(settings,"▣  Full mode",function() main.Size=UDim2.fromOffset(820,520); notify("Full mode") end)
button(settings,"🔔  Test notification",function() notify("NagiHub V3 is working",C.good) end)
button(settings,"📌  Print game information",function() print("NagiHub V3 | Game:",game.Name,"PlaceId:",game.PlaceId,"JobId:",game.JobId); notify("Game info printed to Output") end)

navButton("Home","◆"); navButton("Pet","◇"); navButton("Player","◈"); navButton("Session","▣"); navButton("Settings","⚙")
function selectTab(name)
    for n,p in pairs(pages) do p.Visible=(n==name) end
    for n,bx in pairs(nav) do bx.BackgroundColor3=(n==name) and Color3.fromRGB(40,52,82) or C.card end
end
selectTab("Home")

-- Drag window
local dragging=false; local dragStart; local startPos
top.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=true; dragStart=i.Position; startPos=main.Position end end)
UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=false end end)
UIS.InputChanged:Connect(function(i) if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then local d=i.Position-dragStart; main.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y) end end)

local reopen=Instance.new("TextButton"); reopen.AnchorPoint=Vector2.new(0,1); reopen.Position=UDim2.new(0,18,1,-18); reopen.Size=UDim2.fromOffset(118,38); reopen.BackgroundColor3=C.panel; reopen.Text="NAGI HUB"; reopen.TextColor3=C.text; reopen.TextSize=13; reopen.Font=Enum.Font.GothamBold; reopen.Visible=false; reopen.Parent=gui; corner(reopen,10); stroke(reopen,.4)
close.MouseButton1Click:Connect(function() main.Visible=false; reopen.Visible=true end)
reopen.MouseButton1Click:Connect(function() main.Visible=true; reopen.Visible=false end)

local frames=0; local elapsed=0
RunService.RenderStepped:Connect(function(dt)
    frames += 1; elapsed += dt
    if elapsed >= .5 then fps.Text=string.format("FPS %.0f",frames/elapsed); frames=0; elapsed=0; updateSession() end
end)

if game.PlaceId == TARGET_PLACE_ID then
    notify("NagiHub V3 • Feed Your Pet ready",C.good)
else
    notify("NagiHub V3 loaded • different PlaceId",C.warn)
end
