import os
from celery import Celery

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'store.settings')

app = Celery('store')

app.config_from_object('django.conf:settings', namespace='CELERY')
app.autodiscover_tasks()
app.conf.broker_url = 'redis://localhost:6379/0'
app.conf.update(
	worker_pool_restarts=True
)
