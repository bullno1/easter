local appId = ...

local socket = require 'socket'
local searchSock = assert(socket.udp())
searchSock:setoption('broadcast', true)
searchSock:setsockname('*', 0)

searchSock:sendto(appId, "255.255.255.255", 9008)

searchSock:settimeout(1)

repeat
	local data, addr, port = searchSock:receivefrom()
	if data ~= nil then
		local sepPos = data:find("@")
		print(data:sub(1, sepPos - 1), addr, data:sub(sepPos + 1))
	end
until data == nil
