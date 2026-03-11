# remote/consumers.py

from channels.generic.websocket import AsyncWebsocketConsumer

class SignalConsumer(AsyncWebsocketConsumer):

    async def connect(self):
        self.room = self.scope["url_route"]["kwargs"]["room"]
        self.group = f"room_{self.room}"

        await self.channel_layer.group_add(
            self.group,
            self.channel_name
        )

        await self.accept()

    async def disconnect(self, close_code):

        await self.channel_layer.group_discard(
            self.group,
            self.channel_name
        )

    async def receive(self, text_data):

        await self.channel_layer.group_send(
            self.group,
            {
                "type": "signal",
                "data": text_data
            }
        )

    async def signal(self, event):

        await self.send(text_data=event["data"])