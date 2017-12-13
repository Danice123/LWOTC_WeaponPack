
class X2Ability_LMGAbilities extends X2Ability_DefaultAbilitySet
	dependson (XComGameStateContext_Ability) config(LW_WeaponPack);

var config int LMG_AIM_BONUS_WHEN_NOT_SET_UP;

var name MountedEffectName;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	Templates.AddItem(AddLMG_MountAbility());
	return Templates;
}

DefaultProperties
{
	MountedEffectName="Mounted"
}

static function X2AbilityTemplate AddLMG_MountAbility(name TemplateName = 'MountLMG')
{
	local X2AbilityTemplate Template;
	local X2AbilityTrigger_PlayerInput InputTrigger;
	local X2AbilityCost_ActionPoints ActionPointCost;
	local X2Condition_UnitProperty ShooterPropertyCondition;
	local X2Effect_PersistentStatChange PersistentStatChangeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_ShowIfAvailable;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_pistoloverwatch";
	Template.ShotHUDPriority = 150;
	Template.bNoConfirmationWithHotKey = true;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.DisplayTargetHitChance = false;
	Template.Hostility = eHostility_Neutral;
	Template.CinescriptCameraType = "GenericAccentCam";
	Template.bDontDisplayInAbilitySummary = true;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	Template.AbilityCosts.AddItem(ActionPointCost);

	ShooterPropertyCondition = new class'X2Condition_UnitProperty';
	// ShooterPropertyCondition.ExcludeNoCover = true;
	ShooterPropertyCondition.ExcludeDead = true;
	Template.AbilityShooterConditions.AddItem(ShooterPropertyCondition);

	InputTrigger = new class'X2AbilityTrigger_PlayerInput';
	Template.AbilityTriggers.AddItem(InputTrigger);

	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.EffectName = default.MountedEffectName;
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Offense, 10);
	Template.AddTargetEffect(PersistentStatChangeEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = HunkerDownAbility_BuildVisualization;

	return Template;
}