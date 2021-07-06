Msg("Ping脚本\n");
IncludeScript("VSLib");

//============================================ping============================================
// 用户ping列表
::PingList <- {};
// ping显示时间
::PingExpire <- 15;

function ChatTriggers::ping ( player, args, text ) {
	local ent = player.GetLookingEntity();
	if(!(PingList && player.GetUniqueID() in PingList)) {
		local params = PingSpawn(player,ent);
		PingList[player.GetUniqueID()] <- params;
		Timers.AddTimerByName(params["flag"],1,true,PingTFunc,player.GetUniqueID());
	} else {
		PingRemove(player.GetUniqueID());
		PingList[player.GetUniqueID()] <- PingSpawn(player,ent);
	}
}

::PingSpawn <- function(player,entity) {
	local ent = null;
	local remove = false;
	local pingBar = "来我这！";
	local icon = "icon_run";
	if(entity != null) {
		// Debug
		// Msg("\n物品类：" + entity.GetClassname() + "，模型：" + entity.GetModel() + "\n");
		ent = entity;
		pingBar = "标记了 " + EntityAndPropByName(ent);
		icon = "icon_interact";
	} else {
		remove = true;
		ent = Utils.SpawnDynamicProp("models/editor/axis_helper_thick.mdl",player.GetPosition() + Vector(0,0,25));
	}
	local hint = CreateOtherHint(FollowHint(player.GetName() + "：" + pingBar,5000,0,1,"255 255 255",icon),ent ,ent.GetPosition());
	local params = {
		flag = "ping:" + player.GetUniqueID()
		entity = ent
		hint = hint
		expire = PingExpire
		remove = remove
	}
	return params;
}

::PingTFunc <- function(param) {
	if(PingList[param].expire <= 0) {
		Timers.RemoveTimerByName(PingList[param].flag);
		PingRemove(param);
	} else {
		PingList[param].expire--;
	}
}

::PingRemove <- function(param) {
	DoEntFire("!self", "Kill", "", 0, null, PingList[param].hint);
	if(PingList[param].remove) PingList[param].entity.KillEntity();
	delete PingList[param];
}

::GetZombieName<-function(Z)
{
	if(Player(Z).GetPlayerType() == Z_SPITTER) return "Spitter(毒液)";
	else if(Id.GetPlayerType() == Z_HUNTER) return "Hunter(猎手)";
	else if(Id.GetPlayerType() == Z_JOCKEY) return "Jocker(猴子)";
	else if(Id.GetPlayerType() == Z_SMOKER) return "Smoker(长舌)";
	else if(Id.GetPlayerType() == Z_BOOMER) return "Boomer(胖子)";
	else if(Id.GetPlayerType() == Z_CHARGER) return "Charger(牛)";
	else if(Id.GetPlayerType() == Z_TANK) return "Tank(坦克)";
	else if(Id.GetPlayerType() == Z_SURVIVOR) return "Survivor(幸存者)";
	else return "Zombie(僵尸)";
}

