waxClass{"PGEventTesting", Plugin}

function ePluginLoaded(self)
  puts("PGEventTesting Loaded")
  
end

function ePlayerFound(self, player)
	print("player found in PGEventTesting")
end


function ePlayerDied(self)
	print("Player died")
end

function ePlayerAuraGained(self, spell)
	print("Player gained aura")
end

function ePetAuraGained(self, spell)
	print("Pet gained aura")
end

function eTargetAuraGained(self, spell)
	print("Target gained aura")
end

function ePlayerAuraFaded(self, spell)
	print("Player lost aura")
end

function eMessageReceived(self, chatLogEntry)
	
end

function eWhisperReceived(self, chatLogEntry)
	print("PGEventTesting whisper received")
end

function eBotStart(self)
	print("PGEventTesting Bot Start")
end