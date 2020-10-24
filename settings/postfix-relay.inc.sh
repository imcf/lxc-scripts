#!/bin/bash

# define which host will accept our mails for relay:
POSTFIX_RELAYHOST="my-nice-smtp.example.org"

# who should receive the mails sent to the local "root" account:
POSTFIX_ROOTADDRESS="the-admin@example.org"

# OPTIONAL: a line that should be added to /etc/hosts
ADD_TO_ETC_HOSTS="10.0.3.96  my-nice-smtp.example.org"