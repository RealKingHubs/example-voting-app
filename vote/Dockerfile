FROM python:3.11-slim-bookworm AS base

RUN apt-get update \
    && apt-get upgrade -y --no-install-recommends \
    && apt-get install -y --no-install-recommends curl \
    && rm -rf /var/lib/apt/lists/*

RUN useradd --create-home --uid 10001 appuser

WORKDIR /usr/local/app

COPY requirements.txt ./
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

EXPOSE 8080

FROM base AS dev
RUN pip install --no-cache-dir watchdog
ENV FLASK_ENV=development
USER appuser
CMD ["python", "app.py"]

FROM base AS final
COPY . .
RUN pip uninstall -y pip setuptools wheel
USER appuser
CMD ["gunicorn", "app:app", "-b", "0.0.0.0:8080", "--log-file", "-", "--access-logfile", "-", "--workers", "4", "--keep-alive", "0"]