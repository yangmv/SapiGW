local tools = require "tools"
-- local host = ngx.var.http_host
local host = gw_domain_name
local uri = ngx.var.uri
local user_info = ngx.shared.user_info

local _M = {}
function _M.set(real_new_uri)
	local svc_code = user_info.svc_code
	local default_upstream = 'None'
	if rewrite_conf[host] ~= nil then
		local data = {}
		local key_data = {}
		for i, elem in ipairs(rewrite_conf[host]['rewrite_urls']) do
			--local ret = tools.match(uri,elem['uri'])
			--if ret then
			local ret = tools.match('/'..svc_code,elem['uri'])
			if '/'..svc_code == elem['uri'] then
				data [string.len(elem['uri'])] = elem['rewrite_upstream']
			end
		end

		if next(data) ~= nil then
			for k,v in pairs(data) do
				--ngx.log(ngx.ERR, "k---->"..k,v)
				table.insert(key_data,k)
			end
			table.sort(key_data)	--排序
			local new_key = key_data[#key_data]	--取最后一个key
			default_upstream = data[new_key]
			ngx.log(ngx.ERR, "default_upstream----> "..default_upstream)
		end
	end
	if default_upstream ~= "None" then
		ngx.var.my_upstream = default_upstream
	 	local real_uri = user_info.real_uri
		-- ngx.log(ngx.ERR,'real_uri-------->',real_uri)
		ngx.req.set_uri(real_uri, false)
	else
		return ngx.exit(404)
	end

end
return _M