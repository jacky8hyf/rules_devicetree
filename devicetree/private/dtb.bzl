# Copyright (C) 2025 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

"""Builds device tree blobs."""

load("@bazel_skylib//lib:paths.bzl", "paths")
load(":base_dtb_info.bzl", "BaseDtbInfo")

visibility("//devicetree/...")

def _split_sources(srcs, src_extension):
    """Split the list of `srcs`.

    Args:
        srcs: ctx.attr.srcs
        src_extension: expected extension of the source file

    Returns:
        struct of these fields:

        *   src: the single source file
        *   include_files: other include files
    """
    sources = []
    include_files = []
    for file in srcs:
        if not file.extension == src_extension:
            include_files.append(file)
        else:
            sources.append(file)

    if len(sources) != 1:
        fail("Expect exactly one .{} file in srcs, got {}".format(src_extension, sources))

    return struct(
        src = sources[0],
        include_files = include_files,
    )

def _get_output_path(this_target_name, src, new_extension):
    """Declares and returns the output file at a reasonable path.

    Args:
        this_target_name: name of this target
        src: name of the single source file
        new_extension: extension of the output file, without the dot

    Returns:
        the output file
    """
    return paths.join(this_target_name, paths.replace_extension(src.basename, "." + new_extension))

# buildifier: disable=unused-variable
def _preprocess(ctx, src, include_files):
    # TODO(#7): Support preprocess directives
    return src

def _dtc(
        ctx,
        src,
        include_files,
        generate_symbols,
        out_extension,
        devicetree_toolchain_info):
    """Invokes dtc.

    Args:
        ctx: ctx
        src: The single source file
        include_files: extra inputs to the action
        generate_symbols: whether to generate symbols
        out_extension: extension of output file without the dot
        devicetree_toolchain_info: `DevicetreeToolchainInfo` of resolved toolchain

    Returns:
        the output file
    """
    out = ctx.actions.declare_file(_get_output_path(ctx.label.name, src, out_extension))
    args = ctx.actions.args()
    args.add_all(devicetree_toolchain_info.default_dtcopts)

    if generate_symbols:
        args.add("-@")
    args.add("-o", out)
    args.add(src)
    ctx.actions.run(
        executable = devicetree_toolchain_info.dtc,
        arguments = [args],
        inputs = [src] + include_files,
        outputs = [out],
        mnemonic = "Dtb",
        progress_message = "Building {} %{{label}}".format(out.basename),
    )
    return out

def _dtb_impl(ctx):
    devicetree_toolchain_info = ctx.toolchains["//devicetree:toolchain_type"].devicetree_toolchain_info
    split_sources = _split_sources(ctx.files.srcs, "dts")

    preprocessed = _preprocess(
        ctx = ctx,
        src = split_sources.src,
        include_files = split_sources.include_files,
    )
    out = _dtc(
        ctx = ctx,
        src = preprocessed,
        include_files = split_sources.include_files,
        generate_symbols = ctx.attr.symbols,
        out_extension = "dtb",
        devicetree_toolchain_info = devicetree_toolchain_info,
    )
    return [
        DefaultInfo(files = depset([out])),
        BaseDtbInfo(
            symbols = ctx.attr.symbols,
        ),
    ]

dtb = rule(
    doc = "Build a base devicetree blob (DTB)",
    implementation = _dtb_impl,
    attrs = {
        "srcs": attr.label_list(
            doc = """List of sources.

            There must be exactly one `.dts` file. Beside the `.dts` file,
            extra include files like `.dtsi` can be specified.
        """,
            allow_files = True,
        ),
        "symbols": attr.bool(doc = """Enable generation of symbols (-@).

            This is necessary if you are applying overlays on top of it.
        """),
    },
    toolchains = [
        "//devicetree:toolchain_type",
    ],
)
