-- Blink the LED
pin = 0
gpio.mode(pin, gpio.OUTPUT)
gpio.write(pin, gpio.HIGH)
state = 1

function toggle()
	if state == 1 then
		gpio.write(pin, gpio.LOW)
		state = 0
	else
		gpio.write(pin, gpio.HIGH)
		state = 1
	end
	tmr.alarm(1, 500, toggle)
end

tmr.alarm(1, 500, toggle)
