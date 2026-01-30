addElementToTab("MOVEMENT", "slider", "Высота прыжка", 50, 200, 50, function(s)
    local player = game.Players.LocalPlayer
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.JumpPower = s
    end
end)

addElementToTab("MOVEMENT", "slider", "Скорость игрока", 16, 250, 16, function(s)
    local player = game.Players.LocalPlayer
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = s
    end
end)
