script.on_init(function()
    global.death_points = {}
end)

local function get_world_time()
    local time = (game.surfaces[1].daytime * 24 + 12) % 24

    local h = math.floor(time)
    local m = math.floor((time - h) * 60)

    return h, m
end

local function save_death_point(player, point)
    if not global.death_points[player.index] then
        global.death_points[player.index] = {}
    end

    global.death_points[player.index][game.tick] = point
end

local function remove_death_point(player, death_tick)
    global.death_points[player.index][death_tick].destroy()
    global.death_points[player.index][death_tick] = nil
end

script.on_event({defines.events.on_player_died}, function (e)
    local player = game.get_player(e.player_index)

    local h, m = get_world_time()

    local text = string.gsub(settings.global["deathpoints-pattern"].value, "%$(%w+)", {
        player = player.name,
        time = string.format("%02d:%02d", h, m)
    })

    local point = player.force.add_chart_tag(player.surface, {
        position = player.position,
        text = text
    })

    save_death_point(player, point)
end)

local function on_character_corpse_removed(corpse, expired)
    local death_tick = corpse.character_corpse_tick_of_death

    local player = game.players[corpse.character_corpse_player_index]

    local settings = settings.get_player_settings(player)

    local remove_expired = settings["deathpoints-destroy_expired"].value
    local notify_on_expiration = settings["deathpoints-notify_on_expiration"].value

    if expired and notify_on_expiration then
        player.print{"messages.expired", corpse.position.x, corpse.position.y}
    end

    if remove_expired then
        remove_death_point(player, death_tick)
    end
end

script.on_event({defines.events.on_character_corpse_expired}, function (e)
    on_character_corpse_removed(e.corpse, true)
end)

script.on_event({defines.events.on_pre_player_mined_item}, function (e)
    if e.entity.type == "character-corpse" then
        on_character_corpse_removed(e.entity)
    end
end)

script.on_event({defines.events.on_chart_tag_removed}, function (e)
    local id = e.tag.tag_number

    for player, points in pairs(global.death_points) do
        for tick, point in pairs(points) do
            if point.tag_number == id then
                global.death_points[player][tick] = nil
            end
        end
    end
end)