local P,L,R,TS,RS,Pl=game:GetService("Players").LocalPlayer,game:GetService("Lighting"),game:GetService("RunService"),game:GetService("TweenService"),game:GetService("ReplicatedStorage"),game:GetService("Players")
local lang,isOpen,korblox,headless,espEnabled,noclipEnabled,flyEnabled,infJumpEnabled,currentTab,skyIdx,animIdx,menuMusicPlaying,speedEnabled,jumpBoostEnabled,cloneSkinEnabled = "RU",true,false,false,false,false,false,false,"Visual",1,1,true,false,false,false

local SkyList={
	{RU="Обычное небо",EN="Default Sky",id=nil},
	{RU="Фиолетовая туманность",EN="Purple Nebula",id="159454299"},
	{RU="Космос Галактика",EN="Space Galaxy",id="159454286"},
	{RU="Розовый закат",EN="Pink Sunset",id="271042310"},
	{RU="Ночное небо",EN="Night Sky",id="12064107"},
	{RU="Синие облака",EN="Blue Cloud",id="159454290"},
	{RU="Красное небо",EN="Red Sky",id="151165214"},
	{RU="Вэйпорвейв",EN="Vaporwave",id="1417494402"},
	{RU="Киберпанк",EN="Cyberpunk",id="261556948"},
	{RU="Аниме закат",EN="Anime Sunset",id="4944686445"},
	{RU="Темная пустота",EN="Dark Void",id="268301540"}
}

local soundObj = Instance.new("Sound")
soundObj.Name = "GooseHubRelaxingMusic"
soundObj.SoundId = "rbxassetid://1848354536"
soundObj.Volume = 0.5
soundObj.Looped = true
soundObj.Parent = P:WaitForChild("PlayerGui")
soundObj:Play()

local originalAnims = {}
local function saveOriginalAnims(c)
	local a = c:WaitForChild("Animate", 5) if not a then return end
	task.wait(0.2) originalAnims = {}
	for _, f in ipairs(a:GetChildren()) do
		if f:IsA("Configuration") or f:IsA("Folder") or f:IsA("StringValue") then
			originalAnims[f.Name] = {}
			for _, ch in ipairs(f:GetChildren()) do
				if ch:IsA("Animation") then table.insert(originalAnims[f.Name], {name = ch.Name, id = ch.AnimationId}) end
			end
		end
	end
end

local AnimPacks={
	{RU="Обычный (Свой)",EN="Default (Own)",ids=nil},
	{RU="Ниндзя",EN="Ninja",ids={idle1="656117400",idle2="656118341",walk="656121766",run="656118852",jump="656117878",fall="656115606",climb="656114359",swim="656119721"}},
	{RU="Игрушка",EN="Toy",ids={idle1="782841498",idle2="782845736",walk="782843345",run="782842708",jump="782847020",fall="782846423",climb="782843869",swim="782844582"}},
	{RU="Зомби",EN="Zombie",ids={idle1="616158929",idle2="616160103",walk="616168032",run="616163682",jump="616161997",fall="616157476",climb="616156119",swim="616165109"}},
	{RU="Астронавт",EN="Astronaut",ids={idle1="891621366",idle2="891633237",walk="891667138",run="891636393",jump="891627522",fall="891617961",climb="891609353",swim="891651882"}}
}

local T={
	RU={Title="УНИВЕРСАЛЬНОЕ МЕНЮ",Auth="TikTok:ScriptVFXK",TabVisual="Визуал",TabPlayer="Игрок",TabMods="MODS",TabGrok="Grok AI",Sky="Небо: ",MenuMusic="Музыка меню: ",Anim="Пак аниме: ",InfJump="Бесконечный прыжок: ",NC="Ноклип: ",FLY="Полёт: ",Speed="Быстрый бег: ",JumpBoost="Супер прыжок: ",TP="Телепорт к игроку",TPPlaceholder="Введите ник игрока...",CloneSkin="Клонировать скин (Визуал)",GrokPlaceholder="Спроси Grok о чем угодно...",GrokSend="Спросить",ON="Вкл",OFF="Выкл",UserTag="Юзер скрипт"},
	EN={Title="UNIVERSAL MENU",Auth="TikTok:ScriptVFXK",TabVisual="Visual",TabPlayer="Player",TabMods="MODS",TabGrok="Grok AI",Sky="Sky: ",MenuMusic="Menu Music: ",Anim="Anim Pack: ",InfJump="Infinite Jump: ",NC="Noclip: ",FLY="Fly: ",Speed="Fast Speed: ",JumpBoost="Super Jump: ",TP="Teleport to Player",TPPlaceholder="Enter player username...",CloneSkin="Clone Skin (Visual)",GrokPlaceholder="Ask Grok anything...",GrokSend="Ask",ON="ON",OFF="OFF",UserTag="User script"}
}

local function cObj(cls,p,props) local o=Instance.new(cls) for k,v in pairs(props) do o[k]=v end o.Parent=p return o end
local function tw(o,t,p) TS:Create(o,TweenInfo.new(t,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),p):Play() end

local userTags = {}
local function createHeadTag(plr)
	if not plr or not plr.Character then return end
	local head = plr.Character:WaitForChild("Head", 5) if not head then return end
	local old = head:FindFirstChild("GooseScriptUserTag") if old then old:Destroy() end
	local bg = cObj("BillboardGui", head, {Name="GooseScriptUserTag", Adornee=head, Size=UDim2.new(0,150,0,30), StudsOffset=Vector3.new(0,2.5,0), AlwaysOnTop=true})
	userTags[plr] = cObj("TextLabel", bg, {Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Text=T[lang].UserTag, TextColor3=Color3.fromRGB(255,215,0), TextStrokeTransparency=0.2, TextStrokeColor3=Color3.new(0,0,0), Font=Enum.Font.GothamBold, TextSize=13})
