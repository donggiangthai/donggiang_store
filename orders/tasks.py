from store.celery import app
from django.core.mail import send_mail
from orders.models import Order
import os


@app.task
def order_created(order_id):
    """
    Task to send an email notification when an order is successfully created.
    """
    order = Order.objects.get(id=order_id)
    order_items = order.items.all()
    subject = f"[Dong Giang Store] Order nr. {order_id}"
    message = f"""
Dear {order.first_name} {order.last_name},
    
You have successfully placed an order. Your order id is {order.id}.
    
List of items:"""
    for item in order_items:
        message += f"\n- {item.product.name} x{item.quantity}"

    message += f"\n\nTotal: {order.get_total_cost()}"

    mail_sent = send_mail(
        subject=subject,
        message=message,
        from_email=os.getenv('EMAIL_HOST_USER'),
        auth_user=os.getenv('EMAIL_HOST_USER'),
        auth_password=os.getenv('EMAIL_HOST_PASSWORD'),
        recipient_list=[order.email]
    )
    return mail_sent
