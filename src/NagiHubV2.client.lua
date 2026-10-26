-- NagiHub V2 | Team Zyvora
-- Roblox Studio LocalScript
-- Place in StarterPlayer > StarterPlayerScripts
-- Designed for experiences you own or are authorized to test.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local pg = player:WaitForChild("PlayerGui")
local old = pg:FindFirstChild("NagiHubV2")
if old then old:Destroy() end

local C = {
    bg = Color3.fromRGB(8,10,17), panel = Color3.fromRGB(13,17,27), card = Color3.fromRGB(18,23,35),
    card2 = Color3.fromRGB(23,29,44), text = Color3.fromRGB(238,242,255), muted = Color3.fromRGB(137,149,176),
    accent = Color3.fromRGB(105,135,255), accent2 = Color3.fromRGB(145,100,255), good = Color3.fromRGB(90,220,155),
}

local gui = Instance.new("ScreenGui")
gui.Name = "NagiHubV2"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = pg

local function corner(x,r) local c=Instance.new("UICorner"); c.CornerRadius=UDim.new(0,r); c.Parent=x end
local function stroke(x,t) local s=Instance.new("UIStroke"); s.Color=C.accent; s.Transparency=t or .65; s.Thickness=1; s.Parent=x end
local function tween(x,p,d) TweenService:Create(x,TweenInfo.new(d or .18,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),p):Play() end
local function label(p,text,size,color)
    local x=Instance.new("TextLabel"); x.BackgroundTransparency=1; x.Text=text; x.TextSize=size or 14; x.TextColor3=color or C.text; x.Font=Enum.Font.Gotham; x.TextXAlignment=Enum.TextXAlignment.Left; x.Parent=p; return x
end
local function button(p,text,cb,h)
    local b=Instance.new("TextButton"); b.Size=UDim2.new(1,0,0,h or 42); b.BackgroundColor3=C.card; b.Text=text; b.TextColor3=C.text; b.TextSize=13; b.Font=Enum.Font.GothamMedium; b.TextXAlignment=Enum.TextXAlignment.Left; b.AutoButtonColor=false; b.Parent=p; corner(b,10); stroke(b,.82)
    b.MouseEnter:Connect(function() tween(b,{BackgroundColor3=C.card2}) end); b.MouseLeave:Connect(function() tween(b,{BackgroundColor3=C.card}) end); b.MouseButton1Click:Connect(cb); return b
end
local function notify(text)
    local n=Instance.new("TextLabel"); n.AnchorPoint=Vector2.new(.5,0); n.Position=UDim2.new(.5,0,0,-55); n.Size=UDim2.fromOffset(320,42); n.BackgroundColor3=C.panel; n.Text=text; n.TextColor3=C.text; n.TextSize=13; n.Font=Enum.Font.GothamMedium; n.Parent=gui; corner(n,10); stroke(n,.45); tween(n,{Position=UDim2.new(.5,0,0,18)},.22); task.delay(1.8,function() tween(n,{Position=UDim2.new(.5,0,0,-55)},.2); task.wait(.22); n:Destroy() end)
end

local main=Instance.new("Frame"); main.AnchorPoint=Vector2.new(.5,.5); main.Position=UDim2.fromScale(.5,.5); main.Size=UDim2.fromOffset(760,480); main.BackgroundColor3=C.bg; main.Parent=gui; corner(main,18); stroke(main,.25)
local top=Instance.new("Frame"); top.Size=UDim2.new(1,0,0,70); top.BackgroundColor3=C.panel; top.Parent=main; corner(top,18)
local title=label(top,"NAGI HUB",22); title.Position=UDim2.fromOffset(22,10); title.Size=UDim2.fromOffset(250,30); title.Font=Enum.Font.GothamBold
local sub=label(top,"V2  •  TEAM ZYVORA",11,C.muted); sub.Position=UDim2.fromOffset(24,40); sub.Size=UDim2.fromOffset(250,18)
local status=label(top,"● ONLINE",11,C.good); status.AnchorPoint=Vector2.new(1,.5); status.Position=UDim2.new(1,-62,.5,0); status.Size=UDim2.fromOffset(80,20); status.TextXAlignment=Enum.TextXAlignment.Right
local close=Instance.new("TextButton"); close.AnchorPoint=Vector2.new(1,.5); close.Position=UDim2.new(1,-15,.5,0); close.Size=UDim2.fromOffset(36,36); close.Text="×"; close.TextSize=24; close.TextColor3=C.text; close.BackgroundColor3=C.card2; close.Parent=top; corner(close,9); close.MouseButton1Click:Connect(function() main.Visible=false end)

