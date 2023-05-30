import '@isrd-isi-edu/deriva-react-app/src/assets/scss/example.scss';

import { createRoot } from 'react-dom/client';
import AppWrapper from '@isrd-isi-edu/chaise/src/components/app-wrapper';
import { ID_NAMES } from '@isrd-isi-edu/chaise/src/utils/constants';

import ExampleComponent from '@isrd-isi-edu/deriva-react-app/src/components/example';

const myappSettings = {
  appName: 'app/sample',
  appTitle: 'Sample App',
  overrideHeadTitle: false,
  overrideImagePreviewBehavior: false,
  overrideDownloadClickBehavior: false,
  overrideExternalLinkBehavior: false
};

const MyApp = (): JSX.Element => {
  return (
    <div className='example-app-container'>
      <h1>Example app</h1>

      <ExampleComponent />

    </div>
  )
};

const root = createRoot(document.getElementById(ID_NAMES.APP_ROOT) as HTMLElement);

// TODO if testing locally, you can add dontFetchSession to skip the authn request
root.render(
  <AppWrapper appSettings={myappSettings} includeNavbar displaySpinner ignoreHashChange>
    <MyApp />
  </AppWrapper>
);
