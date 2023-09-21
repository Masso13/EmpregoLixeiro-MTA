local range = 2
local last = 0

local function getPartPosition(element, part)
    local x, y, z = false, nil, nil
    if getElementType(element) == "vehicle" then
        x, y, z = getVehicleComponentPosition(element, part, "world")
    end
    return x, y, z
end

local function getDistanceBetweenElements(element1, element2)
    local x1, y1, z1 = getElementPosition(element1)
    local x2, y2, z2 = getElementPosition(element2)
    return getDistanceBetweenPoints3D(x1, y1, z1, x2, y2, z2)
end

local function isInTable(table, item)
    for _, table_item in ipairs(table) do if table_item == item then return true end end
    return false
end

local function checkElementsByType(type_check, element)
    for _, check_element in ipairs(getElementsByType(type_check)) do if getElementData(check_element, "object") == element then return {check_element, getElementData(check_element, "sacos_lixo") or false} end end
    return {false, false}
end

addEventHandler("onClientClick", root,
    function(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, hitelement)
        if getTickCount() - last >= 1000 and button == "left" and state == "down" then
            if hitelement and isInTable({"vehicle", "object"}, getElementType(hitelement)) then
                local type_element = getElementType(hitelement)
                if type_element == "vehicle" and getElementModel(hitelement) == 408 then
                    local part_x, part_y, part_z = getPartPosition(hitelement, "bump_front_dummy")
                    if part_x then
                        local garbage_bag = getElementData(hitelement, "sacos_lixo")
                        local px, py, pz = getElementPosition(localPlayer)
                        local distance = getDistanceBetweenPoints3D(px, py, pz, part_x, part_y, part_z)
                        if distance > 8.1 and distance < 8.5 then
                            local player_have = getElementData(localPlayer, "sacos_lixo") or false
                            if garbage_bag and not player_have then
                                triggerServerEvent("addLixo", root, localPlayer, hitelement)
                                triggerEvent("add:notification", localPlayer, "Você retirou um lixo do caminhão", "info", true)
                            elseif player_have then
                                triggerServerEvent("addLixo", root, hitelement, localPlayer)
                                triggerEvent("add:notification", localPlayer, "Você colocou um lixo do caminhão", "info", true)
                            end
                        end
                    end
                elseif type_element == "object" then
                    local element_type, garbage_bag = unpack(checkElementsByType("trash", hitelement))
                    if getDistanceBetweenElements(localPlayer, hitelement) <= 2 then
                        local player_have = getElementData(localPlayer, "sacos_lixo") or false
                        if garbage_bag and not player_have then
                            triggerEvent("add:notification", localPlayer, "Você retirou um lixo da lixeira", "info", true)
                            triggerServerEvent("addLixo", root, localPlayer, element_type)
                        elseif player_have then
                            triggerEvent("add:notification", localPlayer, "Você colocou um lixo da lixeira", "info", true)
                            triggerServerEvent("addLixo", root, element_type, localPlayer)
                        end
                    end
                end
            end
            last = getTickCount()
        end
    end, true, "low"
)