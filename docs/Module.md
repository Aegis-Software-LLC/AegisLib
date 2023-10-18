# Modules

An AegisLib module is created similarly to a normal Garry's Mod addon, except loading is performed by 
AegisLib instead of autorun. 

The file structure of a module looks something like this:

---
1. aegislib_module
    1. sh_module.lua
2. mymodule
    1. cl_init.lua
    2. sv_init.lua
---

The code in `sh_module.lua` is responsible for defining and initializing the module.

```lua
AegisLib.Module( "MyModule", "vlz1", "1.0", function( MyModule ) 
    MyModule:Info( "Loading MyModule..." )
    if ( SERVER ) then
        include("mymodule/sv_init.lua");
        AddCSLuaFile("mymodule/cl_init.lua");
        MyModule:Info( "Loaded MyModule:SV." );
    else
        include("mymodule/cl_init.lua");
        MyModule:Info( "Loaded MyModule:CL." );
    end
end )
```