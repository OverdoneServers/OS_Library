local MODULE = {}

MODULE.DisplayName = "OS: Casino"
MODULE.FolderName = "os_casino"
MODULE.Hidden = true

OverdoneServers.OS_Casino = OverdoneServers.OS_Casino or {}
MODULE.PublicVar = OverdoneServers.OS_Casino
OverdoneServers.OS_Casino.Module = MODULE

MODULE.FilesToLoad = {
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
                size = 20, //Max around 65
                weight = 500,
            }
        },
    }
}

OverdoneServers:AddModule(MODULE)