local limit_req = require "plugin.limit.limit_req"
local auth_check = require "plugin.auth.auth_check"
local init_log = require "plugin.logs.init_log"
local upstream = require "upstream"

local tools = require "tools"
local user_info = ngx.shared.user_info

function get_svc_code()
    local url_path_list = tools.split(ngx.var.uri, '/')
    local svc_code = url_path_list[1]
	if svc_code == nil then
		return ngx.exit(404)
    end
    table.remove(url_path_list,1)
    local new_uri = tools.list_to_str(url_path_list,'/',ngx.var.uri)
    local real_url_path_list = tools.split(new_uri, '?')
    local real_uri = real_url_path_list[1]
    user_info['svc_code'] = svc_code
    user_info['real_uri'] = real_uri
    return svc_code
end
get_svc_code()

limit_req.incoming()     --限速,限制每秒请求数
auth_check.check()       --权限验证
init_log.send()          --记录日志
upstream.set()           --匹配upstream

