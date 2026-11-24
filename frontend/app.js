
// =============================================
// ISLAMABAD SMART CITY EXPLORER
// LEAFLET + FASTAPI + POSTGIS
// =============================================


// API CONFIGURATION

const API_BASE = "http://127.0.0.1:8000";


// =============================================
// MAP INITIALIZATION
// =============================================

const map = L.map("map", {
    zoomControl: false
}).setView([33.6844, 73.0479], 12);


L.control.zoom({
    position: "topright"
}).addTo(map);


// OpenStreetMap basemap

L.tileLayer(
    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
    {
        attribution:
            '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
        maxZoom: 19
    }
).addTo(map);


// =============================================
// MAP LAYERS
// =============================================

let facilityLayer = L.geoJSON(null);
let boundaryLayer = L.geoJSON(null, {
    style: {
        color: "#c5a45d",
        weight: 3,
        opacity: 0.9,
        fillColor: "#c5a45d",
        fillOpacity: 0.04,
        dashArray: "7, 5"
    }
});

boundaryLayer.addTo(map);


// =============================================
// GLOBAL DATA
// =============================================

let allFacilities = [];
let selectedCategory = "All";


// =============================================
// CATEGORY COLORS
// =============================================

const categoryColors = {
    "Education": "#477bd1",
    "Healthcare": "#dc6666",
    "Public Safety": "#e2a53f",
    "Recreation": "#48a66a",
    "Other": "#9270bb"
};


function getCategoryColor(category) {

    return categoryColors[category] || "#777777";

}


// =============================================
// FACILITY MARKER
// =============================================

function createFacilityMarker(feature, latlng) {

    const category =
        feature.properties.facility_category;

    const color = getCategoryColor(category);

    return L.circleMarker(latlng, {
        radius: 6,
        fillColor: color,
        color: "#ffffff",
        weight: 1.5,
        opacity: 1,
        fillOpacity: 0.9
    });

}


// =============================================
// FACILITY POPUP
// =============================================

function createPopup(feature) {

    const properties = feature.properties;

    const name = escapeHTML(
        properties.name || "Unnamed Facility"
    );

    const category = escapeHTML(
        properties.facility_category || "Other"
    );

    const amenity = escapeHTML(
        properties.amenity || "Not available"
    );

    const leisure = escapeHTML(
        properties.leisure || "Not available"
    );

    return `
        <div style="min-width:190px">

            <h3 style="color:#123c35;margin-bottom:8px">
                ${name}
            </h3>

            <p>
                <strong>Category:</strong>
                ${category}
            </p>

            <p>
                <strong>Amenity:</strong>
                ${amenity}
            </p>

            <p>
                <strong>Leisure:</strong>
                ${leisure}
            </p>

            <p>
                <strong>ID:</strong>
                ${properties.facility_id}
            </p>

        </div>
    `;

}


// Escape database text before inserting it into HTML

function escapeHTML(value) {

    return String(value).replace(/[&<>"']/g, character => ({
        "&": "&amp;",
        "<": "&lt;",
        ">": "&gt;",
        '"': "&quot;",
        "'": "&#39;"
    })[character]);

}


// =============================================
// LOAD ISLAMABAD BOUNDARY
// =============================================

async function loadBoundary() {

    try {

        const response = await fetch(
            `${API_BASE}/api/boundary`
        );

        if (!response.ok) {
            throw new Error("Boundary API request failed");
        }

        const data = await response.json();

        boundaryLayer.clearLayers();

        boundaryLayer.addData(data);

        if (boundaryLayer.getBounds().isValid()) {

            map.fitBounds(
                boundaryLayer.getBounds(),
                { padding: [20, 20] }
            );

        }

    } catch (error) {

        console.error("Boundary Error:", error);

        document.getElementById("mapStatus").textContent =
            "Boundary unavailable";

    }

}


// =============================================
// LOAD ALL FACILITIES
// =============================================

