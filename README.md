# Connected-graph-constraint
Code, figures and data for the paper:

> [A Connectedness Constraint for Learning Sparse Graphs][arxiv] \
by [Martin Sundin][masundi], [Arun Venkitaraman][arunv], [Magnus Jansson][mjansson] and [Saikat Chatterjee][saikat].

The paper was presented at the 2017 European Signal Processing Conference ([EUSIPCO2017][eusipco]) and is also available through [arxiv.org][arxiv].

Please report any bugs or errors to <sundin83martin@gmail.com>.


<figure>
<img src="figures/sweden_map_withconstraint.png" height=400></img>
<br>
<caption>Nearest neighbours reconstructed from temperature time series with the graph connectedness constraint.</caption>
</figure>

## Summary
An undirected graph with N nodes can be represented by an N x N real and symmetric adjacency matrix **A**. In many problems the adjacency matrix is not known but needs to be reconstructed. At the same time it is often desired that the reconstructed matrix is sparse. This typically leads to optimization problems of the form

minimize g(**A**) + eta * s(**A**), subject to constraints

where g(**A**) is the objective function we want to minimize to reconstruct the graph, s(**A**) is a sparsifying penalty function and eta > 0 is a regularization parameter.

___
### Example

In the **sparse consensus problem** we want to find a matrix **A** that makes the distributed consensus rule

x_i(t+1) = sum_j A_ij * x_j(t)

converges as fast as possible, where A_ij = 0 if node i and j does not share an edge. The optimization problem is then

minimize sigma_1(**A** - 1/n **11^T**) + eta * tr(**I** - **A**),

subject to **A1 = 1**, **A >= 0**, **A^T = A**.

In the problem sigma_1(..) denotes the largest singular value of a matrix, **1** is the N-dimensional vector with one in each component, **I** denotes the N times N identity matrix and tr(..) denotes the matrix trace.

___

One difficulty is that for large values of eta, the graph often becomes disconnected. One example shown in the paper is the following.

___
### Theorem

In the sparse consensus problem, the graph splits into at least *k* parts when

eta > 1- (N - k + 1).
___

The theorem extends the result from [G. Gnecco, R. Morisi, and A. Bemporad, 2014].

In the paper we discuss how connectedness can be enforced as a contraint.

The convex optimization problems in the paper were solved using the [cvx][cvx] toolbox for Matlab.

## License and referencing
This source code is licensed under the [MIT][mit] license. If you in any way use this code for research that results in publications, please cite our original article. The following [Bibtex][bibtex] entry can be used.

```
@inproceedings{sundin2017connectedness,
  title={A connectedness constraint for learning sparse graphs},
  author={Sundin, Martin and Venkitaraman, Arun and Jansson, Magnus and Chatterjee, Saikat},
  booktitle={Signal Processing Conference (EUSIPCO), 2017 25th European},
  pages={151--155},
  year={2017},
  organization={IEEE}
}
```

[masundi]: https://www.kth.se/profile/masundi/
[saikat]: https://www.kth.se/profile/sach/
[mjansson]: https://www.kth.se/profile/janssonm/
[arunv]: https://www.kth.se/profile/arunv
[arxiv]: https://arxiv.org/abs/1708.09021
[mit]: http://choosealicense.com/licenses/mit
[bibtex]: http://www.bibtex.org/
[cvx]: http://cvxr.com/cvx/
[eusipco]: https://www.eusipco2017.org/