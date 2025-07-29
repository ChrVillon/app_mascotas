package com.example.app_mascotas

import android.content.Context
import android.view.View
import com.google.android.gms.maps.*
import com.google.android.gms.maps.model.*
import com.google.maps.android.heatmaps.HeatmapTileProvider
import io.flutter.plugin.platform.PlatformView

class HeatmapView(
    context: Context,
    private val puntos: List<LatLng>
) : PlatformView {
    private val mapView = MapView(context)

    init {
        mapView.onCreate(null)
        mapView.getMapAsync { googleMap ->
            if (puntos.isNotEmpty()) {
                val provider = HeatmapTileProvider.Builder()
                    .data(puntos)
                    .build()

                googleMap.addTileOverlay(TileOverlayOptions().tileProvider(provider))
                googleMap.moveCamera(CameraUpdateFactory.newLatLngZoom(puntos.first(), 13f))
            }
        }
    }

    override fun getView(): View = mapView

    override fun dispose() {
        mapView.onDestroy()
    }
}
