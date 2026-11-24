
import json

from fastapi import FastAPI, HTTPException, Query
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy import text

from database import engine, check_database


# -------------------------------------------------
# APPLICATION
# -------------------------------------------------

app = FastAPI(
    title="Islamabad Smart City Explorer API",
    description="GIS-based facilities exploration system for Islamabad.",
    version="1.0.0"
)


# -------------------------------------------------
# CORS CONFIGURATION
# -------------------------------------------------

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=False,
    allow_methods=["*"],
    allow_headers=["*"],
)


# -------------------------------------------------
# HOME
# -------------------------------------------------

@app.get("/")
def home():
    return {
        "project": "Islamabad Smart City Explorer",
        "message": "API is running successfully",
        "status": "success"
    }


# -------------------------------------------------
# DATABASE HEALTH
# -------------------------------------------------

@app.get("/api/health")
def health_check():

    database_status = check_database()

    return {
        "api": "running",
        "database": (
            "connected" if database_status else "disconnected"
        )
    }


# -------------------------------------------------
# FACILITY CATEGORIES
# -------------------------------------------------

@app.get("/api/categories")
def get_categories():

    query = text("""
        SELECT
            facility_category,
            COUNT(*) AS total
        FROM processed.vw_islamabad_facilities
        GROUP BY facility_category
        ORDER BY total DESC;
    """)

    try:
        with engine.connect() as connection:
            results = connection.execute(query).mappings().all()

        return [dict(row) for row in results]

    except Exception as error:
        raise HTTPException(
            status_code=500,
            detail=str(error)
        )


# -------------------------------------------------
# ALL FACILITIES (GEOJSON)
# -------------------------------------------------

@app.get("/api/facilities")
def get_facilities(
    category: str | None = None,
    search: str | None = None,
    limit: int = Query(default=5000, ge=1, le=5000)
):

    query = text("""
        SELECT
            facility_id,
            name,
            amenity,
            leisure,
            facility_category,
            ST_AsGeoJSON(geom) AS geometry

        FROM processed.vw_islamabad_facilities

        WHERE
            (:category IS NULL
             OR facility_category = :category)

            AND
            (:search IS NULL
             OR COALESCE(name, '') ILIKE :search)

        ORDER BY facility_id

        LIMIT :limit;
    """)

    parameters = {
        "category": category,
        "search": f"%{search}%" if search else None,
        "limit": limit
    }

    try:
        with engine.connect() as connection:
            results = connection.execute(
                query, parameters
            ).mappings().all()

        features = []

        for row in results:

            geometry = (
                json.loads(row["geometry"])
                if row["geometry"]
                else None
            )

            features.append({
                "type": "Feature",
                "id": row["facility_id"],
                "geometry": geometry,
                "properties": {
                    "facility_id": row["facility_id"],
                    "name": row["name"],
                    "amenity": row["amenity"],
                    "leisure": row["leisure"],
                    "facility_category": row["facility_category"]
                }
            })

        return {
            "type": "FeatureCollection",
            "count": len(features),
            "features": features
        }

    except Exception as error:
        raise HTTPException(
            status_code=500,
            detail=str(error)
        )


# -------------------------------------------------
# SINGLE FACILITY
# -------------------------------------------------

@app.get("/api/facilities/{facility_id}")
def get_facility(facility_id: int):

    query = text("""
        SELECT
            facility_id,
            name,
            amenity,
            leisure,
            facility_category,
            ST_AsGeoJSON(geom) AS geometry

        FROM processed.vw_islamabad_facilities

        WHERE facility_id = :facility_id;
    """)

    try:
        with engine.connect() as connection:
            row = connection.execute(
                query,
                {"facility_id": facility_id}
            ).mappings().first()

        if row is None:
            raise HTTPException(
                status_code=404,
                detail="Facility not found"
            )

        return {
            "type": "Feature",
            "id": row["facility_id"],
            "geometry": (
                json.loads(row["geometry"])
                if row["geometry"]
                else None
            ),
            "properties": {
                "facility_id": row["facility_id"],
                "name": row["name"],
                "amenity": row["amenity"],
                "leisure": row["leisure"],
                "facility_category": row["facility_category"]
            }
        }

    except HTTPException:
        raise

    except Exception as error:
        raise HTTPException(
            status_code=500,
            detail=str(error)
        )


# -------------------------------------------------
# ISLAMABAD BOUNDARY (GEOJSON)
# -------------------------------------------------

@app.get("/api/boundary")
def get_boundary():

    query = text("""
        SELECT
            ST_AsGeoJSON(
                ST_Transform(geom, 4326)
            ) AS geometry

        FROM boundaries.islamabad_boundary;
    """)

    try:
        with engine.connect() as connection:
            results = connection.execute(query).mappings().all()

        features = []

        for index, row in enumerate(results):

            features.append({
                "type": "Feature",
                "id": index + 1,
                "geometry": (
                    json.loads(row["geometry"])
                    if row["geometry"]
                    else None
                ),
                "properties": {
                    "name": "Islamabad Capital Territory"
                }
            })

        return {
            "type": "FeatureCollection",
            "count": len(features),
            "features": features
        }

    except Exception as error:
        raise HTTPException(
            status_code=500,
            detail=str(error)
        )
