local MeowUI = MeowUI
local Singleton = assert(require(MeowUI.cwd .. "Core.Singleton"))
local Control = assert(require(MeowUI.cwd .. "Core.Control"))
local Collection
do
  local _class_0
  local _parent_0 = Singleton
  local _base_0 = {
    newCollection = function(self, collName, root, children)
      assert((type(collName) == 'string'), "collName should be a string.")
      assert((root == nil) or (root.__class.__parent == Control) or (root.__class == Control) or ((root:hasMinxins()) and root.__class.__parent.__parent == Control), "root must be nil or Control or a subclass of Control.")
      assert((type(children) == 'table'), "children should be a Table/class/tabOfClasses.")
      self.collection[collName] = {
        root = root,
        size = root and 1 or 0
      }
      for k, v in pairs(children) do
        if k and v then
          rawset(self.collection[collName], k, v)
          self.collection[collName].size = self.collection[collName].size + 1
        end
      end
    end,
    getCollection = function(self, collName)
      return self.collection[collName]
    end,
    attachControlTo = function(self, child, collName)
      if child and collName then
        local k, v = pairs(child)(child)
        rawset(self.collection[collName], k, v)
        self.collection[collName].size = self.collection[collName].size + 1
        return true
      end
      return false
    end,
    removeControlFrom = function(self, child, collName)
      if child and collName then
        local k, _ = pairs(child)(child)
        rawset(self.collection[collName], k, nil)
        self.collection[collName].size = self.collection[collName].size - 1
        return true
      end
      return false
    end,
    forget = function(self, collName)
      if self.collection[collName] then
        self.collection[collName] = nil
        return true
      end
      return false
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self)
      self.collection = { }
    end,
    __base = _base_0,
    __name = "Collection",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Collection = _class_0
end
return Collection.getInstance()
