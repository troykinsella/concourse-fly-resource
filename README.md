Concourse Fly Resource
======================

A Concourse resource for manipulating `fly`.

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

* `url`: _Required_. The base URL of the concourse instance to contact. (i.e. https://example.com/concourse)
* `username`: _Required_. The concourse basic auth username.
* `password`: _Required_. The concourse basic auth password.

### Example

```yaml
resources:
- name: fly
  type: fly
  source:
    url: {{concourse_url}}
    username: {{concourse_username}}
    password: {{concourse_password}}
```

## Behaviour

### `check`: No-op

### `in`: No-Op

Future: Import fly command output

### `out`: Execute `fly` Command

#### Parameters

* `command`: _Required_. The `fly` command to execute.
* `options`: _Optional_. The options to pass to `fly`.

## License

MIT © Troy Kinsella
