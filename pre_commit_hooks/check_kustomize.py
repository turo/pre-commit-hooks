import argparse
import pathlib
import sys
from subprocess import check_output
from subprocess import run
from typing import Dict
from typing import List
from typing import Optional
from typing import Sequence

import ruamel.yaml
from packaging import version

yaml = ruamel.yaml.YAML(typ="safe")


def check_kustomize() -> bool:
    min_version = version.parse("3.8")
    kustomize_version_str = (
        check_output(["kustomize", "version", "--short"])
        .decode(sys.stdout.encoding)[1:]
        .split()[0]
    )
    print(f"raw version: {kustomize_version_str}")
    kustomize_version = version.parse(kustomize_version_str)
    print(f"min version: {min_version}")
    print(f"kustomize_version: {kustomize_version}")
    return kustomize_version >= min_version


def recursive_check(verbose: bool, filenames: List[str]) -> int:
    kustomize_dirs = {}
    for input_filename in filenames:
        for kustomize_files in pathlib.Path(input_filename).glob(
            "**/kustomization.yaml",
        ):
            parent = kustomize_files.parent.resolve()
            if is_customize_dir(parent):
                kustomize_dirs[parent.as_posix()] = parent

    if validate_dirs(verbose, kustomize_dirs):
        return 0

    return 1


def is_customize_dir(input_file: pathlib.Path) -> bool:
    return input_file.joinpath("kustomization.yaml").exists()


def validate_dirs(verbose: bool, kustomize_dirs: Dict[str, pathlib.Path]) -> bool:
    return_value = True
    for kustomize_dir in kustomize_dirs:
        print(f"building {kustomize_dir}")
        completed_process = run(
            ["kustomize", "build", kustomize_dir], capture_output=True,
        )
        print(f"cmd: {' '.join(completed_process.args)}")
        print(f"return code: {completed_process.returncode}")
        if verbose:
            print(completed_process.stdout.decode(sys.stdout.encoding))

        if completed_process.returncode:
            # Successful commands have return code of 0
            return_value = False
            print(completed_process.stderr.decode(sys.stdout.encoding))

    return return_value


def check_files(verbose: bool, filenames: List[str]) -> int:
    kustomize_dirs = {}
    for filename in filenames:
        input_file = pathlib.Path(filename)
        input_directory = (
            input_file.resolve() if input_file.is_dir() else input_file.parent.resolve()
        )
        if is_customize_dir(input_directory):
            kustomize_dirs[input_directory.as_posix()] = input_directory
        else:
            print(f"skipping - {filename}")

    if validate_dirs(verbose, kustomize_dirs):
        return 0
    return 1


def main(argv: Optional[Sequence[str]] = None) -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "-r", "--recursive", action="store_true",
    )
    parser.add_argument(
        "--verbose", action="store_true",
    )
    parser.add_argument("filenames", nargs="*", help="Filenames to check.")
    args = parser.parse_args(argv)

    if not check_kustomize():
        return 1

    if args.recursive:
        return recursive_check(args.verbose, args.filenames)

    return check_files(args.verbose, args.filenames)


if __name__ == "__main__":
    exit(main())
