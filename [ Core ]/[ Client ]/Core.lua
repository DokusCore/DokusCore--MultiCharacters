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
  SelectedID = nil
end)
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
CreateThread(function()
	while true do Wait(0)
    local Network = NetworkIsSessionStarted()
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
  local CharID = Data['cData']['CharID']
  local Steam = Data['cData']['Steam']
  SelectedID = CharID
  local Event = 'DokusCore:S:Core:DB:GetViaSteamAndCharID'
  local Data = TSC(Event, {DB.Characters.Get, Steam, CharID})
  local Data = ConvertToCoords(Data.Coords)
  local Data = SplitString(Data, " ")
  local x,y,z = tonumber(Data[1]), tonumber(Data[2]), tonumber(Data[3])
  local Coords = vector3(x,y,z)
  TSC('DokusCore:S:Core:UpdateCoreUserData', {'CharID', CharID})
  TSC('DokusCore:S:Core:UpdateCoreUserData', {'Coords', Coords})
  TriggerEvent('DokusCore:MultiChar:C:TPPlayer', Coords)
  TriggerEvent('DokusCore:MultiChar:C:SetInvisible', true, false)
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
  DoScreenFadeOut(1500) Wait(1500)
  SetNuiFocus(false, false)
  ToggleMenu(false)
  TriggerServerEvent('DokusCore:MultiChar:S:CreateCharacter', Data, _StartCoords[1], _StartCoords[2], _StartCoords[3])
  SetCoords(Ped, _StartCoords[1], _StartCoords[2], _StartCoords[3], true, false)
  TSC('DokusCore:S:Core:UpdateCoreUserData', {'Coords', vector3(_StartCoords[1], _StartCoords[2], _StartCoords[3])})
  TriggerEvent('DokusCore:C:Core:Sounds:PlayOnUser', 'TrainPass', 1.0) Wait(15000)
  DoScreenFadeIn(15000)
end)
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
RegisterNUICallback('removeCharacter', function(Data)
  TriggerServerEvent('DokusCore:MultiChar:S:DeleteCharacter', Data.Steam, Data.CharID)
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
