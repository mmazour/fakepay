# Fakepay

Fakepay is a development demo for Fakebook, which uses the Coolpay API to allow users to send money to friends.

Fakepay has a simple command-line interface allowing recipients and payments to be created, listed, and searched. 

(Note that these are the only functions available: Coolpay's API doesn't provide for update or deletion. While it's reasonable for payments to be immutable, immutable recipients seem likely to be annoying to users and may violate GDPR. We should consider other payment providers in future.)

Fakebook's underlying technology is built to be portable and embeddable, so it can be incorporated into a mobile app, a website, a standalone service, etc. The command-line demo you see here is little more than a wrapper for a portable Ruby gem, also developed here at Fakebook, that handles all aspects of payments. 

## Requirements

You will need the URL to a Coolpay server, an account, and an API key.

This gem was developed and tested under Ruby 2.6.2, but ought to run on earlier (stable, supported) versions of Ruby.


## Installation

Clone this repo to your local system:

```
$ git clone https://github.com/mmazour/fakepay.git
```

Then install its dependencies.

```
$ cd fakepay
$ bundle
```

The `fakepay` command-line executable is in the `exe` directory. You may wish to add this directory to your path, or create an alias.

```
$ alias fakepay='exe/fakepay'
```


## Usage

### Configuring Fakepay

There are two ways to configure Fakepay:

1. Copy `.coolpay.yml.sample` to `.coolpay.yml` and edit the values for the URL, username, and API key.

2. Set the environment variables `COOLPAY_API_URL`, `COOLPAY_USERNAME`, and `COOLPAY_API_KEY`.

If both are populated, `.coolpay.yml` takes precedence.


### Recipients

Listing recipients:

```bash
$ fakepay list recipients
[\] Login... Done.
[\] Fetch recipients... Done.
Found 1
+------------------------------------+-----------+
|id                                  |name       |
+------------------------------------+-----------+
|2a699718-142a-469e-8c1f-9b486b20bbbf|Sandy McPal|
+------------------------------------+-----------+
```

Recipients have `id` and `name` fields. You can look them up by name.

```bash
$ fakepay find recipient "Sandy McPal"
[/] Login... Done.
[/] Search for recipient... Done.
+------------------------------------+-----------+
|id                                  |name       |
+------------------------------------+-----------+
|2a699718-142a-469e-8c1f-9b486b20bbbf|Sandy McPal|
+------------------------------------+-----------+
```

And you can create them by name.

```bash
$ fakepay create recipient "Chris DeBest"
[\] Login... Done.
[\] Create recipient... Done.
+------------------------------------+------------+
|id                                  |name        |
+------------------------------------+------------+
|340ce00a-5b84-437c-9d80-9cc6b54bc82d|Chris DeBest|
+------------------------------------+------------+

$ fakepay list recipients
[/] Login... Done.
[/] Fetch recipients... Done.
Found 2
+------------------------------------+------------+
|id                                  |name        |
+------------------------------------+------------+
|2a699718-142a-469e-8c1f-9b486b20bbbf|Sandy McPal |
|340ce00a-5b84-437c-9d80-9cc6b54bc82d|Chris DeBest|
+------------------------------------+------------+
```

### Payments

Payments can likewise be listed. Payments have an `id`, an `amount`, a `currency`, the recipient's `recipient_id`, and a status.

```bash
$ fakepay list payments
[/] Login... Done.
[/] Fetch payments... Done.
Found 1
+------------------------------------+------+--------+------------------------------------+------+
|id                                  |amount|currency|recipient_id                        |status|
+------------------------------------+------+--------+------------------------------------+------+
|41272b22-b99f-4878-8a1d-dd0b7d19c147|12.34 |usd     |63fa4887-06c7-4800-8ae4-df3cd5478724|failed|
+------------------------------------+------+--------+------------------------------------+------+
```

Creating a payment requires the `amount`, the `currency`, and the `recipient`'s id.

```bash
$ fakepay create payment --amount 3.25 --currency GBP --recipient 340ce00a-5b84-437c-9d80-9cc6b54bc82d
[/] Login... Done.
[/] Create payment... Done.
+------------------------------------+------+--------+------------------------------------+----------+
|id                                  |amount|currency|recipient_id                        |status    |
+------------------------------------+------+--------+------------------------------------+----------+
|9ccd0ff2-1c53-47a9-8a0d-a2cf16e781d3|3.25  |gbp     |340ce00a-5b84-437c-9d80-9cc6b54bc82d|processing|
+------------------------------------+------+--------+------------------------------------+----------+
```

Checking to see whether the payment's gone through:

```bash
$ fakepay find payment 9ccd0ff2-1c53-47a9-8a0d-a2cf16e781d3
[/] Login... Done.
[/] Search for payment... Done.
+------------------------------------+------+--------+------------------------------------+------+
|id                                  |amount|currency|recipient_id                        |status|
+------------------------------------+------+--------+------------------------------------+------+
|9ccd0ff2-1c53-47a9-8a0d-a2cf16e781d3|3.25  |gbp     |340ce00a-5b84-437c-9d80-9cc6b54bc82d|paid  |
+------------------------------------+------+--------+------------------------------------+------+
```

## Technical notes

### Project structure

Fakepay was built as a [TTY](https://piotrmurach.github.io/tty/) application. TTY includes a somewhat largeish amount of framework ceremony, so to save you muddling through it, the actual working code is concentrated in:

- The `execute` methods in `lib/fakepay/commands/*/*.rb` (e.g. `lib/fakepay/commands/create/payment.rb`).
- `lib/fakepay/coolpay_helper` and `lib/fakepay/tty_helper`.
- `spec/unit/*/*_spec.rb` (e.g. `spec/unit/create/payment_spec.rb`).

TTY also generates projects expecting them to become gems. While that's useful in some situations it's not relevant here (though I haven't yet taken time to strip out the gemmines).

### Content-type warnings

You will see messages like `warning: Overriding "Content-Type" header "application/json"` when running `create` commands. This appears to be a [recurring](https://github.com/rest-client/rest-client/issues/635) [problem](https://github.com/rest-client/rest-client/issues/577) in RestClient. The fix is probably simple but is **TODO** in a later version of Fakepay.

### Coolpay gem

Fakepay uses my own Coolpay gem, which you can find at https://github.com/mmazour/coolpay.

## Copyright

Copyright (c) 2019 Michael Mazour. See [MIT License](LICENSE.txt) for further details.
