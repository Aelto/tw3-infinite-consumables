call variables.cmd
call encode-csv-strings.bat

rmdir "%modpath%\release" /s /q
mkdir "%modpath%\release"

XCOPY "%modpath%\%modname%" "%modpath%\release\mods\%modName%\" /e /s /y
XCOPY "%modpath%\strings" "%modpath%\release\mods\%modName%\content\" /e /s /y

mkdir "%modpath%\release\bin\config\r4game\user_config_matrix\pc\"
copy "%modpath%\mod-menu.xml" "%modpath%\release\bin\config\r4game\user_config_matrix\pc\%modname%.xml" /y
