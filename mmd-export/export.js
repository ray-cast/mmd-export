function osPath(input_path) {
	var platformPath = input_path
	if (Qt.platform.os == "windows") {
		var tmp = new String(platformPath)
		platformPath = tmp.replace(/\//g, "\\")
		// alg.log.info("[WIN] platformPath = " + platformPath)
	}
	return platformPath
}

function jsonPath(input_path) {
	var jsnPath = input_path
	if (Qt.platform.os == "windows") {
		var tmp = new String(jsnPath)
		jsnPath = tmp.replace(/\\/g, "\\\\")
		// alg.log.info("[WIN] jsnPath = " + jsnPath)
	}
	return jsnPath
}

function isExitsVariable(variableName) {
  try {
	if (typeof(variableName) == "undefined") {
	  //alert("value is undefined"); 
	  return false;
	} else {
	  //alert("value is true"); 
	  return true;
	}
  } catch(e) {}
  return false;
}

function exportMaps()
{
	var paths = alg.settings.value("exportMaps", {})
	return {
	isChecked: function isChecked(path) {
		return !(path in paths) || !!paths[path];
		}
	}
}

function exportAssets(exportMaps, callback)
{
	if (exportMaps == undefined)
	{
		alg.log.info("MMD: Empty exportMaps.")
		return
	}

	var sep = (Qt.platform.os == "windows") ? "\\" : "/"
	var ext = ".png"
	var tab = "    "
	var tab2 = tab + tab
	var tab3 = tab2 + tab
	var tab4 = tab3 + tab

	var exportPath = osPath(alg.mapexport.exportPath()) + sep + "MMD" + sep
	var exportTexturesPath = exportPath + "textures" + sep

	var document = alg.mapexport.documentStructure()

	for (var i in document.materials)
	{
		var material = document.materials[i]
		var materialName = material.name
		var materialStacks = material.stacks[0]
		var materialExports = exportMaps[materialName]
		var materialAdditional = alg.mapexport.additionalMapIdentifiers(materialName)

		callback(materialName + ' progress: ' + Math.floor(i / document.materials.length * 100) + '%')

		var ALBEDO_MAP_FROM = materialExports['basecolor'] ? 1 : 3
		var NORMAL_MAP_FROM = materialExports['normal'] ? 1 : 0
		var SMOOTHNESS_MAP_FROM = materialExports['roughness'] ? 1 : 9
		var METALNESS_MAP_FROM = materialExports['metallic'] ? 1 : 0
		var OCCLUSION_MAP_FROM = materialExports['ambient_occlusion'] ? 1 : 0
		var PARALLAX_MAP_FROM = materialExports['height'] ? 1 : 0
		var CUSTOM_A_MAP_FROM = materialExports['curvature'] ? 1 : 0
		var CUSTOM_B_MAP_FROM = materialExports['thickness'] ? 1 : 0

		var ALBEDO_MAP_FILE = materialName + "_basecolor" + ext
		var NORMAL_MAP_FILE = materialName + "_normal" + ext
		var SMOOTHNESS_MAP_FILE = materialName + "_roughness" + ext
		var METALNESS_MAP_FILE = materialName + "_metallic" + ext
		var OCCLUSION_MAP_FILE = materialName + "_occlusion" + ext
		var PARALLAX_MAP_FILE = materialName + "_height" + ext
		var CUSTOM_A_MAP_FILE = materialName + "_curvature" + ext
		var CUSTOM_B_MAP_FILE = materialName + "_thickness" + ext

		var fileContent = ""
		fileContent += '#define ALBEDO_MAP_FROM ' + ALBEDO_MAP_FROM + '\n'
		fileContent += '#define ALBEDO_MAP_UV_FLIP 0\n'
		fileContent += '#define ALBEDO_MAP_APPLY_SCALE 0\n'
		fileContent += '#define ALBEDO_MAP_APPLY_DIFFUSE 1\n'
		fileContent += '#define ALBEDO_MAP_APPLY_MORPH_COLOR 0\n'
		fileContent += '#define ALBEDO_MAP_FILE "'+ ALBEDO_MAP_FILE+ '"\n'
		fileContent += '\n'
		fileContent += 'const float3 albedo = 1.0;\n'
		fileContent += 'const float2 albedoMapLoopNum = 1.0;\n'
		fileContent += '\n'

		fileContent += '#define ALBEDO_SUB_ENABLE 0\n'
		fileContent += '#define ALBEDO_SUB_MAP_FROM 0\n'
		fileContent += '#define ALBEDO_SUB_MAP_UV_FLIP 0\n'
		fileContent += '#define ALBEDO_SUB_MAP_APPLY_SCALE 0\n'
		fileContent += '#define ALBEDO_SUB_MAP_FILE "'+ 'albedo.png'+ '"\n'
		fileContent += '\n'
		fileContent += 'const float3 albedoSub = 1.0;\n'
		fileContent += 'const float2 albedoSubMapLoopNum = 1.0;\n'
		fileContent += '\n'

		fileContent += '#define ALPHA_MAP_FROM 3\n'
		fileContent += '#define ALPHA_MAP_UV_FLIP 0\n'
		fileContent += '#define ALPHA_MAP_SWIZZLE 3\n'
		fileContent += '#define ALPHA_MAP_FILE "alpha.png"\n'
		fileContent += '\n'
		fileContent += 'const float alpha = 1.0;\n'
		fileContent += 'const float alphaMapLoopNum = 1.0;\n'
		fileContent += '\n'

		fileContent += '#define NORMAL_MAP_FROM ' + NORMAL_MAP_FROM + '\n'
		fileContent += '#define NORMAL_MAP_TYPE 0\n'
		fileContent += '#define NORMAL_MAP_UV_FLIP 0\n'
		fileContent += '#define NORMAL_MAP_FILE "'+ NORMAL_MAP_FILE+ '"\n'
		fileContent += '\n'
		fileContent += 'const float normalMapScale = 1.0;\n'
		fileContent += 'const float normalMapLoopNum = 1.0;\n'
		fileContent += '\n'

		fileContent += '#define NORMAL_SUB_MAP_FROM 0\n'
		fileContent += '#define NORMAL_SUB_MAP_TYPE 0\n'
		fileContent += '#define NORMAL_SUB_MAP_UV_FLIP 0\n'
		fileContent += '#define NORMAL_SUB_MAP_FILE "normal.png"\n'
		fileContent += '\n'
		fileContent += 'const float normalSubMapScale = 1.0;\n'
		fileContent += 'const float normalSubMapLoopNum = 1.0;\n'
		fileContent += '\n'

		fileContent += '#define SMOOTHNESS_MAP_FROM ' + SMOOTHNESS_MAP_FROM + '\n'
		fileContent += '#define SMOOTHNESS_MAP_TYPE ' + (SMOOTHNESS_MAP_FROM == 1 ? 1 : 0) + '\n'
		fileContent += '#define SMOOTHNESS_MAP_UV_FLIP 0\n'
		fileContent += '#define SMOOTHNESS_MAP_SWIZZLE 0\n'
		fileContent += '#define SMOOTHNESS_MAP_APPLY_SCALE 0\n'
		fileContent += '#define SMOOTHNESS_MAP_FILE "'+ SMOOTHNESS_MAP_FILE+ '"\n'
		fileContent += '\n'
		fileContent += 'const float smoothness = 0.0;\n'
		fileContent += 'const float smoothnessMapLoopNum = 1.0;\n'
		fileContent += '\n'

		fileContent += '#define METALNESS_MAP_FROM ' + METALNESS_MAP_FROM + '\n'
		fileContent += '#define METALNESS_MAP_UV_FLIP 0\n'
		fileContent += '#define METALNESS_MAP_SWIZZLE 0\n'
		fileContent += '#define METALNESS_MAP_APPLY_SCALE 0\n'
		fileContent += '#define METALNESS_MAP_FILE "'+ METALNESS_MAP_FILE+ '"\n'
		fileContent += '\n'
		fileContent += 'const float metalness = 0.0;\n'
		fileContent += 'const float metalnessMapLoopNum = 1.0;\n'
		fileContent += '\n'

		fileContent += '#define SPECULAR_MAP_FROM 0\n'
		fileContent += '#define SPECULAR_MAP_TYPE 0\n'
		fileContent += '#define SPECULAR_MAP_UV_FLIP 0\n'
		fileContent += '#define SPECULAR_MAP_SWIZZLE 0\n'
		fileContent += '#define SPECULAR_MAP_APPLY_SCALE 0\n'
		fileContent += '#define SPECULAR_MAP_FILE "specular.png"\n'
		fileContent += '\n'
		fileContent += 'const float3 specular = 0.5;\n'
		fileContent += 'const float2 specularMapLoopNum = 1.0;\n'
		fileContent += '\n'

		fileContent += '#define OCCLUSION_MAP_FROM ' + OCCLUSION_MAP_FROM + '\n'
		fileContent += '#define OCCLUSION_MAP_TYPE 0\n'
		fileContent += '#define OCCLUSION_MAP_UV_FLIP 0\n'
		fileContent += '#define OCCLUSION_MAP_SWIZZLE 0\n'
		fileContent += '#define OCCLUSION_MAP_APPLY_SCALE 0 \n'
		fileContent += '#define OCCLUSION_MAP_FILE "'+ OCCLUSION_MAP_FILE + '"\n'
		fileContent += '\n'
		fileContent += 'const float occlusion = 1.0;\n'
		fileContent += 'const float occlusionMapLoopNum = 1.0;\n'
		fileContent += '\n'

		fileContent += '#define PARALLAX_MAP_FROM ' + PARALLAX_MAP_FROM + '\n'
		fileContent += '#define PARALLAX_MAP_TYPE 1\n'
		fileContent += '#define PARALLAX_MAP_UV_FLIP 0\n'
		fileContent += '#define PARALLAX_MAP_SWIZZLE 0\n'
		fileContent += '#define PARALLAX_MAP_FILE "'+ PARALLAX_MAP_FILE+ '"\n'
		fileContent += '\n'
		fileContent += 'const float parallaxMapScale = 1.0;\n'
		fileContent += 'const float parallaxMapLoopNum = 1.0;\n'
		fileContent += '\n'

		fileContent += '#define EMISSIVE_ENABLE 0\n'
		fileContent += '#define EMISSIVE_MAP_FROM 0\n'
		fileContent += '#define EMISSIVE_MAP_UV_FLIP 0\n'
		fileContent += '#define EMISSIVE_MAP_APPLY_SCALE 0\n'
		fileContent += '#define EMISSIVE_MAP_APPLY_MORPH_COLOR 0\n'
		fileContent += '#define EMISSIVE_MAP_APPLY_MORPH_INTENSITY 0\n'
		fileContent += '#define EMISSIVE_MAP_APPLY_BLINK 0\n'
		fileContent += '#define EMISSIVE_MAP_FILE "emissive.png"\n'
		fileContent += '\n'
		fileContent += 'const float3 emissive = 1.0;\n'
		fileContent += 'const float3 emissiveBlink = 1.0;\n'
		fileContent += 'const float  emissiveIntensity = 1.0;\n'
		fileContent += 'const float2 emissiveMapLoopNum = 1.0;\n'
		fileContent += '\n'

		fileContent += '#define CUSTOM_ENABLE 0\n'
		fileContent += '\n'

		fileContent += '#define CUSTOM_A_MAP_FROM ' + CUSTOM_A_MAP_FROM + '\n'
		fileContent += '#define CUSTOM_A_MAP_UV_FLIP 0\n'
		fileContent += '#define CUSTOM_A_MAP_COLOR_FLIP 0\n'
		fileContent += '#define CUSTOM_A_MAP_SWIZZLE 0\n'
		fileContent += '#define CUSTOM_A_MAP_APPLY_SCALE 0\n'
		fileContent += '#define CUSTOM_A_MAP_FILE "'+ CUSTOM_A_MAP_FILE+ '"\n'
		fileContent += '\n'
		fileContent += 'const float customA = 0.0;\n'
		fileContent += 'const float customAMapLoopNum = 1.0;\n'
		fileContent += '\n'

		fileContent += '#define CUSTOM_B_MAP_FROM ' + CUSTOM_B_MAP_FROM + '\n'
		fileContent += '#define CUSTOM_B_MAP_UV_FLIP 0\n'
		fileContent += '#define CUSTOM_B_MAP_COLOR_FLIP 0\n'
		fileContent += '#define CUSTOM_B_MAP_APPLY_SCALE 0\n'
		fileContent += '#define CUSTOM_B_MAP_FILE "'+ CUSTOM_B_MAP_FILE+ '"\n'
		fileContent += '\n'
		fileContent += 'const float3 customB = 0.0;\n'
		fileContent += 'const float2 customBMapLoopNum = 1.0;\n'

		fileContent += "\n"
		fileContent += '#include "material_common_2.0.fxsub"'

		for (var j in materialStacks.channels)
		{
			var materialMapName = materialStacks.channels[j]
			var materialOutputPath = exportTexturesPath + materialName + "_" + materialMapName + ext

			var materials = []
			materials[0] = materialName
			materials[1] = materialMapName

			if (materialExports[materialMapName])
				alg.mapexport.save(materials, materialOutputPath)
		}

		for (var j in materialAdditional)
		{
			var materialMapName = materialAdditional[j]
			var materialOutputPath = exportTexturesPath + materialName + "_" + materialMapName + ext

			if (materialExports[materialMapName])
				alg.mapexport.saveAdditionalMap(materialName, materialMapName, materialOutputPath)
		}

		var steam = alg.fileIO.open(exportPath + materialName + ".fx", "w")
		steam.write(fileContent)
		steam.close()
	}

	alg.log.info("MMD: Export successful !")
}