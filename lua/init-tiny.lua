-- init environment, minified
function _w()
	print("_w")
	if (wifi.sta.status() == 5) then
		local conn = net.createConnection(net.UDP, 0)
		conn:connect(5050, wifi.sta.getbroadcast())
		conn:send("PING! " .. wifi.sta.getip() .. " " .. node.chipid() .. "\n",
		function(cb) conn:close(); end)
		tmr.alarm(1, 25000, run)
		telnetServer()
	else tmr.alarm(0, 2500, 0, _w) end
end

function telnetServer()
	print(wifi.sta.getip())
	_telnetSocket = net.createServer(net.TCP,180)
	_telnetSocket:listen(2323,function(c) 
		function s_output(str) 
			if(c~=nil) 
				then c:send(str) 
			end 
		end 
		node.output(s_output, 0)
		c:on("connection", function(c) tmr.stop(1); end)
		c:on("receive",function(c,l) node.input(l); end)
		c:on("disconnection",function(c) node.output(nil); end) 
		print("connected")
	end)
end

function run()
	print("running main.lua")
	for k,v in pairs(file.list()) do
		if (k == 'main.lua' or k == 'main.lc') then dofile("main") end
	end
end

function getfile(ip, name)
	file.open(name, "w+")
	local sk = net.createConnection(net.TCP, 0)
	sk:on("receive", function(sck, c) file.write(c); end)
	sk:on("disconnection", function(sck, a) file.flush(); file.close(); end)
	sk:connect(9600, ip);
end

tmr.alarm(0, 2500, 0, _w)
