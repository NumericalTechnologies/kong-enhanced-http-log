local access = require("kong.plugins.enhanced-http-log.access")
local log = require("kong.plugins.enhanced-http-log.log")

local KongEnhancedHttpLogHandler = {
  VERSION = "1.0.0",
  PRIORITY = 12,
}

function KongEnhancedHttpLogHandler:access()
  access.execute()
end

function KongEnhancedHttpLogHandler:log(config)
  log.execute(config)
end

return KongEnhancedHttpLogHandler
