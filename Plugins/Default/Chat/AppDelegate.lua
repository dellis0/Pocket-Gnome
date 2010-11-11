waxClass{"PGChat", Plugin}

function ePluginLoaded(self)
  self.trends = {}
  
  puts("Hello from PGChat")
  
end

function ePlayerFound(self, player)
	print("player found in pgchat")
--[[
	print("Found a player! Yay!")
	
	if ( player ) then
		print("Argument is of type: " .. type(player))
		
		print("Class is " .. player:className())
		
		--puts(wax.instance.methods(player))
		
		print("Player name: " .. tostring(player:name()))
	end
]]
end


function ePlayerDied(self)

end


function eMessageReceived(self, chatLogEntry)
	-- put a return here to suppress all of the chat messages from spamming the lua console
	if(chatLogEntry) then
		print(os.date("%X",chatLogEntry:timeStamp()).."["..chatLogEntry:channel().."]["..chatLogEntry:playerName().."] "..chatLogEntry:text())
	end
	
end


function eWhisperReceived(self, chatLogEntry)

	if(chatLogEntry) then
	
	
		print("\n Available functions:")
		for k,v in ipairs(wax.instance.methods(chatLogEntry)) do
			print("\t"..v)
		end
	
	end

end

function sendChatMessage(message)
	
--[[	if(message) then
		puts(wax.instance.methods(self))
	end
]]
end


function eBotStart(self)

	-- prints everything in the global table
	--for k,v in pairs(_G) do print(k) end
--	print("Do we want the bot to start? FUCK NO!")
	
	--DisplayError("No", "I don't want you to start!")
	
	--DisplayError("No")

--	return NO;

end