# -------------------------------
# Base Image
# -------------------------------
FROM python:3.10-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

RUN apt-get update && apt-get install -y \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

# Install project dependencies + gunicorn
RUN pip install --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt \
    && pip install gunicorn

COPY . .

RUN python manage.py collectstatic --noinput || true

EXPOSE 8000

# Run with gunicorn
CMD ["gunicorn", "LoanPrediction.wsgi:application", "--bind", "0.0.0.0:8000"]
