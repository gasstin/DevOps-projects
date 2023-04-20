from fastapi import FastAPI
import uvicorn

app = FastAPI()

@app.get('/')
def index():
    return {"message" : "hello world"}

if "__main__" == __name__:
    uvicorn.run(
        "app:app", port=8000, reload=True, host="127.0.0.1")
