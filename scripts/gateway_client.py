#!/usr/bin/env python3
"""CLI-Wrapper um die IBKR Client Portal Web API des eigenen Gateways.

Einziger Zweck: dem execution-trader-Subagenten eine schmale, geprüfte
Schnittstelle statt roher curl-Aufrufe zu geben. Kein anderer Agent sollte
dieses Skript aufrufen - Order-Ausführung bleibt an einer Stelle gebündelt.

Alle Preis-/Mengenangaben sind Vorschläge des aufrufenden Agenten; dieses
Skript validiert nur das Format, nicht die Handelsstrategie.

Env:
  GATEWAY_URL   Basis-URL des deployten Gateways, z.B.
                https://ib-gateway-paper.onrender.com
"""
import argparse
import json
import os
import sys

import requests

BASE_URL = os.environ.get("GATEWAY_URL", "http://localhost:5000")


def _get(path, **params):
    r = requests.get(f"{BASE_URL}{path}", params=params, timeout=15)
    r.raise_for_status()
    return r.json()


def _post(path, body):
    r = requests.post(f"{BASE_URL}{path}", json=body, timeout=15)
    r.raise_for_status()
    return r.json()


def cmd_status(_args):
    print(json.dumps(_get("/v1/api/iserver/auth/status"), indent=2))


def cmd_accounts(_args):
    print(json.dumps(_get("/v1/api/portfolio/accounts"), indent=2))


def cmd_positions(args):
    print(json.dumps(_get(f"/v1/api/portfolio/{args.account_id}/positions/0"), indent=2))


def cmd_summary(args):
    print(json.dumps(_get(f"/v1/api/portfolio/{args.account_id}/summary"), indent=2))


def cmd_search(args):
    print(json.dumps(_post("/v1/api/iserver/secdef/search", {"symbol": args.symbol}), indent=2))


def cmd_snapshot(args):
    conids = ",".join(args.conids)
    # Feld 31 = last price. Weitere Feld-IDs siehe IBKR-API-Doku bei Bedarf.
    print(json.dumps(_get("/v1/api/iserver/marketdata/snapshot", conids=conids, fields="31"), indent=2))


def cmd_order(args):
    body = {
        "orders": [
            {
                "conid": args.conid,
                "orderType": "LMT",
                "price": args.price,
                "side": args.side,
                "quantity": args.quantity,
                "tif": "DAY",
            }
        ]
    }
    result = _post(f"/v1/api/iserver/account/{args.account_id}/orders", body)
    print(json.dumps(result, indent=2))
    # IBKR verlangt bei der ersten Order pro Session oft eine Bestätigung
    # ("MessageIds" in der Antwort). Diese muss ggf. per Reply-Endpoint
    # bestätigt werden - vom aufrufenden Agenten anhand der Antwort prüfen.


def cmd_cancel(args):
    r = requests.delete(
        f"{BASE_URL}/v1/api/iserver/account/{args.account_id}/order/{args.order_id}",
        timeout=15,
    )
    r.raise_for_status()
    print(json.dumps(r.json(), indent=2))


def main():
    p = argparse.ArgumentParser(description=__doc__)
    sub = p.add_subparsers(dest="command", required=True)

    sub.add_parser("status", help="Auth-Status des Gateways").set_defaults(func=cmd_status)
    sub.add_parser("accounts", help="Verfügbare Konten").set_defaults(func=cmd_accounts)

    sp = sub.add_parser("positions", help="Offene Positionen eines Kontos")
    sp.add_argument("account_id")
    sp.set_defaults(func=cmd_positions)

    sp = sub.add_parser("summary", help="Kontoübersicht (Cash, Buying Power, ...)")
    sp.add_argument("account_id")
    sp.set_defaults(func=cmd_summary)

    sp = sub.add_parser("search", help="Ticker -> conid auflösen")
    sp.add_argument("symbol")
    sp.set_defaults(func=cmd_search)

    sp = sub.add_parser("snapshot", help="Aktueller Kurs für eine oder mehrere conids")
    sp.add_argument("conids", nargs="+")
    sp.set_defaults(func=cmd_snapshot)

    sp = sub.add_parser("order", help="Limit-Order platzieren (Paper-Account)")
    sp.add_argument("account_id")
    sp.add_argument("conid", type=int)
    sp.add_argument("side", choices=["BUY", "SELL"])
    sp.add_argument("quantity", type=float)
    sp.add_argument("price", type=float)
    sp.set_defaults(func=cmd_order)

    sp = sub.add_parser("cancel", help="Order stornieren")
    sp.add_argument("account_id")
    sp.add_argument("order_id")
    sp.set_defaults(func=cmd_cancel)

    args = p.parse_args()
    try:
        args.func(args)
    except requests.HTTPError as e:
        print(f"Gateway-Fehler: {e.response.status_code} {e.response.text}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
