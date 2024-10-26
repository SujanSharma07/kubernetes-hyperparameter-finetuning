import argparse
import os

from sklearn.datasets import fetch_california_housing
from sklearn.ensemble import RandomForestRegressor
from sklearn.metrics import mean_squared_error
from sklearn.model_selection import train_test_split

# Argument parsing for hyperparameters
parser = argparse.ArgumentParser()
parser.add_argument(
    "--n_estimators", type=int, default=100, help="Number of trees in the forest"
)
parser.add_argument(
    "--max_depth", type=int, default=10, help="Maximum depth of the tree"
)
args = parser.parse_args()

# Load the dataset
data = fetch_california_housing()
X_train, X_test, y_train, y_test = train_test_split(
    data.data, data.target, test_size=0.2, random_state=42
)

# Train the RandomForest model
model = RandomForestRegressor(
    n_estimators=args.n_estimators, max_depth=args.max_depth, random_state=42
)
model.fit(X_train, y_train)

# Predict and evaluate
y_pred = model.predict(X_test)
mse = mean_squared_error(y_test, y_pred)

# Log the results to a file
result_dir = "/output"
os.makedirs(result_dir, exist_ok=True)
result_file = os.path.join(
    result_dir, f"result_{args.n_estimators}_{args.max_depth}.txt"
)

with open(result_file, "w") as f:
    f.write(
        f"Hyperparameters: n_estimators={args.n_estimators}, max_depth={args.max_depth}\n"
    )
    f.write(f"Mean Squared Error: {mse}\n")

print(f"Results written to {result_file}")