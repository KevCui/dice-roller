Dice Roller
===========

Roll... Roll... Roll...

## Usage

```
Usage:
  ./roll.sh [n]d[s]

Options:
  n      number of dice(s)
  s      dice side
```

## Examples:
- Roll 3d20:

```bash
$ ./roll.sh 3d20
3d20:	6	13	15
---
Total: 34
```

- Roll 1d2:

```bash
$ ./roll.sh d2
1d2:	2
---
Total: 2
```

- Roll 5d2, 4d8 and 1d20:

```bash
$ ./roll.sh 5d2 4d8 d20
5d2:	1	2	1	2	1
4d8:	7	3	1	7
1d20:	9
---
Total: 34
```
