# Statsig Kong Gateway

Kong Gateway integration with Statsig feature gates for dynamic redirects.

## Prerequisites

- Docker
- Statsig API key

## Setup

1. Add your Statsig API key to `kong.yml`:

```yaml
api_key: "your-api-key-here"
```

2. Add your Statsig API key to `init.lua`:

```lua
local API_KEY = "your-api-key-here"
```

## Running the Project

### Option 1: Run init.lua (Test Statsig API)

```bash
bash run.sh
```

This runs the init.lua script to test Statsig API requests directly.

### Option 2: Run Kong Gateway (Full Setup)

```bash
docker-compose up
```

Kong Gateway will start on port 8000 with the statsig-redirect plugin enabled.

## Testing in Browser

2. Open browser and navigate to:

```
http://localhost:8000/
```

3. **Expected Behavior:**
   - If feature gate `nisala_test_feature_gate` is **enabled**: redirects to `https://google.com`
   - If feature gate `nisala_test_feature_gate` is **disabled**: redirects to `https://youtube.com`

4. Each request generates a random user ID, so refresh multiple times to test different users

5. Check Kong logs to see Statsig API calls:

```bash
docker-compose logs -f kong
```

## Configuration

Edit `kong.yml` to customize:

- `gate_name`: Statsig feature gate name
- `url_true`: Redirect URL when gate is enabled
- `url_false`: Redirect URL when gate is disabled
