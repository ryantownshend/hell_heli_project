/************************************************************************************************/
/* dr_strangepete (any questions - pete@shitnami.net)                     */
/* This work is licensed under a Creative Commons Attribution-ShareAlike 3.0 Unported License.  */
/* http://creativecommons.org/licenses/by-sa/3.0/                       */
/************************************************************************************************/
/*  7:38pm
conventions:  dsp_fnc_xxx   - functions
      dsp_var_xxx   - internal
      dsp_uservar_xxx - user loaded/set
      dsp_arp[_*]_*xxx  - prefix for profileNamespace
VARIABLES:
  {missionNamespace}
    dsp_uservar_randomEnabled   [bool]
    dsp_uservar_timeout         [[min,max]]
    dsp_uservar_tail            [int 0-100]
    dsp_uservar_respawnTime     [seconds]
    dsp_uservar_respawnAlt      [meters]
    dsp_uservar_heli            [str classname]
    dsp_uservar_weather         [int overcast,int fog,bool rain]
    dsp_var_failureActive       [bool]
    dsp_var_heliName            [str display name]
    dsp_var_heliClass           [str classname]
    dsp_var_currentHeli         [object]
    dsp_var_respawnLock         [bool]
    dsp_var_respawnPath         [[pos],[vectorDir],[vectorUp]]
    dsp_var_suicideAction       [user-action index id]



  {profileNamespace}
    dsp_arp_randomEnabled       [bool]
    dsp_arp_timeout             [[min,max]]
    dsp_arp_tail                [int 0-100]
    dsp_arp_heli                [str classname]
    dsp_arp_time                [[hour,minute]]
    dsp_arp_weather             [int overcast,int fog,bool rain]
    dsp_arp_lifetime            [secret]
    dsp_arp_respawnTime         [seconds]
    dsp_arp_respawnAlt          [meters]
    dsp_arp_respawnLock         [bool]
    dsp_arp_respawnPath         [[pos],[vectorDir],[vectorUp]];
*/

//////////////////////////////////////////////////////////////////////////////////////

LOG("loading dsp_functions.sqf");

dsp_var_suicideAction = 10000; /* initialize to a never-possible value */

dsp_fnc_addMenu = {
    _veh = _this select 0;
    LOG("Menu added to " + str(_veh))
    missionNamespace setVariable ["dsp_var_currentHeli",_veh];
    _veh addEventHandler ["GetOut","(_this select 0) setDamage 0; player setDamage 0;missionNamespace setVariable [""dsp_var_failureActive"",false];"];
    _veh addEventHandler ["GetIn","(_this select 0) setDamage 0; missionNamespace setVariable [""dsp_var_failureActive"",false];"];

    if(missionNamespace getVariable ["dsp_uservar_randomEnabled",""]) then {
      _null = _veh addAction ["<t color='#ee0000'>" + localize "str_dsp_DisableRandom" + "</t>",{missionNamespace setVariable ["dsp_uservar_randomEnabled",false];profileNamespace setVariable ["dsp_arp_randomEnabled",false];_this call dsp_fnc_toggleRandom;},"",8.2,false,true];
    } else {
      _null = _veh addAction ["<t color='#ee0000'>" + localize "str_dsp_EnableRandom" + "</t>",{missionNamespace setVariable ["dsp_uservar_randomEnabled",true];profileNamespace setVariable ["dsp_arp_randomEnabled",true];_nil = [(_this select 0)] spawn dsp_fnc_randomLoop;_this call dsp_fnc_toggleRandom;},"",8.2,false,true];
    };

    _null = _veh addAction ["<t color='#55ff55'>" + localize "str_dsp_Repair" + "</t>",{[missionNamespace getVariable ["dsp_var_currentHeli",""]] call dsp_fnc_repairHeli;},"",8.1,false];
    player removeAction dsp_var_suicideAction;
    dsp_var_suicideAction = player addAction ["<t color='#999955'>" + localize "str_dsp_EscapeBush" + "</t>",{[missionNamespace getVariable ["dsp_var_currentHeli",""]] call dsp_fnc_escapeBush;},"",8.09,false];
    _null = _veh addAction ["<t color='#ffa900'>" + localize "str_dsp_EngineFailure" + "</t>",{[_this select 0,true,false] call dsp_fnc_failPart;missionNamespace setVariable ["dsp_var_failureActive",true];},"",8.061,false];
    _null = _veh addAction ["<t color='#ffa900'>" + localize "str_dsp_TailRotorFailure" + "</t>",{[_this select 0,false,true] call dsp_fnc_failPart;missionNamespace setVariable ["dsp_var_failureActive",true];},"",8.06,false];
    _null = _veh addAction ["<t color='#dd5505'>" + localize "str_dsp_ChangeAircraft" + "</t>",{showCommandingMenu '#USER:dsp_0';},"",8.05,false];
    _null = _veh addAction ["<t color='#aa1010'>" + localize "str_dsp_ControlPanel" + "</t>",{createDialog "DSP_DIALOG";},"",8.04,false];
    //_nil = _veh addAction ["Get Mission",{_nil = [800] spawn dsp_fnc_triggerMission;},"",9.03,false];
};

