local LocalPlayer = game.Players.LocalPlayer
local WaveText = LocalPlayer.PlayerGui.Interface.GameInfoBar.Wave.WaveText
local SkipWave = LocalPlayer.PlayerGui.Interface.TopAreaQueueFrame.SkipWaveVoteScreen

local DelayList = {
}

function get_wave()
    local n = string.gsub(WaveText.Text, "WAVE ", "")
    return tonumber(n)
end

local now_wave = get_wave()
while now_wave <= 27 do
  wait()
  if SkipWave.Visible then
    task.wait(DelayList[now_wave] or 0)
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("SkipWaveVoteCast"):FireServer(true)
    wait(2)
  end
  now_wave = get_wave()
end

