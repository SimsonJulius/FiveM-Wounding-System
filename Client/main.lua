local hospitalCheckin = {x = 308.06161499023, y = -595.19683837891, z = 43.291839599609, h = 180.4409942627}
local sandyCheckin = {x = 1840.12, y = 3673.33, z = 34.28, h = 27.55}
local paletoCheckin = {x = -247.78, y = 6331.31, z = 32.43}
local pillboxTeleports = {
    {
        x = 325.48892211914,
        y = -598.75372314453,
        z = 43.291839599609,
        h = 64.513374328613,
        text = "Drucke ~INPUT_CONTEXT~ ~s~um in den unteren Pillbox Eingang zu gehen"
    },
    {
        x = 355.47183227539,
        y = -596.26495361328,
        z = 28.773477554321,
        h = 245.85662841797,
        text = "Drucke ~INPUT_CONTEXT~ ~s~um das Pillbox Krankenhaus zu betreten"
    },
    {
        x = 359.57849121094,
        y = -584.90911865234,
        z = 28.817169189453,
        h = 245.85662841797,
        text = "Drucke ~INPUT_CONTEXT~ ~s~um das Pillbox Krankenhaus zu betreten"
    }
}

local bedOccupying = nil
local bedOccupyingData = nil

local cam = nil

local inBedDict = "anim@gangops@morgue@table@"
local inBedAnim = "ko_front"
local getOutDict = "switch@franklin@bed"
local getOutAnim = "sleep_getup_rubeyes"
ESX = exports['es_extended']:getSharedObject()

Citizen.CreateThread(
    function()
        while true do
            SetPlayerHealthRechargeMultiplier(PlayerId(0), 0.0)
        end
        Citizen.Wait(0)
    end
)

function PrintHelpText(message)
    SetTextComponentFormat("STRING")
    AddTextComponentString(message)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function LeaveBed()
    RequestAnimDict(getOutDict)
    while not HasAnimDictLoaded(getOutDict) do
        Citizen.Wait(0)
    end

    RenderScriptCams(0, true, 200, true, true)
    DestroyCam(cam, false)

    SetEntityHeading(PlayerPedId(), bedOccupyingData.h - 90)
    TaskPlayAnim(PlayerPedId(), getOutDict, getOutAnim, 8.0, -8.0, -1, 0, 0, false, false, false)
    Citizen.Wait(5000)
    ClearPedTasks(PlayerPedId())
    FreezeEntityPosition(PlayerPedId(), false)
    TriggerServerEvent("wounding:server:LeaveBed", bedOccupying)

    bedOccupying = nil
    bedOccupyingData = nil
end

RegisterNetEvent("wounding:client:RPCheckPos")
AddEventHandler(
    "wounding:client:RPCheckPos",
    function()
        TriggerServerEvent("wounding:server:RPRequestBed", GetEntityCoords(PlayerPedId()))
    end
)

RegisterNetEvent("wounding:client:RPSendToBed")
AddEventHandler(
    "wounding:client:RPSendToBed",
    function(id, data)
        bedOccupying = id
        bedOccupyingData = data

        SetEntityCoords(PlayerPedId(), data.x, data.y, data.z - 0.5)

        RequestAnimDict(inBedDict)
        while not HasAnimDictLoaded(inBedDict) do
            Citizen.Wait(0)
        end

        TaskPlayAnim(PlayerPedId(), inBedDict, inBedAnim, 8.0, -8.0, -1, 1, 0, false, false, false)
        SetEntityHeading(PlayerPedId(), data.h + 180)

        cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
        SetCamActive(cam, true)
        RenderScriptCams(true, false, 1, true, true)
        AttachCamToPedBone(cam, PlayerPedId(), 31085, 0, 0, 1.0, true)
        SetCamFov(cam, 90.0)
        SetCamRot(cam, -90.0, 0.0, GetEntityHeading(PlayerPedId()) + 180, true)

        Citizen.CreateThread(
            function()
                while bedOccupyingData ~= nil do
                    Citizen.Wait(1)
                    PrintHelpText("Drucke ~INPUT_VEH_DUCK~ um aufzustehen")
                    if IsControlJustReleased(0, 73) then
                        LeaveBed()
                    end
                end
            end
        )
    end
)

