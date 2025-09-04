from django.contrib import admin
from django.urls import path
from testapp.views import show_message

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', show_message),
]
