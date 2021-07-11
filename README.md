# Components
Repository for Bottles components

> ⚠️ On **July 3, 2021**, Bottles switched to yaml format for all config and manifest files. The old json format will be abandoned by Bottles on **July 14, 2021**, making the repositories inaccessible to versions of Bottles prior to `2021.7.3-treviso`.

## Why a centralized repository?
With a centralized repository we can provide some data such as the checksum, which is useful for validate downloads.

## How to contribute
To propose new components, it is necessary to open a [Pull Request](https://github.com/bottlesdevs/components/pulls) with the manifest of the component we want to add, here are some examples of manifest:
- [dxvk-1.9](https://github.com/bottlesdevs/components/blob/main/dxvk/dxvk-1.9.yml)
- [vkd3d-v2.4](https://github.com/bottlesdevs/components/blob/main/vkd3d/vkd3d-v2.4.yml)
- [Proton-5.21-GE-1](https://github.com/bottlesdevs/components/blob/main/runners/proton/Proton-5.21-GE-1.yml)
- [vaniglia-6.12](https://github.com/bottlesdevs/components/blob/main/runners/wine/vaniglia-6.12.yml)

### Manifest layout
Each poster must follow the following layout:
```yaml
Name: vaniglia-6.12
Provider: bottles
Channel: stable
File:
- file_name: vaniglia-6.12-x86_64.tar.gz
  url: https://github.com/bottlesdevs/wine/releases/download/6.11/vaniglia-6.12-x86_64.tar.gz
  file_checksum: da48f5bd2953a0ce8b5972008df8fafc
  rename: vaniglia-6.12-x86_64.tar.gz
```
old json manifests can be converted using this [online tool](https://www.json2yaml.com).

where:
- **Name** is a name without spaces, including version, of the component (must reflect the name of the manifest file)
- **Provider** is the name of the component supplier (not the maintainer)
- **Channel** should be stable or unstable
- **File** is where it is stated how to get the component archive
  - **file_name** is the full name of the component archive
  - **url** is the direct URL to the archive download (ornly tarball are supported)
  - **file_checksum** is the MD5 checksum of the archive
  - **rename** this field must be the same as the name of the component (plus the extension), it is needed if the archive has a name but acquires another when it is extracted

### Guidelines
The sources of the components must be public and searchable and must not infringe any copyright. Also, each archive must contain the compiled version and not the source code.

### Testing repository
There is also a testing repository to test components before publishing them to the main repository.
To do so you need to add the new component to the `testing.yml` file (opening a Pull request) and run bottles with the environment variable `TESTING_REPOS=1` to use the testing repository.

## Currently offered runners
We offer several runners in Bottles:
- `vaniglia` (our runner, available by default in Bottles v3)
- `lutris`
- `lutris-ge`
- `proton-ge`