//////////////////////////////////////////////////////////////////////////////////////


dsp_fnc_changeHeli = {
    _newHeliClass = _this select 0;
    _veh = missionNamespace getVariable ["dsp_var_currentHeli",""];
  LOG("Change Heli from " + str(_veh) + ", to: " + str(_newHeliClass))
    if(typeName (_this select 0) == "OBJECT") then {
      _newHeliClass = typeof _veh;
    };
    _vectorup = vectorUp _veh;
    _vectordir = vectorDir _veh;
    _vel = velocity _veh;
    //_pos = getPosATL _veh;
    _pos = _this select 1;
    _lastrandom = missionNamespace getVariable ["dsp_uservar_randomEnabled",false];
    missionNamespace setVariable ["dsp_var_failureActive",false];

    cutText ["","BLACK FADED",0];
    player allowDamage false;
    _tempos = [(getPos player) select 0,(getPos player) select 1,0];
    player setPos _tempos;

    deleteVehicle _veh;
    sleep 0.01;

    _veh = createVehicle [_newHeliClass,_pos,[],0,"FLY"];
    _veh allowDamage false;
    _veh setPos [_pos select 0,_pos select 1,_pos select 2];
    _veh setVectorDirAndUp [_vectordir,_vectorup];
    _veh setVelocity _vel;
    _veh addEventHandler ["fired","(_this select 0) setAmmo [(_this select 1),10000]; false"];
    player moveInDriver _veh;

    _veh allowDamage true;
    player allowDamage true;
    cutText ["","BLACK IN",0.5];

    missionNamespace setVariable ["dsp_uservar_heli",_newHeliClass];
    profileNamespace setVariable ["dsp_arp_heli",_newHeliClass];

    if(_lastRandom) then {_nil = [vehicle player] spawn dsp_fnc_randomLoop;};

    [_veh] call dsp_fnc_addMenu;
};

//////////////////////////////////////////////////////////////////////////////////////

dsp_fnc_escapeBush = {
  LOG("Escaped Bush")
    _veh = _this select 0;
    _pos = getPos _veh;
    _veh setVectorDir (vectorDir _veh);
    _veh setVectorUp [0,0,1];
    _veh setVelocity [0,0,0];
    _veh setPos [_pos select 0,_pos select 1,dsp_uservar_respawnAlt];
    //_veh setPos [_pos select 0, _pos select 1, 30];

    [_veh, getPos _veh] spawn dsp_fnc_changeHeli;
    [_veh] call dsp_fnc_repairHeli;
};

