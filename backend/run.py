"""Entry point to run the Signly detection server."""

import uvicorn
from app.config import HOST, PORT

if __name__ == "__main__":
    print(f"\n{'='*50}")
    print(f"  Signly Sign Language Detection Server")
    print(f"  Starting on http://{HOST}:{PORT}")
    print(f"  Health check: http://localhost:{PORT}/health")
    print(f"  API docs: http://localhost:{PORT}/docs")
    print(f"{'='*50}\n")

    uvicorn.run(
        "app.main:app",
        host=HOST,
        port=PORT,
        reload=True,
        log_level="info",
    )
