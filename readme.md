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

## Environment Variables

The following environment variables can be used to configure the BoxLang Docker images:

* `BOXLANG_HOME` - The home directory of the BoxLang installation. Default: `/home/.boxlang`
* `BOXLANG_PORT` - The port the MiniServer will listen on. Default: `8080`
* `BOXLANG_HOST` - The host the MiniServer will listen on. Default: `0.0.0.0`
* `BOXLANG_DEBUG` - Enable debugging. Default: `false`
* `BOXLANG_CONFIG_PATH` - The path to the BoxLang configuration file. Default: `/home/.boxlang/boxlang.json`
* `JAVA_OPTS` - Java options for the MiniServer. Default: `-Xmx512m -Xms256m`
* `BOXLANG_MODULES` - A comma-separated list of modules to install. Default: ``. Example: `bx-compat,bx-esapi,bx-mysql`
