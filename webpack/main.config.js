const { getWebPackConfig } = require('@isrd-isi-edu/chaise/webpack/app.config');
const path = require('path');

// if NODE_DEV defined properly, uset it. otherwise set it to production.
const nodeDevs = ['production', 'development'];
let mode = process.env.NODE_ENV;
if (nodeDevs.indexOf(mode) === -1) {
  mode = nodeDevs[0];
}

const rootFolderLocation = path.resolve(__dirname, '..');
const resolveAliases = { '@isrd-isi-edu/deriva-react-app': rootFolderLocation };

module.exports = (env) => {

  const BASE_PATH = env.BUILD_VARIABLES.DERIVA_REACT_APP_BASE_PATH;
  return getWebPackConfig(
    [
      {
        appName: 'example',
        appTitle: 'Example app',
      }
    ],
    mode,
    env,
    { rootFolderLocation, resolveAliases, urlBasePath: BASE_PATH }
  );
};