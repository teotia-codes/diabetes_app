# 🧠 Diabetes App  
### AI-Powered Type 1 Diabetes Risk Prediction & Clinical Insight System

> A clinical decision support system (CDSS) that predicts short-term diabetes progression risk and provides explainable AI insights through a mobile dashboard.

---

## 🚀 Project Overview

WellDoc AI is an end-to-end healthcare intelligence system designed to:

- Predict 90-day diabetes progression risk
- Analyze glucose trends
- Generate AI-based medical insights
- Provide clinical alerts & recommendations
- Deliver results through a real-time mobile dashboard

This project combines:

- 🧪 Machine Learning
- 📊 Clinical Feature Engineering
- 🔎 Explainable AI
- ⚡ FastAPI Backend
- 📱 Flutter Mobile Frontend

---

## 🏗 System Architecture
Patient Dataset (CGM + Clinical Features)
│
▼
ML Model (Calibrated)
│
▼
FastAPI Backend
├── Risk Prediction API
├── Trend Simulation API
├── Explainability API
└── SHAP Visualization API
│
▼
Flutter Mobile App
├── Overview Dashboard
├── Patient Risk List
├── AI Insight Screen
└── Glucose Trend Graph

---

## 🧬 Machine Learning Model

- Binary classification (90-day progression risk)
- Calibrated probability output

### Risk Levels

| Risk Score | Level |
|-----------|------|
| ≥ 0.6 | 🟥 High |
| 0.3 – 0.6 | 🟧 Medium |
| < 0.3 | 🟩 Low |

### Features Used

- Mean glucose (30-day rolling)
- Time in range (70–180 mg/dL)
- Hyperglycemia frequency
- Historical HbA1c
- Derived temporal features

---

## 🧠 Explainable AI

Each patient includes:

- 📌 Risk score
- 🚨 Clinical alerts
- 🧠 AI interpretation summary
- ✅ Recommended actions
- 📊 SHAP-based feature explanation

This ensures **model transparency and clinical trust**.

---

## 📱 Mobile Dashboard (Flutter)

### 1️⃣ Overview Screen
- Total patients
- Median risk
- High-risk count

### 2️⃣ Patients Screen
- Scrollable risk list
- Color-coded severity badges
- Patient selection system

### 3️⃣ Insight Screen
- Risk severity card
- 📈 30-day glucose trend chart
- Safe glucose band visualization (70–180 mg/dL)
- Alerts & recommendations
- AI reasoning

---

## 📡 Backend API Endpoints

| Endpoint | Description |
|----------|------------|
| `/overview` | Population risk summary |
| `/patients` | Latest patient risk list |
| `/patient/{id}` | Patient risk detail |
| `/patient/{id}/trend` | 30-day glucose trend |
| `/patient/{id}/explain` | AI explanation |
| `/patient/{id}/insight` | SHAP visualization |

---

## ⚙️ Tech Stack

### Backend
- FastAPI
- Pandas
- Scikit-Learn
- Joblib
- SHAP
- Parquet Dataset

### Frontend
- Flutter
- Provider (State Management)
- fl_chart (Medical graph visualization)
- HTTP REST integration

---

## 🛠 Installation

### Backend

```bash
pip install -r requirements.txt
uvicorn backend_api:app --host 0.0.0.0 --port 8000 --reload
