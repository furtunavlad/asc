# Game of Life in Assembly

This repository contains an implementation of Conway's Game of Life in x86 AT&T Assembly, written by me as a project for "Computer Systems Architecture" University course.

## Description

Conway's Game of Life is a cellular automaton devised by the mathematician John Conway. The game is a zero-player game, meaning that its evolution is determined by its initial state, with no further input. The game's rules are simple yet can generate complex and interesting patterns.

The implementation in this repository is written in x86 Assembly language. It includes features for inputting the initial state, evolving the grid through a specified number of generations, and displaying the final grid.

## Features

- Input the number of rows, columns, live cells, and the number of generations.
- Input the positions of live cells.
- Evolve the grid through the specified number of generations.
- Display the final grid after evolution.

## Usage

1. Clone the repository:

```bash
git clone https://github.com/furtunavlad/assembly-game-of-life.git
cd assembly-game-of-life
```
2. Assemble and run the program:
```bash
  as --32 conway.asm -o conway.o
  gcc -m32 conway.o -o conway -no-pie
  ./conway
```
## Example

Here is an example input and output: <br>
<br>
Enter the number of rows: 5 <br>
Enter the number of columns: 5 <br>
Enter the number of live cells: 4 <br>
Enter the positions of live cells: <br>
1 1<br>
2 2<br>
2 3<br>
3 2<br>
Enter the number of generations: 3<br>

Initial grid:<br>
0 0 0 0 0<br>
0 1 0 0 0<br>
0 0 1 1 0<br>
0 1 1 0 0<br>
0 0 0 0 0<br>

Generation 1:<br>
0 0 0 0 0<br>
0 1 1 0 0<br>
0 0 1 1 0<br>
0 1 0 0 0<br>
0 0 0 0 0<br>

Generation 2:<br>
0 0 0 0 0<br>
0 0 1 1 0<br>
0 1 0 1 0<br>
0 1 1 0 0<br>
0 0 0 0 0<br>

Generation 3:<br>
0 0 0 0 0<br>
0 1 1 0 0<br>
0 1 1 1 0<br>
0 1 1 0 0<br>
0 0 0 0 0<br>
