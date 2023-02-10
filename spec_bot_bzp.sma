#include <amxmodx>
#include <amxmisc>
#include <fakemeta>
#include <cstrike>

#define PLUGIN "SPEC BOT"
#define VERSION "1.0"
#define AUTHOR "PANDA"

new ilosc_botow_online, maxplayers, maxbots;
new const nazwy[][]= { "Ananasek", "Ziemniak", "Franek" };

public plugin_init(){
	register_plugin(PLUGIN, VERSION, AUTHOR);
	set_task(5.0, "stworz_bota");
	maxplayers=get_maxplayers();
	maxbots=sizeof(nazwy);
}

public plugin_end(){
	if(ilosc_botow_online>0){
		for(new i = 0; i < maxbots; i++){
			if(ilosc_botow_online==0) break;
			ilosc_botow_online--;
			server_cmd("kick ^"%s^"", nazwy[ilosc_botow_online]);
		}
	}
}

public stworz_bota(){
	for(new i = 0; i < maxbots; i++){
		if(ilosc_botow_online==maxbots || maxplayers-get_playersnum_ex(GetPlayers_None)<2) break;
		new id = engfunc(EngFunc_CreateFakeClient, nazwy[ilosc_botow_online]);
		dllfunc(DLLFunc_ClientConnect, id, nazwy[ilosc_botow_online],"20.05.45.45.2");
		dllfunc(DLLFunc_ClientPutInServer, id);
		set_pev(id, pev_spawnflags, pev(id, pev_spawnflags) | FL_FAKECLIENT);
		set_pev(id, pev_flags, pev(id, pev_flags) | FL_FAKECLIENT);
		cs_set_user_team(id, CS_TEAM_SPECTATOR);
		set_user_flags(id, ADMIN_IMMUNITY);
		ilosc_botow_online++;
	}
}

public client_putinserver(id){	
	if(maxplayers-get_playersnum_ex(GetPlayers_None)==0 && ilosc_botow_online>0){
		ilosc_botow_online--;
		server_cmd("kick %s", nazwy[ilosc_botow_online]);
	}
}

public client_disconnected(id){
	if(task_exists(id)) change_task(id, 0.5);
	set_task(0.5, "check", id);
}

public check(){
	if(ilosc_botow_online < maxbots && maxplayers-get_playersnum_ex(GetPlayers_None)>1)
		stworz_bota();
}
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ deff0{\\ fonttbl{\\ f0\\ fnil Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang1045\\ f0\\ fs16 \n\\ par }
*/
