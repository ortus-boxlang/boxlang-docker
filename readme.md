# ⚡︎ BoxLang Docker Images

```
|:------------------------------------------------------:|
| ⚡︎ B o x L a n g ⚡︎
| Dynamic : Modular : Productive
|:------------------------------------------------------:|
```

<blockquote>
	Copyright Since 2023 by Ortus Solutions, Corp
	<br>
	<a href="https://www.boxlang.io">www.boxlang.io</a> |
	<a href="https://www.ortussolutions.com">www.ortussolutions.com</a>
</blockquote>

<p>&nbsp;</p>

## Welcome to the BoxLang Docker Images

This repo contains the Docker images for the BoxLang OS and MiniServer runtimes.

## Docker Images

Two image tags are currently published to Docker Hub: https://hub.docker.com/r/ortussolutions/boxlang

* `ortussolutions/boxlang:cli` - Just the BoxLang CLI in a container - you can pass expressions, or just run the cli itself
* `ortussolutions/boxlang:miniserver` - This is our lightweight and fast MiniServer

```bash
docker pull ortussolutions/boxlang:cli
docker pull ortussolutions/boxlang:miniserver
```

## Docker Tags

Both images are tagged with the following tags:

* `latest` - The latest stable release of BoxLang
* `snapshot` - The latest snapshot release of BoxLang
* `alpine-snapshot` - The latest snapshot release of BoxLang on Alpine Linux

## Documentation

You can find our complete docs here: https://boxlang.ortusbooks.com/getting-started/running-boxlang/docker
