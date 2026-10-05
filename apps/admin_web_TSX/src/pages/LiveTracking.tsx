import React, { useEffect, useState } from "react";
import {
  Bus,
  MapPin,
  Navigation,
  Clock,
  Radio,
} from "lucide-react";

import {
  MapContainer,
  TileLayer,
  Marker,
  Popup,
  useMap,
} from "react-leaflet";

import L from "leaflet";
import "leaflet/dist/leaflet.css";

import { Vehicle } from "../types";

interface LiveTrackingProps {
  vehicles: Vehicle[];
}

/* =====================================================
   FIX LEAFLET DEFAULT MARKER ICON
===================================================== */

const defaultIcon = L.icon({
  iconUrl:
    "https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.9.4/images/marker-icon.png",
  iconRetinaUrl:
    "https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.9.4/images/marker-icon-2x.png",
  shadowUrl:
    "https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.9.4/images/marker-shadow.png",

  iconSize: [25, 41],
  iconAnchor: [12, 41],
  popupAnchor: [1, -34],
  shadowSize: [41, 41],
});

/* =====================================================
   MAP CONTROLLER
   Moves map when selected vehicle changes
===================================================== */

interface MapControllerProps {
  vehicle: Vehicle | null;
}

const MapController: React.FC<MapControllerProps> = ({
  vehicle,
}) => {
  const map = useMap();

  useEffect(() => {
    if (
      vehicle &&
      typeof vehicle.latitude === "number" &&
      typeof vehicle.longitude === "number"
    ) {
      map.flyTo(
        [vehicle.latitude, vehicle.longitude],
        15,
        {
          duration: 1.2,
        }
      );
    }
  }, [vehicle, map]);

  return null;
};

/* =====================================================
   SELECTED BUS ICON
===================================================== */

const selectedBusIcon = L.divIcon({
  className: "selected-bus-marker",
  html: `
    <div style="
      width: 42px;
      height: 42px;
      border-radius: 50%;
      background: #3339ec;
      border: 4px solid white;
      box-shadow: 0 2px 10px rgba(0,0,0,0.35);
      display: flex;
      align-items: center;
      justify-content: center;
      color: white;
      font-size: 20px;
    ">
      🚌
    </div>
  `,
  iconSize: [42, 42],
  iconAnchor: [21, 21],
  popupAnchor: [0, -21],
});

/* =====================================================
   LIVE TRACKING PAGE
===================================================== */

