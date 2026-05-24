-- إنشاء الواجهة (GUI)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BreadGui"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- إنشاء إطار الصورة (Background Image)
local ImageLabel = Instance.new("ImageLabel")
ImageLabel.Size = UDim2.new(0, 300, 0, 200) -- حجم الواجهة
ImageLabel.Position = UDim2.new(0.5, -150, 0.5, -100) -- في المنتصف
ImageLabel.Image = "rbxassetid://رقم_الصورة_هنا" -- ضع رقم الصورة بعد رفعها على روبلوكس
ImageLabel.Parent = ScreenGui

-- إضافة زر (مثال لربط زر الإعدادات)
local ToggleButton = Instance.new("TextButton")
ToggleButton.Text = "Toggle Settings"
ToggleButton.Parent = ImageLabel
