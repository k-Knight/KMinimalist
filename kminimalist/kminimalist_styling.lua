KMinimalistStyling = {}
require("./kminimalist_styling_parsing.lua")

KMinimalistStyling.find_style = function(name)
  local style_index = nil
  for index, style in pairs(global.kminimalist.styles) do
    if style.name == name then
      return index, style
    end
  end
  return nil, nil
end

KMinimalistStyling.store_style = function(style)
  local index = KMinimalistStyling.find_style(style.name)
  if index ~= nil then
    global.kminimalist.styles[index] = style
  else
    global.kminimalist.styles[#global.kminimalist.styles + 1] = style
  end
end

KMinimalistStyling.define_style = function(name, style, override)
  local _, resulting_style = KMinimalistStyling.find_style(name)

  if resulting_style ~= nil and override ~= true then
    return false;
  end

  local parsed_style = KMinimalistStyling.parsing.parse_style(name, style)
  if parsed_style == nil then
    return false
  end

  if resulting_style ~= nil then
    if parsed_style ~= nil then
      resulting_style = resulting_style:override(parsed_style)
    else
      return false
    end
  else
    resulting_style = parsed_style
  end

  KMinimalistStyling.store_style(resulting_style)
  return true
end

KMinimalistStyling.apply_style = function(gui_element, style, override)
  if type(style) == "string" then
    local _, resulting_style = KMinimalistStyling.find_style(style)

    if resulting_style ~= nil then
      if type(override) == "table" then
        local parsed_style = KMinimalistStyling.parsing.parse_style(nil, override)
        if parsed_style ~= nil then
          resulting_style = resulting_style:override(parsed_style)
        end
      end
      resulting_style:apply(gui_element)
    else
      gui_element.style = style
      if type(override) == "table" then
        local parsed_style = KMinimalistStyling.parsing.parse_style(nil, override)
        if parsed_style ~= nil then
          parsed_style:apply(gui_element)
        end
      end
    end
  elseif type(style) == "table" then
    local parsed_style = KMinimalistStyling.parsing.parse_style(nil, style)
    if parsed_style ~= nil then
      parsed_style:apply(gui_element)
    end
  end
end