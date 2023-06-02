import '@isrd-isi-edu/deriva-react-app/src/assets/scss/example.scss';
import { createRoot } from 'react-dom/client';

// components
import ExampleComponent from '@isrd-isi-edu/deriva-react-app/src/components/example';
import AppWrapper from '@isrd-isi-edu/chaise/src/components/app-wrapper';
import ChaiseSpinner from '@isrd-isi-edu/chaise/src/components/spinner';

// hooks
import useError from '@isrd-isi-edu/chaise/src/hooks/error';
import { useEffect, useState } from 'react';

// models
import { ExampleConfig } from '@isrd-isi-edu/deriva-react-app/src/models/example-config';

// utils
import { ID_NAMES } from '@isrd-isi-edu/chaise/src/utils/constants';
import { getConfigObject } from '@isrd-isi-edu/deriva-react-app/src/utils/config';
import { windowRef } from '@isrd-isi-edu/deriva-react-app/src/utils/window-ref';

const myappSettings = {
  appName: 'app/sample',
  appTitle: 'Sample App',
  overrideHeadTitle: false,
  overrideImagePreviewBehavior: false,
  overrideDownloadClickBehavior: false,
  overrideExternalLinkBehavior: false
};

const MyApp = (): JSX.Element => {
  const { dispatchError, errors } = useError();

  const [appConfig, setAppConfig] = useState<ExampleConfig | null>(null);

  useEffect(() => {
    try {
      const config = getConfigObject(windowRef.exampleConfigs);
      setAppConfig(config);
    } catch (error) {
      dispatchError({ error });
    }
  }, [windowRef.exampleConfigs, dispatchError]);

  // if there was an error during setup, hide the spinner
  if (!appConfig && errors.length > 0) {
    return <></>;
  }

  // show spinner while waiting for the config
  if (!appConfig) {
    return <ChaiseSpinner />;
  }

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
