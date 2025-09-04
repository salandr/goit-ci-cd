from django.apps import AppConfig

class TestappConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'testapp'

    def ready(self):
        from django.db.models.signals import post_migrate
        from .signals import init_data
        post_migrate.connect(init_data, sender=self)
