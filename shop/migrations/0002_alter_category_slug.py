# Generated by Django 4.2 on 2023-04-27 05:11

from django.db import migrations, models


class Migration(migrations.Migration):
    dependencies = [
        ("shop", "0001_initial"),
    ]

    operations = [
        migrations.AlterField(
            model_name="category",
            name="slug",
            field=models.SlugField(blank=True, max_length=200, unique=True),
        ),
    ]
