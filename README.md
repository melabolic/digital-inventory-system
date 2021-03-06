# Capstone: Digital Inventory System

This is a copy of the code that's used for my Capstone project - A Digital Approach to  Reducing Food Waste in Malaysian Households.

If you'd like to use this code, please request my permission using [this email](jiewen.lim@minerva.kgi.edu).

## How I programmed this application

This project was developed using Flutter. 

For help getting started with Flutter, view their 
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

I started this project by first tackling the core proposition of the app: its digital inventory. The very first MVP (which is this release version) allows for a few core functionalities:

1. Allowing users to add a new food item to their inventory
2. Edit the entries already present in the Database (SQLite is used to persist data)
3. Update/delete entries in the database

## Changelog
1. 23/02/2020 - Completed the base inventory system
2. 23/02/2020 - Added data validation functionalities and modified the date entry method
3. 24/02/2020 - Modified the UI of the inventory to reflect desired look; added card colors based on expiration dates
4. 13/03/2020 - Modified the `display_items.dart` file so that we would only need to render the ListView after a new change has been made. More comments were added for more clarity.