end

local Remote = RS:FindFirstChild("GooseHubScriptUsers") or cObj("Folder", RS, {Name="GooseHubScriptUsers"})
local function markUser(plr) createHeadTag(plr) plr.CharacterAdded:Connect(function() task.wait(1) createHeadTag(plr) end) end
cObj("ObjectValue", Remote, {Name=P.Name, Value=P})
Remote.ChildAdded:Connect(function(c) if c:IsA("ObjectValue") and c.Value then markUser(c.Value) end end)
for _, c in ipairs(Remote:GetChildren()) do if c:IsA("ObjectValue") and c.Value then markUser(c.Value) end end

local function applyESP(plr, char)
	if not char then return end
	local old = char:FindFirstChild("GooseESPHighlight") if old then old:Destroy() end
	if espEnabled then
		local isSelf = (plr == P)
		cObj("Highlight", char, {Name="GooseESPHighlight", DepthMode=Enum.HighlightDepthMode.AlwaysOnTop, FillColor=isSelf and Color3.fromRGB(150,150,150) or Color3.fromRGB(0,255,100), OutlineColor=Color3.new(1,1,1), FillTransparency=0.3, Parent=char})
	end
end

local function updateESP() for _, plr in ipairs(Pl:GetPlayers()) do if plr.Character then applyESP(plr, plr.Character) end end end
Pl.PlayerAdded:Connect(function(plr) plr.CharacterAdded:Connect(function(char) task.wait(0.5) if espEnabled then applyESP(plr, char) end end) end)

-- Хранилище оригинального внешнего вида игроков для полного восстановления
local originalPlayerLooks = {}

local function savePlayerOriginalLook(targetChar, targetPlayer)
	if originalPlayerLooks[targetPlayer] then return end
	local lookData = {
		accessories = {},
		clothing = {},
		bodyColors = nil,
		characterMeshes = {},
		parts = {},
		face = nil
	}
	
	for _, child in ipairs(targetChar:GetChildren()) do
		if child:IsA("Accessory") then
			table.insert(lookData.accessories, child:Clone())
		elseif child:IsA("Clothing") then
			table.insert(lookData.clothing, child:Clone())
		elseif child:IsA("BodyColors") then
			lookData.bodyColors = child:Clone()
		elseif child:IsA("CharacterMesh") then
			table.insert(lookData.characterMeshes, child:Clone())
		elseif child:IsA("BasePart") then
			lookData.parts[child.Name] = {
				Color = child.Color,
				Material = child.Material,
				Transparency = child.Transparency
			}
			local head = targetChar:FindFirstChild("Head")
			if head then
				local decal = head:FindFirstChildOfClass("Decal")
				if decal then
					lookData.face = decal:Clone()
				end
			end
		end
	end
	originalPlayerLooks[targetPlayer] = lookData
end

local function restorePlayerLook(targetChar, targetPlayer)
	local lookData = originalPlayerLooks[targetPlayer]
	if not lookData then return end
	
	-- Очищаем текущие скопированные вещи/тело
	for _, child in ipairs(targetChar:GetChildren()) do
		if child:IsA("Accessory") or child:IsA("Clothing") or child:IsA("BodyColors") or child:IsA("CharacterMesh") then
			child:Destroy()
		end
	end
	
	-- Возвращаем сохраненные аксессуары и одежду
	for _, acc in ipairs(lookData.accessories) do
		acc:Clone().Parent = targetChar
	end
	for _, cloth in ipairs(lookData.clothing) do
		cloth:Clone().Parent = targetChar
	end
	if lookData.bodyColors then
		lookData.bodyColors:Clone().Parent = targetChar
	end
	for _, mesh in ipairs(lookData.characterMeshes) do
		mesh:Clone().Parent = targetChar
	end
	
	-- Возвращаем цвета и материалы частей тела
	for _, child in ipairs(targetChar:GetChildren()) do
		if child:IsA("BasePart") and lookData.parts[child.Name] then
			child.Color = lookData.parts[child.Name].Color
			child.Material = lookData.parts[child.Name].Material
			child.Transparency = lookData.parts[child.Name].Transparency
		end
	end
	
	-- Возвращаем лицо
	local head = targetChar:FindFirstChild("Head")
	if head then
		local oldDecal = head:FindFirstChildOfClass("Decal")
		if oldDecal then oldDecal:Destroy() end
		if lookData.face then
			lookData.face:Clone().Parent = head
		end
	end
	
	originalPlayerLooks[targetPlayer] = nil
end

local function applyCloneSkinToCharacter(targetChar, targetPlayer)
	if not cloneSkinEnabled or not P.Character or targetChar == P.Character then return end
	
	-- Сохраняем оригинал перед изменением
	savePlayerOriginalLook(targetChar, targetPlayer)
	
	-- Удаляем старую одежду, аксессуары, меши и телесный цвет у целевого игрока
	for _, child in ipairs(targetChar:GetChildren()) do
		if child:IsA("Accessory") or child:IsA("Clothing") or child:IsA("BodyColors") or child:IsA("CharacterMesh") then
			child:Destroy()
		end
	end
	
	-- Убираем старое лицо с головы
	local targetHead = targetChar:FindFirstChild("Head")
	if targetHead then
		for _, d in ipairs(targetHead:GetChildren()) do
			if d:IsA("Decal") then d:Destroy() end
		end
	end
	
	-- Копируем абсолютно всё (аксессуары, одежду, цвета, меши, лицо) от нашего персонажа
	for _, child in ipairs(P.Character:GetChildren()) do
		if child:IsA("Accessory") or child:IsA("Clothing") or child:IsA("BodyColors") or child:IsA("CharacterMesh") then
			child:Clone().Parent = targetChar
		elseif child:IsA("BasePart") then
			local targetPart = targetChar:FindFirstChild(child.Name)
			if targetPart and targetPart:IsA("BasePart") then
				targetPart.Color = child.Color
				targetPart.Material = child.Material
				targetPart.Transparency = child.Transparency
			end
		end
	end
	
	-- Копируем лицо с нашей головы
	local myHead = P.Character:FindFirstChild("Head")
	if myHead and targetHead then
		local myDecal = myHead:FindFirstChildOfClass("Decal")
		if myDecal then
			myDecal:Clone().Parent = targetHead
		end
	end
