# Check if Issue Exists Action

This Github action queries for an issue in a Github repository,
exposing an output for whether an issue matching that query exists.

## Inputs

### Required Inputs

#### `repo`

Which repo to check issues in. Must include the owner of the repo, e.g. `nickderobertis/check-if-issue-exists-action`

#### `token`

Github token

### Query Inputs

All query inputs are optional, but at least one query input must be passed. If
multiple query inputs are passed, the issue must match all of them.

#### `title`

Check for issues matching this title exactly.

#### `labels`

Check for issues matching these labels. Can pass a comma-separated list of labels or a single label.

## Outputs

### `exists`

Set to `true` if the queried issue exists and `false` otherwise.

## Example usage

```yaml
uses: nickderobertis/check-if-issue-exists-action@master
id: check_if_issue_exists
with:
  repo: myuser/my-target-repo
  token: ${{ secrets.GITHUB_TOKEN }}
  title: Add some stuff
  labels: good first issue, enhancement

```

This is useful in a workflow that creates an issue, to not create that issue if
it already exists. For example:

```yaml
steps:
  - uses: nickderobertis/check-if-issue-exists-action@master
    name: Check if Issue Exists
    id: check_if_issue_exists
    with:
      repo: myuser/my-target-repo
      token: ${{ secrets.GITHUB_TOKEN }}
      title: Add some stuff
      labels: good first issue, enhancement
  - name: Create Issue
    if: steps.check_if_issue_exists.outputs.exists == 'false'
    uses: JasonEtco/create-an-issue@master
    env:
      GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

## Development Guide

### Build Image

Use the script `build.sh` to build the image.

### Run Tests

Tests are run on the CI when code is pushed. But they can also be run locally.
Before doing that, the environment must be set up.

#### Set up Environment for Tests

Copy `env.template.sh` to `env.sh` and add your Github token.

#### Run Tests

Run `./tests/run-tests.sh` from the main project directory. You should see the
build of the image and then:

```
Test to return true passed.
Test to return false passed.
```

## Author

By Nick DeRobertis, licensed MIT.