local side=Instance.new("Frame"); side.Position=UDim2.fromOffset(12,82); side.Size=UDim2.fromOffset(155,386); side.BackgroundTransparency=1; side.Parent=main
local content=Instance.new("Frame"); content.Position=UDim2.fromOffset(180,82); content.Size=UDim2.new(1,-192,1,-94); content.BackgroundTransparency=1; content.Parent=main

local pages={}; local nav={}
local function page(name)
    local p=Instance.new("ScrollingFrame"); p.Name=name; p.Size=UDim2.fromScale(1,1); p.BackgroundTransparency=1; p.BorderSizePixel=0; p.ScrollBarThickness=3; p.Visible=false; p.Parent=content
    local l=Instance.new("UIListLayout"); l.Padding=UDim.new(0,10); l.Parent=p; l:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() p.CanvasSize=UDim2.fromOffset(0,l.AbsoluteContentSize.Y+10) end)
    pages[name]=p; return p
end
local function navButton(name,icon)
    local b=button(side,icon.."   "..name,function() selectTab(name) end,42); nav[name]=b; return b
end
local function card(p,h)
    local f=Instance.new("Frame"); f.Size=UDim2.new(1,-2,0,h or 72); f.BackgroundColor3=C.card; f.Parent=p; corner(f,12); stroke(f,.82); return f
end

local home=page("Home"); local playerPage=page("Player"); local visuals=page("Visuals"); local tools=page("Tools"); local settings=page("Settings")

local welcome=card(home,118); local a=label(welcome,"NagiHub V2",22); a.Position=UDim2.fromOffset(18,14); a.Size=UDim2.new(1,-36,30,0); a.Font=Enum.Font.GothamBold
local b=label(welcome,"Premium utility interface for your own Roblox experience.",13,C.muted); b.Position=UDim2.fromOffset(18,49); b.Size=UDim2.new(1,-36,22,0)
local c=label(welcome,"Local-only • Studio friendly • No remote loader",11,C.good); c.Position=UDim2.fromOffset(18,82); c.Size=UDim2.new(1,-36,20,0)
local stats=card(home,92); local st=label(stats,"SESSION",11,C.muted); st.Position=UDim2.fromOffset(18,12); st.Size=UDim2.fromOffset(120,18)
local sv=label(stats,"Ready",17,C.text); sv.Position=UDim2.fromOffset(18,35); sv.Size=UDim2.fromOffset(180,25)
local clock=label(stats,"",12,C.muted); clock.Position=UDim2.new(1,-200,0,35); clock.Size=UDim2.fromOffset(180,22); clock.TextXAlignment=Enum.TextXAlignment.Right
RunService.RenderStepped:Connect(function() if clock.Parent then clock.Text=string.format("FPS %.0f",1/math.max(RunService.RenderStepped:Wait(),.001)) end end)

local function humanoid() local ch=player.Character; return ch and ch:FindFirstChildOfClass("Humanoid") end
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
slider(playerPage,"WalkSpeed",8,100,16,function(v) local h=humanoid(); if h then h.WalkSpeed=v end end)
slider(playerPage,"JumpPower",25,150,50,function(v) local h=humanoid(); if h then h.UseJumpPower=true; h.JumpPower=v end end)
button(playerPage,"↺  Reset movement",function() local h=humanoid(); if h then h.WalkSpeed=16; h.UseJumpPower=true; h.JumpPower=50 end; notify("Movement reset") end)
local sprint=false
button(playerPage,"⚡  Toggle sprint",function() sprint=not sprint; local h=humanoid(); if h then h.WalkSpeed=sprint and 28 or 16 end; notify(sprint and "Sprint ON" or "Sprint OFF") end)

