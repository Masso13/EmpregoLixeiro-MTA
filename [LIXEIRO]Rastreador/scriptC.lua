local element_blip = false
local prox = false
local rendering = false
local timer

function getDistanceByElement(element)
    local px, py, pz = getElementPosition(localPlayer)
    local x, y, z = getElementPosition(element)
    return getDistanceBetweenPoints3D(px, py, pz, x, y, z)
end

function processProx(element)
    local distance = getDistanceByElement(element)
    if not prox then prox = {element} end
    if distance < getDistanceByElement(prox[1]) then
        prox = {element}
    end
end


function renderTrashs()
    for i, element in ipairs(getElementsByType("trash")) do
        local object = getElementData(element, "object")
        processProx(object)
    end
    if element_blip ~= prox[2] then
        if type(element_blip) ~= "boolean" then
            destroyElement(element_blip)
        end
        element_blip = createBlipAttachedTo(prox[1], 41)
        table.insert(prox, element_blip)
    end
end

addEvent("renderTrashPoints", true)
addEventHandler("renderTrashPoints", root, 
    function()
        if not rendering then
            timer = setTimer(renderTrashs, 500, 0)
            rendering = true
        else
            killTimer(timer)
            destroyElement(element_blip)
            prox = false
            element_blip = false
            rendering = false
        end
    end
)