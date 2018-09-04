# nvidia-docker image for cryptodredge's CUDA miner

This image build [cryptodredge's miner] from GitHub.
It requires a CUDA compatible docker implementation so you should probably go for [nvidia-docker].
It has also been tested successfully on [Mesos].

## Build images

```
git clone https://github.com/eLvErDe/docker-cryptodredge-cuda
cd docker-cryptodredge-cuda
docker build -t cryptodredge-cuda .
```

## Publish it somewhere

```
docker tag cryptodredge-cuda docker.domain.com/mining/cryptodredge-cuda:latest
docker push docker.domain.com/mining/cryptodredge-cuda:latest
```

## Test it (using dockerhub published image)

```
nvidia-docker pull acecile/cryptodredge-cuda
nvidia-docker run -it --rm acecile/cryptodredge-cuda /root/cryptodredge --help
```

An example command line to mine using miningpoolhub.com on Zclassic (on my account, you can use it to actually mine something for real if you haven't choose your pool yet):
Check [cryptodredge's miner] GitHub page for more options.
```
nvidia-docker run -it --rm --name cryptodredge-cuda acecile/cryptodredge-cuda /root/cryptodredge -a lyra2v2 -o stratum+tcp://hub.miningpoolhub.com:20507 -u acecile.catch-all -p x --api-bind 0.0.0.0:4068
```

Ouput will looks like:
```
```

## Background job running forever

```
nvidia-docker run -dt --restart=unless-stopped -p 4068:4068 --name cryptodredge-cuda acecile/cryptodredge-cuda /root/cryptodredge -a lyra2v2 -o stratum+tcp://hub.miningpoolhub.com:20507 -u acecile.catch-all -p x --api-bind 0.0.0.0:4068
```

You can check the output using `docker logs cryptodredge-cuda -f`


## Use it with Mesos/Marathon

Edit `mesos_marathon.json` to replace mining pool parameters, change application path as well as docker image address (if you dont want to use public docker image provided).
Then simply run (adapt application name here too):

```
curl -X PUT -u marathon\_username:marathon\_password --header 'Content-Type: application/json' "http://marathon.domain.com:8080/v2/apps/mining/cryptodredge-cuda?force=true" -d@./mesos\_marathon.json
```

You can check CUDA usage on the mesos slave (executor host) by running `nvidia-smi` there:

```
```

[cryptodredge's miner]: https://github.com/technobyl/CryptoDredge
[nvidia-docker]: https://github.com/NVIDIA/nvidia-docker
[Mesos]: http://mesos.apache.org/documentation/latest/gpu-support/
