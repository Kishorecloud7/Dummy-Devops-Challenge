# app/main.py
from fastapi import FastAPI
import uvicorn

app = FastAPI()

@app.get("/", response_model=dict)
def root():
    return {"message": "Hello, Candidate", "version": "1.0.0"}

if __name__ == "__main__":
    # uvicorn will be started via the Docker entrypoint/command
    uvicorn.run("main:app", host="0.0.0.0", port=80, log_level="info")
