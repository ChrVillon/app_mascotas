package com.example.app_mascotas

import android.content.Context
import com.google.android.gms.maps.model.LatLng
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import io.flutter.plugin.common.StandardMessageCodec

class HeatmapViewFactory : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context, id: Int, args: Any?): PlatformView {
        val creationParams = args as? Map<String, Any>
        val puntos = mutableListOf<LatLng>()

        val listaPuntos = creationParams?.get("puntos") as? List<Map<String, Any>>
        listaPuntos?.forEach { punto ->
            val lat = (punto["lat"] as Number).toDouble()
            val lng = (punto["lng"] as Number).toDouble()
            puntos.add(LatLng(lat, lng))
        }

        return HeatmapView(context, puntos)
    }
}
