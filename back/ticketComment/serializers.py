# # ticketComment/serializers.py

from rest_framework import serializers
from .models import TicketComment



class TicketCommentSerializers(serializers.ModelSerializer):
    class Meta:
        model = TicketComment
        fields = ['id', 'ticket', 'author', 'body', 'created_at']
        read_only_fields = ['id', 'ticket', 'author', 'created_at']