-- ask for dirs
  -- bin: /usr/bin
  -- modules: /usr/modules
  -- config: /etc

function download(url, path) 
	local request = http.get(url)
	local data = request.readAll()
	request.close()
	local file = fs.open(path, "w")
	file.write(data)
	file.close()
end

function writeFile(path, str)
	local file = fs.open(path, "w")
	file.write(str)
	file.close()
end

print("What directory should I install bin files to? (default: /usr/bin)")
local bin = read()
if bin == "" then
  bin = "/usr/bin"
end

print("What directory should I install modules to? (default: /usr/modules)")
local modules = read()
if modules == "" then
  modules = "/usr/modules"
end

print("What directory should I install config files to? (default: /etc)")
local config = read()
if config == "" then
  config = "/etc"
end

local dirs = {
  ["bin"] = bin,
  ["modules"] = modules,
  ["config"] = config
}

-- make sure dirs exist
if (not fs.exists('/etc')) then
  fs.makeDir('/etc')
end

if (not fs.exists('/etc/ccpm')) then
	  fs.makeDir('/etc/ccpm')
end

for _, dir in pairs(dirs) do
  if not fs.exists(dir) then
	fs.makeDir(dir)
  end
end

print("Saving config...")
writeFile("/etc/ccpm/dirs.json", textutils.serializeJSON(dirs))

print("Create default startup? (Y/n)")
local startup = read()
if startup == "" or startup == "y" or startup == "Y" then
  print("Creating startup...")
  writeFile("/startup/ccpm.lua", "shell.setPath(shell.path() .. \":" .. dirs.bin .. "\")")
end

print("Install default repos? (Y/n)")
local repos = read()
if repos == "" or repos == "y" or repos == "Y" then
  print("Installing default repos...")
  download("https://raw.githubusercontent.com/Space-Boy-Industries/ccpm/master/repos.json", "/etc/ccpm/repos.json")
end

-- install cli and lib
print("Installing ccpm library...")
download("https://raw.githubusercontent.com/Space-Boy-Industries/ccpm/master/lib.lua", dirs.modules .. "/sbi/ccpm/lib.lua")

print("Installing ccpm cli...")
download("https://raw.githubusercontent.com/Space-Boy-Industries/ccpm/master/cli.lua", dirs.bin .. "/ccpm")
