pico-8 cartridge // http://www.pico-8.com
version 29
__lua__

#include debug.lua
#include ecs.lua

buttons = {up = false, down = false, left = false, right = false, x = false, o = false}
function buttons:update()
    self.up = btn(2)
    self.down = btn(3)
    self.left = btn(0)
    self.right = btn(1)
    self.x = btn(5)
    self.o = btn(4)
end

-- did the user press anything??
function buttons:any()
    return self.up or self.down or self.left or self.right or self.x or self.o
end

-- did the user press a directional button???
function buttons:dir()
    return self.up or self.down or self.left or self.right
end

-- load systems into these tables
draw_systems = {}
update_systems = {}

bg = {}
bg.cols = {1, 5, 6, 7}
bg.stars={}
function bg:init()
    for z = 1,4 do
       for n=1,10 do
          add(self.stars, {
              x = flr(rnd(128)),
              y = flr(rnd(128)),
              z = z
          })
        end
    end
end

function bg:update()
    for star in all(self.stars) do
        star.y += star.z * 2
        if star.y > 128 then
            star.y = 0
            star.x = flr(rnd(128))
        end
    end
end

function bg:draw()
    for star in all(self.stars) do
        pset(star.x, star.y, self.cols[star.z])
    end
end

function _init()
    -- create the basic physics components
    local v = {p_x = 0, p_y = 0, v_x = 0, v_y = 0, a_x = 0, a_y = 0}
    ecs:create_component("physics", v)


    -- add a sprite component and a basic draw system
    ecs:create_component("sprite", {num = 0, flip_h = false, flip_v = false, w=1, h=1})
    add(draw_systems, ecs:system({"sprite", "physics"}, 
       function (eid)
          local p = ecs:get_component(eid, "physics") 
          local s = ecs:get_component(eid, "sprite")
          spr(s.num, p.p_x, p.p_y, s.w, s.h, s.flip_h, s.flip_v)
    end))

    -- add a component and system for updating player position
    ecs:create_component("is_player", {val = true})
    add(update_systems, ecs:system({"is_player", "physics"}, 
       function (eid) 
          local p = ecs:get_component(eid, "physics")
          p.a_x, p.a_y = 0, 0
          if buttons.up then p.a_y -= 0.5 end
          if buttons.down then p.a_y += 0.5 end
          if buttons.left then p.a_x -= 0.5 end
          if buttons.right then p.a_x += 0.5 end
          if not buttons:any() then 
            if p.v_x < 0 then
              p.v_x += 0.6
              if p.v_x > 0 then p.v_x = 0 end
            else
              p.v_x -= 0.6
              if p.v_x < 0 then p.v_x = 0 end
            end
            if p.v_y < 0 then
              p.v_y += 0.6
              if p.v_y > 0 then p.v_y = 0 end
            else
              p.v_y -= 0.6
              if p.v_y < 0 then p.v_y = 0 end
            end
          end
    end))

    add(update_systems, ecs:system({"physics"}, 
       function (eid) 
          local phy = ecs:get_component(eid, "physics")
          phy.v_x += phy.a_x
          phy.v_y += phy.a_y
          phy.p_x += phy.v_x
          phy.p_y += phy.v_y
    end))

    -- add a component for clamping position
    local c = {max_x = 128, min_x = 0, max_y = 128, min_y = 0}
    ecs:create_component("clamp_pos", c)
    add(update_systems, ecs:system({"physics", "clamp_pos"}, 
       function (eid)
          local p = ecs:get_component(eid, "physics")
          local c = ecs:get_component(eid, "clamp_pos")
          if p.p_x < c.min_x then p.p_x = c.min_x end
          if p.p_x > c.max_x then p.p_x = c.max_x end
          if p.p_y > c.max_y then p.p_y = c.max_y end
          if p.p_y < c.min_y then p.p_y = c.min_y end
    end))

    -- cool, now create the player I guess??
    local player_create = function()
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

    player_create()
    bg:init()
end

function _update()
    buttons:update()
    bg:update()
    for u in all(update_systems) do
        u()
    end
end

function _draw()
    cls(0)
    bg:draw()
    for d in all(draw_systems) do
        d()
    end
    dbg:print()
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000cc000000cc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
008aa800008aa8000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
08cccc8008cccc800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0c8008c00c8008c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
