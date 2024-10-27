# serve_model.py
import pickle

from flask import Flask, jsonify, request

app = Flask(__name__)

# Load the best model from the persistent volume
model_path = "/models/best_model.pkl"
with open(model_path, "rb") as model_file:
    model = pickle.load(model_file)


@app.route("/predict", methods=["POST"])
def predict():
    data = request.json()
    features = data.get("features")

    if features is None:
        return jsonify({"error": "No features provided"}), 400

    # Perform prediction
    prediction = model.predict([features])
    return jsonify({"prediction": prediction[0]})


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
