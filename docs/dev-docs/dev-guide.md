# Developer Guide

This is a guide for people who develop front-end applications.


## Chaise developer guide

Please take a look at [Chaise's dev guide](https://github.com/informatics-isi-edu/chaise/blob/master/docs/dev-docs/dev-guide.md) for information about best practices.

## Customizing this reposotiry

### Renaming the app

In this template, we're creating a `example` app. The main entry to the app is under `src/pages/example.tsx`. The file name `<>.tsx` is important. In the `webpack/main.config.js`, the `appName` that you're passing must be the same as this filename. 

So for example if you want to rename it to `myapp.tsx`, make sure to also change `appName` to `myapp`. The `appTitle` is just the title that will be displayed in the browser and can be any string that you want.


### Adding more apps

1. Start by creating a new file under `src/pages`. Let's say you've named it `new-app.tsx`. This file would be the entry point to your app. Take a look at `src/pages/example.tsx` as an example.
2. We now need to let `webpack` know that we want a separate bundle. To do so, open the `webpack/main.config.js` file.
3. The first parameter of `getWebPackConfig` is an array. Each element in this array configures an app. Please refer to [the Chaise code](https://github.com/informatics-isi-edu/chaise/blob/master/webpack/app.config.js#L7,L37) for more information. `appName` and `appTitle` are the only required properties:
    - `appName`: The filename that you chose in step 1.
    - `appTitle`: The title that you want browsers to display at the top of the tab or window.