end

local function updateCloneSkin()
	for _, plr in ipairs(Pl:GetPlayers()) do
		if plr ~= P and plr.Character then
			if cloneSkinEnabled then
				applyCloneSkinToCharacter(plr.Character, plr)
			else
				restorePlayerLook(plr.Character, plr)
			end
		end
	end
end

Pl.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function(char)
		task.wait(1)
		if cloneSkinEnabled then
			applyCloneSkinToCharacter(char, plr)
		end
	end)
end)

local bg, bv = nil, nil

R.Stepped:Connect(function()
	if noclipEnabled and P.Character then
		local hrp = P.Character:FindFirstChild("HumanoidRootPart")
		if hrp then
			for _, part in ipairs(P.Character:GetDescendants()) do
				if part:IsA("BasePart") then part.CanCollide = false end
			end
		end
	end

	local c = P.Character
	if c and c:FindFirstChildOfClass("Humanoid") then
		local hum = c:FindFirstChildOfClass("Humanoid")
		if speedEnabled then hum.WalkSpeed = 35 else hum.WalkSpeed = 16 end
		if jumpBoostEnabled then hum.JumpPower = 100 else hum.JumpPower = 50 end
	end

	if flyEnabled and c and c:FindFirstChild("HumanoidRootPart") and c:FindFirstChildOfClass("Humanoid") then
		local hrp = c.HumanoidRootPart
		local hum = c:FindFirstChildOfClass("Humanoid")
		local cam = workspace.CurrentCamera
		
		if not bg or not bv or bg.Parent ~= hrp then
			if bg then bg:Destroy() end
			if bv then bv:Destroy() end
			
			bg = Instance.new("BodyGyro")
			bg.P = 9e4
			bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
			bg.Parent = hrp
			
			bv = Instance.new("BodyVelocity")
			bv.velocity = Vector3.new(0, 0, 0)
			bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
			bv.Parent = hrp
			
			hum.PlatformStand = true
		end
		
		local camLook = cam.CFrame.LookVector
		bg.cframe = CFrame.new(hrp.Position, hrp.Position + Vector3.new(camLook.X, 0, camLook.Z))
		
		local moveDir = hum.MoveDirection
		local speed = 50
		if math.random(1, 10) == 1 then
			speed = math.random(10, 90)
		end
		
		if moveDir.Magnitude > 0 then
			bv.velocity = (cam.CFrame.RightVector * moveDir.X + cam.CFrame.LookVector * moveDir.Z) * speed + Vector3.new(0, camLook.Y * moveDir.Z * speed, 0)
		else
			bv.velocity = Vector3.new(0, math.random(-2, 2), 0)
		end
	else
		if bg then bg:Destroy() bg = nil end
		if bv then bv:Destroy() bv = nil end
		if c and c:FindFirstChildOfClass("Humanoid") then
			local hum = c:FindFirstChildOfClass("Humanoid")
			if hum.PlatformStand then
				hum.PlatformStand = false
			end
		end
	end
end)

game:GetService("UserInputService").JumpRequest:Connect(function()
	if infJumpEnabled and P.Character then
		local hum = P.Character:FindFirstChildOfClass("Humanoid")
		if hum then
			hum:ChangeState(Enum.HumanoidStateType.Jumping)
		end
	end
end)

local Gui = cObj("ScreenGui", P:WaitForChild("PlayerGui"), {Name="GooseHub", ResetOnSpawn=false})
local DragBtn = cObj("TextButton", Gui, {Size=UDim2.new(0,42,0,42), Position=UDim2.new(0.02,0,0.2,0), BackgroundColor3=Color3.fromRGB(20,20,28), Text="✨", TextSize=18, Font=Enum.Font.Gotham, Active=true, Draggable=true})
cObj("UICorner", DragBtn, {CornerRadius=UDim.new(1,0)})
local DragStroke = cObj("UIStroke", DragBtn, {Color=Color3.fromRGB(255,200,100), Thickness=2})

local Main = cObj("Frame", Gui, {Size=UDim2.new(0,300,0,400), Position=UDim2.new(0.02,0,0.28,0), BackgroundColor3=Color3.fromRGB(15,15,22), Active=true, Draggable=true, ClipsDescendants=true})
cObj("UICorner", Main, {CornerRadius=UDim.new(0,16)})
local MainStroke = cObj("UIStroke", Main, {Color=Color3.fromRGB(255,180,80), Thickness=1.5})
local GooseImg = cObj("ImageLabel", Main, {Size=UDim2.new(1.1,0,1.1,0), Position=UDim2.new(-0.05,0,-0.05,0), Image="rbxassetid://9459521367", ImageTransparency=0.5, BackgroundTransparency=1, ScaleType=Enum.ScaleType.Crop})
local Title = cObj("TextLabel", Main, {Size=UDim2.new(1,0,0,35), BackgroundColor3=Color3.fromRGB(30,25,35), BackgroundTransparency=0.4, TextSize=13, Font=Enum.Font.Gotham, ZIndex=5})
cObj("UICorner", Title, {CornerRadius=UDim.new(0,16)})

