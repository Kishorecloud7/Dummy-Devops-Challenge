# Dockerfile
FROM python:3.11-slim

# Create app user and group with a fixed UID
ARG APP_USER=appuser
ARG APP_UID=1001
ARG APP_GROUP=appgroup
RUN groupadd -g ${APP_UID} ${APP_GROUP} \
 && useradd -m -u ${APP_UID} -g ${APP_GROUP} -s /sbin/nologin ${APP_USER}

WORKDIR /app

# Install python deps (no cache)
COPY app/requirements.txt /app/requirements.txt
RUN apt-get update \
 && apt-get install -y --no-install-recommends libcap2-bin curl \
 && pip install --no-cache-dir -r /app/requirements.txt \
 && apt-get purge -y --auto-remove curl \
 && rm -rf /var/lib/apt/lists/*

# Copy app code
COPY app /app

# Expose port 80
EXPOSE 80

# Ensure non-root ownership
RUN chown -R ${APP_UID}:${APP_GROUP} /app

# Switch to non-root user
USER ${APP_UID}:${APP_GROUP}

# Run uvicorn binding to 0.0.0.0:80
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "80", "--loop", "uvloop", "--workers", "1"]
