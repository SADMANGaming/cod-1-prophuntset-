// HideNSeek
// AUTHOR: Indy
//////////////
randomColor(a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, b0, b1, b2, b3,
                       b4, b5, b6, b7, b8, b9) {
  r = randomInt(255) * 0.003921568627451;
  g = randomInt(255) * 0.003921568627451;
  b = randomInt(255) * 0.003921568627451;
  return (string)r + " " + (string)g + " " + (string)b;
}
main(a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, b0, b1, b2, b2,
                       b4, b5, b6, b7, b8, b9) {
  spawnpointname = "mp_searchanddestroy_spawn_allied";
  spawnpoints = getentarray(spawnpointname, "classname");
  if (!spawnpoints.size) {
    maps\mp\gametypes\_callbacksetup::AbortLevel();
    return;
  }
  for (i = 0; i < spawnpoints.size; i++)
    spawnpoints[i] placeSpawnpoint();
  spawnpointname = "mp_searchanddestroy_spawn_axis";
  spawnpoints = getentarray(spawnpointname, "classname");
  if (!spawnpoints.size) {
    maps\mp\gametypes\_callbacksetup::AbortLevel();
    return;
  }
  for (i = 0; i < spawnpoints.size; i++)
    spawnpoints[i] PlaceSpawnpoint();
  level.callbackStartGameType = ::Callback_StartGameType;
  level.callbackPlayerConnect = ::Callback_PlayerConnect;
  level.callbackPlayerDisconnect = ::Callback_PlayerDisconnect;
  level.callbackPlayerDamage = ::Callback_PlayerDamage;
  level.callbackPlayerKilled = ::Callback_PlayerKilled;
  maps\mp\gametypes\_callbacksetup::SetupCallbacks();
  custom\coco::init();
  level._effect["bombexplosion"] = loadfx("fx/explosions/mp_bomb.efx");
  allowed[0] = "dm"; // "sd";
  // allowed[1] = "bombzone";
  // allowed[2] = "blocker";
  maps\mp\gametypes\_gameobjects::main(allowed);
  if (getCvar("scr_hns_timelimit") == "") // Time limit per map
    setCvar("scr_hns_timelimit", "0");
  else if (getCvarFloat("scr_hns_timelimit") > 1440)
    setCvar("scr_hns_timelimit", "1440");
  level.timelimit = getCvarFloat("scr_hns_timelimit");
  setCvar("ui_hns_timelimit", level.timelimit);
  makeCvarServerInfo("ui_hns_timelimit", "0");
  if (!isDefined(game["timepassed"]))
    game["timepassed"] = 0;
  if (getCvar("scr_hns_scorelimit") == "") // Score limit per map
    setCvar("scr_hns_scorelimit", "10");
  level.scorelimit = getCvarInt("scr_hns_scorelimit");
  setCvar("ui_hns_scorelimit", level.scorelimit);
  makeCvarServerInfo("ui_hns_scorelimit", "100");
  if (getCvar("scr_hns_roundlimit") == "") // Round limit per map
    setCvar("scr_hns_roundlimit", "0");
  level.roundlimit = getCvarInt("scr_hns_roundlimit");
  setCvar("ui_hns_roundlimit", level.roundlimit);
  makeCvarServerInfo("ui_hns_roundlimit", "0");
  if (getCvar("scr_hns_roundlength") == "") // Time length of each round
    setCvar("scr_hns_roundlength", "6");
  else if (getCvarFloat("scr_hns_roundlength") > 10)
    setCvar("scr_hns_roundlength", "10");
  level.roundlength = getCvarFloat("scr_hns_roundlength");
  if (getCvar("scr_hns_graceperiod") == "") // Time at round start where
                                            // spawning and weapon choosing is
                                            // still allowed
    setCvar("scr_hns_graceperiod", "15");
  else if (getCvarFloat("scr_hns_graceperiod") > 60)
    setCvar("scr_hns_graceperiod", "60");
  level.graceperiod = getCvarFloat("scr_hns_graceperiod");
  killcam = getCvar("scr_killcam");
  if (killcam == "") // Kill cam
    killcam = "1";
  setCvar("scr_killcam", killcam, true);
  level.killcam = getCvarInt("scr_killcam");
  if (getCvar("scr_teambalance") == "") // Auto Team Balancing
    setCvar("scr_teambalance", "0");
  level.teambalance = getCvarInt("scr_teambalance");
  level.lockteams = false;
  if (getCvar("scr_freelook") == "") // Free look spectator
    setCvar("scr_freelook", "1");
  level.allowfreelook = getCvarInt("scr_freelook");
  if (getCvar("scr_spectateenemy") == "") // Spectate Enemy Team
    setCvar("scr_spectateenemy", "1");
  level.allowenemyspectate = getCvarInt("scr_spectateenemy");
  if (getCvar("scr_drawfriend") == "") // Draws a team icon over teammates
    setCvar("scr_drawfriend", "0");
  level.drawfriend = getCvarInt("scr_drawfriend");
  if (!isDefined(game["state"]))
    game["state"] = "playing";
  if (!isDefined(game["roundsplayed"]))
    game["roundsplayed"] = 0;
  if (!isDefined(game["matchstarted"]))
    game["matchstarted"] = false;
  if (!isDefined(game["alliedscore"]))
    game["alliedscore"] = 0;
  setTeamScore("allies", game["alliedscore"]);
  if (!isDefined(game["axisscore"]))
    game["axisscore"] = 0;
  setTeamScore("axis", game["axisscore"]);
  level.bombplanted = false;
  level.bombexploded = false;
  level.roundstarted = false;
  level.roundended = false;
  level.mapended = false;
  if (!isdefined(game["BalanceTeamsNextRound"]))
    game["BalanceTeamsNextRound"] = false;
  level.exist["allies"] = 0;
  level.exist["axis"] = 0;
  level.exist["teams"] = false;
  level.didexist["allies"] = false;
  level.didexist["axis"] = false;
  if (level.killcam >= 1)
    setarchive(true);
  thread maps\mp\gametypes\_moxhns::main_hns();
  thread maps\mp\gametypes\_moxhns::modLogo();
}
Callback_StartGameType(a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, b0, b1, b2, b3,
                       b4, b5, b6, b7, b8, b9) {
  maps\mp\gametypes\_powerup::Callback_StartGameType();
  // if this is a fresh map start, set nationalities based on cvars, otherwise
  // leave game variable nationalities as set in the level script
  if (!isDefined(game["gamestarted"])) {
    // defaults if not defined in level script
    if (!isDefined(game["allies"]))
      game["allies"] = "american";
    if (!isDefined(game["axis"]))
      game["axis"] = "german";
    if (!isDefined(game["layoutimage"]))
      game["layoutimage"] = "default";
    layoutname = "levelshots/layouts/hud@layout_" + game["layoutimage"];
    precacheShader(layoutname);
    setCvar("scr_layoutimage", layoutname);
    makeCvarServerInfo("scr_layoutimage", "");
    // server cvar overrides
    if (getCvar("scr_allies") != "")
      game["allies"] = getCvar("scr_allies");
    if (getCvar("scr_axis") != "")
      game["axis"] = getCvar("scr_axis");
    game["menu_serverinfo"] = "";
    game["menu_team"] = "team_" + game["allies"] + game["axis"];
    game["menu_weapon_allies"] = "weapon_" + game["allies"];
    game["menu_weapon_axis"] = "weapon_" + game["axis"];
    game["menu_viewmap"] = "viewmap";
    game["menu_callvote"] = "callvote";
    game["menu_quickcommands"] = "quickcommands";
    game["menu_quickstatements"] = "quickstatements";
    game["menu_quickresponses"] = "quickresponses";
    game["headicon_allies"] = "gfx/hud/headicon@allies.tga";
    game["headicon_axis"] = "gfx/hud/headicon@axis.tga";
    precacheString(&"MPSCRIPT_PRESS_ACTIVATE_TO_SKIP");
    precacheString(&"MPSCRIPT_ALLIES_WIN");
    precacheString(&"MPSCRIPT_AXIS_WIN");
    precacheString(&"MPSCRIPT_THE_GAME_IS_A_TIE");
    precacheString(&"MPSCRIPT_STARTING_NEW_ROUND");
    precacheString(&"MPSCRIPT_ROUNDCAM");
    precacheString(&"MPSCRIPT_KILLCAM");
    precacheString(&"SD_MATCHSTARTING");
    precacheString(&"SD_MATCHRESUMING");
    precacheString(&"SD_EXPLOSIVESPLANTED");
    precacheString(&"SD_EXPLOSIVESDEFUSED");
    precacheString(&"SD_ROUNDDRAW");
    precacheString(&"SD_TIMEHASEXPIRED");
    precacheString(&"SD_ALLIEDMISSIONACCOMPLISHED");
    precacheString(&"SD_AXISMISSIONACCOMPLISHED");
    precacheString(&"SD_ALLIESHAVEBEENELIMINATED");
    precacheString(&"SD_AXISHAVEBEENELIMINATED");
    game["objective_default"] = "gfx/hud/objective.dds";
    precacheMenu(game["menu_team"]);
    precacheMenu(game["menu_weapon_allies"]);
    precacheMenu(game["menu_weapon_axis"]);
    precacheMenu(game["menu_viewmap"]);
    precacheMenu(game["menu_callvote"]);
    precacheMenu(game["menu_quickcommands"]);
    precacheMenu(game["menu_quickstatements"]);
    precacheMenu(game["menu_quickresponses"]);
    precacheShader("black");
    precacheShader("white");
    precacheShader("hudScoreboard_mp");
    precacheShader("gfx/hud/hud@mpflag_spectator.tga");
    precacheStatusIcon("gfx/hud/hud@status_dead.tga");
    precacheStatusIcon("gfx/hud/hud@status_connecting.tga");
    precacheHeadIcon(game["headicon_allies"]);
    precacheHeadIcon(game["headicon_axis"]);
    precacheShader("ui_mp/assets/hud@plantbomb.tga");
    precacheShader("ui_mp/assets/hud@defusebomb.tga");
    precacheShader("gfx/hud/hud@objectiveA.tga");
    precacheShader("gfx/hud/hud@objectiveA_up.tga");
    precacheShader("gfx/hud/hud@objectiveA_down.tga");
    precacheShader("gfx/hud/hud@objectiveB.tga");
    precacheShader("gfx/hud/hud@objectiveB_up.tga");
    precacheShader("gfx/hud/hud@objectiveB_down.tga");
    precacheShader("gfx/hud/hud@bombplanted.tga");
    precacheShader("gfx/hud/hud@bombplanted_up.tga");
    precacheShader("gfx/hud/hud@bombplanted_down.tga");
    precacheShader("gfx/hud/hud@bombplanted_down.tga");
    precacheModel("xmodel/vehicle_plane_stuka");
    precacheItem("panzerfaust_mp");
    precacheString(&"New Killstreak!\nChopper Gunner!");
    precacheString(&"");
    // MapVote //
  /*  precacheshader("white");
    level.mapvotetext["MapVote"] = &"Press ^2FIRE^7 to vote        Votes";
    level.mapvotetext["Votes"] = &"Votes";
    level.mapvotetext["TimeLeft"] = &"Time Left: ";
    level.mapvotetext["MapVoteHeader"] = &"Next Map Vote";
    game["objective_default"] = "gfx/hud/objective.dds";
    level.awe_mapvotetime = 20;
    PrecacheString(level.mapvotetext["MapVote"]);
    PrecacheString(level.mapvotetext["Votes"]);
    PrecacheString(level.mapvotetext["TimeLeft"]);
    PrecacheString(level.mapvotetext["MapVoteHeader"]);
    precacheShader(game["objective_default"]);
    //maps\mp\gametypes\_teams::precache();
    //maps\mp\gametypes\_teams::scoreboard();
    //maps\mp\gametypes\_teams::initGlobalCvars();
    // thread addBotClients();
	*/
  }
  setCvar("g_TeamColor_Axis", "0.00392157 0.827451 0.784314");
  setCvar("g_TeamColor_Allies", "0.96863 0.00784 0.16471");
  maps\mp\gametypes\_teams::modeltype();
  maps\mp\gametypes\_teams::restrictPlacedWeapons();
  thread maps\mp\gametypes\_privatemsg::init();
  /*
  test = spawn ("script_model", (-7128, -7290, 46));
  test setmodel ("xmodel/barrel_black1");
  test setContents(1);
  test solid();
  solidsphere = spawn( "script_model", (-7128, -7290, 46),0,200,200);
  solidsphere setcontents(1);
  */
  game["gamestarted"] = true;
  setClientNameMode("auto_change");
  // thread bombzones();
  thread startGame();
  thread updateGametypeCvars();
  maps\mp\gametypes\_hns::mainmx(); //***HNS ADDED***
}
Callback_PlayerConnect(a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, b0, b1, b2, b3,
                       b4, b5, b6, b7, b8, b9) {
  self.statusicon = "gfx/hud/hud@status_connecting.tga";
  self waittill("begin");
  self.statusicon = "";
  self setClientCvar("cg_thirdperson", "1");
  self setClientCvar("cg_fov", "80");
  // self setclientcvar("cg_drawgun", 1);
  self.pers["teamTime"] = 0;
  self.seeker = false;
  if (!isDefined(self.pers["team"]))
    iprintln(&"MPSCRIPT_CONNECTED", self);
  maps\mp\gametypes\_powerup::Callback_PlayerConnect();
  custom\coco::onConnect();
  lpselfnum = self getEntityNumber();
  logPrint("J;" + lpselfnum + ";" + self.name + "\n");
  if (game["state"] == "intermission") {
    spawnIntermission();
    return;
  }
  level endon("intermission");
  if (isDefined(self.pers["team"]) && self.pers["team"] != "spectator") {
    self setClientCvar("ui_weapontab", "1");
    if (self.pers["team"] == "allies")
      self setClientCvar("g_scriptMainMenu", game["menu_weapon_allies"]);
    else
      self setClientCvar("g_scriptMainMenu", game["menu_weapon_axis"]);
    if (isDefined(self.pers["weapon"]))
      spawnPlayer();
    else {
      self.sessionteam = "spectator";
      spawnSpectator();
      if (self.pers["team"] == "allies")
        self openMenu(game["menu_weapon_allies"]);
      else
        self openMenu(game["menu_weapon_axis"]);
    }
  } else {
    self setClientCvar("g_scriptMainMenu", game["menu_team"]);
    self setClientCvar("ui_weapontab", "0");
    if (!isdefined(self.pers["team"]))
      self openMenu(game["menu_team"]);
    self.pers["team"] = "spectator";
    self.sessionteam = "spectator";
    spawnSpectator();
  }
  for (;;) {
    self waittill("menuresponse", menu, response);
    if (response == "open" || response == "close")
      continue;
    if (menu == game["menu_team"]) {
      switch (response) {
      case "allies":
      case "axis":
      case "autoassign":
        if (level.lockteams)
          break;
        if (response == self.pers["team"] && self.sessionstate == "playing")
          break;
        if (response != self.pers["team"] && self.sessionstate == "playing")
          break;
        response = "axis";
        self.pers["team"] = response;
        self.pers["teamTime"] =
            game["timepassed"] + ((getTime() - level.starttime) / 1000) / 60.0;
        self.pers["weapon"] = undefined;
        self.pers["weapon1"] = undefined;
        self.pers["weapon2"] = undefined;
        self.pers["spawnweapon"] = undefined;
        self.pers["savedmodel"] = undefined;
        self.grenadecount = undefined;
        self setClientCvar("ui_weapontab", "1");
        if (self.pers["team"] == "allies") {
          self setClientCvar("g_scriptMainMenu", game["menu_weapon_allies"]);
          self openMenu(game["menu_weapon_allies"]);
        } else {
          self setClientCvar("g_scriptMainMenu", game["menu_weapon_axis"]);
          self openMenu(game["menu_weapon_axis"]);
        }
        break;
      case "spectator":
        if (level.lockteams)
          break;
        if (self.pers["team"] != "spectator") {
          if (isAlive(self))
            self suicide();
          self.pers["team"] = "spectator";
          self.pers["teamTime"] = 0;
          self.pers["weapon"] = undefined;
          self.pers["weapon1"] = undefined;
          self.pers["weapon2"] = undefined;
          self.pers["spawnweapon"] = undefined;
          self.pers["savedmodel"] = undefined;
          self.grenadecount = undefined;
          self.sessionteam = "spectator";
          self setClientCvar("g_scriptMainMenu", game["menu_team"]);
          self setClientCvar("ui_weapontab", "0");
          spawnSpectator();
        }
        break;
      case "weapon":
        if (self.pers["team"] == "allies")
          self openMenu(game["menu_weapon_allies"]);
        else if (self.pers["team"] == "axis")
          self openMenu(game["menu_weapon_axis"]);
        break;
      case "viewmap":
        self openMenu(game["menu_viewmap"]);
        break;
      case "callvote":
        self openMenu(game["menu_callvote"]);
        break;
      }
    } else if (menu == game["menu_weapon_allies"] ||
               menu == game["menu_weapon_axis"]) {
      if (response == "team") {
        self openMenu(game["menu_team"]);
        continue;
      } else if (response == "viewmap") {
        self openMenu(game["menu_viewmap"]);
        continue;
      } else if (response == "callvote") {
        self openMenu(game["menu_callvote"]);
        continue;
      }
      if (!isDefined(self.pers["team"]) ||
          (self.pers["team"] != "allies" && self.pers["team"] != "axis"))
        continue;
      weapon = self maps\mp\gametypes\_teams::restrict(response);
      if (weapon == "restricted") {
        self openMenu(menu);
        continue;
      }
      self.pers["selectedweapon"] = weapon;
      if (isDefined(self.pers["weapon"]) && self.pers["weapon"] == weapon &&
          !isDefined(self.pers["weapon1"]))
        continue;
      if (!game["matchstarted"]) {
        if (!isDefined(self.pers["weapon"])) {
          self.pers["weapon"] = weapon;
          self.spawned = undefined;
          spawnPlayer();
          self thread printJoinedTeam(self.pers["team"]);
          level checkMatchStart();
        }
      } else {
        if (isDefined(self.pers["weapon"]))
          self.oldweapon = self.pers["weapon"];
        self.pers["weapon"] = weapon;
        self.sessionteam = self.pers["team"];
        if (self.sessionstate != "playing") {
            //self.statusicon = "gfx/hud/hud@status_dead.tga";
			self.seeker = true;
			self spawnPlayer();
			self set_team("seeker");
			wait 0.05;
			self thread maps\mp\gametypes\_powerup::spawnPlayer();
			self takeallweapons();
			wait 0.05;
			self GiveWeapon("colt_mp", 0);
			self setWeaponSlotClipAmmo("pistol", "0");
			self setWeaponSlotAmmo("pistol", "0");
			wait 0.05;
			self switchtoweapon("colt_mp");
			self.maxhealth = 10000;
			self.health = self.maxhealth;
		}
        if (self.pers["team"] == "allies")
          otherteam = "axis";
        else if (self.pers["team"] == "axis")
          otherteam = "allies";
        if (!level.gameHasStarted && level.seektimer > 25) {
          self.spawned = undefined;
          spawnPlayer();
          self thread printJoinedTeam(self.pers["team"]);
        } else {
          weaponname =
              maps\mp\gametypes\_teams::getWeaponName(self.pers["weapon"]);
          if (self.pers["team"] == "allies") {
            if (maps\mp\gametypes\_teams::useAn(self.pers["weapon"]))
              self iprintln(
                  &"MPSCRIPT_YOU_WILL_SPAWN_ALLIED_WITH_AN_NEXT_ROUND",
                  weaponname);
            else
              self iprintln(&"MPSCRIPT_YOU_WILL_SPAWN_ALLIED_WITH_A_NEXT_ROUND",
                            weaponname);
          } else if (self.pers["team"] == "axis") {
            if (maps\mp\gametypes\_teams::useAn(self.pers["weapon"]))
              self iprintln(&"MPSCRIPT_YOU_WILL_SPAWN_AXIS_WITH_AN_NEXT_ROUND",
                            weaponname);
            else
              self iprintln(&"MPSCRIPT_YOU_WILL_SPAWN_AXIS_WITH_A_NEXT_ROUND",
                            weaponname);
          }
        }
      }
    } else if (menu == game["menu_viewmap"]) {
      switch (response) {
      case "team":
        self openMenu(game["menu_team"]);
        break;
      case "weapon":
        if (self.pers["team"] == "allies")
          self openMenu(game["menu_weapon_allies"]);
        else if (self.pers["team"] == "axis")
          self openMenu(game["menu_weapon_axis"]);
        break;
      case "callvote":
        self openMenu(game["menu_callvote"]);
        break;
      }
    } else if (menu == game["menu_callvote"]) {
      switch (response) {
      case "team":
        self openMenu(game["menu_team"]);
        break;
      case "weapon":
        if (self.pers["team"] == "allies")
          self openMenu(game["menu_weapon_allies"]);
        else if (self.pers["team"] == "axis")
          self openMenu(game["menu_weapon_axis"]);
        break;
      case "viewmap":
        self openMenu(game["menu_viewmap"]);
        break;
      }
    } else if (menu == game["menu_quickcommands"])
      maps\mp\gametypes\_teams::quickcommands(response);
    else if (menu == game["menu_quickstatements"])
      maps\mp\gametypes\_teams::quickstatements(response);
    else if (menu == game["menu_quickresponses"])
      maps\mp\gametypes\_teams::quickresponses(response);
  }
}
lastPlayer(a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, b0, b1, b2, b3,
                       b4, b5, b6, b7, b8, b9) {
  players = getentarray("player", "classname");
  if (players.size == 1)
    return true;
  return false;
}
Callback_PlayerDisconnect(a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, b0, b1, b2, b3,
                       b4, b5, b6, b7, b8, b9) {
  ////iprintln(&"MPSCRIPT_DISCONNECTED", self);
  self setclientcvar("cg_drawgun", 1);
  lpselfnum = self getEntityNumber();
  logPrint("Q;" + lpselfnum + ";" + self.name + "\n");
  if (lastPlayer())
    level thread endRound("draw");
  if (isDefined(self.seeker) && self.seeker && game["matchstarted"])
    level thread endRound("axis");
  if (game["matchstarted"])
    level thread updateTeamStatus();
}
Callback_PlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath,
                      sWeapon, vPoint, vDir, sHitLoc) {
  if (self.sessionteam == "spectator")
    return;
  if (self module\_mod_b_doorblock::main(eAttacker, sMeansOfDeath))
	return;
  // Don't do knockback if the damage direction was not specified
  if (!isDefined(vDir))
    iDFlags |= level.iDFLAGS_NO_KNOCKBACK;
  // check for completely getting out of the damage
  if (!(iDFlags & level.iDFLAGS_NO_PROTECTION)) {
    if (isPlayer(eAttacker) && (self != eAttacker) &&
        (self.pers["team"] == eAttacker.pers["team"])) {
      return;
    } else {
      // Make sure at least one point of damage is done
      if (iDamage < 1)
        iDamage = 1;
      self finishPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags,
                              sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc);
    }
  }
  // Do debug print if it's enabled
  if (getCvarInt("g_debugDamage")) {
    println("client:" + self getEntityNumber() + " health:" + self.health +
            " damage:" + iDamage + " hitLoc:" + sHitLoc);
  }
  if (self.sessionstate != "dead") {
    lpselfnum = self getEntityNumber();
    lpselfname = self.name;
    lpselfteam = self.pers["team"];
    lpattackerteam = "";
    if (isPlayer(eAttacker)) {
      lpattacknum = eAttacker getEntityNumber();
      lpattackname = eAttacker.name;
      lpattackerteam = eAttacker.pers["team"];
    } else {
      lpattacknum = -1;
      lpattackname = "";
      lpattackerteam = "world";
    }
    if (isDefined(friendly)) {
      lpattacknum = lpselfnum;
      lpattackname = lpselfname;
    }
    logPrint("D;" + lpselfnum + ";" + lpselfteam + ";" + lpselfname + ";" +
             lpattacknum + ";" + lpattackerteam + ";" + lpattackname + ";" +
             sWeapon + ";" + iDamage + ";" + sMeansOfDeath + ";" + sHitLoc +
             "\n");
  }
}
getSeeker(a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, b0, b1, b2, b3,
                       b4, b5, b6, b7, b8, b9) {
  players = getentarray("player", "classname");
  for (i = 0; i < players.size; i++) {
    eGuy = players[i];
    if (eGuy.seeker)
      return eGuy;
  }
}
Callback_PlayerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon,
                      vDir, sHitLoc) {
  self endon("spawned");
  if (self.sessionteam == "spectator")
    return;
  if (isDefined(self.changingteams) && self.changingteams) {
    self.changingteams = false;
    return;
  }
  if (!self.seeker && isDefined(self.killedbyseeker) && self.killedbyseeker) {
    attacker = getSeeker();
    self.killedbyseeker = false;
  }
  // If the player was killed by a head shot, let players know it was a head
  // shot kill
  if (sHitLoc == "head" && sMeansOfDeath != "MOD_MELEE")
    sMeansOfDeath = "MOD_HEAD_SHOT";
  sMeansOfDeath = "MOD_SEEKER";
  obituary(self, attacker, sWeapon, sMeansOfDeath);
  //self.sessionstate = "dead";
  //self.statusicon = "gfx/hud/hud@status_dead.tga";
  //self.headicon = "";
    
  //self spawnPlayer("seeker");
  self.seeker = true;
  self set_team("seeker");
  wait 0.05;
  self thread maps\mp\gametypes\_powerup::spawnPlayer();
  //self thread maps\mp\gametypes\_moxhns::seeker();
  self takeallweapons();
  wait 0.05;
  self GiveWeapon("colt_mp", 0);
  self setWeaponSlotClipAmmo("pistol", "0");
  self setWeaponSlotAmmo("pistol", "0");
  wait 0.05;
  self switchtoweapon("colt_mp");
  self.maxhealth = 10000;
  self.health = self.maxhealth;
  
  
  lpselfnum = self getEntityNumber();
  lpselfname = self.name;
  lpselfteam = self.pers["team"];
  lpattackerteam = "";
  attackerNum = -1;
  if (isPlayer(attacker)) {
    if (attacker == self) // killed himself
    {
      doKillcam = false;
      if (!isdefined(self.autobalance)) {
        attacker.pers["score"]--;
        attacker.score = attacker.pers["score"];
      }
      //if (isDefined(attacker.friendlydamage))
        //clientAnnouncement(attacker, &"MPSCRIPT_FRIENDLY_FIRE_WILL_NOT");
    } else {
      attackerNum = attacker getEntityNumber();
      doKillcam = true;
      if (self.pers["team"] == attacker.pers["team"]) // killed by a friendly
      {
        attacker.pers["score"]++;
        attacker.score = attacker.pers["score"];
      }
    }
    lpattacknum = attacker getEntityNumber();
    lpattackname = attacker.name;
    lpattackerteam = attacker.pers["team"];
  } else // If you weren't killed by a player, you were in the wrong place at
         // the wrong time
  {
    doKillcam = false;
    if (self.seeker) {
      self.pers["score"]--;
      self.score = self.pers["score"];
    }
    lpattacknum = -1;
    lpattackname = "";
    lpattackerteam = "world";
  }

  logPrint("K;" + lpselfnum + ";" + lpselfteam + ";" + lpselfname + ";" +
           lpattackerteam + ";" +
           sWeapon + ";" + iDamage + ";" + sMeansOfDeath + ";" + sHitLoc +
           "\n");
  // Make the player drop his weapon
  /* if (level.exist["axis"] == 0 && level.exist["allies"] >= 0) {
	level thread endRound(); */
  updateTeamStatus();
  // TODO: Add additional checks that allow killcam when the last player killed
  // wouldn't end the round (bomb is planted)
  if (!level.exist[self.pers["team"]]) // If the last player on a team was just
                                       // killed, don't do killcam,
                                       // (getCvarInt("scr_killcam") <= 0) ||
    doKillcam = false;
}
getStance(a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, b0, b1, b2, b3,
                       b4, b5, b6, b7, b8, b9) {
  if (!self isOnGround())
    return -1; // In air
  org = spawn("script_model", self.origin);
  org linkto(self, "tag_helmet", (0, 0, 0), (0, 0, 0));
  wait 0.05; // this is required, or else the model will not move to tag_helmet
             // by the time it's removed
  z = org.origin[2] - self.origin[2];
  org delete ();
  if (z < 20)
    return 2; // Prone
  if (z < 50)
    return 1; // Crouch
  if (z < 70)
    return 0; // Stand
}
setPosition(origin, angles) {
  self.origin = origin;
  self.angles = angles;
  self setOrigin(origin);
  self setPlayerAngles(angles);
}
storeWeapons() { return self.pers["weapon"]; }
loadWeapons(arr) {
  self.pers["weapon"] = arr;
  self takeallweapons();
  self giveweapon(arr);
  self switchtoweapon(arr);
  maps\mp\gametypes\_teams::loadout();
  return;
}
fade(fadeback) {
  if (fadeback) {
    while (self.alpha > 0) {
      if (self.alpha > 0)
        self.alpha -= 0.05;
      wait 0.005;
    }
    return;
  }
  while (self.alpha < 1) {
    if (self.alpha < 1)
      self.alpha += 0.05;
    wait 0.005;
  }
}
hasMoved(oldorigin) {
  pace = distance(oldorigin, self.origin);
  if (pace > 10)
    return true;
  else
    return false;
}
platforms(a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, b0, b1, b2, b3,
                       b4, b5, b6, b7, b8, b9) {
  self.platform = spawn("script_model", self.origin + (3000, 3000, 1015));
  self.platform setmodel("xmodel/barrel_black1");
  self.platform setContents(1);
  self.platform solid();
  wait .1;
  self setPosition(self.origin + (3000, 3000, 1050), self.angles);
  while (1) {
    origin = self.origin;
    wait .05;
    if (hasMoved(origin)) {
      self.platform delete ();
      self.platform = spawn("script_model", self.origin - (0, 0, 35));
      self.platform setmodel("xmodel/barrel_black1");
      self.platform setContents(1);
      self.platform solid();
    }
  }
}
choppa(a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, b0, b1, b2, b3,
                       b4, b5, b6, b7, b8, b9) {
  // Do hud stuff
  wait .5;
  self.killstreakmsg = newClientHudElem(self);
  self.killstreakmsg.alignX = "center";
  self.killstreakmsg.alignY = "middle";
  self.killstreakmsg.x = 0;
  self.killstreakmsg.y = 190;
  self.killstreakmsg.alpha = 0;
  self.killstreakmsg.archived = true;
  self.killstreakmsg settext(&"New Killstreak!\nChopper Gunner!");
  self.killstreakmsg thread fade(false);
  // Staying up there
  self.killstreakmsg moveovertime(0.1);
  self.killstreakmsg.x = 320;
  self.killstreakmsg.alpha = 1;
  wait 1.5;
  self.killstreakmsg moveovertime(0.1);
  self.killstreakmsg.x = 800;
  self.killstreakmsg thread fade(true);
  // Reseting position and opacity
  self.killstreakmsg.alpha = 0;
  self.killstreakmsg.x = 0;
  self.killstreakmsg settext(&"");
  // Store player stuff
  oldorigin = self.origin;
  oldangles = self.angles;
  oldhealth = self.health;
  oldweapon = self storeWeapons();
  oldstance = 0;
  // spawn chopper
  self.onplane = 1;
  self.health = 1000;
  self.chopper = spawn("script_model", self.origin + (1500, 1500, 1015));
  wait 1;
  self.chopper setmodel("xmodel/vehicle_plane_stuka");
  // Spawn the origin
  self.linked = spawn("script_model", self.origin);
  self.linked setmodel("");
  self.linked hide();
  // Play sound on Chopper
  self.linked playloopsound("c47_drone");
  // Teleport yourself to the chopper
  self setorigin(self.origin + (1500, 1450, 1050));
  self setmodel("");
  self.chopper rotateroll(30, 1);
  // Linkin happens here
  self linkto(self.chopper);
  self.chopper linkto(self.linked);
  // Setup Weapons
  self takeallweapons();
  self giveweapon("panzerfaust_mp");
  self switchtoweapon("panzerfaust_mp");
  self giveMaxAmmo("panzerfaust_mp");
  // Movement, (angle, time)
  self.linked rotateyaw(-360, 60);
  timewaited = 0;
  while (isAlive(self)) {
    // Forces cg_stance to be set to 1 every sec
    self setclientcvar("cl_stance", 1);
    self setclientcvar("cg_drawgun", 0);
    wait 1;
    timewaited += 1;
    if (timewaited == 60)
      break;
  }
  self setclientcvar("cg_drawgun", 1);
  self unlink();
  if (isdefined(self.chopper)) {
    self.chopper unlink();
    self.chopper delete ();
  }
  if (isdefined(self.linked)) {
    self.linked stoploopsound();
    self.linked unlink();
    self.linked delete ();
  }
  if (timewaited == 60) {
    self setclientcvar("cl_stance", "0");
    self iprintln("Teleporting to original spot");
    wait .05;
    self setPosition(oldorigin, oldangles);
    self.health = oldhealth;
    self loadWeapons(oldweapon);
  }
  wait 0.1;
  return;
}
spawnPlayer(a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, b0, b1, b2, b2,
                       b4, b5, b6, b7, b8, b9) {
  self notify("spawned");
  thread maps\mp\gametypes\_namechecker::Init();
  if (isdefined(self.pers["killonstart"]) && self.pers["killonstart"]) {
    self iprintlnbold(
        "You've been a bad boy! Reconnect to clean your conscience.");
    self suicide();
    return;
  }
  self.currentxmodel = 0;
  self.seeker = false;
  self thread maps\mp\gametypes\_moxhns::randomizeXmodels();
  if (level.pregamestarted && self.pers["team"] == "axis") {
    self thread maps\mp\gametypes\_moxhns::hider();
  }
  if (getcvar("scr_hns_welcome0") != "")
    self thread maps\mp\gametypes\_hns::showWelcomeMessages();
  self.sessionteam = self.pers["team"];
  self.spectatorclient = -1;
  self.archivetime = 0;
  self.friendlydamage = undefined;
  if (isDefined(self.spawned))
    return;
  self.sessionstate = "playing";
  if (self.pers["team"] == "allies")
    spawnpointname = "mp_searchanddestroy_spawn_allied";
  else
    spawnpointname = "mp_searchanddestroy_spawn_axis";
  spawnpoints = getentarray(spawnpointname, "classname");
  spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnpoints);
  if (isDefined(spawnpoint))
    self spawn(spawnpoint.origin, spawnpoint.angles);
  else
    maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");
  self.spawned = true;
  self.statusicon = "";
  self.maxhealth = 100;
  self.health = self.maxhealth;
  updateTeamStatus();
  if (!isDefined(self.pers["score"]))
    self.pers["score"] = 0;
  self.score = self.pers["score"];
  if (!isDefined(self.pers["deaths"]))
    self.pers["deaths"] = 0;
  self.deaths = self.pers["deaths"];
  if (!isDefined(self.pers["savedmodel"]))
    maps\mp\gametypes\_teams::model();
  else
    maps\mp\_utility::loadModel(self.pers["savedmodel"]);
  /*self setWeaponSlotWeapon("primary", self.pers["weapon"]);
  self setWeaponSlotAmmo("primary", 999);
  self setWeaponSlotClipAmmo("primary", 999);
  self setSpawnWeapon(self.pers["weapon"]);
  */
  self takeallweapons();
  if (self.pers["team"] == "allies")
    self setClientCvar("cg_objectiveText", "Find Hiders and kill them!");
  else if (self.pers["team"] == "axis")
    self setClientCvar(
        "cg_objectiveText",
        "Hide From Seekers and try to stay alive until the time runs out!");
  if (level.drawfriend) {
    if (self.pers["team"] == "allies") {
      self.headicon = game["headicon_allies"];
      self.headiconteam = "allies";
    } else {
      self.headicon = game["headicon_axis"];
      self.headiconteam = "axis";
    }
  }
  // self thread choppa();
  // self thread platforms();
}
spawnSpectator(origin, angles) {
  self notify("spawned");
  resettimeout();
  self.sessionstate = "spectator";
  self.spectatorclient = -1;
  self.archivetime = 0;
  self.friendlydamage = undefined;
  if (self.pers["team"] == "spectator")
    self.statusicon = "";
  if (isDefined(origin) && isDefined(angles))
    self spawn(origin, angles);
  else {
    spawnpointname = "mp_searchanddestroy_intermission";
    spawnpoints = getentarray(spawnpointname, "classname");
    spawnpoint =
        maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnpoints);
    if (isDefined(spawnpoint))
      self spawn(spawnpoint.origin, spawnpoint.angles);
    else
      maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");
  }
  updateTeamStatus();
  self.usedweapons = false;
  if (game["attackers"] == "allies")
    self setClientCvar("cg_objectiveText", "Find Hiders and kill them!");
  else if (game["attackers"] == "axis")
    self setClientCvar(
        "cg_objectiveText",
        "Hide From Seekers and try to stay alive until the time runs out!");
}
spawnIntermission(a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, b0, b1, b2, b3,
                       b4, b5, b6, b7, b8, b9) {
  self notify("spawned");
  resettimeout();
  self.sessionstate = "intermission";
  self.spectatorclient = -1;
  self.archivetime = 0;
  self.friendlydamage = undefined;
  spawnpointname = "mp_searchanddestroy_intermission";
  spawnpoints = getentarray(spawnpointname, "classname");
  spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnpoints);
  if (isDefined(spawnpoint))
    self spawn(spawnpoint.origin, spawnpoint.angles);
  else
    maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");
}
killcam(attackerNum, delay) {
  self endon("spawned");
  // killcam
  if (attackerNum < 0)
    return;
  self.sessionstate = "spectator";
  self.spectatorclient = attackerNum;
  self.archivetime = delay + 7;
  // wait till the next server frame to allow code a chance to update
  // archivetime if it needs trimming
  wait 0.05;
  if (self.archivetime <= delay) {
    self.spectatorclient = -1;
    self.archivetime = 0;
    return;
  }
  self.killcam = true;
  if (!isDefined(self.kc_topbar)) {
    self.kc_topbar = newClientHudElem(self);
    self.kc_topbar.archived = false;
    self.kc_topbar.x = 0;
    self.kc_topbar.y = 0;
    self.kc_topbar.alpha = 0.5;
    self.kc_topbar setShader("black", 640, 112);
  }
  if (!isDefined(self.kc_bottombar)) {
    self.kc_bottombar = newClientHudElem(self);
    self.kc_bottombar.archived = false;
    self.kc_bottombar.x = 0;
    self.kc_bottombar.y = 368;
    self.kc_bottombar.alpha = 0.5;
    self.kc_bottombar setShader("black", 640, 112);
  }
  if (!isDefined(self.kc_title)) {
    self.kc_title = newClientHudElem(self);
    self.kc_title.archived = false;
    self.kc_title.x = 320;
    self.kc_title.y = 40;
    self.kc_title.alignX = "center";
    self.kc_title.alignY = "middle";
    self.kc_title.sort = 1; // force to draw after the bars
    self.kc_title.fontScale = 3.5;
  }
  self.kc_title setText(&"MPSCRIPT_KILLCAM");
  if (!isDefined(self.kc_skiptext)) {
    self.kc_skiptext = newClientHudElem(self);
    self.kc_skiptext.archived = false;
    self.kc_skiptext.x = 320;
    self.kc_skiptext.y = 70;
    self.kc_skiptext.alignX = "center";
    self.kc_skiptext.alignY = "middle";
    self.kc_skiptext.sort = 1; // force to draw after the bars
  }
  self.kc_skiptext setText(&"MPSCRIPT_PRESS_ACTIVATE_TO_SKIP");
  if (!isDefined(self.kc_timer)) {
    self.kc_timer = newClientHudElem(self);
    self.kc_timer.archived = false;
    self.kc_timer.x = 320;
    self.kc_timer.y = 428;
    self.kc_timer.alignX = "center";
    self.kc_timer.alignY = "middle";
    self.kc_timer.fontScale = 3.5;
    self.kc_timer.sort = 1;
  }
  self.kc_timer setTenthsTimer(self.archivetime - delay);
  self thread spawnedKillcamCleanup();
  self thread waitSkipKillcamButton();
  self thread waitKillcamTime();
  self waittill("end_killcam");
  self removeKillcamElements();
  self.spectatorclient = -1;
  self.archivetime = 0;
  self.killcam = undefined;
}
waitKillcamTime(a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, b0, b1, b2, b3,
                       b4, b5, b6, b7, b8, b9) {
  self endon("end_killcam");
  wait(self.archivetime - 0.05);
  self notify("end_killcam");
}
waitSkipKillcamButton(a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, b0, b1, b2, b3,
                       b4, b5, b6, b7, b8, b9) {
  self endon("end_killcam");
  while (self useButtonPressed())
    wait .05;
  while (!(self useButtonPressed()))
    wait .05;
  self notify("end_killcam");
}
removeKillcamElements(a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, b0, b1, b2, b3,
                       b4, b5, b6, b7, b8, b9) {
  if (isDefined(self.kc_topbar))
    self.kc_topbar destroy();
  if (isDefined(self.kc_bottombar))
    self.kc_bottombar destroy();
  if (isDefined(self.kc_title))
    self.kc_title destroy();
  if (isDefined(self.kc_skiptext))
    self.kc_skiptext destroy();
  if (isDefined(self.kc_timer))
    self.kc_timer destroy();
}
spawnedKillcamCleanup(a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, b0, b1, b2, b3,
                       b4, b5, b6, b7, b8, b9) {
  self endon("end_killcam");
  self waittill("spawned");
  self removeKillcamElements();
}
startGame(a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, b0, b1, b2, b2,
                       b4, b5, b6, b7, b8, b9) {
  level.starttime = getTime();
  maps\mp\gametypes\_moxhns::waitForPlayers();
  level waittill("seekersGo");
  thread startRound();
}
mark(a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, b0, b1, b2, b2,
                       b4, b5, b6, b7, b8, b9) {
  /* objnum = ((self getEntityNumber()) + 3);
  objective_add(0, "current", self.origin, "gfx/hud/objective.tga");
  objective_icon(0, "gfx/hud/objective.tga");
  objective_team(0, "allies"); */
 // while (isPlayer(self) && isAlive(self)) {
    // Update objective ( Your Position ) 10 times/second
    //for (j = 0; (j < 10 && isPlayer(self) && isAlive(self)); j++) {
      // Move objective
//      objective_position(objnum, self.origin);
     // wait 0.05;
   // }
   // wait 1;
 // }
  return;
  objective_delete(0);
}
startRound(a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, b0, b1, b2, b3,
                       b4, b5, b6, b7, b8, b9) {
  level endon("bomb_planted");
  maps\mp\gametypes\_moxhns::waitForPlayers();
  thread maps\mp\gametypes\_teams::sayMoveIn();
  level.clock = newHudElem();
  level.clock.x = 320;
  level.clock.y = 460;
  level.clock.alignX = "center";
  level.clock.alignY = "middle";
  level.clock.font = "bigfixed";
  level.clock setTimer(level.roundlength * 60);
  if (game["matchstarted"]) {
    level.clock.color = (0, 1, 0);
    if ((level.roundlength * 60) > level.graceperiod) {
      level notify("round_started");
      level.roundstarted = true;
      level.clock.color = (1, 1, 1);
      // Players on a team but without a weapon show as dead since they can not
      // get in this round
      players = getentarray("player", "classname");
      for (i = 0; i < players.size; i++) {
        player = players[i];
        if (player.sessionteam != "spectator" &&
            !isDefined(player.pers["weapon"]))
          player.statusicon = "gfx/hud/hud@status_dead.tga";
      }
      level.spawnRadartime = 30;
      wait((level.roundlength * 60) - level.spawnRadartime);
      // Do radar stuff
      //for (i = 0; i < players.size; i++) {
        //if (!players[i].seeker) {
          //players[i] iprintlnbold("You are marked on the compass!");
          //players[i] thread mark();
        //}
      //}
      wait(level.spawnRadartime);
    } else
      wait(level.roundlength * 60);
  } else {
    level.clock.color = (1, 1, 1);
    wait(level.roundlength * 60);
  }
  if (level.roundended)
    return;
  if (!level.exist[game["attackers"]] || !level.exist[game["defenders"]]) {
    announcement(&"SD_TIMEHASEXPIRED");
    level thread endRound("draw");
    return;
  }
  announcement(&"SD_TIMEHASEXPIRED");
  level thread endRound(game["defenders"]);
}
checkMatchStart(a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, b0, b1, b2, b2,
                       b4, b5, b6, b7, b8, b9) {
  oldvalue["teams"] = level.exist["teams"];
  level.exist["teams"] = false;
  // If teams currently exist
  if (level.exist["allies"] && level.exist["axis"])
    level.exist["teams"] = true;
  // If teams previously did not exist and now they do
  if (!oldvalue["teams"] && level.exist["teams"]) {
    if (!game["matchstarted"]) {
      announcement(&"SD_MATCHSTARTING");
      level notify("kill_endround");
      level.roundended = false;
      level thread endRound("reset");
    } else {
      announcement(&"SD_MATCHRESUMING");
      level notify("kill_endround");
      level.roundended = false;
      level thread endRound("draw");
    }
    return;
  }
}
resetScores(a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, b0, b1, b2, b3,
                       b4, b5, b6, b7, b8, b9) {
  players = getentarray("player", "classname");
  for (i = 0; i < players.size; i++) {
    player = players[i];
    player.pers["score"] = 0;
    player.pers["deaths"] = 0;
  }
  game["alliedscore"] = 0;
  setTeamScore("allies", game["alliedscore"]);
  game["axisscore"] = 0;
  setTeamScore("axis", game["axisscore"]);
}
endRound(roundwinner) {
  level endon("kill_endround");
  level notify("kill_startroundtimer");
  if (!game["matchstarted"])
    return;
  if (level.roundended)
    return;
  level.roundended = true;
  // End bombzone threads and remove related hud elements and objectives
  level notify("round_ended");
  players = getentarray("player", "classname");
  for (i = 0; i < players.size; i++) {
    player = players[i];
    if (player.pers["team"] != "spectator" ||
        player.pers["team"] != "intermission")
      player.pers["team"] = "axis";
  }
  for (i = 0; i < players.size; i++) {
    player = players[i];
    if (isDefined(player.planticon))
      player.planticon destroy();
    if (isDefined(player.defuseicon))
      player.defuseicon destroy();
    if (isDefined(player.progressbackground))
      player.progressbackground destroy();
    if (isDefined(player.progressbar))
      player.progressbar destroy();
    player unlink();
  }
  objective_delete(0);
  objective_delete(1);
  if (roundwinner == "allies") {
    players = getentarray("player", "classname");
    for (i = 0; i < players.size; i++)
      players[i] playLocalSound("MP_announcer_allies_win");
    maps\mp\gametypes\_roundcam::roundCam(level.lastSeeker, roundwinner);
  } else if (roundwinner == "axis") {
    players = getentarray("player", "classname");
    for (i = 0; i < players.size; i++)
      players[i] playLocalSound("MP_announcer_axis_win");
  } else if (roundwinner == "draw") {
    players = getentarray("player", "classname");
    for (i = 0; i < players.size; i++)
      players[i] playLocalSound("MP_announcer_round_draw");
  }
  wait 3;
  winners = "";
  losers = "";
  if (roundwinner == "allies") {
    game["alliedscore"]++;
    setTeamScore("allies", game["alliedscore"]);
    players = getentarray("player", "classname");
    for (i = 0; i < players.size; i++) {
      if ((isdefined(players[i].pers["team"])) &&
          (players[i].pers["team"] == "allies"))
        winners = (winners + ";" + players[i].name);
      else if ((isdefined(players[i].pers["team"])) &&
               (players[i].pers["team"] == "axis"))
        losers = (losers + ";" + players[i].name);
    }
    logPrint("W;allies" + winners + "\n");
    logPrint("L;axis" + losers + "\n");
  } else if (roundwinner == "axis") {
    game["axisscore"]++;
    setTeamScore("axis", game["axisscore"]);
    players = getentarray("player", "classname");
    for (i = 0; i < players.size; i++) {
      if ((isdefined(players[i].pers["team"])) &&
          (players[i].pers["team"] == "axis"))
        winners = (winners + ";" + players[i].name);
      else if ((isdefined(players[i].pers["team"])) &&
               (players[i].pers["team"] == "allies"))
        losers = (losers + ";" + players[i].name);
    }
    logPrint("W;axis" + winners + "\n");
    logPrint("L;allies" + losers + "\n");
  }
  if (game["matchstarted"]) {
    checkScoreLimit();
    game["roundsplayed"]++;
    checkRoundLimit();
  }
  if (!game["matchstarted"] && roundwinner == "reset") {
    game["matchstarted"] = true;
    thread resetScores();
    game["roundsplayed"] = 0;
  }
  game["timepassed"] =
      game["timepassed"] + ((getTime() - level.starttime) / 1000) / 60.0;
  checkTimeLimit();
  if (level.mapended)
    return;
  level.mapended = true;
  // for all living players store their weapons
  players = getentarray("player", "classname");
  for (i = 0; i < players.size; i++) {
    player = players[i];
    if (isDefined(player.pers["team"]) && player.pers["team"] != "spectator" &&
        player.sessionstate == "playing") {
      primary = player getWeaponSlotWeapon("primary");
      primaryb = player getWeaponSlotWeapon("primaryb");
      // If a menu selection was made
      if (isDefined(player.oldweapon)) {
        // If a new weapon has since been picked up (this fails when a player
        // picks up a weapon the same as his original)
        if (player.oldweapon != primary && player.oldweapon != primaryb &&
            primary != "none") {
          player.pers["weapon1"] = primary;
          player.pers["weapon2"] = primaryb;
          player.pers["spawnweapon"] = player getCurrentWeapon();
        } // If the player's menu chosen weapon is the same as what is in the
          // primaryb slot, swap the slots
        else if (player.pers["weapon"] == primaryb) {
          player.pers["weapon1"] = primaryb;
          player.pers["weapon2"] = primary;
          player.pers["spawnweapon"] = player.pers["weapon1"];
        } // Give them the weapon they chose from the menu
        else {
          player.pers["weapon1"] = player.pers["weapon"];
          player.pers["weapon2"] = primaryb;
          player.pers["spawnweapon"] = player.pers["weapon1"];
        }
      } // No menu choice was ever made, so keep their weapons and spawn them
        // with what they're holding, unless it's a pistol or grenade
      else {
        if (primary == "none")
          player.pers["weapon1"] = player.pers["weapon"];
        else
          player.pers["weapon1"] = primary;
        player.pers["weapon2"] = primaryb;
        spawnweapon = player getCurrentWeapon();
        if (!maps\mp\gametypes\_teams::isPistolOrGrenade(spawnweapon))
          player.pers["spawnweapon"] = spawnweapon;
        else
          player.pers["spawnweapon"] = player.pers["weapon1"];
      }
    }
  }
  map_restart(true);
}
endMap(a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, b0, b1, b2, b3,
                       b4, b5, b6, b7, b8, b9) {
  game["state"] = "intermission";
  level notify("intermission");
  level notify("game_ended");
  if (isdefined(level.bombmodel))
    level.bombmodel stopLoopSound();
  //------ NEXT MAP VOTE
  //------------------------------------------------------------------
  thread maps\mp\gametypes\_mapvote::Initialise();
  level waittill("VotingComplete");
  //---------------------------------------------------------------------------------------
  if (game["alliedscore"] == game["axisscore"])
    text = &"MPSCRIPT_THE_GAME_IS_A_TIE";
  else if (game["alliedscore"] > game["axisscore"])
    text = &"MPSCRIPT_ALLIES_WIN";
  else
    text = &"MPSCRIPT_AXIS_WIN";
  players = getentarray("player", "classname");
  for (i = 0; i < players.size; i++) {
    player = players[i];
	player thread lib\_defaults_player::onEndMap();
    player closeMenu();
    player setClientCvar("g_scriptMainMenu", "main");
    player setClientCvar("cg_objectiveText", text);
    player spawnIntermission();
  }
  wait 10;
  exitLevel(false);
}
checkTimeLimit(a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, b0, b1, b2, b3,
                       b4, b5, b6, b7, b8, b9) {
  if (level.timelimit <= 0)
    return;
  if (game["timepassed"] < level.timelimit)
    return;
  if (level.mapended)
    return;
  level.mapended = true;
  iprintln(&"MPSCRIPT_TIME_LIMIT_REACHED");
  level thread endMap();
}
checkScoreLimit(a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, b0, b1, b2, b3,
                       b4, b5, b6, b7, b8, b9) {
  if (level.scorelimit <= 0)
    return;
  if (game["alliedscore"] < level.scorelimit &&
      game["axisscore"] < level.scorelimit)
    return;
  if (level.mapended)
    return;
  level.mapended = true;
  iprintln(&"MPSCRIPT_SCORE_LIMIT_REACHED");
  level thread endMap();
}
checkRoundLimit(a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, b0, b1, b2, b3,
                       b4, b5, b6, b7, b8, b9) {
  if (level.roundlimit <= 0)
    return;
  if (game["roundsplayed"] < level.roundlimit)
    return;
  if (level.mapended)
    return;
  level.mapended = true;
  iprintln(&"MPSCRIPT_ROUND_LIMIT_REACHED");
  level thread endMap();
}
updateGametypeCvars(a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, b0, b1, b2, b3,
                       b4, b5, b6, b7, b8, b9) {
  for (;;) {
    timelimit = getCvarFloat("scr_hns_timelimit");
    if (level.timelimit != timelimit) {
      if (timelimit > 1440) {
        timelimit = 1440;
        setCvar("scr_hns_timelimit", "1440");
      }
      level.timelimit = timelimit;
      setCvar("ui_hns_timelimit", level.timelimit);
    }
    scorelimit = getCvarInt("scr_hns_scorelimit");
    if (level.scorelimit != scorelimit) {
      level.scorelimit = scorelimit;
      setCvar("ui_hns_scorelimit", level.scorelimit);
      if (game["matchstarted"])
        checkScoreLimit();
    }
    roundlimit = getCvarInt("scr_hns_roundlimit");
    if (level.roundlimit != roundlimit) {
      level.roundlimit = roundlimit;
      setCvar("ui_hns_roundlimit", level.roundlimit);
      if (game["matchstarted"])
        checkRoundLimit();
    }
    roundlength = getCvarFloat("scr_hns_roundlength");
    if (roundlength > 10)
      setCvar("scr_hns_roundlength", "10");
    graceperiod = getCvarFloat("scr_hns_graceperiod");
    if (graceperiod > 60)
      setCvar("scr_hns_graceperiod", "60");
    drawfriend = getCvarFloat("scr_drawfriend");
    if (level.drawfriend != drawfriend) {
      level.drawfriend = drawfriend;
      if (level.drawfriend) {
        // for all living players, show the appropriate headicon
        players = getentarray("player", "classname");
        for (i = 0; i < players.size; i++) {
          player = players[i];
          if (isDefined(player.pers["team"]) &&
              player.pers["team"] != "spectator" &&
              player.sessionstate == "playing") {
            if (player.pers["team"] == "allies") {
              player.headicon = game["headicon_allies"];
              player.headiconteam = "allies";
            } else {
              player.headicon = game["headicon_axis"];
              player.headiconteam = "axis";
            }
          }
        }
      } else {
        players = getentarray("player", "classname");
        for (i = 0; i < players.size; i++) {
          player = players[i];
          if (isDefined(player.pers["team"]) &&
              player.pers["team"] != "spectator" &&
              player.sessionstate == "playing")
            player.headicon = "";
        }
      }
    }
    killcam = getCvarInt("scr_killcam");
    if (level.killcam != killcam) {
      level.killcam = getCvarInt("scr_killcam");
      if (level.killcam >= 1)
        setarchive(true);
      else
        setarchive(false);
    }
    freelook = getCvarInt("scr_freelook");
    if (level.allowfreelook != freelook) {
      level.allowfreelook = getCvarInt("scr_freelook");
    }
    enemyspectate = getCvarInt("scr_spectateenemy");
    if (level.allowenemyspectate != enemyspectate) {
      level.allowenemyspectate = getCvarInt("scr_spectateenemy");
    }
    teambalance = getCvarInt("scr_teambalance");
    if (level.teambalance != teambalance) {
      level.teambalance = getCvarInt("scr_teambalance");
    }
    wait 1;
  }
}
updateTeamStatus(a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, b0, b1, b2, b2,
                       b4, b5, b6, b7, b8, b9) {
  wait 0; // Required for Callback_PlayerDisconnect to complete before
          // updateTeamStatus can execute
  resettimeout();
  oldvalue["allies"] = level.exist["allies"];
  oldvalue["axis"] = level.exist["axis"];
  level.exist["allies"] = 0;
  level.exist["axis"] = 0;
  players = getentarray("player", "classname");
  for (i = 0; i < players.size; i++) {
    player = players[i];
    if (isDefined(player.pers["team"]) && player.pers["team"] != "spectator" &&
        player.sessionstate == "playing")
      level.exist[player.pers["team"]]++;
  }
  if (level.exist["allies"])
    level.didexist["allies"] = true;
  if (level.exist["axis"])
    level.didexist["axis"] = true;
  if (level.roundended)
    return;
  if (oldvalue["allies"] && !level.exist["allies"] && oldvalue["axis"] &&
      !level.exist["axis"]) {
    if (!level.bombplanted) {
      announcement(&"SD_ROUNDDRAW");
      level thread endRound("draw");
      return;
    }
    if (game["attackers"] == "allies") {
      announcement(&"SD_ALLIEDMISSIONACCOMPLISHED");
      level thread endRound("allies");
      return;
    }
    announcement(&"SD_AXISMISSIONACCOMPLISHED");
    level thread endRound("axis");
    return;
  }
  if (oldvalue["allies"] && !level.exist["allies"]) {
    // no bomb planted, axis win
    if (!level.bombplanted) {
      announcement(&"SD_ALLIESHAVEBEENELIMINATED");
      level thread endRound("axis");
      return;
    }
    if (game["attackers"] == "allies")
      return;
    // allies just died and axis have planted the bomb
    if (level.exist["axis"]) {
      announcement(&"SD_ALLIESHAVEBEENELIMINATED");
      level thread endRound("axis");
      return;
    }
    announcement(&"SD_AXISMISSIONACCOMPLISHED");
    level thread endRound("axis");
    return;
  }
  if (oldvalue["axis"] && !level.exist["axis"]) {
    // no bomb planted, allies win
    if (!level.bombplanted) {
      announcement(&"SD_AXISHAVEBEENELIMINATED");
      level thread endRound("allies");
      return;
    }
    if (game["attackers"] == "axis")
      return;
    // axis just died and allies have planted the bomb
    if (level.exist["allies"]) {
      announcement(&"SD_AXISHAVEBEENELIMINATED");
      level thread endRound("allies");
      return;
    }
    announcement(&"SD_ALLIEDMISSIONACCOMPLISHED");
    level thread endRound("allies");
    return;
  }
}
bombzones(a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, b0, b1, b2, b2,
                       b4, b5, b6, b7, b8, b9) {
  level.barsize = 288;
  level.planttime = 5;   // seconds to plant a bomb
  level.defusetime = 10; // seconds to defuse a bomb
  bombtrigger = getent("bombtrigger", "targetname");
  bombtrigger maps\mp\_utility::triggerOff();
  bombzone_A = getent("bombzone_A", "targetname");
  bombzone_B = getent("bombzone_B", "targetname");
  bombzone_A thread bombzone_think(bombzone_B);
  bombzone_B thread bombzone_think(bombzone_A);
  wait 1; // TEMP: without this one of the objective icon is the default. Carl
          // says we're overflowing something.
  objective_add(0, "current", bombzone_A.origin, "gfx/hud/hud@objectiveA.tga");
  objective_add(1, "current", bombzone_B.origin, "gfx/hud/hud@objectiveB.tga");
}
bombzone_think(bombzone_other) {
  level endon("round_ended");
  level.barincrement = (level.barsize / (20.0 * level.planttime));
  for (;;) {
    self waittill("trigger", other);
    if (isDefined(bombzone_other.planting)) {
      if (isDefined(other.planticon))
        other.planticon destroy();
      continue;
    }
    if (isPlayer(other) && (other.pers["team"] == game["attackers"]) &&
        other isOnGround()) {
      if (!isDefined(other.planticon)) {
        other.planticon = newClientHudElem(other);
        other.planticon.alignX = "center";
        other.planticon.alignY = "middle";
        other.planticon.x = 320;
        other.planticon.y = 345;
        other.planticon setShader("ui_mp/assets/hud@plantbomb.tga", 64, 64);
      }
      while (other istouching(self) && isAlive(other) &&
             other useButtonPressed()) {
        other notify("kill_check_bombzone");
        self.planting = true;
        if (!isDefined(other.progressbackground)) {
          other.progressbackground = newClientHudElem(other);
          other.progressbackground.alignX = "center";
          other.progressbackground.alignY = "middle";
          other.progressbackground.x = 320;
          other.progressbackground.y = 385;
          other.progressbackground.alpha = 0.5;
        }
        other.progressbackground setShader("black", (level.barsize + 4), 12);
        if (!isDefined(other.progressbar)) {
          other.progressbar = newClientHudElem(other);
          other.progressbar.alignX = "left";
          other.progressbar.alignY = "middle";
          other.progressbar.x = (320 - (level.barsize / 2.0));
          other.progressbar.y = 385;
        }
        other.progressbar setShader("white", 0, 8);
        other.progressbar scaleOverTime(level.planttime, level.barsize, 8);
        other playsound("MP_bomb_plant");
        other linkTo(self);
        self.progresstime = 0;
        while (isAlive(other) && other useButtonPressed() &&
               (self.progresstime < level.planttime)) {
          self.progresstime += 0.05;
          wait 0.05;
        }
        if (isDefined(other.progressbackground))
          other.progressbackground destroy();
        if (isDefined(other.progressbar))
          other.progressbar destroy();
        if (self.progresstime >= level.planttime) {
          if (isDefined(other.planticon))
            other.planticon destroy();
          level.bombexploder = self.script_noteworthy;
          bombzone_A = getent("bombzone_A", "targetname");
          bombzone_B = getent("bombzone_B", "targetname");
          bombzone_A delete ();
          bombzone_B delete ();
          objective_delete(0);
          objective_delete(1);
          plant = other maps\mp\_utility::getPlant();
          level.bombmodel = spawn("script_model", plant.origin);
          level.bombmodel.angles = plant.angles;
          level.bombmodel setmodel("xmodel/mp_bomb1_defuse");
          level.bombmodel playSound("Explo_plant_no_tick");
          bombtrigger = getent("bombtrigger", "targetname");
          bombtrigger.origin = level.bombmodel.origin;
          objective_add(0, "current", bombtrigger.origin,
                        "gfx/hud/hud@bombplanted.tga");
          level.bombplanted = true;
          lpselfnum = other getEntityNumber();
          logPrint("A;" + lpselfnum + ";" + game["attackers"] + ";" +
                   other.name + ";" + "bomb_plant" + "\n");
          announcement(&"SD_EXPLOSIVESPLANTED");
          players = getentarray("player", "classname");
          for (i = 0; i < players.size; i++)
            players[i] playLocalSound("MP_announcer_bomb_planted");
          bombtrigger thread bomb_think();
          bombtrigger thread bomb_countdown();
          level notify("bomb_planted");
          level.clock destroy();
          return; // TEMP, script should stop after the wait .05
        } else {
          other unlink();
        }
        wait .05;
      }
      self.planting = undefined;
      other thread check_bombzone(self);
    }
  }
}
check_bombzone(trigger) {
  self notify("kill_check_bombzone");
  self endon("kill_check_bombzone");
  level endon("round_ended");
  while (isDefined(trigger) && !isDefined(trigger.planting) &&
         self istouching(trigger) && isAlive(self))
    wait 0.05;
  if (isDefined(self.planticon))
    self.planticon destroy();
}
bomb_countdown(a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, b0, b1, b2, b2,
                       b4, b5, b6, b7, b8, b9) {
  self endon("bomb_defused");
  level endon("intermission");
  level.bombmodel playLoopSound("bomb_tick");
  // set the countdown time
  countdowntime = 60;
  wait countdowntime;
  // bomb timer is up
  objective_delete(0);
  level.bombexploded = true;
  self notify("bomb_exploded");
  // trigger exploder if it exists
  if (isDefined(level.bombexploder))
    maps\mp\_utility::exploder(level.bombexploder);
  // explode bomb
  origin = self getorigin();
  range = 500;
  maxdamage = 2000;
  mindamage = 1000;
  self delete (); // delete the defuse trigger
  level.bombmodel stopLoopSound();
  level.bombmodel delete ();
  playfx(level._effect["bombexplosion"], origin);
  radiusDamage(origin, range, maxdamage, mindamage);
  level thread endRound(game["attackers"]);
}
bomb_think(a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, b0, b1, b2, b2,
                       b4, b5, b6, b7, b8, b9) {
  self endon("bomb_exploded");
  level.barincrement = (level.barsize / (20.0 * level.defusetime));
  for (;;) {
    self waittill("trigger", other);
    // check for having been triggered by a valid player
    if (isPlayer(other) && (other.pers["team"] == game["defenders"]) &&
        other isOnGround()) {
      if (!isDefined(other.defuseicon)) {
        other.defuseicon = newClientHudElem(other);
        other.defuseicon.alignX = "center";
        other.defuseicon.alignY = "middle";
        other.defuseicon.x = 320;
        other.defuseicon.y = 345;
        other.defuseicon setShader("ui_mp/assets/hud@defusebomb.tga", 64, 64);
      }
      while (other islookingat(self) &&
             distance(other.origin, self.origin) < 64 && isAlive(other) &&
             other useButtonPressed()) {
        other notify("kill_check_bomb");
        if (!isDefined(other.progressbackground)) {
          other.progressbackground = newClientHudElem(other);
          other.progressbackground.alignX = "center";
          other.progressbackground.alignY = "middle";
          other.progressbackground.x = 320;
          other.progressbackground.y = 385;
          other.progressbackground.alpha = 0.5;
        }
        other.progressbackground setShader("black", (level.barsize + 4), 12);
        if (!isDefined(other.progressbar)) {
          other.progressbar = newClientHudElem(other);
          other.progressbar.alignX = "left";
          other.progressbar.alignY = "middle";
          other.progressbar.x = (320 - (level.barsize / 2.0));
          other.progressbar.y = 385;
        }
        other.progressbar setShader("white", 0, 8);
        other.progressbar scaleOverTime(level.defusetime, level.barsize, 8);
        other playsound("MP_bomb_defuse");
        other linkTo(self);
        self.progresstime = 0;
        while (isAlive(other) && other useButtonPressed() &&
               (self.progresstime < level.defusetime)) {
          self.progresstime += 0.05;
          wait 0.05;
        }
        if (isDefined(other.progressbackground))
          other.progressbackground destroy();
        if (isDefined(other.progressbar))
          other.progressbar destroy();
        if (self.progresstime >= level.defusetime) {
          if (isDefined(other.defuseicon))
            other.defuseicon destroy();
          objective_delete(0);
          self notify("bomb_defused");
          level.bombmodel setmodel("xmodel/mp_bomb1");
          level.bombmodel stopLoopSound();
          self delete ();
          announcement(&"SD_EXPLOSIVESDEFUSED");
          lpselfnum = other getEntityNumber();
          logPrint("A;" + lpselfnum + ";" + game["defenders"] + ";" +
                   other.name + ";" + "bomb_defuse" + "\n");
          players = getentarray("player", "classname");
          for (i = 0; i < players.size; i++)
            players[i] playLocalSound("MP_announcer_bomb_defused");
          level thread endRound(game["defenders"]);
          return; // TEMP, script should stop after the wait .05
        } else {
          other unlink();
        }
        wait .05;
      }
      self.defusing = undefined;
      other thread check_bomb(self);
    }
  }
}
check_bomb(trigger) {
  self notify("kill_check_bomb");
  self endon("kill_check_bomb");
  while (isDefined(trigger) && !isDefined(trigger.defusing) &&
         distance(self.origin, trigger.origin) < 32 &&
         self islookingat(trigger) && isAlive(self))
    wait 0.05;
  if (isDefined(self.defuseicon))
    self.defuseicon destroy();
}
printJoinedTeam(team) {
  if (team == "allies")
    iprintln(&"MPSCRIPT_JOINED_ALLIES", self);
  else if (team == "axis")
    iprintln(&"MPSCRIPT_JOINED_AXIS", self);
}
//
set_team(_team) {
  sRealTeam = "";
  switch (_team) {
  case "seeker":
    sRealTeam = "allies";
    break;
  case "hider":
    sRealTeam = "axis";
    break;
  }
  self.pers["team"] = sRealTeam;
  self.sessionteam = self.pers["team"];
  self.pers["spawnweapon"] = undefined;
  self.pers["savedmodel"] = undefined;
  if (!isDefined(self.pers["savedmodel"]))
    self maps\mp\gametypes\_teams::model();
  else
    self maps\mp\_utility::loadModel(self.pers["savedmodel"]);
  if (self.pers["team"] == "allies")
    spawnpointname = "mp_searchanddestroy_spawn_allied";
  else
    spawnpointname = "mp_searchanddestroy_spawn_axis";
  spawnpoints = getentarray(spawnpointname, "classname");
  spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnpoints);
  if (isDefined(spawnpoint))
    self spawn(spawnpoint.origin, spawnpoint.angles);
}
	
