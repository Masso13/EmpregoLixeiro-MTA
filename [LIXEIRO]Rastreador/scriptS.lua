function sendToClient(player, seat)
    if getElementModel(source) == 408 then
        triggerClientEvent(player, "renderTrashPoints", root)
    end
end

addEventHandler("onVehicleEnter", root, sendToClient)

addEventHandler("onVehicleExit", root, sendToClient)