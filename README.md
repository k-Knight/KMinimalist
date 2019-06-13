# kminimalist

Minimalist library for working with API objects of the game Factorio.

## What kminimalist is for exactly

This Lua library is intented for working with Factorio API objects in a conveient way. More precisely, this it is designed to be used in **cotrol stage** of the game script (or mod) and later during **runtime**.

Kminimalist offers functionality for following situations:

* Registering event handlers in a way that previous event handler doesn't get overridden
* Working with Factorio API objects in a safe way that does not cause errors and does not require a lot if checks
* Working with **styles of GUI** elements in a convenient way **during runtime** without data stage
* Utility scripts, for instance, deep copying Lua objects

# kminimalist reference

## File ``kminimalist_bootstrap.lua``

Supports registration of event handlers without overriding old handlers. Also has initialization that **MUST** be called to for kminimalist library to work during runtime of the game.

### Function ``KMinimalistBootstrap.init()``

Should be called at game runtime in order for kminimalist library to function properly.

### Function ``KMinimalistBootstrap.register(event, handler)``

This function does the registration of event handlers without overriding.

* **``event``** – the ***[number]*** id if the event that event handler will be registered to ([API reference](https://lua-api.factorio.com/latest/defines.html#defines.events))
* **``handler``** – handler ***[function]*** that takes event information table as an argument

## File ``kminimalist_safe_api_object.lua``

Provides functionality to work safely with Facorio API obejcts. When you create a safe API object you can freely index it without being afraid of causing script errors. Two important notices:

* Safe API objects **must not be saved** in a global save as Factorio does not support saving metatables of Lua tables
* Using safe API objects **decreases performance** but saves numerous checks and conditional statements

### Safe API object functionality

* Allows **indexing** (operators: ``.`` and ``[]``). If the result of indexing is ``nil`` or the object is not ``valid`` then returns **empty, but safe** object that can be indexed further though the result always will be ``nil``.
* Allows **assignment**. Assignment takes place **only in safe conditions** (object is not ``nil`` and is ``valid``). Otherwise assignment is ignored.
* Allows making **calls of object's functions**. If the function is not defied then returns ``nil``.
* Has property ``is_api_safe`` set to ``true`` if the object is safe API object.
* Has property ``is_nil`` set to ``true`` if the real objects equals to ``nil``.

### Function ``KMinimalistSafeApiObject.new(api_obj)``

This fuction creates safe API object.

* **``api_obj``** – ***[string]*** anobject to be made safe

### Function ``KMinimalistSafeApiObject.get_real_obj(obj)``

Returns the real object. In case of object that is not safe API object then returns the object itself.

* **``obj``** – ***[any]*** an object from which to retrieve the real object

## File ``kminimalist_styling.lua``

Provides functionality for applyig and managing styles during runtime of the game. It should be noted that the styles managed by the library **are separate and independant from** the game GUI element styles.

### Function ``KMinimalistStyling.define_style(name, style, override)``

This function defines and stores the style for future use. **Can be used only during runtime**. Can also be used to override existing styles.

* **``name``** – the ***[string]*** name of the style (*must be unique*)
* **``style``** – ***[table]*** that contains style definition, see [style definition](#style-definition)
* **``override``** – ***[boolean]*** value that if set to ``true`` allows existing style to be overriden, else existing style does not get overriden

### Function ``KMinimalistStyling.apply_style(gui_element, style, override)``

This function applies style to a GUI element (*also works with safe API objects*).

* **``gui_element``** – the GUI element to which to apply style
* **``style``** – ***[string]*** name of the defined style or ***[table]*** containing style definition, see [style definition](#style-definition)
* **``override``** – ***[table]*** optional argument that if not ``nil`` then overrides the defined style's elements (*``style`` must be a name of a defined style*)

### Style definition

Style is defined as a ***[table]*** that contains style elements. Style elements can be regular Factorio API style elements, see [API reference](https://lua-api.factorio.com/latest/LuaStyle.html). For convenience also supports syntactic sugar elements that are listed below:

* **``width_f``** – sets ``minimal_width``, ``maximal_width`` and ``width`` to the same ***[number]*** value
* **``height_f``** – sets ``minimal_height``, ``maximal_height`` and ``height`` to the same ***[number]*** value
* **``padding``** – sets ``top_padding``, ``right_padding``, ``bottom_padding`` and ``left_padding`` to the same ***[number]*** value
* **``vertical_padding``** – sets ``top_padding`` and ``bottom_padding`` to the same ***[number]*** value
* **``horizontal_padding``** – sets ``right_padding`` and ``left_padding`` to the same ***[number]*** value
* **``vertical_cell_padding``** – sets ``top_cell_padding`` and ``bottom_cell_padding`` to the same ***[number]*** value
* **``horizontal_cell_padding``** – sets ``right_cell_padding`` and ``left_cell_padding`` to the same ***[number]*** value
* **``title_padding``** – sets ``title_top_padding``, ``title_right_padding``, ``title_bottom_padding`` and ``title_left_padding`` to the same ***[number]*** value
* **``title_vertical_padding``** – sets ``title_top_padding`` and ``title_bottom_padding`` to the same ***[number]*** value
* **``title_horizontal_padding``** – sets ``title_right_padding`` and ``title_left_padding`` to the same ***[number]*** value
* **``margin``** – sets ``top_margin``, ``right_margin``, ``bottom_margin`` and ``left_margin`` to the same ***[number]*** value
* **``vertical_margin``** – sets ``top_margin`` and ``bottom_margin`` to the same ***[number]*** value
* **``horizontal_margin``** – sets ``right_margin`` and ``left_margin`` to the same ***[number]*** value
* **``extra_margin_when_activated``** – sets ``extra_top_margin_when_activated``, ``extra_right_margin_when_activated``, ``extra_bottom_margin_when_activated`` and ``extra_left_margin_when_activated`` to the same ***[number]*** value
* **``extra_vertical_margin_when_activated``** – sets ``extra_top_margin_when_activated`` and ``extra_bottom_margin_when_activated`` to the same ***[number]*** value
* **``extra_horizontal_margin_when_activated``** – sets ``extra_right_margin_when_activated`` and ``extra_left_margin_when_activated`` to the same ***[number]*** value
* **``spacing``** – sets ``horizontal_spacing`` and ``vertical_spacing`` to the same ***[number]*** value

## File ``kminimalist_utility.lua``

This file contains general utility functions.

### Function ``KMinimalistUtility.deep_copy(obj)``

Makes a deep copy of the object.

* **``obj``** – ***[any]*** an object to make deep copy of