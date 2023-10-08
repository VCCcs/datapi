from fastapi import FastAPI, HTTPException

from dataprocessing import computation
from api import directives
from api.directives import adult_entities_supported_column
from dataprocessing import generate_dataset

# should be put into some configuration
PATH = "https://archive.ics.uci.edu/ml/machine-learning-databases/adult/adult.data"

dataset = generate_dataset.gather_dataset(PATH)

app = FastAPI()


@app.get("/ping")
async def root():
    return {"pong"}


@app.get("/v1/fields")
async def provide_fields_details():
    return {"available_columns": f"{adult_entities_supported_column}"}


@app.get("/v1/computation/mean/{column_name}")
async def compute_mean(column_name: str):
    if directives.is_numerical_column(column_name):
        return computation.get_mean(column_name, dataset)
    else:
        raise HTTPException(status_code=400, detail=f"This computation accept only numerical column. Numerical column "
                                                    f"are {directives.adult_entities_numerical_column}")


@app.get("/v1/computation/average/{column_name}")
async def compute_average(column_name: str):
    if directives.is_numerical_column(column_name):
        return computation.get_average(column_name, dataset)
    else:
        raise HTTPException(status_code=400, detail=f"This computation accept only numerical column. Numerical column "
                                                    f"are {directives.adult_entities_numerical_column}")


@app.get("/v1/computation/distribution/{column_name}")
async def compute_distribution(column_name: str):
    if directives.is_supported_column(column_name):
        return computation.get_value_distribution(column_name, dataset)
    else:
        raise HTTPException(status_code=400, detail=f"This computation accept only numerical column. Numerical column "
                                                    f"are {directives.adult_entities_supported_column}")


if __name__ == "__main__":
    import uvicorn

    uvicorn.run(app, host="0.0.0.0", port=8000)
