import pandas as pd
import joblib

# Load trained model
model = joblib.load("model/gps_prediction_model.pkl")

# Load tunnel dataset
df = pd.read_csv("data/test_dataset_4.csv")

# Features used by the model
features = [
    "Speed_kmph",
    "Direction_degree",
    "Latitude",
    "Longitude"
]

X = df[features]

# Actual status
actual = df["GPS_Status"]

# AI prediction
predicted = model.predict(X)

# Add prediction to dataset
df["Predicted_GPS_Status"] = predicted

# Compare actual and predicted
df["Correct"] = df["GPS_Status"] == df["Predicted_GPS_Status"]

print("==============================================")
print("       TUNNEL DATASET ANALYSIS")
print("==============================================")

print("\nTotal records:", len(df))

print("\nActual GPS Status:")
print(actual.value_counts().sort_index())

print("\nPredicted GPS Status:")
print(pd.Series(predicted).value_counts().sort_index())

print("\nCorrect predictions:", df["Correct"].sum())
print("Wrong predictions:", (~df["Correct"]).sum())

accuracy = df["Correct"].mean() * 100

print("\nAccuracy:", round(accuracy, 2), "%")

print("\nSample predictions:")
print(
    df[
        [
            "Speed_kmph",
            "Direction_degree",
            "Latitude",
            "Longitude",
            "GPS_Status",
            "Predicted_GPS_Status",
            "Correct"
        ]
    ].head(20)
)

# Save detailed analysis
df.to_csv(
    "result/tunnel_dataset_analysis.csv",
    index=False
)

print("\nDetailed result saved:")
print("result/tunnel_dataset_analysis.csv")

print("\n==============================================")
print("       ANALYSIS COMPLETE")
print("==============================================")
