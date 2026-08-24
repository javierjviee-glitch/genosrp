
-- The shared init file. You'll want to fill out the info for your schema and include any other files that you need.

-- Schema info
Schema.name = "Hogwarts Roleplay"
Schema.author = "Javi"
Schema.description = "Esquema de rol ambientado en Hogwarts."

ix.config.language = "spanish"

-- Basic schema defaults. They remain editable from the Helix configuration menu.
ix.config.Add("maxCharacters", 3, "Número máximo de personajes por jugador.", nil, {category = "characters"})
ix.config.Add("maxAttributes", 100, "Valor máximo de cada atributo.", nil, {category = "characters"})
ix.config.Add("chatRange", 280, "Distancia máxima del chat IC.", nil, {category = "chat"})
ix.config.Add("oocDelay", 10, "Espera entre mensajes OOC.", nil, {category = "chat"})
ix.config.Add("allowGlobalOOC", true, "Permitir el chat OOC global.", nil, {category = "chat"})
ix.config.Add("spawnTime", 5, "Tiempo de espera para reaparecer.", nil, {category = "characters"})
ix.config.Add("inventoryWidth", 6, "Anchura del inventario inicial.", nil, {category = "characters"})
ix.config.Add("inventoryHeight", 4, "Altura del inventario inicial.", nil, {category = "characters"})
ix.config.Add("minNameLength", 4, "Longitud mínima del nombre.", nil, {category = "characters"})
ix.config.Add("maxNameLength", 32, "Longitud máxima del nombre.", nil, {category = "characters"})
ix.config.Add("defaultMoney", 100, "Dinero inicial de cada personaje.", nil, {category = "characters"})
ix.config.Add("allowVoice", true, "Permitir el chat de voz.", nil, {category = "server"})
ix.config.Add("voiceDistance", 600, "Distancia máxima del chat de voz.", nil, {category = "server"})
ix.config.Add("weaponAlwaysRaised", false, "Mantener siempre las armas levantadas.", nil, {category = "server"})
ix.config.Add("allowBusiness", true, "Permitir el menú de comercio.", nil, {category = "server"})
ix.config.Add("allowPush", true, "Permitir empujar con las manos.", nil, {category = "interaction"})

-- Additional files that aren't auto-included should be included here. Note that ix.util.Include will take care of properly
-- using AddCSLuaFile, given that your files have the proper naming scheme.

-- You could technically put most of your schema code into a couple of files, but that makes your code a lot harder to manage -
-- especially once your project grows in size. The standard convention is to have your miscellaneous functions that don't belong
-- in a library reside in your cl/sh/sv_schema.lua files. Your gamemode hooks should reside in cl/sh/sv_hooks.lua. Logical
-- groupings of functions should be put into their own libraries in the libs/ folder. Everything in the libs/ folder is loaded
-- automatically.
ix.util.Include("cl_schema.lua")
ix.util.Include("sv_schema.lua")

ix.util.Include("cl_hooks.lua")
ix.util.Include("sh_hooks.lua")
ix.util.Include("sv_hooks.lua")

-- You'll need to manually include files in the meta/ folder, however.
ix.util.Include("meta/sh_character.lua")
ix.util.Include("meta/sh_player.lua")