//////////////////////////////////////////////////////////////////////////////////////
//
//  arguments: [vehicle,bool engine,bool tail]
dsp_fnc_failPart = {
  LOG("failPart: " + str(_this))
    _return = [];
    _veh = dsp_var_currentHeli;
    _callEngine = _this select 1; /* menu call bool */
    _callTail = _this select 2;   /* menu call bool */
    // there was a reason for being wordy and using setHit vs. setHitPointDamage, but i really can't recall!
    // likely a bug workaround.

    _heloName = getText (configfile >> "CfgVehicles" >> typeOf _veh >> "displayname");
    // _engineNames = ["HitEngine", "HitEngine1", "HitEngine2", "HitEngine3", "HitEngine4"];
    _configTailName = getText (configfile >> "CfgVehicles" >> typeOf _veh >> "HitPoints" >> "HitVRotor" >> "name");
    _tailDamage = 0.95; //(60+(random 30)) * .01;
    _tailChance = missionNamespace getVariable ["dsp_uservar_tail",0];

    if(_callTail) then {
      _veh setHit [_configTailName,_tailDamage];_return = _return + [_configTailName];
    } else {

      // setHitIndex refactor
      // find the engine hitpoint indexes
      private _fields = getAllHitPointsDamage _veh select 0;
      private _engines = [];
      private _count = count _fields;
      for "_i" from 0 to _count step 1 do {
        _field = str(_fields select _i);
        if("engine" in str(_fields select _i)) then {
          _engines pushback _i;
        };
      };

      // destroy the engine hitpoints by index
      {
        _veh setHitIndex[_x, 1];
      } forEach _engines;

      // {
      //   _configName = getText (configfile >> "CfgVehicles" >> typeOf _veh >> "HitPoints" >> _x >> "name");
      //   _convexName = getText (configfile >> "CfgVehicles" >> typeOf _veh >> "HitPoints" >> _x >> "convexComponent");

      //     if(_configName isNotEqualTo _convexName) then {
      //     message = format [
      //       "NAME MISMATCH helo: '%1', engine: %2 name: '%3', convexComponent: '%4' ",
      //       _heloName, 
      //       _x,
      //       _configName, 
      //       _convexName
      //     ];
      //     LOG(message);
      //     _veh setHit [_convexName, 1];
      //     // _return = _return + [_convexName];
      //   };

      //   _veh setHit [_configName, 1];
      //   _return = _return + [_configName];
      // } forEach _engineNames;

      if(_tailChance > 0 && _tailChance >= (random 100) && !_callEngine) then {
        _veh setHit [_configTailName,_tailDamage];
        _return = _return + [_configTailName];
      };
    };
    _return
};

//////////////////////////////////////////////////////////////////////////////////////


dsp_fnc_findSpawn = { //map interoperability!
    _mapsize = worldSize;
    _testpos = [(random _mapsize),(random _mapsize),dsp_uservar_respawnAlt];
    while {surfaceIsWater [_testpos select 0,_testpos select 1]} do {_testpos = [random _mapsize,random _mapsize,dsp_uservar_respawnAlt];};
  LOG("findSpawn pos: " + str(_testpos)); /*debug*/
    _testpos
};

//////////////////////////////////////////////////////////////////////////////////////

