Concourse Fly Resource
======================

A [Concourse](http://concourse.ci/) resource for manipulating `fly`.

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

* `url`: _Required_. The base URL of the concourse instance to contact. (i.e. https://example.com/concourse)
* `username`: _Required_. The concourse basic auth username.
* `password`: _Required_. The concourse basic auth password.
* `team`: _Optional_. The concourse team to login to. Default: "main".
* `insecure`: _Optional_. Set to `true` to skip TLS verification.
* `debug`: _Optional_. Set to `true` to print commands for troubleshooting, including credentials.

### Example

```yaml
resources:
- name: fly
  type: fly
  source:
    url: {{concourse_url}}
    username: {{concourse_username}}
    password: {{concourse_password}}
    team: main
```

## Behaviour

### `check`: No-Op

### `in`: No-Op

Future: Import fly command output

### `out`: Execute `fly` Command

Execute the given `fly` command along with given options. The `fly` client is downloaded from the target 
Concourse instance if not already present or if there is a version mismatch between `fly` and Concourse.
When multiple lines are present in the provided options, `fly` is executed separately for each line.

#### Parameters

* `options`: _Optional_. The options to pass to `fly`.
* `options_file`: _Optional_. A file containing options to pass to `fly`.

Parameters are passed through to the `fly` command as follows:
```sh
fly -t main $options
```
`main` is the name of the target Concourse instance.

## License

MIT © Troy Kinsella
