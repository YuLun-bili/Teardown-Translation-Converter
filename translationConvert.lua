LANGLIST = {
	"de",
	"en",
	"es-ES",
	"fr",
	"it",
	"ja",
	"pl",
	"ru",
	"zh-CN"
}
LANGLOOKUP = {
	["de"] =	{"German",		"german"},
	["en"] =	{"English",		"english"},
	["es-ES"] =	{"Spanish",		"spanish"},
	["fr"] =	{"French",		"french"},
	["it"] =	{"Italian",		"italian"},
	["ja"] =	{"Japanese",	"japanese"},
	["pl"] =	{"Polish",		"polish"},
	["ru"] =	{"Russian",		"russian"},
	["zh-CN"] =	{"Chinese",		"simplified_chinese"}
}

local confirmation = false
local relaPath, fileName, destPath, newDestPath
local sourcePath, targetPath
local currDir = io.popen("cd"):read("*l"):gsub("\\", "/")
local relaPathBack, destPathBack
local performedLocale = {}

repeat
	print("Current directory path:\n")
	print(">", currDir)
	print("\nPlease enter relative path towards destination localization files' folder (\"../\" goes to previous directory):\n")
	relaPath = io.read("*l"):gsub("\\", "/")
	print("\nPlease enter localization file name (with extension):\n")
	fileName = io.read("*l"):gsub("\\", "/")
	print("\nPlease enter root folder for destination mod (\"../\" goes to previous directory):\n")
	destPath = io.read("*l"):gsub("\\", "/")

	relaPath, relaPathBack = relaPath:gsub("%.%./", "")
	local cutCurDir1 = currDir:reverse():gsub("[^/]*/", "", relaPathBack):reverse()
	sourcePath = string.format("%s/%s", cutCurDir1, relaPath):gsub("/*$", "")

	newDestPath, destPathBack = destPath:gsub("%.%./", "")
	local cutCurDir2 = currDir:reverse():gsub("[^/]*/", "", destPathBack):reverse()
	targetPath = string.format("%s/%s", cutCurDir2, newDestPath):gsub("/$", "")

	print("\nPlease check entered information:")
	print("> localization folder:", sourcePath)
	print("> file name          :", fileName)
	print("> destination mod    :", targetPath)
	print("Are these information correct? (y/n)")
	confirmation = io.read("*l"):lower():sub(1, 1) == "y"
until confirmation

print("---------------PROCESSING---------------")

for _, langCode in ipairs(LANGLIST) do
	repeat
		local langName = LANGLOOKUP[langCode][1]
		local destFilePath = string.format("%s/data/texts/strings_%s.str", (destPath:gsub("/*$", "")), LANGLOOKUP[langCode][2])
		local processedLocale = {}

		print(string.format("Looking for localization source file for %s (%s)", langName, langCode))
		local tempPath = (string.format("%s/%s/%s", relaPath, langCode, fileName)):gsub("^/*", "")
		local sourceFile = io.open(tempPath, "r")
		if not sourceFile then print(string.format("No localization source file found for %s (%s), skipping\n", langName, langCode)) break end

		print(string.format("Found localization source file for %s (%s)", langName, langCode))
		print(">", "Processing source file...")
		for newLine in sourceFile:lines() do table.insert(processedLocale, (newLine:gsub("^\"(.-)\"", "%1"))) end
		print(">", "Completed")

		print(">", string.format("Exporting localization to \"%s\"...", destFilePath))
		local destFile = io.open(destFilePath, "w+") or io.open(destFilePath, "w")
		if not destFile then
			os.execute(string.format("md \"%s/data/texts\"", targetPath))
			destFile = io.open(destFilePath, "w+") or io.open(destFilePath, "w")
		end

		for _, localeStr in ipairs(processedLocale) do destFile:write(localeStr, "\n") end
		destFile:close()
		print(">", "Completed")
		print("")
		table.insert(performedLocale, string.format("%s (%s)", langName, langCode))
	until true
end

print("---------------COMPLETED----------------")
print(string.format("Processed localization for %d languages:", #performedLocale))
print(">", table.concat(performedLocale, ", "))
local endStr
repeat endStr = io.read("*l") until #endStr > 0