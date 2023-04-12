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

To do it, there is currently two methods.

### 1 - Add an entry to the CI (prefered method)
For most components, new stable versions (and experimental builds if they exist) are automatically pulled. This is accomplished by the [pull-components.yml](https://github.com/bottlesdevs/components/blob/main/.github/workflows/pull-components.yml) workflow, where components are described in the following format:

```yaml
repo : "doitsujin/dxvk",
workflow: "artifacts.yml",
branch: "master",
name-prefix: "dxvk-",
name-suffix: "",
version-prefix: "v",
yaml-file: "14-dxvk.yml",
Category: "dxvk",
Sub-category: "",
```
where:
- **repo** is the GitHub repository in the format `owner/repository`
- **workflow** is the workflow filename used to generate exerimental builds, if any
- **branch** is the **workflow** branch used to generate exerimental builds, if any
- **name-prefix** is used to generate the full name of the component using **name-prefix** + `version` + **name-suffix** (e.g. `dxvk-` + `2.0` + ∅), and look for release/experimental asset whose filename is begining by **name-prefix**
- **name-suffix** serves the exact same purpose as **name-prefix**, is only used when multiple variants are available for one component (e.g. `-x86`, `-x64`, etc)
- **version-prefix** is used to find the latest release version whose [tag](https://github.com/doitsujin/dxvk/tags) is begining by **version-prefix**, and to remove **version-prefix** from the final `version` string (e.g. `v2.0` will become `2.0`)
- **yaml-file** is the YAML component filename located in the [input_files](https://github.com/bottlesdevs/components/blob/main/input_files) directory
- **Category** and **Sub-category** are repectively the Category and Sub-category as described in the **yaml-file** (e.g. [14-dxvk.yml](https://github.com/bottlesdevs/components/blob/main/input_files/14-dxvk.yml))

### 2 - Manually (legacy method)
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

We provide an [automatic tools](https://github.com/bottlesdevs/tools/blob/main/MaintainersHelpers/component-generator.py) for generating the manifest.

In addition to the manifest, en entry must be created in the corresponding file located in the [input_files](https://github.com/bottlesdevs/components/blob/main/input_files) directory. The index can then be regenerated using the [generate_index.sh](https://github.com/bottlesdevs/components/blob/main/generate_index.sh) script.

Please double check and test using the `LOCAL_COMPONENTS=/path/to/components flatpak run com.usebottles.bottles` command before open a pull request.

### Guidelines
The sources of the components must be public and searchable and must not infringe any copyright. Also, each archive must contain the compiled version and not the source code.


### Testing repository
There is also a testing repository to test components before publishing them to the main repository.
To do so you need to add the new component to the `testing.yml` file (opening a Pull request) and run bottles with the environment variable `TESTING_REPOS=1` to use the testing repository.


## Need help?
Reach us on our [Forums](https://forum.usebottles.com/), [Discord](https://discord.gg/wF4JAdYrTR), [Telegram](https://t.me/usebottles) or [Matrix](https://matrix.to/#/%23UseBottles:matrix.org).