dsp_fnc_Init = {
  LOG("Init")
    // Sorry for this mess, respawn and init code intermixed, has to be run in a certain order //
    _spawnpoint = [];
    _newpos = [];
    _camPos = [];
    private["_isRespawn"];_isRespawn = false;if(!(isNil ("_this"))) then {_isRespawn = _this select 0;};
  LOG("Init - isRespawn=" + str(_isRespawn))
        //waitUntil{player==player};
        //LOG("Init - waitedUntil player")
    if(!_isRespawn) then {
        player assignItem "NVGoggles";
        //player setIdentity "EPC_B_McKendrick";
    };
    if(_isRespawn) then {
  LOG("Init - _this=" + str(_this))
  LOG("Starting death cam")
        //_camPos = (_this select 1);
            _camPos = [((_this select 1) select 0)+4,((_this select 1) select 1)+4,4];
        dsp_cam = "camera" camCreate (_camPos);
        dsp_cam camPrepareTarget (_this select 2);
        dsp_cam camPreparePos _camPos;
        dsp_cam camCommitPrepared 0;
        dsp_cam cameraEffect ["EXTERNAL", "TOP"];
        //dsp_cam camPreparePos [((_this select 1) select 0)+10,((_this select 1) select 1)+20,10];

        _nil = [(parseNumber (str(dsp_uservar_respawnTime)))] spawn {sleep (_this select 0);titleText [(str(profileNamespace getVariable ["dsp_arp_lifetime",0])),"PLAIN DOWN",0.4];cutText ["","BLACK OUT",1];};

        sleep (1+ parseNumber(str(dsp_uservar_respawnTime)));
        deleteVehicle (_this select 2);

        player cameraEffect ["TERMINATE", "BACK"]; camDestroy dsp_cam;
    };
        [localize "str_dsp_ChangeAircraft", "dsp", [missionNamespace getVariable ["dsp_var_heliClass",""],missionNamespace getVariable ["dsp_var_heliName",""]], "","_nil = ['%1', (getPos dsp_var_currentHeli)] spawn dsp_fnc_changeHeli;"] call BIS_FNC_createmenu;
        cutText ["","BLACK FADED",1];
    if(!_isRespawn) then {
        player removeAllEventHandlers "killed";
        player addEventHandler ["killed","_nil = _this call dsp_fnc_respawn;"];

        _ctrlTime = profileNamespace getVariable ["dsp_arp_time",[18,0]];
        setDate [date select 0,date select 1,date select 2,(_ctrlTime select 0),(_ctrlTime select 1)];

        _weather = missionNamespace getVariable ["dsp_uservar_weather",[0,0,false]];

        private "_newovercast";
        _newovercast = overcast;
        if(_weather select 2) then { //rain
          skipTime -1;
          if(_weather select 0 < 75) then {
            3600 setOvercast 0.75;
            _newovercast = 75;
            0 setRain 0.75;
          } else {
            3600 setOvercast ((_weather select 0) * 0.01);
            _newovercast = (_weather select 0);
            0 setRain 0.75;
          };
          skipTime 1;
        } else { //no rain
          3600 setOvercast ((_weather select 0) * 0.01);
          _newovercast = (_weather select 0);
          3600 setRain 0;
        };
        simulWeatherSync;
        0 setFog ((_weather select 1)*0.005);
        missionNamespace setVariable ["dsp_uservar_weather",[(_newovercast),(_weather select 1),(if(_newovercast<75)then{false}else{true})]];
        profileNamespace setVariable ["dsp_arp_weather",[(_newovercast),(_weather select 1),(if(_newovercast<75)then{false}else{true})]];
        saveProfileNamespace;
        _spawnPoint = call dsp_fnc_findSpawn;
        //player setPosATL _spawnPoint;
    };
        if((daytime >= 4) && (daytime <= 20)) then {
          player action ["NVGogglesOff"];
          } else {
          player action ["NVGoggles"];
          };
      if(_isRespawn) then {player setPos [(_this select 1) select 0, (_this select 1) select 1, 0];};
        _lastheli = profileNamespace getVariable ["dsp_arp_heli", ""];
        if(_lastheli == "") then {
          _lastheli = dsp_var_heliClass select 0;
          missionNamespace setVariable ["dsp_uservar_heli",_lastheli];
          profileNamespace setVariable ["dsp_arp_heli", _lastheli];
        };
        if(!(_lastheli in dsp_var_heliClass)) then {
          _lastheli = dsp_var_heliClass select 0;
        };
        if(!_isRespawn) then {
          _newpos = _spawnPoint;
        } else {
          _newpos = [(getPos player) select 0, (getPos player) select 1, dsp_uservar_respawnAlt];
        };
        _veh = createVehicle [_lastheli,_newpos,[],0,"FLY"];
        _veh setPos _newpos;
        _dir = random 360;
        _speed = 10;
        _veh setDir _dir;
        if (dsp_uservar_respawnAlt > 2) then {
          _veh setVelocity [(sin _dir*_speed),(cos _dir*_speed),0];
        };
        player moveindriver _veh;
        player assignasdriver _veh;
        player hideObject false;
        player allowDamage true;
        _veh addEventHandler ["fired","(_this select 0) setAmmo [(_this select 1),10000]; false"];
        [_veh] call dsp_fnc_addMenu;

        _randomEnabled = localize "str_dsp_Disabled";
        if(missionNamespace getVariable ["dsp_uservar_randomEnabled",false]) then {
            missionNamespace setVariable ["dsp_uservar_randomEnabled",true];
            profileNamespace setVariable ["dsp_arp_randomEnabled",true];
            _nil = [_veh] spawn dsp_fnc_randomLoop;
            _randomEnabled = localize "str_dsp_Enabled";
        };
    if(!_isRespawn) then {
        _color = "ef2e2e";
        if(_randomEnabled==localize "str_dsp_Enabled") then {_color="15b603";} else {_color="ee0000";/*disabled*/};
        hint parseText format [localize "str_dsp_IntroText",_randomEnabled,_color,((actionName "heliCollectiveLower") + " " + (localize "str_dsp_key") + " " + (actionkeysNames ["heliCollectiveLower",1])),((actionName "heliCollectiveRaise") + " " + (localize "str_dsp_key") + " " + (actionkeysNames ["heliCollectiveRaise",1])),"FFCC00","CCFF33"];
    };
    if(_isRespawn) then {
  LOG ("Death cam finishing")
    };
    cutText ["","BLACK IN",1];
};

