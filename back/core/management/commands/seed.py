import random
from faker import Faker
from django.core.management.base import BaseCommand
from django.utils import timezone
from datetime import timedelta

from orgs.models import Organization
from authUser.models import CustomUser
from devices.models import Device
from alert.models import AlertRule
from incident.models import Incident
from metricSample.models import MetricSample
from notifications.models import Notification
from audit.models import AuditEvent
from tickets.models import Ticket
from ticketComment.models import TicketComment
from remote.models import RemoteSession
from agent.utils import create_agent_key

class Command(BaseCommand):
    help = 'Seeds the database with robust fake data for RemoteDesk application.'

    def handle(self, *args, **kwargs):
        fake = Faker()
        
        self.stdout.write("Clearing existing data...")
        CustomUser.objects.exclude(phone="+10000000000").delete() # keep optionally some superuser
        Organization.objects.all().delete()
        
        self.stdout.write("Seeding Organizations, Users, and Devices...")
        
        roles = [CustomUser.Role.ORG_ADMIN, CustomUser.Role.TECHNICIAN, CustomUser.Role.CLIENT_VIEWER]
        
        for i in range(2): # 2 organizations
            org = Organization.objects.create(name=f"{fake.company()} IT Solutions")
            
            # Create Users for this Org
            org_users = []
            for role in roles:
                user = CustomUser.objects.create_user(
                    phone=f"+{fake.msisdn()[:11]}",
                    password="password123", # standard password for all seeded users
                    role=role,
                    organization=org
                )
                org_users.append(user)
                if role == CustomUser.Role.ORG_ADMIN:
                    admin_user = user
                elif role == CustomUser.Role.TECHNICIAN:
                    tech_user = user
                elif role == CustomUser.Role.CLIENT_VIEWER:
                    client_user = user
                    
            # 5-10 devices
            num_devices = random.randint(5, 10)
            org_devices = []
            for d in range(num_devices):
                dev = Device.objects.create(
                    organization=org,
                    hostname=f"PC-{fake.word().upper()}-{d}",
                    os=random.choice(["Windows", "Linux", "macOS"]),
                    os_version=random.choice(["10", "11", "Ubuntu 22", "Monterey"]),
                    serial=fake.uuid4()[:8],
                    ip=fake.ipv4(),
                    status="ONLINE",
                    agent_version="v2.0",
                    last_seen_at=timezone.now() - timedelta(minutes=random.randint(1, 60))
                )
                org_devices.append(dev)
                create_agent_key(dev)
            
            self.stdout.write(f"Organization '{org.name}' created with {num_devices} devices.")
            
            # Seed AlertRules
            rules = []
            for m in ['cpu_pct', 'ram_pct', 'disk_free_gb']:
                rule = AlertRule.objects.create(
                    organization=org,
                    metric=m,
                    operator='>',
                    threshold=random.uniform(80.0, 95.0),
                    duration_sec=300,
                    severity='high'
                )
                rules.append(rule)
                
            # Seed Incidents
            incidents = []
            for d in org_devices[:3]: 
                inc = Incident.objects.create(
                    organization=org,
                    device=d,
                    rule=random.choice(rules),
                    severity='high',
                    status=random.choice(['OPEN', 'ACKNOWLEDGED', 'RESOLVED'])
                )
                incidents.append(inc)
                
            # Seed Metrics Samples
            for d in org_devices:
                for _ in range(5):
                    MetricSample.objects.create(
                        device=d,
                        ts=timezone.now() - timedelta(minutes=random.randint(1, 60)),
                        cpu_pct=random.randint(10, 95),
                        ram_pct=random.randint(20, 85),
                        disk_free_gb=random.randint(10, 500),
                        uptime_sec=random.randint(1000, 100000)
                    )

            # Seed Tickets & Comments
            for _ in range(7):
                ticket = Ticket.objects.create(
                    organization=org,
                    device=random.choice(org_devices),
                    incident=random.choice(incidents) if random.choice([True, False]) else None,
                    title=fake.sentence(),
                    description=fake.paragraph(),
                    assignee_user=tech_user if random.choice([True, False]) else None,
                    priority=random.choice(["low", "medium", "high"]),
                    status=random.choice(["open", "in_progress", "closed"])
                )
                
                # Ticket Comments
                for _ in range(random.randint(1, 3)):
                    TicketComment.objects.create(
                        ticket=ticket,
                        author=random.choice([tech_user, client_user]),
                        body=fake.sentence()
                    )
                    
            # Seed Notifications
            for u in org_users:
                for _ in range(5):
                    Notification.objects.create(
                        user=u,
                        type='ticket_updated',
                        payload_json={"ticket_id": ticket.id, "message": "Update available"}
                    )
            
            # Seed Audit Events
            for _ in range(5):
                AuditEvent.objects.create(
                    organization=org,
                    actor_user=admin_user,
                    type='agent_token_issued',
                    metadata_json={"ip": fake.ipv4()}
                )
                
            # Seed Remote Session
            RemoteSession.objects.create(
                organization=org,
                device=random.choice(org_devices),
                requester_user=tech_user,
                status="ended",
                consent_method="manual",
                access_token=fake.uuid4(),
                started_at=timezone.now() - timedelta(minutes=30),
                ended_at=timezone.now() - timedelta(minutes=10)
            )

        self.stdout.write(self.style.SUCCESS("Successfully seeded the database!"))
        self.stdout.write("\n===============================")
        self.stdout.write("Credentials to login:")
        self.stdout.write(f"Phone: {org_users[0].phone} (Role: {org_users[0].role})")
        self.stdout.write(f"Phone: {org_users[1].phone} (Role: {org_users[1].role})")
        self.stdout.write(f"Phone: {org_users[2].phone} (Role: {org_users[2].role})")
        self.stdout.write("Password (for all): password123")
        self.stdout.write("===============================\n")
