local P,L,R,TS,RS,Pl=game:GetService("Players").LocalPlayer,game:GetService("Lighting"),game:GetService("RunService"),game:GetService("TweenService"),game:GetService("ReplicatedStorage"),game:GetService("Players")
local SoundService = game:GetService("SoundService")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local lang,isOpen,korblox,headless,espEnabled,noclipEnabled,flyEnabled,infJumpEnabled,currentTab,skyIdx,animIdx,menuMusicPlaying,speedEnabled,jumpBoostEnabled,cloneSkinEnabled,bigHeadEnabled,allBigHeadEnabled,godModeEnabled,egorModeEnabled = "RU",false,false,false,false,false,false,false,"Visual",1,1,true,false,false,false,false,false,false,false

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

local soundObj = SoundService:FindFirstChild("GooseHubRelaxingMusic")
if not soundObj then
	soundObj = Instance.new("Sound")
	soundObj.Name = "GooseHubRelaxingMusic"
	soundObj.SoundId = "rbxassetid://1848354536"
	soundObj.Volume = 10
	soundObj.Looped = true
	soundObj.Parent = SoundService
end
pcall(function() soundObj:Play() end)

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
	{RU="Зомби",EN="Zombie",ids={idle1="616158929",idle2="616160103",walk="616168032",run="616163682",jump="616161997",fall="616157476",climb="616157476",climb="616156119",swim="616165109"}},
	{RU="Астронавт",EN="Astronaut",ids={idle1="891621366",idle2="891633237",walk="891667138",run="891636393",jump="891627522",fall="891617961",climb="891609353",swim="891651882"}}
}

local T={
	RU={
		Title="УНИВЕРСАЛЬНОЕ МЕНЮ",Auth="TikTok: ScriptVFXK",TabVisual="Визуал",TabPlayer="Игрок",TabMods="МОДС",TabTikTok="ТикТок",
		Sky="Небо: ",MenuMusic="Музыка меню: ",Anim="Пак анимаций: ",InfJump="Бесконечный прыжок: ",NC="Ноклип: ",
		FLY="Полёт: ",Speed="Быстрый бег: ",JumpBoost="Супер прыжок: ",GodMode="Бессмертие (God): ",EgorMode="Режим Егора: ",TP="Телепорт к игроку",TPPlaceholder="Введите ник игрока...",
		CloneSkin="Клонировать скин (Визуал)",BigHead="Большая голова (Визуал)",AllBigHead="Головы всем (Визуал)",
		Korblox="Фейк Корблокс: ",Headless="Фейк Хедлесс: ",ESP="ЕСП: ",
		ON="Вкл",OFF="Выкл",UserTag="ScriptVFXK ЮЗЕР",
		LoadingSec="Загрузка (%d) сек...",LoadingDone="Загрузка завершена!",
		LangSelect="ScriptVFXK приветствует!\nВыберите язык / Select language:",
		TikTokInfo="👋 Всем привет! Я начинающий РОБЛОКСер и скриптер!\n\nЭто мой самый первый скрипт, который я создал с большой душой и старанием для вас. Надеюсь, он вам понравится!\n\n📱 Обязательно переходите на мой TikTok аккаунт, подписывайтесь и поддержите меня!\n\n🔗 Нажмите на кнопку ниже, чтобы скопировать ссылку или открыть TikTok профиль:",
		CopyLink="📋 Скопировать ссылку на TikTok",
		LinkCopied="✅ Ссылка скопирована в буфер обмена!"
	},
	EN={
		Title="UNIVERSAL MENU",Auth="TikTok: ScriptVFXK",TabVisual="Visual",TabPlayer="Player",TabMods="MODS",TabTikTok="TikTok",
		Sky="Sky: ",MenuMusic="Menu Music: ",Anim="Anim Pack: ",InfJump="Infinite Jump: ",NC="Noclip: ",
		FLY="Fly: ",Speed="Fast Speed: ",JumpBoost="Super Jump: ",GodMode="God Mode: ",EgorMode="Egor Mode: ",TP="Teleport to Player",TPPlaceholder="Enter player username...",
		CloneSkin="Clone Skin (Visual)",BigHead="Big Head (Visual)",AllBigHead="All Big Head (Visual)",
		Korblox="Fake Korblox: ",Headless="Fake Headless: ",ESP="ESP: ",
		ON="ON",OFF="OFF",UserTag="ScriptVFXK USERS",
		LoadingSec="Loading (%d) sec...",LoadingDone="Loading Complete!",
		LangSelect="ScriptVFXK welcomes:\nSelect language / Выберите язык:",
		TikTokInfo="👋 Hello everyone! I am a beginner ROBLOXer and scripter!\n\nThis is my very first script that I created with a lot of soul and effort for you. I hope you enjoy it!\n\n📱 Be sure to check out my TikTok account, subscribe and support me!\n\n🔗 Click the button below to copy the link or open the TikTok profile:",
		CopyLink="📋 Copy TikTok Link",
		LinkCopied="✅ Link copied to clipboard!"
	}
}

local function cObj(cls,p,props) local o=Instance.new(cls) for k,v in pairs(props) do o[k]=v end o.Parent=p return o end
local function tw(o,t,p) TS:Create(o,TweenInfo.new(t,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),p):Play() end

local Gui = cObj("ScreenGui", P:WaitForChild("PlayerGui"), {Name="GooseHub", ResetOnSpawn=false, IgnoreGuiInset=true})

