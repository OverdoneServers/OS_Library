local MODULE = {}

MODULE.DisplayName = "OS: Casino"

MODULE.Version = "1.0.0"

OverdoneServers.OS_Casino = OverdoneServers.OS_Casino or {}
MODULE.PublicVar = OverdoneServers.OS_Casino
OverdoneServers.OS_Casino.Module = MODULE

MODULE.DataToLoad = {
    Client = {
        "card_builder.lua",
        },
    Shared = {
        "card_legend.lua",
    },
    Fonts = {
        {"CardFace", "croissant-one.ttf",
            {
                font = "Croissant One",
                size = 150,
                weight = 500,
                noScale = true
            }
        },
        {"CardFaceOnTable", "croissant-one.ttf",
            {
                font = "Croissant One",
                size = 170,
                weight = 500,

                noScale = true
            }
        },
    }
}

return MODULE