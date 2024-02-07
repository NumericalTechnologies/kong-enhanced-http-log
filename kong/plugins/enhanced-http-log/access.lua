local _M = {}
local kong = kong

function _M.execute(config)
  local body = kong.request.get_body("application/json")
  kong.ctx.plugin.request_body = body or {}
end

return _M
