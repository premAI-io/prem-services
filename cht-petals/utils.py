import platform


def get_cpu_architecture():
    arch = platform.machine()
    if "x86_64" in arch:
        return "AMD"
    elif "arm" in arch:
        return "ARM"
    else:
        return None
