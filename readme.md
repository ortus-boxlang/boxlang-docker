## Docker Images in the AWS ECR

### Log into AWS ECR to access files

Run the following to get logged into the ecr registry

```
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 233317242204.dkr.ecr.us-east-1.amazonaws.com
```

This will attempt to log you in with your AWS Credentials

You can set those credentials with the following commands

#### mac

```
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
```

#### windows

```
set AWS_ACCESS_KEY_ID=
set AWS_SECRET_ACCESS_KEY=
```

### Pull Images from AWS ECR

We have 2 images

- bx - Just the BX CLI in a container
- bx-web - This is a webserver

```
docker pull 233317242204.dkr.ecr.us-east-1.amazonaws.com/tryboxlang:bx
docker pull 233317242204.dkr.ecr.us-east-1.amazonaws.com/tryboxlang:bx-web
```

#### Multiple AWS Profiles

What if you have lots of different AWS Cli Credentials?

You can manage multiple AWS cli profiles in your AWS conf file.
https://www.simplified.guide/aws/cli/configure-multiple-profiles

## Docker Compose for Images

### Docker Compose for bx cli

```
version: "2.1"

services:
  cli:
    image: 233317242204.dkr.ecr.us-east-1.amazonaws.com/tryboxlang:bx
```

#### Running a command in a running container

```
docker exec -it CONTAINERID /usr/bin/bx.sh 2+2
```

##### timing

```
real 0m 0.46s
user 0m 0.85s
sys 0m 0.10s
```

#### Starting a docker container, run a command, and exit

```
docker run 233317242204.dkr.ecr.us-east-1.amazonaws.com/tryboxlang:bx time /usr/bin/bx.sh 2+2
```

##### timing

```
real 0m 1.52s
user 0m 4.38s
sys 0m 0.37s
```

### Docker Compose for bx web server

```
version: "2.1"

services:
  bxweb:
    image: 233317242204.dkr.ecr.us-east-1.amazonaws.com/tryboxlang:bx-web
    environment:
      cfconfig_adminPassword: testing
    volumes:
      - ./:/app
      - ./build:/root/build
    ports:
      - "8888:8080"

```
