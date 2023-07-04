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

print("Saving config...")
saveJson("/etc/ccpm/dirs.json", dirs)

print("Create default startup? (Y/n)")
local startup = read()
if startup == "" or startup == "y" or startup == "Y" then
  print("Creating startup...")
  local file = fs.open("/startup/ccpm.lua", "w")
  file.write("shell.setPath(shell.path() .. \"" .. dirs.bin .. "\")")
  file.close()
end

print("Install default repos? (Y/n)")
local repos = read()

if repos == "" or repos == "y" or repos == "Y" then
  print("Installing default repos...")
  local request = http.get("https://raw.githubusercontent.com/Space-Boy-Industries/ccpm/main/repo.json")
  file.write(textutils.serializeJSON())
  file.close()
end