//////////////////////////////////////////////////////////////////////////////////////

dsp_fnc_repairHeli = {
  LOG("Repair")
    (_this select 0) setDamage 0;
    (_this select 0) setFuel 1;
    // player setDamage 0;
    call dsp_fnc_healplayer;
    missionNamespace setVariable ["dsp_var_failureActive",false];
};

dsp_fnc_healplayer = {

  // handle vanilla medical
  player setDamage 0;

  // handle ace medical
  if (isClass(configFile >> "CfgPatches" >> "ace_medical")) exitWith {
    [player] call ace_medical_treatment_fnc_fullHealLocal
  };
  nil
};

//////////////////////////////////////////////////////////////////////////////////////

dsp_fnc_Respawn = {
    //singleplayer respawn:
    //  [unit] addEventHandler ["killed","_nil = _this call dsp_fnc_respawn;"];
    //

    _oldUnit =  _this select 0;
    _oldProfile = profileName;
    _oldUnitVeh = vehicle _oldUnit;
    _newPos = getPos _oldUnit;
    _newPos = [(_newPos select 0)+5,(_newPos select 1)+5,(_newPos select 2)];
    _group = group _oldUnit;
    _newUnit = _group createUnit [typeOf _oldUnit,_newPos,[],0,"FORM"];
    _newUnit allowDamage false;
    _newUnit hideObject true;
    //_newUnit setIdentity "EPC_B_McKendrick";
    [_newUnit] joinSilent _group;
    _newUnit setDir getDir _oldUnit;
    _newUnit setRank "SERGEANT";

    selectPlayer _newUnit;
    deleteVehicle _oldUnit;
  //LOG(str(_oldUnit) + " respawned as " + str(_newUnit));

    _newUnit removeAllEventHandlers "killed";
    _newUnit addEventHandler ["killed","_nil = _this call dsp_fnc_respawn;"];
    _nil = [true,_newPos, _oldUnitVeh] spawn dsp_fnc_Init;


    _newUnit addRating 5000;
    profileNamespace setVariable ["dsp_arp_lifetime",((profilenamespace getvariable ["dsp_arp_lifetime",0])+1)];
};

