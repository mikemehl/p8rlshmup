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
    local h = ecs:add_component(p, "hitbox")
    h.x1, h.y1, h.x2, h.y2 = 11, 4, 12, 4
    return p
end

function create_player_bullet_entity(player_eid)
    local p = ecs:get_component(player_eid, "physics")
    local b = ecs:new_entity()
    local phys = ecs:add_component(b, "physics")
    phys.p_x, phys.p_y = p.p_x + 4, p.p_y
    phys.a_x, phys.a_y = 0, 0
    phys.v_x, phys.v_y = 0, -5
    local pix = ecs:add_component(b, "anim_pixel")
    pix.colors = {14, 12}
    pix.frame_change = 2
    local die = ecs:add_component(b, "die_offscreen")
    return b
end