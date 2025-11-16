HuntingConfig = {
    rewards = {
		----------------------------------------------------------------
        -- Generic pelt prop1 (delete it, but give no items)
        [-1038420333] = {},   		
		--Generic pelt prop2 (delete it, but give noitems)
        [-1202329112] = {},
		--Generic pelt prop3 (delete it, but give noitems)
		[1780825678] = {},
		--Generic pelt prop4 (delete it, but give noitems)
        [85379810] = {},
		----------------------------------------------------------------
		-- MUTTON-TYPE ANIMALS (Sheep, Ram)
		----------------------------------------------------------------
		--Sierra Nevada Ram
		[-1568716381] = {
			{ item = "Mutton", count = 2 },
		},
		--Merino Sheep
		[40345436] = {
			{ item = "Mutton", count = 2 },
		},
		----------------------------------------------------------------
        -- VENISON-TYPE ANIMALS (DEER / BUCK / PRONGHORN / ELK)
        ----------------------------------------------------------------

        -- Whitetail Deer ($3.50 -> Tier B -> 3)
        [1110710183] = {
            { item = "venison", count = 2 },
        },

        -- Whitetail Buck ($3.15 -> Tier B -> 3)
        [-1963605336] = {
            { item = "venison", count = 2 },
        },

        -- American Pronghorn Doe ($3.75 -> Tier A -> 4)
        [1755643085] = {
            { item = "venison", count = 2 },
        },

        -- Elk ($3.90 -> Tier A -> 4)
        [-2021043433] = {
            { item = "venison", count = 2 },
        },

        ----------------------------------------------------------------
        -- BEEF / HOOFED LIVESTOCK (COW / BISON / BULL / OX)
        ----------------------------------------------------------------

        -- Bison variants ($3.00 -> Tier B -> 3)
        [1556473961] = {                    -- Bison (Animals)
            { item = "beef", count = 3 },
        },
        [367637652] = {                     -- Bison variant (Skinnable / alt)
            { item = "beef", count = 3 },
        },

        -- Bulls ($2.50 -> Tier B -> 3)
        [1957001316] = {                    -- Bull
            { item = "beef", count = 3 },
        },
        [195700131] = {                     -- Hereford Bull
            { item = "beef", count = 3 },
        },

		-- Florida Cracker Cow ($2.00 -> Tier C -> 2)
		[-50684386] = {
		{ item = "beef", count = 2 },
		},

        -- Angus Ox ($2.25 -> Tier B (borderline) -> 3)
        [556355544] = {
            { item = "beef", count = 3 },
        },

        ----------------------------------------------------------------
        -- PORK (PIGS / BOARS)
        ----------------------------------------------------------------

		-- Boar ($2.10 -> Tier C -> 2)
		[2028722809] = {
		{ item = "pork", count = 2 },
		},
			-- Old Spot Pig ($2.10 -> Tier C -> 2)
		[1007418994] = {
		{ item = "pork", count = 2 },
		},
		-- Berkshire Pig ($1.75 -> Tier C -> 2)
		[1007418994] = {
		{ item = "pork", count = 2 },
		},

		-- Peccary Pig ($2.00 -> Tier C -> 2)
		[1751700893] = {
		{ item = "pork", count = 2 },
		},

        ----------------------------------------------------------------
        -- BIG GAME (BEARS / CATS / LARGE PREDATORS / GIANT HERBIVORES)
        ----------------------------------------------------------------

        -- Bears ($3.50 -> Tier B -> 3)
        [-1124266369] = {                   -- Bear
            { item = "biggame", count = 2 },
        },
        [730092646] = {                     -- American Black Bear
            { item = "biggame", count = 2 },
        },

        -- Wolves
        -- Big Grey Wolf ($3.15 -> Tier B -> 3)
        [-1143398950] = {
            { item = "biggame", count = 1 },
        },
        -- Medium Grey Wolf ($4.15 -> Tier S -> 5)
        [-885451903] = {
            { item = "biggame", count = 1 },
        },
        -- Small Grey Wolf ($4.80 -> Tier S -> 5, but game instead of biggame)
        [-829273561] = {
            { item = "game", count = 1 },
        },

        -- Big cats
        -- Cougar ($4.25 -> Tier S -> 5)
        [90264823] = {
            { item = "biggame", count = 5 },
        },
        -- Panther ($4.00 -> Tier S -> 5)
        [1654513481] = {
            { item = "biggame", count = 5 },
        },

        -- Moose ($3.50 -> Tier B -> 3)
        [-1098441944] = {
            { item = "biggame", count = 2 },
        },

        -- Alligators
		-- Small Alligator (~2.75? but generally weaker) -> 2
		[-1892280447] = {
		{ item = "biggame", count = 2 },
		},

        -- Alligator (~3.0 -> Tier B -> 3)
        [-2004866590] = {
            { item = "biggame", count = 2 },
        },
        -- Northern Alligator (~3.0 -> Tier B -> 3)
        [-1295720802] = {
            { item = "biggame", count = 2 },
        },

        ----------------------------------------------------------------
        -- GENERAL GAME MEAT (FOX / COYOTE / GOAT / GILA / BEAVER / ETC)
        ----------------------------------------------------------------

        -- Fox ($2.25 -> Tier B -> 3)
        [252669332] = {                     -- American Red Fox
            { item = "game", count = 3 },
        },

        -- Coyote ($3.25 -> Tier A -> 4)
        [480688259] = {
            { item = "game", count = 2 },
        },

        -- Gila Monster ($2.75 -> Tier B -> 3)
        [45741642] = {
            { item = "game", count = 3 },
        },

        -- Alpine Goat ($2.50 -> Tier B -> 3)
        [-753902995] = {
            { item = "game", count = 3 },
        },

        -- North American Beaver ($2.75 -> Tier B -> 3)
        [759906147] = {
            { item = "game", count = 3 },
        },

		-- Snapping Turtle (~2.0–2.5 range -> 2)
		[-407730502] = {
		{ item = "game", count = 2 },
		},

        -- Water / Boa / Rattlesnakes / Fer-de-lance (~2.75–3.0 -> Tier B -> 3)
        [-22968827] = {                     -- Water Snake
            { item = "game", count = 3 },
        },
        [-1790499186] = {                   -- Red Boa
            { item = "game", count = 3 },
        },
        [1464167925] = {                    -- Fer-de-Lance
            { item = "game", count = 3 },
        },
        [846659001] = {                     -- Black-Tailed Rattlesnake
            { item = "game", count = 3 },
        },
        [545068538] = {                     -- Western Rattlesnake
            { item = "game", count = 3 },
        },

        -- Virginia Possum (~2.0 -> Tier C -> 2)
		[-1414989025] = {
		{ item = "game", count = 1 },
		{ item = "opossumc", count = 1},
		{ item = "opossums", count = 1},
		},

        ----------------------------------------------------------------
        -- GAMEY / HERPTILE / SMALL WEIRD CREATURES
        ----------------------------------------------------------------
		
		-- generic Black-Tailed Jackrabbit (~2.0 -> 2)
		[311947389] = {},
		-- Black-Tailed Jackrabbit (~2.0 -> 2)
		[-541762431] = {
		{ item = "gamey", count = 1 },
		{ item = "rabbits", count = 1 },
		{ item = "rabbitpaw", count = 2 },
		},
        -- Iguanas
        -- Green Iguana (~2.25 -> Tier B -> 3)
        [-1854059305] = {
            { item = "gamey", count = 3 },
        },
        -- Desert Iguana (~2.75 -> Tier B -> 3)
        [-593056309] = {
            { item = "gamey", count = 3 },
        },

        ----------------------------------------------------------------
        -- STRINGY MEAT (RACCOON / MUSKRAT / SKUNK)
        ----------------------------------------------------------------
		-- Striped Skunk ($2.25 -> Tier B -> 3)
        [-1211566332] = {
            { item = "stringy", count = 3 },
        },

        -- Striped Skunk ($2.25 -> Tier B -> 3)
        [-121266332] = {
            { item = "stringy", count = 3 },
        },

        -- North American Raccoon ($2.00 -> Tier C -> 2)
		[1458540991] = {
		{ item = "stringy", count = 2 },
		},

        -- American Muskrat ($2.25 -> Tier B -> 3)
        [-1134449699] = {
            { item = "stringy", count = 3 },
        },

        ----------------------------------------------------------------
        -- BIRD MEAT (ALL BIRDS THAT NORMALLY GIVE FEATHERS)
        ----------------------------------------------------------------

        -- Duck ($1.65 -> Tier C -> 2)
        [-1003616053] = {
            { item = "bird", count = 1 },
        },

        -- Eagles / Egrets (high-ish but still birds, keep 2)
        [1459778951] = {                    -- Eagle
            { item = "bird", count = 1 },
        },
        [831859211] = {                     -- Egret
            { item = "bird", count = 1 },
        },

        -- Vulture (~2.5–2.75 -> Tier B -> 3)
        [1104697660] = {
            { item = "bird", count = 1 },
        },

        -- Turkeys ($2.0 -> Tier C -> 2)
        [-466054788] = {                    -- Wild Turkey
            { item = "bird", count = 1 },
        },
        [-2011226991] = {                   -- Wild Turkey
            { item = "bird", count = 1 },
        },
        [-166054593] = {                    -- Wild Turkey
            { item = "bird", count = 1 },
        },

        -- Herring Seagull (~1.5 -> Tier C -> 2)
        [-164963696] = {
            { item = "bird", count = 1 },
        },

        -- Roseate Spoonbill (~2.5 -> Tier B -> 3)
        [-1076508705] = {
            { item = "bird", count = 1 },
        },

        -- Dominique Rooster (small/cheap -> 1–2, we keep 2 for fun)
        [2023522846] = {
            { item = "bird", count = 1 },
        },

        -- Red-Footed Booby (~2.0+ -> 2)
        [-466687768] = {
            { item = "bird", count = 1 },
        },

        -- Raven ($1.75 -> Tier C -> 2)
        [-575340245] = {
            { item = "bird", count = 1 },
        },

        -- Greater Prairie Chicken ($1.0 -> Tier D -> 1)
        [2079703102] = {
            { item = "bird", count = 1 },
        },

        -- Ring-Necked Pheasant ($1.25 -> border C/D -> 2)
        [1416324601] = {
            { item = "bird", count = 1 },
        },

        -- American White Pelican ($1.5 -> Tier C -> 2)
        [1265966684] = {
            { item = "bird", count = 1 },
        },

        -- Blue And Yellow Macaw (exotic bird, treat as 2)
        [-1797450568] = {
            { item = "bird", count = 1 },
        },

        -- Californian Condor (~2.75 -> Tier B -> 3)
        [120598262] = {
            { item = "bird", count = 1 },
        },

        -- Dominique Chicken (similar to rooster)
        [-2063183075] = {
            { item = "bird", count = 1 },
        },

        -- Double-Crested Cormorant (~2.0 -> Tier C -> 2)
        [-2073130256] = {
            { item = "bird", count = 1 },
        },

        -- Whooping Crane ($2.75 -> Tier B -> 3)
        [-564099192] = {
            { item = "bird", count = 1 },
        },

        -- Canada Goose ($2.75 -> Tier B -> 3)
        [723190474] = {
            { item = "bird", count = 1 },
        },

        -- Ferruginous Hawk (~2.5 -> Tier B -> 3)
        [-2145890973] = {
            { item = "bird", count = 1 },
        },

        -- Great Blue Heron (~2.5 -> Tier B -> 3)
        [1095117488] = {
            { item = "bird", count = 1 },
        },

        -- Common Loon (~2.0 -> Tier C -> 2)
        [386506078] = {
            { item = "bird", count = 1 },
        },

        -- Great Horned Owl (~2.0 -> Tier C -> 2)
        [-86244272] = {
            { item = "bird", count = 1 },
        },

        ----------------------------------------------------------------
        -- FISH (OPTIONAL – IF YOU EVER CARRY LARGE FISH AS ENTITIES)
        -- NOTE: These use your *existing* items, since Config.Animals
        --       doesn't give them butcher money the same way. We keep
        --       them mostly as-is.
        ----------------------------------------------------------------

        -- Longnose Gar
		[-711779521] = {
		{ item = "fishmeat", count = 2 },
		},

		-- Muskie
		[-1553593715] = {
		{ item = "fishmeat", count = 2 },
		},

		-- Lake Sturgeon
		[-300867788] = {
		{ item = "fishmeat", count = 2 },
		},

		-- Channel Catfish
		[1538187374] = {
		{ item = "fishmeat", count = 2 },
		},

		-- Northern Pike
		[697075200] = {
		{ item = "fishmeat", count = 2 },
		},

        -- Bluegill (kept as 1 “fish item”)
        [1867262572] = {
            { item = "a_c_fishbluegil_01_ms", count = 1 },
        },

		-- Bullhead Catfish
		[1493541632] = {
		{ item = "fishmeat", count = 2 },
		},

        -- Chain Pickerel
        [3111984125] = {
            { item = "a_c_fishchainpickerel_01_ms", count = 1 },
        },

        -- Largemouth/Bigmouth Bass
        [463643368] = {
            { item = "a_c_fishlargemouthbass_01_ms", count = 1 },
        },

        -- Perch
        [3842742512] = {
            { item = "a_c_fishperch_01_ms", count = 1 },
        },

        -- Rainbow Trout
        [134747314] = {
            { item = "a_c_fishrainbowtrout_01_ms", count = 1 },
        },

        -- Redfin Pickerel
        [4051778898] = {
            { item = "a_c_fishredfinpickerel_01_ms", count = 1 },
        },

        -- Rock Bass
        [2313405824] = {
            { item = "a_c_fishrockbass_01_ms", count = 1 },
        },

        -- Smallmouth Bass
        [2410477101] = {
            { item = "a_c_fishsmallmouthbass_01_ms", count = 1 },
        },

        -- Salmon Redfish
        [543892122] = {
            { item = "a_c_fishsalmonsockeye_01_ms", count = 1 },
        },

        -- Salmon Sockeye
        [1702636991] = {
            { item = "a_c_fishsalmonsockeye_01_ms", count = 1 },
        },
    },

    requireDead   = true,
    requireCarried = true,
}
