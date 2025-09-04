from .models import Message

def init_data(sender, **kwargs):
    if not Message.objects.exists():
        Message.objects.create(text="Hi from PostgreSQL!")
