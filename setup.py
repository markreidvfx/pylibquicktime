from distutils.core import setup
from distutils.extension import Extension
from Cython.Build import cythonize

import shlex
import subprocess
import sys

def pkg_config(name):
    """Get distutils compatible extension extras via pkg-config."""

    proc = subprocess.Popen(['pkg-config', '--cflags', '--libs', name], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    raw_config, err = proc.communicate()
    if proc.wait():
        return

    config = {}
    for chunk in raw_config.strip().split():
        if chunk.startswith('-I'):
            config.setdefault('include_dirs', []).append(chunk[2:])
        elif chunk.startswith('-L'):
            config.setdefault('library_dirs', []).append(chunk[2:])
        elif chunk.startswith('-l'):
            config.setdefault('libraries', []).append(chunk[2:])
        elif chunk.startswith('-D'):
            name = chunk[2:].split('=')[0]
            config.setdefault('define_macros', []).append((name, None))

    return config



config = pkg_config("libquicktime")
extensions= [Extension('libquicktime',
                       ["libquicktime/libquicktime.pyx"],
                        **config)]

setup(
    name="libquicktime",
    version="0.0.1",
    description="Pythonic Bindings to libquicktime API written in Cython",
    url='https://github.com/markreidvfx/pylibquicktime',
    
    author='Mark Reid',
    author_email='mindmark@gmail.com',
    
    ext_modules = cythonize(extensions, 
                            include_path=['libquicktime', 'include'], 
                            ),

)

