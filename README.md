![50-1](https://github.com/user-attachments/assets/315bdea8-3790-4bf8-bc5b-184cddcba008)# travelling-salesman-problem

For more datasets, you can visit http://comopt.ifi.uni-heidelberg.de/software/TSPLIB95/tsp/

The traveling salesman problem is a classic optimization problem. The background of the traveling salesman problem is to seek the shortest possible route for a salesman to visit each city exactly once and return to the origin city. The
distance, time, and cost in actual travel are abstracted as "distance". In the symmetric traveling salesman problem, the round-trip distance between two cities is equal. When the number of cities is small, traditional algorithms such as
linear programming, dynamic programming, and greedy algorithms can obtain an exact optimal solution. However, as the number of cities increases, the time required for traditional algorithms to reach the optimal solution increases
dramatically and cannot be solved in polynomial time, which is NP-hard.

This algorithm is a new heuristic algorithm inspired by indoor sound field modeling. In life, we have the experience of watching movies, listening to indoor music or indoor speeches. Affected by the indoor furnishings, decoration style, and
air quality, the auditory experience in different positions varies greatly. In theory, acoustic engineers can use the sound field modeling method to find the best position for auditory experience. The process of sound propagation throughout
the house is used to realize global search, and the reflection and refraction of sound are introduced to achieve randomness to avoid the result falling into the local optimal solution. The algorithm iteration is realized according to the
volume of the space, and the parameter of volume tolerance is introduced to realize algorithm truncation. Experimental results on benchmark datasets demonstrate that our method outperforms traditional heuristic approaches in terms of
solution quality and convergence speed. The proposed method offers a promising alternative for solving large-scale TSPs and other combinatorial optimization problems.

To test different data sets, just change the file name in line10: filename = 'att48.tsp';

Main results
![Uplo![Uploading 50-2.svg…]()ading 50-1.svg…]()

