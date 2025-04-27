# requirements
import pandas as pd
from sklearn.linear_model import LinearRegression
from sklearn.model_selection import train_test_split
from fastapi import FastAPI
from pydantic import BaseModel
import uvicorn

# loading csv file
data = pd.read_csv('dataset/stockData/GAIL.csv')

data['Date'] = pd.to_datetime(data['Date'])
data['Date_ordinal'] = data['Date'].map(pd.Timestamp.toordinal)

X = data[['Date_ordinal']]
y = data['Close']

# Train/Test Split (optional)
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Train the model
model = LinearRegression()
model.fit(X_train, y_train)

# Step 2: Create FastAPI app
app = FastAPI()

# Define response schema
class SinglePrediction(BaseModel):
    date: str
    price: float

# Multiple predictions
from typing import List

@app.get("/predict_week", response_model=List[SinglePrediction])
async def predict_week():
    predictions = []
    
    # Start from last known date
    last_date = data['Date'].max()
    for i in range(1, 8):  # Predict next 7 days
        next_date = last_date + pd.Timedelta(days=i)
        next_date_ordinal = next_date.toordinal()

        predicted_price = model.predict([[next_date_ordinal]])[0]

        predictions.append(
            SinglePrediction(
                date=str(next_date.date()),
                price=round(predicted_price, 2)
            )
        )
    
    return predictions

# Run the app
if __name__ == "__main__":
    uvicorn.run("backend:app", host="0.0.0.0", port=8000, reload=True)
