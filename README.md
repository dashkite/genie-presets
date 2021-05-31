# Genie Presets

Defines presets for the Genie task runner. Probably most useful for DashKite internal development.

The available presets are:

|         Name | Description                                                  |
| -----------: | ------------------------------------------------------------ |
|      presets | Presets for managing your presets.                           |
| coffeescript | Builds CoffeeScript source and test code for node and import targets. |
|      writeme | Builds YAML spec files into Markdown reference docs using WriteMe. |
|       retype | Configures and runs Retype, publishing to GitHub pages.      |
|      release | Builds, versions, and publishes a module.                    |
|          esm | Set up package.json to use ESM modules.                      |
|      license | Install a given license.                                     |
|       verify | Make sure a module is ready for release.                     |
|       update | Like verify, but tries to fix everything.                    |
|          pug | Compile pug into HTML or JavaScript functions.               |
|       server | Run a local server.                                          |

To use a preset, just load it from your task file, passing in your Genie module.

```coffeescript
import "coffeescript/register"
import * as t from "@dashkite/genie"
import preset from "@dashkite/genie-presets"

preset t, "coffeescript"
preset t, "writeme"
preset t, "retype"
preset t, "release"
```

You can also specify them in `genie.yaml`, along with any applicable options.

```yaml
presets:
	coffeescript:
		targets:
			- import
	verify: ~
  update: ~
	release: ~
```

You can also use the built-in `presets` mixin to add or remove them:

```sh
genie presets:add:esm
```

## coffeescript

|     Name | Description                                                  |
| -------: | ------------------------------------------------------------ |
|    build | Builds source and test files from `src` and `test` directories into the `build` directory. Builds to two targets: `node` and `import`, to corresponding subdirectories. |
|     test | Builds and run tests from the `build/` directory.            |
| dev:test | Runs tests from `test/` directly without building the source. (This is sometimes helpful for complex builds, where the build is relatively slow.) |
|    watch | Watch the `src/` and `test/` directory for changes and runs `build` in response. |
|    clean | Remove the `build` directory.                                |

### Options

| Name    | Type  | Description                                          |
| ------- | ----- | ---------------------------------------------------- |
| targets | Array | List of targets. Defaults to `[ "node", "import" ]`. |

## release

Usually what you want to run is something like:

```bash
genie release:patch
```

which will run all the subtasks necessary to do a full release. But sometimes, for whatever reason, you want to do the steps manually, in which case, this preset also provides subtask definitions for convenience.

**Important &rtri;** The *release* preset assumes that you have a `test` task defined (the *coffeescript* preset defines one, for example) and runs that before proceeding. That task should also perform a build, if necessary, and run tests against the build to ensure that the published code has been tested.

|                               Name | Description                                                  |
| ---------------------------------: | ------------------------------------------------------------ |
| release:**version**:**prerelease** | Does a patch release (test, version, publish, and push). Takes *version* and *prerelease* as arguments. Ex: `release:patch:alpha`. The *prerelease* argument is optional. |
|       release:version:*prerelease* | Versions the module: `npm version <level>`. Takes *version* and *prerelease* as arguments. Ex: `release:patch:alpha`. The *prerelease* argument is optional. |
|                    release:publish | Publishes to the NPM registry: `npm publish --access public`. |
|                       release:push | Pushes to git remote: `git push --follow-tags`.              |

### Options

- `version` - Arguments to pass to `npm version`.

## writeme

|       Name | Description                                                  |
| ---------: | ------------------------------------------------------------ |
| docs:build | Builds your Markdown files (into `docs/reference`) from your specs (`specs`). |
| docs:watch | Watches the `specs` directory for changes and runs `docs:build` in response. |
| docs:clean | Removes the `docs/reference` directory. **Important: ** Do not add files to this directory, since they’ll be removed on the next build. |

### Options

Currently takes no options.

## retype

|             Name | Description                                                  |
| ---------------: | ------------------------------------------------------------ |
| retype:configure | Sets up your Retype configuration for use locally and with GitHub pages. Requires the `RETYPE_LICENSE_KEY` environment variable be set. You will also need to add the license key to your GitHub secrets. |
|       site:build | Builds the site with Retype into the `.retype` directory. (This directory should be added to your `.gitignore`.) |
|       site:watch | Runs `doc:watch` if defined and runs Retype using your local configuration. |

### Options

Currently takes no options.

## esm

|            Name | Description                                                  |
| --------------: | ------------------------------------------------------------ |
|        esm:dual | Set up `node` and `import` targets in your `package.json`.   |
|   esm:dual:glob | Set up `node` and `import` glob targets in your `package.json`. |
|        esm:node | Set up `node` target in your `package.json`.                 |
|      esm:import | Set up `import` target in your `package.json`.               |
|   esm:node:glob | Set up `node` glob targets in your `package.json`.           |
| esm:import:glob | Set up `import` glob targets in your `package.json`.         |
|        esm:main | Set up `main` target in your `package.json`.                 |

### Options

Currently takes no options.

## license

|            Name | Description                         |
| --------------: | ----------------------------------- |
| license:ethical | Installs an ethical source license. |

### Options

Currently takes no options.

## verify
|                          Name | Description                                                  |
| ----------------------------: | ------------------------------------------------------------ |
|                        verify | Runs `verify:audit`, `verify:dependencies`, and `verify:license`. |
|                  verify:audit | Runs `npm audit`.                                            |
|           verify:dependencies | Runs `ncu`. You can install `ncu` by running `npm i -g npm-check-updates`. Runs `verify:dependencies:no-local` and `no-legacy` first. |
|                verify:license | Checks to make sure a license file exists and there’s a license entry in `package.json`. |
|  verify:dependencies:no-local | Checks for local dependencies (those starting with `file:`). |
| verify:dependencies:no-legacy | Checks for legacy dependencies.                              |

### Options

Currently takes no options.

