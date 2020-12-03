# vision-loki

[![Build Status](https://travis-ci.com/vision-it/vision-loki.svg?branch=production)](https://travis-ci.com/vision-it/vision-loki)

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
