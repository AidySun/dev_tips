# Math

1. [vector](#vector)
   1. [calculating](#calculating)
   2. [magnitude](#magnitude)
   3. [normalization](#normalization)
   4. [dot](#dot)
   5. [Real application](#real-application)
   6. [reflection](#reflection)
2. [Common](#common)
   1. [Radians to Degrees](#radians-to-degrees)


## vector

- A vector has a `direction` and a `magnitude`

- references
  - [What is the need for normalizing a vector?](https://stackoverflow.com/questions/10002918/what-is-the-need-for-normalizing-a-vector)
  - [Vector magnitude & normalization](https://www.khanacademy.org/computing/computer-programming/programming-natural-simulations/programming-vectors/a/vector-magnitude-normalization)


### calculating

- `A + B = B + A` a parallelogram.

- pointing from postion A to position B: `var AB = B - A` (note the order) is the vector goes from A to B.

- **multiplication and division with scalar**, are means by which the length of the vector can be changed without affecting direction. e.g.:

  ```math
  v = \{10, 6\} \\
  v * 2 == \{20, 12\}\\
  v / 2 == \{5, 3\}
  ```

### magnitude

- **length of a vector**. e.g. `v = {3, 4}`, length of the vector is `5`. It's calculated with following equation because it's a **right trangle**

  ```math
  |v| = sqrt(a*a + b*b) \\
  a^2 + b^2 = c^2
  ```

### normalization

- **take a vector and reducing its magnitude to 1 (by dividing its magnitude) without changing its direction is called normalization.**

```math
v = \{3, 4\} \\
|v| = sqrt(3*3 + 4*4) = 5\\
v / |v| = \{3, 4\} / sqrt(3*3+4*4) = \{3/5, 4/5\}
```

>️️⚠️Note: `vector(0,0)` CANNOT be normalized.

### dot


### Real application

position `vector`
:   location

velocity `vector`
:   measures the change in position in unit time. Which means how far to move

acceleration `vector`
:   

force
:   

### reflection


## Common

### Radians to Degrees

- `1 pi radians = 180 degrees`
  - `1 radians = 180/pi degrees = 57.295 degress`



