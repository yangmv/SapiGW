json = require("cjson")

-- 缓存配置
redis_config = {
	host = '10.211.55.4',
    port = 6379,
    auth_pwd = '',
    db = 4,
    alive_time =  3600 * 24 * 7,
	channel = 'gw'
}

-- 全局配置
gw_domain_name = 'gw.yangmv.com'               --此网关域名
logs_file = '/var/log/gw_access_get.log'       --访问日志[GET]

-- 鉴权接口配置 【SuperMG】
auth_api = 'http://mg.yangmv.com:8888'                          -- [权限系统]地址
token_secret = "pXy5Fb4i%*83AIiOq18iodGq4ODQyMzc4lz7yI6ImF1dG"  -- JWT令牌密钥,需和[权限系统] 服务端的key一致
rewrite_cache_token = '8b888a62-3edb-4920-b446-697a472b4001'    -- 刷新redis权限接口的token,需和[权限系统]服务端的key一致
auth_check_uri = '/v1/mg/auth_check/'                           -- 权限认证接口
rewrite_cache_uri = '/v1/mg/renew_verify/'                      -- 刷新权限到redis接口

-- 并发限流配置
limit_conf = {
    rate = 5,        --限制ip每分钟只能调用n*60次接口
    burst = 10, 	 --桶容量,用于平滑处理,最大接收请求次数
}

-- upstream匹配规则
rewrite_conf = {
	[gw_domain_name] = {
        rewrite_urls = {
            {
                uri = "/account",
                rewrite_upstream = "mg.yangmv.com:8888"
            },
            {
                uri = "/mg",
                rewrite_upstream = "mg.yangmv.com:8888"
            },
            {
                uri = "/cron",
                rewrite_upstream = "cron.yangmv.cn:5001"
            },
            {
                uri = "/cmdb",
                rewrite_upstream = "cmdb.opendevops.cn:8002"
            },
            {
                uri = "/k8s",
                rewrite_upstream = "k8s.opendevops.cn:8001"
            }
        }
    }
}

-- 白名单[跳过认证]
white_list = {
    'account',
}
