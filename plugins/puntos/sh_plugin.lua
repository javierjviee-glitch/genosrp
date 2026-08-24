PLUGIN.name = "Puntos Casas"
PLUGIN.author = "Javi"
PLUGIN.description = "Sistema de puntos de Hogwarts."

ix.util.Include("sh_puntos.lua")

ix.config.Add("permitirModificarPuntos", true, "Permite sumar/restar puntos.", nil, {
    category = "Puntos"
})
