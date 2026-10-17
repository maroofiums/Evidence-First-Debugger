from cart import cart_total


def test_modern_items():
    items = [{"price": 10.0, "qty": 2}]
    assert cart_total(items) == 20.0


def test_imported_items():
    items = [{"price": 10.0, "qty": 2}, {"price": 5.0, "quantity": 3}]
    assert cart_total(items) == 35.0
