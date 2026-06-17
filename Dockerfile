FROM python:3.11-slim

WORKDIR /app

COPY requirements_flask.txt requirements.txt ./
RUN pip install --no-cache-dir -r requirements_flask.txt && \
    pip install --no-cache-dir gunicorn

COPY . .

RUN adduser --disabled-password --no-create-home appuser
RUN chown -R appuser:appuser /app
USER appuser

EXPOSE 8000

ENV FLASK_DEBUG=0
ENV DOMINIOS_PERMITIDOS=gmail.com,outlook.com,yahoo.com

CMD ["gunicorn", "--workers", "4", "--bind", "0.0.0.0:8000", \
     "--timeout", "60", "--max-requests", "1000", \
     "--access-logfile", "-", "--error-logfile", "-", \
     "app:app"]
