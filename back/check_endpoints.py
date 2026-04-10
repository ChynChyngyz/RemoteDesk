"""
QA Endpoint Tester — Tests all org-level API endpoints.
Usage:  ..\venv\Scripts\python test_endpoints.py <phone> <password>

It will:
  1. Login via /api/v1/auth/login/ to obtain a JWT access token.
  2. GET /api/v1/auth/me/ to identify the user's org.
  3. Hit every org endpoint (devices, incidents, tickets, audit, notifications, metrics, alert-rules)
     and report HTTP status + short body summary.
  4. Also test the Swagger schema endpoint itself (/api/v1/schema/).
"""

import sys
import requests

BASE = "http://127.0.0.1:8000/api/v1"

def green(s):  return f"\033[92m{s}\033[0m"
def red(s):    return f"\033[91m{s}\033[0m"
def yellow(s): return f"\033[93m{s}\033[0m"

def test_get(session, url, label):
    try:
        r = session.get(url, timeout=10)
        status = r.status_code
        if 200 <= status < 300:
            body = r.json() if r.headers.get("content-type","").startswith("application/json") else r.text[:80]
            count = len(body) if isinstance(body, list) else "obj"
            print(f"  {green('PASS')} [{status}] {label:35s}  items={count}")
        else:
            print(f"  {red('FAIL')} [{status}] {label:35s}  body={r.text[:120]}")
    except Exception as e:
        print(f"  {red('ERR ')}        {label:35s}  {e}")

def main():
    if len(sys.argv) < 3:
        print("Usage: python test_endpoints.py <phone> <password>")
        sys.exit(1)

    phone, password = sys.argv[1], sys.argv[2]

    # ── 1. Login ───────────────────────────────────────────────
    print(f"\n{'='*60}")
    print(f"  Logging in as {phone}...")
    print(f"{'='*60}")
    r = requests.post(f"{BASE}/auth/login/", json={"phone": phone, "password": password})
    if r.status_code != 200:
        print(red(f"  Login FAILED [{r.status_code}]: {r.text[:200]}"))
        sys.exit(1)
    tokens = r.json()
    access = tokens.get("access")
    print(green(f"  Login OK — access token obtained"))

    s = requests.Session()
    s.headers.update({"Authorization": f"Bearer {access}", "Content-Type": "application/json"})

    # ── 2. Identify user ──────────────────────────────────────
    print(f"\n{'='*60}")
    print(f"  Identifying current user...")
    print(f"{'='*60}")
    test_get(s, f"{BASE}/auth/me/", "/auth/me/")

    me = s.get(f"{BASE}/auth/me/").json()
    org = me.get("organization")
    org_id = org.get("id") if org else None
    print(f"  User: {me.get('phone')}  Role: {me.get('role')}  OrgId: {org_id}")

    # ── 3. Test org endpoints ──────────────────────────────────
    print(f"\n{'='*60}")
    print(f"  Testing org-level GET endpoints...")
    print(f"{'='*60}")

    endpoints = [
        (f"{BASE}/orgs/devices/",                 "GET /orgs/devices/"),
        (f"{BASE}/orgs/incidents/",                "GET /orgs/incidents/"),
        (f"{BASE}/orgs/tickets/",                  "GET /orgs/tickets/"),
        (f"{BASE}/orgs/audit/",                    "GET /orgs/audit/"),
        (f"{BASE}/orgs/notifications/",            "GET /orgs/notifications/"),
        (f"{BASE}/orgs/alert-rules/",              "GET /orgs/alert-rules/"),
        (f"{BASE}/orgs/metrics/?organization={org_id}", "GET /orgs/metrics/?organization=<id>"),
    ]
    for url, label in endpoints:
        test_get(s, url, label)

    # ── 4. Test org detail (if org exists) ─────────────────────
    if org_id:
        print(f"\n{'='*60}")
        print(f"  Testing detail/retrieve endpoints...")
        print(f"{'='*60}")
        test_get(s, f"{BASE}/orgs/organizations/{org_id}/", f"GET /orgs/organizations/{org_id}/")

    # ── 5. Test Swagger schema ─────────────────────────────────
    print(f"\n{'='*60}")
    print(f"  Testing Swagger schema generation...")
    print(f"{'='*60}")
    try:
        r = requests.get(f"{BASE}/schema/", timeout=10)
        if r.status_code == 200:
            print(f"  {green('PASS')} [{r.status_code}] /schema/  (OpenAPI YAML, {len(r.text)} bytes)")
        else:
            print(f"  {red('FAIL')} [{r.status_code}] /schema/")
    except Exception as e:
        print(f"  {red('ERR ')} /schema/  {e}")

    print(f"\n{'='*60}")
    print(green("  All tests completed!"))
    print(f"{'='*60}\n")

if __name__ == "__main__":
    main()