local LoadFrame = cObj("Frame", Gui, {Size=UDim2.new(1,0,1,0), BackgroundColor3=Color3.fromRGB(0,0,0), ZIndex=200})
local LoadTitle = cObj("TextLabel", LoadFrame, {Size=UDim2.new(0,500,0,60), Position=UDim2.new(0.5,-250,0.45,-30), BackgroundTransparency=1, Text=string.format(T[lang].LoadingSec, 3), TextColor3=Color3.fromRGB(255,255,255), TextSize=26, Font=Enum.Font.GothamBold, TextXAlignment=Enum.TextXAlignment.Center, ZIndex=201})
local LoadBarBg = cObj("Frame", LoadFrame, {Size=UDim2.new(0,320,0,6), Position=UDim2.new(0.5,-160,0.5,30), BackgroundColor3=Color3.fromRGB(20,20,20), ZIndex=201})
cObj("UICorner", LoadBarBg, {CornerRadius=UDim.new(1,0)})
local LoadBar = cObj("Frame", LoadBarBg, {Size=UDim2.new(0,0,1,0), BackgroundColor3=Color3.fromRGB(255,200,100), ZIndex=202})
cObj("UICorner", LoadBar, {CornerRadius=UDim.new(1,0)})

tw(LoadBar, 3, {Size=UDim2.new(1,0,1,0)})

task.spawn(function()
	task.wait(1) LoadTitle.Text = string.format(T[lang].LoadingSec, 2)
	task.wait(1) LoadTitle.Text = string.format(T[lang].LoadingSec, 1)
	task.wait(1) LoadTitle.Text = T[lang].LoadingDone
end)

task.wait(3.2)
tw(LoadFrame, 0.4, {BackgroundTransparency=1})
tw(LoadTitle, 0.4, {TextTransparency=1})
tw(LoadBarBg, 0.4, {BackgroundTransparency=1})
tw(LoadBar, 0.4, {BackgroundTransparency=1})
task.wait(0.4) LoadFrame:Destroy()

local LangFrame = cObj("Frame", Gui, {Size=UDim2.new(1,0,1,0), BackgroundColor3=Color3.fromRGB(0,0,0), BackgroundTransparency=0.4, ZIndex=100})
local LangSelectBox = cObj("Frame", LangFrame, {Size=UDim2.new(0,340,0,240), Position=UDim2.new(0.5,-170,0.5,-120), BackgroundColor3=Color3.fromRGB(18,18,26), ZIndex=101})
cObj("UICorner", LangSelectBox, {CornerRadius=UDim.new(0,16)})
cObj("UIStroke", LangSelectBox, {Color=Color3.fromRGB(255,200,100), Thickness=1.5})

local LangTextLabel = cObj("TextLabel", LangSelectBox, {Size=UDim2.new(1,-20,0,60), Position=UDim2.new(0,10,0,10), BackgroundTransparency=1, Text=T[lang].LangSelect, TextColor3=Color3.fromRGB(255,255,255), TextSize=14, Font=Enum.Font.GothamBold, TextXAlignment=Enum.TextXAlignment.Center, TextWrapped=true, ZIndex=102})
local RuBtn = cObj("TextButton", LangSelectBox, {Size=UDim2.new(0.8,0,0,45), Position=UDim2.new(0.1,0,0,85), BackgroundColor3=Color3.fromRGB(45,35,60), Text="🇷🇺 Русский", TextColor3=Color3.fromRGB(255,220,150), TextSize=14, Font=Enum.Font.GothamBold, ZIndex=102})
cObj("UICorner", RuBtn, {CornerRadius=UDim.new(0,10)})
cObj("UIStroke", RuBtn, {Color=Color3.fromRGB(255,220,150), Transparency=0.5, Thickness=1})
local EnBtn = cObj("TextButton", LangSelectBox, {Size=UDim2.new(0.8,0,0,45), Position=UDim2.new(0.1,0,0,145), BackgroundColor3=Color3.fromRGB(35,35,50), Text="🇬🇧 English", TextColor3=Color3.fromRGB(180,180,180), TextSize=14, Font=Enum.Font.GothamBold, ZIndex=102})
cObj("UICorner", EnBtn, {CornerRadius=UDim.new(0,10)})
cObj("UIStroke", EnBtn, {Color=Color3.fromRGB(255,220,150), Transparency=0.8, Thickness=1})

local langChosen = false
RuBtn.MouseButton1Click:Connect(function() lang = "RU" langChosen = true end)
EnBtn.MouseButton1Click:Connect(function() lang = "EN" langChosen = true end)
repeat task.wait() until langChosen
tw(LangFrame, 0.4, {BackgroundTransparency=1})
tw(LangSelectBox, 0.4, {Size=UDim2.new(0,0,0,0)})
task.wait(0.4) LangFrame:Destroy()

local userTags = {}
local function createHeadTag(plr)
	if not plr or not plr.Character then return end
	local head = plr.Character:WaitForChild("Head", 5) if not head then return end
	local old = head:FindFirstChild("GooseScriptUserTag") if old then old:Destroy() end
	local bg = cObj("BillboardGui", head, {Name="GooseScriptUserTag", Adornee=head, Size=UDim2.new(0,300,0,30), StudsOffset=Vector3.new(0,2.5,0), AlwaysOnTop=true})
	userTags[plr] = cObj("TextLabel", bg, {Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Text=T[lang].UserTag, TextColor3=Color3.fromRGB(255,215,0), TextStrokeTransparency=0.2, TextStrokeColor3=Color3.new(0,0,0), Font=Enum.Font.GothamBold, TextSize=15})
end

local RemoteFolder = RS:FindFirstChild("GooseHubScriptUsersFolder")
if not RemoteFolder then RemoteFolder = cObj("Folder", RS, {Name="GooseHubScriptUsersFolder"}) end

local function markUser(plr)
	createHeadTag(plr)
	plr.CharacterAdded:Connect(function() task.wait(1) createHeadTag(plr) end)
end

