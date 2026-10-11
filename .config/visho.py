#!/usr/bin/env python3

import csv
import json
import os
import subprocess
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

from PIL import ExifTags, Image, ImageOps


DEFAULT_DIRECTORY = Path(
    "~/Downloads/2026_09_Sicilie_september"
).expanduser()

IMAGE_EXTENSIONS = {".jpg", ".jpeg"}
THUMBNAIL_SIZE = (180, 135)
JPEG_QUALITY = 78


HTML_TEMPLATE = r"""<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Photo Locations</title>

<link rel="stylesheet"
      href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css">

<style>
:root {
    color-scheme: dark;
    --background: #181818;
    --panel: #242424;
    --border: #444;
    --text: #eee;
    --muted: #aaa;
    --hover: #263d52;
    --blue: #3388ff;
}

* {
    box-sizing: border-box;
}

html,
body {
    width: 100%;
    height: 100%;
    margin: 0;
    overflow: hidden;
    color: var(--text);
    background: var(--background);
    font-family: sans-serif;
}

#application {
    display: grid;
    grid-template-columns: 260px minmax(220px, 1fr) 8px
        minmax(220px, 1fr);
    width: 100vw;
    height: 100vh;
}

#picture-list {
    min-width: 0;
    overflow-y: auto;
    padding: 12px;
    background: var(--panel);
    border-right: 1px solid var(--border);
}

#picture-list h2 {
    margin-top: 0;
}

#list-controls {
    position: sticky;
    top: 0;
    z-index: 20;
    padding-bottom: 8px;
    background: var(--panel);
}

button {
    margin: 2px;
    padding: 5px 8px;
    cursor: pointer;
}

button:disabled {
    cursor: not-allowed;
    opacity: .45;
}

#list-status {
    margin: 8px 0;
    color: var(--muted);
    font-size: 13px;
}

.picture-row {
    display: flex;
    align-items: center;
    gap: 8px;
    min-height: 68px;
    margin: 6px 0;
    padding: 6px;
    background: #2d2d2d;
    border: 1px solid var(--border);
    border-radius: 5px;
    cursor: pointer;
}

.picture-row:hover,
.picture-row.current {
    background: var(--hover);
    border-color: var(--blue);
}

.picture-thumbnail {
    width: 80px;
    height: 60px;
    flex: 0 0 80px;
    object-fit: cover;
    background: #111;
    border-radius: 3px;
}

.picture-name {
    min-width: 0;
    overflow-wrap: anywhere;
    font-size: 14px;
}

.no-gps {
    color: var(--muted);
    font-size: 12px;
}

#map {
    width: 100%;
    height: 100%;
    min-width: 0;
    background: #111;
}

#splitter {
    z-index: 50;
    width: 8px;
    height: 100%;
    background: #444;
    border-left: 1px solid #666;
    border-right: 1px solid #666;
    cursor: col-resize;
}

#splitter:hover,
#splitter.dragging {
    background: var(--blue);
}

#picture-viewer {
    position: relative;
    width: 100%;
    height: 100%;
    overflow: hidden;
    background: #111;
}

#viewer-image-container {
    display: flex;
    align-items: center;
    justify-content: center;
    width: 100%;
    height: 100%;
    overflow: hidden;
    cursor: grab;
    touch-action: none;
}

#viewer-image-container.dragging {
    cursor: grabbing;
}

#viewer-image {
    max-width: 100%;
    max-height: 100%;
    object-fit: contain;
    transform-origin: center center;
    user-select: none;
    -webkit-user-drag: none;
}

#viewer-title {
    position: absolute;
    top: 12px;
    right: 70px;
    left: 70px;
    z-index: 10;
    margin: 0;
    color: white;
    font-size: .75rem;
    font-weight: normal;
    text-align: center;
    overflow-wrap: anywhere;
    pointer-events: none;
    text-shadow: 0 1px 3px black, 0 0 8px black;
}

#viewer-navigation {
    position: absolute;
    top: 50%;
    right: 0;
    left: 0;
    z-index: 10;
    display: flex;
    justify-content: space-between;
    padding: 0 12px;
    transform: translateY(-50%);
    pointer-events: none;
}

.viewer-navigation {
    width: 54px;
    height: 76px;
    padding: 0;
    color: white;
    background: rgba(0, 0, 0, .65);
    border: 1px solid #aaa;
    font-size: 38px;
    pointer-events: auto;
}

#viewer-controls {
    position: absolute;
    right: 12px;
    bottom: 18px;
    left: 12px;
    z-index: 10;
    text-align: center;
}

#viewer-controls button {
    min-width: 42px;
    color: white;
    background: rgba(0, 0, 0, .7);
    border: 1px solid #aaa;
}

#zoom-level {
    display: inline-block;
    min-width: 55px;
    text-align: center;
    color: white;
    text-shadow: 0 1px 3px black;
}
</style>
</head>

<body>
<main id="application">

<aside id="picture-list">
    <h2>Pictures</h2>

    <div id="list-controls">
        <button id="google-maps-button"
                onclick="openSelectedLocationInGoogleMaps()">
            Open location in Google Maps
        </button>

        <br>

        <button onclick="zoomToSelectedPicture()">
            Zoom to selected
        </button>

        <button onclick="zoomToAllPictures()">
            Zoom to all
        </button>

        <div id="list-status"></div>
    </div>

    <div id="pictures"></div>
    <div id="list-sentinel"></div>
</aside>

<section id="map"></section>
<div id="splitter"></div>

<section id="picture-viewer">
    <h2 id="viewer-title">Select a picture</h2>

    <div id="viewer-navigation">
        <button class="viewer-navigation"
                aria-label="Previous picture"
                onclick="showPreviousPicture()">&lt;</button>

        <button class="viewer-navigation"
                aria-label="Next picture"
                onclick="showNextPicture()">&gt;</button>
    </div>

    <div id="viewer-image-container">
        <img id="viewer-image" alt="">
    </div>

    <div id="viewer-controls">
        <button onclick="zoomImageOut()">−</button>
        <span id="zoom-level">100%</span>
        <button onclick="zoomImageIn()">+</button>
        <button onclick="resetImageZoom()">Reset</button>
    </div>
</section>

</main>

<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>

<script>
const locations = __LOCATION_DATA__;

const application = document.getElementById("application");
const splitter = document.getElementById("splitter");
const listElement = document.getElementById("pictures");
const sentinel = document.getElementById("list-sentinel");

const map = L.map("map").setView([37.5, 14], 8);

/*
 * Esri ArcGIS World Street Map.
 * This does not require a CARTO API key.
 */
L.tileLayer(
    "https://server.arcgisonline.com/ArcGIS/rest/services/"
    + "World_Street_Map/MapServer/tile/{z}/{y}/{x}",
    {
        maxZoom: 19,
        attribution:
            "Tiles &copy; Esri — Source: Esri, "
            + "DeLorme, NAVTEQ, USGS, Intermap, "
            + "iPC, NRCAN, Esri Japan, METI, Esri China "
            + "(Hong Kong), Esri Korea, Esri (Thailand), "
            + "TomTom, MapmyIndia, &copy; OpenStreetMap contributors"
    }
).addTo(map);

const markers = [];
const rows = new Map();

let currentPictureIndex = -1;
let filteredIndices = locations.map((_, index) => index);
let renderedCount = 0;

let imageZoom = 1;
let imageOffsetX = 0;
let imageOffsetY = 0;

locations.forEach(function(location, index) {
    if (!location.has_gps) {
        return;
    }

    const marker = L.circleMarker(
        [location.latitude, location.longitude],
        {
            radius: 7,
            color: "#0645ad",
            weight: 2,
            fillColor: "#3388ff",
            fillOpacity: .95
        }
    ).addTo(map);

    marker.pictureIndex = index;
    marker.bindTooltip(location.name);

    marker.on("click", function() {
        showPicture(index, false);
    });

    markers.push(marker);
});

function markerStyle(selected) {
    return selected
        ? {
            radius: 11,
            color: "#8b0000",
            weight: 3,
            fillColor: "#ff0000",
            fillOpacity: 1
        }
        : {
            radius: 7,
            color: "#0645ad",
            weight: 2,
            fillColor: "#3388ff",
            fillOpacity: .95
        };
}

function updateMarkerStyles() {
    markers.forEach(function(marker) {
        marker.setStyle(
            markerStyle(marker.pictureIndex === currentPictureIndex)
        );
    });
}

function zoomToLocations(indices) {
    const gps = indices
        .map(index => locations[index])
        .filter(location => location.has_gps);

    if (!gps.length) {
        alert("No selected pictures have GPS data.");
        return;
    }

    if (gps.length === 1) {
        map.setView([gps[0].latitude, gps[0].longitude], 14);
        return;
    }

    map.fitBounds(
        L.latLngBounds(
            gps.map(location => [
                location.latitude,
                location.longitude
            ])
        ),
        {padding: [30, 30]}
    );
}

function zoomToAllPictures() {
    zoomToLocations(locations.map((_, index) => index));
}

function zoomToSelectedPicture() {
    if (currentPictureIndex < 0) {
        alert("No picture is currently selected.");
        return;
    }

    zoomToLocations([currentPictureIndex]);
}

function updateGoogleMapsButton() {
    const button = document.getElementById("google-maps-button");
    const location = locations[currentPictureIndex];

    button.disabled = !location || !location.has_gps;
}

function openSelectedLocationInGoogleMaps() {
    const location = locations[currentPictureIndex];

    if (!location || !location.has_gps) {
        alert("The selected picture has no GPS data.");
        return;
    }

    const url =
        "https://www.google.com/maps/search/?api=1&query="
        + encodeURIComponent(
            location.latitude + "," + location.longitude
        );

    window.open(url, "_blank", "noopener");
}

function updateImageTransform() {
    document.getElementById("viewer-image").style.transform =
        "translate("
        + imageOffsetX + "px, "
        + imageOffsetY + "px) scale("
        + imageZoom + ")";

    document.getElementById("zoom-level").textContent =
        Math.round(imageZoom * 100) + "%";
}

function resetImageZoom() {
    imageZoom = 1;
    imageOffsetX = 0;
    imageOffsetY = 0;
    updateImageTransform();
}

function zoomImageIn() {
    imageZoom = Math.min(imageZoom + .25, 5);
    updateImageTransform();
}

function zoomImageOut() {
    imageZoom = Math.max(imageZoom - .25, 1);

    if (imageZoom === 1) {
        imageOffsetX = 0;
        imageOffsetY = 0;
    }

    updateImageTransform();
}

function updateListStatus() {
    const number = currentPictureIndex < 0
        ? renderedCount
        : currentPictureIndex + 1;

    document.getElementById("list-status").textContent =
        "Showing " + number + " of "
        + locations.length + " pictures";
}

function createPictureRow(index) {
    const location = locations[index];
    const row = document.createElement("div");

    row.className = "picture-row";

    const thumbnail = document.createElement("img");
    thumbnail.className = "picture-thumbnail";
    thumbnail.alt = location.name;
    thumbnail.loading = "lazy";
    thumbnail.src = location.thumbnail;

    const text = document.createElement("span");

    const name = document.createElement("div");
    name.className = "picture-name";
    name.textContent = location.name;
    text.appendChild(name);

    if (!location.has_gps) {
        const gps = document.createElement("div");
        gps.className = "no-gps";
        gps.textContent = "No GPS data";
        text.appendChild(gps);
    }

    row.appendChild(thumbnail);
    row.appendChild(text);

    row.addEventListener("click", function() {
        showPicture(index, false);
    });

    rows.set(index, row);
    return row;
}

function renderNextBatch() {
    const nextCount = Math.min(
        renderedCount + 100,
        filteredIndices.length
    );

    const fragment = document.createDocumentFragment();

    for (
        let position = renderedCount;
        position < nextCount;
        position++
    ) {
        fragment.appendChild(
            createPictureRow(filteredIndices[position])
        );
    }

    listElement.appendChild(fragment);
    renderedCount = nextCount;

    updateListStatus();
}

function updateCurrentRow() {
    rows.forEach(function(row, index) {
        row.classList.toggle(
            "current",
            index === currentPictureIndex
        );
    });
}

function ensureRowIsRendered(index) {
    const position = filteredIndices.indexOf(index);

    while (
        renderedCount <= position
        && renderedCount < filteredIndices.length
    ) {
        renderNextBatch();
    }

    const row = rows.get(index);

    if (row) {
        row.scrollIntoView({
            behavior: "smooth",
            block: "center"
        });
    }
}

function showPicture(index, zoomMap) {
    if (!locations.length) {
        return;
    }

    currentPictureIndex = index;
    const location = locations[index];

    document.getElementById("viewer-title").textContent =
        location.name;

    const image = document.getElementById("viewer-image");
    image.src = location.picture;
    image.alt = location.name;

    resetImageZoom();
    ensureRowIsRendered(index);
    updateCurrentRow();
    updateMarkerStyles();
    updateGoogleMapsButton();
    updateListStatus();

    if (zoomMap && location.has_gps) {
        map.setView(
            [location.latitude, location.longitude],
            14
        );
    }
}

function showPreviousPicture() {
    if (!locations.length) {
        return;
    }

    showPicture(
        (currentPictureIndex - 1 + locations.length)
        % locations.length,
        false
    );
}

function showNextPicture() {
    if (!locations.length) {
        return;
    }

    showPicture(
        (currentPictureIndex + 1) % locations.length,
        false
    );
}

/* Resizable map/viewer divider */
let resizing = false;

splitter.addEventListener("pointerdown", function(event) {
    resizing = true;
    splitter.classList.add("dragging");
    splitter.setPointerCapture(event.pointerId);

    document.body.style.cursor = "col-resize";
    document.body.style.userSelect = "none";
});

splitter.addEventListener("pointermove", function(event) {
    if (!resizing) {
        return;
    }

    const rect = application.getBoundingClientRect();
    const listWidth = document.getElementById(
        "picture-list"
    ).getBoundingClientRect().width;

    const splitterWidth = 8;
    const minimumMapWidth = 220;
    const minimumViewerWidth = 220;

    const mapStart = rect.left + listWidth;
    const totalWidth = rect.width - listWidth - splitterWidth;

    let mapWidth = event.clientX - mapStart;

    mapWidth = Math.max(mapWidth, minimumMapWidth);
    mapWidth = Math.min(
        mapWidth,
        totalWidth - minimumViewerWidth
    );

    application.style.gridTemplateColumns =
        listWidth + "px "
        + mapWidth + "px "
        + splitterWidth + "px "
        + "minmax(" + minimumViewerWidth + "px, 1fr)";

    map.invalidateSize();
});

function stopResizing(event) {
    resizing = false;
    splitter.classList.remove("dragging");

    document.body.style.cursor = "";
    document.body.style.userSelect = "";

    if (
        event
        && splitter.hasPointerCapture(event.pointerId)
    ) {
        splitter.releasePointerCapture(event.pointerId);
    }

    map.invalidateSize();
}

splitter.addEventListener("pointerup", stopResizing);
splitter.addEventListener("pointercancel", stopResizing);

/* Image zooming and dragging */
const imageContainer = document.getElementById(
    "viewer-image-container"
);

imageContainer.addEventListener("wheel", function(event) {
    event.preventDefault();

    if (event.deltaY < 0) {
        zoomImageIn();
    } else {
        zoomImageOut();
    }
}, {passive: false});

let draggingImage = false;
let dragStartX = 0;
let dragStartY = 0;

imageContainer.addEventListener("pointerdown", function(event) {
    if (imageZoom <= 1) {
        return;
    }

    draggingImage = true;
    dragStartX = event.clientX - imageOffsetX;
    dragStartY = event.clientY - imageOffsetY;

    imageContainer.classList.add("dragging");
    imageContainer.setPointerCapture(event.pointerId);
});

imageContainer.addEventListener("pointermove", function(event) {
    if (!draggingImage) {
        return;
    }

    imageOffsetX = event.clientX - dragStartX;
    imageOffsetY = event.clientY - dragStartY;
    updateImageTransform();
});

imageContainer.addEventListener("pointerup", function(event) {
    draggingImage = false;
    imageContainer.classList.remove("dragging");

    if (imageContainer.hasPointerCapture(event.pointerId)) {
        imageContainer.releasePointerCapture(event.pointerId);
    }
});

imageContainer.addEventListener("pointercancel", function() {
    draggingImage = false;
    imageContainer.classList.remove("dragging");
});

document.addEventListener("keydown", function(event) {
    if (event.key === "p") {
        showPreviousPicture();
    } else if (event.key === "n") {
        showNextPicture();
    } else if (event.key === "+" || event.key === "=") {
        zoomImageIn();
    } else if (event.key === "-") {
        zoomImageOut();
    } else if (event.key === "0") {
        resetImageZoom();
    }
});

const listObserver = new IntersectionObserver(
    function(entries) {
        if (
            entries[0].isIntersecting
            && renderedCount < filteredIndices.length
        ) {
            renderNextBatch();
        }
    },
    {
        root: document.getElementById("picture-list"),
        rootMargin: "500px"
    }
);

listObserver.observe(sentinel);
renderNextBatch();

if (locations.length > 0) {
    showPicture(0, false);
    zoomToAllPictures();
} else {
    updateGoogleMapsButton();
}
</script>
</body>
</html>
"""


