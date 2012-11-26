strandbeest
===========

Dutch artist/engineer Theo Jansen came up with this really cool walking machine (he calls it a strandbeest) that takes rotary input (a regular motor) and translates it to a walking motion. It's made of about 11 rods connected at joints that rotate in a single plane. The tricky part is figuring out what lengths to make each of the 11 rods so that we actually get a walking motion and not some other weird path traced out by the machine's "foot." So.. I wrote this Matlab code to first _solve_ the joint positions for all joints given the motor's position and joint lengths.

You can play around with that solver in the first half of `test.m`.

Changing the lengths of the rods drastically changes the "output" (i.e. the path of the foot through one cycle). The script `optimize.m` is my first ever attempt at doing genetic algorithms - it generates 100 machines with random length rods, simulates them, and the _scores_ them based on the trajectory of the joints.

The bottom few lines of of `optimize.m` plot the worst- and best-score of each generation. The good news is that the scores get better over the generations. The bad news is that the resulting machine is really ugly and clearly not fit for actually walking.

So _after_ doing all of this, I discovered that [Jansen's website](http://www.strandbeest.com/beests_leg.php) includes a description of how he came up with the lengths that he did. He took the same exact approach - the problem is too high-dimensional to be done analytically, so we need to evolve the best solution (i.e. genetic algorithms). He also includes the ideal ratio of the limbs.

So.. can I at least reproduce his results? Or do better?

Ultimately I want to produce little desktop size strandbeests - maybe 3D print them. Turns out Jansen already did that too. Oh, well..

Todo
---

* Come up with a better fitness function.
    * Jansen suggests that the more _triangular_ the foot's path, the better. Flat motion on the ground and picking the foot up high are both pluses. How to measure _triangleness_?
    * Also need to consider torque of actually driving it.. Give a worse score if ever trying to push on a joint close to 180º or pull close to 0º. 90ºish is ideal.
* speed up simulation
    * can anything be parallelized?
    * putting this on git and running it remotely (thayer school computing cluster) help a bit, at least to reduce strain on my dinky laptop