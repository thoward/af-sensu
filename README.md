# af-senu

Contains Sensu components setup to run on AppFog. 

Components are:

* Sensu Server - A server that manages and schedules checks, and handles client output
* Sensu Client - A client that runs various checks
* Sensu API - A Sinatra application that provides a HTTP/JSON API for Sensu
* Sensu Dashboard - A Sinatra application that provides a front-end for monitoring Sensu
## Deploying

From each sub-directory, run ```af push``` to deploy that component. Modify the manifest to change application names, urls, and service names for RabbitMQ/Redis.

#### A note on dependencies/communication patterns

Sensu requires a shared instance of RabbitMQ and Redis, and some components are dependent on each other.

**Sensu Server**
- Talks to RabbitMQ, Redis, and has no dependencies on other components. Requires at least one client instance to run checks.

**Sensu Client**
- Talks to RabbitMQ, and has no dependencies on other components. Can run checks standlone without Server.

**Sensu API**
- Talks to RabbitMQ, Redis, and has no dependencies on other components.

**Sensu Dashboard**
- Talks to Sensu API only.

