module("my_verify", package.seeall)
--local mysql = require('mysql')
local my_cache = require ("redis")
local http = require "resty.http"

-- 对接权限系统的redis
function get_verify(user_id,uri,method)
    my_verify = my_cache.smembers(user_id..method)
    all_verify = my_cache.smembers(user_id..'ALL')

    for k,v in ipairs(my_verify) do
        -- ngx.log(ngx.ERR,'uri----->',uri)
        -- ngx.log(ngx.ERR,'line----->',v)
        local is_exit = string.find(uri,"^"..v)
        if is_exit == 1 then
            return true
        end
    end

    for k,v in ipairs(all_verify) do
        --ngx.log(ngx.ERR,'line----->',v)
        local is_exit = string.find(uri,"^"..v)
        if is_exit == 1 then
            return true
        end
    end
    return false
end

function write_verify(user_id)
    local httpc = http.new()
    local res, err = httpc:request_uri(
        rewrite_cache_url,
        {
            method = "POST",
            body = json.encode({
                user_id=user_id,
                secret_key=rewrite_cache_token
            }),
            headers = {
                ["Content-Type"] = "application/json"
            }
        }
    )
--    if not res then
--        ngx.say("failed to request: ", err)
--        return
--    end
--    if 200 ~= res.status then
--        ngx.exit(res.status)
--    end
end

--local permissions = get_permission(28,'/home1')
--ngx.say(json.encode(permissions))





