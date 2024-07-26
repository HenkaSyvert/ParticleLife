# ParticleLife
```
todo:

	structure:
		- some kind of static soundmap class
		-add menu on autoload
		
		
	- check best practices and naming conventions
	- 4d version
	- add cube universe shape
	- fix errors from all enforced typing options
	- c++ optimization?
	- do double buffer in cpu
	- figure out why gpu and cpu dont behave the same
	- lint shader code
	- add particle drag
	- random seed button
	- more robust menu variable system..
	- fix all broken signals
	- fix signal for universe sphere so doesnt change scale every frame
	- move 2d,3d specific params out from gpu
	- save camera transform upon retart
	-fix random start pos more spread out
	- gpu fix num vec elements dpenedsing on dimensions
	. sexiest and most performant way of passing buffer data from gpu to cpu: byte array or variant?

	- fix 2d gpu

	- maybe it's sexier to not have simulation2/3D be partially static?
	- rename buffer toggle to current_buffer
	- staticify buffer_toggle/current_buffer?
	
	gpu:
		- figure out optimal work groups
		- parallelize i,j loops
		- research interleaved version
		
	gui:
		- make particle color picker
		- fix dont take wasd input to spinboxes
		- attraction matrix
		- add theme, transparency, to see check boxes better
		- make better menu sliders, with own scene
		- add hide menu
		
	sound:
		- make particle velocity affect envelope
		- other note mapping to fib dirs
		- different particles have own sounds
		- make notes from 4ths and 5th and set intervals instead of just all tones in scale
		- visualize with keyboard
		- polyrythm
		- make use of string thickness for determine if particle hit string or not

	graphics:
		- change particle mesh to cooler
		- cooler graphics
	
	
```
