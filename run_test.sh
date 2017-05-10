nvidia-docker run -i -v /mnt/raid/projects:/projects -t coreindustries/neuralstyle:latest \
	/opt/torch/install/bin/th neural_style.lua \
	-gpu 1 \
	-backend cudnn \
	-style_image examples/inputs/starry_night.jpg \
	-content_image examples/inputs/hoovertowernight.jpg \
	-output_image /projects/photos/output/test.png