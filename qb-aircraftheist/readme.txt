Dependencies
-Qb-core 
-qb-menu 
-qb-target
-memorygame_2 by Nathan#8860 - https://github.com/Nathan-FiveM/memorygame_2


Add this in qb-core/shared/items.lua

["labs_usb"]                      = {["name"] = "labs_usb", 				        ["label"] = "USB Research", 			["weight"] = 500, 		["type"] = "item", 		["image"] = "lab-usb.png", 		        ["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "A USB filled with loads of complicated numbers and letters... Big brain stuff!"},

Copy images from foler into qb-inventory/html/images folder

Add this in the qb-target/init.lua/Config.TargetModels

["aircraftbox"] = {
			models = {
				"hei_prop_carrier_cargo_05a"
			},
			options = {
				{
					type = "client",
					event = "qb-aircraftheist-collect",
					icon = "fas fa-box",
					label = "Search Box",
					item = "labs_usb",
				},
			},
			distance = 2.5,
		},
