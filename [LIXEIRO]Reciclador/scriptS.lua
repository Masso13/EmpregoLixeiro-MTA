local marker_reciclagem = createMarker(-1829.7044677734, -1698.7513427734, 23.940624237061-1, "cylinder", 1.6, 255, 255, 255, 255, root)

addEventHandler("onMarkerHit", marker_reciclagem,
    function(hitelement)
        if getElementType(hitelement) == "player" and getElementData(hitelement, "sacos_lixo") or false then
            triggerEvent("addLixo", root, marker_reciclagem, hitelement)
            triggerClientEvent(hitelement, "add:notification", root, "Você colocou um lixo no container", "info", true)
        end
    end
)

addEvent("addLixo", true)
addEventHandler("addLixo", root,
    function(target, receive)
        local lixo = (getElementData(receive, "sacos_lixo") or 0) - 1
        if lixo <= 0 then
            removeElementData(receive, "sacos_lixo")
            if getElementType(receive) == "player" then
                local saco = getElementData(receive, "saco_objeto")
                destroyElement(saco)
            end
        else
            setElementData(receive, "sacos_lixo", lixo)
        end
        setElementData(target, "sacos_lixo", (getElementData(target, "sacos_lixo") or 0)+1)
        if getElementType(target) == "player" then
            local x, y, z = getElementPosition(target)
            local saco = createObject(1265, x, y, z)
            setObjectScale(saco, 0.5)
            setElementData(target, "saco_objeto", saco)
            exports.bone_attach:attachElementToBone(saco, target, 12, _, _, 0.1, _, 180)
        end
    end, true, "low"
)