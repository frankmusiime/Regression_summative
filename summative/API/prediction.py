from pathlib import Path

import joblib
import pandas as pd

from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field

from API.retrain import retrain


app = FastAPI(
    title="University Performance Prediction API",
    description="Predict university performance scores using Machine Learning",
    version="1.0.0"
)

# CORS Configuration

origins = [
    "http://localhost:3000",
    "http://localhost:8080",
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["GET", "POST"],
    allow_headers=["Content-Type", "Authorization"],
)

# Model Paths


BASE_DIR = Path(__file__).resolve().parent.parent

MODEL_DIR = BASE_DIR / "models"

MODEL_PATH = MODEL_DIR / "best_model.pkl"
SCALER_PATH = MODEL_DIR / "scaler.pkl"
MODEL_NAME_PATH = MODEL_DIR / "model_name.txt"


# Load Saved Artifacts


def load_artifacts():
    """
    Loads the saved model, scaler and model name.
    """

    model = joblib.load(MODEL_PATH)

    scaler = joblib.load(SCALER_PATH)

    with open(MODEL_NAME_PATH, "r") as file:
        model_name = file.read().strip()

    return model, scaler, model_name


model, scaler, model_name = load_artifacts()


# Input Validation


class UniversityInput(BaseModel):

    quality_of_education: float = Field(
        ...,
        ge=0,
        le=100
    )

    alumni_employment: float = Field(
        ...,
        ge=0,
        le=100
    )

    quality_of_faculty: float = Field(
        ...,
        ge=0,
        le=100
    )

    publications: float = Field(
        ...,
        ge=0
    )

    influence: float = Field(
        ...,
        ge=0
    )

    citations: float = Field(
        ...,
        ge=0
    )

    broad_impact: float = Field(
        ...,
        ge=0
    )

    patents: float = Field(
        ...,
        ge=0
    )

    year: int = Field(
        ...,
        ge=2000,
        le=2030
    )


# Helper Function


def create_input_dataframe(data: UniversityInput):

    return pd.DataFrame([{
        "quality_of_education": data.quality_of_education,
        "alumni_employment": data.alumni_employment,
        "quality_of_faculty": data.quality_of_faculty,
        "publications": data.publications,
        "influence": data.influence,
        "citations": data.citations,
        "broad_impact": data.broad_impact,
        "patents": data.patents,
        "year": data.year
    }])


# Home Endpoint


@app.get("/model-info")
def model_info():
    return {
        "model": model_name,
        "prediction_target": "University Performance Score",
        "features": [
            "quality_of_education",
            "alumni_employment",
            "quality_of_faculty",
            "publications",
            "influence",
            "citations",
            "broad_impact",
            "patents",
            "year"
        ]
    }


@app.get("/model-features")
def get_features():
    return {
        "target": "score",
        "features": [
            "quality_of_education",
            "alumni_employment",
            "quality_of_faculty",
            "publications",
            "influence",
            "citations",
            "broad_impact",
            "patents",
            "year"
        ]
    }


# Prediction Endpoint


@app.post("/predict")
def predict(data: UniversityInput):

    try:

        input_data = create_input_dataframe(data)

        # Scale only for linear models

        if model_name in [
            "Linear Regression",
            "Gradient Descent (SGD)"
        ]:
            input_data = scaler.transform(input_data)

        prediction = model.predict(input_data)

        return {
            "model_used": model_name,
            "predicted_score": round(float(prediction[0]), 2)
        }

    except Exception as e:

        raise HTTPException(
            status_code=500,
            detail=str(e)
        )


# Retraining Endpoint

@app.post("/retrain")
def retrain_endpoint():

    global model
    global scaler
    global model_name

    model, scaler, model_name, results = retrain()

    return {
        "message": "Model retrained successfully.",
        "best_model": model_name,
        "training_results": results
    }
