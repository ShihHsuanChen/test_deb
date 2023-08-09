import os


def get_readme():
    fname = os.path.join(os.path.dirname(__file__), 'static', 'README.md')
    with open(fname, 'r') as fp:
        s = fp.read()
    return s


def add_all(*args):
    s = 0
    for x in args:
        try:
            x = float(x)
        except:
            continue
        else:
            s += x
    return s
