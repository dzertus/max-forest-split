/*
<grimoire>
	<description>Tool to split forest for foreground/background pourpose</description>
	<authors>YTA</authors>
	<version> 0.0.1 </version>
	<categories>Render</categories>
</grimoire>
*/

ForestSplitLog = TatLoggerModule "ForestSplit"
ForestSplitLog.setVerbosity #warning


-- Retrieving version from deployment folder (e.g. \\koro\pub\MatCheck\0.0.1 => 0.0.1)
FORESTSPLIT_VERSION = substituteString (pathConfig.stripPathToLeaf (getFilenamePath (getThisScriptFilename()))) "\\" ""

fileIn "ForestSplit_UI.ms"
fileIn "ForestSplit_Lib.ms"
fileIn "ForestSplit_Macros.ms"

configFile = (getfileNamePath (getThisScriptFilename())) + @"\Config\" + __TATPROJECT__ + ".ms"
if doesFileExist configFile then (
	fileIn configFile
)

FORESTSPLIT_LOCAL_SETTINGS  = (getfileNamePath (getThisScriptFilename())) + "Local.ms"
if (doesFileExist FORESTSPLIT_LOCAL_SETTINGS) then (
	fileIn FORESTSPLIT_LOCAL_SETTINGS
)

