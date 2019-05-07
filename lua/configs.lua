json = require("cjson")

--mysql_config = {
--    host = "127.0.0.1",
--    port = 3306,
--    database = "lua",
--    user = "root",
--    password = "",
--    max_packet_size = 1024 * 1024
--}

redis_config = {
	host = '172.16.0.121',
    port = 6379,
    auth_pwd = '',
    db = 4,
    alive_time =  3600 * 24 * 7,
	channel = 'gw'
}

--mq_conf = {
--	host = '172.16.0.121',
--	port = 5672,
--	username = 'sz',
--	password = '123456',
--	vhost = '/'
--}

logs_file = '/var/log/gw.log'

--JWT令牌密钥,需和服务端的key一致
token_secret = "pXy5Fb4i%*83AIiOq18iodGq4ODQyMzc4lz7yI6ImF1dG"

--刷新权限到redis接口
rewrite_cache_url = 'http://mg.opendevops.cn:8888/v1/mg/renew_verify/'
rewrite_cache_token = '8b888a62-3edb-4920-b446-697a472b4001'

--并发限流配置
limit_conf = {
    rate = 5,        --限制ip每分钟只能调用n*60次接口
    burst = 10, 	 --桶容量,用于平滑处理,最大接收请求次数
}

--upstream匹配规则
gw_domain_name = 'gw.opendevops.cn'

--upstream匹配规则
rewrite_conf = {
	[gw_domain_name] = {
        rewrite_urls = {
            {
                uri = "/cmdb",
                rewrite_upstream = "cmdb.opendevops.cn:8002"
            },
            {
                uri = "/k8s",
                rewrite_upstream = "k8s.opendevops.cn:8001"
            },
            {
                uri = "/cron",
                rewrite_upstream = "cron.opendevops.cn:5001"
            },
            {
                uri = "/mg",
                rewrite_upstream = "mg.opendevops.cn:8888"
            },
            {
                uri = "/account",
                rewrite_upstream = "mg.opendevops.cn:8888"
            }
        }
    }
}

--白名单[跳过认证]
white_list = {
    'account',
--    'nginx-logo.png',
--    'poweredby.png'
}
