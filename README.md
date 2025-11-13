# Loan Prediction System

A Machine Learning powered **Loan Prediction Web Application** built using **Django** and a **Random Forest Classifier**.  
The project allows users to upload a dataset, train a ML model, view analysis, and predict loan approval status.

---

## 🚀 Features

- Upload CSV dataset  
- Train Random Forest model  
- Save trained model (`optimized_loan_model.pkl`)  
- View model performance metrics  
- Predict loan approval from input  
- Clean and structured UI using HTML & Bootstrap  

---

# 📁 Project Structure

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


## 🛠️ How to Run This Project on Local Machine

### 1. Clone the Repository

```
git clone https://github.com/dafalsanika30/LoanPrediction.git
cd LoanPrediction
```

### 2. Create a Virtual Environment

Windows:

```
python -m venv venv
```

Activate:

```
venv\Scripts\activate
```

### 3. Install Required Packages

```
pip install -r requirements.txt
```

### 4. Apply Migrations

```
python manage.py makemigrations
python manage.py migrate
```

### 5. Run the Django Server

```
python manage.py runserver
```

Open in browser:

```
http://127.0.0.1:8000/
```

## 🔧 Tech Stack Used

- Python  
- Django  
- Machine Learning (Random Forest Classifier)  
- Pandas  
- NumPy  
- Bootstrap  

## 📊 Machine Learning Model

- Algorithm: RandomForestClassifier  
- Evaluation metrics:
  - Accuracy Score  
  - Confusion Matrix  
  - Precision, Recall, F1  

The trained model is saved as `MLmodel.pkl`.

## 👤 Author

Sanika Vijay Dafal  
MCA Student — Loan Prediction Mini Project
