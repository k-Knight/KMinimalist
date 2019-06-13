KMinimalistBootstrap = {}
KMinimalistBootstrap.init = function()
  if global.kminimalist == nil then
    global.kminimalist = {}
  end
  if global.kminimalist.styles == nil then
    global.kminimalist.styles = {}
  end
  if global.kminimalist.templates == nil then
    global.kminimalist.templates = {}
  end
end

KMinimalistBootstrap.register = function(event, handler)
  local old_handler = script.get_event_handler(event)

  if old_handler ~= nil then
    script.on_event(event, function(e)
      old_handler(e)
      handler(e)
    end)
  else
    script.on_event(event, handler)
  end
end