import time
from argparse import ArgumentParser
import mycalc


def main():
    parser = ArgumentParser('mycalc')
    parser.add_argument('-r', '--readme', action='store_true')
    parser.add_argument('-n', '--no-block', action='store_true')
    parser.add_argument('numbers', type=float, nargs='*')

    args = parser.parse_args()
    if args.readme:
        print(mycalc.utils.get_readme())
        return 

    if len(args.numbers) == 0:
        try:
            numbers = input('Input numbers (separate by while space):\n')
        except KeyboardInterrupt:
            print('Bye')
            return
        numbers = [x for x in numbers.split() if x != '']
        print('result = ', end='')
    else:
        numbers = args.numbers

    print(mycalc.utils.add_all(*numbers))

    if not args.no_block:
        print('press Ctl-c to quit')
        try:
            while True:
                time.sleep(1)
        except KeyboardInterrupt:
            pass
        print('Bye')


if __name__ == '__main__':
    main()
