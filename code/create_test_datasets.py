import pandas as pd
import numpy as np
import os

# Create data folder if it does not exist
os.makedirs("data", exist_ok=True)

np.random.seed(42)

# Function to create a dataset
def create_dataset(filename, min_speed, max_speed, gps_status):

    records = 100

    data = {
        "Speed_kmph": np.random.randint(min_speed, max_speed + 1, records),
        "Direction_degree": np.random.randint(0, 361, records),
        "Latitude": np.random.uniform(26.85, 26.95, records),
        "Longitude": np.random.uniform(75.70, 75.85, records),
        "GPS_Status": gps_status,
        "Timestamp": pd.date_range(
            start="2026-09-18 10:00:00",
            periods=records,
            freq="min"
        )
    }

    df = pd.DataFrame(data)

    df.to_csv(f"data/{filename}", index=False)

    print(f"{filename} created successfully")


# Dataset 1 - Normal navigation
create_dataset(
    "test_dataset_1.csv",
    30, 60,
    1
)

# Dataset 2 - Low speed
create_dataset(
    "test_dataset_2.csv",
    5, 25,
    1
)

# Dataset 3 - High speed
create_dataset(
    "test_dataset_3.csv",
    70, 120,
    1
)

# Dataset 4 - Tunnel condition
# Mixed GPS conditions inside and around tunnel

records = 100

tunnel_data = {
    "Speed_kmph": np.random.randint(20, 51, records),
    "Direction_degree": np.random.randint(0, 361, records),
    "Latitude": np.random.uniform(26.85, 26.95, records),
    "Longitude": np.random.uniform(75.70, 75.85, records),
    "GPS_Status": np.random.choice([0, 1], records),
    "Timestamp": pd.date_range(
        start="2026-09-18 14:00:00",
        periods=records,
        freq="min"
    )
}

tunnel_df = pd.DataFrame(tunnel_data)

tunnel_df.to_csv(
    "data/test_dataset_4.csv",
    index=False
)

print("test_dataset_4.csv created successfully")

# Dataset 5 - Mixed navigation
create_dataset(
    "test_dataset_5.csv",
    10, 100,
    1
)

print()
print("====================================")
print("ALL TEST DATASETS CREATED")
print("====================================")