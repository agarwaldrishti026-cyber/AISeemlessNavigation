import pandas as pd

# Load training and testing data
train_data = pd.read_csv("data/train_data.csv")
test_data = pd.read_csv("data/test_data.csv")

print("==============================================")
print("        DATA BALANCE CHECK")
print("==============================================")

print("\nTRAINING DATA")
print("----------------------------------------------")

print("Total records:", len(train_data))

print("\nGPS Status distribution:")

train_counts = train_data["GPS_Status"].value_counts().sort_index()

print(train_counts)

print("\nPercentage:")

print(
    (train_data["GPS_Status"].value_counts(normalize=True)
     .sort_index() * 100).round(2)
)

print("\n\nTESTING DATA")
print("----------------------------------------------")

print("Total records:", len(test_data))

print("\nGPS Status distribution:")

test_counts = test_data["GPS_Status"].value_counts().sort_index()

print(test_counts)

print("\nPercentage:")

print(
    (test_data["GPS_Status"].value_counts(normalize=True)
     .sort_index() * 100).round(2)
)

print("\n==============================================")
print("        DATA BALANCE CHECK COMPLETE")
print("==============================================")