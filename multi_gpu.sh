# To run this script you'll need to download the ultra-high res
# scan of Starry Night from the Google Art Project, available here:
# https://commons.wikimedia.org/wiki/File:Van_Gogh_-_Starry_Night_-_Google_Art_Project.jpg

STYLE_IMAGE=/projects/photos/style/Van_Gogh_-_Starry_Night_-_Google_Art_Project.jpg
CONTENT_IMAGE=/projects/createtech/LA-Banner.JPG
OUTPUT=/projects/photos/output
# CMD=clear;time nvidia-docker run -i -v /mnt/raid/projects:/projects -t coreindustries/neuralstyle:latest /opt/torch/install/bin/th

STYLE_WEIGHT=5e2
STYLE_SCALE=1.0

clear;time nvidia-docker run -i -v /mnt/raid/projects:/projects -t coreindustries/neuralstyle:latest /opt/torch/install/bin/th neural_style.lua \
  -content_image $CONTENT_IMAGE \
  -style_image $STYLE_IMAGE \
  -style_scale $STYLE_SCALE \
  -print_iter 1 \
  -style_weight $STYLE_WEIGHT \
  -image_size 256 \
  -output_image $OUTPUT/out1.png \
  -tv_weight 0 \
  -backend cudnn -cudnn_autotune

echo "\n\n"
echo "------ 2"
time nvidia-docker run -i -v /mnt/raid/projects:/projects -t coreindustries/neuralstyle:latest /opt/torch/install/bin/th neural_style.lua \
  -content_image $CONTENT_IMAGE \
  -style_image $STYLE_IMAGE \
  -init image -init_image $OUTPUT/out1.png \
  -style_scale $STYLE_SCALE \
  -print_iter 1 \
  -style_weight $STYLE_WEIGHT \
  -image_size 512 \
  -num_iterations 500 \
  -output_image $OUTPUT/out2.png \
  -tv_weight 0 \
  -backend cudnn -cudnn_autotune

echo "\n\n"
echo "------ 3"
time nvidia-docker run -i -v /mnt/raid/projects:/projects -t coreindustries/neuralstyle:latest /opt/torch/install/bin/th neural_style.lua \
  -content_image $CONTENT_IMAGE \
  -style_image $STYLE_IMAGE \
  -init image -init_image $OUTPUT/out2.png \
  -style_scale $STYLE_SCALE \
  -print_iter 1 \
  -style_weight $STYLE_WEIGHT \
  -image_size 1024 \
  -num_iterations 200 \
  -output_image $OUTPUT/out3.png \
  -tv_weight 0 \
  -backend cudnn -cudnn_autotune

echo "\n\n"
echo "------ 4"
time nvidia-docker run -i -v /mnt/raid/projects:/projects -t coreindustries/neuralstyle:latest /opt/torch/install/bin/th neural_style.lua \
  -content_image $CONTENT_IMAGE \
  -style_image $STYLE_IMAGE \
  -init image -init_image $OUTPUT/out3.png \
  -style_scale $STYLE_SCALE \
  -print_iter 1 \
  -style_weight $STYLE_WEIGHT \
  -image_size 2048 \
  -num_iterations 100 \
  -output_image $OUTPUT/out4.png \
  -tv_weight 0 \
  -gpu 0,1 \
  -backend cudnn

echo "\n\n"
echo "------ 5"
time nvidia-docker run -i -v /mnt/raid/projects:/projects -t coreindustries/neuralstyle:latest /opt/torch/install/bin/th neural_style.lua \
  -content_image $CONTENT_IMAGE \
  -style_image $STYLE_IMAGE \
  -init image -init_image $OUTPUT/out4.png \
  -style_scale $STYLE_SCALE \
  -print_iter 1 \
  -style_weight $STYLE_WEIGHT \
  -image_size 3620 \
  -num_iterations 50 \
  -save_iter 25 \
  -output_image $OUTPUT/out5.png \
  -tv_weight 0 \
  -lbfgs_num_correction 5 \
  -gpu 0,1 \
  -multigpu_strategy 6,12 \
  -backend cudnn
