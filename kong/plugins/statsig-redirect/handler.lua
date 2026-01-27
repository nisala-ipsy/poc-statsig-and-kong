local http = require("resty.http")
local cjson = require("cjson")

local StatsigRedirectHandler = {
	VERSION = "1.0.0",
	PRIORITY = 1000,
}

function StatsigRedirectHandler:access(conf)
	local httpc = http.new()
	httpc:set_timeout(5000)

	math.randomseed(ngx.time() + ngx.worker.pid())
	local user_id = "user-" .. math.random(1000, 9999)

	local res, err = httpc:request_uri("https://api.statsig.com/v1/check_gate", {
		method = "POST",
		headers = {
			["Content-Type"] = "application/json",
			["statsig-api-key"] = conf.api_key,
		},
		body = cjson.encode({
			gateName = conf.gate_name,
			user = {
				userID = user_id,
			},
		}),
		ssl_verify = false,
	})

	if not res then
		ngx.log(ngx.ERR, "statsig request failed: ", err)
		return
	end

	local body = cjson.decode(res.body)
	local redirect_url = body.value and conf.url_true or conf.url_false

	return ngx.redirect(redirect_url, 302)
end

return StatsigRedirectHandler