const LiveTracking: React.FC<LiveTrackingProps> = ({
  vehicles,
}) => {
  const activeVehicles = vehicles.filter(
    (vehicle) => vehicle.status === "Running"
  );

  const vehiclesWithLocation = activeVehicles.filter(
    (vehicle) =>
      typeof vehicle.latitude === "number" &&
      typeof vehicle.longitude === "number"
  );

  /* =====================================================
     SELECTED VEHICLE
  ===================================================== */

  const [selectedVehicleId, setSelectedVehicleId] =
    useState<string | undefined>(
      vehiclesWithLocation[0]?.id
    );

  /* =====================================================
     KEEP SELECTED BUS VALID WHEN FIREBASE UPDATES
  ===================================================== */

  useEffect(() => {
    if (vehiclesWithLocation.length === 0) {
      setSelectedVehicleId(undefined);
      return;
    }

    const selectedStillExists =
      vehiclesWithLocation.some(
        (vehicle) => vehicle.id === selectedVehicleId
      );

    if (!selectedStillExists) {
      setSelectedVehicleId(
        vehiclesWithLocation[0]?.id
      );
    }
  }, [vehiclesWithLocation, selectedVehicleId]);

  /* =====================================================
     FIND SELECTED VEHICLE
  ===================================================== */

  const selectedVehicle =
    vehiclesWithLocation.find(
      (vehicle) => vehicle.id === selectedVehicleId
    ) || null;

  /* =====================================================
     DEFAULT MAP LOCATION
     Colombo
  ===================================================== */

  const defaultCenter: [number, number] = [
    6.9271,
    79.8612,
  ];

  const mapCenter: [number, number] =
    selectedVehicle &&
    typeof selectedVehicle.latitude === "number" &&
    typeof selectedVehicle.longitude === "number"
      ? [
          selectedVehicle.latitude,
          selectedVehicle.longitude,
        ]
      : defaultCenter;

  return (
    <div className="space-y-6">

      {/* =================================================
          PAGE HEADER
      ================================================= */}

      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold text-slate-900">
            Live Tracking
          </h1>

          <p className="mt-1 text-sm text-slate-500">
            Monitor active vehicles and their current
            locations.
          </p>
        </div>

        <div className="flex items-center gap-2 rounded-lg bg-emerald-50 px-3 py-2 text-xs font-medium text-emerald-600">
          <Radio className="h-4 w-4" />

          Live
        </div>
      </div>

      {/* =================================================
          MAIN CONTENT
      ================================================= */}

      <div className="grid grid-cols-1 gap-6 lg:grid-cols-3">

        {/* =================================================
            VEHICLE LIST
        ================================================= */}

        <div className="rounded-2xl border border-slate-200 bg-white">

          {/* Header */}

          <div className="flex items-center justify-between border-b border-slate-200 p-4">

            <div>
              <h2 className="font-semibold text-slate-900">
                Active Vehicles
              </h2>

              <p className="mt-1 text-xs text-slate-500">
                {activeVehicles.length} vehicle
                {activeVehicles.length !== 1
                  ? "s"
                  : ""}{" "}
                running
              </p>
            </div>

            <div className="rounded-lg bg-indigo-50 p-2 text-indigo-600">
              <Bus className="h-5 w-5" />
            </div>

          </div>

          {/* Vehicle List */}

          <div className="max-h-[600px] overflow-y-auto">

            {activeVehicles.length === 0 ? (
              <div className="p-6 text-center">

                <Bus className="mx-auto h-8 w-8 text-slate-300" />

                <p className="mt-3 text-sm text-slate-500">
                  No active vehicles.
                </p>

                <p className="mt-1 text-xs text-slate-400">
                  Running vehicles will appear here.
                </p>

              </div>
            ) : (
              <div className="divide-y divide-slate-100">

                {activeVehicles.map((vehicle) => {

                  const hasLocation =
                    typeof vehicle.latitude ===
                      "number" &&
                    typeof vehicle.longitude ===
                      "number";

                  const isSelected =
                    vehicle.id === selectedVehicleId;

                  return (
                    <button
                      type="button"
                      key={vehicle.id}
                      onClick={() => {
                        if (hasLocation) {
                          setSelectedVehicleId(
                            vehicle.id
                          );
                        }
                      }}
                      disabled={!hasLocation}
                      className={`w-full p-4 text-left transition-colors ${
                        isSelected
                          ? "bg-indigo-50"
                          : "hover:bg-slate-50"
                      } ${
                        !hasLocation
                          ? "cursor-not-allowed"
                          : "cursor-pointer"
                      }`}
                    >

                      {/* Vehicle Header */}

                      <div className="flex items-start justify-between gap-3">

                        <div className="flex min-w-0 items-center gap-3">

                          <div
                            className={`rounded-lg p-2 ${
                              isSelected
                                ? "bg-indigo-600 text-white"
                                : "bg-indigo-50 text-indigo-600"
                            }`}
                          >
                            <Bus className="h-4 w-4" />
                          </div>

                          <div className="min-w-0">

                            <p className="truncate text-sm font-semibold text-slate-900">
                              {vehicle.vehicleNumber}
                            </p>

                            <p className="text-xs text-slate-500">
                              {vehicle.vehicleType}
                            </p>

                          </div>

                        </div>

                        <span className="flex items-center gap-1 rounded-full bg-emerald-50 px-2 py-1 text-[10px] font-medium text-emerald-600">

                          <span className="h-1.5 w-1.5 rounded-full bg-emerald-500" />

                          Running

                        </span>

                      </div>

                      {/* Location */}

                      <div className="mt-3 space-y-2">

                        <div className="flex items-center gap-2 text-xs text-slate-500">

                          <MapPin className="h-3.5 w-3.5" />

                          {hasLocation ? (
                            <span>
                              {vehicle.latitude?.toFixed(
                                5
                              )}
                              ,{" "}
                              {vehicle.longitude?.toFixed(
                                5
                              )}
                            </span>
                          ) : (
                            <span>
                              Location unavailable
                            </span>
                          )}

                        </div>

                        {vehicle.lastUpdated && (
                          <div className="flex items-center gap-2 text-xs text-slate-400">

                            <Clock className="h-3.5 w-3.5" />

                            <span>
                              Updated{" "}
                              {new Date(
                                vehicle.lastUpdated
                              ).toLocaleTimeString()}
                            </span>

                          </div>
                        )}

                      </div>

                      {/* Selected indicator */}

                      {isSelected && (
                        <div className="mt-3 flex items-center gap-1.5 text-[10px] font-semibold text-indigo-600">

                          <Navigation className="h-3 w-3" />

                          Showing on map

                        </div>
                      )}

                    </button>
                  );
                })}

              </div>
            )}

          </div>
        </div>

        {/* =================================================
            OPENSTREETMAP
        ================================================= */}

        <div className="overflow-hidden rounded-2xl border border-slate-200 bg-white lg:col-span-2">

          <div className="flex h-[600px] flex-col">

            {/* Map Header */}

            <div className="flex items-center justify-between border-b border-slate-200 bg-white p-4">

              <div>

                <h2 className="font-semibold text-slate-900">
                  Vehicle Locations
                </h2>

                <p className="mt-1 text-xs text-slate-500">
                  OpenStreetMap • Live vehicle positions
                </p>

              </div>

              <div className="flex items-center gap-2 text-xs text-slate-500">

                <Navigation className="h-4 w-4 text-indigo-600" />

                {vehiclesWithLocation.length} tracked

              </div>

            </div>

            {/* =================================================
                MAP
            ================================================= */}

            <div className="relative flex-1">

              {vehiclesWithLocation.length === 0 ? (
                <div className="flex h-full items-center justify-center bg-slate-100">

                  <div className="text-center">

                    <MapPin className="mx-auto h-10 w-10 text-slate-300" />

                    <p className="mt-3 text-sm font-medium text-slate-600">
                      No GPS locations available
                    </p>

                    <p className="mt-1 max-w-sm text-xs text-slate-400">
                      Add latitude and longitude values
                      to your Firebase vehicle documents.
                    </p>

                  </div>

                </div>
              ) : (

                <MapContainer
                  center={mapCenter}
                  zoom={15}
                  scrollWheelZoom={true}
                  className="h-full w-full"
                >

                  {/* OpenStreetMap */}

                  <TileLayer
                    attribution='&copy; <a href="https://www.openstreetmap.org/copyright" target="_blank" rel="noreferrer">OpenStreetMap</a> contributors'
                    url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
                  />

                  {/* Move map when bus selected */}

                  <MapController
                    vehicle={selectedVehicle}
                  />

                  {/* =================================================
                      BUS MARKERS
                  ================================================= */}

                  {vehiclesWithLocation.map(
                    (vehicle) => {

                      const isSelected =
                        vehicle.id ===
                        selectedVehicleId;

                      return (
                        <Marker
                          key={vehicle.id}
                          position={[
                            vehicle.latitude!,
                            vehicle.longitude!,
                          ]}
                          icon={
                            isSelected
                              ? selectedBusIcon
                              : defaultIcon
                          }
                          eventHandlers={{
                            click: () => {
                              setSelectedVehicleId(
                                vehicle.id
                              );
                            },
                          }}
                        >

                          <Popup>

                            <div className="min-w-[180px]">

                              <div className="flex items-center gap-2">

                                <Bus className="h-4 w-4 text-indigo-600" />

                                <span className="font-semibold text-slate-900">
                                  {
                                    vehicle.vehicleNumber
                                  }
                                </span>

                              </div>

                              <p className="mt-1 text-xs text-slate-500">
                                {
                                  vehicle.vehicleType
                                }
                              </p>

                              <div className="mt-3 space-y-1">

                                <p className="text-xs text-slate-600">
                                  <strong>
                                    Latitude:
                                  </strong>{" "}
                                  {vehicle.latitude?.toFixed(
                                    6
                                  )}
                                </p>

                                <p className="text-xs text-slate-600">
                                  <strong>
                                    Longitude:
                                  </strong>{" "}
                                  {vehicle.longitude?.toFixed(
                                    6
                                  )}
                                </p>

                              </div>

                              <div className="mt-2 flex items-center gap-1 text-[10px] font-medium text-emerald-600">

                                <span className="h-1.5 w-1.5 rounded-full bg-emerald-500" />

                                Running

                              </div>

                            </div>

                          </Popup>

                        </Marker>
                      );
                    }
                  )}

                </MapContainer>

              )}

              {/* Selected bus information */}

              {selectedVehicle && (
                <div className="absolute bottom-4 left-4 z-[1000] rounded-xl border border-slate-200 bg-white/95 px-4 py-3 shadow-lg backdrop-blur">

                  <div className="flex items-center gap-3">

                    <div className="rounded-lg bg-indigo-50 p-2 text-indigo-600">

                      <Bus className="h-4 w-4" />

                    </div>

                    <div>

                      <p className="text-xs font-semibold text-slate-900">
                        {selectedVehicle.vehicleNumber}
                      </p>

                      <p className="text-[10px] text-slate-500">
                        Selected vehicle
                      </p>

                    </div>

                  </div>

                  <div className="mt-2 text-[10px] text-slate-500">

                    {selectedVehicle.latitude?.toFixed(
                      5
                    )}
                    ,{" "}
                    {selectedVehicle.longitude?.toFixed(
                      5
                    )}

                  </div>

                </div>
              )}

            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default LiveTracking;