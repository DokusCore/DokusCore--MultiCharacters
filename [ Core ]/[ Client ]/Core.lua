--------------------------------------------------------------------------------
---------------------------------- DokusCore -----------------------------------
--------------------------------------------------------------------------------
SelectedID = nil
--------------------------------------------------------------------------------
RegisterCommand('logout', function(source, args, rawCommand)
  local Ped = PlayerPedId()
  local Coords = GetEntityCoords(Ped)
  TriggerEvent('DokusCore:MultiChar:C:ChooseChar')
  TSC('DokusCore:S:Core:UpdateCoreUserData', {'Coords', nil})
  local Steam = TSC('DokusCore:S:Core:GetUserIDs')[1]
  local Event = 'DokusCore:S:Core:DB:UpdateViaSteamAndCharID'
  TSC(Event, {DB.Characters.SetCoords, 'Coords', Coords, Steam, SelectedID})
  TriggerEvent('DokusCore:C:Core:Hud:Toggle', false)
  TriggerEvent('DokusCore:C:Core:Hud:Update', {0, 0})
  SelectedID = nil
end)
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
CreateThread(function()
	while true do Wait(0)
    local Network = NetworkIsSessionStarted()
    TriggerEvent('DokusCore:C:Core:Hud:Toggle', false)
    TriggerEvent('DokusCore:MultiChar:C:SetInvisible', false, true)
		if Network then	TriggerEvent('DokusCore:MultiChar:C:ChooseChar') return end
	end
end)
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
RegisterNetEvent('DokusCore:MultiChar:C:ChooseChar')
AddEventHandler('DokusCore:MultiChar:C:ChooseChar', function()
  local PediD = PlayerPedId()
  local GetPed = GetPlayerPed(-1)
  SetNuiFocus(false, false)
  DoScreenFadeOut(1500) Wait(2000)
  SetEntityVisible(PediD, false)
  FreezeEntityPosition(PediD, true)
  SetEntityCoords(PediD, -355.6, 790.0, 100.2) Wait(1500)
  ShutdownLoadingScreenNui()
  ShutdownLoadingScreen() Wait(1)
  ShutdownLoadingScreenNui()
  ShutdownLoadingScreen()
  ToggleMenu(true)
end)
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
RegisterNUICallback('selectCharacter', function(Data)
  DoScreenFadeOut(1500) Wait(1500)
  ToggleMenu(false)
  local Ped = PlayerPedId()
  local CharID = Data['cData']['CharID']
  local Steam = Data['cData']['Steam']
  SelectedID = CharID
  local Event = 'DokusCore:S:Core:DB:GetViaSteamAndCharID'
  local cData = TSC(Event, {DB.Characters.Get, Steam, CharID})[1]
  local Data = ConvertToCoords(cData.Coords)
  local Data = SplitString(Data, " ")
  local x,y,z = tonumber(Data[1]), tonumber(Data[2]), tonumber(Data[3])
  local Coords = vector3(x,y,z)
  TSC('DokusCore:S:Core:UpdateCoreUserData', {'CharID', CharID})
  TSC('DokusCore:S:Core:UpdateCoreUserData', {'Coords', Coords})
  TriggerEvent('DokusCore:MultiChar:C:TPPlayer', Coords)
  TriggerEvent('DokusCore:MultiChar:C:SetInvisible', true, false)
  local Data = TSC('DokusCore:S:Core:DB:GetViaSteamAndCharID', {DB.Banks.Get, Steam, CharID})[1]
  local sID = TSC('DokusCore:S:Core:GetUserServerID')
  TriggerEvent('DokusCore:C:Core:Hud:Update', {Data.Money, Data.BankMoney, SelectedID, sID})
  TriggerEvent('DokusCore:C:Core:Hud:Toggle', true)
  local Skin = json.decode(cData.Skin)
  if (Skin ~= nil) then TriggerEvent('DokusCore:SkinCreator:C:SetSkin', Skin) end
  Wait(1000) DoScreenFadeIn(1500)
end)
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
RegisterNUICallback('closeUI', function() DoScreenFadeIn(1500) ToggleMenu(false) end)
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
RegisterNUICallback('setupCharacters', function()
  local array = {}
  local iDs = TSC('DokusCore:S:Core:GetUserIDs')
  local DBChar = TSC('DokusCore:S:Core:DB:GetViaSteam', {DB.Characters.GetViaSteam, iDs[1]})
  if (DBChar) then
    for k, v in pairs(DBChar) do
      local CharID, cName = v.CharID, v.cName
      table.insert(array, { Steam = iDs[1], CharID = CharID, cName = cName })
    end
    SendNUIMessage({ action = "setupCharacters", characters = array })
  else
    SendNUIMessage({ action = "SetupSteam", value = iDs[1] })
  end
end)
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
RegisterNUICallback('createNewCharacter', function(Data)
  local source = source
  local Ped = PlayerPedId()
  local Steam, CharID = Data.Steam, Data.CharID
  SelectedID = CharID
  TSC('DokusCore:S:Core:UpdateCoreUserData', { 'CharID', CharID })
  DoScreenFadeOut(1500) Wait(1500)
  SetNuiFocus(false, false)
  ToggleMenu(false)
  TriggerServerEvent('DokusCore:MultiChar:S:CreateCharacter', Data, _StartCoords[1], _StartCoords[2], _StartCoords[3])
  SetCoords(Ped, _StartCoords[1], _StartCoords[2], _StartCoords[3], true, false)
  TSC('DokusCore:S:Core:UpdateCoreUserData', {'Coords', vector3(_StartCoords[1], _StartCoords[2], _StartCoords[3])})
  TriggerEvent('DokusCore:C:Core:Sounds:PlayOnUser', 'TrainPass', 1.0) Wait(15000)
  local Data = TSC('DokusCore:S:Core:DB:GetViaSteamAndCharID', {DB.Banks.Get, Steam, CharID})[1]
  TriggerEvent('DokusCore:C:Core:Hud:Update', {Data.Money, Data.BankMoney})
  local pCoords = GetEntityCoords(Ped)
  TriggerEvent('DokusCore:SkinCreator:C:OpenMenu', Ped, pCoords)
  DoScreenFadeIn(15000) Wait(3000)
  TriggerEvent('DokusCore:C:Core:Hud:Toggle', true)
  TSC('DokusCore:S:Core:DB:AddInventoryItem', { Steam, CharID, 'Consumable', { 'coffee', 3, nil }})
  TSC('DokusCore:S:Core:DB:AddInventoryItem', { Steam, CharID, 'Consumable', { 'meat', 2, nil }})
end)
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
RegisterNUICallback('removeCharacter', function(Data)
  TSC('DokusCore:S:Core:DB:RemoveAllCharData', {Data.Steam, Data.CharID})
  TriggerEvent('DokusCore:MultiChar:C:ChooseChar')
end)
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
RegisterNetEvent('DokusCore:MultiChar:C:SetInvisible')
AddEventHandler('DokusCore:MultiChar:C:SetInvisible', function(visible, freeze)
  local source = source
  local Ped = PlayerPedId()
  SetEntityVisible(Ped, visible)
  FreezeEntityPosition(Ped, freeze)
end)
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
RegisterNetEvent('DokusCore:MultiChar:C:TPPlayer')
AddEventHandler('DokusCore:MultiChar:C:TPPlayer', function(Coords)
  local source = source
  local Ped = PlayerPedId()
  SetEntityCoords(Ped, Coords)
end)
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
RegisterNetEvent('DokusCore:MultiChar:C:GetCharID')
AddEventHandler('DokusCore:MultiChar:C:GetCharID', function()
  TSC('DokusCore:S:Core:UpdateCoreUserData', { 'CharID', SelectedID })
end)










































--------------------------------------------------------------------------------
