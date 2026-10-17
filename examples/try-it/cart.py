"""Tiny shopping cart used for the Try It exercise.

This module contains a deliberate bug. Do not fix it by reading the code:
give the failure to your assistant and see how it investigates.
"""


def line_total(item):
    return item["price"] * item["qty"]


def cart_total(items, discount_rate=0.0):
    subtotal = sum(line_total(i) for i in items)
    return round(subtotal * (1 - discount_rate), 2)
