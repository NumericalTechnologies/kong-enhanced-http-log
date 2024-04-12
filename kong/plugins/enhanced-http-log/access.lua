local _M = {}
local kong = kong

function _M.execute()
  kong.ctx.plugin.request_headers = kong.request.get_headers()
  kong.ctx.plugin.request_body = kong.request.get_body()
end

return _M
