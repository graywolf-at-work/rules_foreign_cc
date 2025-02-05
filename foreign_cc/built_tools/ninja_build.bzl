""" Rule for building Ninja from sources. """

load(
    "//foreign_cc/built_tools/private:built_tools_framework.bzl",
    "FOREIGN_CC_BUILT_TOOLS_ATTRS",
    "FOREIGN_CC_BUILT_TOOLS_FRAGMENTS",
    "FOREIGN_CC_BUILT_TOOLS_HOST_FRAGMENTS",
    "built_tool_rule_impl",
)
load("//foreign_cc/private/framework:platform.bzl", "os_name")

def _ninja_tool_impl(ctx):
    script = [
        # TODO: Drop custom python3 usage https://github.com/ninja-build/ninja/pull/2118
        "python3 ./configure.py --bootstrap",
        "mkdir $$INSTALLDIR$$/bin",
        "cp -p ./ninja{} $$INSTALLDIR$$/bin/".format(
            ".exe" if "win" in os_name(ctx) else "",
        ),
    ]

    return built_tool_rule_impl(
        ctx,
        script,
        ctx.actions.declare_directory("ninja"),
        "BootstrapNinjaBuild",
    )

ninja_tool = rule(
    doc = "Rule for building Ninja. Invokes configure script.",
    attrs = FOREIGN_CC_BUILT_TOOLS_ATTRS,
    host_fragments = FOREIGN_CC_BUILT_TOOLS_HOST_FRAGMENTS,
    fragments = FOREIGN_CC_BUILT_TOOLS_FRAGMENTS,
    output_to_genfiles = True,
    implementation = _ninja_tool_impl,
    toolchains = [
        "@rules_foreign_cc//foreign_cc/private/framework:shell_toolchain",
        "@bazel_tools//tools/cpp:toolchain_type",
    ],
)