cObj("ObjectValue", RemoteFolder, {Name=P.Name, Value=P})
RemoteFolder.ChildAdded:Connect(function(c) if c:IsA("ObjectValue") and c.Value then markUser(c.Value) end end)
for _, c in ipairs(RemoteFolder:GetChildren()) do if c:IsA("ObjectValue") and c.Value then markUser(c.Value) end end

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

local originalPlayerLooks = {}
local function savePlayerOriginalLook(targetChar, targetPlayer)
	if originalPlayerLooks[targetPlayer] then return end
	local lookData = { accessories = {}, clothing = {}, bodyColors = nil, characterMeshes = {}, parts = {}, face = nil }
	for _, child in ipairs(targetChar:GetChildren()) do
		if child:IsA("Accessory") then table.insert(lookData.accessories, child:Clone())
		elseif child:IsA("Clothing") then table.insert(lookData.clothing, child:Clone())
		elseif child:IsA("BodyColors") then lookData.bodyColors = child:Clone()
		elseif child:IsA("CharacterMesh") then table.insert(lookData.characterMeshes, child:Clone())
		elseif child:IsA("BasePart") then
			lookData.parts[child.Name] = {Color = child.Color, Material = child.Material, Transparency = child.Transparency}
			local head = targetChar:FindFirstChild("Head")
			if head then local decal = head:FindFirstChildOfClass("Decal") if decal then lookData.face = decal:Clone() end end
		end
	end
	originalPlayerLooks[targetPlayer] = lookData
end

local function restorePlayerLook(targetChar, targetPlayer)
	local lookData = originalPlayerLooks[targetPlayer]
	if not lookData then return end
	for _, child in ipairs(targetChar:GetChildren()) do
		if child:IsA("Accessory") or child:IsA("Clothing") or child:IsA("BodyColors") or child:IsA("CharacterMesh") then child:Destroy() end
	end
	for _, acc in ipairs(lookData.accessories) do acc:Clone().Parent = targetChar end
	for _, cloth in ipairs(lookData.clothing) do cloth:Clone().Parent = targetChar end
	if lookData.bodyColors then lookData.bodyColors:Clone().Parent = targetChar end
	for _, mesh in ipairs(lookData.characterMeshes) do mesh:Clone().Parent = targetChar end
	for _, child in ipairs(targetChar:GetChildren()) do
		if child:IsA("BasePart") and lookData.parts[child.Name] then
			child.Color = lookData.parts[child.Name].Color
			child.Material = lookData.parts[child.Name].Material
			child.Transparency = lookData.parts[child.Name].Transparency
		end
	end
	local head = targetChar:FindFirstChild("Head")
	if head then
		local oldDecal = head:FindFirstChildOfClass("Decal") if oldDecal then oldDecal:Destroy() end
		if lookData.face then lookData.face:Clone().Parent = head end
	end
	originalPlayerLooks[targetPlayer] = nil
end

local function applyCloneSkinToCharacter(targetChar, targetPlayer)
	if not cloneSkinEnabled or not P.Character or targetChar == P.Character then return end
	savePlayerOriginalLook(targetChar, targetPlayer)
	for _, child in ipairs(targetChar:GetChildren()) do
		if child:IsA("Accessory") or child:IsA("Clothing") or child:IsA("BodyColors") or child:IsA("CharacterMesh") then child:Destroy() end
	end
	local targetHead = targetChar:FindFirstChild("Head")
	if targetHead then for _, d in ipairs(targetHead:GetChildren()) do if d:IsA("Decal") then d:Destroy() end end end
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
	local myHead = P.Character:FindFirstChild("Head")
	if myHead and targetHead then
		local myDecal = myHead:FindFirstChildOfClass("Decal")
		if myDecal then myDecal:Clone().Parent = targetHead end
	end
end

local function updateCloneSkin()
	for _, plr in ipairs(Pl:GetPlayers()) do
		if plr ~= P and plr.Character then
			if cloneSkinEnabled then applyCloneSkinToCharacter(plr.Character, plr) else restorePlayerLook(plr.Character, plr) end
		end
	end
end

Pl.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function(char)
		task.wait(1)
		if cloneSkinEnabled then applyCloneSkinToCharacter(char, plr) end
	end)
end)

local function applyKorblox()
	local c = P.Character if not c then return end
	local att,oldM = c:FindFirstChild("RightUpperLeg") or c:FindFirstChild("Right Leg"),c:FindFirstChild("FakeKorbloxLeg")
	for _,p in ipairs({"RightUpperLeg","RightLowerLeg","RightFoot","Right Leg"}) do 
		local part=c:FindFirstChild(p) 
		if part then part.Transparency=korblox and 1 or 0 end 
	end
	if korblox and not oldM and att then
		local leg = cObj("Part",c,{Name="FakeKorbloxLeg",Size=Vector3.new(1,2,1),CanCollide=false,Massless=true})
		cObj("SpecialMesh",leg,{MeshId="rbxassetid://302562817",TextureId="rbxassetid://302558554",Scale=Vector3.new(1,1,1)})
		cObj("Weld",leg,{Part0=att,Part1=leg,C0=CFrame.new(0,-0.2,0)})
	elseif not korblox and oldM then 
		oldM:Destroy() 
	end
end

local function applyHeadless()
	local c = P.Character if not c then return end
	local h=c:FindFirstChild("Head") 
	if h then 
		h.Transparency=headless and 1 or 0 
		local f=h:FindFirstChildOfClass("Decal") 
		if f then f.Transparency=headless and 1 or 0 end 
	end
end

local function updateBigHead()
	local c = P.Character if not c then return end
	local head = c:FindFirstChild("Head")
	if head then head.Size = bigHeadEnabled and Vector3.new(3.5, 3.5, 3.5) or Vector3.new(2, 1, 1) end
end

