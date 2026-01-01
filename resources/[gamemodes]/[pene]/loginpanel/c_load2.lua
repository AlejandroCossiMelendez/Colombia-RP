--[[
Creado por : Edvis20 

Servidor : ExoticRP

2020
]]

function loadDateFromXML()
		local xml = xmlLoadFile('data.xml')
    if xml then
        local myLogin = xmlFindChild(xml, 'login', 0)
        local myPassword = xmlFindChild(xml, 'password', 0)
        local dateLogin = xmlNodeGetValue(myLogin) or ''
        local datePass = xmlNodeGetValue(myPassword) or ''

        datePass = base64Decode(datePass) -- odkodowujemy zapisane haslo na naszym komputerze

    	xmlUnloadFile(xml)
    	return {dateLogin, datePass}
  	else
    	xml = xmlCreateFile('data.xml', 'data')
    	return ''
  	end
end

function saveDateToXML(login, password)
    password = base64Encode(password) -- kodujemy zapisane haslo, aby ktos go nie ukradl, oczywiscie hasla w mysql sa tak zakodowane, ze nie da sie ich odkodowac

    local xml = xmlLoadFile('data.xml')
    if not xml then
        xml = xmlCreateFile('data.xml', 'data')
    end

    local myLogin = xmlFindChild(xml, 'login', 0)
    if not myLogin then
        myLogin = xmlCreateChild(xml, 'login')
    end

    local myPassword = xmlFindChild(xml, 'password', 0)
    if not myPassword then
        myPassword = xmlCreateChild(xml, 'password')
    end

    xmlNodeSetValue(myLogin, login)
    xmlNodeSetValue(myPassword, password)
    xmlSaveFile(xml)
    xmlUnloadFile(xml)
end
addEvent('saveDateToXML', true)
addEventHandler('saveDateToXML', resourceRoot, saveDateToXML)
