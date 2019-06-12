KMinimalistSafeApiObject = {}

KMinimalistSafeApiObject.get_unsafe_obj = function(safe_obj)
  local meta = getmetatable(safe_obj)
  if meta ~= nil then
    return meta.unsafe
  end
  return nil
end

KMinimalistSafeApiObject.get_real_obj = function(obj)
  if type(obj) == "table" then
    if obj.is_api_safe then
      return KMinimalistSafeApiObject.get_unsafe_obj(obj)
    else
      return obj
    end
  else
    return obj
  end
end

KMinimalistSafeApiObject.new = function(api_obj)
  safe_obj = {
    unsafe = api_obj
  }

  safe_obj.__index = function(table, key)
    local unsafe = KMinimalistSafeApiObject.get_unsafe_obj(table)
    if unsafe ~= nil then
      if unsafe.valid ~= false then
        local unsafe_field = nil
        pcall(function() unsafe_field = unsafe[key] end)

        if unsafe_field ~= nil and type(unsafe_field) ~= "table" then
          return unsafe_field
        else
          return KMinimalistSafeApiObject.new(unsafe_field)
        end
      end
    end
    return KMinimalistSafeApiObject.new(nil)
  end

  safe_obj.__newindex = function(table, key, value)
    local unsafe = KMinimalistSafeApiObject.get_unsafe_obj(table)
    if unsafe ~= nil then
      if unsafe.valid ~= false then
        unsafe[key] = value
      end
    end
  end

  safe_obj.__call = function(...)
    return nil
  end

  local is_nil = api_obj == nil
  return setmetatable({is_api_safe = true, is_nil = is_nil}, safe_obj)
end