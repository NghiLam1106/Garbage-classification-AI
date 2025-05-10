# from django.contrib import admin
# from django.urls import path, include

# from rest_framework import permissions
# from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView

# urlpatterns = [
#     # path("admin/", admin.site.urls),
#     path("plant-disease/", include("hohotree_be.plant_disease.urls")),
#     path("auth/", include("hohotree_be.users.urls")),
#     path("auth/login/", TokenObtainPairView.as_view(), name="login"),
#     path("auth/refresh-token/", TokenRefreshView.as_view(), name="refresh_token"),
# ]

from django.urls import path, include # type: ignore
from src.payments.view import CreateMoMoPayment
from src.payments.callback import CallBackPayment
from src.plant_disease.views import predict_image
from src.chatbot.views import ChatbotView
from src.users.views import RegisterView, ActivateUserView, SupabaseLoginView, SupabaseRefreshTokenView

urlpatterns = [
    # Supabase Auth
    # path("auth/", include("src.users.urls")),
    # path("auth/register/", RegisterView.as_view(), name="register"),
    # path("auth/activate/<slug:token>/", ActivateUserView.as_view(), name="activate"),
    # path("auth/login/", SupabaseLoginView.as_view(), name="login"),
    # path("auth/refresh-token/", SupabaseRefreshTokenView.as_view(), name="refresh_token"),
    
    # # Plant disease
    # path("plant-disease/", include("src.plant_disease.urls")),
    # path("plant/", predict_image),

    # # Momo payment
    # path('create-momo/', CreateMoMoPayment.as_view(), name='create-momo'),
    # path('callback-momo/', CallBackPayment.as_view(), name='callback-momo'),

    # Chatbot
    path('chat/', ChatbotView.as_view(), name='chat_with_groq'),
]