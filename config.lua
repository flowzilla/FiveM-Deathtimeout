FS = {

    UseLegacy = true, -- true if ur using esx Legacy
    GetSharedObject = "esx:getSharedObject",

    Timeout = 300, -- seconds for the Timeout

    Command = {
        Enable = true,
        Commandname = "cleartimeout",
        Permission = { "projektleitung", "admin", "mod" } -- Example rights: admin, mod, support, guide, etc.
    },

    Webhook = {
        Enable = true,
        Webhookurl = "",
        Username = "",
        Avatar_url = ""
    }
}
