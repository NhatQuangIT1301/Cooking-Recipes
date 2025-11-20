import { lazy } from 'react';

import AdminLayout from 'layouts/AdminLayout';
import AuthLayout from '../layouts/AuthLayout';

const DashboardSales = lazy(() => import('../views/dashboard/index'));

const Recipes = lazy(() => import('../views/recipes/index'));
const Ingredients = lazy(() => import('../views/ingredients/index'));
const ManageUsers = lazy(() => import('../views/manage_users/index'));

const Typography = lazy(() => import('../views/ui-elements/basic/BasicTypography'));
const Color = lazy(() => import('../views/ui-elements/basic/BasicColor'));

const FeatherIcon = lazy(() => import('../views/ui-elements/icons/Feather'));
const FontAwesome = lazy(() => import('../views/ui-elements/icons/FontAwesome'));
const MaterialIcon = lazy(() => import('../views/ui-elements/icons/Material'));

const Profile = lazy(() => import('../views/profile/index'));
const Login = lazy(() => import('../views/auth/login'));


const MainRoutes = {
  path: '/',
  children: [
    {
      path: '/',
      element: <AdminLayout />,
      children: [
        {
          path: '/',
          element: <DashboardSales />
        },
        {
          path: '/typography',
          element: <Typography />
        },
        {
          path: '/color',
          element: <Color />
        },
        {
          path: '/icons/Feather',
          element: <FeatherIcon />
        },
        {
          path: '/icons/font-awesome-5',
          element: <FontAwesome />
        },
        {
          path: '/icons/material',
          element: <MaterialIcon />
        },
        {
          path: '/recipes',
          element: <Recipes />
        },
        {
          path: '/ingredients',
          element: <Ingredients />
        },
        {
          path: '/manage-users',
          element: <ManageUsers />
        },
        {
          path: '/profile',
          element: <Profile />
        }
      ]
    },
    {
      path: '/',
      element: <AuthLayout />,
      children: [
        {
          path: '/login',
          element: <Login />
        }
      ]
    }
  ]
};

export default MainRoutes;
