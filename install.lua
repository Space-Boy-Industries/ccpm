-- ask for dirs
  -- bin: /usr/bin
  -- modules: /usr/modules
  -- config: /etc

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
dirFile = fs.open("/etc/ccpm/dirs.json", "w")
dirFile.write("/etc/ccpm/dirs.json", dirs)
dirFile.close()

print("Create default startup? (Y/n)")
local startup = read()
if startup == "" or startup == "y" or startup == "Y" then
  print("Creating startup...")
  local startupFile = fs.open("/startup/ccpm.lua", "w")
  startupFile.write("shell.setPath(shell.path() .. \":" .. dirs.bin .. "\")")
  startupFile.close()
end

print("Install default repos? (Y/n)")
local repos = read()

if repos == "" or repos == "y" or repos == "Y" then
  print("Installing default repos...")
  local request = http.get("https://raw.githubusercontent.com/Space-Boy-Industries/ccpm/main/repo.json")
  local data = request.readAll()
  reposFile = fs.open("/etc/ccpm/repos.json", "w")
  reposFile.write(textutils.serializeJSON(data))
  reposFile.close()
end
