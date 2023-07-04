-- Computer Craft Package Manager Library
-- functionalities
	-- add repositories (remote and in /etc/ccpm/repos.json)
	-- remove repositories
	-- list repositories
	-- install packages from a repository
	-- remove packages
	-- update packages

-- /etc/ccpm/repos.json format
-- [
-- 	"https://raw.githubusercontent.com/Space-Boy-Industries/ccpm/main/repo.json"
-- ]

-- example repo format
-- {
-- 	"name": "default",
-- 	"format": "v1",
-- 	"packages": {
-- 		"quarry": {
-- 			"version": "3.6.4",
-- 			"files": {
-- 				"bin": [
-- 					["https://pastebin.com/raw/rpXRAZs4", "quarry"]
-- 				],
-- 				"modules": [],
-- 				"config": []
-- 			}
-- 		},
-- 		"cctracker": {
-- 			"version": "1.0.0",
-- 			"files": {
-- 				"bin": [
-- 					["https://raw.githubusercontent.com/James-Dumas/cctracker/master/cctracker.lua", "cctracker"]
-- 				],
-- 				"modules": [],
-- 				"config": []
-- 			}
-- 		}
-- 	}
-- }

local ccpm = {}

local function loadJson(path)
	local file = fs.open(path, "r")
	local data = file.readAll()
	file.close()
	return textutils.unserializeJSON(data)
end

local function saveJson(path, data)
	local file = fs.open(path, "w")
	file.write(textutils.serializeJSON(data))
	file.close()
end

local function loadDirectoryConfig()
	local dirs = loadJson("/etc/ccpm/dirs.json")
	if not dirs then
		dirs = {
			["bin"] = "/usr/bin",
			["modules"] = "/usr/modules",
			["config"] = "/etc"
		}
		saveJson("/etc/ccpm/dirs.json", dirs)
	end
	return dirs
end

local function loadRepoList()
	local path = "/etc/ccpm/repos.json"
	if not fs.exists(path) then
		saveJson(path, {})
	end
	return loadJson(path)
end

local function saveRepoList(data)
	local path = "/etc/ccpm/repos.json"
	saveJson(path, data)
end

local function loadRepo(url) 
	local request = http.get(url)
	local data = request.readAll()
	request.close()
	return textutils.unserializeJSON(data)
end

local function loadAllPackages()
	local repos = loadRepoList()
	local packages = {}

	for _, url in pairs(repos) do
		local repo = loadRepo(url)
		for name, package in pairs(repo.packages) do
			packages[name] = package
		end
	end

	return packages
end

local function loadPackage(name)
	local packages = loadAllPackages()
	return packages[name]
end

local function installPackage(name)
	local package = loadPackage(name)
	local dirs = loadDirectoryConfig()

	for name, path in pairs(dirs) do
		for _, file in ipairs(package.files[name]) do
			local request = http.get(file[1])
			local data = request.readAll()
			request.close()
			local path = path .. "/" .. file[2]
			local file = fs.open(path, "w")
			file.write(data)
			file.close()
		end
	end
end

local function removePackage(name)
	local package = loadPackage(name)
	local dirs = loadDirectoryConfig()

	for name, path in pairs(dirs) do
		for _, file in ipairs(package.files.bin) do
			local path = path .. "/" .. file[2]
			fs.delete(path)
		end
	end
end

local function updatePackage(name)
	removePackage(name)
	installPackage(name)
end

function ccpm.addRepo(url)
	local repos = loadRepoList()
	table.insert(repos, url)
	saveRepoList(repos)
end

function ccpm.removeRepo(url)
	local repos = loadRepoList()
	for i, repo in ipairs(repos) do
		if repo == url then
			table.remove(repos, i)
			break
		end
	end
	saveRepoList(repos)
end

function ccpm.listRepos()
	return loadRepoList()
end

function ccpm.install(name)
	installPackage(name)
end

function ccpm.remove(name)
	removePackage(name)
end

function ccpm.update(name)
	updatePackage(name)
end

function ccpm.search(name)
	local packages = loadAllPackages()
	local names = {}
	for packageName, _ in pairs(packages) do
		if string.find(packageName, name) then
			table.insert(names, packageName)
		end
	end
	table.sort(names)
	return names
end

return ccpm