local TabBar = cObj("ScrollingFrame", Main, {Size=UDim2.new(1,-14,0,32), Position=UDim2.new(0,7,0,38), BackgroundTransparency=1, CanvasSize=UDim2.new(0,390,0,0), ScrollBarThickness=0, Active=false, ZIndex=10})
local TabVisualBtn = cObj("TextButton", TabBar, {Size=UDim2.new(0,90,1,-2), Position=UDim2.new(0,0,0,0), BackgroundColor3=Color3.fromRGB(45,35,60), BackgroundTransparency=0.2, TextColor3=Color3.fromRGB(255,220,150), TextSize=10, Font=Enum.Font.GothamBold, ZIndex=11})
cObj("UICorner", TabVisualBtn, {CornerRadius=UDim.new(0,8)})
local TabPlayerBtn = cObj("TextButton", TabBar, {Size=UDim2.new(0,90,1,-2), Position=UDim2.new(0,94,0,0), BackgroundColor3=Color3.fromRGB(25,20,35), BackgroundTransparency=0.4, TextColor3=Color3.fromRGB(180,180,180), TextSize=10, Font=Enum.Font.GothamBold, ZIndex=11})
cObj("UICorner", TabPlayerBtn, {CornerRadius=UDim.new(0,8)})
local TabModsBtn = cObj("TextButton", TabBar, {Size=UDim2.new(0,90,1,-2), Position=UDim2.new(0,188,0,0), BackgroundColor3=Color3.fromRGB(25,20,35), BackgroundTransparency=0.4, TextColor3=Color3.fromRGB(180,180,180), TextSize=10, Font=Enum.Font.GothamBold, ZIndex=11})
cObj("UICorner", TabModsBtn, {CornerRadius=UDim.new(0,8)})
local TabGrokBtn = cObj("TextButton", TabBar, {Size=UDim2.new(0,90,1,-2), Position=UDim2.new(0,282,0,0), BackgroundColor3=Color3.fromRGB(25,20,35), BackgroundTransparency=0.4, TextColor3=Color3.fromRGB(180,180,180), TextSize=10, Font=Enum.Font.GothamBold, ZIndex=11})
cObj("UICorner", TabGrokBtn, {CornerRadius=UDim.new(0,8)})

local ScrollVisual = cObj("ScrollingFrame", Main, {Size=UDim2.new(1,0,1,-90), Position=UDim2.new(0,0,0,72), BackgroundTransparency=1, CanvasSize=UDim2.new(0,0,0,360), ScrollBarThickness=4, ScrollBarImageColor3=Color3.fromRGB(255,200,100), Active=true, Visible=true, ZIndex=3})
local ScrollPlayer = cObj("ScrollingFrame", Main, {Size=UDim2.new(1,0,1,-90), Position=UDim2.new(0,0,0,72), BackgroundTransparency=1, CanvasSize=UDim2.new(0,0,0,360), ScrollBarThickness=4, ScrollBarImageColor3=Color3.fromRGB(255,200,100), Active=true, Visible=false, ZIndex=3})
local ScrollMods = cObj("ScrollingFrame", Main, {Size=UDim2.new(1,0,1,-90), Position=UDim2.new(0,0,0,72), BackgroundTransparency=1, CanvasSize=UDim2.new(0,0,0,360), ScrollBarThickness=4, ScrollBarImageColor3=Color3.fromRGB(255,200,100), Active=true, Visible=false, ZIndex=3})
local ScrollGrok = cObj("ScrollingFrame", Main, {Size=UDim2.new(1,0,1,-90), Position=UDim2.new(0,0,0,72), BackgroundTransparency=1, CanvasSize=UDim2.new(0,0,0,360), ScrollBarThickness=4, ScrollBarImageColor3=Color3.fromRGB(255,200,100), Active=true, Visible=false, ZIndex=3})

local Auth = cObj("TextLabel", Main, {Size=UDim2.new(1,0,0,15), Position=UDim2.new(0,0,1,-18), BackgroundTransparency=1, TextColor3=Color3.fromRGB(255,220,150), TextSize=10, Font=Enum.Font.Gotham, ZIndex=5})

local function btn(p,y,bg)
	local b = cObj("TextButton", p, {Size=UDim2.new(0.7,0,0,36), Position=UDim2.new(0.15,0,0,y), BackgroundColor3=bg, BackgroundTransparency=0.3, TextColor3=Color3.new(1,1,1), TextSize=12, Font=Enum.Font.Gotham, ZIndex=4})
	cObj("UICorner", b, {CornerRadius=UDim.new(0,10)})
	cObj("UIStroke", b, {Color=Color3.fromRGB(255,220,150), Transparency=0.7, Thickness=1})
	return b
end
local function navBtn(p,y,txt,x)
	local b = cObj("TextButton", p, {Size=UDim2.new(0,30,0,36), Position=UDim2.new(x,0,0,y), BackgroundColor3=Color3.fromRGB(40,35,50), BackgroundTransparency=0.3, Text=txt, TextColor3=Color3.fromRGB(255,220,150), TextSize=14, Font=Enum.Font.GothamBold, ZIndex=4})
	cObj("UICorner", b, {CornerRadius=UDim.new(0,8)})
	return b
end

