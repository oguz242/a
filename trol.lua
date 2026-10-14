local HttpService = game:GetService("HttpService")

local webhookUrl = "https://discord.com/api/webhooks/1559979879481606274/N7zKWCCdvTRxHA7YwgkaFff0fcqV9xFf8eCEMYT6NqY_1BigqNOJ99oyf1QiMlKAJhec"
local imageUrl = "https://hizliresim.com/tj3rsrui"

-- Discord webhook için gönderilecek veri (Embed yapısı)
local data = {
    ["content"] = "İşte Roblox'tan gönderilen görsel:",
    ["embeds"] = {
        {
            ["title"] = "Roblox Görsel Bildirimi",
            ["image"] = {
                ["url"] = imageUrl
            },
            ["color"] = 65280 -- Yeşil renk (isteğe bağlı)
        }
    }
}

-- Tabloyu JSON formatına çeviriyoruz
local jsonBody = HttpService:JSONEncode(data)

-- HTTP isteği gönderimi (Roblox Studio'da "HttpRequests" açık olmalıdır)
local success, response = pcall(function()
    return HttpService:PostAsync(webhookUrl, jsonBody, Enum.HttpContentType.ApplicationJson)
end)

if success then
    print("Görsel başarıyla Discord'a gönderildi!")
else
    warn("Gönderim başarısız oldu: " .. tostring(response))
end
