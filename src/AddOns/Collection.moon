----
-- A Collection class (extends @{Singleton})
-- @classmod Collection
-- @usage c = Collection.getInstance!

MeowUI = MeowUI
Singleton = assert require MeowUI.cwd .. "Core.Singleton"
Control     = assert require MeowUI.cwd .. "Core.Control"


class Collection extends Singleton
  -- @local
  new: =>
    @collection = {}

  --- Creates a new collection with an optional root and children{childName: child}
  -- @tparam string collName
  -- @tparam Control root
  -- @tparam table children
  newCollection: (collName, root, children) =>
    assert (type(collName) == 'string'), "collName should be a string."
    assert (root == nil) or (root.__class.__parent == Control) or (root.__class == Control) or ((root\hasMinxins!) and root.__class.__parent.__parent == Control),
      "root must be nil or Control or a subclass of Control."
    assert (type(children) == 'table'), "children should be a Table/class/tabOfClasses."

    @collection[collName] = {
      root: root
      size: root and 1 or 0
    }

    for k, v in pairs children
      if k and v
        @collection[collName][k] = {}
        @collection[collName][k] = v
        @collection[collName].size += 1


  --- gets a collection.
  -- @tparam string collName
  getCollection: (collName) =>
    @collection[collName]

  --- adds child to a collection.
  -- @tparam Control(table) child
  -- @tparam string collName
  attachControlTo: (child, collName) =>
    if child and collName
      k, v = pairs(child)(child)
      @collection[collName][k] = v
      @collection[collName].size += 1
      return true
    false

  --- removes child to a collection.
  -- @tparam Control(table) child
  -- @tparam string collName
  removeControlFrom: (child, collName) =>
    if child and collName
      k, _ = pairs(child)(child)
      @collection[collName][k] = nil
      @collection[collName].size -= 1
      return true
    false

  --- remove a collection.
  -- @tparam string collName
  forget: (collName) =>
    if @collection[collName]
      @collection[collName] = nil
      return true
    false


Collection.getInstance!
