function Notifications::OnModeStart::GameStart(gamemode)
{
	printf("游戏开始!");
	// 检测发光列表
	Timers.AddTimerByName("GlowShell",1.0,true,EntityGlowShell,null);
}

//============================================ping============================================
// 用户ping列表
::PingList <- {};
// ping显示时间
::PingExpire <- 15;

// 用户ping列表
::PingList <- {};
// ping显示时间
::PingExpire <- 15;

function ChatTriggers::ping ( player, args, text ) 
{
	local ent = player.GetLookingEntity();
	if(ent != null)
{
		local idx = ent.GetIndex();
		foreach(item in PingList)
{
			if(item.entity.GetIndex() == idx) return player.ShowHint( "该实体已被标记！", 5, "icon_alert", "", Utils.GetRandNumber(0,255) + " " + Utils.GetRandNumber(0,255) + " " + Utils.GetRandNumber(0,255), 0, 0, 0 );
		}
	}

	if(!(PingList && player.GetUniqueID() in PingList))
{
		PingList[player.GetUniqueID()] <- PingSpawn(player,ent);
		Timers.AddTimerByName(PingList[player.GetUniqueID()].flag,1,true,PingTFunc,player.GetUniqueID());
	} else
{
		// 移除该用户上一个实体标记
		EntityGlowShellRemove(PingList[player.GetUniqueID()].entity,PingList[player.GetUniqueID()].glowMark);

		PingRemove(player.GetUniqueID());
		PingList[player.GetUniqueID()] <- PingSpawn(player,ent);
	}
}

::PingSpawn <- function(player,entity)
{
	local ent = null;
	local remove = false;
	local pingBar = "来我这！";
	local icon = "icon_run";
	local glowMark = "";
	if(entity != null)
{
		// Debug
		// Msg("\n物品类：" + entity.GetClassname() + "，模型：" + entity.GetModel() + "\n");
		ent = entity;
		pingBar = "标记了 " + EntityAndPropByName(ent);
		icon = "icon_interact";
		// 添加发光
		glowMark = EntityGlowShellAdd(ent, "ping:" + GetObjectUniqueID(player), PingExpire, 3, 102, 204, 102);
	} else
{
		remove = true;
		ent = Utils.SpawnDynamicProp("models/editor/axis_helper_thick.mdl",player.GetPosition() + Vector(0,0,25));
	}
	local hint = CreateOtherHint(FollowHint(player.GetName() + "：" + pingBar,5000,0,1,"255 255 255",icon),ent ,ent.GetPosition());
	local params =
{
		flag = "ping:" + player.GetUniqueID()
		entity = ent
		hint = hint
		expire = PingExpire
		remove = remove
		glowMark = glowMark
	}
	return params;
}

::PingTFunc <- function(param)
{
	local params = PingList[param];
	if(params.expire <= 0)
{
		Timers.RemoveTimerByName(params.flag);
		PingRemove(param);
	} else params.expire--;
}

::PingRemove <- function(uniqueID)
{
	local params = PingList[uniqueID];
	DoEntFire("!self", "Kill", "", 0, null, params.hint);
	if(params.remove) params.entity.KillEntity();
	delete PingList[uniqueID];
}

::GetPlayerTypeName<-function(Z)
{
	local player = Player(Z);
	if(player.GetPlayerType() == Z_SPITTER) return "Spitter(毒液)";
	else if(player.GetPlayerType() == Z_HUNTER) return "Hunter(猎手)";
	else if(player.GetPlayerType() == Z_JOCKEY) return "Jocker(猴子)";
	else if(player.GetPlayerType() == Z_SMOKER) return "Smoker(长舌)";
	else if(player.GetPlayerType() == Z_BOOMER) return "Boomer(胖子)";
	else if(player.GetPlayerType() == Z_CHARGER) return "Charger(牛)";
	else if(player.GetPlayerType() == Z_TANK) return "Tank(坦克)";
	else if(player.GetPlayerType() == Z_SURVIVOR) return "Survivor(幸存者)";
	else return "Zombie(僵尸)";
}