local function updateAllBigHead()
	for _, plr in ipairs(Pl:GetPlayers()) do
		if plr.Character then
			local head = plr.Character:FindFirstChild("Head")
			if head then head.Size = allBigHeadEnabled and Vector3.new(3.5, 3.5, 3.5) or Vector3.new(2, 1, 1) end
		end
	end
end

Pl.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function(char)
		task.wait(1)
		if allBigHeadEnabled then
			local head = char:FindFirstChild("Head")
			if head then head.Size = Vector3.new(3.5, 3.5, 3.5) end
		end
	end)
end)

local godConn = nil
local function setupGodMode(char)
	if godConn then godConn:Disconnect() godConn = nil end
	if not char then return end
	local hum = char:WaitForChild("Humanoid", 5)
	if not hum then return end

	hum.StateChanged:Connect(function(_, newState)
		if godModeEnabled and newState == Enum.HumanoidStateType.Dead then
			hum:ChangeState(Enum.HumanoidStateType.Running)
			hum.Health = hum.MaxHealth
		end
	end)

	godConn = hum.HealthChanged:Connect(function(newHealth)
		if godModeEnabled and newHealth < hum.MaxHealth then
			hum.Health = hum.MaxHealth
		end
	end)
end

local currentFov = 70
local customFovEnabled = false

local bg, bv = nil, nil

R.Stepped:Connect(function()
	if customFovEnabled then
		pcall(function() workspace.CurrentCamera.FieldOfView = currentFov end)
	end

	if noclipEnabled and P.Character then
		local hrp = P.Character:FindFirstChild("HumanoidRootPart")
		if hrp then
			for _, part in ipairs(P.Character:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = false end end
		end
	end
	local c = P.Character
	if c and c:FindFirstChildOfClass("Humanoid") then
		local hum = c:FindFirstChildOfClass("Humanoid")
		
		if egorModeEnabled then
			hum.WalkSpeed = 5
			pcall(function()
				for _, track in ipairs(hum:GetPlayingAnimationTracks()) do
					if track.Name:lower():find("run") or track.Name:lower():find("walk") then
						track:AdjustSpeed(10)
					end
				end
			end)
		elseif speedEnabled then 
			hum.WalkSpeed = 35 
		else 
			hum.WalkSpeed = 16 
		end

		if jumpBoostEnabled then hum.JumpPower = 100 else hum.JumpPower = 50 end
		if godModeEnabled then
			if hum.Health < hum.MaxHealth then hum.Health = hum.MaxHealth end
			pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false) end)
		else
			pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true) end)
		end
	end
	if flyEnabled and c and c:FindFirstChild("HumanoidRootPart") and c:FindFirstChildOfClass("Humanoid") then
		local hrp = c.HumanoidRootPart
		local hum = c:FindFirstChildOfClass("Humanoid")
		local cam = workspace.CurrentCamera
		if not bg or not bv or bg.Parent ~= hrp then
			if bg then bg:Destroy() end if bv then bv:Destroy() end
			bg = Instance.new("BodyGyro") bg.P = 9e4 bg.maxTorque = Vector3.new(9e9, 9e9, 9e9) bg.Parent = hrp
			bv = Instance.new("BodyVelocity") bv.velocity = Vector3.new(0, 0, 0) bv.maxForce = Vector3.new(9e9, 9e9, 9e9) bv.Parent = hrp
			hum.PlatformStand = true
		end
		local camLook = cam.CFrame.LookVector
		bg.cframe = CFrame.new(hrp.Position, hrp.Position + Vector3.new(camLook.X, 0, camLook.Z))
		local moveDir = hum.MoveDirection
		local speed = 50
		if moveDir.Magnitude > 0 then
			bv.velocity = (cam.CFrame.RightVector * moveDir.X + cam.CFrame.LookVector * moveDir.Z) * speed + Vector3.new(0, camLook.Y * moveDir.Z * speed, 0)
		else
			bv.velocity = Vector3.new(0, 0, 0)
		end
	else
		if bg then bg:Destroy() bg = nil end if bv then bv:Destroy() bv = nil end
		if c and c:FindFirstChildOfClass("Humanoid") then
			local hum = c:FindFirstChildOfClass("Humanoid")
			if hum.PlatformStand then hum.PlatformStand = false end
		end
	end
end)

UserInputService.JumpRequest:Connect(function()
	if infJumpEnabled and P.Character then
		local hum = P.Character:FindFirstChildOfClass("Humanoid")
		if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
	end
end)

local DragBtn = cObj("TextButton", Gui, {Size=UDim2.new(0,42,0,42), Position=UDim2.new(0.02,0,0.2,0), BackgroundColor3=Color3.fromRGB(20,20,28), Text="✨", TextSize=18, Font=Enum.Font.Gotham, Active=true, Draggable=true})
cObj("UICorner", DragBtn, {CornerRadius=UDim.new(1,0)})
local DragStroke = cObj("UIStroke", DragBtn, {Color=Color3.fromRGB(255,200,100), Thickness=2})

local Main = cObj("Frame", Gui, {Size=UDim2.new(0,300,0,400), Position=UDim2.new(0.02,0,0.36,0), BackgroundColor3=Color3.fromRGB(15,15,22), Active=true, Draggable=true, ClipsDescendants=true})
cObj("UICorner", Main, {CornerRadius=UDim.new(0,16)})
local MainStroke = cObj("UIStroke", Main, {Color=Color3.fromRGB(255,180,80), Thickness=1.5})
local GooseImg = cObj("ImageLabel", Main, {Size=UDim2.new(1.1,0,1.1,0), Position=UDim2.new(-0.05,0,-0.05,0), Image="rbxassetid://9459521367", ImageTransparency=0.5, BackgroundTransparency=1, ScaleType=Enum.ScaleType.Crop})
local Title = cObj("TextLabel", Main, {Size=UDim2.new(1,0,0,35), BackgroundColor3=Color3.fromRGB(30,25,35), BackgroundTransparency=0.4, TextSize=13, Font=Enum.Font.Gotham, ZIndex=5})
cObj("UICorner", Title, {CornerRadius=UDim.new(0,16)})

