import os.path

from .base import *  # noqa

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': os.path.join(SITE_ROOT, 'dev.db'),
    }
}

REDIS = {
    'host': '0.0.0.0',
    'port': 6379,
    'db': 0,
}
ALLOW_PRIVATE_REPOS = "ALLOW_PRIVATE_REPOS" in os.environ

BROKER_URL = 'redis://0.0.0.0:6379/0'
CELERY_RESULT_BACKEND = 'redis://0.0.0.0:6379/0'
#CELERY_ALWAYS_EAGER = False


SESSION_COOKIE_DOMAIN = None
SESSION_COOKIE_HTTPONLY = False
CACHE_BACKEND = 'dummy://'

SLUMBER_USERNAME = 'test'
SLUMBER_PASSWORD = 'test'
SLUMBER_API_HOST = 'http://0.0.0.0:8000'
#GROK_API_HOST = 'http://0.0.0.0:5555'
PRODUCTION_DOMAIN = '0.0.0.0:8000'

WEBSOCKET_HOST = '0.0.0.0:8088'

HAYSTACK_CONNECTIONS = {
    'default': {
        'ENGINE': 'haystack.backends.simple_backend.SimpleEngine',
    },
}

IMPORT_EXTERNAL_DATA = False
DONT_HIT_DB = False
NGINX_X_ACCEL_REDIRECT = True

CELERY_ALWAYS_EAGER = True
EMAIL_BACKEND = 'django.core.mail.backends.console.EmailBackend'
FILE_SYNCER = 'privacy.backends.syncers.LocalSyncer'

# For testing locally. Put this in your /etc/hosts:
# 127.0.0.1 test
# and navigate to http://test:8000
CORS_ORIGIN_WHITELIST = (
    'test:8000',
)

try:
    from local_settings import *  # noqa
except ImportError:
    pass