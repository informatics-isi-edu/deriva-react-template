import { ICustomWindow } from '@isrd-isi-edu/chaise/src/utils/window-ref';

import { ExampleConfig } from '@isrd-isi-edu/deriva-react-app/src/models/example-config';

interface WebAppCustomWindow extends ICustomWindow {
  exampleConfigs: ExampleConfig;
}

declare let window: WebAppCustomWindow;

export const windowRef = window;