RegisterNetEvent("wounding:client:SendToBed")
AddEventHandler(
    "wounding:client:SendToBed",
    function(id, data)
        bedOccupying = id
        bedOccupyingData = data

        SetEntityCoords(PlayerPedId(), data.x, data.y, data.z - 0.3)
        RequestAnimDict(inBedDict)
        while not HasAnimDictLoaded(inBedDict) do
            Citizen.Wait(0)
        end
        TaskPlayAnim(PlayerPedId(), inBedDict, inBedAnim, 8.0, -8.0, -1, 1, 0, false, false, false)
        SetEntityHeading(PlayerPedId(), data.h + 180)

        cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
        SetCamActive(cam, true)
        RenderScriptCams(true, false, 1, true, true)
        AttachCamToPedBone(cam, PlayerPedId(), 31085, 0, 0, 1.0, true)
        SetCamFov(cam, 90.0)
        SetCamRot(cam, -90.0, 0.0, GetEntityHeading(PlayerPedId()) + 180, true)

        Citizen.CreateThread(
            function()
                Citizen.Wait(5)
                local player = PlayerPedId()

                ESX.ShowNotification('Du wirst nun behandelt', 3000, 'info')
                Citizen.Wait(5000)
                TriggerServerEvent("wounding:server:EnteredBed")
            end
        )
    end
)

RegisterNetEvent("wounding:client:FinishServices")
AddEventHandler(
    "wounding:client:FinishServices",
    function()
        SetEntityHealth(PlayerPedId(), GetEntityMaxHealth(PlayerPedId()))
        TriggerEvent("wounding:client:RemoveBleed")
        TriggerEvent("wounding:client:ResetLimbs")
        ESX.ShowNotification('Du wurdest behandelt und dir wurde eine Rechnung ausgestellt', 5000, 'success')
        LeaveBed()
    end
)

