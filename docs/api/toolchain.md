<!-- Generated with Stardoc: http://skydoc.bazel.build -->

This module implements the language-specific toolchain rule.

<a id="devicetree_toolchain"></a>

## devicetree_toolchain

<pre>
load("@rules_devicetree//devicetree:toolchain.bzl", "devicetree_toolchain")

devicetree_toolchain(<a href="#devicetree_toolchain-name">name</a>, <a href="#devicetree_toolchain-default_dtcopts">default_dtcopts</a>, <a href="#devicetree_toolchain-dtc">dtc</a>, <a href="#devicetree_toolchain-fdtoverlay">fdtoverlay</a>, <a href="#devicetree_toolchain-preprocess">preprocess</a>)
</pre>

Defines a devicetree toolchain.

For usage see https://docs.bazel.build/versions/main/toolchains.html#defining-toolchains.

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="devicetree_toolchain-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="devicetree_toolchain-default_dtcopts"></a>default_dtcopts |  Default list of flags to dtc   | List of strings | optional |  `[]`  |
| <a id="devicetree_toolchain-dtc"></a>dtc |  devicetree compiler   | <a href="https://bazel.build/concepts/labels">Label</a> | optional |  `None`  |
| <a id="devicetree_toolchain-fdtoverlay"></a>fdtoverlay |  executable to apply overlays   | <a href="https://bazel.build/concepts/labels">Label</a> | optional |  `None`  |
| <a id="devicetree_toolchain-preprocess"></a>preprocess |  Whether source files are preprocessed.<br><br>If true, allow preprocessing directives in source files (`*.dts`, `*.dtso`). The CC toolchain must be available.<br><br>If false, preprocessing directives are not allowed.   | Boolean | required |  |


