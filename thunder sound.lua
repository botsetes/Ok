local sounds = {
    [1] = "ambient\\thunder2.wav",
    [2] = "ambient\\thunder3.wav",
    [3] = "ambient\\thunder4.wav",
}

local last = globals.TickCount()

function work()
   if not entities.GetLocalPlayer() then
       return
   end

   if globals.TickCount() - last > 384 then
       client.Command("play " .. sounds[math.random(1, 3)
], true);
       last = globals.TickCount()
   end
end

local function work_events(event)
   if event:GetName() == "game_newmap" then
       last = 0
   end
end

client.AllowListener("game_newmap");
callbacks.Register("FireGameEvent", "work_events_thunder", work_events);
callbacks.Register("Draw", "work_thunder", work);
