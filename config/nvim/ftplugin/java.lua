local jdtls = require("jdtls")

local home = os.getenv("HOME")
local workspace_dir = home .. "/.local/share/jdtls-workspaces/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

local launcher = vim.fn.glob(home .. "/.local/share/jdtls/plugins/org.eclipse.equinox.launcher_*.jar")
local lombok = home .. "/.local/share/lombok/lombok.jar"

local config = {
  cmd = {
    "java",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xms1g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens", "java.base/java.util=ALL-UNNAMED",
    "--add-opens", "java.base/java.lang=ALL-UNNAMED",
    "-javaagent:" .. lombok,
    "-Xbootclasspath/a:" .. lombok,
    "-jar", launcher,
    "-configuration", home .. "/.local/share/jdtls/config_mac",
    "-data", workspace_dir,
  },

  root_dir = require("jdtls.setup").find_root({ "pom.xml", "build.gradle", ".git" }),
  settings = {
    java = {},
  },
  init_options = {
    bundles = {},
  },
}

jdtls.start_or_attach(config)