def choose_directory():
    directory = DEFAULT_DIRECTORY

    while True:
        print(f"\nPhoto directory:\n  {directory}")
        answer = input("Use this directory? [Y/n]: ").strip().lower()

        if answer in {"", "y", "yes"}:
            if not directory.is_dir():
                print("Directory does not exist.")
                create = input("Create it? [y/N]: ").strip().lower()

                if create in {"y", "yes"}:
                    directory.mkdir(parents=True, exist_ok=True)
                else:
                    continue

            return directory

        if answer in {"n", "no"}:
            selected = input("Enter another directory: ").strip()

            if selected:
                directory = Path(selected).expanduser().resolve()

            continue

        print("Please answer y or n.")


def is_valid_image(path):
    try:
        with Image.open(path) as image:
            image.verify()

        return True

    except Exception as error:
        print(f"Skipping invalid JPEG {path.name}: {error}")
        return False


def find_photos(directory):
    photos = []

    for path in sorted(directory.iterdir()):
        if path.is_file() and path.suffix.lower() in IMAGE_EXTENSIONS:
            if is_valid_image(path):
                photos.append(path)

    return photos


def as_float(value):
    try:
        return float(value)
    except (TypeError, ValueError):
        return value.numerator / value.denominator


def gps_to_decimal(values, reference):
    if not values or len(values) != 3:
        return None

    result = (
        as_float(values[0])
        + as_float(values[1]) / 60
        + as_float(values[2]) / 3600
    )

    if reference.upper() in {"S", "W"}:
        result = -result

    return result


