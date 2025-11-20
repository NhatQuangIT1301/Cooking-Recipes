import { lazy } from 'react';
import { createBrowserRouter } from 'react-router-dom';

// project import
import MainRoutes from './MainRoutes';

// render - landing page

// ==============================|| ROUTING RENDER ||============================== //

const router = createBrowserRouter(
  [
    MainRoutes
  ],
  { basename: import.meta.env.VITE_APP_BASE_NAME }
);

export default router;
