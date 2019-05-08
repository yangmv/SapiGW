module("my_verify", package.seeall)
--local mysql = require('mysql')
local my_cache = require ("redis")
local http = require "resty.http"

-- 对接权限系统的redis【改用 get_verify】
function get_verify_redis(user_id,uri,method)
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

-- 对接权限系统鉴权
function get_verify(user_id,uri,method)
    local httpc = http.new()
    local res, err = httpc:request_uri(
        -- rewrite_cache_url,
        auth_api..auth_check_uri,
        {
            method = "POST",
            body = json.encode({
                user_id=user_id,
                method=method,
                uri=uri
            }),
            headers = {
                ["Content-Type"] = "application/json"
            }
        }
    )
    if res.status == 200 then
        ret = json.decode(res.body)
        if ret.status == 0 then
            return true
        end
    end
    return false
end

function write_verify(user_id)
    local httpc = http.new()
    local res, err = httpc:request_uri(
        -- rewrite_cache_url,
        auth_api..rewrite_cache_uri,
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
end

--local permissions = get_permission(28,'/home1')
--ngx.say(json.encode(permissions))