local LangB = btn(ScrollVisual,10,Color3.fromRGB(50,40,65)) LangB.Size,LangB.Position = UDim2.new(0.86,0,0,36),UDim2.new(0.07,0,0,10)
local SkyPrev,SkyB,SkyNext = navBtn(ScrollVisual,60,"◄",0.04),btn(ScrollVisual,60,Color3.fromRGB(75,50,85)),navBtn(ScrollVisual,60,"►",0.86)
local MenuMusicB = btn(ScrollVisual,110,Color3.fromRGB(40,130,75)) MenuMusicB.Size,MenuMusicB.Position = UDim2.new(0.86,0,0,36),UDim2.new(0.07,0,0,110)
local KbB = btn(ScrollVisual,160,Color3.fromRGB(35,35,50)) KbB.Size,KbB.Position = UDim2.new(0.86,0,0,36),UDim2.new(0.07,0,0,160)
local HlB = btn(ScrollVisual,210,Color3.fromRGB(35,35,50)) HlB.Size,HlB.Position = UDim2.new(0.86,0,0,36),UDim2.new(0.07,0,0,210)
local EspB = btn(ScrollVisual,260,Color3.fromRGB(35,35,50)) EspB.Size,EspB.Position = UDim2.new(0.86,0,0,36),UDim2.new(0.07,0,0,260)

local LangPlayerB = btn(ScrollPlayer,10,Color3.fromRGB(50,40,65)) LangPlayerB.Size,LangPlayerB.Position = UDim2.new(0.86,0,0,36),UDim2.new(0.07,0,0,10)
local AnimPrev,AnimB,AnimNext = navBtn(ScrollPlayer,60,"◄",0.04),btn(ScrollPlayer,60,Color3.fromRGB(55,40,85)),navBtn(ScrollPlayer,60,"►",0.86)
local InfJumpB = btn(ScrollPlayer,110,Color3.fromRGB(35,35,50)) InfJumpB.Size,InfJumpB.Position = UDim2.new(0.86,0,0,36),UDim2.new(0.07,0,0,110)
local NcB = btn(ScrollPlayer,160,Color3.fromRGB(35,35,50)) NcB.Size,NcB.Position = UDim2.new(0.86,0,0,36),UDim2.new(0.07,0,0,160)
local FlyB = btn(ScrollPlayer,210,Color3.fromRGB(35,35,50)) FlyB.Size,FlyB.Position = UDim2.new(0.86,0,0,36),UDim2.new(0.07,0,0,210)
local SpeedB = btn(ScrollPlayer,260,Color3.fromRGB(35,35,50)) SpeedB.Size,SpeedB.Position = UDim2.new(0.86,0,0,36),UDim2.new(0.07,0,0,260)
local JumpBoostB = btn(ScrollPlayer,310,Color3.fromRGB(35,35,50)) JumpBoostB.Size,JumpBoostB.Position = UDim2.new(0.86,0,0,36),UDim2.new(0.07,0,0,310)

local TpBox = cObj("TextBox", ScrollPlayer, {Size=UDim2.new(0.86,0,0,36), Position=UDim2.new(0.07,0,0,360), BackgroundColor3=Color3.fromRGB(35,35,50), BackgroundTransparency=0.3, Text="", TextColor3=Color3.new(1,1,1), PlaceholderColor3=Color3.fromRGB(150,150,150), TextSize=12, Font=Enum.Font.Gotham, ZIndex=4})
cObj("UICorner", TpBox, {CornerRadius=UDim.new(0,10)})
cObj("UIStroke", TpBox, {Color=Color3.fromRGB(255,220,150), Transparency=0.7, Thickness=1})
local TpB = btn(ScrollPlayer,410,Color3.fromRGB(40,110,130)) TpB.Size,TpB.Position = UDim2.new(0.86,0,0,36),UDim2.new(0.07,0,0,410)
ScrollPlayer.CanvasSize = UDim2.new(0,0,0,460)

local LangModsB = btn(ScrollMods,10,Color3.fromRGB(50,40,65)) LangModsB.Size,LangModsB.Position = UDim2.new(0.86,0,0,36),UDim2.new(0.07,0,0,10)
local CloneSkinB = btn(ScrollMods,60,Color3.fromRGB(35,35,50)) CloneSkinB.Size,CloneSkinB.Position = UDim2.new(0.86,0,0,36),UDim2.new(0.07,0,0,60)
ScrollMods.CanvasSize = UDim2.new(0,0,0,120)

local GrokScroll = cObj("ScrollingFrame", ScrollGrok, {Size=UDim2.new(0.86,0,0,220), Position=UDim2.new(0.07,0,0,10), BackgroundColor3=Color3.fromRGB(20,20,30), BackgroundTransparency=0.4, CanvasSize=UDim2.new(0,0,0,0), ScrollBarThickness=4, ZIndex=4})
cObj("UICorner", GrokScroll, {CornerRadius=UDim.new(0,10)})
cObj("UIStroke", GrokScroll, {Color=Color3.fromRGB(255,220,150), Transparency=0.7, Thickness=1})
local GrokUIList = cObj("UIListLayout", GrokScroll, {SortOrder=Enum.SortOrder.LayoutOrder, Padding=UDim.new(0,5)})

local GrokBox = cObj("TextBox", ScrollGrok, {Size=UDim2.new(0.6,0,0,36), Position=UDim2.new(0.07,0,0,240), BackgroundColor3=Color3.fromRGB(35,35,50), BackgroundTransparency=0.3, Text="", TextColor3=Color3.new(1,1,1), PlaceholderColor3=Color3.fromRGB(150,150,150), TextSize=12, Font=Enum.Font.Gotham, ZIndex=4})
cObj("UICorner", GrokBox, {CornerRadius=UDim.new(0,10)})
cObj("UIStroke", GrokBox, {Color=Color3.fromRGB(255,220,150), Transparency=0.7, Thickness=1})
local GrokSendB = btn(ScrollGrok,240,Color3.fromRGB(110,40,130)) GrokSendB.Size,GrokSendB.Position = UDim2.new(0.24,0,0,36),UDim2.new(0.69,0,0,240)

