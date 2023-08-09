from argparse import ArgumentParser
import mycalc


def main():
    parser = ArgumentParser('mycalc')
    parser.add_argument('-r', '--readme', action='store_true')
    parser.add_argument('-n', '--numbers', type=float, nargs='+')

    args = parser.parse_args()
    if args.readme:
        print(mycalc.utils.get_readme())
        return 
    if args.numbers is None:
        return
    print(mycalc.utils.add_all(*args.numbers))


if __name__ == '__main__':
    main()
