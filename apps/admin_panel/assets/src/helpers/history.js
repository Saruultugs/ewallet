import { createBrowserHistory } from 'history';
import { ADMIN_PANEL_BASENAME } from '../omisego/config';

export default createBrowserHistory({ basename: ADMIN_PANEL_BASENAME });
