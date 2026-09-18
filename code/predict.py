import joblib
import pandas as pd

print("===================================")
print("       AI GPS PREDICTION")
print("===================================")

# Load trained model
model = joblib.load("model/gps_prediction_model.pkl")

# New input
speed = 45
direction = 90
latitude = 26.912
longitude = 75.787

# Create input data
new_data = pd.DataFrame([{
    "Speed_kmph": speed,
    "Direction_degree": direction,
    "Latitude": latitude,
    "Longitude": longitude
}])

# Make prediction
prediction = model.predict(new_data)[0]

print("\nNew Input:")
print("Speed:", speed, "km/h")
print("Direction:", direction, "degrees")
print("Latitude:", latitude)
print("Longitude:", longitude)

print("\nAI Prediction:")

if prediction == 1:
    print("GPS Status = 1")
    print("GPS is AVAILABLE / CONNECTED")
else:
    print("GPS Status = 0")
    print("GPS is UNAVAILABLE / DISCONNECTED")

print("\n===================================")
print("       PREDICTION COMPLETE")
print("===================================")