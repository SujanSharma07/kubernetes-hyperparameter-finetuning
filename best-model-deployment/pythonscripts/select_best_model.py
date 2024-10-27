import os
import shutil

# Directory where models and accuracy files are stored
model_dir = "/models"
best_model_path = os.path.join(model_dir, "best_model.pkl")

best_accuracy = 0
best_model = None

for filename in os.listdir(model_dir):
    if filename.endswith("_accuracy.txt"):
        accuracy_file = os.path.join(model_dir, filename)
        model_file = accuracy_file.replace("_accuracy.txt", ".pkl")

        # Read the accuracy from the text file
        with open(accuracy_file, "r") as f:
            accuracy = float(f.read().strip())

        # Check if this is the best accuracy so far
        if accuracy > best_accuracy:
            best_accuracy = accuracy
            best_model = model_file

if best_model:
    print(f"The best model is {best_model} with an accuracy of {best_accuracy}")

    # Copy the best model to the desired location
    shutil.copy(best_model, best_model_path)
    print(f"Best model saved to {best_model_path}")
else:
    print("No models found.")
