# -------------------------------
# Base Image
# -------------------------------
FROM python:3.10-slim

# -------------------------------
# Environment variables
# -------------------------------
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# -------------------------------
# Set working directory
# -------------------------------
WORKDIR /app

# -------------------------------
# Install system dependencies
# (needed for numpy, pandas, sklearn)
# -------------------------------
RUN apt-get update && apt-get install -y \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# -------------------------------
# Install Python dependencies
# -------------------------------
COPY requirements.txt .
RUN pip install --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

# -------------------------------
# Copy project files
# -------------------------------
COPY . .

# -------------------------------
# Collect static files (safe)
# -------------------------------
RUN python manage.py collectstatic --noinput || true

# -------------------------------
# Expose port
# -------------------------------
EXPOSE 8000

# -------------------------------
# Run Django development server
# -------------------------------
CMD ["gunicorn", "LoanPrediction.wsgi:application", "--bind", "0.0.0.0:8000"]

