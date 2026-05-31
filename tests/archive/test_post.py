import requests
import json

url = "http://localhost:8000/api/v1/telemetry"
headers = {"X-API-Key": "test-secret-key-for-local-development-12345", "Content-Type": "application/json"}
payload = {
    "sensor_id": "test_sensor_001",
    "timestamp": "2026-04-20T20:00:00Z",
    "energy_source": "solar",
    "power_generated_mwh": 10.5,
    "ghg_emissions_kgCO2_per_kgH2": 2.5,
    "water_consumption_liters": 12.0,
    "water_source": "recycled"
}
try:
    response = requests.post(url, headers=headers, json=payload)
    print("Status Code:", response.status_code)
    try:
        print("Response:", json.dumps(response.json(), indent=2))
    except Exception:
        print("Response text:", response.text)
except Exception as e:
    print("Error:", str(e))
