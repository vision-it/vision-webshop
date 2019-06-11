# vision-webshop

[![Build Status](https://travis-ci.org/vision-it/vision-webshop.svg)](https://travis-ci.org/vision-it/vision-webshop)

## Parameter

## Usage

Include in the *Puppetfile*:

```
mod 'vision_webshop',
    :git => 'https://github.com/vision-it/vision-webshop.git,
    :ref => 'production'
```

Include in a role/profile:

```puppet
contain ::vision_webshop
```

