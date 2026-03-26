# orgs/serializers.py
from rest_framework import serializers
from .models import TicketComment



class TicketCommentSerializers(serializers.ModelSerializer):
    class Meta:
        model = TicketComment
        fields = ['ticket', 'author', 'body', 'created_at']