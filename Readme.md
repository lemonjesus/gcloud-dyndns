# Google Cloud Dynamic DNS Daemon

This is a small little daemon that keeps your Google Cloud DNS up to date with your ip address.

## How To Use

You need to tell `gcloud-dyndns` what zone and record it's supposed to update with the current public ip address and provide it with service account credentials with adequate access to edit DNS records.

First, build the image:
```
docker build . -t gcloud-dyndns
```

You can use a Docker command or Docker Compose to run it:
```
docker run -e ZONE_NAME=zonename-com -e RECORD_NAME=recordname.com -e PROJECT_NAME=project-name-12345 -v /path/to/credentials.json:/app/credentials.json gcloud-dyndns 
```

or

```
version: "3.3"

services:
  test:
    image: gcloud-dyndns
    environment:
      ZONE_NAME: "zonename-com"
      RECORD_NAME: "recordname.com"
      PROJECT_NAME: "project-name-12345"
    volumes:
      - /path/to/credentials.json:/app/credentials.json
```

To see what `ZONE_NAME` and `RECORD_NAME` should be, you can pass `list` as an argument to the container to see a list of all zones and records:

```
docker run --rm -e PROJECT_NAME=project-name-12345 -v /path/to/credentials.json:/app/credentials.json gcloud-dyndns list
```

You can also use the `INTERVAL` environment variable to control the number of seconds between each update. The default is one day.

## Future Improvements
 - Edit multiple records at once
 - Edit only one piece of data in a record with more than one piece
 - Support AAAA records