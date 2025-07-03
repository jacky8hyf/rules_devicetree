<!-- Generated with Stardoc: http://skydoc.bazel.build -->

Builds device tree blob overlays.

<a id="dtbo"></a>

## dtbo

<pre>
dtbo(<a href="#dtbo-name">name</a>, <a href="#dtbo-dtcopts">dtcopts</a>, <a href="#dtbo-srcs">srcs</a>)
</pre>

Build a base devicetree blob overlay (DTBO)

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="dtbo-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="dtbo-dtcopts"></a>dtcopts |  List of flags to dtc.   | List of strings | optional | <code>[]</code> |
| <a id="dtbo-srcs"></a>srcs |  List of sources.<br><br>            There must be exactly one <code>.dtso</code> file. Beside the <code>.dtso</code> file,             extra include files like <code>.dtsi</code> can be specified.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional | <code>[]</code> |


