"""Reproduces the failure. Run: python demo.py"""
from cart import cart_total

items = [
    {"price": 10.0, "qty": 2},
    {"price": 5.0, "quantity": 3},  # produced by a legacy importer
]
print(cart_total(items))
