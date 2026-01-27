local http = require("resty.http")
local pretty = require("pl.pretty")
local cjson = require("cjson")

local M = {}

local API_KEY = ""

math.randomseed(os.time())
local userID = "user-" .. math.random(1000, 9999)

local client = http.new()
client:set_timeout(5000)

function M.statsig_request(url, payload, label)
	print("\n" .. label .. "\n")

	local res, err = client:request_uri(url, {
		method = "POST",
		headers = {
			["Content-Type"] = "application/json",
			["statsig-api-key"] = API_KEY,
		},
		body = cjson.encode(payload),
		ssl_verify = false,
	})

	if not res then
		print("request failed: " .. err)
		return nil
	end

	local body = cjson.decode(res.body)
	print("status: " .. res.status)
	print("body: " .. pretty.write(body))
	return body
end

----------------------------------------------------------------------
--                           FEATURE GATE                           --
----------------------------------------------------------------------
M.statsig_request("https://api.statsig.com/v1/check_gate", {
	gateName = "nisala_test_feature_gate",
	user = {
		userID = userID,
		email = "user@example.com",
	},
}, "Feature Gate")

----------------------------------------------------------------------
--                           GET EXPERIMENT                         --
----------------------------------------------------------------------
M.statsig_request("https://api.statsig.com/v1/get_config", {
	configName = "nisala_new_button_experiment",
	user = {
		userID = userID,
	},
}, "Get Experiment")

----------------------------------------------------------------------
--                           GET CONFIG                            --
----------------------------------------------------------------------
M.statsig_request("https://api.statsig.com/v1/get_config", {
	configName = "nisala_test_dynamic_config",
	user = {
		userID = userID,
	},
}, "Get Config")

----------------------------------------------------------------------
--                           LOG EVENT                             --
----------------------------------------------------------------------
M.statsig_request("https://events.statsigapi.net/v1/log_event", {
	events = {
		{
			eventName = "add_to_cart",
			value = 29.99,
			time = os.time() * 1000,
			user = {
				userID = userID,
			},
			metadata = {
				product_id = "prod_456",
				category = "electronics",
			},
		},
	},
}, "Log Event")

----------------------------------------------------------------------
--                           GET LAYER                             --
----------------------------------------------------------------------
M.statsig_request("https://api.statsig.com/v1/get_layer", {
	layerName = "nisala-test-layer-for-us-customers",
	user = {
		userID = userID,
	},
}, "Get Layer")