//////////////////////////////////////////////////////////////////////////////////////
//
//  arguments: [vehicle]
//
dsp_fnc_randomLoop = {
    dsp_var_loopUnique = dsp_var_loopUnique + 1;
    if (dsp_var_loopCount < 2) then {
    dsp_var_loopCount = dsp_var_loopCount + 1; // hacky way to prevent runaway loop spawns :/
    _thisLoop = dsp_var_loopUnique;

  LOG("begin randomLoop #" + str(_thisLoop))
        while {(missionNamespace getVariable ["dsp_uservar_randomEnabled",false]) && !(isNull (_this select 0))} do {
          _veh = _this select 0;
          _timeout = missionNamespace getVariable ["dsp_uservar_timeout",[]];
          _tMin = _timeout select 0;
          _tMax = _timeout select 1;
          _fnc_timerChanged = { /*check for variable change*/ _t = missionNamespace getVariable ["dsp_uservar_timeout",[]];_tmin = _this select 0;_tmax = _this select 1;_return = false;if(_tmin != (_t select 0) || _tmax != (_t select 1)) then {_return = true;};_return};
          _cutTime = time + (_tMin + random (_tMax - _tMin));
  LOG("_cutTime initialization: " + str(time))

          waitUntil {([_tMin,_tMax] call _fnc_timerChanged) || !(missionNamespace getVariable ["dsp_uservar_randomEnabled",false]) || time >= _cutTime || isNull(_veh)};
          /*variable change triggers waitUntil, skips exec code, restarts waitUntil with new timings...*/
  LOG("randomLoop #" + str(_thisLoop))
  LOG("_timeout = " + str(_timeout))
  LOG("_cutTime = " + str(_cutTime) + ", time = " + str(time))

          if(!([_tMin,_tMax] call _fnc_timerChanged) && (missionNamespace getVariable ["dsp_uservar_randomEnabled",false]) && !isNull(_veh)) then {
            /*####EDIT####*/
  LOG("randomLoop #" + str(_thisLoop) + " was triggered for " + str(_veh))
            _failure = [_veh, _thisLoop] spawn dsp_fnc_triggerScenario;
            waitUntil {scriptDone _failure};
  LOG("randomLoop #" + str(_thisLoop) + " waitUntil scriptDone triggerScenario")
            /*############*/
          } else {
            //diag_log format ["false trigger by:   _fnc_timerChanged: %1    dsp_uservar_randomEnabled: %2",missionNamespace getVariable ["dsp_uservar_randomEnabled","error"]];
    //LOG("false trigger - ")
    //LOG(str(missionNamespace getVariable ["dsp_uservar_randomEnabled","error"]))
          };
        };
  LOG("randomLoop #" + str(_thisLoop) + " exited by condition")
    dsp_var_loopCount = dsp_var_loopCount - 1;
    } else { //loopCount
  LOG("randomLoop aborting due to loopCount")
    };
};


//////////////////////////////////////////////////////////////////////////////////////


dsp_fnc_toggleRandom = { //toggle random
    _target = _this select 0;
    _caller = _this select 1;
    _ID = _this select 2;
    _args = _this select 3;

    if((missionNamespace getVariable ["dsp_uservar_randomEnabled",false])) then {
      _target removeAction _ID;
      _null = _target addAction [("<t color='#ee0000'>" + (localize "str_dsp_DisableRandom") + "</t>"),{missionNamespace setVariable ["dsp_uservar_randomEnabled", false]; profileNamespace setVariable ["dsp_arp_randomEnabled",false];_this call dsp_fnc_toggleRandom;},"",8.2,false,true];
      hint "";hint parseText format [((localize "str_dsp_RandomFailure") + " <t color='%1'>" + (localize "str_dsp_Enabled") + "</t>"),"#15b603"];sleep 3.5;hint "";
    } else {
      _target removeAction _ID;
      _null = _target addAction [("<t color='#ee0000'>" + (localize "str_dsp_EnableRandom") + "</t>"),{missionNamespace setVariable ["dsp_uservar_randomEnabled",true]; profileNamespace setVariable ["dsp_arp_randomEnabled",true];_this call dsp_fnc_toggleRandom;_nil = [_this select 0] spawn dsp_fnc_randomLoop;},"",8.2,false,true];
      hint "";hint parseText format [((localize "str_dsp_RandomFailure") + " <t color='%1'>" + (localize "str_dsp_Disabled") + "</t>"),"#ee0000"];sleep 3.5;hint "";
    };
  LOG("toggleRandom - randomEnabled: " + str(dsp_uservar_randomEnabled))
};

//////////////////////////////////////////////////////////////////////////////////////

dsp_fnc_triggerScenario =   {
  LOG("triggerScenario #" + str(_this select 1) + " is waiting...")
    dsp_var_failureActive = true;
    _veh = _this select 0;
    [_veh,false,false] call dsp_fnc_failPart;
    waitUntil {!(missionNamespace getVariable ["dsp_var_failureActive",true]) || isNull(_veh)};
  LOG("triggerScenario #" + str(_this select 1) + " waitedUntil failureActive = false, time = " + str(time))
    sleep (dsp_uservar_respawnTime + 2);  //liftoff safety
  LOG("triggerScenario #" + str(_this select 1) + " slept and exited, " + str(time))
};

