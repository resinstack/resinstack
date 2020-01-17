# ResinStack

If you manage infrastructure that runs containers, you will already be
familiar with the concepts of immutability and minimalism that
containers bring.  This kind of simplicity that can make
containerization such a nice option can be extended down to the
infrastructure that manages the metal of your datacenter as well.

## How does this work?

This repo contains tooling to build immutable system images for the
Nomad stack from HashiCorp.  These control files can be consumed by
[linuxkit](https://github.com/linuxkit/linuxkit) to produce images for
public and private clouds, as well as bare metal servers.  Rather than
maintaining a late-binding orchestration technology like Ansible,
Puppet or Chef, you simply build a new image with updates in it and
perform a rolling update of the underlying infrastructure.  In this
way you can confidently know the state of your infrastructure at any
given time since it can't be changed except during well defined
lifecycle phases (rebooting).

## Why Hashicorp?  Why not Kubernetes?

If you want Kubernetes [that's been
done](https://github.com/linuxkit/kubernetes).  This repo is about the
HashiStack because it is.  If you want a non-tautological answer its
because the authors believe its a nicer stack to work with, a cleaner
one to maintain, and one with less potential to explode if looked at
wrong.

## Cool, what's on the roadmap?

Reference deployments in AWS using terraform.  This way you can have
your very own Nomad cluster in a way that uses the images designed
here in a standard and repeatable way.

## How do I help?

File an issue on this repo with what you're interested in, and we'll
find a task for you to work on.
