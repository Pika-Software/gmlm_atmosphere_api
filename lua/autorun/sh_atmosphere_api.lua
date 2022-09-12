module( "atmosphere", package.seeall )

if (CLIENT) then

    function Run( name, ... )
        if isstring( name ) then
            RunConsoleCommand( "menu_api", name, ... )
        end
    end

    net.Receive("atmosphere", function()
        local name = net.ReadString()
        if isstring( name ) and (name ~= "") then
            local args = net.ReadTable()
            if istable( args ) then
                if (#args > 0) then
                    Run( name, unpack( args ) )
                else
                    Run( name )
                end
            end
        end
    end)

end

if (SERVER) then

    util.AddNetworkString( "atmosphere" )

    function Send( ply, name, ... )
        net.Start( "atmosphere" )
            net.WriteString( name )
            net.WriteTable( {...} )
        net.Send( ply )
    end

    function Broadcast( name, ... )
        net.Start( "atmosphere" )
            net.WriteString( name )
            net.WriteTable( {...} )
        net.Broadcast()
    end

end
