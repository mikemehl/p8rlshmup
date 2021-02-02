-- button singleton, basic background scroller
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

-- background (just stars for now)
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