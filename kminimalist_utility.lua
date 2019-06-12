KMinimalistUtility = {}
KMinimalistUtility.deep_copy = function(obj)
  if type(obj) ~= 'table' then
    return obj
  end
  local res = {}
  for key, value in pairs(obj) do
    res[KMinimalistUtility.deep_copy(key)] = KMinimalistUtility.deep_copy(value)
  end
  return res
end