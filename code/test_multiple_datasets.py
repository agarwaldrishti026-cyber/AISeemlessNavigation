import pandas as pd
import joblib
import os
from sklearn.metrics import accuracy_score, confusion_matrix

# Load trained AI model
model = joblib.load("model/gps_prediction_model.pkl")

# List of testing datasets
datasets = [
    "test_dataset_1.csv",
    "test_dataset_2.csv",
    "test_dataset_3.csv",
    "test_dataset_4.csv",
    "test_dataset_5.csv"
]

print("==============================================")
print("       MULTIPLE DATASET AI TESTING")
print("==============================================")

results = []

for file in datasets:

    path = f"data/{file}"

    # Read dataset
    df = pd.read_csv(path)

    # Features used by the trained model
    X = df[
        [
            "Speed_kmph",
            "Direction_degree",
            "Latitude",
            "Longitude"
        ]
    ]

    # Actual GPS status
    y_actual = df["GPS_Status"]

    # AI prediction
    y_predicted = model.predict(X)

    # Calculate accuracy
    accuracy = accuracy_score(y_actual, y_predicted)

    # Count correct and wrong predictions
    correct = (y_actual == y_predicted).sum()
    wrong = (y_actual != y_predicted).sum()

    print()
    print("----------------------------------------------")
    print(f"Dataset: {file}")
    print(f"Total Records: {len(df)}")
    print(f"Correct Predictions: {correct}")
    print(f"Wrong Predictions: {wrong}")
    print(f"Accuracy: {accuracy * 100:.2f}%")

    if accuracy >= 0.90:
        print("Status: PASS")
    else:
        print("Status: CHECK")

    results.append({
        "Dataset": file,
        "Records": len(df),
        "Correct": correct,
        "Wrong": wrong,
        "Accuracy": accuracy * 100
    })


# Create result folder
os.makedirs("result", exist_ok=True)

# Save results
result_df = pd.DataFrame(results)

result_df.to_csv(
    "result/multiple_dataset_results.csv",
    index=False
)

# Save readable text result
with open("result/multiple_dataset_results.txt", "w") as file:

    file.write("MULTIPLE DATASET AI TESTING RESULTS\n")
    file.write("====================================\n\n")

    for result in results:

        file.write(f"Dataset: {result['Dataset']}\n")
        file.write(f"Records: {result['Records']}\n")
        file.write(f"Correct Predictions: {result['Correct']}\n")
        file.write(f"Wrong Predictions: {result['Wrong']}\n")
        file.write(f"Accuracy: {result['Accuracy']:.2f}%\n")

        if result["Accuracy"] >= 90:
            file.write("Status: PASS\n")
        else:
            file.write("Status: CHECK\n")

        file.write("------------------------------------\n")


print()
print("==============================================")
print("       TESTING COMPLETED")
print("==============================================")

print()
print("Results saved:")
print("result/multiple_dataset_results.csv")
print("result/multiple_dataset_results.txt")