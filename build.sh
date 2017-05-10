# download models first
# mkdir -p models
wget -nc https://s3-us-west-2.amazonaws.com/cpb-la-bigdata-public/models/neuralstyle/models.tgz 
tar xzf models.tgz


# https://stackoverflow.com/questions/22030931/how-to-rebuild-dockerfile-quick-by-using-cache/22089946#22089946
# get squid ip to use in docker build
# SQUID_IP=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' squid)
# docker build --no-cache=true --build-arg http_proxy=http://$SQUID_IP:3128 --build-arg https_proxy=https://$SQUID_IP:3128 -t coreindustries/neuralstyle .
# docker build --build-arg http_proxy=http://$SQUID_IP:3128 --build-arg https_proxy=https://$SQUID_IP:3128 -t coreindustries/neuralstyle .
docker build -t coreindustries/neuralstyle .
