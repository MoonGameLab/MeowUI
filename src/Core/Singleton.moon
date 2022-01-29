----
-- A Singleton class
-- @classmod Singleton


class Singleton
  --- Whenever a class inherits from Singleton, it sends a message to the Singleton class by calling this method.
  __inherited: (By) =>
    By.getInstance = (...) ->
      if I = By.Instance then return I
      with I = By ...
        By.Instance = I
