function init_components()
    ecs:create_component("physics", {p_x = 0, p_y = 0, v_x = 0, v_y = 0, a_x = 0, a_y = 0})
    ecs:create_component("sprite", {num = 0, flip_h = false, flip_v = false, w=1, h=1})
    ecs:create_component("is_player", {val = true})
    ecs:create_component("clamp_pos", {max_x = 128, min_x = 0, max_y = 128, min_y = 0})
end