async function loadFacilities() {

    try {

        document.getElementById("mapStatus").textContent =
            "Loading facilities...";

        const response = await fetch(
            `${API_BASE}/api/facilities?limit=5000`
        );

        if (!response.ok) {
            throw new Error("Facilities API request failed");
        }

        const data = await response.json();

        allFacilities = data.features || [];

        updateDashboard(allFacilities);

        displayFacilities(allFacilities);

        document.getElementById("mapStatus").textContent =
            "Map data loaded";

    } catch (error) {

        console.error("Facilities Error:", error);

        document.getElementById("mapStatus").textContent =
            "Unable to connect to API";

        document.getElementById("resultText").textContent =
            "Please check that the FastAPI backend is running.";

    }

}


// =============================================
// DISPLAY FACILITIES ON MAP
// =============================================

function displayFacilities(features) {

    facilityLayer.clearLayers();

    facilityLayer = L.geoJSON(
        {
            type: "FeatureCollection",
            features: features
        },
        {
            pointToLayer: createFacilityMarker,

            onEachFeature: function (feature, layer) {

                layer.bindPopup(
                    createPopup(feature)
                );

            }
        }
    );

    facilityLayer.addTo(map);

    document.getElementById("resultText").textContent =
        `Showing ${features.length} facilities on the map.`;

}


// =============================================
// UPDATE DASHBOARD COUNTS
// =============================================

function updateDashboard(features) {

    const counts = {
        "Education": 0,
        "Healthcare": 0,
        "Public Safety": 0,
        "Recreation": 0,
        "Other": 0
    };

    features.forEach(feature => {

        const category =
            feature.properties.facility_category;

        if (counts[category] !== undefined) {
            counts[category]++;
        }

    });

    document.getElementById("totalFacilities").textContent =
        features.length;

    document.getElementById("countAll").textContent =
        features.length;

    document.getElementById("countEducation").textContent =
        counts["Education"];

    document.getElementById("countHealthcare").textContent =
        counts["Healthcare"];

    document.getElementById("countSafety").textContent =
        counts["Public Safety"];

    document.getElementById("countRecreation").textContent =
        counts["Recreation"];

    document.getElementById("countOther").textContent =
        counts["Other"];

}


// =============================================
// CATEGORY FILTER
// =============================================

document.querySelectorAll(".category-btn").forEach(button => {

    button.addEventListener("click", function () {

        document.querySelectorAll(".category-btn")
            .forEach(btn => btn.classList.remove("active"));

        this.classList.add("active");

        selectedCategory = this.dataset.category;

        applyFilters();

    });

});


// =============================================
// SEARCH
// =============================================

function applyFilters() {

    const searchValue = document.getElementById(
        "searchInput"
    ).value.trim().toLowerCase();

    let filtered = allFacilities;

    if (selectedCategory !== "All") {

        filtered = filtered.filter(feature =>
            feature.properties.facility_category === selectedCategory
        );

    }

    if (searchValue) {

        filtered = filtered.filter(feature => {

            const name =
                feature.properties.name || "";

            return name.toLowerCase().includes(searchValue);

        });

    }

    displayFacilities(filtered);

}


document.getElementById("searchButton")
    .addEventListener("click", applyFilters);


document.getElementById("searchInput")
    .addEventListener("keydown", function (event) {

        if (event.key === "Enter") {
            applyFilters();
        }

    });


// =============================================
// RESET FILTERS
// =============================================

document.getElementById("resetButton")
    .addEventListener("click", function () {

        selectedCategory = "All";

        document.getElementById("searchInput").value = "";

        document.querySelectorAll(".category-btn")
            .forEach(button => {

                button.classList.remove("active");

                if (button.dataset.category === "All") {
                    button.classList.add("active");
                }

            });

        displayFacilities(allFacilities);

    });


// =============================================
// START APPLICATION
// =============================================

async function initializeApplication() {

    await loadBoundary();

    await loadFacilities();

}


// Run application

initializeApplication();