local TabBar = cObj("ScrollingFrame", Main, {Size=UDim2.new(1,-14,0,32), Position=UDim2.new(0,7,0,38), BackgroundTransparency=1, CanvasSize=UDim2.new(0,380,0,0), ScrollBarThickness=0, Active=false, ZIndex=10})
local TabVisualBtn = cObj("TextButton", TabBar, {Size=UDim2.new(0,68,1,-2), Position=UDim2.new(0,0,0,0), BackgroundColor3=Color3.fromRGB(45,35,60), BackgroundTransparency=0.2, TextColor3=Color3.fromRGB(255,220,150), TextSize=9, Font=Enum.Font.GothamBold, ZIndex=11})
cObj("UICorner", TabVisualBtn, {CornerRadius=UDim.new(0,8)})
local TabPlayerBtn = cObj("TextButton", TabBar, {Size=UDim2.new(0,68,1,-2), Position=UDim2.new(0,72,0,0), BackgroundColor3=Color3.fromRGB(25,20,35), BackgroundTransparency=0.4, TextColor3=Color3.fromRGB(180,180,180), TextSize=9, Font=Enum.Font.GothamBold, ZIndex=11})
cObj("UICorner", TabPlayerBtn, {CornerRadius=UDim.new(0,8)})
local TabModsBtn = cObj("TextButton", TabBar, {Size=UDim2.new(0,68,1,-2), Position=UDim2.new(0,144,0,0), BackgroundColor3=Color3.fromRGB(25,20,35), BackgroundTransparency=0.4, TextColor3=Color3.fromRGB(180,180,180), TextSize=9, Font=Enum.Font.GothamBold, ZIndex=11})
cObj("UICorner", TabModsBtn, {CornerRadius=UDim.new(0,8)})
local TabTikTokBtn = cObj("TextButton", TabBar, {Size=UDim2.new(0,92,1,-2), Position=UDim2.new(0,216,0,0), BackgroundColor3=Color3.fromRGB(25,20,35), BackgroundTransparency=0.4, TextColor3=Color3.fromRGB(100,200,255), TextSize=9, Font=Enum.Font.GothamBold, ZIndex=11})
cObj("UICorner", TabTikTokBtn, {CornerRadius=UDim.new(0,8)})
cObj("UIStroke", TabTikTokBtn, {Color=Color3.fromRGB(0,170,255), Thickness=1, Transparency=0.3})

local ScrollVisual = cObj("ScrollingFrame", Main, {Size=UDim2.new(1,0,1,-90), Position=UDim2.new(0,0,0,72), BackgroundTransparency=1, CanvasSize=UDim2.new(0,0,0,380), ScrollBarThickness=4, ScrollBarImageColor3=Color3.fromRGB(255,200,100), Active=true, Visible=true, ZIndex=3})
local ScrollPlayer = cObj("ScrollingFrame", Main, {Size=UDim2.new(1,0,1,-90), Position=UDim2.new(0,0,0,72), BackgroundTransparency=1, CanvasSize=UDim2.new(0,0,0,710), ScrollBarThickness=4, ScrollBarImageColor3=Color3.fromRGB(255,200,100), Active=true, Visible=false, ZIndex=3})
local ScrollMods = cObj("ScrollingFrame", Main, {Size=UDim2.new(1,0,1,-90), Position=UDim2.new(0,0,0,72), BackgroundTransparency=1, CanvasSize=UDim2.new(0,0,0,300), ScrollBarThickness=4, ScrollBarImageColor3=Color3.fromRGB(255,200,100), Active=true, Visible=false, ZIndex=3})
local ScrollTikTok = cObj("ScrollingFrame", Main, {Size=UDim2.new(1,0,1,-90), Position=UDim2.new(0,0,0,72), BackgroundTransparency=1, CanvasSize=UDim2.new(0,0,0,380), ScrollBarThickness=4, ScrollBarImageColor3=Color3.fromRGB(0,170,255), Active=true, Visible=false, ZIndex=3})

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

local FovFrame = cObj("Frame", ScrollVisual, {Size=UDim2.new(0.86,0,0,36), Position=UDim2.new(0.07,0,0,310), BackgroundColor3=Color3.fromRGB(35,35,50), BackgroundTransparency=0.3, ZIndex=4})
cObj("UICorner", FovFrame, {CornerRadius=UDim.new(0,10)})
cObj("UIStroke", FovFrame, {Color=Color3.fromRGB(255,220,150), Transparency=0.7, Thickness=1})
local FovFill = cObj("Frame", FovFrame, {Size=UDim2.new((70-10)/(120-10),0,1,0), BackgroundColor3=Color3.fromRGB(40,130,75), ZIndex=4})
cObj("UICorner", FovFill, {CornerRadius=UDim.new(0,10)})
local FovText = cObj("TextLabel", FovFrame, {Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Text="FOV: 70", TextColor3=Color3.new(1,1,1), TextSize=12, Font=Enum.Font.Gotham, ZIndex=5})
local FovBtn = cObj("TextButton", FovFrame, {Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Text="", ZIndex=6})

local draggingFov = false
FovBtn.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		draggingFov = true
		customFovEnabled = true
	end
end)
UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		draggingFov = false
	end
end)

