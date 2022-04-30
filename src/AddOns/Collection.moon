----
-- A Collection class (extends @{Singleton})
-- @classmod Collection
-- @usage c = Collection.getInstance!

MeowUI = MeowUI
Singleton = assert require MeowUI.cwd .. "Core.Singleton"


class Collection extends Singleton
  new: =>
    return
