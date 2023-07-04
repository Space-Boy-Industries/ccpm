-- Computercraft Package Manager CLI
local ccpm = require("/usr/modules/sbi/ccpm")

local args = {...}

local version = "v0.1.0"

local function printUsage()
	print("Usage: ccpm <command> [args]")
	print("Commands:")
	print("  repo add <url> - Add a repository")
	print("  repo remove <url> - Remove a repository")
	print("  repo list - List all repositories")
	print("  install <name> - Install a package")
	print("  remove <name> - Remove a package")
	print("  update <name> - Update a package")
	print("  search <name> - Search for a package")
	print("  version - Print version")
end

local function printRepos()
	local repos = ccpm.listRepos()
	for _, repo in ipairs(repos) do
		print(repo)
	end
end

local function addRepo(url)
	ccpm.addRepo(url)
	print("Added repository " .. url)
end

local function removeRepo(url)
	ccpm.removeRepo(url)
	print("Removed repository " .. url)
end

local function install(name)
	ccpm.install(name)
	print("Installed package " .. name)
end

local function remove(name)
	ccpm.remove(name)
	print("Removed package " .. name)
end

local function update(name)
	ccpm.update(name)
	print("Updated package " .. name)
end

local function search(name)
	local names = ccpm.search(name)
	for _, name in ipairs(names) do
		print(name)
	end
end

local function main()
	local command = args[1]

	if command == "repo" then
		local subcommand = args[2]
		if subcommand == "add" then
			addRepo(args[3])
		elseif subcommand == "remove" then
			removeRepo(args[3])
		elseif subcommand == "list" then
			printRepos()
		else
			printUsage()
		end
	elseif command == "install" then
		install(args[2])
	elseif command == "remove" then
		remove(args[2])
	elseif command == "update" then
		update(args[2])
	elseif command == "search" then
		search(args[2])
	elseif command == "version" then
		print(version)
	else
		printUsage()
	end
end

main()
