import os
from setuptools import setup, find_packages


def get_requirements(fns, envsub: bool = False):
    reg = r'\$(\w+)'
    reqs = []
    for fn in fns:
        if not os.path.exists(fn):
            raise FileNotFoundError(f'Given file {fn} does not exists.')
        with open(fn, 'r') as f:
            for line in f.readlines():
                s = line.strip()
                if s.startswith('#'):
                    continue
                if envsub:
                    for k in re.findall(reg, line):
                        v = os.environ.get(k)
                        if v is None:
                            warnings.warn(
                                f'Environment variable "{k}" is required by "{s}"'
                                f'but not given. Skip'
                            )
                            break
                        s = s.replace('$'+k, v)
                    else:
                        reqs.append(s)
                else:
                    reqs.append(s)
    return reqs


setup(
    name='mycalc',
    description='Add numbers',
    version_config={
        'template': '{tag}',
        'dev_template': '{tag}.post{ccount}',
        'dirty_template': '{tag}.post{ccount}+dirty',
    },
    setup_requires=['setuptools-git-versioning'],
    install_requires=get_requirements(['requirements.txt']),
    packages=find_packages(exclude=['test', 'test.*']),
)
