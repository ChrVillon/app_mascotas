package com.example.app_mascotas

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import com.google.android.gms.maps.CameraUpdateFactory
import com.google.android.gms.maps.GoogleMap
import com.google.android.gms.maps.SupportMapFragment
import com.google.android.gms.maps.model.LatLng
import com.google.android.gms.maps.model.TileOverlayOptions
import com.google.maps.android.heatmaps.HeatmapTileProvider
import org.json.JSONArray
import java.util.*

class HeatmapActivity : AppCompatActivity() {

    private lateinit var map: GoogleMap

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_heatmap)

        val mapFragment = supportFragmentManager
            .findFragmentById(R.id.map_fragment) as SupportMapFragment
        mapFragment.getMapAsync { googleMap ->
            map = googleMap
            addHeatMap()
        }
    }

    private fun addHeatMap() {
        val latLngs = readItems()
        val provider = HeatmapTileProvider.Builder()
            .data(latLngs)
            .build()
        map.addTileOverlay(TileOverlayOptions().tileProvider(provider))
        map.moveCamera(CameraUpdateFactory.newLatLngZoom(LatLng(-2.15, -79.97), 13f))
    }

    private fun readItems(): List<LatLng> {
        val result = mutableListOf<LatLng>()
        // Aquí pondrás tus datos. Ejemplo estático:
        result.add(LatLng(-2.15, -79.97))
        result.add(LatLng(-2.16, -79.98))
        result.add(LatLng(-2.155, -79.975))
        return result
    }
}
