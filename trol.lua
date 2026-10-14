local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- Webhook ve Görsel Bilgileri
local webhookUrl = "https://discord.com/api/webhooks/1559979879481606274/N7zKWCCdvTRxHA7YwgkaFff0fcqV9xFf8eCEMYT6NqY_1BigqNOJ99oyf1QiMlKAJhec"
local imageUrl = "https://hizliresim.com/tj3rsrui"

-- 1. GUI Oluşturma
local playerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Eğer eski GUI varsa temizleyelim
if playerGui:FindFirstChild("WebhookSendGui") then
playerGui.WebhookSendGui:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "WebhookSendGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Ana Çerçeve (Frame)
local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 300, 0, 180)
frame.Position = UDim2.new(0.5, -150, 0.5, -90) -- Ekranın tam ortasında
frame.BackgroundColor3 = Color3.fromRGB(35, 39, 42)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true -- Sürüklenebilir
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

-- Başlık Label
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Discord Görsel Gönderici"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 18
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.Parent = frame

-- Gönder Butonu
local sendButton = Instance.new("TextButton")
sendButton.Name = "SendButton"
sendButton.Size = UDim2.new(0.8, 0, 0, 45)
sendButton.Position = UDim2.new(0.1, 0, 0.5, -10)
sendButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242) -- Discord mavisi/moru
sendButton.Text = "Görseli Gönder"
sendButton.TextColor3 = Color3.fromRGB(255, 255, 255)
sendButton.TextSize = 16
sendButton.Font = Enum.Font.SourceSansBold
sendButton.Parent = frame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 8)
buttonCorner.Parent = sendButton

-- Durum Bildirim Metni
local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Size = UDim2.new(1, 0, 0, 25)
statusLabel.Position = UDim2.new(0, 0, 0.82, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = ""
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.TextSize = 14
statusLabel.Font = Enum.Font.SourceSans
statusLabel.Parent = frame

-- 2. Webhook Gönderme Fonksiyonu
local isSending = false

local function sendWebhook()
if isSending then return end
isSending = true

sendButton.Text = "Gönderiliyor..."
statusLabel.Text = ""

local payload = {
    ["content"] = "İşte Roblox'tan gönderilen görsel:",
    ["embeds"] = {
        {
            ["title"] = "Roblox Görsel Bildirimi",
            ["image"] = {
                ["url"] = imageUrl
            },
            ["color"] = 65280
        }
    }
}

local requestFunc = (syn and syn.request) or (http and http.request) or request or http_request

-- Eğer Executor (Synapse, Fluxus, Wave vb.) ortamındaysak
if requestFunc then
    local response = requestFunc({
        Url = webhookUrl,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = HttpService:JSONEncode(payload)
    })

    if response and (response.StatusCode == 200 or response.StatusCode == 204) then
        statusLabel.TextColor3 = Color3.fromRGB(87, 242, 135)
        statusLabel.Text = "Başarıyla Gönderildi!"
    else
        statusLabel.TextColor3 = Color3.fromRGB(237, 66, 69)
        statusLabel.Text = "Gönderim Hatası!"
    end
else
    -- Roblox Studio / Normal Oyun içi ortam (Server/LocalScript kısıtlamalarına bağlıdır)
    local success, err = pcall(function()
        return HttpService:PostAsync(webhookUrl, HttpService:JSONEncode(payload), Enum.HttpContentType.ApplicationJson)
    end)

    if success then
        statusLabel.TextColor3 = Color3.fromRGB(87, 242, 135)
        statusLabel.Text = "Başarıyla Gönderildi!"
    else
        statusLabel.TextColor3 = Color3.fromRGB(237, 66, 69)
        statusLabel.Text = "Hata! HTTP iznini kontrol edin."
        warn("Webhook hatası: " .. tostring(err))
    end
end

sendButton.Text = "Görseli Gönder"
isSending = false



end
