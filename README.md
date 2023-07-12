# Acquisition Server

This repository contains the acquisition server firmware, based on a Beaglebone Black connected to a 4-20mA to modbus converter.
The device exposes the measurements on a web server.

## Author: Federico G. Roux (rouxfederico@gmail.com)

## Installation

First installation on BBB requires the device connected to the network (know IP), and then run:

```bash
cd scripts
./install-remote.sh -a <ip>
```

## Local development

Must have docker and docker compose installed.

Build and get inside the container executing:

```bash
docker-compose up -d
docker exec -it server-acq bash
```

## Deployment

The device doesn't have space to install docker, so native python and flask are used. Deploy using the script:

```bash
cd scripts
./deploy-remote.sh -a <ip>
```

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License

Private repository