# vision-loki

[![Build Status](https://travis-ci.org/vision-it/vision-loki.svg?branch=development)](https://travis-ci.org/vision-it/vision-loki)

## Parameter

## Usage

Include in the *Puppetfile*:

```
mod 'vision_loki',
    :git => 'https://github.com/vision-it/vision-loki.git,
    :ref => 'production'
```

Include in a role/profile:

```puppet
contain ::vision_loki::server
contain ::vision_loki::client
```
