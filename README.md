# Atmosphere Client API ( Lua Module )

## Example
```lua
    require( 'atmosphere' )

    if (CLIENT) then
        atmosphere.Menu( 'action', LocalPlayer():Nick() )
    end

    if (SERVER) then
        atmosphere.Broadcast( 'action', 'prikolmen' )
    end
```
