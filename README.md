# gmod_atmosphere_api

## Example
```lua
    require( "atmosphere" )

    if (CLIENT) then
        atmosphere.Run( "clientAction", LocalPlayer():Nick() )
    end

    if (SERVER) then
        atmosphere.Run( "clientAction", "prikolmen" )
    end
```