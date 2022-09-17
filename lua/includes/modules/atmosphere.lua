module( "atmosphere", package.seeall )

if (CLIENT) then

    -- Menu -> Client API
    do

        local apiCommands = {}
        function SetFunc( name, func )
            assert( isstring( name ), "Argument #1 must be string!" )
            assert( isfunction( func ), "Argument #2 must be function!" )
            apiCommands[ name ] = func
        end

        do
            local isfunction = isfunction
            function RunFunc( name, ... )
                assert( isstring( name ), "Argument #1 must be string!" )
                local func = apiCommands[ name ]
                if isfunction( func ) then
                    func( ... )
                end
            end
        end

        concommand.Add("atmosphere_api", function( ply, cmd, args )
            RunFunc( unpack( args ) )
        end, nil, "Menu -> Client API", FCVAR_DONTRECORD )

    end

    -- Client -> Menu API
    do

        local isstring = isstring

        -- Client -> Menu API
        do
            local RunConsoleCommand = RunConsoleCommand

            function Menu( name, ... )
                if isstring( name ) then
                    RunConsoleCommand( "menu_api", name, ... )
                end
            end
        end

        -- Server -> Client -> Menu API
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
                            Menu( name, unpack( args ) )
                        else
                            Menu( name )
                        end
                    end
                end
            end)

        end

    end

    hook.Add("InitPostEntity", "atmosphere.clientAPI.ready", function()
        RunFunc( "clientAPI.ready" )
    end)

end

-- Server -> Client API
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
