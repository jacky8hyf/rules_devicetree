# How to Contribute

## Using devcontainers

If you are using [devcontainers](https://code.visualstudio.com/docs/devcontainers/containers)
and/or [codespaces](https://github.com/features/codespaces) then you can start
contributing immediately and skip the next step.

## Formatting

Starlark files should be formatted by buildifier.
We suggest using a pre-commit hook to automate this.
First [install pre-commit](https://pre-commit.com/#installation),
then run

```shell
pre-commit install
```

Otherwise later tooling on CI will yell at you about formatting/linting violations.

## Updating BUILD files

Some targets are generated from sources.
Currently this is just the `bzl_library` targets.
Run `bazel run //:gazelle` to keep them up-to-date.

## Using this as a development dependency of other rules

You'll commonly find that you develop in another WORKSPACE, such as
some other ruleset that depends on rules_devicetree, or in a nested
WORKSPACE in the integration_tests folder.

To always tell Bazel to use this directory rather than some release
artifact or a version fetched from the internet, run this from this
directory:

```sh
OVERRIDE="--override_repository=rules_devicetree=$(pwd)/rules_devicetree"
echo "common $OVERRIDE" >> ~/.bazelrc
```

This means that any usage of `@rules_devicetree` on your system will point to this folder.

## Releasing

Releases are automated on a cron trigger.
The new version is determined automatically from the commit history, assuming the commit messages follow conventions, using
https://github.com/marketplace/actions/conventional-commits-versioner-action.
If you do nothing, eventually the newest commits will be released automatically as a patch or minor release.
This automation is defined in .github/workflows/tag.yaml.

Rather than wait for the cron event, you can trigger manually. Navigate to
https://github.com/bazel-contrib/rules_devicetree/actions/workflows/tag.yaml
and press the "Run workflow" button.

If you need control over the next release version, for example when making a release candidate for a new major,
then: tag the repo and push the tag, for example

```sh
% git fetch
% git tag v1.0.0-rc0 origin/main
% git push origin v1.0.0-rc0
```

Then watch the automation run on GitHub actions which creates the release.

## Naming conventions

### Devicetree

Throughout the code base, "devicetree" should always be treated as one word.
This aligns with the convention in
[Linux documentation](https://docs.kernel.org/devicetree/index.html).

When used in `CamelCase` names, the "t" should not be capitalized.

When used in `snake_case` names, there should not be a `_` before the "t".

Examples:

- `Devicetree`
- `devicetree`
- `DevicetreeInfo`
- `devicetree_info`

Avoid abbreviations for "devicetree", e.g. `dt` or `DT`. Abbreviations are only
allowed:

- in existing executable names, e.g. `dtc` or `fdtoverlay`
- in file types like `.dtb`, `.dtbo`, `.dts`, `.dtso`
- in words like `dtb` and `dtbo`.

### dtcopts

Use `dtcopts`, not `dtc_opts`. This is similar to `copts` and `javaopts`.
