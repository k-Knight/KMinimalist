require("./kminimalist_styling_definitions.lua")
require("./kminimalist_utility.lua")

KMinimalistStyling.parsing = {}
KMinimalistStyling.parsing.parse_complex_element = function(elem_key, elem_value)
  local key_vaild = false
  local elem_type = nil
  for _, elem_def in pairs(KMinimalistStyling.definitions.complex_elements) do
    if elem_def.field_name == elem_key then
      key_vaild = true
      elem_type = elem_def.type_name
      break
    end
  end

  if key_vaild then
    local element = {}

    if elem_type == "color" then
      element[elem_key] = {}
      element[elem_key].r = elem_value.r
      element[elem_key].g = elem_value.g
      element[elem_key].b = elem_value.b
      element[elem_key].a = elem_value.a
    else
      return nil
    end

    return element
  end

  return nil
end

KMinimalistStyling.parsing.is_sugar_element = function(elem_key)
  for _, elem_def in pairs(KMinimalistStyling.definitions.sugar_elements) do
    if elem_def.field_name == elem_key then
      return true, elem_def.type_name
    end
  end

  for _, elem_def in pairs(KMinimalistStyling.definitions.simple_elements) do
    if elem_def.field_name == elem_key then
      return false, elem_def.type_name
    end
  end

  return false, nil
end

KMinimalistStyling.parsing.parse_sugar_element = function(elem_key, elem_value)
  local element = {}

  if elem_key == "width_f" then

    element["minimal_width"] = elem_value
    element["maximal_width"] = elem_value
    element["width"] = elem_value

  elseif elem_key == "height_f" then

    element["minimal_height"] = elem_value
    element["maximal_height"] = elem_value
    element["height"] = elem_value

  elseif elem_key == "padding" then

    element["top_padding"] = elem_value
    element["right_padding"] = elem_value
    element["bottom_padding"] = elem_value
    element["left_padding"] = elem_value

  elseif elem_key == "vertical_padding" then

    element["top_padding"] = elem_value
    element["bottom_padding"] = elem_value

  elseif elem_key == "horizontal_padding" then

    element["right_padding"] = elem_value
    element["left_padding"] = elem_value

  elseif elem_key == "vertical_cell_padding" then

    element["top_cell_padding"] = elem_value
    element["bottom_cell_padding"] = elem_value

  elseif elem_key == "horizontal_cell_padding" then

    element["right_cell_padding"] = elem_value
    element["left_cell_padding"] = elem_value

  elseif elem_key == "title_padding" then

    element["title_top_padding"] = elem_value
    element["title_right_padding"] = elem_value
    element["title_bottom_padding"] = elem_value
    element["title_left_padding"] = elem_value

  elseif elem_key == "title_vertical_padding" then

    element["title_top_padding"] = elem_value
    element["title_bottom_padding"] = elem_value

  elseif elem_key == "title_horizontal_padding" then

    element["title_right_padding"] = elem_value
    element["title_left_padding"] = elem_value

  elseif elem_key == "margin" then

    element["top_margin"] = elem_value
    element["right_margin"] = elem_value
    element["bottom_margin"] = elem_value
    element["left_margin"] = elem_value

  elseif elem_key == "vertical_margin" then

    element["top_margin"] = elem_value
    element["bottom_margin"] = elem_value

  elseif elem_key == "horizontal_margin" then

    element["right_margin"] = elem_value
    element["left_margin"] = elem_value

  elseif elem_key == "extra_margin_when_activated" then

    element["extra_top_margin_when_activated"] = elem_value
    element["extra_right_margin_when_activated"] = elem_value
    element["extra_bottom_margin_when_activated"] = elem_value
    element["extra_left_margin_when_activated"] = elem_value

  elseif elem_key == "extra_vertical_margin_when_activated" then

    element["extra_top_margin_when_activated"] = elem_value
    element["extra_bottom_margin_when_activated"] = elem_value

  elseif elem_key == "extra_horizontal_margin_when_activated" then

    element["extra_right_margin_when_activated"] = elem_value
    element["extra_left_margin_when_activated"] = elem_value

  elseif elem_key == "spacing" then

    element["horizontal_spacing"] = elem_value
    element["vertical_spacing"] = elem_value

  else
    return nil
  end

  return element
end

KMinimalistStyling.parsing.parse_style_element = function(elem_key, elem_value)
  if type(elem_value) == "table" then
    return KMinimalistStyling.parsing.parse_complex_element(elem_key, elem_value)
  else
    local is_sugar_element, elem_type = KMinimalistStyling.parsing.is_sugar_element(elem_key)
    if is_sugar_element then
      return KMinimalistStyling.parsing.parse_sugar_element(elem_key, elem_value)
    else
      if elem_type ~= nil then
        local element = {}
        element[elem_key] = elem_value

        return element
      end
    end
  end

  return nil
end

KMinimalistStyling.parsing.parse_style = function(name, style)
  local parsed_style = {name = name, elements = {}}

  for key, value in pairs(style) do
    local parsed_element = KMinimalistStyling.parsing.parse_style_element(key, value)
    if parsed_element ~= nil then
      for key, value in pairs(parsed_element) do
        parsed_style.elements[key] = value
      end
    end
  end

  function parsed_style:apply(gui_element)
    for key, value in pairs(self.elements) do
      gui_element.style[key] = value
    end
  end

  function parsed_style:override(style)
    local new_style = KMinimalistUtility.deep_copy(self)

    for key, value in pairs(style.elements) do
      new_style.elements[key] = KMinimalistUtility.deep_copy(value)
    end

    return new_style
  end

  return parsed_style
end