RegisterNetEvent("wounding:client:ForceLeaveBed")
AddEventHandler(
    "wounding:client:ForceLeaveBed",
    function()
        LeaveBed()
    end
)

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(1)
            local plyCoords = GetEntityCoords(PlayerPedId(), 0)
            local distance = #(vector3(hospitalCheckin.x, hospitalCheckin.y, hospitalCheckin.z) - plyCoords)
            local sdistance = #(vector3(sandyCheckin.x, sandyCheckin.y, sandyCheckin.z) - plyCoords)
            local pdistance = #(vector3(paletoCheckin.x, paletoCheckin.y, paletoCheckin.z) - plyCoords)
            if pdistance < 100 then

                if not IsPedInAnyVehicle(PlayerPedId(), true) then
                    if pdistance < 10 then
                        ESX.Game.Utils.DrawText3D(
                            vector3(paletoCheckin.x, paletoCheckin.y, paletoCheckin.z + 0.5),
                            "[E] Einchecken",
                            0.4
                        )
                        if IsControlJustReleased(0, 54) then
                            if (GetEntityHealth(PlayerPedId()) < 200) or (IsInjuredOrBleeding()) then
                                TriggerEvent(
                                    "mythic_progbar:client:progress",
                                    {
                                        name = "hospital_action",
                                        duration = 10500,
                                        label = "Einchecken",
                                        useWhileDead = false,
                                        canCancel = true,
                                        controlDisables = {
                                            disableMovement = true,
                                            disableCarMovement = true,
                                            disableMouse = false,
                                            disableCombat = true
                                        },
                                        animation = {
                                            animDict = "missheistdockssetup1clipboard@base",
                                            anim = "base",
                                            flags = 49
                                        },
                                        prop = {
                                            model = "p_amb_clipboard_01",
                                            bone = 18905,
                                            coords = {x = 0.10, y = 0.02, z = 0.08},
                                            rotation = {x = -80.0, y = 0.0, z = 0.0}
                                        },
                                        propTwo = {
                                            model = "prop_pencil_01",
                                            bone = 58866,
                                            coords = {x = 0.12, y = 0.0, z = 0.001},
                                            rotation = {x = -150.0, y = 0.0, z = 0.0}
                                        }
                                    },
                                    function(status)
                                        if not status then
                                            TriggerServerEvent("wounding:server:RequestBed")
                                        end
                                    end
                                )
                            else
                                ESX.ShowNotification('Du brauchst keine Arztliche Hilfe', 3000, 'info')
                            end
                        end
                    end
                end
            elseif sdistance < 100 then

                if not IsPedInAnyVehicle(PlayerPedId(), true) then
                    if sdistance < 10 then
                        ESX.Game.Utils.DrawText3D(
                            vector3(sandyCheckin.x, sandyCheckin.y, sandyCheckin.z + 0.5),
                            "[E] Einchecken",
                            0.4
                        )
                        if IsControlJustReleased(0, 54) then
                            if (GetEntityHealth(PlayerPedId()) < 200) or (IsInjuredOrBleeding()) then
                                TriggerEvent(
                                    "mythic_progbar:client:progress",
                                    {
                                        name = "hospital_action",
                                        duration = 10500,
                                        label = "Einchecken",
                                        useWhileDead = false,
                                        canCancel = true,
                                        controlDisables = {
                                            disableMovement = true,
                                            disableCarMovement = true,
                                            disableMouse = false,
                                            disableCombat = true
                                        },
                                        animation = {
                                            animDict = "missheistdockssetup1clipboard@base",
                                            anim = "base",
                                            flags = 49
                                        },
                                        prop = {
                                            model = "p_amb_clipboard_01",
                                            bone = 18905,
                                            coords = {x = 0.10, y = 0.02, z = 0.08},
                                            rotation = {x = -80.0, y = 0.0, z = 0.0}
                                        },
                                        propTwo = {
                                            model = "prop_pencil_01",
                                            bone = 58866,
                                            coords = {x = 0.12, y = 0.0, z = 0.001},
                                            rotation = {x = -150.0, y = 0.0, z = 0.0}
                                        }
                                    },
                                    function(status)
                                        if not status then
                                            TriggerServerEvent("wounding:server:RequestBed")
                                        end
                                    end
                                )
                            else
                                ESX.ShowNotification('Du brauchst keine Arztliche Hilfe', 3000, 'info')
                            end
                        end
                    end
                end
            elseif distance < 100 then

                if not IsPedInAnyVehicle(PlayerPedId(), true) then
                    if distance < 10 then
                        ESX.Game.Utils.DrawText3D(
                            vector3(hospitalCheckin.x, hospitalCheckin.y, hospitalCheckin.z + 0.5),
                            "[E] Check in",
                            0.4
                        )
                        if IsControlJustReleased(0, 54) then
                            if (GetEntityHealth(PlayerPedId()) < 200) or (IsInjuredOrBleeding()) then
                                TriggerEvent(
                                    "mythic_progbar:client:progress",
                                    {
                                        name = "hospital_action",
                                        duration = 10500,
                                        label = "Checking In",
                                        useWhileDead = false,
                                        canCancel = true,
                                        controlDisables = {
                                            disableMovement = true,
                                            disableCarMovement = true,
                                            disableMouse = false,
                                            disableCombat = true
                                        },
                                        animation = {
                                            animDict = "missheistdockssetup1clipboard@base",
                                            anim = "base",
                                            flags = 49
                                        },
                                        prop = {
                                            model = "p_amb_clipboard_01",
                                            bone = 18905,
                                            coords = {x = 0.10, y = 0.02, z = 0.08},
                                            rotation = {x = -80.0, y = 0.0, z = 0.0}
                                        },
                                        propTwo = {
                                            model = "prop_pencil_01",
                                            bone = 58866,
                                            coords = {x = 0.12, y = 0.0, z = 0.001},
                                            rotation = {x = -150.0, y = 0.0, z = 0.0}
                                        }
                                    },
                                    function(status)
                                        if not status then
                                            TriggerServerEvent("wounding:server:RequestBed")
                                        end
                                    end
                                )
                            else
                                ESX.ShowNotification('Du brauchst keine Arztliche Hilfe', 3000, 'info')
                            end
                        end
                    end
                end
            else
                Citizen.Wait(1000)
            end
        end
    end
)
