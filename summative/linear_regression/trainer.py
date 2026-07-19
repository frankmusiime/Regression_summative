import joblib
import pandas as pd
import numpy as np

from pathlib import Path

from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler

from sklearn.linear_model import LinearRegression
from sklearn.linear_model import SGDRegressor
from sklearn.tree import DecisionTreeRegressor
from sklearn.ensemble import RandomForestRegressor

from sklearn.metrics import (
    mean_squared_error,
    mean_absolute_error,
    r2_score
)


BASE_DIR = Path(__file__).resolve().parent

DATA_PATH = BASE_DIR / "data" / "cwurData.csv"

MODEL_DIR = BASE_DIR.parent / "models"

MODEL_PATH = MODEL_DIR / "best_model.pkl"

SCALER_PATH = MODEL_DIR / "scaler.pkl"

MODEL_NAME_PATH = MODEL_DIR / "model_name.txt"


def retrain_models():
    """
    Retrains all regression models, selects the best-performing model,
    saves the model artifacts, and returns evaluation metrics.
    """

    # -----------------------------
    # Load Dataset
    # -----------------------------
    df = pd.read_csv(DATA_PATH)

    # -----------------------------
    # Handle Missing Values
    # -----------------------------
    df["broad_impact"] = df["broad_impact"].fillna(
        df["broad_impact"].median()
    )

    # -----------------------------
    # Feature Engineering
    # -----------------------------
    model_df = df.copy()

    model_df = model_df.drop(
        columns=[
            "institution",
            "country",
            "world_rank",
            "national_rank",
        ]
    )

    # -----------------------------
    # Split Features and Target
    # -----------------------------
    X = model_df.drop(columns=["score"])
    y = model_df["score"]

    X_train, X_test, y_train, y_test = train_test_split(
        X,
        y,
        test_size=0.20,
        random_state=42
    )

    # -----------------------------
    # Standardize Features
    # -----------------------------
    scaler = StandardScaler()

    X_train_scaled = scaler.fit_transform(X_train)
    X_test_scaled = scaler.transform(X_test)

    # -----------------------------
    # Train Models
    # -----------------------------
    linear_model = LinearRegression()
    linear_model.fit(X_train_scaled, y_train)

    gradient_model = SGDRegressor(
        loss="squared_error",
        learning_rate="adaptive",
        eta0=0.01,
        max_iter=2000,
        tol=1e-4,
        random_state=42,
    )
    gradient_model.fit(X_train_scaled, y_train)

    decision_tree = DecisionTreeRegressor(
        random_state=42,
        max_depth=5,
    )
    decision_tree.fit(X_train, y_train)

    random_forest = RandomForestRegressor(
        n_estimators=200,
        max_depth=8,
        random_state=42,
    )
    random_forest.fit(X_train, y_train)

    # -----------------------------
    # Predictions
    # -----------------------------
    predictions = {
        "Linear Regression": (
            linear_model,
            linear_model.predict(X_test_scaled),
        ),
        "Gradient Descent (SGD)": (
            gradient_model,
            gradient_model.predict(X_test_scaled),
        ),
        "Decision Tree": (
            decision_tree,
            decision_tree.predict(X_test),
        ),
        "Random Forest": (
            random_forest,
            random_forest.predict(X_test),
        ),
    }

    # -----------------------------
    # Evaluate Models
    # -----------------------------
    results = []

    best_model = None
    best_model_name = None
    best_metrics = None
    best_mse = float("inf")

    for name, (model, prediction) in predictions.items():

        mse = mean_squared_error(y_test, prediction)
        rmse = np.sqrt(mse)
        mae = mean_absolute_error(y_test, prediction)
        r2 = r2_score(y_test, prediction)

        results.append(
            {
                "model": name,
                "mse": float(round(mse, 4)),
                "rmse": float(round(rmse, 4)),
                "mae": float(round(mae, 4)),
                "r2": float(round(r2, 4)),
            }
        )

        if mse < best_mse:
            best_mse = mse
            best_model = model
            best_model_name = name

            best_metrics = {
                "mse": float(round(mse, 4)),
                "rmse": float(round(rmse, 4)),
                "mae": float(round(mae, 4)),
                "r2": float(round(r2, 4)),
            }

    # -----------------------------
    # Save Model Artifacts
    # -----------------------------
    joblib.dump(best_model, MODEL_PATH)
    joblib.dump(scaler, SCALER_PATH)

    with open(MODEL_NAME_PATH, "w") as file:
        file.write(best_model_name)

    # -----------------------------
    # Return Response
    # -----------------------------
    return {
        "message": "Model retrained successfully.",
        "best_model": best_model_name,
        "metrics": best_metrics,
        "results": results,
    }


# if __name__ == "__main__":
#     results = retrain_models()

# print(results)
