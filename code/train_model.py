import pandas as pd
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score, classification_report
import joblib

print("===================================")
print("       AI MODEL TRAINING")
print("===================================")

train_data = pd.read_csv("data/train_data.csv")
test_data = pd.read_csv("data/test_data.csv")

features = [
    "Speed_kmph",
    "Direction_degree",
    "Latitude",
    "Longitude"
]

X_train = train_data[features]
y_train = train_data["GPS_Status"]

X_test = test_data[features]
y_test = test_data["GPS_Status"]

print("\nTraining records:", len(X_train))
print("Testing records:", len(X_test))

model = RandomForestClassifier(
    n_estimators=100,
    random_state=42
)

print("\nTraining AI model...")
model.fit(X_train, y_train)

print("Model training completed!")

y_pred = model.predict(X_test)

accuracy = accuracy_score(y_test, y_pred)

print("\n===================================")
print("          MODEL RESULT")
print("===================================")

print("Accuracy:", round(accuracy * 100, 2), "%")

print("\nClassification Report:")
print(classification_report(y_test, y_pred))

joblib.dump(model, "model/gps_prediction_model.pkl")

print("\nModel saved successfully!")
print("Location: model/gps_prediction_model.pkl")

print("\n===================================")
print("       TRAINING COMPLETE")
print("===================================")