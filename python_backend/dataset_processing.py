import kagglehub
import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression
from sklearn.preprocessing import StandardScaler
import yfinance as yf

# Download the dataset
path = 'python_backend/dataset/stockData/ADANIPORTS.csv'
df = pd.read_csv(path)

# Preprocess the data
df['Date'] = pd.to_datetime(df['Date'])
df.set_index('Date', inplace=True)
df['Target'] = df['Close'].shift(-1)  # Predicting the next day's closing price

# Features and target variable
X = df[['Open', 'High', 'Low', 'Volume']]
y = df['Target'].dropna()

# Align X with y
X = X[:-1]

# Train-test split
X_train, X_valid, y_train, y_valid = train_test_split(X, y, test_size=0.1, random_state=42)

# Scale the features
scaler = StandardScaler()
X_train = scaler.fit_transform(X_train)
X_valid = scaler.transform(X_valid)

# Train the model
model = LinearRegression()
model.fit(X_train, y_train)

# Make predictions
predictions = model.predict(X_valid)

# Save the model and scaler for API use
import joblib
joblib.dump(model, 'stock_price_model.pkl')
joblib.dump(scaler, 'scaler.pkl')