local LangPlayerB = btn(ScrollPlayer,10,Color3.fromRGB(50,40,65)) LangPlayerB.Size,LangPlayerB.Position = UDim2.new(0.86,0,0,36),UDim2.new(0.07,0,0,10)
local AnimPrev,AnimB,AnimNext = navBtn(ScrollPlayer,60,"◄",0.04),btn(ScrollPlayer,60,Color3.fromRGB(55,40,85)),navBtn(ScrollPlayer,60,"►",0.86)
local InfJumpB = btn(ScrollPlayer,110,Color3.fromRGB(35,35,50)) InfJumpB.Size,InfJumpB.Position = UDim2.new(0.86,0,0,36),UDim2.new(0.07,0,0,110)
local NcB = btn(ScrollPlayer,160,Color3.fromRGB(35,35,50)) NcB.Size,NcB.Position = UDim2.new(0.86,0,0,36),UDim2.new(0.07,0,0,160)
local FlyB = btn(ScrollPlayer,210,Color3.fromRGB(35,35,50)) FlyB.Size,FlyB.Position = UDim2.new(0.86,0,0,36),UDim2.new(0.07,0,0,210)
local SpeedB = btn(ScrollPlayer,260,Color3.fromRGB(35,35,50)) SpeedB.Size,SpeedB.Position = UDim2.new(0.86,0,0,36),UDim2.new(0.07,0,0,260)
local EgorB = btn(ScrollPlayer,310,Color3.fromRGB(35,35,50)) EgorB.Size,EgorB.Position = UDim2.new(0.86,0,0,36),UDim2.new(0.07,0,0,310)
local JumpBoostB = btn(ScrollPlayer,360,Color3.fromRGB(35,35,50)) JumpBoostB.Size,JumpBoostB.Position = UDim2.new(0.86,0,0,36),UDim2.new(0.07,0,0,360)
local GodModeB = btn(ScrollPlayer,410,Color3.fromRGB(35,35,50)) GodModeB.Size,GodModeB.Position = UDim2.new(0.86,0,0,36),UDim2.new(0.07,0,0,410)

local TpBox = cObj("TextBox", ScrollPlayer, {Size=UDim2.new(0.86,0,0,36), Position=UDim2.new(0.07,0,0,460), BackgroundColor3=Color3.fromRGB(35,35,50), BackgroundTransparency=0.3, Text="", TextColor3=Color3.new(1,1,1), PlaceholderColor3=Color3.fromRGB(150,150,150), TextSize=12, Font=Enum.Font.Gotham, ZIndex=4})
cObj("UICorner", TpBox, {CornerRadius=UDim.new(0,10)})
cObj("UIStroke", TpBox, {Color=Color3.fromRGB(255,220,150), Transparency=0.7, Thickness=1})
local TpB = btn(ScrollPlayer,510,Color3.fromRGB(40,110,130)) TpB.Size,TpB.Position = UDim2.new(0.86,0,0,36),UDim2.new(0.07,0,0,510)

local LangModsB = btn(ScrollMods,10,Color3.fromRGB(50,40,65)) LangModsB.Size,LangModsB.Position = UDim2.new(0.86,0,0,36),UDim2.new(0.07,0,0,10)
local CloneSkinB = btn(ScrollMods,60,Color3.fromRGB(35,35,50)) CloneSkinB.Size,CloneSkinB.Position = UDim2.new(0.86,0,0,36),UDim2.new(0.07,0,0,60)
local BigHeadB = btn(ScrollMods,110,Color3.fromRGB(35,35,50)) BigHeadB.Size,BigHeadB.Position = UDim2.new(0.86,0,0,36),UDim2.new(0.07,0,0,110)
local AllBigHeadB = btn(ScrollMods,160,Color3.fromRGB(35,35,50)) AllBigHeadB.Size,AllBigHeadB.Position = UDim2.new(0.86,0,0,36),UDim2.new(0.07,0,0,160)

local LangTikTokB = btn(ScrollTikTok,10,Color3.fromRGB(50,40,65)) LangTikTokB.Size,LangTikTokB.Position = UDim2.new(0.86,0,0,36),UDim2.new(0.07,0,0,10)
local TikTokTextLabel = cObj("TextLabel", ScrollTikTok, {Size=UDim2.new(0.86,0,0,210), Position=UDim2.new(0.07,0,0,60), BackgroundTransparency=1, Text=T[lang].TikTokInfo, TextColor3=Color3.fromRGB(230,230,250), TextSize=12, Font=Enum.Font.Gotham, TextXAlignment=Enum.TextXAlignment.Left, TextYAlignment=Enum.TextYAlignment.Top, TextWrapped=true, ZIndex=4})
local TikTokBtn = cObj("TextButton", ScrollTikTok, {Size=UDim2.new(0.86,0,0,45), Position=UDim2.new(0.07,0,0,285), BackgroundColor3=Color3.fromRGB(15,25,45), BackgroundTransparency=0.2, Text=T[lang].CopyLink, TextColor3=Color3.fromRGB(100,200,255), TextSize=12, Font=Enum.Font.GothamBold, ZIndex=4})
cObj("UICorner", TikTokBtn, {CornerRadius=UDim.new(0,10)})
local TikTokBtnStroke = cObj("UIStroke", TikTokBtn, {Color=Color3.fromRGB(0,170,255), Thickness=1.5, Transparency=0.2})

TikTokBtn.MouseButton1Click:Connect(function()
	local link = "www.tiktok.com/@scriptvfxk"
	pcall(function() setclipboard(link) end)
	pcall(function()
		StarterGui:SetCore("SendNotification", {Title="TikTok: ScriptVFXK", Text=T[lang].LinkCopied, Duration=3})
	end)
end)

