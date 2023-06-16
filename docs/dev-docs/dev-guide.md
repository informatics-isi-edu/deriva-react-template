# Developer Guide

This is a guide for people who develop front-end applications.

## Table of contents

- [Chaise developer guide](#chaise-developer-guide)
- [Customizing this repository](#customizing-this-repository)
  - [Recommended location for the apps](#recommended-location-for-the-apps)
  - [Renaming the app](#renaming-the-app)
  - [Adding an app with a configuration file](#adding-an-app-with-a-configuration-file)
  - [Adding more apps](#adding-more-apps)

## Chaise developer guide

Please look at [Chaise's dev guide](https://github.com/informatics-isi-edu/chaise/blob/master/docs/dev-docs/dev-guide.md) for best practices.

## Customizing this repository

### Recommended location for the apps

As mentioned in [the installation guide](../user-docs/installation.md), you should specify where to deploy this repository using `DERIVA_REACT_APP_REL_PATH` envronment variable. This repository is designed to handle a collection of React applications. Therefore, with `DERIVA_REACT_APP_REL_PATH`, you're just describing the parent folder of bundles and all the apps defined in this repository. So if you didn't make any changes to the code or environment variables, the custom application will be accessible under `/deriva-react-app/example/` location.

In deriva, we would like to group all customized apps under the `/apps/` location (`/var/www/html/apps/`). We highly discourage defining `DERIVA_REACT_APP_REL_PATH` as the same folder as apps from other sources. This folder should only be designated for the apps described in this repository and nothing else. Therefore, you should define `DERIVA_REACT_APP_REL_PATH` in the `/apps/NAME/` format, where `NAME` describes this repository (your set of applications).

For example, you could do `/apps/graphs/` if all your apps show different graphs. And then, let's say you have a `gene` app in this repository, so your app would be accessible under `/app/graphs/gene/`.

### Renaming the app

In this template, we're creating an `example` app. The main entry to the app is under `src/pages/example.tsx`. The file name `<>.tsx` is important. In the `webpack/main.config.js`, the `appName` you're passing must be the same as this filename.

So, for example, if you want to rename it to `myapp.tsx`, make sure to also change `appName` to `myapp`. The `appTitle` is just the title displayed in the browser and can be any string you want.

### Adding an app with a configuration file

The `src/pages/example.tsx` defines a simple app that doesn't require any configuration. If your app needs configuration, please use the `src/pages/example-w-config.tsx` template.

Apart from the instructions in the [Renaming the app section](#renaming-the-app), you also need to do the following (let's assume our app name is going to be `matrix`):

- `config` folder is where the configuration files should reside. Assuming your app name is `matrix`, you should create a `matrix-config-sample.js` file under `config`. This file will act as an example. For actual deployments, you should rename this to `matrix-config.js`.
- The `matrix-config-sample.js` should define a `matrixConfigs` object. The keys in this object are "config name" and the value is the actual properties that are needed to configure the app (`*` is a special "config name" that will be used when the query parameter is missing). When an app is initiated, we use the value of `config` query parameter to match it with one of the "config name"s. For instance, in the existing `config/example-config-sample.js` file, if we go to `/matrix?config=config2`, the second configuration will be used.
- `src/utils/window-ref.ts` should be updated by removing the `exampleConfigs` and adding `matrixConfigs`.
- In the `src/models` folder, add a new `matrix-config.ts` file, and define your config's expected type.
- The main page component should be updated based on the changes described above.

### Adding more apps

1. Create a new file under `src/pages`. This file would be the entry point to your app. Let's say you've named it `new-app.tsx`. Look at `src/pages/example.tsx` as an example.
2. We now need to let `webpack` know we want a separate bundle. To do so, open the `webpack/main.config.js` file.
3. The first parameter of `getWebPackConfig` is an array. Each element in this array configures an app. Please refer to [the Chaise code](https://github.com/informatics-isi-edu/chaise/blob/master/webpack/app.config.js#L7,L37) for more information. `appName` and `appTitle` are the only required properties:
    - `appName`: The filename that you chose in step 1.
    - `appTitle`: The title you want browsers to display at the top of the tab or window.
