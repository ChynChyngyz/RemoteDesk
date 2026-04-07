# remote/consumers.py

from urllib.parse import parse_qs
from channels.generic.websocket import AsyncWebsocketConsumer

class SignalConsumer(AsyncWebsocketConsumer):

    async def connect(self):
        user = self.scope["user"]
        self.room_group_name = None

        print(f"[WS DEBUG] Попытка подключения. Пользователь: {user}, Авторизован: {user.is_authenticated}")
        if not user.is_authenticated:
            print("[WS DEBUG] Отклонено: Пользователь не авторизован")
            await self.close()
            return

        self.room = self.scope["url_route"]["kwargs"]["room"]
        print(f"[WS DEBUG] ID комнаты: {self.room}")

        # ==========================================
        # ВРЕМЕННЫЙ ХАК ДЛЯ CHROME
        # ==========================================
        if self.room == "chrome":
            self.room_group_name = f"room_{self.room}"
            await self.channel_layer.group_add(
                self.room_group_name,
                self.channel_name
            )
            await self.accept()
            print("[WS DEBUG] УСПЕХ: Тестовое подключение к комнате chrome установлено!")
            return
        # ==========================================

        from .models import RemoteSession
        try:
            session = await RemoteSession.objects.aget(id=self.room)
        except RemoteSession.DoesNotExist:
            print(f"[WS DEBUG] Отклонено: Сессия {self.room} не найдена в БД")
            await self.close()
            return
        except ValueError:
            print(f"[WS DEBUG] Отклонено: Неверный формат ID комнаты (ожидалось число, получено '{self.room}')")
            await self.close()
            return

        if session.requester_user_id != user.id:
            print(
                f"[WS DEBUG] Отклонено: ID пользователя ({user.id}) не совпадает с создателем сессии ({session.requester_user_id})")
            await self.close()
            return

        query = parse_qs(self.scope["query_string"].decode())
        token = query.get("token")

        if not token or token[0] != session.access_token:
            print("[WS DEBUG] Отклонено: Токен не передан или не совпадает")
            await self.close()
            return

        self.room_group_name = f"room_{self.room}"

        await self.channel_layer.group_add(
            self.room_group_name,
            self.channel_name
        )
        await self.accept()
        print("[WS DEBUG] УСПЕХ: Соединение установлено")

    async def disconnect(self, close_code):
        if getattr(self, "room_group_name", None):
            await self.channel_layer.group_discard(
                self.room_group_name,
                self.channel_name
            )

    async def receive(self, text_data):
        if getattr(self, "room_group_name", None):
            await self.channel_layer.group_send(
                self.room_group_name,
                {
                    "type": "signal",
                    "sender": self.channel_name,
                    "data": text_data
                }
            )

    async def signal(self, event):
        if event.get("sender") == self.channel_name:
            return

        await self.send(text_data=event["data"])