# nvidia-docker run --rm -it --name neuralstyle -v /mnt/raid/projects:/projects coreindustries/neuralstyle:latest /bin/bash
# nvidia-docker run --rm -it --name neuralstyle -v /mnt/raid/projects:/projects ffedoroff/neural-style /bin/bash

nvidia-docker run -i -v /mnt/raid/projects:/projects -t rectalogic/neural-style:latest -gpu 1 -style_image examples/inputs/starry_night.jpg -content_image examples/inputs/hoovertowernight.jpg