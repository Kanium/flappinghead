--[[
Uncomment the "effect.enable" parts of the code by removing the double "-" to enable the shader effect.

Please see https://github.com/vrld/moonshine#list-of-effects for more information on settings.

--]]

--boxblur
--effect.enable("boxblur")
effect.boxblur.radius_x = 3
effect.boxblur.radius_y = 3

--chromasep
--effect.enable("chromasep")
effect.chromasep.angle = 0
effect.chromasep.radius = 0

--colorgradesimple
--effect.enable("colorgradesimple")
effect.colorgradesimple.factors = {1,1,1}

--crt
--effect.enable("crt")
effect.crt.x = 1.06
effect.crt.y = 1.065
effect.crt.scaleFactor = {1,1}
effect.crt.feather = 0.02

--desaturate
--effect.enable("desaturate")
effect.desaturate.tint = {255,255,255}
effect.desaturate.strength = 0.5

--dmg
--effect.enable("dmg")
effect.dmg.palette = "default"

--fastgaussianblur
--effect.enable("fastgaussianblur")
effect.fastgaussianblur.taps = 7
effect.fastgaussianblur.offset = 1
effect.fastgaussianblur.sigma = -1

--filmgrain
--effect.enable("filmgrain")
effect.filmgrain.opacity = 0.3
effect.filmgrain.size = 1

--gaussianblur
--effect.enable("gaussianblur")
effect.gaussianblur.sigma = 1

--glow
--effect.enable("glow")
effect.glow.min_luma = 0.1
effect.glow.strength = 10

--godsray
--effect.enable("godsray")
effect.godsray.exposure = 0.5
effect.godsray.decay = 0.95
effect.godsray.density = 0.05
effect.godsray.weight = 0.5
effect.godsray.light_x = 0.5
effect.godsray.light_y = 0.5
effect.godsray.samples = 70

--pixelate
--effect.enable("pixelate")
effect.pixelate.size = {5,5}
effect.pixelate.feedback = 0

--posterize
--effect.enable("posterize")
effect.posterize.num_bands = 3

--scanlines
--effect.enable("scanlines")
effect.scanlines.width = 2
effect.scanlines.phase = 0
effect.scanlines.thickness = 1
effect.scanlines.opacity = 1
effect.scanlines.color = {0,0,0}

--sketch
--effect.enable("sketch")
effect.sketch.amp = 0.0007
effect.sketch.center = {0,0}

--vignette
--effect.enable("vignette")
effect.vignette.radius = 0.8
effect.vignette.softness = 0.5
effect.vignette.opacity = 0.5
effect.vignette.color = {0,0,0}

--fog
--effect.enable("fog")
effect.fog.fog_color = {0.35, 0.48, 0.95}
effect.fog.octaves = 4
effect.fog.speed = {0.5,0.5}