local hue,t = 0,0
R.RenderStepped:Connect(function(dt)
	hue,t = (hue+dt*0.25)%1, t+dt
	local c = Color3.fromHSV(hue,0.55,1)
	Title.TextColor3,DragBtn.TextColor3,DragStroke.Color,MainStroke.Color = c,c,c,c
	GooseImg.Position = UDim2.new(-0.05,math.sin(t*1.5)*5,-0.05,math.cos(t*1.5)*5)
	
	if draggingFov then
		local mousePos = UserInputService:GetMouseLocation().X
		local framePos = FovFrame.AbsolutePosition.X
		local frameSize = FovFrame.AbsoluteSize.X
		local percent = math.clamp((mousePos - framePos) / frameSize, 0, 1)
		currentFov = math.floor(10 + (110 * percent))
		FovFill.Size = UDim2.new(percent, 0, 1, 0)
		FovText.Text = "FOV: " .. currentFov
	end

	local glowVal = (math.sin(t * 4) + 1) / 2
	TikTokBtnStroke.Transparency = 0.1 + glowVal * 0.4
end)

local function switchTab(tab)
	currentTab = tab
	ScrollVisual.Visible = (tab == "Visual")
	ScrollPlayer.Visible = (tab == "Player")
	ScrollMods.Visible = (tab == "Mods")
	ScrollTikTok.Visible = (tab == "TikTok")
	
	TabVisualBtn.BackgroundColor3 = (tab == "Visual" and Color3.fromRGB(45,35,60) or Color3.fromRGB(25,20,35))
	TabVisualBtn.TextColor3 = (tab == "Visual" and Color3.fromRGB(255,220,150) or Color3.fromRGB(180,180,180))
	TabPlayerBtn.BackgroundColor3 = (tab == "Player" and Color3.fromRGB(45,35,60) or Color3.fromRGB(25,20,35))
	TabPlayerBtn.TextColor3 = (tab == "Player" and Color3.fromRGB(255,220,150) or Color3.fromRGB(180,180,180))
	TabModsBtn.BackgroundColor3 = (tab == "Mods" and Color3.fromRGB(45,35,60) or Color3.fromRGB(25,20,35))
	TabModsBtn.TextColor3 = (tab == "Mods" and Color3.fromRGB(255,220,150) or Color3.fromRGB(180,180,180))
	TabTikTokBtn.BackgroundColor3 = (tab == "TikTok" and Color3.fromRGB(20,40,70) or Color3.fromRGB(25,20,35))
	TabTikTokBtn.TextColor3 = (tab == "TikTok" and Color3.fromRGB(150,220,255) or Color3.fromRGB(100,200,255))
end

TabVisualBtn.MouseButton1Click:Connect(function() switchTab("Visual") end)
TabPlayerBtn.MouseButton1Click:Connect(function() switchTab("Player") end)
TabModsBtn.MouseButton1Click:Connect(function() switchTab("Mods") end)
TabTikTokBtn.MouseButton1Click:Connect(function() switchTab("TikTok") end)

local function updateUI()
	local d = T[lang]
	Title.Text = d.Title
	Auth.Text = "TikTok: ScriptVFXK"
	TabVisualBtn.Text = "👁️ " .. d.TabVisual
	TabPlayerBtn.Text = "👤 " .. d.TabPlayer
	TabModsBtn.Text = "⚡ " .. d.TabMods
	TabTikTokBtn.Text = "🎵 " .. d.TabTikTok
	LangB.Text = "🌐 Язык / Language: "..lang
	LangPlayerB.Text = "🌐 Язык / Language: "..lang
	LangModsB.Text = "🌐 Язык / Language: "..lang
	LangTikTokB.Text = "🌐 Язык / Language: "..lang
	SkyB.Text = "🌌 "..d.Sky..SkyList[skyIdx][lang]
	MenuMusicB.Text = "🎵 "..d.MenuMusic..(menuMusicPlaying and d.ON or d.OFF)
	MenuMusicB.BackgroundColor3 = menuMusicPlaying and Color3.fromRGB(40,130,75) or Color3.fromRGB(35,35,50)
	KbB.Text,KbB.BackgroundColor3 = "🦵 "..d.Korblox..(korblox and d.ON or d.OFF), korblox and Color3.fromRGB(40,130,75) or Color3.fromRGB(35,35,50)
	HlB.Text,HlB.BackgroundColor3 = "💀 "..d.Headless..(headless and d.ON or d.OFF), headless and Color3.fromRGB(40,130,75) or Color3.fromRGB(35,35,50)
	EspB.Text,EspB.BackgroundColor3 = "👁️ "..d.ESP..(espEnabled and d.ON or d.OFF), espEnabled and Color3.fromRGB(40,130,75) or Color3.fromRGB(35,35,50)
	InfJumpB.Text,InfJumpB.BackgroundColor3 = "🦘 "..d.InfJump..(infJumpEnabled and d.ON or d.OFF), infJumpEnabled and Color3.fromRGB(40,130,75) or Color3.fromRGB(35,35,50)
	NcB.Text,NcB.BackgroundColor3 = "👻 "..d.NC..(noclipEnabled and d.ON or d.OFF), noclipEnabled and Color3.fromRGB(40,130,75) or Color3.fromRGB(35,35,50)
	FlyB.Text,FlyB.BackgroundColor3 = "🦸 "..d.FLY..(flyEnabled and d.ON or d.OFF), flyEnabled and Color3.fromRGB(40,130,75) or Color3.fromRGB(35,35,50)
	SpeedB.Text,SpeedB.BackgroundColor3 = "⚡ "..d.Speed..(speedEnabled and d.ON or d.OFF), speedEnabled and Color3.fromRGB(40,130,75) or Color3.fromRGB(35,35,50)
	EgorB.Text,EgorB.BackgroundColor3 = "🏃 "..d.EgorMode..(egorModeEnabled and d.ON or d.OFF), egorModeEnabled and Color3.fromRGB(40,130,75) or Color3.fromRGB(35,35,50)
	JumpBoostB.Text,JumpBoostB.BackgroundColor3 = "🚀 "..d.JumpBoost..(jumpBoostEnabled and d.ON or d.OFF), jumpBoostEnabled and Color3.fromRGB(40,130,75) or Color3.fromRGB(35,35,50)
	GodModeB.Text,GodModeB.BackgroundColor3 = "🛡️ "..d.GodMode..(godModeEnabled and d.ON or d.OFF), godModeEnabled and Color3.fromRGB(40,130,75) or Color3.fromRGB(35,35,50)
	TpBox.PlaceholderText = d.TPPlaceholder
	TpB.Text = "🎯 "..d.TP
	AnimB.Text = "🕺 "..d.Anim..AnimPacks[animIdx][lang]
	CloneSkinB.Text = "👥 "..d.CloneSkin..": "..(cloneSkinEnabled and d.ON or d.OFF)
	CloneSkinB.BackgroundColor3 = cloneSkinEnabled and Color3.fromRGB(40,130,75) or Color3.fromRGB(35,35,50)
	BigHeadB.Text = "🗣️ "..d.BigHead..": "..(bigHeadEnabled and d.ON or d.OFF)
	BigHeadB.BackgroundColor3 = bigHeadEnabled and Color3.fromRGB(40,130,75) or Color3.fromRGB(35,35,50)
	AllBigHeadB.Text = "👥🗣️ "..d.AllBigHead..": "..(allBigHeadEnabled and d.ON or d.OFF)
	AllBigHeadB.BackgroundColor3 = allBigHeadEnabled and Color3.fromRGB(40,130,75) or Color3.fromRGB(35,35,50)
	TikTokTextLabel.Text = d.TikTokInfo
	TikTokBtn.Text = d.CopyLink
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
								if folderName:lower():find("idle") then newId = (num == "2") and pack.idle2 or pack.idle1
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
						for _, orig in ipairs(anims) do if orig.name == child.Name then child.AnimationId = orig.id end end
					end
				end
			end
		end
	end
	local hum = c:FindFirstChildOfClass("Humanoid") if hum then for _, tr in ipairs(hum:GetPlayingAnimationTracks()) do tr:Stop() end end
