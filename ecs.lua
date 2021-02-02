ecs = {}
ecs.curr_eid = 4
ecs.entities = {}
ecs.components = {}
ecs.component_prototypes = {}

-- create a new type of component called "name" with default values in table "proto"
function ecs:create_component(name, proto)
  if self.components[name] then
    return false
  end
  self.components[name] = {}
  self.component_prototypes[name] = proto
  return true
end

-- add the component "name" to the entity with id "eid", with default values in table "vals"
function ecs:add_component(eid, name, vals)
  if self.components[name] then
    self.components[name][eid] = vals   
    return self.components[name][eid] 
  end
  return nil 
end

-- add the commponent "name" to the entity with id "eid" with default values from prototype table
function ecs:add_component(eid, name)
  if self.components[name] and self.component_prototypes[name] then
    self.components[name][eid] = {}
    for k,v in pairs(self.component_prototypes[name]) do
      self.components[name][eid][k] = v
    end
    return self.components[name][eid]
  end
  return nil
end

-- remove the component "name" from entity with id "eid"
function ecs:remove_component(eid, name)
  if self.components[name] then
    self.components[name][eid] = nil
    return true
  end
  return false
end

-- get a reference to the component "name" associated with entity with id "eid" (if it exists)
function ecs:get_component(eid, name)
  if self.components[name] then
    return self.components[name][eid] 
  end
  return nil 
end

-- check if an entity has a component
function ecs:has_component(eid, name)
  if self.components[name] then 
    return true
  end
  return false
end

-- create a new entity. returns the entity's id.
function ecs:new_entity()
   local ret_val = self.curr_eid
   self.curr_eid = self.curr_eid + 2
   add(self.entities, ret_val)
   return ret_val
end

-- delete an entity 
function ecs:delete_entity(eid)
  for _, c in pairs(self.components) do
    if c[eid] then c[eid] = nil end
  end
  del(self.entities, eid)
end

-- create a system function that applies function "f" to all entities with componenets specified in table "comp_list"
-- returns the created function
function ecs:system(comp_list, f, ...)
  local r = function(...)
    for _,v in pairs(self.entities) do
      for _,c in pairs(comp_list) do
        if not self.components[c][v] then
          goto _skip
        end
      end
      f(v, ...)
    ::_skip::
    end
  end
  return r
end