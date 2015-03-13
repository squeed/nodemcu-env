-- NodeMCU initialization environment
-- This will open a telnet server for 25 seconds, then run
-- main.lua on timeout

-- The telnet server
_telnetSocket = nil
inboot = true

-- Start wifi init timer
tmr.alarm(0, 2500, 0, _checkwifi)

function _checkwifi()
	print("Are we alive?")
	status = wifi.sta.status()
	print(status)
	if (status == 5) then
		print ("Wifi is alive!")
		-- Once wifi is alive, proceed with booting
		bcast()
		_startRunTimer()
		telnetServer(true)
	else
		print("Wifi not alive " .. status)
		tmr.alarm(0, 2500, 0, _checkwifi)
	end
end

-- Send a broadcast UDP Packet to port 5050 for discovery
function bcast()
	bcip = wifi.sta.getbroadcast()
	print("Sending broadcast ping")
	print("Broadcast address: " .. bcip)
	conn = net.createConnection(net.UDP, 0)
	conn:connect(5050, bcip)
	ip, nm = wifi.sta.getip()
	sendstr = ip .. " " .. node.chipid() .. " " .. node.flashid() .. "\n"
	conn:send("HELO 0 " .. sendstr, function(cb) print("sent!"); end)
end

-- Start the 25 second countdown to "normal" boot
function _startRunTimer()
	tmr.alarm(1, 25000, 0, function()
		_telnetSocket:close()
		_telnetSocket = nil
		run()
	end)
end

-- Stop the 25 second countdown
function _stopRunTimer()
	if inboot then
		tmr.stop(1)
		inboot = false
	end
end

-- Open a "telnet" server on port 2323
function telnetServer()
	print("Starting telnet server")
	_telnetSocket = net.createServer(net.TCP,180)
	_telnetSocket:listen(2323,function(c) 
		function s_output(str) 
			if(c~=nil) 
				then c:send(str) 
			end 
		end 
		node.output(s_output, 0)   -- re-direct output to function s_ouput.
		c:on("connection", function(c)
			_stopRunTimer() -- Stop the run timer so we don't go to main.lua
		end)
		c:on("receive",function(c,l) 
			node.input(l)
		end)
		c:on("disconnection",function(c)
			node.output(nil)
			print("Telnet disconnect")
		end) 
		print("connected")
	end)
end

function run()
	print("Done with pre-boot...")
	exists = file.open("main.lua")
	file.close()
	if exists then
		print("Running main.lua")
		dofile("main.lua")
	else if _telnetSocket == nil then
		print("Telnet time!")
		telnetServer(false)
	end
end




