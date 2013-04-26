# github-auth `gh-auth`
[![Travis CI](https://travis-ci.org/chrishunt/github-auth.png)](https://travis-ci.org/chrishunt/github-auth)
[![Coverage Status](https://coveralls.io/repos/chrishunt/github-auth/badge.png?branch=master)](https://coveralls.io/r/chrishunt/github-auth)
[![Code Climate](https://codeclimate.com/github/chrishunt/github-auth.png)](https://codeclimate.com/github/chrishunt/github-auth)

## Description

If you agree to [\#pairwithme](https://twitter.com/search?q=pairwithme), we'll
probably be SSHing into my laptop, your laptop, or some laptop in the sky.
Sharing passwords over email is no fun, so we'll use public key authentication
to keep things fun, fast, and **secure**

`gh-auth` allows you to quickly add and remove any Github user's public ssh
keys from your [`authorized_keys`](http://en.wikipedia.org/wiki/Ssh-agent)
file.

Let's see how this works.

After you've [installed](#installation) `gh-auth`, you can give me ssh access
with:

```bash
$ gh-auth add chrishunt
Adding 2 key(s) to '/Users/chris/.ssh/authorized_keys'
```

That was easy! When we're done working, you can revoke my access with:

```bash
$ gh-auth remove chrishunt
Removing 2 key(s) from '/Users/chris/.ssh/authorized_keys'
```

You can add and remove any number of users at the same time.

```bash
$ gh-auth add chrishunt zachmargolis
Adding 4 key(s) to '/Users/chris/.ssh/authorized_keys'

$ gh-auth remove chrishunt
Removing 2 key(s) from '/Users/chris/.ssh/authorized_keys'

$ gh-auth remove zachmargolis
Removing 2 key(s) from '/Users/chris/.ssh/authorized_keys'
```

## Usage

```bash
usage: gh-auth [--version] [add|remove] <username>
```

## Installation

Install the `github-auth` gem:

```bash
$ gem install github-auth

$ gh-auth
usage: gh-auth [--version] [add|remove] <username>
```

### SSH Public Key Authentication (Mac OS X)

Public key authentication works with Mac OS by default, but you'll need to get
your ssh server running. This is done by ticking 'Remote Login' in the
'Sharing' panel of System Preferences.

![](https://raw.github.com/chrishunt/github-auth/master/img/mac-os-ssh-sharing.jpg)

Now that SSH is running, make sure you have the correct permissions set for
your authorized keys.

```bash
$ chmod 700 ~/.ssh
$ chmod 600 ~/.ssh/authorized_keys
```

### Verification

If you'd like to verify that everything is working as expected, you can test
right from your machine.

First, authorized yourself for ssh. (Make sure to replace 'chrishunt' with
*your* Github username)

```bash
$ gh-auth add chrishunt
Adding 2 key(s) to '/Users/chris/.ssh/authorized_keys'
```

Next, open an SSH session to your machine with public key authentication. It
should work just fine.

```bash
$ ssh -o PreferredAuthentications=publickey localhost

(localhost)$
```

Now remove your public keys from the keys file:

```bash
$ gh-auth remove chrishunt
Removing 2 key(s) from '/Users/chris/.ssh/authorized_keys'
```

You should no longer be able to login to the machine since the keys have been
removed.

```bash
$ ssh -o PreferredAuthentications=publickey localhost

> Permission denied (publickey,keyboard-interactive)
```

## Troubleshooting

### How do people actually connect to my machine?

Good question! Others will connect to your machine using ssh:

```bash
$ ssh username@external-ip-address
```

### What username do I use?

The `username` is going to be the same username that you used to add the keys.
In most cases, it's a good idea to create a new `pair` account and use that
account for all pairings. You don't want strangers reading your email!

Once you've created the pair account, you can switch to it yourself in a
terminal with:

```bash
$ su - pair
```

### How do I get my external IP?

You can get your external IP address with:

```bash
$ curl http://remote-ip.herokuapp.com
```

### It's still not working! :(

In almost all cases, your laptop is not directly plugged into your modem.
You're on a wirelress network or plugged directly into a router or switch. This
means the external IP address that your pair is connecting to is not your
machine, it's actually your router.

You can tell your router to forward ssh connections to your machine by enabling
[port forwarding](http://en.wikipedia.org/wiki/Port_forwarding). You will want
to forward port `22` (ssh) to the local IP address of your machine.

If port `22` is already forwarded to another machine or you want to change
things up, you can have ssh listen on another port and have your pair connect
with:

```bash
ssh -p <port> username@external-ip-address
```

### I can't enable port forwarding, my boss won't let me. Can I still pair?

Yes! A nice solution to this is to have a machine **somewhere else** that both
of you can ssh into. Place this machine on a network that you *do* have the
ability to forward ports. Maybe this machine is at home, a friends house, or
at a company your worked for in the past that forgot to turn it off.

If this isn't possible, then you can use a VPS provider like
[Linode](http://www.linode.com) to setup a pairing machine in the cloud.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Run the tests (`bundle exec rake spec`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request
