import pandas as pd
from sklearn.model_selection import train_test_split

# ===================================
# 1. LOAD DATASET
# ===================================

file_path = "data/ai_navigation_dataset_binary_gps.csv"

df = pd.read_csv(file_path)

print("===================================")
print("       DATA PREPROCESSING")
print("===================================")

print("\nOriginal dataset:")
print("Total records:", len(df))

# ===================================
# 2. REMOVE EMPTY ROWS
# ===================================

df = df.dropna(how="all")
df = df.dropna(subset=["Record_ID"])

print("\nAfter removing empty rows:")
print("Total records:", len(df))

# ===================================
# 3. SELECT FEATURES
# ===================================

features = [
    "Speed_kmph",
    "Direction_degree",
    "Latitude",
    "Longitude"
]

target = "GPS_Status"

X = df[features]
y = df[target]

print("\nFeatures used:")
print(features)

print("\nTarget:")
print(target)

# ===================================
# 4. TRAIN / TEST SPLIT
# ===================================

X_train, X_test, y_train, y_test = train_test_split(
    X,
    y,
    test_size=0.20,
    random_state=42,
    stratify=y
)

print("\n===================================")
print("       TRAIN / TEST SPLIT")
print("===================================")

print("Total records:", len(df))
print("Training records:", len(X_train))
print("Testing records:", len(X_test))

# ===================================
# 5. SAVE TRAINING DATA
# ===================================

train_data = X_train.copy()
train_data["GPS_Status"] = y_train.values

test_data = X_test.copy()
test_data["GPS_Status"] = y_test.values

train_data.to_csv(
    "data/train_data.csv",
    index=False
)

test_data.to_csv(
    "data/test_data.csv",
    index=False
)

print("\nTraining data saved:")
print("data/train_data.csv")

print("\nTesting data saved:")
print("data/test_data.csv")

print("\n===================================")
print("       PREPROCESSING COMPLETE")
print("===================================")