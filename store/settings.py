"""
Django settings for store project.

Generated by 'django-admin startproject' using Django 4.0.3.

For more information on this file, see
https://docs.djangoproject.com/en/4.0/topics/settings/

For the full list of settings and their values, see
https://docs.djangoproject.com/en/4.0/ref/settings/
"""

import os
from dotenv import load_dotenv
import braintree
import boto3
from boto3.session import Session
import ec2_metadata
from requests.exceptions import ReadTimeout
from urllib3.exceptions import ReadTimeoutError

# Build paths inside the project like this: BASE_DIR / 'subdir'.
BASE_DIR = os.path.dirname(os.path.dirname(__file__))

# For local only
load_dotenv(
    dotenv_path=os.path.join(
        BASE_DIR,
        '.env'
    )
)

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = bool(os.environ.get('DEBUG', 'False') == 'True')

try:
    default_region = ec2_metadata.EC2Metadata.region
except ReadTimeout:
    print(f"Not running in an EC2 instance: \n {ReadTimeout}")
except ReadTimeoutError:
    print(f"Not running in an EC2 instance: \n {ReadTimeoutError}")
finally:
    default_region = 'us-east-1'

if DEBUG:
    boto3_session = Session(
        profile_name=os.environ.get('AWS_PROFILE_NAME'),
        region_name=os.environ.get(
            'AWS_DEFAULT_REGION'
        )
    )
    ssm_client = boto3_session.client(service_name='ssm')
else:
    ssm_client = boto3.client(
        service_name='ssm',
        region_name=os.environ.get(
            'AWS_DEFAULT_REGION',
            default_region
        )
    )

ssm_prefix = '/donggiang_store'

# Braintree setting
# Merchant ID
BRAINTREE_MERCHANT_ID = os.environ.get(
    'BRAINTREE_MERCHANT_ID',
    ssm_client.get_parameter(
        Name=f"{ssm_prefix}/BRAINTREE_MERCHANT_ID",
        WithDecryption=True
    )['Parameter']['Value']
)
# Public Key
BRAINTREE_PUBLIC_KEY = os.environ.get(
    'BRAINTREE_PUBLIC_KEY',
    ssm_client.get_parameter(
        Name=f"{ssm_prefix}/BRAINTREE_PUBLIC_KEY",
        WithDecryption=True
    )['Parameter']['Value']
)
# Private key
BRAINTREE_PRIVATE_KEY = os.environ.get(
    'BRAINTREE_PRIVATE_KEY',
    ssm_client.get_parameter(
        Name=f"{ssm_prefix}/BRAINTREE_PRIVATE_KEY",
        WithDecryption=True
    )['Parameter']['Value']
)

BRAINTREE_CONF = braintree.Configuration(
    environment=braintree.Environment.Sandbox,
    merchant_id=BRAINTREE_MERCHANT_ID,
    public_key=BRAINTREE_PUBLIC_KEY,
    private_key=BRAINTREE_PRIVATE_KEY,
)

# Quick-start development settings - unsuitable for production
# See https://docs.djangoproject.com/en/4.0/howto/deployment/checklist/

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = os.environ.get(
    'DJANGO_SECRET_KEY',
    ssm_client.get_parameter(
        Name=f"{ssm_prefix}/DJANGO_SECRET_KEY",
        WithDecryption=True
    )['Parameter']['Value']
)

ALLOWED_HOSTS = ['*']

AUTH_USER_MODEL = 'users.CustomUser'

CART_SESSION_ID = 'cart'

# Security setting follows the `check --deploy`
SESSION_COOKIE_SECURE = True
CSRF_COOKIE_SECURE = True

CSRF_TRUSTED_ORIGINS = ['https://*', 'http://127.0.0.1:1337', 'http://localhost:1337']
CORS_ORIGIN_ALLOW_ALL = True

# Application definition

INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',

    # My app
    'shop',
    'users',
    'cart',
    'orders',
    'payment',
    'coupons',

    # 3rd-party app
    'health_check',
    'health_check.db',
    'health_check.storage',
    'health_check.contrib.celery',
    'health_check.contrib.migrations',
    'health_check.contrib.s3boto3_storage',
    'health_check.contrib.redis',
    'storages',
    'rest_framework',
    'rest_framework.authtoken',
    'django.contrib.sites',
    'allauth',
    'allauth.account',
    'allauth.socialaccount',
    'allauth.socialaccount.providers.facebook',
    'allauth.socialaccount.providers.twitter',
    'allauth.socialaccount.providers.google',
]

MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]

ROOT_URLCONF = 'store.urls'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [
            os.path.join(BASE_DIR, 'cart', 'templates'),
            os.path.join(BASE_DIR, 'orders', 'templates'),
            os.path.join(BASE_DIR, 'payment', 'templates'),
            os.path.join(BASE_DIR, 'shop', 'templates'),
        ],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
                'cart.context_processors.cart',
            ],
        },
    },
]

WSGI_APPLICATION = 'store.wsgi.application'

# Database
# https://docs.djangoproject.com/en/4.0/ref/settings/#databases

DATABASES = {
    'default': {
        'ENGINE': os.environ.get(
            'DATABASE_ENGINE',
            ssm_client.get_parameter(
                Name=f"{ssm_prefix}/DATABASE_ENGINE",
                WithDecryption=True
            )['Parameter']['Value']
        ),
        'NAME': os.environ.get(
            'DATABASE_NAME',
            ssm_client.get_parameter(
                Name=f"{ssm_prefix}/DATABASE_NAME",
                WithDecryption=True
            )['Parameter']['Value']
        ),
        # This options below for using with MySQL.
        # 'OPTIONS': {
        #     'init_command': "SET sql_mode='STRICT_ALL_TABLES'",
        # },
        'USER': os.environ.get(
            'DATABASE_USERNAME',
            ssm_client.get_parameter(
                Name=f"{ssm_prefix}/DATABASE_USERNAME",
                WithDecryption=True
            )['Parameter']['Value']
        ),
        'PASSWORD': os.environ.get(
            'DATABASE_PASSWORD',
            ssm_client.get_parameter(
                Name=f"{ssm_prefix}/DATABASE_PASSWORD",
                WithDecryption=True
            )['Parameter']['Value']
        ),
        'HOST': os.environ.get(
            'DATABASE_HOST',
            ssm_client.get_parameter(
                Name=f"{ssm_prefix}/DATABASE_HOST",
                WithDecryption=True
            )['Parameter']['Value']
        ),
        'PORT': os.environ.get(
            'DATABASE_PORT',
            ssm_client.get_parameter(
                Name=f"{ssm_prefix}/DATABASE_PORT",
                WithDecryption=True
            )['Parameter']['Value']
        ),
    }
}

REDIS_URL = os.environ.get('BROKER_URL', 'redis://localhost:6379/0')

# Password validation
# https://docs.djangoproject.com/en/4.0/ref/settings/#auth-password-validators

AUTH_PASSWORD_VALIDATORS = [
    {
        'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator',
    },
]

# Internationalization
# https://docs.djangoproject.com/en/4.0/topics/i18n/

LANGUAGE_CODE = 'en-us'

TIME_ZONE = 'UTC'

USE_I18N = True

USE_TZ = True

# Static files (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/4.0/howto/static-files/

USE_S3 = bool(os.environ.get('USE_S3', 'False') == 'True')

if USE_S3:
    # aws settings
    AWS_ACCESS_KEY_ID = os.environ.get(
        'AWS_ACCESS_KEY_ID',
        ssm_client.get_parameter(
            Name=f"{ssm_prefix}/AWS_ACCESS_KEY_ID",
            WithDecryption=True
        )['Parameter']['Value']
    )
    AWS_SECRET_ACCESS_KEY = os.environ.get(
        'AWS_SECRET_ACCESS_KEY',
        ssm_client.get_parameter(
            Name=f"{ssm_prefix}/AWS_SECRET_ACCESS_KEY",
            WithDecryption=True
        )['Parameter']['Value']
    )
    AWS_STORAGE_BUCKET_NAME = os.environ.get(
        'AWS_STORAGE_BUCKET_NAME',
        ssm_client.get_parameter(
            Name=f"{ssm_prefix}/AWS_STORAGE_BUCKET_NAME",
            WithDecryption=True
        )['Parameter']['Value']
    )
    AWS_DEFAULT_ACL = None
    AWS_S3_CUSTOM_DOMAIN = f'{AWS_STORAGE_BUCKET_NAME}.s3.amazonaws.com'
    AWS_S3_REGION_NAME = os.getenv('AWS_S3_REGION_NAME')
    AWS_S3_OBJECT_PARAMETERS = {'CacheControl': 'max-age=86400'}
    # s3 static settings
    STATIC_LOCATION = '/static/'
    STATIC_URL = f'https://{AWS_S3_CUSTOM_DOMAIN}/{STATIC_LOCATION}/'
    STATICFILES_STORAGE = 'store.storage_backends.StaticStorage'
    # s3 public media settings
    PUBLIC_MEDIA_LOCATION = '/media/'
    MEDIA_URL = f'https://{AWS_S3_CUSTOM_DOMAIN}/{PUBLIC_MEDIA_LOCATION}/'
    DEFAULT_FILE_STORAGE = 'store.storage_backends.PublicMediaStorage'
