import requests # type: ignore
from django.conf import settings
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status

GROQ_API_KEY = settings.GROQ_API_KEY
GROQ_API_URL = settings.GROQ_API_URL

def send_message_to_groq(messages):
    system_prompt = "Bạn là chuyên gia về cây trồng, hãy trả lời bằng tiếng Việt. Câu hỏi của người dùng liên quan đến cây cà chua, hãy trả lời một cách tự nhiên và dễ hiểu nhất có thể."
    headers = {
        'Content-Type': 'application/json',
        'Authorization': f'Bearer {GROQ_API_KEY}',
    }
    final_messages = [{'role': 'system', 'content': system_prompt}] + messages

    data = {
        'model': 'llama3-70b-8192', 
        'messages': final_messages 
    }

    try:
        response = requests.post(GROQ_API_URL, json=data, headers=headers)

        if response.status_code == 200:
            response_data = response.json()
            return response_data['choices'][0]['message']['content']
        else:
            raise Exception('Failed to get response from Groq: ' + response.text)

    except requests.exceptions.RequestException as e:
        raise Exception('Error with the API request: ' + str(e))

class ChatbotView(APIView):
    def post(self, request):
        messages = request.data.get("messages", [])

        if not messages:
            return Response({"error": "Message is required."}, status=status.HTTP_400_BAD_REQUEST)

        try:
            response = send_message_to_groq(messages)
            return Response({"response": response}, status=status.HTTP_200_OK)

        except Exception as e:
            return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)