def get_gps(image_path):
    try:
        with Image.open(image_path) as image:
            exif = image.getexif()

            if not exif:
                return None

            gps = exif.get_ifd(ExifTags.IFD.GPSInfo)

            latitude = gps.get(2)
            latitude_ref = gps.get(1)
            longitude = gps.get(4)
            longitude_ref = gps.get(3)

            if not all(
                (latitude, latitude_ref, longitude, longitude_ref)
            ):
                return None

            if isinstance(latitude_ref, bytes):
                latitude_ref = latitude_ref.decode("ascii")

            if isinstance(longitude_ref, bytes):
                longitude_ref = longitude_ref.decode("ascii")

            latitude = gps_to_decimal(latitude, latitude_ref)
            longitude = gps_to_decimal(longitude, longitude_ref)

            if latitude is None or longitude is None:
                return None

            return latitude, longitude

    except Exception as error:
        print(f"Could not read EXIF from {image_path.name}: {error}")
        return None


def create_thumbnail(image_path, thumbnail_directory):
    thumbnail_directory.mkdir(parents=True, exist_ok=True)

    thumbnail_path = thumbnail_directory / f"{image_path.stem}.jpg"

    if thumbnail_path.exists():
        if (
            thumbnail_path.stat().st_mtime
            >= image_path.stat().st_mtime
        ):
            return thumbnail_path

    try:
        with Image.open(image_path) as image:
            image = ImageOps.exif_transpose(image)

            image.thumbnail(
                THUMBNAIL_SIZE,
                Image.Resampling.LANCZOS,
            )

            if image.mode != "RGB":
                image = image.convert("RGB")

            image.save(
                thumbnail_path,
                "JPEG",
                quality=JPEG_QUALITY,
            )

    except Exception as error:
        print(f"Could not create thumbnail for {image_path.name}: {error}")
        return image_path

    return thumbnail_path


