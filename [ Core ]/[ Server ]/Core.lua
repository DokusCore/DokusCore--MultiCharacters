--------------------------------------------------------------------------------
---------------------------------- DokusCore -----------------------------------
--------------------------------------------------------------------------------
local IsError = false
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
RegisterServerEvent('DokusCore:MultiChar:S:CreateCharacter')
AddEventHandler('DokusCore:MultiChar:S:CreateCharacter', function(Data, x,y,z)
  local source = source
  local cName = Data.Firstname.." "..Data.Lastname
  local Nat, CharID = Data.Nationality, Data.CharID
  local Birth, Gender, Steam = Data.Birthdate, Data.Gender, Data.Steam
  local DBData = TCC(-1, 'DokusCore:C:Core:GetCoreConfig')
  local Coords = "{"..x..", "..y..", "..z.."}"

  local mChar = {
    Steam = Steam, Groups = DBData._Moderation.Users, cName = cName,
    CharID = CharID, Gender = Gender, Nationality = Nat, BirthDate = Birth,
    XP = 0, Level = 0, JobName = DBData._StartJob.Name, JobGrade = 0, Coords = Coords
  }

  MySQL.Async.execute(DB.Characters.InsertTable, mChar, function() end)
  local NeedError = false
  local source = source
  if (cName == ' ') then NeedError = true end
  if (Nat == '') then NeedError = true end
  if (Birth == '') then NeedError = true end
  if NeedError then TriggerEvent('DokusCore:MultiChar:S:IncorrectData', source) end
end)
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
RegisterServerEvent('DokusCore:MultiChar:S:IncorrectData')
AddEventHandler('DokusCore:MultiChar:S:IncorrectData', function(source)
  IsError = not IsError
  local source = source
  while IsError do
    TriggerClientEvent('DokusCore:C:Core:ShowTip', source, _('MultiChar:IncorrectData', User.Language), 5000)
    Wait(5000)
  end
end)
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
RegisterServerEvent('DokusCore:MultiChar:S:DeleteCharacter')
AddEventHandler('DokusCore:MultiChar:S:DeleteCharacter', function(Steam, CharID)
  local Table = DB.Characters.DelViaSteamAndCharID
  local User = TCC(-1, 'DokusCore:C:Core:DB:DelViaSteamAndCharID', {Table, Steam, CharID})
  TriggerClientEvent('DokusCore:MultiChar:C:ChooseChar', -1)
end)
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------