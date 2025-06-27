"""Extensions for bzlmod.

Installs a devicetree toolchain.
Every module can define a toolchain version under the default name, "devicetree".
The latest of those versions will be selected (the rest discarded),
and will always be registered by rules_devicetree.

Additionally, the root module can define arbitrarily many more toolchain versions under different
names (the latest version will be picked for each name) and can register them as it sees fit,
effectively overriding the default named toolchain due to toolchain resolution precedence.
"""

load("//devicetree/private:toolchains_repo.bzl", "toolchains_repo")

devicetree_toolchain = tag_class(attrs = {
    "name": attr.string(doc = """\
Base name for generated repositories, allowing more than one devicetree toolchain to be registered.
Overriding the default is only permitted in the root module.
""", mandatory = True),
})

def _toolchain_extension(module_ctx):
    registrations = {}
    for mod in module_ctx.modules:
        for toolchain in mod.tags.toolchain:
            if not mod.is_root and not toolchain.name.startswith(mod.name + "_"):
                fail("Module {module_name} declares devicetree toolchain repository named {repo_name}, but the name must start with {module_name}".format(
                    module_name = mod.name,
                    repo_name = toolchain.name,
                ))
            if toolchain.name not in registrations.keys():
                registrations[toolchain.name] = []
            registrations[toolchain.name].append(struct(
                source = mod.name,
            ))
    for name, reg_of_name in registrations.items():
        if len(reg_of_name) > 1:
            fail("Multiple modules declraed devicetree toolchain repository named {}: {}".format(
                name,
                [reg.source for reg in reg_of_name],
            ))

        toolchains_repo(
            name = name,
        )

devicetree = module_extension(
    implementation = _toolchain_extension,
    tag_classes = {"toolchain": devicetree_toolchain},
)