def process_photo(arguments):
    image_path, thumbnail_directory = arguments

    thumbnail_path = create_thumbnail(
        image_path,
        thumbnail_directory,
    )

    gps = get_gps(image_path)

    if gps is None:
        latitude = None
        longitude = None
        has_gps = False
    else:
        latitude, longitude = gps
        has_gps = True

    return {
        "name": image_path.name,
        "latitude": latitude,
        "longitude": longitude,
        "has_gps": has_gps,
        "picture": image_path.resolve().as_uri(),
        "thumbnail": thumbnail_path.resolve().as_uri(),
    }


def build_locations(photos, thumbnail_directory):
    if not photos:
        return []

    worker_count = min(
        16,
        max(4, (os.cpu_count() or 4) * 2),
    )

    arguments = [
        (photo, thumbnail_directory)
        for photo in photos
    ]

    locations = []

    with ThreadPoolExecutor(
        max_workers=worker_count
    ) as executor:
        results = executor.map(process_photo, arguments)

        for number, location in enumerate(results, start=1):
            print(
                f"Processing {number}/{len(photos)}: "
                f"{location['name']}"
            )
            locations.append(location)

    return locations


def write_csv(locations, output_directory):
    csv_path = output_directory / "locations.csv"

    with csv_path.open(
        "w",
        newline="",
        encoding="utf-8",
    ) as file:
        writer = csv.DictWriter(
            file,
            fieldnames=[
                "name",
                "latitude",
                "longitude",
                "has_gps",
                "picture",
                "thumbnail",
            ],
        )

        writer.writeheader()
        writer.writerows(locations)

    return csv_path


