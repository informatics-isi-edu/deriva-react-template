# Installation

## Table of contents

- [Development dependencies](#development-dependencies)
- [Building and deploying](#building-and-deploying)
- [Local testing](#local-testing)

## Development dependencies

1. [make](https://en.wikipedia.org/wiki/Makefile): Make is required for any build or development. With `make` only the non-minified package can be built and installed.
2. [Node.js](https://www.nodejs.org): Node is required for most development operations including linting, minifying, and testing.
3. [NPM](https://docs.npmjs.com/downloading-and-installing-node-js-and-npm): used for installing dependencies used for both building and testing ERMrestJS.

## Building and deploying

To build the package, you must have `Node.js` installed and on your path. The build script will pull in all of the
dependencies into the `/dist/` directory. If you want to test this locally, please refer to [this section](#local-testing)


1. First, you need to ensure ermrestjs is installed on the server you're testing. If that's not the case, please follow [ermrestjs's installation guide](https://github.com/informatics-isi-edu/ermrestjs/blob/master/docs/user-docs/installation.md).

2. You need to setup some environment variables so we know where we should install the package. The following are the variables and their default values:

    ```sh
    WEB_URL_ROOT=/
    WEB_INSTALL_ROOT=/var/www/html/
    DERIVA_REACT_APP_REL_PATH=deriva-react-app/

    CHAISE_REL_PATH=chaise/
    ```
    Notes:
    - Which means deriva React app build folder will be copied to `/var/www/html/deriva-react-app/` location by default. And the URL path of the React apps under this repository would be `/deriva-react-app/APP_NAME/` where `APP_NAME` is the name that you've chosen for you app.
    - In [here](../dev-docs/dev-guide.md#recommended-location-for-the-apps) we discuss the recommended location for the apps and how we suggest setting `DERIVA_REACT_APP_REL_PATH` variable.

    Notes:
    - All the variables MUST have a trailing `/`.

    - If you're deploying remotely, since we're using the `WEB_INSTALL_ROOT` in `rsync` command, you can use a remote location `username@host:public_html/` for this variable.

    - A very silly thing to do would be to set your deployment directory to root `/` and run `make deploy` with `sudo`. This would be very silly indeed, and would probably result in some corruption of your operating system. Surely, no one would ever do this. But, in the off chance that one might attempt such silliness, the `make deploy` rule specifies a `dont_deploy_in_root` prerequisite that attempts to put a stop to any such silliness before it goes too far.


3. Build the bundles by running the following command:
    ```sh
    make dist
    ```

    Notes:
    - Make sure to run this command with the owner of the current folder. It will complain if you attempt to run this with a different user.
    - This command will also install the npm packages every time that is called. You can skip installing npm packages using the `make dist-wo-deps` command instead. If you want to install npm modules in a separate command, the following make targets are available:
      - `deps`: Install the dependencies based on `NODE_ENV` environment variable (it will skip `devDependencies` if `NODE_ENV` is not defined or is "production").
      - `npm-install-all-modules`: Install all dependencies, including `devDependencies` regardless of `NODE_ENV` value.



4. To deploy, you can use the `deploy` target:

    ```
    $ make deploy
    ```

    Notes:
      - If the given directory does not exist, it will first create it. So you may need to run `make deploy` with _super user_ privileges depending on the deployment directory you choose.
      -



## Local testing

By following the previous instructions and building the app, a new `dist` folder is created. And then, we deploy this folder into a desired location (remote or local). If you want to avoid deploying it on the server and want to build the files and test it locally, you can follow these steps instead:

> :warning: Testing this way has limitations as the features that require communication with server might not work as expected.

1. Ensure [Node.js](https://nodejs.org/en/) is installed on your machine. We recommend installing it with [nvm](https://github.com/nvm-sh/nvm), allowing you to switch between different versions easily.

2. You need to create a parent folder that, in the end, we can serve. All the repositories you will clone (including this one) must have the same parent folder and are siblings. In my case, I created a folder called "isrd":

    ```sh
    mkdir isrd
    cd isrd
    ```

3. Chaise apps assume that `ermrestjs` is installed in the same parent folder, and then you can use `ERMRESTJS_REL_PATH`, `CHAISE_REL_PATH`, and `DERIVA_REACT_APP_REL_PATH` to specify their location relative to this parent folder. Therefore we will clone `ermrestjs` in the same directory as this repository:

    ```sh
    git clone git@github.com:informatics-isi-edu/ermrestjs.git
    git clone git@github.com:informatics-isi-edu/deriva-react-template.git
    ```
    Notes:
      - You probably have created a separate repository from `deriva-react-template`. If that's the case, clone that repository instead.
      - If you've forked this repository, make sure you're cloning your forked repository instead.

4. Our build process can be customized by defining environment variables. The following is how you should define them for this local installation:

    ```sh
    export WEB_URL_ROOT=./../
    export DERIVA_REACT_APP_REL_PATH=
    export ERMRESTJS_REL_PATH=../../../ermrestjs/dist/
    export CHAISE_REL_PATH=../../../chaise/dist/
    ```

5. Use `echo` command to make sure these variables are correct, so

    ```sh
    echo $WEB_URL_ROOT
    echo $WEB_INSTALL_ROOT
    echo $ERMRESTJS_REL_PATH
    echo $CHAISE_REL_PATH
    ```
    This should print the defined values, not `/var/www/html` paths or empty values.

6. Build ermrestjs:

    ```sh
     cd ermrestjs
     make dist
     ```
     If this step was successful, you should see a `dist` folder under `ermrestjs` folder.


7. The previous steps are only needed for the initial setup; you don't need to repeat them when implementing deriva React app features. So now let's go to the deriva-react-template folder:

    ```sh
    cd ../deriva-react-template
    ```
    Notes:
      - You probably have created a separate repository from `deriva-react-template`. If that's the case, go to the proper folder.

8. While you can build deriva React apps with the same `make dist` command as ermrestjs, it will always reinstall npm packages. While developing features, it might be better to skip this step. That's why we directly install the dependencies and then use an alternative command to skip the reinstallation of npm packages. So run the following to install all the dependencies:

    ```sh
    make npm-install-all-modules
    ```

9. (optional) Properly define `NODE_ENV` depending on whether you want to install in "development" mode or "production":

    ```sh
    export NODE_ENV="production"
    ```
    - Use "production" mode by default. Use "development" mode only when you want to debug.
    - If this environment variable is not defined, it will default to "production" mode.

10. If you look at the `src/pages/example.tsx` implementation, you can see that we're using Chaise's `AppWrapper`. This will inject all the styles that we need. By default, it will also fetch the user session on load. We should skip that since we're testing locally, as that request will fail. So make sure to add `dontFetchSession` to the props of `AppWrapper`.

    ```tsx
    <AppWrapper ... dontFetchSession >
    ```

11. Build the app:

    ```sh
    make dist-wo-deps
    ```
    If this step was successful, you should see a `dist` folder.


12. You can now access the React app by opening the `deriva-react-template/dist/react/example/index.html` file in a browser. But this will give you a CORS error while fetching the data. To solve this, you need to serve the parent `isrd` folder we created using some server plugin. The simplest way to achieve this is using the [Live Server extension](https://marketplace.visualstudio.com/items?itemName=ritwickdey.LiveServer) of [VS code](https://code.visualstudio.com/). I highly recommend using VSCode for development in general. For this, follow the following steps:
    1. Install [VS Code](https://code.visualstudio.com/).
    2. Install [Live server extension](https://marketplace.visualstudio.com/items?itemName=ritwickdey.LiveServer)
    3. Open the `isi` folder in VS Code. I recommend creating a workspace based on this folder.
    4. You will see a "Go Live" button on the bottom right of VS Code. Click on it.
    5. It will open a browser and shows the content of `isrd` folder. Navigate to `deriva-react-template/dist/react/example`
    6. You should see the matrix app properly loaded.

13. If you change your local deriva-react-template, you must run `make dist-wo-deps`, which should create the new bundles for you.


