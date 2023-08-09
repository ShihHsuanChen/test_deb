try:
    from importlib.metadata import version
except (ImportError, ModuleNotFoundError):
    from importlib_metadata import version
try:
    __version__ = version(__name__)
except:
    __version__ = ''

from . import utils
