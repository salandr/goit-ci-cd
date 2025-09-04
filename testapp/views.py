from django.http import HttpResponse
from .models import Message

def show_message(request):
    msg = Message.objects.first()
    if msg:
        return HttpResponse(f"Mesage from db: {msg.text}")
    return HttpResponse("No messages")
