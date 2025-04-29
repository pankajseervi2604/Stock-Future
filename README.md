# 📈 Stock Future

**Stock Future** is a Flutter-based mobile application that predicts stock trends for the upcoming week. It uses a FastAPI backend to fetch and serve historical stock data and predictions. The app visualizes both past and future data in easy-to-read charts.

---

## ✨ Features

- 📊 **Stock Prediction for 7 Days**
- 🔄 **Historical Stock Data Viewer**
- 📈 **Interactive Charts for Visualization**
- 🚀 **REST API Integration via FastAPI**

---

## 🎥 Preview

![Stock Future Demo](https://github.com/pankajseervi2604/Stock-Future/blob/main/assets/stock%20future%20demo.gif?raw=true)


---

## 🧠 Backend Setup (FastAPI)

Ensure Python and `uvicorn` are installed on your system.

### 1. Install Dependencies
Navigate to your backend directory and install the required packages (FastAPI, uvicorn, etc.).

cmd ==> `pip install fastapi uvicorn pandas scikit-learn`

### 2. Start the FastAPI Server
cmd ==> `uvicorn backend:app --reload --host 0.0.0.0 --port 8000`

⚠️ Adjust the path (backend:app) depending on your project structure.

## 📱 Frontend Setup (Flutter)
1. Install Flutter
Make sure Flutter is installed. If not, follow the Flutter installation guide.

2. Clone the Repository
cmd ==> `git clone https://github.com/yourusername/stock_future.git
cd stock_future`

3. Get Flutter Packages
cmd ==> `flutter pub get`

4. Run the App
Make sure your emulator or device is running, then:
cmd ==> `flutter run`

📡 Ensure the backend server is running before launching the Flutter app.

## 🔌 API Integration
The Flutter app fetches stock data from:

cmd ==> `http://<your-ip>:8000/predict?stock=XY`

You can set this IP dynamically or use localhost when testing on an emulator.

## 📄 License
This project is licensed under the MIT License. See the LICENSE file for more info.

Let me know if you'd like this generated in a file or want a template Flutter/FastAPI project to go along with it.






