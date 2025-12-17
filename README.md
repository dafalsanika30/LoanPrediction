# 💰 Loan Prediction System (Django + Machine Learning)

A web application built using **Django** and **Random Forest Classifier** to predict whether a loan should be approved.  
This project supports dataset upload, model training, analysis, and prediction.

---

## 🚀 Features

- 📂 Upload CSV dataset  
- 🤖 Train Random Forest ML model  
- 📈 Display model accuracy & analysis  
- 🔮 Predict loan approval  
- 💾 Save/load trained model  
- 🎨 Clean UI using HTML & Bootstrap  

---

## 📁 Project Structure

```plaintext
Project Root/
│
├── manage.py
├── requirement.txt
├── db.sqlite3
├── loan_approval_dataset.csv
├── .gitignore
│
├── LoanPrediction/              # Main Django App
│   ├── settings.py
│   ├── urls.py
│   ├── views.py
│   ├── forms.py
│   ├── asgi.py
│   └── wsgi.py
│
├── media/                       # ML model files & uploaded data
│   ├── last_model_results.pkl
│   ├── last_uploaded_file.pkl
│   ├── loan_approval_dataset.csv
│   ├── optimized_loan_model.pkl
│   └── scaler.pkl
│
├── static/
│   └── styles.css
│
└── template/
    └── website/
        ├── index.html
        ├── upload.html
        ├── analysis.html
        ├── predict.html
        ├── result.html
        ├── aboutus.html
        └── layout.html
```

---

# 🛠️ Setup Instructions

## 1️⃣ Clone the Repository

```bash
git clone https://github.com/dafalsanika30/LoanPrediction.git
cd LoanPrediction
```

---

## 2️⃣ Create Virtual Environment

### Windows
```bash
python -m venv env
env\Scripts\activate
```

### Linux / Mac
```bash
python3 -m venv env
source env/bin/activate
```

---

## 3️⃣ Install Dependencies

### Windows:
```bash
pip install -r requirements.txt
```

### Linux:
```bash
pip3 install -r requirements.txt
```

---

## 4️⃣ Apply Migrations

### Windows:
```bash
python manage.py makemigrations
python manage.py migrate
```

### Linux:
```bash
python3 manage.py makemigrations
python3 manage.py migrate
```

---

## 5️⃣ Start the Development Server

### Windows:
```bash
python manage.py runserver
```

### Linux:
```bash
python3 manage.py runserver
```

Open browser:
```
http://127.0.0.1:8000/
```

---

## 📊 Machine Learning Details

- **Algorithm:** RandomForestClassifier  
- **Scaler:** StandardScaler  
- **Trained Model:** optimized_loan_model.pkl  
- **Scaler File:** scaler.pkl  
- **Result Cache:** last_model_results.pkl  

---

## 🔧 Tech Stack

| Layer | Technology |
|-------|------------|
| Backend | Django |
| Machine Learning | Scikit-Learn |
| Data Handling | Pandas, NumPy |
| Frontend | HTML, CSS, Bootstrap |
| Database | SQLite |

---

## 👩‍💻 Author

**Sanika Vijay Dafal**  
MCA Student – IMCC College  
Loan Prediction Mini Project  