::EntityAndPropByName <- function (entity) {
    local classname = entity.GetClassname();
    if(classname == "weapon_rifle_ak47") return "AK47步枪";
	if(classname == "weapon_rifle") return "M16步枪";
	if(classname == "weapon_smg") return "smg冲锋枪"
	if(classname == "weapon_smg_silenced") return "消音smg冲锋枪";
	if(classname == "weapon_smg_mp5") return "MP5冲锋枪";
	if(classname == "weapon_pumpshotgun") return "旧式单喷";
	if(classname == "weapon_shotgun_chrome") return "新式单喷";
	if(classname == "weapon_rifle_desert") return "SCAR步枪";
	if(classname == "weapon_rifle_sg552") return "SG552步枪";
	if(classname == "weapon_rifle_m60") return "M60机枪";
	if(classname == "weapon_autoshotgun") return "旧式连喷";
	if(classname == "weapon_shotgun_spas") return "新式连喷";
	if(classname == "weapon_hunting_rifle") return "一代连阻";
	if(classname == "weapon_sniper_military") return "二代连阻";
	if(classname == "weapon_sniper_awp") return "重阻AWP";
	if(classname == "weapon_sniper_scout") return "轻阻Scout";
	if(classname == "weapon_grenade_launcher") return "榴弹枪";
	if(classname == "weapon_pistol") return "小手枪";
	if(classname == "weapon_pistol_magnum") return "沙漠之鹰";
	if(classname == "weapon_melee" || classname == "weapon_melee_spawn") {
		local model = entity.GetModel();
		if(model == "models/w_models/weapons/w_knife_t.mdl") return "小刀";
		if(model == "models/weapons/melee/w_machete.mdl") return "砍刀";
		if(model == "models/weapons/melee/w_katana.mdl") return "太刀";
		if(model == "models/weapons/melee/w_bat.mdl") return "棒球棍";
		if(model == "models/weapons/melee/w_fireaxe.mdl") return "斧头";
		if(model == "models/weapons/melee/w_crowbar.mdl") return "撬棍";
		if(model == "models/weapons/melee/w_tonfa.mdl") return "警棍";
		if(model == "models/weapons/melee/w_golfclub.mdl") return "高尔夫球杆";
		if(model == "models/weapons/melee/w_pitchfork.mdl") return "干草叉";
		if(model == "models/weapons/melee/w_shovel.mdl") return "铲子";
		if(model == "models/weapons/melee/w_electric_guitar.mdl") return "电吉他";
		if(model == "models/weapons/melee/w_frying_pan.mdl") return "平底锅";
		// 自定义武器
		if(model == "models/weapons/melee/w_bow.mdl") return "反曲弓";
		if(model == "models/weapons/melee/w_ammo_pack.mdl") return "子弹包";
		if(model == "models/weapons/melee/w_flamethrower.mdl") return "喷火器";
		if(model == "models/weapons/melee/w_sentry.mdl") return "自动哨兵塔";
		if(model == "models/weapons/melee/w_custom_shotgun.mdl") return "管制霰弹枪";
		if(model == "models/weapons/melee/w_syringe_gun.mdl") return "治疗枪";
	}
	if(classname == "weapon_chainsaw" || classname == "weapon_chainsaw_spawn") return "电锯";
	if(classname == "weapon_pipe_bomb" || classname == "weapon_pipe_bomb_spawn") return "土制炸弹";
	if(classname == "weapon_molotov" || classname == "weapon_molotov_spawn") return "燃烧瓶";
	if(classname == "weapon_vomitjar" || classname == "weapon_vomitjar_spawn") return "胆汁";
	if(classname == "weapon_first_aid_kit" || classname == "weapon_first_aid_kit_spawn") return "医疗包";
	if(classname == "weapon_defibrillator" || classname == "weapon_defibrillator_spawn") return "电击器";
	if(classname == "weapon_upgradepack_incendiary" || classname == "weapon_upgradepack_incendiary_spawn") return "燃烧子弹升级包";
	if(classname == "weapon_upgradepack_explosive" || classname == "weapon_upgradepack_explosive_spawn") return "高爆子弹升级包";
    if(classname == "upgrade_laser_sight") return "红外线升级";
	if(classname == "weapon_pain_pills" || classname == "weapon_pain_pills_spawn") return "止痛药";
	if(classname == "weapon_adrenaline" || classname == "weapon_adrenaline_spawn") return "肾上腺素";
	if(classname == "weapon_gascan") return "燃料桶";
	if(classname == "weapon_propanetank") return "煤气罐";
	if(classname == "weapon_oxygentank") return "氧气瓶";
	if(classname == "weapon_gnome") return "圣诞老人";
	if(classname == "weapon_cola_bottles") return "乐可瓶";
	if(classname == "weapon_fireworkcrate") return "烟花盒";
    if(classname == "prop_minigun_l4d1") return "加特林";
    if(classname == "prop_minigun") return "机枪";
    if(classname == "weapon_ammo_spawn") return "子弹堆";
    if(classname == "weapon_spawn")
    {
        local model = entity.GetModel();
        if(model == "models/w_models/weapons/w_eq_molotov.mdl") return "燃烧瓶";
        if(model == "models/w_models/weapons/w_eq_bile_flask.mdl") return "胆汁";
    }
    if(classname == "prop_dynamic")
    {
        local model = entity.GetModel();
        if(model == "models/props_interiors/medicalcabinet02.mdl") return "药品箱";
        if(model == "models/w_models/weapons/w_cola.mdl") return "可乐";
        if(model == "models/props_junk/gnome.mdl") return "侏儒人偶";
        if(model == "models/props_unique/jukebox01.mdl") return "唱片机";
        if(model == "models/props_industrial/barrel_fuel.mdl") return "汽油桶";
        if(model == "models/props_office/vending_machine01.mdl" || model == "models/props/cs_office/vending_machine.mdl") return "售货机";
        if(model == "models/props_interiors/tv.mdl") return "电视";
        if(model == "models/props_lab/monitor01a.mdl") return "老式电脑";
    }
    if(classname == "witch") return "女巫";
    if(classname == "player") return GetZombieName(entity);

    return "未知实体";
}