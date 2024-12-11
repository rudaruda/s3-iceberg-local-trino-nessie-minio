from fastapi import FastAPI
from starlette.responses import HTMLResponse, StreamingResponse, FileResponse, RedirectResponse

app = FastAPI()


@app.get("/", include_in_schema=False)
def root():
    """
    Redireciona para documentação /docs (Swagger)
    """
    return RedirectResponse(url="/docs")


@app.get("/items/{item_id}")
def read_item(item_id: int, q: str = None):
    return {"item_id": item_id, "q": q}