::EntityAndPropByName <- function (entity)
{
	if(!entity.IsEntityValid()) return "无效实体";
    local classname = entity.GetClassname();
	local model = entity.GetModel();
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
	if(classname == "weapon_melee" || classname == "weapon_melee_spawn")
{
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
        if(model == "models/w_models/weapons/w_eq_molotov.mdl") return "燃烧瓶";
        if(model == "models/w_models/weapons/w_eq_bile_flask.mdl") return "胆汁";
    }
    if(classname == "prop_dynamic")
   
{
        if(model == "models/props_interiors/medicalcabinet02.mdl") return "药品箱";
        if(model == "models/w_models/weapons/w_cola.mdl") return "可乐";
        if(model == "models/props_junk/gnome.mdl") return "侏儒人偶";
        if(model == "models/props_unique/jukebox01.mdl") return "唱片机";
        if(model == "models/props_industrial/barrel_fuel.mdl") return "汽油桶";
        if(model == "models/props_office/vending_machine01.mdl" || model == "models/props/cs_office/vending_machine.mdl") return "售货机";
        if(model == "models/props_interiors/tv.mdl") return "电视";
        if(model == "models/props_lab/monitor01a.mdl") return "老式电脑";
    }
	if(classname == "prop_physics")
	{
		switch(model)
		{
			case "models/props_junk/dumpster_2.mdl": return "垃圾箱";
			case "models/props_fairgrounds/traffic_barrel.mdl": return "交通路障";
			case "models/props_vehicles/cara_82hatchback_wrecked.mdl": return "损坏的汽车";
		}
	}
    if(classname == "witch") return "女巫";
    if(classname == "player") return GetPlayerTypeName(entity);

    return "未知实体";
}

::GetObjectUniqueID <- function(object)
{
	local classname = object.GetClassname();
	if(classname == "player" && object.IsPlayerEntityValid()) return GetPlayerUniqueID(object);
	return object.GetIndex();
}

::GetPlayerUniqueID <- function(player)
{
	if(player.IsPlayerEntityValid())
{
		if(player.GetUniqueID() == "BOT")
{
			return player.GetIndex();
		}
		return player.GetUniqueID();
	}
}

::FindEntityByUniqueID <- function(UniqueID)
{
	foreach(object in Objects.All())
{
			if(object.GetClassname() == "player")
{
				if(object.GetUniqueID() == UniqueID || object.GetIndex() == UniqueID)
{
					if(object.IsPlayerEntityValid()) return object;
					return null;
				}
			} else if(object.GetIndex() == UniqueID) return object;
	}
	return null;
}

// 指导性hint
::FollowHint <- function(StrBar, range, duration = 5, coercion = 0, color = "255 255 255", icon = "icon_tip")
{
	return HintSpawnInfo <-
{
		classname = "env_instructor_hint"
		hint_name = "follow_hint" + UniqueString()
		hint_caption = StrBar
		hint_auto_start = 1
		hint_timeout = duration
		hint_static = 0
		hint_forcecaption = coercion
		hint_icon_onscreen = icon
		hint_icon_offscreen = icon
		hint_instance_type = 2
		hint_range = range
		hint_allow_nodraw_target = 1
		hint_icon_offset = 8
		hint_color = "255 255 255"
	}
}

// 通用实体hint 创建
::CreateOtherHint <- function(hint, entity, pos)
{
	local hintname = "c_d_hint_" + entity.GetName();
	hint["targetname"] <- hintname;

	local spawn =
	{
		classname = "prop_dynamic",
		solid = "0",
		model = "models/editor/axis_helper_thick.mdl",
		targetname = "prop_dynamic_" + entity.GetName() ,
		rendermode = "10",
		angles = QAngle(0, 0, 0)
	};
	spawn["spawnflags"] <- 256;

	local prop_dynamic = g_ModeScript.CreateSingleSimpleEntityFromTable(spawn);
	prop_dynamic.ValidateScriptScope();
	local UniqueName = prop_dynamic.GetName();;

	AttachOther(PlayerInstanceFromIndex(entity.GetIndex()),prop_dynamic, true, pos);
	g_MapScript.CreateHintTarget( UniqueName, prop_dynamic.GetOrigin(), null, g_MapScript.TrainingHintTargetCB )
	g_MapScript.CreateHintOn(UniqueName, null, hint.hint_caption, hint, g_MapScript.TrainingHintCB )
	local ex = regexp("[0-9]+");
	local res = ex.search(SessionState.TrainingHintTargetNextName);
	local num = SessionState.TrainingHintTargetNextName.slice(res.begin,res.end).tointeger();
	SessionState.rawdelete( "TrainingHintTargetNextName" );

	return Entities.FindByName(null,"_"+(++num)+"_"+hintname);
}

