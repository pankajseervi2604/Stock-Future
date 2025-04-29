import pandas as pd
from sklearn.linear_model import LinearRegression
from sklearn.model_selection import train_test_split
from fastapi import FastAPI, HTTPException, Query
from pydantic import BaseModel
from typing import List
import uvicorn
import os

app = FastAPI()

# Response schema for each prediction
class SinglePrediction(BaseModel):
    date: str
    price: float

# Response schema for the full response
class PredictionResponse(BaseModel):
    historical: List[SinglePrediction]
    prediction: List[SinglePrediction]

@app.get("/predict_week", response_model=PredictionResponse)
async def predict_week(stock: str = Query(..., description="Stock name like TCS")):
    path = f"dataset/stockData/{stock.upper()}.csv"

    if not os.path.exists(path):
        raise HTTPException(status_code=404, detail=f"CSV not found for stock: {stock}")

    data = pd.read_csv(path)
    data['Date'] = pd.to_datetime(data['Date'])
    data['Date_ordinal'] = data['Date'].map(pd.Timestamp.toordinal)

    X = data[['Date_ordinal']]
    y = data['Close']

    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
    model = LinearRegression()
    model.fit(X_train, y_train)

    # Generate predictions for the next 7 days
    predictions = []
    last_date = data['Date'].max()

    for i in range(1, 8):  # Next 7 days
        next_date = last_date + pd.Timedelta(days=i)
        next_date_ordinal = next_date.toordinal()
        predicted_price = model.predict([[next_date_ordinal]])[0]

        predictions.append(
            SinglePrediction(
                date=str(next_date.date()),
                price=round(predicted_price, 2)
            )
        )

    # Get historical data (e.g., last 30 days for context)
    historical_data = [
        SinglePrediction(date=str(data['Date'].iloc[i].date()), price=round(data['Close'].iloc[i], 2))
        for i in range(-30, 0)
    ]

    return PredictionResponse(historical=historical_data, prediction=predictions)

if __name__ == "__main__":
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
