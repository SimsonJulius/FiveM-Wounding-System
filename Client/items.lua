RegisterNetEvent("wounding:items:gauze")
AddEventHandler("wounding:items:gauze", function(item)
    TriggerEvent("mythic_progbar:client:progress", {
        name = "firstaid_action",
        duration = 3000,
        label = "Wunden Verbinden",
        useWhileDead = false,
        canCancel = true,
        controlDisables = {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        },
        animation = {
            animDict = "missheistdockssetup1clipboard@idle_a",
            anim = "idle_a",
            flags = 49,
        },
        prop = {
            model = "prop_paper_bag_small",
        }
    }, function(status)
        if not status then
            TriggerEvent('wounding:client:RemoveBleed')
            TriggerEvent('wounding:client:FieldTreatBleed')
        end
    end)
end)

RegisterNetEvent("wounding:items:bandage")
AddEventHandler("wounding:items:bandage", function(item)
    TriggerEvent("mythic_progbar:client:progress", {
        name = "firstaid_action",
        duration = 5000,
        label = "Verband anlegen",
        useWhileDead = false,
        canCancel = true,
        controlDisables = {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        },
        animation = {
            animDict = "missheistdockssetup1clipboard@idle_a",
            anim = "idle_a",
            flags = 49,
        },
        prop = {
            model = "prop_paper_bag_small",
        }
    }, function(status)
        if not status then
			local maxHealth = GetEntityMaxHealth(PlayerPedId())
			local health = GetEntityHealth(PlayerPedId())
			local newHealth = math.min(maxHealth, math.floor(health + maxHealth / 16))
            SetEntityHealth(PlayerPedId(), newHealth)
            TriggerEvent('wounding:client:ReduceBleed')
        end
    end)
end)

RegisterNetEvent("wounding:items:firstaid")
AddEventHandler("wounding:items:firstaid", function(item)
    TriggerEvent("mythic_progbar:client:progress", {
        name = "firstaid_action",
        duration = 10000,
        label = "Erste Hilfe anwenden",
        useWhileDead = false,
        canCancel = true,
        controlDisables = {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        },
        animation = {
            animDict = "missheistdockssetup1clipboard@idle_a",
            anim = "idle_a",
            flags = 49,
        },
        prop = {
            model = "prop_stat_pack_01"
        },
    }, function(status)
        if not status then
			local maxHealth = GetEntityMaxHealth(PlayerPedId())
			local health = GetEntityHealth(PlayerPedId())
			local newHealth = math.min(maxHealth, math.floor(health + maxHealth / 8))
            SetEntityHealth(PlayerPedId(), newHealth)
            TriggerEvent('wounding:client:FieldTreatLimbs')
        end
    end)
end)

RegisterNetEvent("wounding:items:medkit")
AddEventHandler("wounding:items:medkit", function(item)
    TriggerEvent("mythic_progbar:client:progress", {
        name = "firstaid_action",
        duration = 20000,
        label = "Medikit anwenden",
        useWhileDead = false,
        canCancel = true,
        controlDisables = {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        },
        animation = {
            animDict = "missheistdockssetup1clipboard@idle_a",
            anim = "idle_a",
            flags = 49,
        },
        prop = {
            model = "prop_ld_health_pack"
        },
    }, function(status)
        if not status then
			SetEntityHealth(PlayerPedId(), GetEntityMaxHealth(PlayerPedId()))
            TriggerEvent('wounding:client:FieldTreatLimbs')
            TriggerEvent('wounding:client:ResetLimbs')
        end
    end)
end)

RegisterNetEvent("wounding:items:vicodin")
AddEventHandler("wounding:items:vicodin", function(item)
    TriggerEvent("mythic_progbar:client:progress", {
        name = "firstaid_action",
        duration = 2000,
        label = "Vicodin einnehmen",
        useWhileDead = false,
        canCancel = true,
        controlDisables = {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        },
        animation = {
            animDict = "mp_suicide",
            anim = "pill",
            flags = 49,
        },
        prop = {
            model = "prop_cs_pills",
            bone = 58866,
            coords = { x = 0.1, y = 0.0, z = 0.001 },
            rotation = { x = -60.0, y = 0.0, z = 0.0 },
        },
    }, function(status)
        if not status then
            TriggerEvent('wounding:client:UsePainKiller', 1)
        end
    end)
end)

RegisterNetEvent("wounding:items:hydrocodone")
AddEventHandler("wounding:items:hydrocodone", function(item)
    TriggerEvent("mythic_progbar:client:progress", {
        name = "firstaid_action",
        duration = 2000,
        label = "Hydrocodone einnehmen",
        useWhileDead = false,
        canCancel = true,
        controlDisables = {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        },
        animation = {
            animDict = "mp_suicide",
            anim = "pill",
            flags = 49,
        },
        prop = {
            model = "prop_cs_pills",
            bone = 58866,
            coords = { x = 0.1, y = 0.0, z = 0.001 },
            rotation = { x = -60.0, y = 0.0, z = 0.0 },
        },
    }, function(status)
        if not status then
            TriggerEvent('wounding:client:UsePainKiller', 2)
        end
    end)
end)

RegisterNetEvent("wounding:items:morphine")
AddEventHandler("wounding:items:morphine", function(item)
    TriggerEvent("mythic_progbar:client:progress", {
        name = "firstaid_action",
        duration = 2000,
        label = "Morphine einnehmen",
        useWhileDead = false,
        canCancel = true,
        controlDisables = {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        },
        animation = {
            animDict = "mp_suicide",
            anim = "pill",
            flags = 49,
        },
        prop = {
            model = "prop_cs_pills",
            bone = 58866,
            coords = { x = 0.1, y = 0.0, z = 0.001 },
            rotation = { x = -60.0, y = 0.0, z = 0.0 },
        },
    }, function(status)
        if not status then
            TriggerEvent('wounding:client:UsePainKiller', 6)
            TriggerEvent('wounding:client:UseAdrenaline', 2)
        end
    end)
end)
