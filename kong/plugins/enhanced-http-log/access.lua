local _M = {}
local kong = kong

function _M.execute()
  kong.ctx.plugin.request_headers = kong.request.get_headers() or {}
  kong.ctx.plugin.request_body = kong.request.get_body("application/json") or {}
end

return _M
