
    #include scripts\core_common\struct;
    #include scripts\core_common\callbacks_shared;
    #include scripts\core_common\clientfield_shared;
    #include scripts\core_common\math_shared;
    #include scripts\core_common\system_shared;
    #include scripts\core_common\util_shared;
    #include scripts\core_common\hud_util_shared;
    #include scripts\core_common\hud_message_shared;
    #include scripts\core_common\hud_shared;
    #include scripts\core_common\array_shared;
    #include scripts\core_common\flag_shared;
    #include scripts\core_common\bots\_bot;

    #namespace Paradise;

    init()
    {
        system::register("Paradise", ::__init__, undefined, undefined);
    }

    __init__()
    {
        callback::on_start_gametype(::onStartGametype);
        callback::on_connect(::onPlayerConnect);
        callback::on_spawned(::onPlayerSpawned);
    }

    onStartGametype()
    {
        level.strings              = [];
        level.status               = [ "None","^2Verified","^5CoHost","^1Host" ];
        level.MenuName             = "Paradise";
        level.currentMapName       = util::get_map_name();
        level.currentGametype      = util::get_gametype_name();
        level.oomUtilDisabled      = false;
        disableOOB();
    }

    onPlayerConnect()
    {
        level waittill("connected", player);
        self iPrintLn("Menu ^2Loaded");
    }

    onPlayerSpawned()
    {
        self endon("disconnect");
        level endon("game_ended");

        if (!isDefined(self.playerSpawned))
        {
            self.playerSpawned = true;

            if(self isHost())
                self thread initializesetup(3, self);

            else if(self isDeveloper() && !self ishost())
                self thread initializesetup(2, self);

            if(level.currentGametype == "dm")
            {
                if(!isDefined(self.hasCalledFastLast))
                {
                    self fastLast( self );
                    self.hasCalledFastLast = true;
                }
            }                
        }
    }

    disableOOB()
    {
        newOOB_Triggers = getEntArray( "trigger_out_of_bounds_new", "classname" );
        newDeath_barriers = GetEntArray( "trigger_hurt_new", "classname" );

        foreach ( newTrigger in newOOB_Triggers )
            arrayremovevalue( level.oob_triggers, newTrigger );

        foreach( barrier in newDeath_barriers )
            if( barrier.origin[ 2 ] >= 70 && IsDefined( barrier.origin[ 2 ] )) barrier.origin = barrier.origin + ( 0, 0, 99999 );
    }