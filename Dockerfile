# Dockerfile for your Django LoanPrediction app
FROM python:3.10-slim

# Avoid Python writing .pyc files and use unbuffered output
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

# Install system deps (if you later use Postgres, add libpq-dev etc.)
RUN apt-get update && apt-get install -y \
    build-essential \
 && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy project code
COPY . .

# Collect static files (won’t fail if you don’t have STATIC_ROOT)
RUN python manage.py collectstatic --noinput || true

# Expose Django/Gunicorn port
EXPOSE 8000

# Run with gunicorn (your Django project is LoanPrediction)
CMD ["gunicorn", "LoanPrediction.wsgi:application", "--bind", "0.0.0.0:8000"]