//////////////////////////////////////////////////////////////////////////////////////


/*UNDER DEVELOPMENT - just a proof of concept, feel free to enable it by uncommenting the addAction in function dsp_fnc_addMenu */

dsp_fnc_triggerMission = { // [radius]
  LOG("ALPHA FLAG! triggerMisson")
    _seats = (getNumber (configfile >> "CfgVehicles" >> typeOf (vehicle player) >> "transportSoldier"));
    _groupspawn = call dsp_fnc_findSpawn;
    if(_seats > 0) then { //transport
        _grp = [_groupspawn,blufor,(configfile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_ReconPatrol")] call BIS_fnc_spawnGroup;
        _blumark = createMarker ["BLUFOR",_groupspawn];
        _blumark setMarkerText "Friendly";
        _blumark setMarkerShape "Icon";
        _blumark setMarkerType "mil_pickup";
        _blumark setMarkerColor "ColorBlue";
        _nil = [_blumark,"Chemlight_blue","G_40mm_SmokeBlue"] spawn dsp_fnc_spawnflare;
        _enygrp = [[((_groupspawn select 0)-50)+(random 100),((_groupspawn select 1)-50)+(random 100),0],opfor,(configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfTeam")] call BIS_fnc_spawnGroup;
        _opmark = createMarker ["OPFOR",(getPos (leader _enygrp))];
        _opmark setMarkerText "EI";
        _opmark setMarkerShape "Icon";
        _opmark setMarkerType "mil_warning";
        _opmark setMarkerColor "ColorRed";
        _nil = [_opmark,"Chemlight_red","G_40mm_SmokeRed"] spawn dsp_fnc_spawnflare;
        [_grp,_groupspawn]call BIS_fnc_taskDefend;

        [player,"csar",["CSAR Mission","Extract Overrun Recon Patrol","Recon EVAC"],_groupspawn,true,10] call BIS_fnc_taskCreate;

        waitUntil {(player distance _groupspawn)<=100};

        if(alive (leader _grp)) then {
          { _x assignAsCargo (vehicle player);/*_x action ["GetIn",(vehicle player)];*/} forEach units _grp;
          //[units _grp] orderGetIn true;
          _wp = _grp addWaypoint [_groupspawn,30,1];
          _wp setWaypointType "GetIn";
          ["csar","succeeded",true] call BIS_fnc_taskSetState;

          waitUntil {(leader _grp in (vehicle player))};
          _newspawn = call dsp_fnc_findSpawn;
          [player,"dropoff",["Transport Recon Patrol to Rendezvous","Drop off Recon Patrol","LZ"],_newspawn,true,10] call BIS_fnc_taskCreate;
          waitUntil {(player distance _newspawn)<=100};
          ["csar","succeeded",true] call BIS_fnc_taskSetState;
        } else {
          ["csar","failed",true] call BIS_fnc_taskSetState;
        };
    } else { //attack

    };
};
//////////////////////////////////////////////////////////////////////////////////////

dsp_fnc_spawnflare = {
    //
    //this spawns a flare and smoke at the LZ, and keeps them lit for as long as the LZ exists
    //it also adds a WP option for the pilot to select a destination
    //
    _currentmarker = _this select 0;

    _flareammo = _this select 1; //Chemlight_red, F_20mm_White
    _smokeammo = _this select 2; //G_40mm_SmokeRed - twin reds seems to be the darkest at night
    _flare = _flareammo createVehicle (getMarkerPos _currentmarker);
    _smoke = _smokeammo createVehicle (getMarkerPos _currentmarker);
    while {markerText _currentmarker != ""} do {
        if(isNull _flare) then {_flare = _flareammo createVehicle (getMarkerPos _currentmarker);};
        if(isNull _smoke) then {_smoke = _smokeammo createVehicle (getMarkerPos _currentmarker);};
        sleep 1;
    };
    //now clean up once marker is deleted:

    if(!isNull _flare) then {deleteVehicle _flare;};
    if(!isNull _smoke) then {deleteVehicle _smoke;};
};

//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
