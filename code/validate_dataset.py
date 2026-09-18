import pandas as pd

# CSV file load karna
file_path = "data/ai_navigation_dataset_binary_gps.csv"

df = pd.read_csv(file_path)
# Remove completely empty rows
df = df.dropna(how="all")

# Remove rows where Record_ID is missing
df = df.dropna(subset=["Record_ID"])

# Reset row numbering
df = df.reset_index(drop=True)

print("===================================")
print("       DATASET VALIDATION")
print("===================================")

# 1. SPEED CHECK
invalid_speed = df[
    (df["Speed_kmph"] < 0) |
    (df["Speed_kmph"] > 150)
]

print("\n1. SPEED CHECK")
print("Invalid speed records:", len(invalid_speed))

if len(invalid_speed) == 0:
    print("PASS - All speed values are valid.")
else:
    print("CHECK NEEDED - Some speed values are invalid.")

# 2. DIRECTION CHECK
invalid_direction = df[
    (df["Direction_degree"] < 0) |
    (df["Direction_degree"] > 360)
]

print("\n2. DIRECTION CHECK")
print("Invalid direction records:", len(invalid_direction))

if len(invalid_direction) == 0:
    print("PASS - All direction values are valid.")
else:
    print("CHECK NEEDED - Some direction values are invalid.")

# 3. LATITUDE CHECK
invalid_latitude = df[
    (df["Latitude"] < -90) |
    (df["Latitude"] > 90)
]

print("\n3. LATITUDE CHECK")
print("Invalid latitude records:", len(invalid_latitude))

if len(invalid_latitude) == 0:
    print("PASS - All latitude values are valid.")
else:
    print("CHECK NEEDED - Some latitude values are invalid.")

# 4. LONGITUDE CHECK
invalid_longitude = df[
    (df["Longitude"] < -180) |
    (df["Longitude"] > 180)
]

print("\n4. LONGITUDE CHECK")
print("Invalid longitude records:", len(invalid_longitude))

if len(invalid_longitude) == 0:
    print("PASS - All longitude values are valid.")
else:
    print("CHECK NEEDED - Some longitude values are invalid.")

# 5. GPS STATUS CHECK
expected_gps = {
    "Outside": 1,
    "Entering": 1,
    "Inside": 0,
    "Exiting": 1
}

df["Expected_GPS_Status"] = df["Tunnel_Status"].map(expected_gps)
# Fill missing GPS status according to tunnel status
df["GPS_Status"] = df["GPS_Status"].fillna(
    df["Tunnel_Status"].map(expected_gps)
)

invalid_gps = df[
    df["GPS_Status"] != df["Expected_GPS_Status"]
]

print("\n5. GPS STATUS CHECK")
print("Invalid GPS records:", len(invalid_gps))

if len(invalid_gps) == 0:
    print("PASS - GPS status matches tunnel status.")
else:
    print("CHECK NEEDED - Some GPS values do not match.")

# FINAL SUMMARY
print("\n===================================")
print("           FINAL SUMMARY")
print("===================================")

print("Total records:", len(df))
print("GPS values:", sorted(df["GPS_Status"].unique()))

if (
    len(invalid_speed) == 0
    and len(invalid_direction) == 0
    and len(invalid_latitude) == 0
    and len(invalid_longitude) == 0
    and len(invalid_gps) == 0
):
    print("\nALL CHECKS PASSED!")
    print("Dataset is ready for the next step.")
else:
    print("\nSome need correction.")