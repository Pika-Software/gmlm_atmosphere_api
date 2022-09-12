module( "atmosphere", package.seeall )

if (CLIENT) then

    local isstring = isstring

    do
        local RunConsoleCommand = RunConsoleCommand

        function Run( name, ... )
            if isstring( name ) then
                RunConsoleCommand( "menu_api", name, ... )
            end
        end
    end

    do

        local net_ReadString = net.ReadString
        local net_ReadTable = net.ReadTable
        local net_Receive = net.Receive
        local istable = istable
        local unpack = unpack

        net_Receive("atmosphere", function()
            local name = net_ReadString()
            if isstring( name ) and (name ~= "") then
                local args = net_ReadTable()
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

end

if (SERVER) then

    util.AddNetworkString( "atmosphere" )

    local net_WriteString = net.WriteString
    local net_WriteTable = net.WriteTable
    local net_Broadcast = net.Broadcast
    local net_Start = net.Start
    local net_Send = net.Send

    function Send( ply, name, ... )
        net_Start( "atmosphere" )
            net_WriteString( name )
            net_WriteTable( {...} )
        net_Send( ply )
    end

    function Broadcast( name, ... )
        net_Start( "atmosphere" )
            net_WriteString( name )
            net_WriteTable( {...} )
        net_Broadcast()
    end

end
