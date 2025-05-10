"""
Settings for local development environment.
"""

from .common import *

# Quick-start development settings - unsuitable for production
# See https://docs.djangoproject.com/en/3.2/howto/deployment/checklist/

DEBUG = True

SECRET_KEY = "django-insecure-*$0b8ibx7uzk45cm+fxw7*jj(yzi2ye!l4+!dnyxa-u-nbuz=q"

ALLOWED_HOSTS = ["*"]

HOST = "http://localhost:8000/"

# Database
SUPABASE_URL = "https://kyyiekngpfhpoldvlpmq.supabase.co"
SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imt5eWlla25ncGZocG9sZHZscG1xIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc0MzY4Nzc0NywiZXhwIjoyMDU5MjYzNzQ3fQ.L8HWR-MPEKNnRDuqqEQ92QdtKnqZiMOW16ev9UjOX2E"

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': 'postgres', 
        'USER': 'postgres.kyyiekngpfhpoldvlpmq',
        'PASSWORD': 'th123456789th12345678',
        'HOST': 'aws-0-ap-southeast-1.pooler.supabase.com',
        'PORT': '6543',
    }
}


# CORS
CORS_ALLOWED_ORIGINS = ["http://localhost:8000"]

#groq
GROQ_API_URL = 'https://api.groq.com/openai/v1/chat/completions'
GROQ_API_KEY = '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'