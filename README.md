# kminimalist

Minimalist library for working with API objects of the game Factorio.

## What kminimalist is for exactly

This Lua library is intented for working with Factorio API objects in a conveient way. More precisely, this it is designed to be used in **cotrol stage** of the game script (or mod) and later during **runtime**.

Kminimalist offers functionality for following situations:

* Registering event handlers in a way that previous event handler doesn't get overridden
* Working with Factorio API objects in a safe way that does not cause errors and does not require a lot if checks
* Working with **styles of GUI** elements in a convenient way **during runtime** without data stage
* Utility scripts, for instance, deep copying Lua objects

## kminimalist script files

### File ``kminimalist_bootstrap.lua``

Supports registration of event handlers without overriding old handlers. Also has initialization that **MUST** be called to for kminimalist library to work during runtime of the game.

#### function ``KMinimalistBootstrap.init()``

Should be called at game runtime in order for kminimalist library to function properly.

#### function ``KMinimalistBootstrap.register(event, handler)``

This functions does the registration of event handlers without overriding. Its arguments are:

* ``event`` – the id if the event that event handler will be registered to ([API reference](https://lua-api.factorio.com/0.17.48/defines.html#defines.events))
* ``handler`` – handler function that takes event information table as an argument

### File ``kminimalist_safe_api_object.lua``

### File ``kminimalist_styling.lua``

### File ``kminimalist_utility.lua``