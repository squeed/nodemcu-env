wifi.setmode(wifi.STATION)
wifi.sta.config(xxx, yyy)
print(wifi.sta.getip())

-- Bootstrapping code
f=''; srv = net.createServer(net.TCP); srv:listen(2000, function(c)print(node.heap()); c:on("receive",function(c, l) f = f .. l; print("get"); end); c:on("disconnection", function(c) print('DISCONNECTION'); print(node.heap()); end); end);

file.open('hmm.lua', 'w'); file.write(f); file.close(); srv:close();
dofile('hmm.lua')