else:
    STATIC_URL = '/static/'
    STATIC_ROOT = os.path.join(BASE_DIR, "static_cdn", "static_root")
    MEDIA_URL = '/media/'
    MEDIA_ROOT = os.path.join(BASE_DIR, "static_cdn", "media_root")

# Default primary key field type
# https://docs.djangoproject.com/en/4.0/ref/settings/#default-auto-field

DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'

# django-allauth
ACCOUNT_USER_MODEL_USERNAME_FIELD = None
ACCOUNT_EMAIL_REQUIRED = True
ACCOUNT_UNIQUE_EMAIL = True
ACCOUNT_USERNAME_REQUIRED = False
ACCOUNT_AUTHENTICATION_METHOD = 'email'
ACCOUNT_EMAIL_VERIFICATION = 'mandatory'
ACCOUNT_CONFIRM_EMAIL_ON_GET = True
ACCOUNT_EMAIL_CONFIRMATION_ANONYMOUS_REDIRECT_URL = '/?verification=1'
ACCOUNT_EMAIL_CONFIRMATION_AUTHENTICATED_REDIRECT_URL = '/?verification=1'

SITE_ID = 1
SOCIALACCOUNT_PROVIDERS = {
    'google': {
        'APP': {
            'client_id': os.environ.get(
                'GOOGLE_CLIENT_ID',
                ssm_client.get_parameter(
                    Name=f"{ssm_prefix}/GOOGLE_CLIENT_ID",
                    WithDecryption=True
                )['Parameter']['Value']
            ),
            'secret': os.environ.get(
                'GOOGLE_SECRET',
                ssm_client.get_parameter(
                    Name=f"{ssm_prefix}/GOOGLE_SECRET",
                    WithDecryption=True
                )['Parameter']['Value']
            ),
            'key': ''
        },
        'SCOPE': [
            'profile',
            'email',
        ],
        'AUTH_PARAMS': {
            'access_type': 'offline',
        },
        'OAUTH_PKCE_ENABLED': True,
    }
}

# Set up authentication backend
AUTHENTICATION_BACKENDS = [
    # Needed to log in by username in Django admin, regardless of `allauth`
    'django.contrib.auth.backends.ModelBackend',

    # `allauth` specific authentication methods, such as login by e-mail
    'allauth.account.auth_backends.AuthenticationBackend',
]
LOGIN_REDIRECT_URL = '/'

# EMAIL_BACKEND = 'django.core.mail.backends.console.EmailBackend'
EMAIL_BACKEND = 'django.core.mail.backends.smtp.EmailBackend'
EMAIL_HOST = 'smtp.gmail.com'
EMAIL_HOST_USER = os.environ.get(
    'EMAIL_HOST_USER',
    ssm_client.get_parameter(
        Name=f"{ssm_prefix}/EMAIL_HOST_USER",
        WithDecryption=True
    )['Parameter']['Value']
)
EMAIL_HOST_PASSWORD = os.environ.get(
    'EMAIL_HOST_PASSWORD',
    ssm_client.get_parameter(
        Name=f"{ssm_prefix}/EMAIL_HOST_PASSWORD",
        WithDecryption=True
    )['Parameter']['Value']
)
EMAIL_PORT = 587
EMAIL_USE_TLS = True
