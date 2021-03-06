local Event = require 'utils.event'
local Functions = require 'maps.mountain_fortress_v3.ic.functions'
local IC = require 'maps.mountain_fortress_v3.ic.table'
local Public = {}

Public.reset = IC.reset
Public.get_table = IC.get

local function on_entity_died(event)
    local entity = event.entity
    if not entity and not entity.valid then
        return
    end

    if not entity.type == 'car' then
        return
    end

    local ic = IC.get()
    Functions.kill_car(ic, entity)
end

local function on_player_mined_entity(event)
    local entity = event.entity
    if not entity and not entity.valid then
        return
    end

    if not entity.type == 'car' then
        return
    end

    local ic = IC.get()
    Functions.save_car(ic, event)
end

local function on_robot_mined_entity(event)
    local entity = event.entity

    if not entity and not entity.valid then
        return
    end

    if not entity.type == 'car' then
        return
    end

    local ic = IC.get()
    Functions.kill_car(ic, entity)
end

local function on_built_entity(event)
    local created_entity = event.created_entity
    if not created_entity.type == 'car' then
        return
    end

    local ic = IC.get()
    Functions.create_car(ic, event)
end

local function on_player_driving_changed_state(event)
    local ic = IC.get()
    local player = game.players[event.player_index]

    Functions.use_door_with_entity(ic, player, event.entity)
end

local function on_tick()
    local ic = IC.get()
    local tick = game.tick

    if tick % 60 == 0 then
        Functions.teleport_players_around(ic)
        Functions.item_transfer(ic)
    end

    if not ic.rebuild_tick then
        return
    end

    if ic.rebuild_tick ~= tick then
        return
    end

    Functions.reconstruct_all_cars(ic)
    ic.rebuild_tick = nil
end

local function on_init()
    Public.reset()
end

Event.on_init(on_init)
Event.add(defines.events.on_tick, on_tick)
Event.add(defines.events.on_player_driving_changed_state, on_player_driving_changed_state)
Event.add(defines.events.on_entity_died, on_entity_died)
Event.add(defines.events.on_built_entity, on_built_entity)
Event.add(defines.events.on_player_mined_entity, on_player_mined_entity)
Event.add(defines.events.on_robot_mined_entity, on_robot_mined_entity)

return Public