local hue,t = 0,0
R.RenderStepped:Connect(function(dt)
	hue,t = (hue+dt*0.25)%1, t+dt
	local c = Color3.fromHSV(hue,0.55,1)
	Title.TextColor3,DragBtn.TextColor3,DragStroke.Color,MainStroke.Color = c,c,c,c
	GooseImg.Position = UDim2.new(-0.05,math.sin(t*1.5)*5,-0.05,math.cos(t*1.5)*5)
end)

local function switchTab(tab)
	currentTab = tab
	ScrollVisual.Visible = (tab == "Visual")
	ScrollPlayer.Visible = (tab == "Player")
	ScrollMods.Visible = (tab == "Mods")
	ScrollGrok.Visible = (tab == "Grok")
	
	TabVisualBtn.BackgroundColor3 = (tab == "Visual" and Color3.fromRGB(45,35,60) or Color3.fromRGB(25,20,35))
	TabVisualBtn.TextColor3 = (tab == "Visual" and Color3.fromRGB(255,220,150) or Color3.fromRGB(180,180,180))
	
	TabPlayerBtn.BackgroundColor3 = (tab == "Player" and Color3.fromRGB(45,35,60) or Color3.fromRGB(25,20,35))
	TabPlayerBtn.TextColor3 = (tab == "Player" and Color3.fromRGB(255,220,150) or Color3.fromRGB(180,180,180))

	TabModsBtn.BackgroundColor3 = (tab == "Mods" and Color3.fromRGB(45,35,60) or Color3.fromRGB(25,20,35))
	TabModsBtn.TextColor3 = (tab == "Mods" and Color3.fromRGB(255,220,150) or Color3.fromRGB(180,180,180))
	
	TabGrokBtn.BackgroundColor3 = (tab == "Grok" and Color3.fromRGB(45,35,60) or Color3.fromRGB(25,20,35))
	TabGrokBtn.TextColor3 = (tab == "Grok" and Color3.fromRGB(255,220,150) or Color3.fromRGB(180,180,180))
end

TabVisualBtn.MouseButton1Click:Connect(function() switchTab("Visual") end)
TabPlayerBtn.MouseButton1Click:Connect(function() switchTab("Player") end)
TabModsBtn.MouseButton1Click:Connect(function() switchTab("Mods") end)
TabGrokBtn.MouseButton1Click:Connect(function() switchTab("Grok") end)

local function updateUI()
	local d = T[lang]
	Title.Text = d.Title
	Auth.Text = "TikTok:ScriptVFXK"
	TabVisualBtn.Text = "👁️ " .. d.TabVisual
	TabPlayerBtn.Text = "👤 " .. d.TabPlayer
	TabModsBtn.Text = "⚡ " .. d.TabMods
	TabGrokBtn.Text = "🤖 " .. d.TabGrok
	LangB.Text = "🌐 Язык / Language: "..lang
	LangPlayerB.Text = "🌐 Язык / Language: "..lang
	LangModsB.Text = "🌐 Язык / Language: "..lang
	SkyB.Text = "🌌 "..d.Sky..SkyList[skyIdx][lang]
	MenuMusicB.Text = "🎵 "..d.MenuMusic..(menuMusicPlaying and d.ON or d.OFF)
	MenuMusicB.BackgroundColor3 = menuMusicPlaying and Color3.fromRGB(40,130,75) or Color3.fromRGB(35,35,50)
	KbB.Text,KbB.BackgroundColor3 = "🦵 Фейк Корблокс: "..(korblox and d.ON or d.OFF), korblox and Color3.fromRGB(40,130,75) or Color3.fromRGB(35,35,50)
	HlB.Text,HlB.BackgroundColor3 = "💀 Фейк Хедлесс: "..(headless and d.ON or d.OFF), headless and Color3.fromRGB(40,130,75) or Color3.fromRGB(35,35,50)
	EspB.Text,EspB.BackgroundColor3 = "👁️ ЕСП: "..(espEnabled and d.ON or d.OFF), espEnabled and Color3.fromRGB(40,130,75) or Color3.fromRGB(35,35,50)
	InfJumpB.Text,InfJumpB.BackgroundColor3 = "🦘 "..d.InfJump..(infJumpEnabled and d.ON or d.OFF), infJumpEnabled and Color3.fromRGB(40,130,75) or Color3.fromRGB(35,35,50)
	NcB.Text,NcB.BackgroundColor3 = "👻 "..d.NC..(noclipEnabled and d.ON or d.OFF), noclipEnabled and Color3.fromRGB(40,130,75) or Color3.fromRGB(35,35,50)
	FlyB.Text,FlyB.BackgroundColor3 = "🦸 "..d.FLY..(flyEnabled and d.ON or d.OFF), flyEnabled and Color3.fromRGB(40,130,75) or Color3.fromRGB(35,35,50)
	SpeedB.Text,SpeedB.BackgroundColor3 = "⚡ "..d.Speed..(speedEnabled and d.ON or d.OFF), speedEnabled and Color3.fromRGB(40,130,75) or Color3.fromRGB(35,35,50)
	JumpBoostB.Text,JumpBoostB.BackgroundColor3 = "🚀 "..d.JumpBoost..(jumpBoostEnabled and d.ON or d.OFF), jumpBoostEnabled and Color3.fromRGB(40,130,75) or Color3.fromRGB(35,35,50)
	TpBox.PlaceholderText = d.TPPlaceholder
	TpB.Text = "🎯 "..d.TP
	AnimB.Text = "🕺 "..d.Anim..AnimPacks[animIdx][lang]
	CloneSkinB.Text = "👥 "..d.CloneSkin..": "..(cloneSkinEnabled and d.ON or d.OFF)
	CloneSkinB.BackgroundColor3 = cloneSkinEnabled and Color3.fromRGB(40,130,75) or Color3.fromRGB(35,35,50)
	GrokBox.PlaceholderText = d.GrokPlaceholder
	GrokSendB.Text = d.GrokSend
	for _, l in pairs(userTags) do if l and l.Parent then l.Text = d.UserTag end end
