global ForestSplitRollout
global TatObjectNamesLib
global TatMxsLib
global KiwiAPI

global __RENDERFOLDER__

struct ST_ForestSplit
(
	_rgxClass = dotnetclass "System.Text.RegularExpressions.Regex",

	_dotnetPath =  dotnetclass "System.IO.Path",

	ExportFolder = @"\\lm4\ARGO\06_LINK\Cache", -- set in Script.ms
	LightsSetupFolder = @"N:\XX_LIB\lib_Rendu\SetUp_Light", -- set in Script.ms

	FirelightFXDuration = 2000,

	LightsPatterns = #("L_*", "KeyLight_*", "FILL_*", "RIM_*", "BNC_*", "L06_*", "L07_*", "Dome_*"), -- set in Script.ms

	VrayLightClasses = #(VRayLight, VRaySun, VRayAmbientLight, VRayIES),
	VrayLightsFolder = __TATDRIVE__ + @"\XX_LIB\lib_rendu\VrayLightsConfig",

	fn GetBoxLight l = (
		if superClassOf l == light then (
			local m = for o in l.children where matchPattern o.name pattern:"ExportBox*" collect o
			if m.count > 0 then (
				return m[1]
			)
		)
		return undefined
	),

)

ForestSplit = ST_ForestSplit()
