local trash_elements = {}

addEventHandler("onResourceStart", root,
    function(res)
        if res == getThisResource() then
            for i, coord in ipairs(trashs) do
                table.insert(trash_elements, createElement("trash"))
                setElementData(trash_elements[i], "object", createObject(1328, coord[1], coord[2], coord[3], _, _, _, true))
                setElementData(trash_elements[i], "sacos_lixo", 1)
            end
        end
    end
)

addEventHandler("onResourceStop", root,
    function()
        if res == getThisResource() then
            for i, element in ipairs(trash_elements) do
                destroyElement(element)
            end
            trash_elements = nil
        end
    end
)