::AttachOther <- function(Entity,otherEntity, teleportOther,pos)
{
	teleportOther = (teleportOther.tointeger() > 0) ? true : false;
	if (teleportOther)
		otherEntity.SetOrigin(pos);
	DoEntFire("!self", "SetParent", "!activator", 0, Entity, otherEntity);
}

//==============================================实体发光=============================================
::GlowShellList <-
{};

::EntitySetGlow <- function(ent, type, color){
	if(!ent || !ent.IsEntityValid()) return OtherError("EntitySetGlow function Entity is not valid");
	ent.SetNetProp("m_Glow.m_glowColorOverride", color);
	ent.SetNetProp("m_Glow.m_iGlowType", type);
}

// 调用该函数使实体发光进入队列
// 默认使用 mark 为 "" 就行
// 传入 mark 则可以给添加的发光做个标记，好将来根据mark删除
::EntityGlowShellAdd <- function(entity, mark, expire, type, red, green, blue, alpha = 255)
{
	if(!GlowShellList) return OtherError("EntityGlowShellAdd function GlowShellList no exist!");
	
	local UniqueID = GetObjectUniqueID(entity);
	if(!(UniqueID in GlowShellList)) GlowShellList[UniqueID] <-
{
		uniqueID = GetObjectUniqueID(entity)
		original =
{
			color = entity.GetGlowColor()
			type = entity.GetNetPropInt("m_Glow.m_iGlowType")
		}
		queue = []
	}
	local GlowMark = mark != "" ? mark : UniqueString();
	GlowShellList[UniqueID].queue.push({
		mark = GlowMark
		expire = expire
		shell =
{
			color = Utils.SetColor32( red, green, blue, alpha)
			type = type
		}
	});
	return GlowMark;
}


::EntityGlowShellGetIndex <- function(UniqueID, mark)
{
	if(!GlowShellList) return OtherError("EntityGlowShellFixedGetIndex function GlowShellList no exist!");
	if(UniqueID in GlowShellList)
{
		foreach(idx,item in GlowShellList[UniqueID].queue)
{
			if(item.mark == mark) return idx
		}
	}
	return -1;
}

::EntityGlowShellRemove <- function(entity, mark)
{
	local UniqueID = GetObjectUniqueID(entity);
	local idx = EntityGlowShellGetIndex(UniqueID, mark);
	if(idx != -1) GlowShellList[UniqueID].queue.remove(idx);
	return OtherError("EntityGlowShellFixedRemove function GlowShellList Key " + UniqueID + " fixedQueue no exist!");
}

::EntityGlowShell <- function(params){
	foreach(item in GlowShellList)
{
		// Utils.PrintTable(GlowShellList);
		foreach(idx,shell in item.queue)
{
			if(--shell.expire <= 0) item.queue.remove(idx);
		}
		local entity = FindEntityByUniqueID(item.uniqueID);
		
		// 时效性发光外壳列表
		if(entity && entity.IsEntityValid() && item.queue.len() > 0)
{
			local currentShell = item.queue[item.queue.len() - 1].shell;
			EntitySetGlow(entity, currentShell.type, currentShell.color);
		}
		// 列表全部没有则恢复原样
		else
{
			EntitySetGlow(entity, item.original.type, item.original.color);
			delete GlowShellList[item.uniqueID];
		}
	}
}

::OtherError <- function(msg)
{
	Msg("\n---------------------------------------------------------------------");
	Msg("\nError：" + msg);
	Msg("\n---------------------------------------------------------------------\n");
	return -1;
}