local vtitle=label(visuals,"PLAYERS",11,C.muted); vtitle.Size=UDim2.new(1,0,0,20); vtitle.Font=Enum.Font.GothamBold
local plist=card(visuals,220); local scroll=Instance.new("ScrollingFrame"); scroll.Position=UDim2.fromOffset(12,12); scroll.Size=UDim2.new(1,-24,1,-24); scroll.BackgroundTransparency=1; scroll.BorderSizePixel=0; scroll.ScrollBarThickness=2; scroll.Parent=plist
local layout=Instance.new("UIListLayout"); layout.Padding=UDim.new(0,6); layout.Parent=scroll
local function refresh()
    for _,x in ipairs(scroll:GetChildren()) do if x:IsA("TextButton") then x:Destroy() end end
    for _,other in ipairs(Players:GetPlayers()) do
        local x=button(scroll,"  "..other.DisplayName.."  ("..other.Name..")",function() local r=other.Character and other.Character:FindFirstChild("HumanoidRootPart"); local me=player.Character and player.Character:FindFirstChild("HumanoidRootPart"); if r and me then me.CFrame=r.CFrame+Vector3.new(3,0,0); notify("Moved near "..other.DisplayName) end end,34); x.TextXAlignment=Enum.TextXAlignment.Left
    end
end
refresh(); Players.PlayerAdded:Connect(refresh); Players.PlayerRemoving:Connect(refresh)

local t=label(tools,"TOOLS",11,C.muted); t.Size=UDim2.new(1,0,0,20); t.Font=Enum.Font.GothamBold
button(tools,"📍  Copy current position to output",function() local r=player.Character and player.Character:FindFirstChild("HumanoidRootPart"); if r then print("NagiHub Position:",r.Position); notify("Position printed to Output") end end)
button(tools,"🔄  Respawn character",function() local h=humanoid(); if h then h.Health=0 end end)
button(tools,"🔔  Notification test",function() notify("NagiHub V2 is working") end)
button(tools,"🧹  Clear hub notices",function() for _,x in ipairs(gui:GetChildren()) do if x:IsA("TextLabel") and x~=clock and x~=title and x~=sub and x~=status then if x.Position.Y.Scale==0 then x:Destroy() end end end end)

local q=label(settings,"INTERFACE",11,C.muted); q.Size=UDim2.new(1,0,0,20); q.Font=Enum.Font.GothamBold
button(settings,"👁  Hide window",function() main.Visible=false end)
button(settings,"🎯  Reset window position",function() main.Position=UDim2.fromScale(.5,.5); notify("Position reset") end)
button(settings,"↔  Compact mode",function() main.Size=UDim2.fromOffset(650,420); notify("Compact mode") end)
button(settings,"▣  Full mode",function() main.Size=UDim2.fromOffset(760,480); notify("Full mode") end)

navButton("Home","◆"); navButton("Player","◇"); navButton("Visuals","◈"); navButton("Tools","▣"); navButton("Settings","⚙")
function selectTab(name)
    for n,p in pairs(pages) do p.Visible=(n==name) end
    for n,bx in pairs(nav) do bx.BackgroundColor3=(n==name) and Color3.fromRGB(40,52,82) or C.card end
end
selectTab("Home")

-- Drag window from header.
local dragging=false; local dragStart; local startPos
top.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=true; dragStart=i.Position; startPos=main.Position end end)
UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=false end end)
UIS.InputChanged:Connect(function(i) if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then local d=i.Position-dragStart; main.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y) end end)

-- Re-open button when the main window is hidden.
local reopen=Instance.new("TextButton"); reopen.AnchorPoint=Vector2.new(0,1); reopen.Position=UDim2.new(0,18,1,-18); reopen.Size=UDim2.fromOffset(118,38); reopen.BackgroundColor3=C.panel; reopen.Text="NAGI HUB"; reopen.TextColor3=C.text; reopen.TextSize=13; reopen.Font=Enum.Font.GothamBold; reopen.Visible=false; reopen.Parent=gui; corner(reopen,10); stroke(reopen,.4)
close.MouseButton1Click:Connect(function() main.Visible=false; reopen.Visible=true end)
reopen.MouseButton1Click:Connect(function() main.Visible=true; reopen.Visible=false end)
notify("NagiHub V2 loaded")
