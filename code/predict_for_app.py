import joblib
import json

# Load trained model
model = joblib.load("model/gps_prediction_model.pkl")

# Example input
speed = 45
direction = 90
latitude = 26.912
longitude = 75.787

# Make prediction
prediction = model.predict([
    [speed, direction, latitude, longitude]
])[0]

# Convert prediction into app-friendly output
if prediction == 1:
    gps_status = "AVAILABLE"
else:
    gps_status = "UNAVAILABLE"

# Create output
result = {
    "speed": speed,
    "direction": direction,
    "latitude": latitude,
    "longitude": longitude,
    "gps_status": int(prediction),
    "status": gps_status
}

# Display JSON output
print(json.dumps(result, indent=4))