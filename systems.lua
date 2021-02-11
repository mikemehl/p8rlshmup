-- tables of systems, oh my....and maybe the functions to run them???
-- regular shmupping systems-------
shmup_draw_systems = 
{
    -- draw sprites system
    ecs:system({"sprite", "physics"}, 
       function (eid)
          local p = ecs:get_component(eid, "physics") 
          local s = ecs:get_component(eid, "sprite")
          spr(s.num, p.p_x, p.p_y, s.w, s.h, s.flip_h, s.flip_v)
    end),

    -- draw pixels system
    ecs:system({"anim_pixel", "physics"},
        function (eid)
          local p = ecs:get_component(eid, "physics")
          local a = ecs:get_component(eid, "anim_pixel")
          pset(p.p_x, p.p_y, a.colors[a.curr_col])
          a.frame_ct = a.frame_ct + 1
          if a.frame_ct == a.frame_change then
            a.curr_col = a.curr_col + 1
            if a.curr_col > #a.colors then
              a.curr_col = 1
            end
            a.frame_ct = 0
          end
    end)
}

shmup_update_systems =
{
 -- basic physics system
 ecs:system({"physics"}, 
    function (eid) 
       local phy = ecs:get_component(eid, "physics")
       phy.v_x += phy.a_x
       phy.v_y += phy.a_y
       phy.p_x += phy.v_x
       phy.p_y += phy.v_y
 end),

 -- basic player control system
 ecs:system({"is_player", "physics"}, 
    function (eid) 
       local p = ecs:get_component(eid, "physics")
       local plyr = ecs:get_component(eid, "is_player")
       if plyr.bullet_cooldown == 0 then
          if buttons.o then
             create_player_bullet_entity(eid)
             plyr.bullet_cooldown = 2
          end
       else
          plyr.bullet_cooldown = plyr.bullet_cooldown - 1
       end
       p.a_x, p.a_y = 0, 0
       if buttons.up then p.a_y -= 0.5 end
       if buttons.down then p.a_y += 0.5 end
       if buttons.left then p.a_x -= 0.5 end
       if buttons.right then p.a_x += 0.5 end
       p.v_x = mid(-9, p.v_x, 9)
       p.v_y = mid(-9, p.v_y, 9)
       if not buttons:dir() then 
         if p.v_x < 0 then
           p.v_x += 0.6
           if p.v_x > 0 then p.v_x = 0 end
         elseif p.v_x > 0 then
           p.v_x -= 0.6
           if p.v_x < 0 then p.v_x = 0 end
         end
         if p.v_y < 0 then
           p.v_y += 0.6
           if p.v_y > 0 then p.v_y = 0 end
         elseif p.v_y > 0 then
           p.v_y -= 0.6
           if p.v_y < 0 then p.v_y = 0 end
         end
       end
    end),

 -- clamping system
 ecs:system({"physics", "clamp_pos"}, 
       function (eid)
          local p = ecs:get_component(eid, "physics")
          local c = ecs:get_component(eid, "clamp_pos")
          if p.p_x < c.min_x then p.p_x = c.min_x end
          if p.p_x > c.max_x then p.p_x = c.max_x end
          if p.p_y > c.max_y then p.p_y = c.max_y end
          if p.p_y < c.min_y then p.p_y = c.min_y end
    end),

  -- remove offscreen entities system
  ecs:system({"die_offscreen", "physics"}, 
        function(eid)
         local p = ecs:get_component(eid, "physics") 
         local d = ecs:get_component(eid, "die_offscreen") 
         if d.vertical then
            if(p.p_y < 0 or p.p_y > 128) then
               ecs:delete_entity(eid)
            end
         elseif d.horizontal then
            if(p.p_x < 0 or p.p_x > 128) then
               ecs:delete_entity(eid)
            end
         end
  end)
}

function shmup_draw()
    cls(0)
    bg:draw()
    for d in all(shmup_draw_systems) do
        d()
    end
    dbg:print()
end

function shmup_update()
    buttons:update()
    bg:update()
    for u in all(shmup_update_systems) do
        u()
    end
end