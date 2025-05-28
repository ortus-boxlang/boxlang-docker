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

This repo contains the Docker images for the BoxLang OS and MiniServer runtimes.  You can find the full documentation here: https://boxlang.ortusbooks.com/getting-started/running-boxlang/docker

## What is BoxLang?

**BoxLang** is a modern dynamic JVM language that can be deployed on multiple runtimes: operating system (Windows/Mac/*nix/Embedded), web server, lambda, iOS, android, web assembly, and more. **BoxLang** combines many features from different programming languages, including Java, ColdFusion, Python, Ruby, Go, and PHP, to provide developers with a modern and expressive syntax.

**BoxLang** has been designed to be a highly adaptable and dynamic language to take advantage of all the modern features of the JVM and was designed with several goals in mind:

* Be a rapid application development (RAD) scripting language and middleware.
* Unstagnate the dynamic language ecosystem in Java.
* Be dynamic, modular, lightweight, and fast.
* Be 100% interoperable with Java.
* Be modern, functional, and fluent (Think mixing CFML, Node, Kotlin, Java, and Clojure)
* Be able to support multiple runtimes and deployment targets:
  * Native OS Binaries (CLI Tooling, compilers, etc.)
  * MiniServer
  * Servlet Containers - CommandBox/Tomcat/Jetty/JBoss
  * JSR223 Scripting Engines
  * AWS Lambda
  * Microsoft Azure Functions (Coming Soon)
  * Android/iOS Devices (Coming Soon)
  * Web assembly (Coming Soon)
* Compile down to Java ByteCode
* Allow backward compatibility with the existing ColdFusion/CFML language.
* Great IDE, Debugger and Tooling: https://boxlang.ortusbooks.com/getting-started/ide-tooling
* Scripting (Any OS and Shebang) and REPL capabilities

You can find our docs here: https://boxlang.ortusbooks.com/

## License

Apache License, Version 2.0.

## Open-Source & Professional Support

This project is a professional open source project and is available as FREE and open source to use.  Ortus Solutions, Corp provides commercial support, training and commercial subscriptions which include the following:

* Professional Support and Priority Queuing
* Remote Assistance and Troubleshooting
* New Feature Requests and Custom Development
* Custom SLAs
* Application Modernization and Migration Services
* Performance Audits
* Enterprise Modules and Integrations
* Much More

Visit us at [BoxLang.io Plans](https://boxlang.io/plans) for more information.

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

### BoxLang Environment Variables

Please note that BoxLang has the capacity to override any configuration setting via environment variables using the `BOXLANG_` prefix.  Click here for more information: https://boxlang.ortusbooks.com/getting-started/configuration#environment-variable-substitution

Example:

```bash
BOXLANG_DEBUGMODE=true
```
