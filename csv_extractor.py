#!/usr/bin/python3

with open("contacts.csv", "r") as contacts:
    for contact in contacts:
        contact = contact.split(',')
        name, phone = contact[0],contact[-15].split(' ')
        aux = f"{name} == "
        if len(phone) == 1:
            aux += phone[0]
        else:
            for number in phone[1:]:
                aux += number
        with open("lista.txt", "a") as lista:
            lista.write(f"{aux}\n")

        