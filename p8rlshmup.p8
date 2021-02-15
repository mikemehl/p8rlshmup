pico-8 cartridge // http://www.pico-8.com
version 29
__lua__

#include debug.lua
#include ecs.lua
#include utils.lua
#include components.lua
#include entities.lua
#include systems.lua


function _init()
    init_components()
    create_player_entity()
    bg:init()
end

function _update()
    shmup_update()
end

function _draw()
    shmup_draw()
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
__sfx__
00010000000003b5503855035550335502f5502d5502955026550235501f5501d5501b550185501655013550115500a5500c5500a550085500755005550035500155000550000000000000000000000000000000
