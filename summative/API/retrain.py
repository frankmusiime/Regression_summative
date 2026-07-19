import joblib

from linear_regression.trainer import (
    retrain_models,
    MODEL_PATH,
    SCALER_PATH,
    MODEL_NAME_PATH,
)


def retrain():
    """
    Retrains all models, reloads the newly saved artifacts,
    and returns them to the API.
    """

    # Retrain and save the best model
    results = retrain_models()

    # Reload the updated artifacts
    model = joblib.load(MODEL_PATH)
    scaler = joblib.load(SCALER_PATH)

    with open(MODEL_NAME_PATH, "r") as file:
        model_name = file.read().strip()

    return model, scaler, model_name, results
