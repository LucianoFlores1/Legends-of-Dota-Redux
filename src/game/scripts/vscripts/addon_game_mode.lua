
require('lib/StatUploaderFunctions')

-- Precache obstacles
require('obstacles')

-- Misc functions
require('util')

-- Option storage
require('optionmanager')

-- Networking functions
require('network')

-- Chat commands
require('commands')

--Interaction with server
require('stats_client')

-- Custom Shop
require('lib/playertables')
require('lib/notifications')
-- require('panorama_shop')

-- Misc functions for Angel Arena Black Star abilities/items
require('lib/util_aabs')

-- IMBA
require('lib/util_imba')
require('lib/util_imba_funcs')
require('lib/animations')

require('pregame')
require('ingame')

-- Precaching
function Precache(context)
    -- COMMENT THE BELOW OUT IF YOU DO NOT WANT TO COMPILE ASSETS
    if IsInToolsMode() then
        local abilities = LoadKeyValues('scripts/npc/npc_abilities_custom.txt')
        for ability,content in pairs(abilities) do
            if type(content) == "table" then
                for block,val in pairs(content) do
                  if block == "precache" then
                    for precacheType, resource in pairs(val) do
                        PrecacheResource(precacheType, resource, context)
                    end
                  end
                end
            end
        end
    end
    -- COMMENT THE ABOVE OUT IF YOU DO NOT WANT TO COMPILE ASSETS
    PrecacheResource("particle","particles/econ/events/battlecup/battle_cup_fall_destroy_flash.vpcf",context)
    --PrecacheResource("particle","particles/world_tower/tower_upgrade/ti7_radiant_tower_proj.vpcf",context)
    --PrecacheResource("particle","particles/world_tower/tower_upgrade/ti7_dire_tower_projectile.vpcf",context)
    PrecacheResource("soundfile","soundevents/lod_game_sounds.vsndevts",context)
    PrecacheResource("soundfile","soundevents/memes_redux_sounds.vsndevts",context)
    --PrecacheUnitByNameSync("npc_dota_lucifers_claw_doomling", context)
    --PrecacheUnitByNameSync("npc_bot_spirit_sven", context)

    -- Precache all hero sounds here as some sounds end up not working
    local soundList = LoadKeyValues('scripts/kv/sounds.kv')
    for hero_name, _ in pairs(soundList["hero_sounds"]) do
        PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_" .. hero_name .. ".vsndevts", context)
    end

	-- Precache bots asynchronously to avoid blocking the server thread during initial loading
	local botList = {
		"npc_dota_hero_axe", "npc_dota_hero_bane", "npc_dota_hero_bloodseeker",
		"npc_dota_hero_bounty_hunter", "npc_dota_hero_bristleback", "npc_dota_hero_chaos_knight",
		"npc_dota_hero_crystal_maiden", "npc_dota_hero_dazzle", "npc_dota_hero_death_prophet",
		"npc_dota_hero_dragon_knight", "npc_dota_hero_drow_ranger", "npc_dota_hero_earthshaker",
		"npc_dota_hero_jakiro", "npc_dota_hero_juggernaut", "npc_dota_hero_kunkka",
		"npc_dota_hero_lich", "npc_dota_hero_lina", "npc_dota_hero_lion",
		"npc_dota_hero_luna", "npc_dota_hero_necrolyte", "npc_dota_hero_nevermore",
		"npc_dota_hero_omniknight", "npc_dota_hero_oracle", "npc_dota_hero_phantom_assassin",
		"npc_dota_hero_pudge", "npc_dota_hero_razor", "npc_dota_hero_sand_king",
		"npc_dota_hero_skeleton_king", "npc_dota_hero_skywrath_mage", "npc_dota_hero_sniper",
		"npc_dota_hero_sven", "npc_dota_hero_tidehunter", "npc_dota_hero_tiny",
		"npc_dota_hero_vengefulspirit", "npc_dota_hero_viper", "npc_dota_hero_warlock",
		"npc_dota_hero_windrunner", "npc_dota_hero_witch_doctor", "npc_dota_hero_zuus"
	}
	for _, botHero in ipairs(botList) do
		PrecacheUnitByNameAsync(botHero, function() end)
	end

	precacheObstacles(context)
end

-- Create the game mode when we activate
function Activate()
    -- Print LoD version header
    local versionNumber = "7.41.3"
    print('\n\nDota 2 Redux is activating! (v'..versionNumber..')')

   -- Load specific modules
    if not Pregame then
        require('pregame')
	end
    if not Ingame then
        require('ingame')
    end

    -- Init other stuff
    network:init()
    Pregame:init()
    Ingame:init()

    StatsClient:SubscribeToClientEvents()

    print('LoD seems to have activated successfully!!\n\n')

    -- PlayerResource:SetCustomTeamAssignment(0, DOTA_TEAM_BADGUYS)
    -- PlayerResource:SetCustomTeamAssignment(1, DOTA_TEAM_GOODGUYS)
    -- GameRules:LockCustomGameSetupTeamAssignment(true)
end

-- Boot directly into LoD interface
--Convars:SetInt('dota_wait_for_players_to_load', 0)