def write_html(locations, output_directory):
    html_path = output_directory / "locations.html"

    html = HTML_TEMPLATE.replace(
        "__LOCATION_DATA__",
        json.dumps(
            locations,
            ensure_ascii=False,
            separators=(",", ":"),
        ),
    )

    html_path.write_text(html, encoding="utf-8")
    return html_path


def open_in_browser(path):
    try:
        subprocess.Popen(
            [
                "xdg-open",
                str(path.resolve()),
            ],
            stdin=subprocess.DEVNULL,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            start_new_session=True,
        )

    except FileNotFoundError:
        print(f"\nOpen this file manually:\n  {path}")


def main():
    directory = choose_directory()

    output_directory = directory / "locations"
    thumbnail_directory = output_directory / "thumbnails"

    output_directory.mkdir(
        parents=True,
        exist_ok=True,
    )

    photos = find_photos(directory)

    print(f"\nFound {len(photos)} valid JPEG files.")

    locations = build_locations(
        photos,
        thumbnail_directory,
    )

    csv_path = write_csv(
        locations,
        output_directory,
    )

    html_path = write_html(
        locations,
        output_directory,
    )

    geotagged_count = sum(
        location["has_gps"]
        for location in locations
    )

    print()
    print(f"Valid JPEG files found: {len(photos)}")
    print(f"Photos with GPS: {geotagged_count}")
    print(
        "Photos without GPS: "
        f"{len(photos) - geotagged_count}"
    )
    print(f"CSV written to: {csv_path}")
    print(f"Map written to: {html_path}")
    print(f"Thumbnails written to: {thumbnail_directory}")

    open_in_browser(html_path)


if __name__ == "__main__":
    main()
