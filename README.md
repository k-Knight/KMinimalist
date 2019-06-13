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

Must be called at game runtime in order for kminimalist library to function properly.

### Function ``KMinimalistBootstrap.register(event, handler)``

This function does the registration of event handlers without overriding.

* **``event``** – the ***[number]*** id if the event that event handler will be registered to ([API reference](https://lua-api.factorio.com/latest/defines.html#defines.events))
* **``handler``** – handler ***[function]*** that takes event information table as an argument

### Example of event registration

```lua
KMinimalistBootstrap.register(defines.events.on_player_joined_game, function(event)
    game.print("Say hello to: " .. game.players[event.player_index].name)
end)
```

Prints ***"Say hello to: player_name"*** every time a player joins the game

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

### Example of work with safe API objects

```lua
object = {
    valid = true,
    a = 1,
    b = {
        valid = true,
        c = 2,
        d = {
            valid = false,
            e = 3
        }
    },
    f = "no",
    g = function() return "function g" end
}

safe = KMinimalistSafeApiObject.new(object)

game.print("Safe A:            " .. safe.a )
game.print("Safe B.[\"C\"]:      " .. safe.b["c"] )
game.print("Safe is_nil:       " .. tostring( safe.b.d.e.is_nil ))
game.print("Safe is_api_safe:  " .. tostring( safe.k.i.b.is_api_safe ))
game.print("Safe E:            " .. tostring(
    KMinimalistSafeApiObject.get_real_obj(safe.e )
))
game.print("Unsafe B.D.E:      " .. KMinimalistSafeApiObject.get_real_obj(safe.b.d).e )

safe.f = "yes";

game.print("Safe F:            " .. safe.f )
game.print("Safe G():          " .. safe.g() )
game.print("Safe H():          " .. tostring( safe.h() ))
```

Expected output:

    Safe A:            1
    Safe B.["C"]:      2
    Safe is_nil:       true
    Safe is_api_safe:  true
    Safe E:            nil
    Unsafe B.D.E:      3
    Safe F:            yes
    Safe G():          function g
    Safe H():          nil


## File ``kminimalist_styling.lua``

Provides functionality for applyig and managing styles during runtime of the game. It should be noted that the styles managed by the library **are separate and independant from** the game GUI element styles.

### Function ``KMinimalistStyling.define_style(name, style, override)``

This function defines and stores the style for future use. **Can be used only during runtime**. Can also be used to override existing styles.

* **``name``** – the ***[string]*** name of the style (*must be unique*)
* **``style``** – ***[table]*** that contains style definition, see [style definition](#style-definition)
* **``override``** – ***[boolean]*** optional argument that if set to ``true`` allows existing style to be overriden, else existing style does not get overriden

### Function ``KMinimalistStyling.apply_style(gui_element, style, override)``

This function applies style to a GUI element (*also works with safe API objects*).

* **``gui_element``** – the GUI element to which to apply style
* **``style``** – ***[string]*** name of the defined style or ***[table]*** containing style definition, see [style definition](#style-definition)
* **``override``** – ***[table]*** optional argument that if not ``nil`` then overrides the defined style's elements (*``style`` must be a name of a defined style*)

### Style definition

Style is defined as a ***[table]*** that contains style elements. Style elements can be regular Factorio API style elements, see [API reference](https://lua-api.factorio.com/latest/LuaStyle.html). For convenience also supports syntactic sugar elements that are listed below:

**Syntactic sugar** | **Type** | **Sets elements**
--- | --- | ---
**``width_f``** | ***[number]*** | ``minimal_width``<br/> ``maximal_width``<br/> ``width``
**``padding``** | ***[number]*** | ``top_padding``<br/> ``right_padding``<br/> ``bottom_padding``<br/> ``left_padding``
**``vertical_padding``** | ***[number]*** | ``top_padding``<br/> ``bottom_padding``
**``horizontal_padding``** | ***[number]*** | ``right_padding``<br/> ``left_padding``
**``vertical_cell_padding``** | ***[number]*** | ``top_cell_padding``<br/> ``bottom_cell_padding``
**``horizontal_cell_padding``** | ***[number]*** | ``right_cell_padding``<br/> ``left_cell_padding``
**``title_padding``** | ***[number]*** | ``title_top_padding``<br/> ``title_right_padding``<br/> ``title_bottom_padding``<br/> ``title_left_padding``
**``title_vertical_padding``** | ***[number]*** | ``title_top_padding``<br/> ``title_bottom_padding``
**``title_horizontal_padding``** | ***[number]*** | ``title_right_padding``<br/> ``title_left_padding``
**``margin``** | ***[number]*** | ``top_margin``<br/> ``right_margin``<br/> ``bottom_margin``<br/> ``left_margin``
**``vertical_margin``** | ***[number]*** | ``top_margin``<br/> ``bottom_margin``
**``horizontal_margin``** | ***[number]*** | ``right_margin``<br/> ``left_margin``
**``extra_margin_when_activated``** | ***[number]*** | ``extra_top_margin_when_activated``<br/> ``extra_right_margin_when_activated``<br/> ``extra_bottom_margin_when_activated``<br/> ``extra_left_margin_when_activated``
**``extra_vertical_margin_when_activated``** | ***[number]*** | ``extra_top_margin_when_activated``<br/> ``extra_bottom_margin_when_activated``
**``extra_horizontal_margin_when_activated``** | ***[number]*** | ``extra_right_margin_when_activated``<br/> ``extra_left_margin_when_activated``
**``spacing``** | ***[number]*** | ``horizontal_spacing``<br/> ``vertical_spacing``

### Example of working with styles

```lua
KMinimalistStyling.define_style( "example_style", { width_f = 400, top_padding = 50, bottom_margin = 30 }, false )

game.players[1].gui.top.add{type = "frame", caption = "Example frame", name = "frame_1"}
KMinimalistStyling.apply_style(
    game.players[1].gui.top.frame_1,
    "example_style"
)

game.players[1].gui.top.frame_1.add{type = "frame", caption = "inner frame 1", name = "frame_2"}
KMinimalistStyling.apply_style(
    game.players[1].gui.top.frame_1.frame_2,
    { width = 300, margin = 40}
)

game.players[1].gui.top.frame_1.add{type = "frame", caption = "inner frame 2", name = "frame_3"}
KMinimalistStyling.apply_style(
    game.players[1].gui.top.frame_1.frame_3,
    "example_style",
    { width_f = 200}
)
```

## File ``kminimalist_utility.lua``

This file contains general utility functions.

### Function ``KMinimalistUtility.deep_copy(obj)``

Makes a deep copy of the object.

* **``obj``** – ***[any]*** an object to make deep copy of