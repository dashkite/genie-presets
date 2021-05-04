# Genie Presets

Defines presets for the Genie task runner. Probably most useful for DashKite internal development.

The available presets are:

- `coffeescript`: Builds CoffeeScript source and test code for node and import targets.
- `writeme`: Builds YAML spec files into Markdown reference docs using WriteMe.
- `retype`: Configures and runs Retype, publishing to GitHub pages.

The tasks made available for each preset are described below.

To use a preset, just load it from your task file, passing in your Genie module.

```coffeescript
import "coffeescript/register"
import * as t from "@dashkite/genie"
import preset from "@dashkite/genie-presets"

preset t, "coffeescript"
preset t, "writeme"
preset t, "retype"
```

## coffeescript

| Task Name  | Description                                                  |
| ---------- | ------------------------------------------------------------ |
| build      | Builds source and test files from `src` and `test` directories into the `build` directory. Builds to two targets: `node` and `import`, to corresponding subdirectories. |
| test       | Runs tests in `src/index.coffee` without building the source. |
| node:test  | Runs tests from the `build` directory.                       |
| watch      | Watch the `src` directory for changes and runs `build` in response. |
| test:watch | Wath the `test` directory for changes and runs `build` in response. |
| clean      | Remove the `build` directory.                                |

### Options

The `coffeescript` preset currently takes no options.

## writeme

| Task Name  | Description                                                  |
| ---------- | ------------------------------------------------------------ |
| docs:build | Builds your Markdown files (into `docs/reference`) from your specs (`specs`). |
| docs:watch | Watches the `specs` directory for changes and runs `docs:build` in response. |
| docs:clean | Removes the `docs/reference` directory. **Important: ** Do not add files to this directory, since they’ll be removed on the next build. |

### Options

The `writeme` preset currently takes no options.

## retype

| Task Name        | Description                                                  |
| ---------------- | ------------------------------------------------------------ |
| retype:configure | Sets up your Retype configuration for use locally and with GitHub pages. Requires the `RETYPE_LICENSE_KEY` environment variable be set. You will also need to add the license key to your GitHub secrets. |
| site:build       | Builds the site with Retype into the `.retype` directory. (This directory should be added to your `.gitignore`.) |
| site:watch       | Runs `doc:watch` if defined and runs Retype using your local configuration. |

### Options

The `retype` preset currently takes no options.