end

local function changeAnim(dir) animIdx=(animIdx-1+dir+#AnimPacks)%#AnimPacks+1 applyAnimPack(animIdx) updateUI() end
AnimNext.MouseButton1Click:Connect(function() changeAnim(1) end)
AnimPrev.MouseButton1Click:Connect(function() changeAnim(-1) end)
AnimB.MouseButton1Click:Connect(function() changeAnim(1) end)

MenuMusicB.MouseButton1Click:Connect(function()
	menuMusicPlaying = not menuMusicPlaying
	if menuMusicPlaying then soundObj:Play() else soundObj:Stop() end
	updateUI()
end)

KbB.MouseButton1Click:Connect(function() korblox = not korblox applyKorblox() updateUI() end)
HlB.MouseButton1Click:Connect(function() headless = not headless applyHeadless() updateUI() end)
EspB.MouseButton1Click:Connect(function() espEnabled = not espEnabled updateESP() updateUI() end)
InfJumpB.MouseButton1Click:Connect(function() infJumpEnabled = not infJumpEnabled updateUI() end)
NcB.MouseButton1Click:Connect(function() noclipEnabled = not noclipEnabled updateUI() end)
FlyB.MouseButton1Click:Connect(function() flyEnabled = not flyEnabled updateUI() end)
SpeedB.MouseButton1Click:Connect(function() speedEnabled = not speedEnabled updateUI() end)
EgorB.MouseButton1Click:Connect(function() egorModeEnabled = not egorModeEnabled updateUI() end)
JumpBoostB.MouseButton1Click:Connect(function() jumpBoostEnabled = not jumpBoostEnabled updateUI() end)

GodModeB.MouseButton1Click:Connect(function()
	godModeEnabled = not godModeEnabled
	if P.Character then setupGodMode(P.Character) end
	updateUI()
end)

CloneSkinB.MouseButton1Click:Connect(function() cloneSkinEnabled = not cloneSkinEnabled updateCloneSkin() updateUI() end)
BigHeadB.MouseButton1Click:Connect(function() bigHeadEnabled = not bigHeadEnabled updateBigHead() updateUI() end)
AllBigHeadB.MouseButton1Click:Connect(function() allBigHeadEnabled = not allBigHeadEnabled updateAllBigHead() updateUI() end)

TpB.MouseButton1Click:Connect(function()
	local targetName = TpBox.Text
	if targetName == "" then return end
	local targetPlayer = nil
	for _, plr in ipairs(Pl:GetPlayers()) do
		if string.lower(string.sub(plr.Name, 1, string.len(targetName))) == string.lower(targetName) then targetPlayer = plr break end
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

local function toggleLang() lang = (lang=="RU" and "EN" or "RU") updateUI() end
LangB.MouseButton1Click:Connect(toggleLang)
LangPlayerB.MouseButton1Click:Connect(toggleLang)
LangModsB.MouseButton1Click:Connect(toggleLang)
LangTikTokB.MouseButton1Click:Connect(toggleLang)

P.CharacterAdded:Connect(function(c)
	c:WaitForChild("Humanoid") task.wait(0.5) saveOriginalAnims(c)
	setupGodMode(c)
	if korblox then applyKorblox() end 
	if headless then applyHeadless() end
	if espEnabled then updateESP() end
	if cloneSkinEnabled then task.wait(1) updateCloneSkin() end
	if bigHeadEnabled then updateBigHead() end
	if allBigHeadEnabled then updateAllBigHead() end
end)

if P.Character then 
	saveOriginalAnims(P.Character)
	setupGodManager = setupGodMode(P.Character)
end

setSky(1) updateUI() switchTab("Visual")