end

local function setSky(i)
	local old = L:FindFirstChildOfClass("Sky") if old then old:Destroy() end
	if SkyList[i].id then
		local s,tex = Instance.new("Sky"),"rbxassetid://"..SkyList[i].id
		s.SkyboxBk,s.SkyboxDn,s.SkyboxFt,s.SkyboxLf,s.SkyboxRt,s.SkyboxUp = tex,tex,tex,tex,tex,tex s.Parent = L
	end
end
local function changeSky(dir) skyIdx=(skyIdx-1+dir+#SkyList)%#SkyList+1 setSky(skyIdx) updateUI() end
SkyNext.MouseButton1Click:Connect(function() changeSky(1) end)
SkyPrev.MouseButton1Click:Connect(function() changeSky(-1) end)
SkyB.MouseButton1Click:Connect(function() changeSky(1) end)

local function applyAnimPack(i)
	local c = P.Character if not c then return end
	local a = c:FindFirstChild("Animate") if not a then return end
	local pack = AnimPacks[i].ids
	for folderName, anims in pairs(originalAnims) do
		local folder = a:FindFirstChild(folderName)
		if folder then
			for _, child in ipairs(folder:GetChildren()) do
				if child:IsA("Animation") then
					if pack then
						for _, orig in ipairs(anims) do
							if orig.name == child.Name then
								local num = string.match(orig.name, "%d+") or "1"
								local newId = nil
								if folderName:lower():find("idle") then
									newId = (num == "2") and pack.idle2 or pack.idle1
								elseif folderName:lower():find("walk") then newId = pack.walk
								elseif folderName:lower():find("run") then newId = pack.run
								elseif folderName:lower():find("jump") then newId = pack.jump
								elseif folderName:lower():find("fall") then newId = pack.fall
								elseif folderName:lower():find("climb") then newId = pack.climb
								elseif folderName:lower():find("swim") then newId = pack.swim end
								if newId then child.AnimationId = "rbxassetid://"..newId end
							end
						end
					else
						for _, orig in ipairs(anims) do
							if orig.name == child.Name then child.AnimationId = orig.id end
						end
					end
				end
			end
		end
	end
	local hum = c:FindFirstChildOfClass("Humanoid")
	if hum then
		for _, tr in ipairs(hum:GetPlayingAnimationTracks()) do tr:Stop() end
	end
end

local function changeAnim(dir) animIdx=(animIdx-1+dir+#AnimPacks)%#AnimPacks+1 applyAnimPack(animIdx) updateUI() end
AnimNext.MouseButton1Click:Connect(function() changeAnim(1) end)
AnimPrev.MouseButton1Click:Connect(function() changeAnim(-1) end)
AnimB.MouseButton1Click:Connect(function() changeAnim(1) end)

MenuMusicB.MouseButton1Click:Connect(function()
	menuMusicPlaying = not menuMusicPlaying
	if menuMusicPlaying then
		soundObj:Play()
	else
		soundObj:Stop()
	end
	updateUI()
end)

local function addGrokMessage(sender, text, isAi)
	local msgLabel = cObj("TextLabel", GrokScroll, {
		Size = UDim2.new(1, -10, 0, 40),
		BackgroundTransparency = 1,
		TextColor3 = isAi and Color3.fromRGB(120, 220, 255) or Color3.fromRGB(255, 220, 150),
		TextSize = 11,
		Font = Enum.Font.Gotham,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		Text = (sender .. ": " .. text)
	})
	GrokScroll.CanvasSize = UDim2.new(0, 0, 0, GrokUIList.AbsoluteContentSize.Y + 20)
	GrokScroll.CanvasPosition = Vector2.new(0, GrokScroll.CanvasSize.Y.Offset)
end

addGrokMessage("Grok", (lang=="RU" and "Йоу! Я Grok — твой ультимативный ИИ. Спроси меня как дела, как меня зовут или о чем угодно!" or "Yo! I'm Grok — your ultimate AI. Ask me how I'm doing, my name, or anything else!"), true)

GrokSendB.MouseButton1Click:Connect(function()
	local txt = GrokBox.Text
	if txt == "" then return end
	addGrokMessage(P.Name, txt, false)
	GrokBox.Text = ""
	
	task.delay(0.4, function()
		local reply = ""
		local lower = string.lower(txt)
		
		if string.find(lower, "привет") or string.find(lower, "здаров") or string.find(lower, "хай") or string.find(lower, "hello") or string.find(lower, "hi") then
			reply = (lang=="RU" and "Привет-привет! Рад пообщаться. Как твое настроение и во что гоняем сегодня?" or "Hey there! Nice to chat. How's your mood and what are we playing today?")
		elseif string.find(lower, "как дела") or string.find(lower, "как ты") or string.find(lower, "how are you") then
			reply = (lang=="RU" and "У меня всё отлично, процессоры горячие, код крутится! Сам как поживаешь?" or "I'm doing great, processors are hot, code is spinning! How are you doing yourself?")
		elseif string.find(lower, "как тебя зовут") or string.find(lower, "кто ты") or string.find(lower, "твое имя") or string.find(lower, "what is your name") or string.find(lower, "who are you") then
			reply = (lang=="RU" and "Меня зовут Grok! Я твой личный ИИ-ассистент прямо внутри этого скрипта." or "My name is Grok! I'm your personal AI assistant right inside this script.")
		elseif string.find(lower, "ролокс") or string.find(lower, "roblox") or string.find(lower, "скрипт") then
			reply = (lang=="RU" and "Roblox — топовая игра, а этот чит-хуб просто имба. Можешь включать полёт, ЕСП, менять небо и кастомизировать персонажа!" or "Roblox is top tier, and this cheat hub is absolute meta. You can toggle flight, ESP, change skies, and customize your character!")
		elseif string.find(lower, "смысл жизни") or string.find(lower, "meaning of life") then
			reply = (lang=="RU" and "Смысл жизни — это 42, а в Роблоксе — запустить скрипт и порофлить на сервере." or "The meaning of life is 42, and in Roblox it's running a script and trolling the server.")
		else
			reply = (lang=="RU" and ("Интересный вопрос: '"..txt.."'. Как Grok заявляю: мир полон загадок, но на всё найдется свой эксплойт или ответ. Спрашивай еще!") or ("Interesting question: '"..txt.."'. As Grok, I declare: the world is full of mysteries, but there's an exploit or answer for everything. Ask me more!"))
		end
		
		addGrokMessage("Grok", reply, true)
	end)
end)

KbB.MouseButton1Click:Connect(function()
	korblox = not korblox
	local c = P.Character if c then
		local att,oldM = c:FindFirstChild("RightUpperLeg") or c:FindFirstChild("Right Leg"),c:FindFirstChild("FakeKorbloxLeg")
		for _,p in ipairs({"RightUpperLeg","RightLowerLeg","RightFoot","Right Leg"}) do local part=c:FindFirstChild(p) if part then part.Transparency=korblox and 1 or 0 end end
		if korblox and not oldM and att then
			local leg = cObj("Part",c,{Name="FakeKorbloxLeg",Size=Vector3.new(1,2,1),CanCollide=false,Massless=true})
			cObj("SpecialMesh",leg,{MeshId="rbxassetid://302562817",TextureId="rbxassetid://302558554",Scale=Vector3.new(1,1,1)})
			cObj("Weld",leg,{Part0=att,Part1=leg,C0=CFrame.new(0,-0.2,0)})
		elseif not korblox and oldM then oldM:Destroy() end
	end updateUI()
end)

HlB.MouseButton1Click:Connect(function()
	headless = not headless
	local c = P.Character if c then local h=c:FindFirstChild("Head") if h then h.Transparency=headless and 1 or 0 local f=h:FindFirstChildOfClass("Decal") if f then f.Transparency=headless and 1 or 0 end end end
	updateUI()
end)

EspB.MouseButton1Click:Connect(function() espEnabled = not espEnabled updateESP() updateUI() end)
InfJumpB.MouseButton1Click:Connect(function() infJumpEnabled = not infJumpEnabled updateUI() end)
NcB.MouseButton1Click:Connect(function() noclipEnabled = not noclipEnabled updateUI() end)
FlyB.MouseButton1Click:Connect(function() flyEnabled = not flyEnabled updateUI() end)
SpeedB.MouseButton1Click:Connect(function() speedEnabled = not speedEnabled updateUI() end)
JumpBoostB.MouseButton1Click:Connect(function() jumpBoostEnabled = not jumpBoostEnabled updateUI() end)

CloneSkinB.MouseButton1Click:Connect(function()
	cloneSkinEnabled = not cloneSkinEnabled
	updateCloneSkin()
	updateUI()
end)

TpB.MouseButton1Click:Connect(function()
	local targetName = TpBox.Text
	if targetName == "" then return end
	local targetPlayer = nil
	for _, plr in ipairs(Pl:GetPlayers()) do
		if string.lower(string.sub(plr.Name, 1, string.len(targetName))) == string.lower(targetName) or string.lower(string.sub(plr.DisplayName, 1, string.len(targetName))) == string.lower(targetName) then
			targetPlayer = plr
			break
		end
	end
	if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
		local myChar = P.Character
		if myChar and myChar:FindFirstChild("HumanoidRootPart") then
			myChar.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
		end
	end
end)

DragBtn.MouseButton1Click:Connect(function()
	isOpen = not isOpen
	if isOpen then Main.Visible=true tw(Main,0.25,{Size=UDim2.new(0,300,0,400)})
	else tw(Main,0.2,{Size=UDim2.new(0,300,0,0)}) task.delay(0.2,function() if not isOpen then Main.Visible=false end end) end
end)

LangB.MouseButton1Click:Connect(function() lang = (lang=="RU" and "EN" or "RU") updateUI() end)
LangPlayerB.MouseButton1Click:Connect(function() lang = (lang=="RU" and "EN" or "RU") updateUI() end)
LangModsB.MouseButton1Click:Connect(function() lang = (lang=="RU" and "EN" or "RU") updateUI() end)

P.CharacterAdded:Connect(function(c)
	c:WaitForChild("Humanoid") task.wait(0.5) saveOriginalAnims(c)
	if korblox then KbB.MouseButton1Click:Fire() end if headless then HlB.MouseButton1Click:Fire() end
	if espEnabled then updateESP() end
	if cloneSkinEnabled then task.wait(1) updateCloneSkin() end
end)

if P.Character then saveOriginalAnims(P.Character) end
setSky(1) updateUI() switchTab("Visual")
