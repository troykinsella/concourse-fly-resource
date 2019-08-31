Concourse Fly Resource
======================

A [Concourse](http://concourse.ci/) resource for manipulating `fly`.

See [Docker Hub](https://cloud.docker.com/repository/docker/troykinsella/concourse-fly-resource)
for tagged image versions available.

Compatibility matrix:

| Concourse Version | Resource Tag |
| ----------------- | ------------ |
| `5.x` | `2.x`, `latest` |
| `4.x` | `2.x`, `latest` |
| `3.x` | `1.x` |
| `2.x` and below | NOPE | 

## Resource Type Configuration

```yaml
resource_types:
- name: fly
  type: docker-image
  source:
    repository: troykinsella/concourse-fly-resource
    tag: latest
```

## Source Configuration

Currently only HTTP basic authentication is supported.

* `url`: _Optional_. The base URL of the concourse instance to contact. (i.e. https://ci.concourse-ci.org).
  Default: The value of the `$ATC_EXTERNAL_URL` [metadata](https://concourse-ci.org/implementing-resource-types.html#resource-metadata) variable.
* `username`: _Required_. The concourse basic auth username.
* `password`: _Required_. The concourse basic auth password.
* `target`: _Optional_. The name of the target concourse instance. Default: "main".
* `team`: _Optional_. The concourse team to login to. Default: The value of the
  `$BUILD_TEAM_NAME` [metadata](https://concourse-ci.org/implementing-resource-types.html#resource-metadata) variable.
* `insecure`: _Optional_. Set to `true` to skip TLS verification.
* `debug`: _Optional_. Set to `true` to print commands (such as `fly login` and `fly sync`) for troubleshooting, including credentials. Default: `false`.
* `secure_output`: _Optional_. Set to `false` to show potentially insecure options and echoed fly commands. Default: `true`.
* `multiline_lines`: _Optional_. Set to `true` to interpret `\` as one line (mostly for big options line).

### Example

```yaml
resources:
- name: fly
  type: fly
  source:
    url: {{concourse_url}}
    username: ((concourse_username))
    password: ((concourse_password))
    team: eh-team
```

## Behaviour

### `check`: No-Op

### `in`: No-Op

### `out`: Execute `fly` Command

Execute the given `fly` command along with given options. The `fly` client is downloaded from the target 
Concourse instance if not already present. If there is a version mismatch between `fly` and Concourse,
a `fly sync` is performed.
When multiple lines are present in the provided options, `fly` is executed separately for each line.

#### Parameters

* `options`: _Optional_. The options to pass to `fly`.
* `options_file`: _Optional_. A file containing options to pass to `fly`.

Parameters are passed through to the `fly` command as follows:
```sh
fly -t <target> <options>
```

Concourse [metadata](https://concourse-ci.org/implementing-resource-types.html#resource-metadata)
variables are supported in options.

#### Example

```yaml
- name: trigger-something
  plan:
  - put: fly
    params:
      options: trigger-job -j some-pipeline/some-job
```

## License

MIT © Troy Kinsella
