function create_player_entity()
    local p = ecs:new_entity()
    ecs:add_component(p, "is_player")
    local phys = ecs:add_component(p, "physics")
    phys.p_x, phys.p_y = 64, 64
    ecs:add_component(p, "sprite")
    local c = ecs:add_component(p, "clamp_pos")
    c.max_x = 128 - 8
    c.min_x = 8
    c.max_y = 128 - 8
    c.min_y = -3
end