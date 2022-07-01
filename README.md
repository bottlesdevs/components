# Components
Repository for Bottles components


## Why a centralized repository?
With a centralized repository we can provide some data such as the checksum, which is useful for validate downloads.


## How to contribute
To propose new components, it is necessary to open a [Pull Request](https://github.com/bottlesdevs/components/pulls) with the manifest of the component we want to add, here are some examples of manifest:
- [caffe-7.2](https://github.com/bottlesdevs/components/blob/main/runners/wine/caffe-7.2.yml)
- [Proton-5.21-GE-1](https://github.com/bottlesdevs/components/blob/main/runners/proton/Proton-5.21-GE-1.yml)
- [dxvk-1.9](https://github.com/bottlesdevs/components/blob/main/dxvk/dxvk-1.9.yml)
- [vkd3d-v2.4](https://github.com/bottlesdevs/components/blob/main/vkd3d/vkd3d-v2.4.yml)


### Manifest layout
Each poster must follow the following layout:
```yaml
Name: caffe-7.2
Provider: bottles
Channel: stable
File:
- file_name: caffe-7.2-x86_64.tar.xz
  url: https://github.com/bottlesdevs/wine/releases/download/caffe-7.2/caffe-7.2-x86_64.tar.xz
  file_checksum: 659ee0ee3dbe5274825734ad19692e12
  rename: caffe-7.2-x86_64.tar.xz
```
old json manifests can be converted using this [online tool](https://www.json2yaml.com).

where:
- **Name** is a name without spaces, including version, of the component (must reflect the name of the manifest file)
- **Provider** is the name of the component supplier (not the maintainer)
- **Channel** should be stable or unstable
- **File** is where it is stated how to get the component archive
  - **file_name** is the full name of the component archive
  - **url** is the direct URL to the archive download (only tarball are supported)
  - **file_checksum** is the MD5 checksum of the archive
  - **rename** this field should be the same as the name of the component for must cases (plus the extension), it is needed to rename the archive.

There is also an optional `Post` section, which can be used to rename the path after extraction:

```yaml
Post:
- action: rename
  source: lutris-fshack-6.14-2
  dest: lutris-6.14-2-fshack
```

We provide an [automatic tools](https://github.com/bottlesdevs/tools/blob/main/MaintainersHelpers/component-generator.py) for generating the manifest. Please double check and test the manfiest before open a pull request.


### Guidelines
The sources of the components must be public and searchable and must not infringe any copyright. Also, each archive must contain the compiled version and not the source code.


### Testing repository
There is also a testing repository to test components before publishing them to the main repository.
To do so you need to add the new component to the `testing.yml` file (opening a Pull request) and run bottles with the environment variable `TESTING_REPOS=1` to use the testing repository.


## Need help?
Reach us on our [Forums](https://forum.usebottles.com/), [Discord](https://discord.gg/wF4JAdYrTR), [Telegram](https://t.me/usebottles) or [Matrix](https://matrix.to/#/%23UseBottles:matrix.org).
